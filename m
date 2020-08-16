Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F2B245964
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbgHPToG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:44:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgHPToC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:44:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OZS-009c9J-B8; Sun, 16 Aug 2020 21:43:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 7/7] net: dsa: mv88e6xxx: Implement devlink info get callback
Date:   Sun, 16 Aug 2020 21:43:16 +0200
Message-Id: <20200816194316.2291489-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816194316.2291489-1-andrew@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the driver name and the asic.id with the switch name.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  1 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 15 +++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 33e4518736a2..ee3b1a6b1ea8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5385,6 +5385,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_ts_info		= mv88e6xxx_get_ts_info,
 	.devlink_param_get	= mv88e6xxx_devlink_param_get,
 	.devlink_param_set	= mv88e6xxx_devlink_param_set,
+	.devlink_info_get	= mv88e6xxx_devlink_info_get,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index c6ebadcfa63f..8cb167d737e2 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -673,3 +673,18 @@ int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
 	return 0;
 }
 
+int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
+			       struct devlink_info_req *req,
+			       struct netlink_ext_ack *extack)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int err;
+
+	err = devlink_info_driver_name_put(req, "mv88e6xxx");
+	if (err)
+		return err;
+
+	return devlink_info_version_fixed_put(req,
+					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
+					      chip->info->name);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.h b/drivers/net/dsa/mv88e6xxx/devlink.h
index da83c25d944b..3d72db3dcf95 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.h
+++ b/drivers/net/dsa/mv88e6xxx/devlink.h
@@ -15,4 +15,7 @@ int mv88e6xxx_devlink_param_set(struct dsa_switch *ds, u32 id,
 int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds);
 void mv88e6xxx_teardown_devlink_regions(struct dsa_switch *ds);
 
+int mv88e6xxx_devlink_info_get(struct dsa_switch *ds,
+			       struct devlink_info_req *req,
+			       struct netlink_ext_ack *extack);
 #endif /* _MV88E6XXX_DEVLINK_H */
-- 
2.28.0

