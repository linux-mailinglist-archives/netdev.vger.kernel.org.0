Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486B64A68F1
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243167AbiBBAEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243070AbiBBAE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:26 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92E3C061758;
        Tue,  1 Feb 2022 16:04:24 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id u24so37670076eds.11;
        Tue, 01 Feb 2022 16:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qXor+97ZJrWJJG2GzxBd/cPWc63u+eVCQOmFrvGNqks=;
        b=JLO0Bp+iG4Om3w/Wesfzwz9MZuqTJLIdVer0S3Qyj2YNR0wjSH5udHH2TY3GBRPoZi
         OoVWEwxOlVMYesLWLeRMguooXOT+ktPY8t8IE/ipPamnsQGnqMwwHSS1erD55wdKT6XY
         oG90AY3C2Dh3o54y5FWctKbD1flZo3n6KtCeGJrPJXS4Ii1stIqNni6B9BPBR9RV0v3/
         3bpJXh3PWmHPZTbg8ScMwMFCReExwm1OeVdHbVLdGnu4yemCYNOXp7Dc954JjwBG8f4Z
         Cj6v+i19EPbGAKLJ2rgFibtiCM8fEYXII99ZS/xja0r7vAduXyO+H+9e/Lh4qnL+Jkcc
         YvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qXor+97ZJrWJJG2GzxBd/cPWc63u+eVCQOmFrvGNqks=;
        b=L4U6Xji3H68LGEG8VG8TOBs5orJMGGS5fYQSJ3R5Nq32okDAc9vZQqbmn0K6i71UxT
         rG9dBSgOwtKxjNQf63wPIgxtLmQc7aFy8QJhSXGvqIZ9aQQ84J4sA6zICnbn8Sqe0Uwi
         YrPgwUUNTU92qbG57w9IcEVzZeKpRmzm3w6ZUhtpzIQLlbvT9q+IeyN0sJQ/u+/X2xKW
         HKrabol7cSC6zcHe7gLKiILE8N7QO3+z6fsWgk3DCXW2u31kbUKpfxW6/vQ/sBisRvih
         iPs3QFCxR63hZuA8LqOhq9juXvc0Eh89Oyq7lypMXu3ghyJBnRhTDTewWge1FWIjIOQU
         kjVw==
X-Gm-Message-State: AOAM532j6Z34ksOgWt5Z9R/GjPBvJeiO4NrPS1nrk2wPPilFm7PgO1Ee
        URyTnhUEhYCLWqbTpAzw73Y=
X-Google-Smtp-Source: ABdhPJxWvaNlLYV1ADE92nW+4VZyPEXsEcJVSNsZCKwkhbdMM2ys3GVKeCdTafW+GCknl5H6ta5pkA==
X-Received: by 2002:a05:6402:2071:: with SMTP id bd17mr28006923edb.330.1643760263403;
        Tue, 01 Feb 2022 16:04:23 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:23 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 09/16] net: dsa: qca8k: add tracking state of master port
Date:   Wed,  2 Feb 2022 01:03:28 +0100
Message-Id: <20220202000335.19296-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO/MIB Ethernet require the master port and the tagger availabale to
correctly work. Use the new api master_state_change to track when master
is operational or not and set a bool in qca8k_priv.
We cache the first cached master available and we check if other cpu
port are operational when the cached one goes down.
This cached master will later be used by mdio read/write and mib request to
correctly use the working function.

qca8k implementation for MDIO/MIB Ethernet is bad. CPU port0 is the only
one that answers with the ack packet or sends MIB Ethernet packets. For
this reason the master_state_change ignore CPU port6 and only checks
CPU port0 if it's operational and enables this mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/qca8k.c | 15 +++++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..ec062b9a918d 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2383,6 +2383,20 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
 	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
+static void
+qca8k_master_change(struct dsa_switch *ds, const struct net_device *master,
+		    bool operational)
+{
+	struct dsa_port *dp = master->dsa_ptr;
+	struct qca8k_priv *priv = ds->priv;
+
+	/* Ethernet MIB/MDIO is only supported for CPU port 0 */
+	if (dp->index != 0)
+		return;
+
+	priv->mgmt_master = operational ? (struct net_device *)master : NULL;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2418,6 +2432,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.master_state_change	= qca8k_master_change,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..b81aad98a116 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -353,6 +353,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

