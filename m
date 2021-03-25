Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD1D349733
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 17:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCYQrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 12:47:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhCYQrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 12:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616690863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zvm4ttdwyI2zpKh8pXUANo8hDmXVXXRsBCjVUunDBR8=;
        b=UHjEpV+8K4sjsxfOggeKwZi5YByH9Qx82yiVtyR0DcJmB296ngksRppOZDmFgo5DZj7PZG
        YbKWBI/GBmtjrzhHJhKsA6m+pb/Mu6qINlx67J57jleK9kpYxS5sZOHmzTC8RlmgOes9Jw
        rWFhFZpX0eCj6swEqt5KKwnko7ZmqWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-OEOJv7sQP-ClAiOYHuvdgg-1; Thu, 25 Mar 2021 12:47:41 -0400
X-MC-Unique: OEOJv7sQP-ClAiOYHuvdgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA4AB81746B;
        Thu, 25 Mar 2021 16:47:39 +0000 (UTC)
Received: from ovpn-113-211.ams2.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A330550DD5;
        Thu, 25 Mar 2021 16:47:37 +0000 (UTC)
Message-ID: <030bcf7a14ada8caa464bb33916e5abc19eab67c.camel@redhat.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Thu, 25 Mar 2021 17:47:36 +0100
In-Reply-To: <CA+FuTSepOe88N_jY+9F5gTu6ShzMa8rOZzi6CAsF+4k6iPeajw@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
         <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
         <43f56578c91f8abd8e3d1e8c73be1c4d5162089f.camel@redhat.com>
         <CA+FuTSd6fOaj6bJssyXeyL-LWvSEdSH+QchHUG8Ga-=EQ634Lg@mail.gmail.com>
         <5143c873078583ef0f12d08ccf966d6b4640b9ee.camel@redhat.com>
         <CA+FuTScdNaWxNWMp+tpZrEGmO=eW1cpHQi=1Rz9cYQQ8oz+2CA@mail.gmail.com>
         <6377ac88cd76e7d948a0f4ea5f8bfffd3fac1710.camel@redhat.com>
         <CA+FuTSepOe88N_jY+9F5gTu6ShzMa8rOZzi6CAsF+4k6iPeajw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-03-25 at 09:53 -0400, Willem de Bruijn wrote:
> On Thu, Mar 25, 2021 at 6:57 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > AFAICS, it depends ;) From skbuff.h:
> > 
> >  *   skb->csum_level indicates the number of consecutive checksums found in
> >  *   the packet minus one that have been verified as CHECKSUM_UNNECESSARY.
> > 
> > if skb->csum_level > 0, the NIC validate additional headers. The intel
> > ixgbe driver use that for vxlan RX csum offload. Such field translates
> > into:
> > 
> >         NAPI_GRO_CB(skb)->csum_cnt
> > 
> > inside the GRO engine, and skb_gro_incr_csum_unnecessary takes care of
> > the updating it after validation.
> 
> True. I glanced over those cases.
> 
> More importantly, where exactly do these looped packets get converted
> from CHECKSUM_PARTIAL to CHECKSUM_NONE before this patch?

Very good question! It took a bit finding the exact place.

int __iptunnel_pull_header(struct sk_buff *skb, int hdr_len,
			   __be16 inner_proto, bool raw_proto, bool xnet)
{
	if (unlikely(!pskb_may_pull(skb, hdr_len)))
		return -ENOMEM;

	skb_pull_rcsum(skb, hdr_len);
        // here ^^^ via skb_pull_rcsum -> skb_postpull_rcsum() -> __skb_postpull_rcsum()

well, this is actually with _this_ patch applied: it does not change
the place where the ip_summed is set.

> > My understanding is that the following should be better:
> > 
> > static inline void udp_post_segment_fix_csum(struct sk_buff *skb)
> > {
> >         /* UDP-lite can't land here - no GRO */
> >         WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> > 
> >         /* UDP packets generated with UDP_SEGMENT and traversing:
> >          * UDP tunnel(xmit) -> veth (segmentation) -> veth (gro) -> UDP tunnel (rx)
> >          * land here with CHECKSUM_NONE. Instead of adding another check
> >          * in the tunnel fastpath, we can force valid csums here:
> >          * packets are locally generated and the GRO engine already validated
> >          * the csum.
> >          * Additionally fixup the UDP CB
> >          */
> >         UDP_SKB_CB(skb)->cscov = skb->len;
> >         if (skb->ip_summed == CHECKSUM_NONE && !skb->csum_valid)
> >                 skb->csum_valid = 1;
> > }
> > 
> > I'll use the above in v2.
> 
> Do I understand correctly that this avoids matching tunneled packets
> that arrive from the network with rx checksumming disabled, because
> __skb_gro_checksum_complete will have been called on the outer packet
> and have set skb->csum_valid?

Exactly. I did the test, and perf probes showed that.

> Yes, this just (1) identifying the packet as being of local source and
> then (2) setting csum_valid sounds great to me, thanks.

Will try to submit v2 soon, after some more testing.

Thanks for all the feedback!

Paolo

