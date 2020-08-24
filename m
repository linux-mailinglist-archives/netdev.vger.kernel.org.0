Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8AB24F852
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHXJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbgHXIvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 04:51:38 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EBAEC061573;
        Mon, 24 Aug 2020 01:51:37 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b17so7045768wru.2;
        Mon, 24 Aug 2020 01:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=uTdKQ5clD4r2ToOsU82FKuGY0/oAS0sA2b3OkSN5Zpg=;
        b=ZkDEphbp87qPwg7y4agT8NB/4n8w+C0e9Jewlx//TTpCFePPG1ec/nrGDnfw5404iS
         Fm9ZKmN28ldI0dxZI6vuP9tBrWjqz6tKEKh2OEeoIwHc2mboJUjeziXneOtr7KhrReJt
         DuaL8ssq5eEPp5aoPWexv4X+yt5EIoXI/HA44jYLWbVLrmtG10vPP/cXSWDIvSxhCntf
         3IH9TxsTBURfwGFkdqCkLwkpx6qgJDWrxrdDrzrG5huGYH5jAeYSsZzBHk1nmmILpUtF
         lHxyBQgdxQNgXZn/eQKzlgP49DMHp6eZDzbHaHOqwqUVxe6nWg0v1yqUXt8A0iDZBiiB
         iLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uTdKQ5clD4r2ToOsU82FKuGY0/oAS0sA2b3OkSN5Zpg=;
        b=f4UcIyyeTEhIoPVFWPjuWgqZwVJ/jl9VePzsGwD2wVbVyZ1aaOQ3OTWdooQOcjjuDx
         SAZLXH1P7+cB7ud556eGwnrCgoe26pN4AzCz4LbfRbU4aPgpqhol3/bj1KGwbdyZVVPb
         YK81NNyGP1hAAqrdefDo3w+9mKnbQxEO0S4A0GonTfy8zTH2Ie9MVGgtgBUPbb+vraEm
         gQa5JYi2a2HoXYBn2k4LXFkSRkBssFXHR6sUX8WITraoLnUr2AuAG1Hai9Cm6n1jT2Nh
         2GKqN48GuDFs6pOf7BzuQerQiSL1lCIDss2zgpFOBIrBQULa5WgdjRbICB0MI5lQ+Evk
         zKYA==
X-Gm-Message-State: AOAM531PNHkIm/f03rpKwJbt8NokGxG1qm2gdycj4ufGO1z8BADKZHY9
        Z9FRMZ7m13XrynVLmSt6VZM=
X-Google-Smtp-Source: ABdhPJxsKgQ9wDqvKQpQNa2EKUcLm0a5wgrSnP2iQunmlTDMK7yxZgtojvcdEyQBb3/+Dv5RAF/h/A==
X-Received: by 2002:adf:ef44:: with SMTP id c4mr4718306wrp.84.1598259095843;
        Mon, 24 Aug 2020 01:51:35 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.43])
        by smtp.gmail.com with ESMTPSA id o2sm21622456wrh.70.2020.08.24.01.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 01:51:35 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     andrea.mayer@uniroma2.it, ahabdels@gmail.com
Subject: [net-next v4] seg6: using DSCP of inner IPv4 packets
Date:   Mon, 24 Aug 2020 08:51:24 +0000
Message-Id: <20200824085124.2488-1-ahabdels@gmail.com>
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
 net/ipv6/seg6_iptunnel.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 897fa59c47de..7eaa7adc296b 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -104,8 +104,7 @@ static void set_tun_src(struct net *net, struct net_device *dev,
 }
 
 /* Compute flowlabel for outer IPv6 header */
-static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
-				  struct ipv6hdr *inner_hdr)
+static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb)
 {
 	int do_flowlabel = net->ipv6.sysctl.seg6_flowlabel;
 	__be32 flowlabel = 0;
@@ -116,7 +115,7 @@ static __be32 seg6_make_flowlabel(struct net *net, struct sk_buff *skb,
 		hash = rol32(hash, 16);
 		flowlabel = (__force __be32)hash & IPV6_FLOWLABEL_MASK;
 	} else if (!do_flowlabel && skb->protocol == htons(ETH_P_IPV6)) {
-		flowlabel = ip6_flowlabel(inner_hdr);
+		flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 	}
 	return flowlabel;
 }
@@ -130,6 +129,7 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 	struct ipv6_sr_hdr *isrh;
 	int hdrlen, tot_len, err;
 	__be32 flowlabel;
+	u8 tos = 0, hop_limit;
 
 	hdrlen = (osrh->hdrlen + 1) << 3;
 	tot_len = hdrlen + sizeof(*hdr);
@@ -138,30 +138,32 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
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
+	hop_limit = ip6_dst_hoplimit(skb_dst(skb));
+
 	if (skb->protocol == htons(ETH_P_IPV6)) {
-		ip6_flow_hdr(hdr, ip6_tclass(ip6_flowinfo(inner_hdr)),
-			     flowlabel);
-		hdr->hop_limit = inner_hdr->hop_limit;
+		inner_hdr = ipv6_hdr(skb);
+		hop_limit = inner_hdr->hop_limit;
+		tos = ip6_tclass(ip6_flowinfo(inner_hdr));
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
+
+	hdr = ipv6_hdr(skb);
+	ip6_flow_hdr(hdr, tos, flowlabel);
+	hdr->hop_limit = hop_limit;
 	hdr->nexthdr = NEXTHDR_ROUTING;
 
 	isrh = (void *)hdr + sizeof(*hdr);
-- 
2.17.1

