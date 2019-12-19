Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB3F125C7D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 09:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfLSIWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 03:22:49 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:42010 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbfLSIWt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 03:22:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CC65520533;
        Thu, 19 Dec 2019 09:22:47 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XANShWYe3Nzu; Thu, 19 Dec 2019 09:22:47 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5465D200AC;
        Thu, 19 Dec 2019 09:22:47 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Dec 2019
 09:22:46 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A030D3180373;
 Thu, 19 Dec 2019 09:22:46 +0100 (CET)
Date:   Thu, 19 Dec 2019 09:22:46 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
Message-ID: <20191219082246.GS8621@gauss3.secunet.de>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com>
 <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 11:02:39AM -0500, Willem de Bruijn wrote:
> On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> 
> > +struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > +                                netdev_features_t features,
> > +                                unsigned int offset)
> > +{
> > +       struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> > +       unsigned int tnl_hlen = skb_tnl_header_len(skb);
> > +       unsigned int delta_truesize = 0;
> > +       unsigned int delta_len = 0;
> > +       struct sk_buff *tail = NULL;
> > +       struct sk_buff *nskb;
> > +
> > +       skb_push(skb, -skb_network_offset(skb) + offset);
> > +
> > +       skb_shinfo(skb)->frag_list = NULL;
> > +
> > +       do {
> > +               nskb = list_skb;
> > +               list_skb = list_skb->next;
> > +
> > +               if (!tail)
> > +                       skb->next = nskb;
> > +               else
> > +                       tail->next = nskb;
> > +
> > +               tail = nskb;
> > +
> > +               delta_len += nskb->len;
> > +               delta_truesize += nskb->truesize;
> > +
> > +               skb_push(nskb, -skb_network_offset(nskb) + offset);
> > +
> > +               if (!secpath_exists(nskb))
> > +                       __skb_ext_copy(nskb, skb);
> 
> Of all the possible extensions, why is this only relevant to secpath?

I wrote this before we had these extensions and adjusted it
when the extensions where introduced to make it compile again.
I think we can just copy the extensions unconditionally.

> 
> More in general, this function open codes a variety of skb fields that
> carry over from skb to nskb. How did you select this subset of fields?

I tried to find the subset of __copy_skb_header() that is needed to copy.
Some fields of nskb are still valid, and some (csum related) fields
should not be copied from skb to nskb.

> 
> > +
> > +               memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
> > +
> > +               nskb->tstamp = skb->tstamp;
> > +               nskb->dev = skb->dev;
> > +               nskb->queue_mapping = skb->queue_mapping;
> > +
> > +               nskb->mac_len = skb->mac_len;
> > +               nskb->mac_header = skb->mac_header;
> > +               nskb->transport_header = skb->transport_header;
> > +               nskb->network_header = skb->network_header;
> > +               skb_dst_copy(nskb, skb);
> > +
> > +               skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> > +               skb_copy_from_linear_data_offset(skb, -tnl_hlen,
> > +                                                nskb->data - tnl_hlen,
> > +                                                offset + tnl_hlen);
> > +
> > +               if (skb_needs_linearize(nskb, features) &&
> > +                   __skb_linearize(nskb))
> > +                       goto err_linearize;
> > +
> > +       } while (list_skb);
> > +
> > +       skb->truesize = skb->truesize - delta_truesize;
> > +       skb->data_len = skb->data_len - delta_len;
> > +       skb->len = skb->len - delta_len;
> > +       skb->ip_summed = nskb->ip_summed;
> > +       skb->csum_level = nskb->csum_level;
> 
> This changed from the previous version, where nskb inherited ip_summed
> and csum_level from skb. Why is that?

I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
make sure the noone touches the checksum of the head
skb. Otherise netfilter etc. tries to touch the csum.

Before chaining I make sure that ip_summed and csum_level is
the same for all chained skbs and here I restore the original
value from nskb.
