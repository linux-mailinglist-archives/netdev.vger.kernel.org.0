Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236623407AA
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhCROQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhCROQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:19 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEE7C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:19 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id b83so4842966lfd.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=bKcpC2dDbqfbjiG681wmb/mxrXsgkE1mtyFpi5i8rCY=;
        b=q9HLF0gL5YZkkvdeYLgSF8udx+Jm6FyH5//ahHrU2flf2mKZMsg9FihqGEiEF4Xs1B
         0lZ4T0cSA2TKgdGirvjWrSxWDaX+CH3zFLRT6xqaa0bvYdlXkpe9IiS8pj1+LZ8p86cj
         V9EbBIS1nxLIFFI94F+U8I7b+LruhgMHNBwn0Hu6IiSi6RK8zDafDprLjTPOUt9P9YDH
         STn1V2iJ7kqEDdDS9KKHvKfS2RdxrMPhho+1Qt0M115pubKlufEu8uTgPHF6ucQ39iXx
         ZWx6r4Tui/VpcWJqSkhmX4YTgBhJPBCfkUVkmu780w3IvBSfOx1dgEyYmooLXRvHBOSa
         uqaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=bKcpC2dDbqfbjiG681wmb/mxrXsgkE1mtyFpi5i8rCY=;
        b=lWCGcQcjVM5hpZHSkVcFP5mi2+gzepYV922rYigNZ1jPZH/oGSqVKn1Du7kB409N/M
         fjibnyjO8vJPhPm4YkFO0MIcNoH9b7ICxYS5kBP72q+mnrtBylrEOpq9Vs10rEiw5yD1
         CnRlV2fqX+fXj30+QjgZjs7ZD0+MXs+61h2Dzt5ikAbRn6WJQYBohU8HOznHOpUj9Bz+
         DOpkCvqXXoXdyQzwYNPC5+JTLsSJqTwFoYgcdB1O/mcbdpE+ZaV2X1shIYUv2KZKNgoU
         FldnJ9UMbF2tuKm07swCOuwkLw4G5xZVEbpAxaBoygT8E7P147NAM4pBWZcBxmJgFfaK
         xD6w==
X-Gm-Message-State: AOAM533O4inhlxfx56+2iEyRMQEH1zVkN2ivOsUrC92TgzCiXw8QnSVQ
        vMQsafrfExoa623drH9xhlIhHw==
X-Google-Smtp-Source: ABdhPJyZRUTJswl6msc6OMqn7oPc5zZw2dBcbozRnRMKRN6Yf1ydT86a0nvaZO0ny8tWVHODLPjCmg==
X-Received: by 2002:a19:ae0a:: with SMTP id f10mr5393048lfc.118.1616076977836;
        Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:17 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 8/8] net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
Date:   Thu, 18 Mar 2021 15:15:50 +0100
Message-Id: <20210318141550.646383-9-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These switches have two modes of classifying broadcast:

1. Broadcast is multicast.
2. Broadcast is its own unique thing that is always flooded
   everywhere.

This driver uses the first option, making sure to load the broadcast
address into all active databases. Because of this, we can support
per-port broadcast flooding by (1) making sure to only set the subset
of ports that have it enabled whenever joining a new bridge or VLAN,
and (2) by updating all active databases whenever the setting is
changed on a port.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 73 +++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7976fb699086..3baa4dadb0dd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1982,6 +1982,21 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 	int err;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		struct dsa_port *dp = dsa_to_port(chip->ds, port);
+		struct net_device *brport;
+
+		if (dsa_is_unused_port(chip->ds, port))
+			continue;
+
+		brport = dsa_port_to_bridge_port(dp);
+
+		if (dp->bridge_dev &&
+		    !br_port_flag_is_set(brport, BR_BCAST_FLOOD))
+			/* Skip bridged user ports where broadcast
+			 * flooding is disabled.
+			 */
+			continue;
+
 		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
 		if (err)
 			return err;
@@ -1990,6 +2005,53 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 	return 0;
 }
 
+struct mv88e6xxx_port_broadcast_sync_ctx {
+	int port;
+	bool flood;
+};
+
+static int
+mv88e6xxx_port_broadcast_sync_vlan(struct mv88e6xxx_chip *chip,
+				   const struct mv88e6xxx_vtu_entry *vlan,
+				   void *_ctx)
+{
+	struct mv88e6xxx_port_broadcast_sync_ctx *ctx = _ctx;
+	u8 broadcast[ETH_ALEN];
+	u8 state;
+
+	if (ctx->flood)
+		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
+	else
+		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED;
+
+	eth_broadcast_addr(broadcast);
+
+	return mv88e6xxx_port_db_load_purge(chip, ctx->port, broadcast,
+					    vlan->vid, state);
+}
+
+static int mv88e6xxx_port_broadcast_sync(struct mv88e6xxx_chip *chip, int port,
+					 bool flood)
+{
+	struct mv88e6xxx_port_broadcast_sync_ctx ctx = {
+		.port = port,
+		.flood = flood,
+	};
+	struct mv88e6xxx_vtu_entry vid0 = {
+		.vid = 0,
+	};
+	int err;
+
+	/* Update the port's private database... */
+	err = mv88e6xxx_port_broadcast_sync_vlan(chip, &vid0, &ctx);
+	if (err)
+		return err;
+
+	/* ...and the database for all VLANs. */
+	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_broadcast_sync_vlan,
+				  &ctx);
+}
+
 static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 				    u16 vid, u8 member, bool warn)
 {
@@ -5609,7 +5671,8 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5663,6 +5726,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 			goto out;
 	}
 
+	if (flags.mask & BR_BCAST_FLOOD) {
+		bool broadcast = !!(flags.val & BR_BCAST_FLOOD);
+
+		err = mv88e6xxx_port_broadcast_sync(chip, port, broadcast);
+		if (err)
+			goto out;
+	}
+
 out:
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.25.1

