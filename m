Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E42F81E1
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbhAORN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:13:27 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:53092 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730505AbhAORN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:13:26 -0500
Date:   Fri, 15 Jan 2021 17:12:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610730763; bh=LXcmJKBuaYzaNR2L/7SrZkPnX5Pb9ABYbXcPPC91lF0=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=aso/0ju/yHbVPMzIeV6/44swTZ6bbdlkToxmT72XGN00hlcB95nPAihC5iPXmMlCG
         VqLYlsg1QpTCS5S8Ad6uL8VINpJbffiXdL72aZymfgx4Wr1MMRCirzyx//YPKRKJfR
         YJgRf1JrikeyC6A0sV8PvFhM657+Fd4tXeBp3LYvRD7DtKbBHqLahJUQcBQX5aZ5uN
         ovISKbetSuQk64tdfgbU+LheM5NtlYl46i8rvcLhU0CZhVowROrXHZWSDAj2bg0o8n
         GFrGfWkSvjWIz+pNAvKaY8YnyK110CcsXS1vwB7iFtmAHUFyQn0N/aBKgAN5GrT/+T
         vwghgsBSnC3bg==
To:     Dongseok Yi <dseok.yi@samsung.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        namkyu78.kim@samsung.com, Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net v2] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
Message-ID: <20210115171203.175115-1-alobakin@pm.me>
In-Reply-To: <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com> <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongseok Yi <dseok.yi@samsung.com>
Date: Fri, 15 Jan 2021 22:20:35 +0900

> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
> forwarding. Only the header of head_skb from ip_finish_output_gso ->
> skb_gso_segment is updated but following frag_skbs are not updated.
>=20
> A call path skb_mac_gso_segment -> inet_gso_segment ->
> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
> does not try to update UDP/IP header of the segment list but copy
> only the MAC header.
>=20
> Update dport, daddr and checksums of each skb of the segment list
> in __udp_gso_segment_list. It covers both SNAT and DNAT.
>=20
> Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> ---
> v1:
> Steffen Klassert said, there could be 2 options.
> https://lore.kernel.org/patchwork/patch/1362257/
> I was trying to write a quick fix, but it was not easy to forward
> segmented list. Currently, assuming DNAT only.
>=20
> v2:
> Per Steffen Klassert request, move the procedure from
> udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
>=20
> To Alexander Lobakin, I've checked your email late. Just use this
> patch as a reference. It support SNAT too, but does not support IPv6
> yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
> to the file is in IPv4 directory.

I used another approach, tried to make fraglist GRO closer to plain
in terms of checksummming, as it is confusing to me why GSO packet
should have CHECKSUM_UNNECESSARY. Just let Netfilter do its mangling,
and then use classic UDP GSO magic at the end of segmentation.
I also see the idea of explicit comparing and editing of IP and UDP
headers right in __udp_gso_segment_list() rather unacceptable.

