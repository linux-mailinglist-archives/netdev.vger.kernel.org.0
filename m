Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB128348E74
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 11:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbhCYK5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 06:57:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230232AbhCYK4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 06:56:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616669794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwrRt9/REJs2WcFZ7AfoFelvRtbrA+1x2yNCQsDfv9A=;
        b=ILOCQaYXFKyMk3zUa48hTGgsOVk8qfiK+GQmNkpzFe5qsWDamVAUMeYDepmsfQ/nWLi0s0
        PXPENnNng+7F9b3pAvKYld89UKN0lXAqcNFpfFWKO9Ac+QXchE0YLdOJ3VQKTR4QxAka0I
        LlqVAKKup77zJWrOK1fuSdMzFDztB80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-kYT_eMXqO2u_AkTFdjG4ug-1; Thu, 25 Mar 2021 06:56:30 -0400
X-MC-Unique: kYT_eMXqO2u_AkTFdjG4ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 753451083E80;
        Thu, 25 Mar 2021 10:56:28 +0000 (UTC)
Received: from ovpn-113-211.ams2.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7024C17258;
        Thu, 25 Mar 2021 10:56:26 +0000 (UTC)
Message-ID: <6377ac88cd76e7d948a0f4ea5f8bfffd3fac1710.camel@redhat.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Thu, 25 Mar 2021 11:56:25 +0100
In-Reply-To: <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
         <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
         <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
         <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
         <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
         <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2021-03-24 at 18:36 -0400, Willem de Bruijn wrote:
> > > This is a UDP GSO packet egress packet that was further encapsulated
> > > with a GSO_UDP_TUNNEL on egress, then looped to the ingress path?
> > > 
> > > Then in the ingress path it has traversed the GRO layer.
> > > 
> > > Is this veth with XDP? That seems unlikely for GSO packets. But there
> > > aren't many paths that will loop a packet through napi_gro_receive or
> > > napi_gro_frags.
> > 
> > This patch addresses the following scenario:
> > 
> > sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
> > 
> > What I meant here is that the issue is not visible with:
> > 
> > (baremetal, NETIF_F_GRO_UDP_FWD | NETIF_F_GRO_FRAGLIST enabled -> vxlan -> sk
> > 
> > > > with the appropriate features bit set, will validate the checksum for
> > > > both the inner and the outer header - udp{4,6}_gro_receive will be
> > > > traversed twice, the fist one for the outer header, the 2nd for the
> > > > inner.
> > > 
> > > GRO will validate multiple levels of checksums with CHECKSUM_COMPLETE.
> > > It can only validate the outer checksum with CHECKSUM_UNNECESSARY, I
> > > believe?
> > 
> > I possibly miss some bits here ?!?
> > 
> > AFAICS:
> > 
> > udp4_gro_receive() -> skb_gro_checksum_validate_zero_check() ->
> > __skb_gro_checksum_validate -> (if  not already valid)
> > __skb_gro_checksum_validate_complete() -> (if not CHECKSUM_COMPLETE)
> > __skb_gro_checksum_complete()
> > 
> > the latter will validate the UDP checksum at the current nesting level
> > (and set the csum-related bits in the GRO skb cb to the same status
> > as CHECKSUM_COMPLETE)
> > 
> > When processing UDP over UDP tunnel packet, the gro call chain will be:
> > 
> > [l2/l3 GRO] -> udp4_gro_receive (validate outher header csum) ->
> > udp_sk(sk)->gro_receive -> [other gro layers] ->
> > udp4_gro_receive (validate inner header csum) -> ...
> 
> Agreed. But __skb_gro_checksum_validate on the first invocation will
> call skb_gro_incr_csum_unnecessary, so that on the second invocation
> csum_cnt == 0 and triggers a real checksum validation?
> 
> At least, that is my understanding. Intuitively, CHECKSUM_UNNECESSARY
> only validates the first checksum, so says nothing about the validity
> of any subsequent ones.
> 
> But it seems I'm mistaken?

AFAICS, it depends ;) From skbuff.h:

 *   skb->csum_level indicates the number of consecutive checksums found in
 *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.

if skb->csum_level > 0, the NIC validate additional headers. The intel
ixgbe driver use that for vxlan RX csum offload. Such field translates
into:

	NAPI_GRO_CB(skb)->csum_cnt

inside the GRO engine, and skb_gro_incr_csum_unnecessary takes care of
the updating it after validation.

> __skb_gro_checksum_validate has an obvious exception for locally
> generated packets by excluding CHECKSUM_PARTIAL. Looped packets
> usually have CHECKSUM_PARTIAL set. Unfortunately, this is similar to
> the issue that I looked at earlier this year with looped UDP packets
> with MSG_MORE: those are also changed to CHECKSUM_NONE (and exposed a
> checksum bug: 52cbd23a119c).
> 
> Is there perhaps some other way that we can identify that these are
> local packets? They should trivially avoid all checksum checks.
> 
> > > As for looped packets with CHECKSUM_PARTIAL: we definitely have found
> > > bugs in that path before. I think it's fine to set csum_valid on any
> > > packets that can unambiguously be identified as such. Hence the
> > > detailed questions above on which exact packets this code is
> > > targeting, so that there are not accidental false positives that look
> > > the same but have a different ip_summed.
> > 
> > I see this change is controversial.
> 
> I have no concerns with the fix. It is just a very narrow path (veth +
> xdp - tso + gro ..), and to minimize risk I would try to avoid
> updating state of unrelated packets. That was my initial comment: I
> don't understand the need for the else clause.

The branch is there because I wrote this patch before the patches 5,6,7
later in this series. GSO UDP L4 over UDP tunnel packets were segmented
at the UDP tunnel level, and that 'else' branch preserves the
appropriate 'csum_level' value to avoid later (if/when the packet lands
in a plain UDP socket) csum validation.

> > Since the addressed scenario is
> > really a corner case, a simpler alternative would be
> > replacing udp_post_segment_fix_csum with:
> > 
> > static inline void udp_post_segment_fix_cb(struct sk_buff *skb, int level)
> > {
> >         /* UDP-lite can't land here - no GRO */
> >         WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > 
> >         /* UDP CB mirrors the GSO packet, we must re-init it */
> >         UDP_SKB_CB(skb)->cscov = skb->len;
> > }
> > 
> > the downside will be an additional, later, unneeded csum validation for the
> > 
> > sk ->vxlan -> veth -> (xdp in use, TSO disabled, GRO on) -> veth -> vxlan -> sk
> > 
> > scenario. WDYT?
> 
> No, let's definitely avoid an unneeded checksum verification.

Ok.

My understanding is that the following should be better:

static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
{
	/* UDP-lite can't land here - no GRO */
	WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);

	/* UDP packets generated with UDP_SEGMENT and traversing:
	 * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
	 * land here with CHECKSUM_NONE. Instead of adding another check
	 * in the tunnel fastpath, we can force valid csums here:
	 * packets are locally generated and the GRO engine already validated
	 * the csum.
	 * Additionally fixup the UDP CB
	 */
	UDP_SKB_CB(skb)->cscov = skb->len;
	if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
		skb->csum_valid = 1;
}

I'll use the above in v2.

Thanks!

Paolo

