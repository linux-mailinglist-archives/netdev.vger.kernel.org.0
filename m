Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53F696DC3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjBNTXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:23:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjBNTXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:23:32 -0500
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0221C3029D
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676402593; x=1707938593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8sgN5jkxVIT3NbVMr5ZQXlQvRJnL7JvRLcC6za9VtcQ=;
  b=LqWQ+KqwtgUakRSKy64FxjmNHCcyDT946TxIWjUJ+xWXH6TVIAW4myCb
   vT+780veoQB5flsi/4C3L6N/kSVNoCvt72Cgqb3zySCiMLN0gFcw5Yt8b
   F2udnHVCHoxyPDOO4jYiFJVRh9yDRHW6Q27pJTZfvghErVVtiye8oGzOp
   Y=;
X-IronPort-AV: E=Sophos;i="5.97,297,1669075200"; 
   d="scan'208";a="292829835"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 19:23:09 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id A1B4D82294;
        Tue, 14 Feb 2023 19:23:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 14 Feb 2023 19:23:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Tue, 14 Feb 2023 19:23:05 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <fhofmann@cloudflare.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <fred@cloudflare.com>, <kernel-team@cloudflare.com>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yoshfuji@linux-ipv6.org>, <kuniyu@amazon.com>
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
Date:   Tue, 14 Feb 2023 11:22:57 -0800
Message-ID: <20230214192257.47149-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
References: <CABEBQimj8Jk659Xb+gNgW_dVub+euLwM6XGrPvkrPaEb=9GH+A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Tue, 14 Feb 2023 17:14:24 +0000
> Hi Eric,
> 
> On Mon, Jan 23, 2023 at 3:49 PM 'Eric Dumazet' via
> kernel-team+notifications <kernel-team@cloudflare.com> wrote:
> >
> > > On 1/18/23 11:07 AM, Eric Dumazet wrote:
> > [ ... ]
> > > > Thanks for the report
> > > >
> > > > I guess this part has been missed in commit 0a375c822497ed6a
> > > >
> > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> > > > 100644
> > > > --- a/net/ipv4/tcp_output.c
> > > > +++ b/net/ipv4/tcp_output.c
> > > > @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> > > > sock *sk, struct dst_entry *dst,
> [ ... ]
> 
> we're still seeing this with a preempt-enabled kernel, in
> tcp_check_req() though, like:
> 
> BUG: using __this_cpu_add() in preemptible [00000000] code: nginx-ssl/186233
> caller is tcp_check_req+0x49a/0x660
> CPU: 58 PID: 186233 Comm: nginx-ssl Kdump: loaded Tainted: G
> O       6.1.8-cloudflare-2023.1.16 #1
> Hardware name: ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x34/0x48
>  check_preemption_disabled+0xdd/0xe0
>  tcp_check_req+0x49a/0x660
>  tcp_rcv_state_process+0xa3/0x1020
>  ? tcp_sendmsg_locked+0x2a4/0xc50
>  tcp_v4_do_rcv+0xc6/0x280
>  __release_sock+0xb4/0xc0
>  release_sock+0x2b/0x90
>  tcp_sendmsg+0x33/0x40
>  sock_sendmsg+0x5b/0x70
>  sock_write_iter+0x97/0x100
>  vfs_write+0x330/0x3d0
>  ksys_write+0xab/0xe0
>  ? syscall_trace_enter.constprop.0+0x164/0x170
>  do_syscall_64+0x3b/0x90
>  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
> 
> There's a notable number of "__"-marked stats updates in
> tcp_check_req(); I can't claim to understand the code well enough if
> all would have to be changed.
> The occurence is infrequent (we see about two a week).

How about converting __SNMP_XXX() only if the kernel is preemptible
like this ?  Then we can keep the optimised code for other config.

untested & incomplete patch:

---8<---
diff --git a/include/net/snmp.h b/include/net/snmp.h
index 468a67836e2f..6ead61d9deb3 100644
--- a/include/net/snmp.h
+++ b/include/net/snmp.h
@@ -124,9 +124,13 @@ struct linux_tls_mib {
 #define DECLARE_SNMP_STAT(type, name)	\
 	extern __typeof__(type) __percpu *name
 
+#ifdef CONFIG_PREEMPT
+#define __SNMP_INC_STATS(mib, field)	\
+			this_cpu_inc(mib->mibs[field])
+#else
 #define __SNMP_INC_STATS(mib, field)	\
 			__this_cpu_inc(mib->mibs[field])
-
+#endif
 #define SNMP_INC_STATS_ATOMIC_LONG(mib, field)	\
 			atomic_long_inc(&mib->mibs[field])
 
---8<---

