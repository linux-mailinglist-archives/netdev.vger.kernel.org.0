Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C368690FF7
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjBISKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBISKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:10:09 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C814E677B9
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 10:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675966208; x=1707502208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dS8brvACs500hE38fpSS/QqAquXvMO0LA/ygNlUQR4g=;
  b=IhR4hZCznTINUVHi4dizTM044O+GkEAN/Gj+FSELw54FdHt63g+p9cpv
   xbp7rKpMxwQXxcaIYw1g/z8vAbzUMgVZihzmWkCwC5w2cm7kpHQ9EDvnG
   seAr7xFqtsW9hZzhsBFPKFyxQbNd/CIyPEhDgNXAGLGr8AcW+7yXftLRo
   M=;
X-IronPort-AV: E=Sophos;i="5.97,284,1669075200"; 
   d="scan'208";a="309354326"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 18:09:57 +0000
Received: from EX13MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id 0C8D1822C7;
        Thu,  9 Feb 2023 18:09:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Thu, 9 Feb 2023 18:09:56 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.162.56) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Thu, 9 Feb 2023 18:09:53 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <acme@mandriva.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <tulup@mail.ru>
Subject: Re: [PATCH v2 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.> On Thu, Feb 9, 2023 at 2:34 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
Date:   Thu, 9 Feb 2023 10:09:44 -0800
Message-ID: <20230209180944.55957-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iJ2SpzuL9wyCeDjadogiUfk2C1niJD3RG7tJHA+T1aiJA@mail.gmail.com>
References: <CANn89iJ2SpzuL9wyCeDjadogiUfk2C1niJD3RG7tJHA+T1aiJA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.56]
X-ClientProxiedBy: EX13D42UWB004.ant.amazon.com (10.43.161.99) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 Feb 2023 12:20:04 +0100
> >
> > Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
> > for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
> > resulting in a negative sk_forward_alloc.
> >
> > Note that in (dccp|tcp)_v6_do_rcv(), we call sk_rmem_schedule()
> > just after skb_clone() instead of after ipv6_opt_accepted().  This is
> > because tcp_send_synack() can make sk_forward_alloc negative before
> > ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.
> >
> > [0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/
> >
> > Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
> > Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> 
> Thanks, but I suggest we add a helper to avoid the duplication...

This is much cleaner, thank you!

> 
> Something like this (this can also be made out-of-line, because this
> is not fast path)
> 
> Name is probably not well chosen...

or skb_clone_and_charge(skb, sk), skb_clone_and_charge_r(skb, sk), or
skb_clone_and_set_owner_r(skb, sk) ?


> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b23006051d651630bdd966741cbb01..f5a97aed14345c403b25339fcb86d99bc51233a7
> 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2977,4 +2977,19 @@ static inline bool sk_is_readable(struct sock *sk)
>                 return sk->sk_prot->sock_is_readable(sk);
>         return false;
>  }
> +
> +static inline struct sk_buff *
> +sk_clone_and_charge_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +       skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
> +       if (skb) {
> +               if (sk_rmem_schedule(sk, skb, skb->truesize)) {
> +                       skb_set_owner_r(skb, sk);
> +                       return skb;
> +               }
> +               __kfree_skb(skb);
> +       }
> +       return NULL;
> +}
> +
>  #endif /* _SOCK_H */
