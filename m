Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B64E192C31
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgCYPW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46341 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgCYPWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so3550917wru.13
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tvQtsw0ICTvjn7fc59FPmyf50Xjv75M/Lj9Ga3yqMGo=;
        b=QEGJRDGf0JVThrbSUH+h7NStEwfHb932hjAZAtXO4A0sRVZd49v6eDxaYhcbq/csGf
         pRa63GZdnkKtNNU8fyM1zu+48Y4IUC3H2MpLR83PwFW8oYTsRk/9D70mKUMnl8vf2kD2
         LX57pky5WorlUwdwLbQuUQrDuIJGB6v+y8mrCIRVte6Brhgh7DdrkqbwiPYICyG4vj/3
         1X1P5gBUw4qQH493XYM/xgeEDTGBn05RZJPLk3EALlOIeOQKa+aAbBXj0M8U3eXO5h8n
         UChMRgFcYU2D1xwSiu01u98nW2QyFzk6nPC3iTdE7bVL954E/wrEHNqfuS/hPIWA4y3w
         bmDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tvQtsw0ICTvjn7fc59FPmyf50Xjv75M/Lj9Ga3yqMGo=;
        b=lklSjddwD7mmpZBtWAI2sgMUzpm1wYnEsgEXx4VQ76ov5l0iQlF1S4iFA5RIkUhuI2
         B7YpXdeSKY2jjsqsqHSfR8LVQN9XYOXyfZX0Sde742b58CUb9+QbL52U1MXBz+Gdq4YQ
         VDJYc+PZnaDPl70bl++lM8wMuv+OAUgmKnkPkvKbnWySmY6OK2RjZqCQzEykPIvTe4Ra
         1nohqhkwT5d1TpZuybk8ZgDV2WDRJMRpoPCrzk+ziOY/GvLODoUS8MXz4qtekpbExZpR
         sNBGhCzOX87Q35xSRbp8WBK3kDYBZa/C81MdU/wyfmegfLElpLJQm4acu//1Sq9BtFtD
         1jCg==
X-Gm-Message-State: ANhLgQ2DWRsD8V9GNj7yxj5PZVUu9iwPtukiSaJzJ+GHP4BWOnndDz1i
        ih2FWLJ16yiRNFPfLnurrEI=
X-Google-Smtp-Source: ADFU+vtd+AYkfx7+liA4HDeIgtgLl2c/U2F8tqU34ccfkmbdXabh6GlaaffNTXitSJio9mUKWU/9IA==
X-Received: by 2002:a5d:6044:: with SMTP id j4mr3804270wrt.232.1585149742401;
        Wed, 25 Mar 2020 08:22:22 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:21 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 06/10] net: dsa: b53: Add MTU configuration support
Date:   Wed, 25 Mar 2020 17:22:05 +0200
Message-Id: <20200325152209.3428-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Krishna Policharla <murali.policharla@broadcom.com>

Add b53_change_mtu API to configure mtu settings in B53 switch. Enable
jumbo frame support if configured mtu size is for jumbo frame. Also
configure BCM583XX devices to send and receive jumbo frames when ports
are configured with 10/100 Mbps speed.

Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c | 35 ++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index ceafce446317..e32e05803800 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -644,6 +644,7 @@ EXPORT_SYMBOL(b53_brcm_hdr_setup);
 
 static void b53_enable_cpu_port(struct b53_device *dev, int port)
 {
+	u32 port_mask;
 	u8 port_ctrl;
 
 	/* BCM5325 CPU port is at 8 */
@@ -658,6 +659,14 @@ static void b53_enable_cpu_port(struct b53_device *dev, int port)
 	b53_brcm_hdr_setup(dev->ds, port);
 
 	b53_br_egress_floods(dev->ds, port, true, true);
+
+	b53_read32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, &port_mask);
+
+	if (dev->chip_id == BCM583XX_DEVICE_ID)
+		port_mask |= JPM_10_100_JUMBO_EN;
+
+	port_mask |= BIT(port);
+	b53_write32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, port_mask);
 }
 
 static void b53_enable_mib(struct b53_device *dev)
@@ -2065,6 +2074,30 @@ int b53_set_mac_eee(struct dsa_switch *ds, int port, struct ethtool_eee *e)
 }
 EXPORT_SYMBOL(b53_set_mac_eee);
 
+static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
+{
+	struct b53_device *dev = ds->priv;
+	u32 port_mask;
+
+	if (dev->chip_id == BCM58XX_DEVICE_ID ||
+	    is5325(dev) || is5365(dev))
+		return -EOPNOTSUPP;
+
+	b53_read32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, &port_mask);
+
+	if (mtu >= JMS_MIN_SIZE)
+		port_mask |= BIT(port);
+	else
+		port_mask &= ~BIT(port);
+
+	return b53_write32(dev, B53_JUMBO_PAGE, dev->jumbo_pm_reg, port_mask);
+}
+
+static int b53_get_max_mtu(struct dsa_switch *ds, int port)
+{
+	return JMS_MAX_SIZE;
+}
+
 static const struct dsa_switch_ops b53_switch_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
 	.setup			= b53_setup,
@@ -2102,6 +2135,8 @@ static const struct dsa_switch_ops b53_switch_ops = {
 	.port_mdb_prepare	= b53_mdb_prepare,
 	.port_mdb_add		= b53_mdb_add,
 	.port_mdb_del		= b53_mdb_del,
+	.port_max_mtu		= b53_get_max_mtu,
+	.port_change_mtu	= b53_change_mtu,
 };
 
 struct b53_chip_data {
-- 
2.17.1

