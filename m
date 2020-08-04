Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2E323B5E0
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729925AbgHDHkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbgHDHkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 03:40:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADDCC06174A;
        Tue,  4 Aug 2020 00:40:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id c15so190180wrs.11;
        Tue, 04 Aug 2020 00:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nNzt5TcbFA3OdRa1OrMmungZKleua2u+KjZa3EIGs5w=;
        b=FejR63DY+mt6oi68sgJ4ohkXOsHF3VuWI0H9hNo2UhGbRd0ZaLW6gluW3zH+KyFVuv
         N2Z4Aejyf/ucPLxA/rQrm3i/FSmOkFPS5Nt0oSW7MhEBICtPI3hWpGGh1uHWXUFBDhzR
         GZf4rtbw7XfGZh6yPwnrpq3AYKntFFBXUzRi7Tz6M6XlqRC22VT0rwj6dqpSr53zpikc
         dfa+8+ZrblHLUzYN454MVn0qcDoaTXg6ebK3DLP/2D/J4Qdf+ynW4hp6DsS8u0a4Qb0s
         1U13AkBVwyJxtLF8VbnsI7kVP/D0L21repGv61lyTD37JnB4/LhO8OzfgdxeihNg8i4N
         BhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nNzt5TcbFA3OdRa1OrMmungZKleua2u+KjZa3EIGs5w=;
        b=WaIPUO61DMxDFOixe5AvnFNDIQNO6vi2U3Ucu3DjPDS6pmsHs4RTG8n8efGBn1UVez
         tYW1OKaUUsIQyXkP7SHhqqQr+sTafL6t9LhlmQoMWvhFsh5PMZkHbo/VPbrqekH7VdNX
         kjshnoKKi7AGU53Bjpwc08WteKUS5YB7BHvMkya8LQisRgqiId/Nvh1m3Y/LZHbSxavX
         xLKLIdn57LZXFW7PEgH4ExnCt+3OXd9OPwLhNv5PGwhonq8Wo1oqyb4sBm2kj3XyszP/
         1KO0nrwXgcHnBIDIHL33lRWd4CVXFXTsFOEVDqiKxW5avMCg7vKdTWAaiOmCm4qIcNVJ
         T2ZQ==
X-Gm-Message-State: AOAM530t7CljpbXhbS9QlYgwo2AnhNDRdRRIqDczL3geug19E+kGjj9C
        g1MlKewnX5HLA/ixPjIpXPP7XtEY/iI=
X-Google-Smtp-Source: ABdhPJxUdt7GVbNqFGdSxL8QJ40j7jlSGNB7gkOV1Mk2BEoQcpjgYCV7FFu3lPixi7MGbKMY+qA19A==
X-Received: by 2002:adf:bc07:: with SMTP id s7mr19589488wrg.254.1596526838366;
        Tue, 04 Aug 2020 00:40:38 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.44])
        by smtp.gmail.com with ESMTPSA id a3sm3406580wme.34.2020.08.04.00.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 00:40:37 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Cc:     Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: [PATCH] seg6: using DSCP of inner IPv4 packets
Date:   Tue,  4 Aug 2020 07:40:30 +0000
Message-Id: <20200804074030.1147-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows copying the DSCP from inner IPv4 header to the
outer IPv6 header, when doing SRv6 Encapsulation.

This allows forwarding packet across the SRv6 fabric based on their
original traffic class.

Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 net/ipv6/seg6_iptunnel.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e0e9f48ab14f..12fb32ca64f7 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -87,8 +87,7 @@ static void set_tun_src(struct net *net, struct net_device *dev,
 }
 
 /* Compute flowlabel for outer IPv6 header */
-static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
-				  struct ipv6hdr *inner_hdr)
+static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb)
 {
 	int do_flowlabel = net->ipv6.sysctl.seg6_flowlabel;
 	__be32 flowlabel = 0;
@@ -99,7 +98,7 @@ static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
 		hash = rol32(hash, 16);
 		flowlabel = (__force __be32)hash & IPV6_FLOWLABEL_MASK;
 	} else if (!do_flowlabel && skb->protocol == htons(ETH_P_IPV6)) {
-		flowlabel = ip6_flowlabel(inner_hdr);
+		flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 	}
 	return flowlabel;
 }
@@ -109,10 +108,11 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(dst->dev);
-	struct ipv6hdr *hdr, *inner_hdr;
 	struct ipv6_sr_hdr *isrh;
 	int hdrlen, tot_len, err;
+	struct ipv6hdr *hdr;
 	__be32 flowlabel;
+	u8 tos = 0;
 
 	hdrlen = (osrh->hdrlen + 1) << 3;
 	tot_len = hdrlen + sizeof(*hdr);
@@ -121,31 +121,31 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	if (unlikely(err))
 		return err;
 
-	inner_hdr = ipv6_hdr(skb);
-	flowlabel = seg6_make_flowlabel(net, skb, inner_hdr);
-
-	skb_push(skb, tot_len);
-	skb_reset_network_header(skb);
-	skb_mac_header_rebuild(skb);
-	hdr = ipv6_hdr(skb);
-
 	/* inherit tc, flowlabel and hlim
 	 * hlim will be decremented in ip6_forward() afterwards and
 	 * decapsulation will overwrite inner hlim with outer hlim
 	 */
 
+	flowlabel = seg6_make_flowlabel(net, skb);
+
 	if (skb->protocol == htons(ETH_P_IPV6)) {
-		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
-			     flowlabel);
-		hdr->hop_limit = inner_hdr->hop_limit;
+		tos = ip6_tclass(ip6_flowinfo(ipv6_hdr(skb)));
+	} else if (skb->protocol == htons(ETH_P_IP)) {
+		tos = ip_hdr(skb)->tos;
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	} else {
-		ip6_flow_hdr(hdr, 0, flowlabel);
-		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
-
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	}
 
+	skb_push(skb, tot_len);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	hdr = ipv6_hdr(skb);
+
+	ip6_flow_hdr(hdr, tos, flowlabel);
+
 	hdr->nexthdr = NEXTHDR_ROUTING;
+	hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
 
 	isrh = (void *)hdr + sizeof(*hdr);
 	memcpy(isrh, osrh, hdrlen);
-- 
2.17.1

