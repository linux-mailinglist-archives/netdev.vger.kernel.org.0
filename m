Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19E7604BCD
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiJSPjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:39:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbiJSPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:39:10 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E23418B48C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 08:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666193737; x=1697729737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D3yKd9UNHKi+g+UkzbUEW5vBMya1NlvJMwjke/PB7QA=;
  b=vHX/RvjubIlX7pbxkSDgWhUj9HPV+ocNmNw8nJ/ao2J1kxA7Dgr2J9NK
   FgBhWZq1GXhxNag2eTy6GVeDAYxpnhjitSeEWRG6ovDFxKamW2htckpn0
   wsAmj0eNIOiacGxztfscQ19YaLlH6MX2MTnqnSUczzYisX7j59tgvz08G
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,196,1661817600"; 
   d="scan'208";a="234356101"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 15:34:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 9817AA2753;
        Wed, 19 Oct 2022 15:34:48 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 19 Oct 2022 15:34:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.128) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Wed, 19 Oct 2022 15:34:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <matthieu.baerts@tessares.net>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <mathew.j.martineau@linux.intel.com>, <mptcp@lists.linux.dev>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v1 net-next 1/5] inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
Date:   Wed, 19 Oct 2022 08:34:37 -0700
Message-ID: <20221019153437.67054-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <2b8c8764-052a-97b3-bf5b-8335a75c11d9@tessares.net>
References: <2b8c8764-052a-97b3-bf5b-8335a75c11d9@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.128]
X-ClientProxiedBy: EX13D48UWB001.ant.amazon.com (10.43.163.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 19 Oct 2022 15:22:40 +0200
> Hi Kuniyuki,
> 
> +cc MPTCP ML.
> 
> On 18/10/2022 21:09, Kuniyuki Iwashima wrote:
> > After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
> > in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
> > sk->sk_destruct() by setting inet6_sock_destruct() to it to make
> > sure we do not leak inet6-specific resources.
> > 
> > Now we can remove unnecessary inet6_destroy_sock() calls in
> > sk->sk_prot->destroy().
> > 
> > DCCP and SCTP have their own sk->sk_destruct() function, so we
> > change them separately in the following patches.
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> > Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> 
> Thank you for the cc!
> Please next time also cc MPTCP ML if you don't mind.

Sure!


> 
> (...)
> 
> > diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> > index f599ad44ed24..7cc9c542c768 100644
> > --- a/net/mptcp/protocol.c
> > +++ b/net/mptcp/protocol.c
> > @@ -17,9 +17,6 @@
> >  #include <net/protocol.h>
> >  #include <net/tcp.h>
> >  #include <net/tcp_states.h>
> > -#if IS_ENABLED(CONFIG_MPTCP_IPV6)
> > -#include <net/transp_v6.h>
> > -#endif
> 
> Please keep this include: it is needed to access "tcpv6_prot" (as
> reported by the kernel bot).

Will add it back in v2.

I wonder why allmodconfig couldn't catch this and noticed MPTCP
cannot be modulised.
I'll test all(yes|mod|no)config from next time :)


> 
> >  #include <net/mptcp.h>
> >  #include <net/xfrm.h>
> >  #include <asm/ioctls.h>
> > @@ -3898,12 +3895,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
> >  
> >  static struct proto mptcp_v6_prot;
> >  
> > -static void mptcp_v6_destroy(struct sock *sk)
> > -{
> > -	mptcp_destroy(sk);
> > -	inet6_destroy_sock(sk);
> > -}
> > -
> >  static struct inet_protosw mptcp_v6_protosw = {
> >  	.type		= SOCK_STREAM,
> >  	.protocol	= IPPROTO_MPTCP,
> > @@ -3919,7 +3910,6 @@ int __init mptcp_proto_v6_init(void)
> >  	mptcp_v6_prot = mptcp_prot;
> >  	strcpy(mptcp_v6_prot.name, "MPTCPv6");
> >  	mptcp_v6_prot.slab = NULL;
> > -	mptcp_v6_prot.destroy = mptcp_v6_destroy;
> >  	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
> >  
> >  	err = proto_register(&mptcp_v6_prot, 1);
> 
> I see that for MPTCP IPv6 sockets, sk->sk_destruct is now set to
> inet6_sock_destruct() which calls inet6_destroy_sock() via
> inet6_cleanup_sock().
> 
> So all good for the MPTCP part (if you re-add the include ;) ).

Thank you!


> 
> Cheers,
> Matt
> -- 
> Tessares | Belgium | Hybrid Access Solutions
> www.tessares.net
