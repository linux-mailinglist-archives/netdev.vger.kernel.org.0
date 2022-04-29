Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4711651509C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378977AbiD2QVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378564AbiD2QVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 12:21:34 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B984D8910
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 09:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1651249096; x=1682785096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RJRrU7qQ5fgoTgBrlHAKGPCL4u0ZnrFtOq5RGqVJDeg=;
  b=JRiQXFssCVPm/LkpYGNdj8eM5J1KwkhKCevuB+GSnmdAc2mXULMAl6IL
   oGVxaYxHfM9YWus48dsQy6cBZUi44lfsP0aIWckWJe7o/KycxRWkKWBPM
   H2rH0qZecESmwEhVpKY4CWFpkp2/WISDglZJZLT/J+StaVjNsClpgUxwd
   E=;
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 29 Apr 2022 09:18:15 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 09:18:14 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 29 Apr 2022 09:18:14 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 29 Apr
 2022 09:18:13 -0700
Date:   Fri, 29 Apr 2022 12:18:10 -0400
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
Message-ID: <20220429161810.GA175@qian>
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220422201237.416238-1-eric.dumazet@gmail.com>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 01:12:37PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Logic added in commit f35f821935d8 ("tcp: defer skb freeing after socket
> lock is released") helped bulk TCP flows to move the cost of skbs
> frees outside of critical section where socket lock was held.
> 
> But for RPC traffic, or hosts with RFS enabled, the solution is far from
> being ideal.
> 
> For RPC traffic, recvmsg() has to return to user space right after
> skb payload has been consumed, meaning that BH handler has no chance
> to pick the skb before recvmsg() thread. This issue is more visible
> with BIG TCP, as more RPC fit one skb.
> 
> For RFS, even if BH handler picks the skbs, they are still picked
> from the cpu on which user thread is running.
> 
> Ideally, it is better to free the skbs (and associated page frags)
> on the cpu that originally allocated them.
> 
> This patch removes the per socket anchor (sk->defer_list) and
> instead uses a per-cpu list, which will hold more skbs per round.
> 
> This new per-cpu list is drained at the end of net_action_rx(),
> after incoming packets have been processed, to lower latencies.
> 
> In normal conditions, skbs are added to the per-cpu list with
> no further action. In the (unlikely) cases where the cpu does not
> run net_action_rx() handler fast enough, we use an IPI to raise
> NET_RX_SOFTIRQ on the remote cpu.
> 
> Also, we do not bother draining the per-cpu list from dev_cpu_dead()
> This is because skbs in this list have no requirement on how fast
> they should be freed.
> 
> Note that we can add in the future a small per-cpu cache
> if we see any contention on sd->defer_lock.

Hmm, we started to see some memory leak reports from kmemleak that have
been around for hours without being freed since yesterday's linux-next
tree which included this commit. Any thoughts?

unreferenced object 0xffff400610f55cc0 (size 216):
  comm "git-remote-http", pid 781180, jiffies 4314091475 (age 4323.740s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 7e 87 ff 3f ff ff 00 00 00 00 00 00 00 00  ..~..?..........
  backtrace:
     kmem_cache_alloc_node
     __alloc_skb
     __tcp_send_ack.part.0
     tcp_send_ack
     tcp_cleanup_rbuf
     tcp_recvmsg_locked
     tcp_recvmsg
     inet_recvmsg
     __sys_recvfrom
     __arm64_sys_recvfrom
     invoke_syscall
     el0_svc_common.constprop.0
     do_el0_svc
     el0_svc
     el0t_64_sync_handler
     el0t_64_sync
unreferenced object 0xffff4001e58f0c40 (size 216):
  comm "git-remote-http", pid 781180, jiffies 4314091483 (age 4323.968s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 c0 7e 87 ff 3f ff ff 00 00 00 00 00 00 00 00  ..~..?..........
  backtrace:
     kmem_cache_alloc_node
     __alloc_skb
     __tcp_send_ack.part.0
     tcp_send_ack
     tcp_cleanup_rbuf
     tcp_recvmsg_locked
     tcp_recvmsg
     inet_recvmsg
     __sys_recvfrom
     __arm64_sys_recvfrom
     invoke_syscall
     el0_svc_common.constprop.0
     do_el0_svc
     el0_svc
     el0t_64_sync_handler
     el0t_64_sync
