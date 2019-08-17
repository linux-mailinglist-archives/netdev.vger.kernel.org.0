Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B879912A5
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfHQTPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:15:05 -0400
Received: from mail.nic.cz ([217.31.204.67]:41644 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfHQTO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 15:14:59 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id D390D140B52;
        Sat, 17 Aug 2019 21:14:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566069297; bh=5bUmByzWwsKmOQtkyX8os620YqcHFPrH1przbv7z6IA=;
        h=From:To:Date;
        b=EJMdMoP5poGls/wlpc4FDvRjghzuokovhM7qfVwQgzKRLTwZPO2tn0mg6rhiRHjAN
         ExduBNQm9eDMVekkowO7DKl1B2hxKJBJk6e3kSXekMyZeDCa6TaETJDW/Da/3wIFax
         ZVG7YQWQoZGYzHKJfGQEVH+CSgpGTVSGNHeujfyM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC v2 net-next 2/4] net: dsa: call port_enable/port_disable for CPU/DSA ports
Date:   Sat, 17 Aug 2019 21:14:50 +0200
Message-Id: <20190817191452.16716-3-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190817191452.16716-1-marek.behun@nic.cz>
References: <20190817191452.16716-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call dsa_port_enable for CPU/DSA ports in dsa_port_setup, and
dsa_port_disable for CPU/DSA ports in dsa_port_teardown. This requires
changing all DSA drivers, since they expect the port_enable/port_disable
methods to be called only for user ports.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 21 ++++++++++++++++++++-
 net/dsa/port.c |  4 ++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3abd173ebacb..98ea5c158ee3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -315,6 +315,16 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	}
 
+	switch (dp->type) {
+	case DSA_PORT_TYPE_CPU:
+	case DSA_PORT_TYPE_DSA:
+		if (!err)
+			err = dsa_port_enable(dp, NULL);
+		break;
+	default:
+		break;
+	}
+
 	if (err)
 		devlink_port_unregister(&dp->devlink_port);
 
@@ -323,8 +333,17 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 static void dsa_port_teardown(struct dsa_port *dp)
 {
-	if (dp->type != DSA_PORT_TYPE_UNUSED)
+	switch (dp->type) {
+	case DSA_PORT_TYPE_UNUSED:
+		break;
+	case DSA_PORT_TYPE_CPU:
+	case DSA_PORT_TYPE_DSA:
+		dsa_port_disable(dp);
+		/* fall-through */
+	case DSA_PORT_TYPE_USER:
 		devlink_port_unregister(&dp->devlink_port);
+		break;
+	}
 
 	switch (dp->type) {
 	case DSA_PORT_TYPE_UNUSED:
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f071acf2842b..0cadda57df1f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -75,7 +75,7 @@ int dsa_port_enable(struct dsa_port *dp, struct phy_device *phy)
 			return err;
 	}
 
-	if (!dp->bridge_dev)
+	if (dp->type == DSA_PORT_TYPE_USER && !dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_FORWARDING);
 
 	return 0;
@@ -86,7 +86,7 @@ void dsa_port_disable(struct dsa_port *dp)
 	struct dsa_switch *ds = dp->ds;
 	int port = dp->index;
 
-	if (!dp->bridge_dev)
+	if (dp->type == DSA_PORT_TYPE_USER && !dp->bridge_dev)
 		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
 
 	if (ds->ops->port_disable)
-- 
2.21.0

