Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40402B9573
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgKSOpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbgKSOpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:45:51 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42A0C061A04
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:49 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id y16so6522630ljh.0
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=NOpr5mhii6j42MIlvIKSVtrSs5/W16BZnHNpKqxkoCO7aCV9srUneNuic/QfDA+9zs
         KvUqXZi6DPDsvrudSzzEblMGupfcXy46DIl1j+VVXA1925wBaTs1JoY7qFAeA8Y2Ooev
         HMelkrBKfp1pr+U7w+ltxBBqul3cEfclQBr6hVGQUwCFVz9z0Fw82vmIRY5T1sox4/xr
         8rtonTtYIfXV5IiIitePcM4akD2yWxivX0zuA4c1zxHrkKELoBS9cZnzlAwTjEvE+dM5
         2iN0YOp1RrRRDpxh9rzcKubo3pGCZBqKFgxJl8Gdvy67ty5kSuije4tOJoPkQLe/p1K+
         Ej2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=/KfAZdLcKAvjrpDU1E/2WOowI2qRomiaywYSfqciaZg=;
        b=klzKyTt5/fqW33cb4hN11i8Yw1d9o27pS2atcOkVK0J4eSq1frHOp99OKgo7lBD+dz
         GNnaElBvI48AKkolwTleRWhYGLKRUKjzXBpNkkvqTZeDBEGkMa0UwVWETLxPa9UXs3h7
         slDISKXRFWJ7mTFB4ewrJaNcu5YRv9UNDfiQjTYR8o4FbKNPfIHU5Q9nQfOqXZ1RX6ae
         LG+WoEj+t/9iGNX9EM0onv0f3FV42kNsnOXsN5FZhPhJv4S78viabjRMcYlOZY0rYRuK
         8COLJVbygx5BROOJoU0r5vznbEfN782QpHv8AM+M4bzn2keh9n2z4MoSLFlLcZdLTpgw
         2ysw==
X-Gm-Message-State: AOAM533WtlMME7Oip1SryW2fAFAlDKYUWH1WgFUw7DYJjGokKaHe8WQA
        XhxiK/IO45Lghk+KdXcBIeC6kA==
X-Google-Smtp-Source: ABdhPJyXitYs8ZCurEy1fvGkrvKuXIVYOjKXeUgNr3G3TRIM8r7gSfE2VPKpiWFpiswCNyHSmFnRyQ==
X-Received: by 2002:a05:651c:11c6:: with SMTP id z6mr6383251ljo.414.1605797148278;
        Thu, 19 Nov 2020 06:45:48 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 123sm3993483lfe.161.2020.11.19.06.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:45:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: tag_dsa: Support reception of packets from LAG devices
Date:   Thu, 19 Nov 2020 15:45:08 +0100
Message-Id: <20201119144508.29468-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119144508.29468-1-tobias@waldekranz.com>
References: <20201119144508.29468-1-tobias@waldekranz.com>
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
 net/dsa/dsa.c     | 12 +++++++++++-
 net/dsa/tag_dsa.c | 17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index a1b1dc8a4d87..7325bf4608e9 100644
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
index 112c7c6dd568..be7271de8d0b 100644
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