Dongseok, Steffen, please test this WIP diff and tell if this one
works for you, so I could clean up the code and make a patch.
For me, it works now in any configurations, with and without
checksum/GSO/fraglist offload.

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c1a6f262636a..646a42e88e83 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3674,6 +3674,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 =09=09=09=09 unsigned int offset)
 {
 =09struct sk_buff *list_skb =3D skb_shinfo(skb)->frag_list;
+=09unsigned int doffset =3D skb->data - skb_mac_header(skb);
 =09unsigned int tnl_hlen =3D skb_tnl_header_len(skb);
 =09unsigned int delta_truesize =3D 0;
 =09unsigned int delta_len =3D 0;
@@ -3681,7 +3682,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 =09struct sk_buff *nskb, *tmp;
 =09int err;
=20
-=09skb_push(skb, -skb_network_offset(skb) + offset);
+=09skb_push(skb, doffset);
=20
 =09skb_shinfo(skb)->frag_list =3D NULL;
=20
@@ -3716,12 +3717,11 @@ struct sk_buff *skb_segment_list(struct sk_buff *sk=
b,
 =09=09delta_len +=3D nskb->len;
 =09=09delta_truesize +=3D nskb->truesize;
=20
-=09=09skb_push(nskb, -skb_network_offset(nskb) + offset);
+=09=09skb_push(nskb, skb_headroom(nskb) - skb_headroom(skb));
=20
 =09=09skb_release_head_state(nskb);
-=09=09 __copy_skb_header(nskb, skb);
+=09=09__copy_skb_header(nskb, skb);
=20
-=09=09skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(sk=
b));
 =09=09skb_copy_from_linear_data_offset(skb, -tnl_hlen,
 =09=09=09=09=09=09 nskb->data - tnl_hlen,
 =09=09=09=09=09=09 offset + tnl_hlen);
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94781bf..61665fcd8c85 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -190,13 +190,58 @@ EXPORT_SYMBOL(skb_udp_tunnel_segment);
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 =09=09=09=09=09      netdev_features_t features)
 {
-=09unsigned int mss =3D skb_shinfo(skb)->gso_size;
+=09struct sk_buff *seg;
+=09struct udphdr *uh;
+=09unsigned int mss;
+=09__be16 newlen;
+=09__sum16 check;
+
+=09mss =3D skb_shinfo(skb)->gso_size;
+=09if (skb->len <=3D sizeof(*uh) + mss)
+=09=09return ERR_PTR(-EINVAL);
=20
-=09skb =3D skb_segment_list(skb, features, skb_mac_header_len(skb));
+=09skb_pull(skb, sizeof(*uh));
+
+=09skb =3D skb_segment_list(skb, features, skb->data - skb_mac_header(skb)=
);
 =09if (IS_ERR(skb))
 =09=09return skb;
=20
-=09udp_hdr(skb)->len =3D htons(sizeof(struct udphdr) + mss);
+=09seg =3D skb;
+=09uh =3D udp_hdr(seg);
+
+=09/* compute checksum adjustment based on old length versus new */
+=09newlen =3D htons(sizeof(*uh) + mss);
+=09check =3D csum16_add(csum16_sub(uh->check, uh->len), newlen);
+
+=09for (;;) {
+=09=09if (!seg->next)
+=09=09=09break;
+
+=09=09uh->len =3D newlen;
+=09=09uh->check =3D check;
+
+=09=09if (seg->ip_summed =3D=3D CHECKSUM_PARTIAL)
+=09=09=09gso_reset_checksum(seg, ~check);
+=09=09else
+=09=09=09uh->check =3D gso_make_checksum(seg, ~check) ? :
+=09=09=09=09    CSUM_MANGLED_0;
+
+=09=09seg =3D seg->next;
+=09=09uh =3D udp_hdr(seg);
+=09}
+
+=09/* last packet can be partial gso_size, account for that in checksum */
+=09newlen =3D htons(skb_tail_pointer(seg) - skb_transport_header(seg) +
+=09=09       seg->data_len);
+=09check =3D csum16_add(csum16_sub(uh->check, uh->len), newlen);
+
+=09uh->len =3D newlen;
+=09uh->check =3D check;
+
+=09if (seg->ip_summed =3D=3D CHECKSUM_PARTIAL)
+=09=09gso_reset_checksum(seg, ~check);
+=09else
+=09=09uh->check =3D gso_make_checksum(seg, ~check) ? : CSUM_MANGLED_0;
=20
 =09return skb;
 }
@@ -602,27 +647,13 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct =
sk_buff *skb, int nhoff)
 =09const struct iphdr *iph =3D ip_hdr(skb);
 =09struct udphdr *uh =3D (struct udphdr *)(skb->data + nhoff);
=20
-=09if (NAPI_GRO_CB(skb)->is_flist) {
-=09=09uh->len =3D htons(skb->len - nhoff);
-
-=09=09skb_shinfo(skb)->gso_type |=3D (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
-=09=09skb_shinfo(skb)->gso_segs =3D NAPI_GRO_CB(skb)->count;
-
-=09=09if (skb->ip_summed =3D=3D CHECKSUM_UNNECESSARY) {
-=09=09=09if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
-=09=09=09=09skb->csum_level++;
-=09=09} else {
-=09=09=09skb->ip_summed =3D CHECKSUM_UNNECESSARY;
-=09=09=09skb->csum_level =3D 0;
-=09=09}
-
-=09=09return 0;
-=09}
-
 =09if (uh->check)
 =09=09uh->check =3D ~udp_v4_check(skb->len - nhoff, iph->saddr,
 =09=09=09=09=09  iph->daddr, 0);
=20
+=09if (NAPI_GRO_CB(skb)->is_flist)
+=09=09skb_shinfo(skb)->gso_type |=3D SKB_GSO_FRAGLIST;
+
 =09return udp_gro_complete(skb, nhoff, udp4_lib_lookup_skb);
 }
=20

