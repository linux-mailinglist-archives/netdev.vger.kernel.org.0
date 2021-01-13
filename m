Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D14C2F46C6
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbhAMIoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbhAMIoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:44:38 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F63FC0617A4
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:47 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id y22so1603561ljn.9
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=WxzaFX+fxgdMYuoXdwfDg6QYJrlQ84AA/FpaoU5//zw=;
        b=NATJp2vkS4PBuqIrfMbMXDlvovXDy3xg31hNtCduyO+4J0EMbFBWksUHnwOg+lgeNE
         2/RD2/k+bk6bL1mDu14Kz6hBed/TNsIlW6957WJKQIVtFADPmw6sZ8PoNC5GzNy5LvJa
         mwFOjQr2kaqyTi3XLL/QeeM8G1WxWXEkyFOimZxC1Sxx14GH7bscv3JZOWe0yt2qULMq
         O2Fcfbba7MFzZDcR7sSDwKX/xz4QlDPn7zuMWKxJC1dsRnXeVk2aZ2u/XMPQV+vJCr0b
         WLmtX85pO3akZXrn9CjKE8sVGlXUrLlnNzaHK8mnDNxJsWUI4nZ5HVrvaLuEY8VYuhDS
         H2Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=WxzaFX+fxgdMYuoXdwfDg6QYJrlQ84AA/FpaoU5//zw=;
        b=H+3DmvECSp3Khg+1fbAzb9njG+cYgpGiksOe8879pu0aWuvO9QwpmfomTwb10NqYdB
         qJ8Y0D/mqwtGNgGzkuHq+8kNXsGUHExzkk6O5OHy8WqUReaUaRyF2G8aNR/4hsP92nPq
         hnN0AsWaDn1mVmKaBy0Fd0WTYadCTZLdENjXfF/6zge6VL6QkpZCHlj22no8RoBLpU7b
         z/GieiaF9uOzShjPwnKjE2aBnSbiVAEZ+M9y5Lh/zQ+Az6JhRa3aUhb8sH7xwyxTUIOf
         TR0yFO8umirayvp63fEa4Juiv+BB3WClm+0Id7/O+RBBoHYXESKDWaxSxSvpX+/UKgD3
         hVRA==
X-Gm-Message-State: AOAM530D0os4Zu0CtEfjK/DmSMuV/7sULEPZE9poIMEanZhnoTH20Baa
        gGasiDLFf3z09HPdtoAR1wqQ7w==
X-Google-Smtp-Source: ABdhPJzdkkWlYjnp76MPh8Z6S0TK9zYv1jzQ4MdIl/gd9v3G7CsC3+9d81vRVnB+aJJ+lflLdrbdrQ==
X-Received: by 2002:a2e:9b1a:: with SMTP id u26mr465396lji.187.1610527425891;
        Wed, 13 Jan 2021 00:43:45 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u14sm137027lfk.108.2021.01.13.00.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 00:43:45 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v5 net-next 5/5] net: dsa: tag_dsa: Support reception of packets from LAG devices
Date:   Wed, 13 Jan 2021 09:42:55 +0100
Message-Id: <20210113084255.22675-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113084255.22675-1-tobias@waldekranz.com>
References: <20210113084255.22675-1-tobias@waldekranz.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/dsa.c     | 12 +++++++++++-
 net/dsa/tag_dsa.c | 17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index df75481b12ed..f4ce3c5826a0 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -219,11 +219,21 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	skb = nskb;
-	p = netdev_priv(skb->dev);
 	skb_push(skb, ETH_HLEN);
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
+		/* Packet is to be injected directly on an upper
+		 * device, e.g. a team/bond, so skip all DSA-port
+		 * specific actions.
+		 */
+		netif_rx(skb);
+		return 0;
+	}
+
+	p = netdev_priv(skb->dev);
+
 	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
 		nskb = dsa_untag_bridge_pvid(skb);
 		if (!nskb) {
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 112c7c6dd568..7e7b7decdf39 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -163,6 +163,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
 	int source_device, source_port;
+	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -174,6 +175,8 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
 		skb->offload_fwd_mark = 1;
+
+		trunk = !!(dsa_header[1] & 7);
 		break;
 
 	case DSA_CMD_TO_CPU:
@@ -216,7 +219,19 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	source_device = dsa_header[0] & 0x1f;
 	source_port = (dsa_header[1] >> 3) & 0x1f;
 
-	skb->dev = dsa_master_find_slave(dev, source_device, source_port);
+	if (trunk) {
+		struct dsa_port *cpu_dp = dev->dsa_ptr;
+
+		/* The exact source port is not available in the tag,
+		 * so we inject the frame directly on the upper
+		 * team/bond.
+		 */
+		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port);
+	} else {
+		skb->dev = dsa_master_find_slave(dev, source_device,
+						 source_port);
+	}
+
 	if (!skb->dev)
 		return NULL;
 
-- 
2.17.1

