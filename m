Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E19045D
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfHPPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:08:41 -0400
Received: from mail.nic.cz ([217.31.204.67]:32864 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbfHPPIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:08:40 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id CC6AA140CDD;
        Fri, 16 Aug 2019 17:08:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565968118; bh=vRUZH/gOa1T/0u+NCfdx4Pvdwhu91i7kAAljJm1hyBQ=;
        h=From:To:Date;
        b=V8lgn2hv777vs2mA6Ot9kUWiO4KNUg/0D2YoK0C2cy55VFuUxtLuQKo3T8qbDbSrM
         YWxcAvJ0/Nh/ov109gSQjJo/UuuOHmHeiDB7sSUmhoAuZt9Of6LieW1I2xPAyrt96C
         29EI8TfEEcZ3JTMyRiWWRCVvXswYWZgRH/0e3ARI=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 2/3] net: dsa: add port_setup/port_teardown methods to DSA ops
Date:   Fri, 16 Aug 2019 17:08:33 +0200
Message-Id: <20190816150834.26939-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816150834.26939-1-marek.behun@nic.cz>
References: <20190816150834.26939-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new methods into the DSA operations structure:
  - port_setup(), called from dsa_port_setup() after the DSA port
    already registered
  - port_teardown(), called from dsa_port_teardown() before the port is
    unregistered

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/dsa2.c    | 10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 147b757ef8ea..848898e5d7c5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -360,6 +360,8 @@ struct dsa_switch_ops {
 
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
+	int	(*port_setup)(struct dsa_switch *ds, int port);
+	void	(*port_teardown)(struct dsa_switch *ds, int port);
 	u32	(*get_phy_flags)(struct dsa_switch *ds, int port);
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3abd173ebacb..c891300a6d2c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -315,6 +315,9 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	}
 
+	if (!err && ds->ops->port_setup)
+		err = ds->ops->port_setup(ds, dp->index);
+
 	if (err)
 		devlink_port_unregister(&dp->devlink_port);
 
@@ -323,8 +326,13 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
-	if (dp->type != DSA_PORT_TYPE_UNUSED)
+	struct dsa_switch *ds = dp->ds;
+
+	if (dp->type != DSA_PORT_TYPE_UNUSED) {
 		devlink_port_unregister(&dp->devlink_port);
+		if (ds->ops->port_teardown)
+			ds->ops->port_teardown(ds, dp->index);
+	}
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
-- 
2.21.0

