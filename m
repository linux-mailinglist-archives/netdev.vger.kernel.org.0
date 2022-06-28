Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8155CFF6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345011AbiF1LiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 07:38:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344096AbiF1LiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 07:38:04 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DE433347;
        Tue, 28 Jun 2022 04:38:00 -0700 (PDT)
Received: from localhost.localdomain ([160.80.103.126])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25SBbSQV010288
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jun 2022 13:37:29 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Anton Makarov <anton.makarov11235@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v3 1/4] seg6: add support for SRv6 H.Encaps.Red behavior
Date:   Tue, 28 Jun 2022 13:36:39 +0200
Message-Id: <20220628113642.3223-2-andrea.mayer@uniroma2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
References: <20220628113642.3223-1-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SRv6 H.Encaps.Red behavior described in [1] is an optimization of
the SRv6 H.Encaps behavior [2].

H.Encaps.Red reduces the length of the SRH by excluding the first
segment (SID) in the SRH of the pushed IPv6 header. The first SID is
only placed in the IPv6 Destination Address field of the pushed IPv6
header.
When the SRv6 Policy only contains one SID the SRH is omitted, unless
there is an HMAC TLV to be carried.

[1] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.2
[2] - https://datatracker.ietf.org/doc/html/rfc8986#section-5.1

Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Anton Makarov <anton.makarov11235@gmail.com>
---
 include/uapi/linux/seg6_iptunnel.h |   1 +
 net/ipv6/seg6_iptunnel.c           | 126 ++++++++++++++++++++++++++++-
 2 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/seg6_iptunnel.h b/include/uapi/linux/seg6_iptunnel.h
index eb815e0d0ac3..538152a7b2c3 100644
--- a/include/uapi/linux/seg6_iptunnel.h
+++ b/include/uapi/linux/seg6_iptunnel.h
@@ -35,6 +35,7 @@ enum {
 	SEG6_IPTUN_MODE_INLINE,
 	SEG6_IPTUN_MODE_ENCAP,
 	SEG6_IPTUN_MODE_L2ENCAP,
+	SEG6_IPTUN_MODE_ENCAP_RED,
 };
 
 #endif
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index d64855010948..4942073650d3 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -36,6 +36,7 @@ static size_t seg6_lwt_headroom(struct seg6_iptunnel_encap *tuninfo)
 	case SEG6_IPTUN_MODE_INLINE:
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		head = sizeof(struct ipv6hdr);
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
@@ -195,6 +196,122 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 }
 EXPORT_SYMBOL_GPL(seg6_do_srh_encap);
 
+/* encapsulate an IPv6 packet within an outer IPv6 header with reduced SRH */
+static int seg6_do_srh_encap_red(struct sk_buff *skb,
+				 struct ipv6_sr_hdr *osrh, int proto)
+{
+	__u8 first_seg = osrh->first_segment;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net *net = dev_net(dst->dev);
+	struct ipv6hdr *hdr, *inner_hdr;
+	int hdrlen = ipv6_optlen(osrh);
+	int red_tlv_offset, tlv_offset;
+	struct ipv6_sr_hdr *isrh;
+	bool skip_srh = false;
+	__be32 flowlabel;
+	int tot_len, err;
+	int red_hdrlen;
+	int tlvs_len;
+
+	if (first_seg > 0) {
+		red_hdrlen = hdrlen - sizeof(struct in6_addr);
+	} else {
+		/* NOTE: if tag/flags and/or other TLVs are introduced in the
+		 * seg6_iptunnel infrastructure, they should be considered when
+		 * deciding to skip the SRH.
+		 */
+		skip_srh = !sr_has_hmac(osrh);
+
+		red_hdrlen = skip_srh ? 0 : hdrlen;
+	}
+
+	tot_len = red_hdrlen + sizeof(struct ipv6hdr);
+
+	err = skb_cow_head(skb, tot_len + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	inner_hdr = ipv6_hdr(skb);
+	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
+
+	skb_push(skb, tot_len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	hdr = ipv6_hdr(skb);
+
+	/* based on seg6_do_srh_encap() */
+	if (skb->protocol == htons(ETH_P_IPV6)) {
+		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
+			     flowlabel);
+		hdr->hop_limit = inner_hdr->hop_limit;
+	} else {
+		ip6_flow_hdr(hdr, 0, flowlabel);
+		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
+
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+		IP6CB(skb)->iif = skb->skb_iif;
+	}
+
+	/* no matter if we have to skip the SRH or not, the first segment
+	 * always comes in the pushed IPv6 header.
+	 */
+	hdr->daddr = osrh->segments[first_seg];
+
+	if (skip_srh) {
+		hdr->nexthdr = proto;
+
+		set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+		goto out;
+	}
+
+	/* we cannot skip the SRH, slow path */
+
+	hdr->nexthdr = NEXTHDR_ROUTING;
+	isrh = (void *)hdr + sizeof(struct ipv6hdr);
+
+	if (unlikely(!first_seg)) {
+		/* this is a very rare case; we have only one SID but
+		 * we cannot skip the SRH since we are carrying some
+		 * other info.
+		 */
+		memcpy(isrh, osrh, hdrlen);
+		goto srcaddr;
+	}
+
+	tlv_offset = sizeof(*osrh) + (first_seg + 1) * sizeof(struct in6_addr);
+	red_tlv_offset = tlv_offset - sizeof(struct in6_addr);
+
+	memcpy(isrh, osrh, red_tlv_offset);
+
+	tlvs_len = hdrlen - tlv_offset;
+	if (unlikely(tlvs_len > 0)) {
+		const void *s = (const void *)osrh + tlv_offset;
+		void *d = (void *)isrh + red_tlv_offset;
+
+		memcpy(d, s, tlvs_len);
+	}
+
+	--isrh->first_segment;
+	isrh->hdrlen -= 2;
+
+srcaddr:
+	isrh->nexthdr = proto;
+	set_tun_src(net, dst->dev, &hdr->daddr, &hdr->saddr);
+
+#ifdef CONFIG_IPV6_SEG6_HMAC
+	if (unlikely(!skip_srh && sr_has_hmac(isrh))) {
+		err = seg6_push_hmac(net, &hdr->saddr, isrh);
+		if (unlikely(err))
+			return err;
+	}
+#endif
+
+out:
+	skb_postpush_rcsum(skb, hdr, tot_len);
+
+	return 0;
+}
+
 /* insert an SRH within an IPv6 packet, just after the IPv6 header */
 int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh)
 {
@@ -265,6 +382,7 @@ static int seg6_do_srh(struct sk_buff *skb)
 			return err;
 		break;
 	case SEG6_IPTUN_MODE_ENCAP:
+	case SEG6_IPTUN_MODE_ENCAP_RED:
 		err = iptunnel_handle_offloads(skb, SKB_GSO_IPXIP6);
 		if (err)
 			return err;
@@ -276,7 +394,11 @@ static int seg6_do_srh(struct sk_buff *skb)
 		else
 			return -EINVAL;
 
-		err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		if (tinfo->mode == SEG6_IPTUN_MODE_ENCAP)
+			err = seg6_do_srh_encap(skb, tinfo->srh, proto);
+		else
+			err = seg6_do_srh_encap_red(skb, tinfo->srh, proto);
+
 		if (err)
 			return err;
 
@@ -514,6 +636,8 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 		break;
 	case SEG6_IPTUN_MODE_L2ENCAP:
 		break;
+	case SEG6_IPTUN_MODE_ENCAP_RED:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.20.1

