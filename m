Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2E929AA08
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 11:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421006AbgJ0KwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 06:52:05 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46972 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1420751AbgJ0Kv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 06:51:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id 2so1136925ljj.13
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 03:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=hEoYtEmQwh/NarmPyowUc0rNHPP9I0cUuiTpnspPp/Q=;
        b=wdpc4lTdD62jDRcOL3egX/oKLfCFGm4mGwMD4QbJ49JcAnBE5MMVhojNiSwAosNPwh
         i/AnCsCGd39HviuezJ11BUVER2CYtP5ERvjoRDM8p399KOW26A0BFXR30tfs9YHc7GTm
         xQxop7N8F4JcCl1a2KDwDAT+n6sae+p0M92MLOwsWG5WXSkx20zKvILvmp2gDMqkudDG
         VAEQUYXjbrRZTB29mjfevhQm5EXeR7gDPLlHSzL1IHFqS6W5nzBjs1Cb3Lx00X7iM6KP
         OhKU1mXHNuQCnusPB1m5nF8j+/0V+tUzeaGPl/XJo30YoxXWm2aOctZHRCgN1OE0AP8g
         0vjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=hEoYtEmQwh/NarmPyowUc0rNHPP9I0cUuiTpnspPp/Q=;
        b=GU70R0MkLnvdFbPTx9bbCxftnHGOSoCRNe1Ms5zarTfygx6AwStkUPWZE19EN9Sck1
         p4EKHxSeQiyhblYM/xG39+50r0/lhnjmaN/hBVCVyQu1VUaZojTqupthlKuHFaYrjsWN
         KKVBfDo6rKrggfA+i/bvSLbLsDv+fmTm4DvZgvweLSJAq6pNsr2X0Gkl7jhjjbMHnWm1
         7P2DyIVuQcqa1sJvqov9Ps5+Hozjztp1VI+T4OCLQbnwmhqf+M4jXHF6g7tNrA8hyba5
         6FjcOTsm076RCxjJrxxDSQxBhNJShgFhnD7MIMd6ktGd0cAgCjn+hwqFNG/KZs0OY6ki
         H9Vw==
X-Gm-Message-State: AOAM530PSE+3Kjgockm382f5vWewEjg5sLniPCcT65z1Hlth8vW3nRQs
        mUqSM1ROihi7ChC493z7aoZDstVbF0ZqPq7w
X-Google-Smtp-Source: ABdhPJwQhXIINERK1h2uKUjOVAXHp62UVJAXclJS/BbOV6qt2cF0j6pbO6Q912RreiaUsravyDA0NA==
X-Received: by 2002:a2e:80c2:: with SMTP id r2mr789923ljg.402.1603795916419;
        Tue, 27 Oct 2020 03:51:56 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s19sm134385lfb.224.2020.10.27.03.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 03:51:55 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets from lag devices
Date:   Tue, 27 Oct 2020 11:51:17 +0100
Message-Id: <20201027105117.23052-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201027105117.23052-1-tobias@waldekranz.com>
References: <20201027105117.23052-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Packets ingressing on a LAG that egress on the CPU port, which are not
classified as management, will have a FORWARD tag that does not
contain the normal source device/port tuple. Instead the trunk bit
will be set, and the port field holds the LAG id.

Since the exact source port information is not available in the tag,
frames are injected directly on the LAG interface and thus do never
pass through any DSA port interface on ingress.

Management frames (TO_CPU) are not affected and will pass through the
DSA port interface as usual.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa.c      | 23 +++++++++++++----------
 net/dsa/tag_edsa.c | 12 +++++++++++-
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 2131bf2b3a67..b84e5f0be049 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -220,7 +220,6 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	skb = nskb;
-	p = netdev_priv(skb->dev);
 	skb_push(skb, ETH_HLEN);
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
@@ -234,17 +233,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 		skb = nskb;
 	}
 
-	s = this_cpu_ptr(p->stats64);
-	u64_stats_update_begin(&s->syncp);
-	s->rx_packets++;
-	s->rx_bytes += skb->len;
-	u64_stats_update_end(&s->syncp);
+	if (dsa_slave_dev_check(skb->dev)) {
+		p = netdev_priv(skb->dev);
+		s = this_cpu_ptr(p->stats64);
+		u64_stats_update_begin(&s->syncp);
+		s->rx_packets++;
+		s->rx_bytes += skb->len;
+		u64_stats_update_end(&s->syncp);
 
-	if (dsa_skb_defer_rx_timestamp(p, skb))
-		return 0;
-
-	gro_cells_receive(&p->gcells, skb);
+		if (dsa_skb_defer_rx_timestamp(p, skb))
+			return 0;
 
+		gro_cells_receive(&p->gcells, skb);
+	} else {
+		netif_rx(skb);
+	}
 	return 0;
 }
 
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 120614240319..800b02f04394 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -86,6 +86,7 @@ static struct sk_buff *edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 				struct packet_type *pt)
 {
+	bool trunk = false;
 	u8 *edsa_header;
 	int frame_type;
 	int code;
@@ -120,6 +121,7 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 		break;
 
 	case FRAME_TYPE_FORWARD:
+		trunk = !!(edsa_header[1] & 7);
 		skb->offload_fwd_mark = 1;
 		break;
 
@@ -133,7 +135,15 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	source_device = edsa_header[0] & 0x1f;
 	source_port = (edsa_header[1] >> 3) & 0x1f;
 
-	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
+	if (trunk) {
+		struct dsa_port *cpu_dp = dev->dsa_ptr;
+
+		skb->dev = dsa_lag_dev_by_id(cpu_dp->dst, source_port);
+	} else {
+		skb->dev = dsa_master_find_slave(dev, source_device,
+						 source_port);
+	}
+
 	if (!skb->dev)
 		return NULL;
 
-- 
2.17.1

