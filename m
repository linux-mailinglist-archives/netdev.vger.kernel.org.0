Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880342FEA17
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbhAUMa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:30:29 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:56452 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731137AbhAUM3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:29:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 04C322018D;
        Thu, 21 Jan 2021 13:28:59 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FC8YExFQj8NY; Thu, 21 Jan 2021 13:28:58 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0E689200AC;
        Thu, 21 Jan 2021 13:28:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 21 Jan 2021 13:28:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 21 Jan
 2021 13:28:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 49CFE3181CAC;
 Thu, 21 Jan 2021 13:28:57 +0100 (CET)
Date:   Thu, 21 Jan 2021 13:28:57 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dongseok Yi <dseok.yi@samsung.com>
CC:     "'David S. Miller'" <davem@davemloft.net>,
        'Alexander Lobakin' <alobakin@pm.me>,
        <namkyu78.kim@samsung.com>, 'Jakub Kicinski' <kuba@kernel.org>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        "'Willem de Bruijn'" <willemb@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Message-ID: <20210121122857.GS3576117@gauss3.secunet.de>
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
 <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
 <20210118132736.GM3576117@gauss3.secunet.de>
 <012d01d6eef9$45516d40$cff447c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <012d01d6eef9$45516d40$cff447c0$@samsung.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 03:55:42PM +0900, Dongseok Yi wrote:
> On 2021-01-18 22:27, Steffen Klassert wrote:
> > On Fri, Jan 15, 2021 at 10:20:35PM +0900, Dongseok Yi wrote:
> > > UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> > > forwarding. Only the header of head_skb from ip_finish_output_gso ->
> > > skb_gso_segment is updated but following frag_skbs are not updated.
> > >
> > > A call path skb_mac_gso_segment -> inet_gso_segment ->
> > > udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> > > does not try to update UDP/IP header of the segment list but copy
> > > only the MAC header.
> > >
> > > Update dport, daddr and checksums of each skb of the segment list
> > > in __udp_gso_segment_list. It covers both SNAT and DNAT.
> > >
> > > Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> > > Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> > > ---
> > > v1:
> > > Steffen Klassert said, there could be 2 options.
> > > https://lore.kernel.org/patchwork/patch/1362257/
> > > I was trying to write a quick fix, but it was not easy to forward
> > > segmented list. Currently, assuming DNAT only.
> > >
> > > v2:
> > > Per Steffen Klassert request, move the procedure from
> > > udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
> > >
> > > To Alexander Lobakin, I've checked your email late. Just use this
> > > patch as a reference. It support SNAT too, but does not support IPv6
> > > yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> > > to the file is in IPv4 directory.
> > >
> > >  include/net/udp.h      |  2 +-
> > >  net/ipv4/udp_offload.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++----
> > >  net/ipv6/udp_offload.c |  2 +-
> > >  3 files changed, 59 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/include/net/udp.h b/include/net/udp.h
> > > index 877832b..01351ba 100644
> > > --- a/include/net/udp.h
> > > +++ b/include/net/udp.h
> > > @@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> > >  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
> > >
> > >  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> > > -				  netdev_features_t features);
> > > +				  netdev_features_t features, bool is_ipv6);
> > >
> > >  static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
> > >  {
> > > diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> > > index ff39e94..c532d3b 100644
> > > --- a/net/ipv4/udp_offload.c
> > > +++ b/net/ipv4/udp_offload.c
> > > @@ -187,8 +187,57 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
> > >  }
> > >  EXPORT_SYMBOL(skb_udp_tunnel_segment);
> > >
> > > +static void __udpv4_gso_segment_csum(struct sk_buff *seg,
> > > +				     __be32 *oldip, __be32 *newip,
> > > +				     __be16 *oldport, __be16 *newport)
> > > +{
> > > +	struct udphdr *uh = udp_hdr(seg);
> > > +	struct iphdr *iph = ip_hdr(seg);
> > > +
> > > +	if (uh->check) {
> > > +		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
> > > +					 true);
> > > +		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
> > > +					 false);
> > > +		if (!uh->check)
> > > +			uh->check = CSUM_MANGLED_0;
> > > +	}
> > > +	uh->dest = *newport;
> > > +
> > > +	csum_replace4(&iph->check, *oldip, *newip);
> > > +	iph->daddr = *newip;
> > > +}
> > 
> > Can't we just do the checksum recalculation for this case as it is done
> > with standard GRO?
> 
> If I understand standard GRO correctly, it calculates full checksum.
> Should we adopt the same method to UDP GRO fraglist? I did not find
> a simple method for the incremental checksum update.
> 
> > 
> > > +
> > > +static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
> > > +{
> > > +	struct sk_buff *seg;
> > > +	struct udphdr *uh, *uh2;
> > > +	struct iphdr *iph, *iph2;
> > > +
> > > +	seg = segs;
> > > +	uh = udp_hdr(seg);
> > > +	iph = ip_hdr(seg);
> > > +
> > > +	while ((seg = seg->next)) {
> > > +		uh2 = udp_hdr(seg);
> > > +		iph2 = ip_hdr(seg);
> > > +
> > > +		if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> > > +			__udpv4_gso_segment_csum(seg,
> > > +						 &iph2->saddr, &iph->saddr,
> > > +						 &uh2->source, &uh->source);
> > > +
> > > +		if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> > > +			__udpv4_gso_segment_csum(seg,
> > > +						 &iph2->daddr, &iph->daddr,
> > > +						 &uh2->dest, &uh->dest);
> > > +	}


> > 
> > You don't need to check the addresses and ports of all packets in the
> > segment list. If the addresses and ports are equal for the first and
> > second packet in the list, then this also holds for the rest of the
> > packets.
> 
> I think we can try this with an additional flag (seg_csum).
> 
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 36b7e30..3f892df 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -213,25 +213,36 @@ static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
>         struct sk_buff *seg;
>         struct udphdr *uh, *uh2;
>         struct iphdr *iph, *iph2;
> +       bool seg_csum = false;
> 
>         seg = segs;
>         uh = udp_hdr(seg);
>         iph = ip_hdr(seg);

Why not

       if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
           (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
           (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
           (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
	   	return segs;

Then you don't need to test inside the loop. Just update all
packets if there is a header mismatch.

> 
> -       while ((seg = seg->next)) {
> +       seg = seg->next;
> +       do {
> +               if (!seg)
> +                       break;
> +
>                 uh2 = udp_hdr(seg);
>                 iph2 = ip_hdr(seg);
> 
> -               if (uh->source != uh2->source || iph->saddr != iph2->saddr)
> +               if (uh->source != uh2->source || iph->saddr != iph2->saddr) {
>                         __udpv4_gso_segment_csum(seg,
>                                                  &iph2->saddr, &iph->saddr,
>                                                  &uh2->source, &uh->source);
> +                       seg_csum = true;
> +               }
> 
> -               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
> +               if (uh->dest != uh2->dest || iph->daddr != iph2->daddr) {
>                         __udpv4_gso_segment_csum(seg,
>                                                  &iph2->daddr, &iph->daddr,
>                                                  &uh2->dest, &uh->dest);
> -       }
> +                       seg_csum = true;
> +               }
> +
> +               seg = seg->next;
> +       } while (seg_csum);
> 
>         return segs;
>  }
