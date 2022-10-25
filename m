Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90D7460D350
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiJYSP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbiJYSP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:15:57 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B119D38DE
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666721758; x=1698257758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a1PHb5BZONpCN021csllVja0N2+Im92x+SUe2FCNfRk=;
  b=J/Ja350wp1QJ+qEJwdmkp34Mrjl7rT23bbsxG3SvyXEo6l5fBiXLFZ07
   /G3XgduDIwM8RhXg+JEnhTr2vsfdjp7fnwz5YwwznwGLvDDkQ0k9AyN19
   wETT7yvlUhOQegN5mJsMb9b7cvy5lbTFi3ZrX2vmapa+CigHpbOsGxSgS
   I=;
X-IronPort-AV: E=Sophos;i="5.95,212,1661817600"; 
   d="scan'208";a="273469147"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 18:15:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id 1420181B52;
        Tue, 25 Oct 2022 18:15:47 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 25 Oct 2022 18:15:41 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.178) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Tue, 25 Oct 2022 18:15:39 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <mathew.j.martineau@linux.intel.com>,
        <matthieu.baerts@tessares.net>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] mptcp: fix tracking issue in mptcp_subflow_create_socket()
Date:   Tue, 25 Oct 2022 11:15:26 -0700
Message-ID: <20221025181526.80400-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221025180546.652251-1-edumazet@google.com>
References: <20221025180546.652251-1-edumazet@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.178]
X-ClientProxiedBy: EX13D12UWC003.ant.amazon.com (10.43.162.12) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Oct 2022 18:05:46 +0000
> My recent patch missed that mptcp_subflow_create_socket()
> was creating a 'kernel' socket, then converted it to 'user' socket.
> 
> Fixes: 0cafd77dcd03 ("net: add a refcount tracker for kernel sockets")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

I missed that, thanks for the fix!


> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  net/mptcp/subflow.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 07dd23d0fe04ac37f4cc66c0c21d4d41f50fb3f4..120f792fda9764271f020771b36d27c6e44d8618 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1595,7 +1595,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
>  
>  	/* kernel sockets do not by default acquire net ref, but TCP timer
>  	 * needs it.
> +	 * Update ns_tracker to current stack trace and refcounted tracker.
>  	 */
> +	__netns_tracker_free(net, &sf->sk->ns_tracker, false);
>  	sf->sk->sk_net_refcnt = 1;
>  	get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
>  	sock_inuse_add(net, 1);
> -- 
> 2.38.0.135.g90850a2211-goog
