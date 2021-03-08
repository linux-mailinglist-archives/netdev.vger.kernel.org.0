Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96D333135E
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhCHQ14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31563 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhCHQ1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:27:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615220850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SssBAwjVIlVsmWMO7PiZrFKkubwCKH4nIDdW9qq+hs0=;
        b=g3LKjHRlxFIR4JmGqHSh+G56vBddEDMyCI73PxL32v6GU4Mg69sqdoePuWR+oISOBcXPOe
        lqZ6VcbgW/lXX8DHx8dBivh1yt5/sRnXvy7LkRxT7ZxEXFu7Yp+RKWjjnA3bv/NlpNZ3tU
        6kkbFQFi/Lnc4P4iRZ7S5/hTIz2pVAI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-stQCLjH9NYqiHO2iz4QXVA-1; Mon, 08 Mar 2021 11:27:28 -0500
X-MC-Unique: stQCLjH9NYqiHO2iz4QXVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B1D3DF8B2;
        Mon,  8 Mar 2021 16:26:51 +0000 (UTC)
Received: from bnemeth.users.ipa.redhat.com (ovpn-112-139.ams2.redhat.com [10.36.112.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 746C760C04;
        Mon,  8 Mar 2021 16:26:49 +0000 (UTC)
Message-ID: <543ebc518aa31f04bb6a85b66f37d984ede4b031.camel@redhat.com>
Subject: Re: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment
 when mpls_hlen == 0
From:   Balazs Nemeth <bnemeth@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Date:   Mon, 08 Mar 2021 17:26:48 +0100
In-Reply-To: <718e4f13-31a8-037c-9725-08ae3cd93ccd@gmail.com>
References: <cover.1615199056.git.bnemeth@redhat.com>
         <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
         <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
         <718e4f13-31a8-037c-9725-08ae3cd93ccd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-08 at 09:17 -0700, David Ahern wrote:
> On 3/8/21 9:07 AM, Willem de Bruijn wrote:
> > > diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
> > > index b1690149b6fa..cc1b6457fc93 100644
> > > --- a/net/mpls/mpls_gso.c
> > > +++ b/net/mpls/mpls_gso.c
> > > @@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct
> > > sk_buff *skb,
> > > 
> > >         skb_reset_network_header(skb);
> > >         mpls_hlen = skb_inner_network_header(skb) -
> > > skb_network_header(skb);
> > > -       if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
> > > +       if (unlikely(!mpls_hlen || !pskb_may_pull(skb,
> > > mpls_hlen)))
> > >                 goto out;
> > 
> > Good cathc. Besides length zero, this can be more strict: a label
> > is
> > 4B, so mpls_hlen needs to be >= 4B.
> > 
> > Perhaps even aligned to 4B, too, but not if there may be other
> > encap on top.
> > 
> > Unfortunately there is no struct or type definition that we can use
> > a
> > sizeof instead of open coding the raw constant.
> > 
> 
> MPLS_HLEN can be used here.
> 

What about sizeof(struct mpls_label), like in net/ipv4/tunnel4.c?

