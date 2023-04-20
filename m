Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B3E6E99D4
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDTQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDTQqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:46:42 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4822721
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682009201; x=1713545201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vr64tCtLdtnSXfg0hoEYGlTzToFn9hZ2r1HFvTdYpOM=;
  b=uoCKoQ/dIrXHoC8b6N1aLJqhJWg2Y3SEKB8MVkpLgfH4pwc2Tr0XtIz0
   gFr9CMtsbD2owpRs6mCFtNRlEYpd1BwQ21Y0s+SYYo8HnkC/UVWSD45Hx
   pIhlPTYKU0iUHKN3sjuCiBSMk8GYazv2eJcKho378EhDq3uZULP9TWmRn
   8=;
X-IronPort-AV: E=Sophos;i="5.99,213,1677542400"; 
   d="scan'208";a="316364598"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 16:46:38 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-d2040ec1.us-west-2.amazon.com (Postfix) with ESMTPS id 39A3A413E5;
        Thu, 20 Apr 2023 16:46:36 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 20 Apr 2023 16:46:35 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.17) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.26;
 Thu, 20 Apr 2023 16:46:31 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <willemdebruijn.kernel@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <syzkaller@googlegroups.com>, <willemb@google.com>
Subject: Re: [PATCH v2 net] tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.
Date:   Thu, 20 Apr 2023 09:46:22 -0700
Message-ID: <20230420164622.98898-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <64413ad24900e_303b5294c8@willemb.c.googlers.com.notmuch>
References: <64413ad24900e_303b5294c8@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.17]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 20 Apr 2023 09:14:58 -0400
> > > > > Actually, the skb_clone in __skb_tstamp_tx should already release
> > > > > the reference on the ubuf.
> > > > > 
> > > > > With the same mechanism that we rely on for packet sockets, e.g.,
> > > > > in dev_queue_xmit_nit.
> > > > > 
> > > > > skb_clone calls skb_orphan_frags calls skb_copy_ubufs for zerocopy
> > > > > skbs. Which creates a copy of the data and calls skb_zcopy_clear.
> > > > > 
> > > > > The skb that gets queued onto the error queue should not have a
> > > > > reference on an ubuf: skb_zcopy(skb) should return NULL.
> > > > 
> > > > Exactly, so how about this ?
> > > > 
> > > > ---8<---
> > > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > > index 768f9d04911f..0fa0b2ac7071 100644
> > > > --- a/net/core/skbuff.c
> > > > +++ b/net/core/skbuff.c
> > > > @@ -5166,6 +5166,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
> > > >  	if (!skb)
> > > >  		return;
> > > >  
> > > > +	if (skb_zcopy(skb) && skb_copy_ubufs(skb, GFP_ATOMIC))
> > > > +		return;
> > > > +
> > > >  	if (tsonly) {
> > > >  		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
> > > >  					     SKBTX_ANY_TSTAMP;
> > > > ---8<---
> > > > 
> > > 
> > > What I meant was that given this I don't understand how a packet
> > > with ubuf references gets queued at all.
> > > 
> > > __skb_tstamp_tx does not queue orig_skb. It either allocates a new
> > > skb or calls skb = skb_clone(orig_skb).
> > > 
> > > That existing call internally calls skb_orphan_frags and
> > > skb_copy_ubufs.
> > 
> > No, skb_orphan_frags() does not call skb_copy_ubufs() here because
> > msg_zerocopy_alloc() sets SKBFL_DONT_ORPHAN for orig_skb.
> > 
> > So, we need to call skb_copy_ubufs() explicitly if skb_zcopy(skb).
> > 
> > > 
> > > So the extra test should not be needed. Indeed I would be surprised if
> > > this triggers:
> > 
> > And this actually triggers.
> 
> Oh right, I confused skb_orphan_frags and skb_orphan_frags_rx.
> 
> We need to add a call to that, the same approach used for looping in
> __netif_receive_skb_core and packet sockets in deliver_skb and
> dev_queue_xmit_nit.

I missed skb_orphan_frags_rx() defined just below skb_orphan_frags(),
which calls very what I want :)

Will post v3, thanks!

> 
> @@ -5160,6 +5160,9 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>                         skb = alloc_skb(0, GFP_ATOMIC);
>         } else {
>                 skb = skb_clone(orig_skb, GFP_ATOMIC);
> +
> +               if (skb_orphan_frags_rx(skb, GFP_ATOMIC))
> +                       return;
>         }
>         if (!skb)
>                 return;
