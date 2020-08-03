Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6647A23AC33
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgHCSO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:14:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB37BC06174A;
        Mon,  3 Aug 2020 11:14:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id 88so35048640wrh.3;
        Mon, 03 Aug 2020 11:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xYmgJ9q6WmAiysmjl1lzv94xYZ4lfXJx4yvPnQA+3M0=;
        b=LXLalZvPCz2jqU161ucRPSMW06oGrqpvKoH27x0ATSl192G+i8fP5C3Nl9qTtXQ4B9
         +KLA1W4n4lhfeer4dMuQq8d5LvW13W3GQvCD8TIOtUQJdVFqWajJOiS8wMMEi0fRZBJY
         B4HMmbnZEHUtKaeMO/UOzqX+nG/czudlreN0nF7GraHW6HQ1XmgOXaatRlgUULLl9q4l
         g6Kd5SSb8uxifr7WywcN1UwA4Af3DUcLuhUY2Bn73oRXnh+HKa4Oct2bON2rpsJQ6Qxo
         wcm3ZWrbQ6DnPRxyAdn1cZUcVYVPVBnAWqyS7ROW9iq9XuK0N7qIIBFJYYDv9tGG1GA5
         AuAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xYmgJ9q6WmAiysmjl1lzv94xYZ4lfXJx4yvPnQA+3M0=;
        b=Kj9wKYTiMjvO56ziX9Jtqa5YNhHOI/66qTELB7ZpVkiYy+bWNNfknl0urrugSe4b/a
         3/RVAhOnt0UJ0ENRh/XuqUljMiO0hVe0/0+cJzQ488QLdg0DjEXi5oZzAyi3ASq5WKow
         T52WTORPJPtWp5kKeUnoJIhfrYfiS9pxJCPByIHntXQrg+4Sq4A0Z8KX+hL/aMwxwn/q
         8rkfA/yu8ly3J6K2uJRPs2cWwbwmXzjYekYlkNfCU9HmoIV7nuSvrtGZfr2rzLEri7nL
         AMDrCQJ2OFrGfci0kWw6tCMxkKQfNOWHFwJcFAuqnkXQlGzQyii2TLDXMq0Qh0b5DJVV
         +SUw==
X-Gm-Message-State: AOAM532S1cKbNeC4fyIkh+H+6K6odZcUQtAuHpnbtzMxxc2FWZNsbown
        RyqdSv9pDAIGzKTqbjzLdRg=
X-Google-Smtp-Source: ABdhPJyMr45lC/evGy9WXmIvt25trODkkhEKUYG93zlPxp2YZMwv0I2e0z1BFB7LEAnQc7E9RBIBSQ==
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr14970147wrx.33.1596478466650;
        Mon, 03 Aug 2020 11:14:26 -0700 (PDT)
Received: from ubuntu18_1.cisco.com ([173.38.220.35])
        by smtp.gmail.com with ESMTPSA id p25sm549060wma.39.2020.08.03.11.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 11:14:26 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
Cc:     Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: [net-next v2] seg6: using DSCP of inner IPv4 packets
Date:   Mon,  3 Aug 2020 18:14:17 +0000
Message-Id: <20200803181417.1320-1-ahabdels@gmail.com>
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
 net/ipv6/seg6_iptunnel.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index e0e9f48ab14f..79abbfc95739 100644
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
@@ -109,10 +108,10 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net *net = dev_net(dst->dev);
-	struct ipv6hdr *hdr, *inner_hdr;
 	struct ipv6_sr_hdr *isrh;
 	int hdrlen, tot_len, err;
-	__be32 flowlabel;
+	struct ipv6hdr *hdr;
+	__be32 flowlabel, tos = 0;
 
 	hdrlen = (osrh->hdrlen + 1) << 3;
 	tot_len = hdrlen + sizeof(*hdr);
@@ -121,31 +120,31 @@ int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh, int proto)
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

