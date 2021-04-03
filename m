Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FE63533DB
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 13:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhDCLtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 07:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236632AbhDCLtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 07:49:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE58C061788
        for <netdev@vger.kernel.org>; Sat,  3 Apr 2021 04:49:06 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSelp-0000eq-6s; Sat, 03 Apr 2021 13:48:53 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lSell-0007xX-ML; Sat, 03 Apr 2021 13:48:49 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH net-next v1 1/9] net: dsa: add rcv_post call back
Date:   Sat,  3 Apr 2021 13:48:40 +0200
Message-Id: <20210403114848.30528-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210403114848.30528-1-o.rempel@pengutronix.de>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switches (for example ar9331) do not provide enough information
about forwarded packets. If the switch decision was made based on IPv4
or IPv6 header, we need to analyze it and set proper flag.

Potentially we can do it in existing rcv path, on other hand we can
avoid part of duplicated work and let the dsa framework set skb header
pointers and then use preprocessed skb one step later withing the rcv_post
call back.

This patch is needed for ar9331 switch.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 include/net/dsa.h | 2 ++
 net/dsa/dsa.c     | 4 ++++
 net/dsa/port.c    | 1 +
 3 files changed, 7 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b2c49f72f4..f1a7aa4303a7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -84,6 +84,7 @@ struct dsa_device_ops {
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
+	void (*rcv_post)(struct sk_buff *skb);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
 			     int *offset);
 	/* Used to determine which traffic should match the DSA filter in
@@ -247,6 +248,7 @@ struct dsa_port {
 	struct dsa_switch_tree *dst;
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev,
 			       struct packet_type *pt);
+	void (*rcv_post)(struct sk_buff *skb);
 	bool (*filter)(const struct sk_buff *skb, struct net_device *dev);
 
 	enum {
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 84cad1be9ce4..fa3e7201e760 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -249,6 +249,10 @@ static int dsa_switch_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb->pkt_type = PACKET_HOST;
 	skb->protocol = eth_type_trans(skb, skb->dev);
 
+
+	if (cpu_dp->rcv_post)
+		cpu_dp->rcv_post(skb);
+
 	if (unlikely(!dsa_slave_dev_check(skb->dev))) {
 		/* Packet is to be injected directly on an upper
 		 * device, e.g. a team/bond, so skip all DSA-port
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 01e30264b25b..859957688c62 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -720,6 +720,7 @@ void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 {
 	cpu_dp->filter = tag_ops->filter;
 	cpu_dp->rcv = tag_ops->rcv;
+	cpu_dp->rcv_post = tag_ops->rcv_post;
 	cpu_dp->tag_ops = tag_ops;
 }
 
-- 
2.29.2

