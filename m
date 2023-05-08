Return-Path: <netdev+bounces-904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 346976FB4EE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:21:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72971280FFB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930CF5243;
	Mon,  8 May 2023 16:21:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E44407
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:21:45 +0000 (UTC)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7CCC7
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683562904; x=1715098904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k1z4OOx74l3aCJN8ArjLZbxEQspCM03d5mmKJsJBmM4=;
  b=Dz3Xsakt2ErGvxyGQWUd0ufdC3po91DbywWBs5jv7sH0Kl2xxA/PqHjF
   9JC6jt+B55plHvSN6DvLImjazBOwhaoaCZFYxkz5kdOEFWLrtg3e6woco
   1escP36VfGsLjeG6PRYv3cq+meCkZb7+Nmt0WONfFxdwQb/k/ei19Jg6M
   s=;
X-IronPort-AV: E=Sophos;i="5.99,259,1677542400"; 
   d="scan'208";a="329372252"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 16:21:38 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
	by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id EE73680E12;
	Mon,  8 May 2023 16:21:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 16:21:36 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.41) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 8 May 2023 16:21:34 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <leon@kernel.org>
CC: <netdev@vger.kernel.org>, <patryk.sondej@gmail.com>
Subject: Re: [PATCH net] inet_diag: fix inet_diag_msg_attrs_fill() for net_cls cgroup
Date: Mon, 8 May 2023 09:21:26 -0700
Message-ID: <20230508162126.39146-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230508061749.GC6195@unreal>
References: <20230508061749.GC6195@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.41]
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 8 May 2023 09:17:49 +0300
> On Mon, May 08, 2023 at 05:32:33AM +0200, Patryk Sondej wrote:
> > This commit fixes inet_diag_msg_attrs_fill() function in the ipv4/inet_diag.c file.
> > The problem was that the function was using CONFIG_SOCK_CGROUP_DATA to check for the net_cls cgroup.
> > However, the net_cls cgroup is defined by CONFIG_CGROUP_NET_CLASSID instead.
> > 
> > Therefore, this commit updates the #ifdef statement to CONFIG_CGROUP_NET_CLASSID,
> > and uses the sock_cgroup_classid() function to retrieve the classid from the socket cgroup.
> > 
> > This change ensures that the function correctly retrieves the classid for the net_cls cgroup
> > and fixes any issues related to the use of the function in this context.
> > 
> 
> Please add Fixes line here.
> 
> > Signed-off-by: Patryk Sondej <patryk.sondej@gmail.com>
> > ---
> >  net/ipv4/inet_diag.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> > index b812eb36f0e3..7017f88911a6 100644
> > --- a/net/ipv4/inet_diag.c
> > +++ b/net/ipv4/inet_diag.c
> > @@ -157,7 +157,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
> >  	    ext & (1 << (INET_DIAG_TCLASS - 1))) {
> >  		u32 classid = 0;
> >  
> > -#ifdef CONFIG_SOCK_CGROUP_DATA
> > +#ifdef CONFIG_CGROUP_NET_CLASSID
> 
> This ifdef should be deleted as sock_cgroup_classid() already has right ifdef.

sock_cgroup_classid() is defined under #ifdef CONFIG_SOCK_CGROUP_DATA,
so removing this guard will cause an error at compile time if we
disable CONFIG_SOCK_CGROUP_DATA.

I think we can keep the old #ifdef as is for consistensy with
another CONFIG_SOCK_CGROUP_DATA use just below for sock_cgroup_ptr()
in inet_diag_msg_attrs_fill().

If we enable CONFIG_SOCK_CGROUP_DATA without CONFIG_CGROUP_NET_CLASSID,
I guess gcc will optimize it and remove the zero assignment.


> 
>   809 static inline u32 sock_cgroup_classid(const struct sock_cgroup_data *skcd)
>   810 {
>   811 #ifdef CONFIG_CGROUP_NET_CLASSID
>   812         return READ_ONCE(skcd->classid);
>   813 #else
>   814         return 0;
>   815 #endif
>   816 }
>   817
> 
> 
> >  		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
> >  #endif
> >  		/* Fallback to socket priority if class id isn't set.
> > -- 
> > 2.37.1 (Apple Git-137.1)

