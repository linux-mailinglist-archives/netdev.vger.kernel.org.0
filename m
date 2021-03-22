Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7396344C80
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhCVQ7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:59:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231270AbhCVQ7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616432362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7N6XCp6yGRBkxMmcdSYxJKvExERSs5ZsnuqRS5j5r0w=;
        b=DDBJao6qhkOIP1TYs2Nb4h4K9kQjY8yXgGmbZU9J1HG+No6KXWPXpMy+8hGIz/r3XarYWD
        gux7e7I8n0qSqBxdRV7BTa4M992ON8RlEzGMsA+r4nCYPJLy69fTM9Me8NfcOmWA78l1UY
        Q/6Un9I5y4CFJSB8BlR2etetzBFmPEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-YV3LD6y7MvynlPtYZB05Nw-1; Mon, 22 Mar 2021 12:59:12 -0400
X-MC-Unique: YV3LD6y7MvynlPtYZB05Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56CD61007477;
        Mon, 22 Mar 2021 16:59:11 +0000 (UTC)
Received: from ovpn-115-44.ams2.redhat.com (ovpn-115-44.ams2.redhat.com [10.36.115.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C4D260D43;
        Mon, 22 Mar 2021 16:59:09 +0000 (UTC)
Message-ID: <6d5fae11c4eecda3f59f9491426834fce8c37f7e.camel@redhat.com>
Subject: Re: [PATCH net-next 3/8] udp: properly complete L4 GRO over UDP
 tunnel packet
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Mon, 22 Mar 2021 17:59:08 +0100
In-Reply-To: <CA+FuTSfpAzEEz0WZ0EqwKu3CzuvZiD1Vv5+kCos0mL=_Rudkrg@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <72d8fc8a6d35a74d267cca6c9eddb3ff7852868b.1616345643.git.pabeni@redhat.com>
         <CA+FuTSfpAzEEz0WZ0EqwKu3CzuvZiD1Vv5+kCos0mL=_Rudkrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-22 at 09:30 -0400, Willem de Bruijn wrote:
> On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > After the previous patch the stack can do L4 UDP aggregation
> > on top of an UDP tunnel.
> > 
> > The current GRO complete code tries frag based aggregation first;
> > in the above scenario will generate corrupted frames.
> > 
> > We need to try first UDP tunnel based aggregation, if the GRO
> > packet requires that. We can use time GRO 'encap_mark' field
> > to track the need GRO complete action. If encap_mark is set,
> > skip the frag_list aggregation.
> > 
> > On tunnel encap GRO complete clear such field, so that an inner
> > frag_list GRO complete could take action.
> > 
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/ipv4/udp_offload.c | 8 +++++++-
> >  net/ipv6/udp_offload.c | 3 ++-
> >  2 files changed, 9 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > index 25134a3548e99..54e06b88af69a 100644
> > --- a/net/ipv4/udp_offload.c
> > +++ b/net/ipv4/udp_offload.c
> > @@ -642,6 +642,11 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
> >                 skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
> >                                         : SKB_GSO_UDP_TUNNEL;
> > 
> > +               /* clear the encap mark, so that inner frag_list gro_complete
> > +                * can take place
> > +                */
> > +               NAPI_GRO_CB(skb)->encap_mark = 0;
> > +
> >                 /* Set encapsulation before calling into inner gro_complete()
> >                  * functions to make them set up the inner offsets.
> >                  */
> > @@ -665,7 +670,8 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
> >         const struct iphdr *iph = ip_hdr(skb);
> >         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> > 
> > -       if (NAPI_GRO_CB(skb)->is_flist) {
> > +       /* do fraglist only if there is no outer UDP encap (or we already processed it) */
> > +       if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
> 
> Sorry, I don't follow. I thought the point was to avoid fraglist if an
> outer udp tunnel header is present. But the above code clears the mark
> and allows entering the fraglist branch exactly when such a header is
> encountered?

The relevant UDP packet has gone through:

[l2/l3 GRO] -> udp_gro_receive  -> udp_sk(sk)->gro_receive -> [some
more GRO layers] -> udp_gro_receive (again)

The first udp_gro_receive set NAPI_GRO_CB(skb)->encap_mark, the
latter udp_gro_receive set NAPI_GRO_CB(skb)->is_flist.

Then, at GRO complete time:

[l2/l3 GRO] -> udp{4,6}_gro_complete -> udp_sk(sk)->gro_complete ->
[more GRO layers] -> udp{4,6}_gro_complete (again).

In the first udp{4,6}_gro_complete invocation 'encap_mark' is 1, so
with this patch we do the 'udp_sk(sk)->gro_complete' path. In the
second udp{4,6}_gro_complete invocation 'encap_mark' has been cleared
(by udp_gro_complete), so we do the SKB_GSO_FRAGLIST completion.

In case SKB_GSO_FRAGLIST with no UDP tunnel, 'encap_mark' is 0 and we
do the SKB_GSO_FRAGLIST completion.

Another alternative, possibly more readable, would be avoid clearing
'encap_mark' in udp_gro_complete() and replacing the above check with:

	if (NAPI_GRO_CB(skb)->is_flist &&
            (!NAPI_GRO_CB(skb)->encap_mark ||
 	     (NAPI_GRO_CB(skb)->encap_mark && skb->encapsulation))) {

I opted otherwise to simplify the conditional expression.

Please let me know if the above is somewhat more clear and if you have
preferecens between the two options.

Cheers,

Paolo

