Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3026340E32
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbhCRT03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbhCRTZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C55C06175F
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:53 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 12so4236323wmf.5
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=VqQsQdax3O/Z0p8kDLBVJ5i6JwBjqgRFd6jB/taEUBg=;
        b=uA1pUvcYXeSSSyCG/JnK5V+MAmwkIRjkDK9mfTl69D1kX2+Wc6UGTYDDCGGI305yQu
         cgrAGcnm3bh6E8zrtSqHf3jBZns2eCDEtNE3yC2diYgKkNoO7NKyiVikKxQTBcCo1S4V
         768tHp6C6EXd/aDsQvceFY7jaCx7Ry/6+aWFguYuOlpx9Jtzt85fC/vhvqaLWFimqZcf
         V93us555WtDXdYDcfYS6kLp4zvnLGtXRI7yL1Z/CerVlyoPWS/srjVsmtcGEKB5cRVUT
         fDI3ZPnBqkXNE3F2lbMJDTyCLC8UFtrGerVGfIkWHeYQWz/CTN4XQMnOJNok9PDgS9zr
         gHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=VqQsQdax3O/Z0p8kDLBVJ5i6JwBjqgRFd6jB/taEUBg=;
        b=uhphmYfBjZ19xasHp/2Tdl1kryb3uxLTrFVBArqOZtTuGCrMLmvKqSpV7LqgHgQs0B
         OVusWZiFBSuki5j6lRb3S8yDT5rEsVc4K+MnVUGa0HAvxJIWMW+kXyZhaRQabhUbBxow
         KJbRdHsMR+Sj5GiAmPfOii/XZJnnrXFfMQLisH+QCk1+lYrgj+uHhqA0se8JPIhbYNv/
         hnPfCkriQWgJ6GDysjKS2q8u+/U7Sir9NS2fPwaabU68qRSDQZZYe+J1yqCX87+/+Gmf
         ioKKorPesFyUAVD7gNu5oWewY9FXoRYvArtt9SnlJYF1Rsqsz6+vgwbgZMNX9pbXHtAv
         UqOg==
X-Gm-Message-State: AOAM5324/8mX4jXZwETwLlowjgNMMnIhBqXgkQ3hD5BC3oyWy3hQrBEv
        Am6q5bX+5cQaYr0xrRCyNgJYfA==
X-Google-Smtp-Source: ABdhPJy9yWoLSYz3GCvpNT0dg8FdaCQj17oHcqQKfEElF8nGPBMXSbqR1MBtrw1A5bOZ2rp+grkmaQ==
X-Received: by 2002:a1c:ac02:: with SMTP id v2mr8708wme.111.1616095552035;
        Thu, 18 Mar 2021 12:25:52 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:51 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 8/8] net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
Date:   Thu, 18 Mar 2021 20:25:40 +0100
Message-Id: <20210318192540.895062-9-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 71 +++++++++++++++++++++++++++++++-
 1 file changed, 70 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7976fb699086..95f07fcd4f85 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1982,6 +1982,19 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
 	int err;
 
 	for (port = 0; port < mv88e6xxx_num_ports(chip); port++) {
+		struct dsa_port *dp = dsa_to_port(chip->ds, port);
+		struct net_device *brport;
+
+		if (dsa_is_unused_port(chip->ds, port))
+			continue;
+
+		brport = dsa_port_to_bridge_port(dp);
+		if (brport && !br_port_flag_is_set(brport, BR_BCAST_FLOOD))
+			/* Skip bridged user ports where broadcast
+			 * flooding is disabled.
+			 */
+			continue;
+
 		err = mv88e6xxx_port_add_broadcast(chip, port, vid);
 		if (err)
 			return err;
@@ -1990,6 +2003,53 @@ static int mv88e6xxx_broadcast_setup(struct mv88e6xxx_chip *chip, u16 vid)
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
@@ -5609,7 +5669,8 @@ static int mv88e6xxx_port_pre_bridge_flags(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 
-	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+	if (flags.mask & ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD |
+			   BR_BCAST_FLOOD))
 		return -EINVAL;
 
 	ops = chip->info->ops;
@@ -5663,6 +5724,14 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
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

