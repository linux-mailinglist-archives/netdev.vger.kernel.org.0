Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB92607D9
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgIHAwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:52:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728236AbgIHAwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:52:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRro-00Di6S-Gv; Tue, 08 Sep 2020 02:52:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: Implement devlink info get callback
Date:   Tue,  8 Sep 2020 02:51:55 +0200
Message-Id: <20200908005155.3267736-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908005155.3267736-1-andrew@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return the driver name and the asic.id with the switch name.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  1 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 15 +++++++++++++++
 drivers/net/dsa/mv88e6xxx/devlink.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8d1710c896ae..9417412e5fce 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5378,6 +5378,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_ts_info		= mv88e6xxx_get_ts_info,
 	.devlink_param_get	= mv88e6xxx_devlink_param_get,
 	.devlink_param_set	= mv88e6xxx_devlink_param_set,
+	.devlink_info_get	= mv88e6xxx_devlink_info_get,
 };
 
 static int mv88e6xxx_register_switch(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index d93a2b33e355..5accd34a9862 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -669,3 +669,18 @@ int mv88e6xxx_setup_devlink_regions(struct dsa_switch *ds)
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

