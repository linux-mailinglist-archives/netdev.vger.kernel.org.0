Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB06496F80
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiAWBeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235262AbiAWBdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:52 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BDDC061401;
        Sat, 22 Jan 2022 17:33:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id z22so49510181edd.12;
        Sat, 22 Jan 2022 17:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NVeC3B2Yit618jzzQLJaDTN+I7pHw/ZBk6dm6ruYyvo=;
        b=eYygCN20TJe1WXBqXMPIhCErvz3siyHiMJ1GhIsYx/NzcFFP554HDIAwttBp7D7iGt
         tTpu6T1TKYPAN3YCoXr5o23TQ07qUsa+G9ycA3kUQwkZEzKO8BIz8QsH0Y9tgucOC17v
         Omhz7BcES+6WzjUAv7SwLJX1l5X9aNoXDzKyWmHv/LIQFNYIc+0+Ws4mhS7VXMXlHZRh
         mKYRRveeajUHZRl/namXADxKQituStEF8KvjDpInUAMMO/55AZJ14zZ6aoMqJWhWEEt7
         sefd2Jpi57PrxjJqCIJ9oE9KLc634SJ36INcc1kJ0Dq+wFXwbUOENluj6y6Vf0CaYuPb
         24pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NVeC3B2Yit618jzzQLJaDTN+I7pHw/ZBk6dm6ruYyvo=;
        b=UFltOK9HLVJYYxExaolq974RHoqLkqtQZ/KzyxhpHSYa3t+9mFXYEMnD1Tc8xL622e
         0By/p534y63pzuxrqAm4vAfHxYmZy8L6I7WBYHp8+SBfqzGQkCbI6ucj2ltzN7TlX/dK
         it1gB8k1rSarEeHahExYebXcEG0aHavOgd8uGWwEoJJddtcNUh45lGRo4ejDDE9nDaii
         lYjKUaTvWzdIzI9KzuSnLt0EwKtfwGCLyZ1xrF079aYPowJdXbGUeb7KCnFqHbUPU2FF
         zapZWTkiSMrwj4/mYHwBfgf7SeLM/A3ZYy60DN4Lybgn2gOo+53Nrw+2kOJUocIhKJ1z
         /wEA==
X-Gm-Message-State: AOAM5325KO9ysB2hXLQbi5X5WtIYckEEPjapEYYiQMg0t9fgtDUdmTHG
        a32SRiHzRkpQWO/YZIXIcGw=
X-Google-Smtp-Source: ABdhPJzlnR3eV37hzAh64GIT3dqvTMorSnte7rs2c1QJTe51kqzmFBpa3ZX79VV26PhANanEc+C4uQ==
X-Received: by 2002:a05:6402:5203:: with SMTP id s3mr10130309edd.27.1642901630266;
        Sat, 22 Jan 2022 17:33:50 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:49 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 09/16] net: dsa: qca8k: add tracking state of master port
Date:   Sun, 23 Jan 2022 02:33:30 +0100
Message-Id: <20220123013337.20945-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
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
this reason the master_state_change ignore CPU port6 and checkes only
CPU port0 if it's operational and enables this mode.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 18 ++++++++++++++++++
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 039694518788..4bc5064414b5 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2383,6 +2383,23 @@ qca8k_port_lag_leave(struct dsa_switch *ds, int port,
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
+	if (operational)
+		priv->mgmt_master = master;
+	else
+		priv->mgmt_master = NULL;
+}
+
 static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_tag_protocol	= qca8k_get_tag_protocol,
 	.setup			= qca8k_setup,
@@ -2418,6 +2435,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.get_phy_flags		= qca8k_get_phy_flags,
 	.port_lag_join		= qca8k_port_lag_join,
 	.port_lag_leave		= qca8k_port_lag_leave,
+	.master_state_change	= qca8k_master_change,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index ab4a417b25a9..9437369c60ca 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -353,6 +353,7 @@ struct qca8k_priv {
 	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	unsigned int port_mtu[QCA8K_NUM_PORTS];
+	const struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 };
 
 struct qca8k_mib_desc {
-- 
2.33.1

