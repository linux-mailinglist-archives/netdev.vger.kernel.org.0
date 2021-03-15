Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C19433C851
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhCOVPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhCOVPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:11 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F2AC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:10 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id t18so11345345lfl.3
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=OxZK0EpkWuwxaCH5ICgb9sgxnbVsd3E2N4MHrwUkx8s=;
        b=dXlQ7SMyfSmLSUU+sWRXv4FZ3LEx89DlUxfp5Jq9BMN24TdhoJlQVurWPJnA609uGY
         96MQF9nowa5GexugRSVdSWKANLEgkCsA+F9ZyeqHbSFVcr4tdVwXU0MYX/tNwUiwzJWg
         OHSgZOStmZ8HMWnGvhgAL43HKJE4Gi17qFY/y2gRrCDCMTyPvNNSfRHSuDCx/2Pxb1G7
         nr+AaTtsSEQQ9U+0OQhVkSx+LXkGuzel4SbY6RohHKHf5EirbLak5LeQctOm2jA7vwlG
         W5LwSY33E8UuWL/0GCyeZxDdDRmhB9QwPOp3zKYRvHIhhs8Xo8k+K0VoGJlTpn6wnPee
         FxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=OxZK0EpkWuwxaCH5ICgb9sgxnbVsd3E2N4MHrwUkx8s=;
        b=Wvh125NbfoIQGimFd6RDhAPdpDEsLZxN8cmLlHJky4CzFHhH/ksRA7aeC2Ni5RHwoT
         xPXOyfaqEQPekhu2HfuKvkaIVCRGtPF8AaOKvTl8QgWboUvLKoOBzCnKuxBBH4k0Xh0j
         ds7ECyDOiONVP+Pnnh/kztoZdqIJUAZJ40gzgIPqHLO67/jGxYiXfyCS2sqhxv+mcoof
         t4vq5PLVItIKftix6l4pA4mBzeGhCYMlRnL5ovei5oYcYQMSSiuCypRURhz7CKc5usiB
         /bt/sdv87UC7l6lpYVbTt65+iAFFpGkL6UrOFv0mtFg9NakSDRhYy0Idx7gq+uASUAkg
         GUOQ==
X-Gm-Message-State: AOAM531kkt7OrOdJXf2C8Bz1JlAYvhP46fFMzYuKVmr/uGaqkdalcOgq
        62K+F/XGbgZmTBhY/LANebuscA==
X-Google-Smtp-Source: ABdhPJz4o+QshmOCB9zoagYuFW5MY9OmiyLkJzXGocOJ/0w0ye/kQIlNbfEA/AsS5nZBOYUL89bvmw==
X-Received: by 2002:ac2:5e62:: with SMTP id a2mr9722608lfr.385.1615842909237;
        Mon, 15 Mar 2021 14:15:09 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
Date:   Mon, 15 Mar 2021 22:14:00 +0100
Message-Id: <20210315211400.2805330-6-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315211400.2805330-1-tobias@waldekranz.com>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
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
 drivers/net/dsa/mv88e6xxx/chip.c | 68 +++++++++++++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 48e65f22641e..e6987c501fb7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1950,6 +1950,18 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 	int err;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		struct dsa_port *dp = dsa_to_port(chip->ds, port);
+
+		if (dsa_is_unused_port(chip->ds, port))
+			continue;
+
+		if (dsa_is_user_port(chip->ds, port) && dp->bridge_dev &&
+		    !br_port_flag_is_set(dp->slave, BR_BCAST_FLOOD))
+			/* Skip bridged user ports where broadcast
+			 * flooding is disabled.
+			 */
+			continue;
+
 		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
 		if (err)
 			return err;
@@ -1958,6 +1970,51 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
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
+	const char broadcast[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	struct mv88e6xxx_port_broadcast_sync_ctx *ctx = _ctx;
+	u8 state;
+
+	if (ctx->flood)
+		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC;
+	else
+		state = MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED;
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
@@ -5431,7 +5488,8 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5480,6 +5538,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
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

