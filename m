Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486AE25AF0C
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgIBPdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:33:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52318 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728376AbgIBPcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:32:36 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 082FWTDB014704;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 082FWTUU026693;
        Wed, 2 Sep 2020 18:32:29 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 082FWTiR026692;
        Wed, 2 Sep 2020 18:32:29 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        linux-kernel@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next RFC v1 3/4] devlink: Add hierarchy between traps in device level and port level
Date:   Wed,  2 Sep 2020 18:32:13 +0300
Message-Id: <1599060734-26617-4-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
References: <1599060734-26617-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Managing large scale port's traps may be complicated. This patch
introduces a shortcut: when setting a trap on a device and this trap is
not registered on this device, the action will take place on all related
ports that did register this trap.

Signed-off-by: Aya Levin <ayal@mellanox.com>
---
 net/core/devlink.c | 43 +++++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b13e1b40bf1c..dea5482b2517 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6501,23 +6501,46 @@ static int devlink_nl_cmd_trap_set_doit(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_mngr *trap_mngr;
 	struct devlink_trap_item *trap_item;
+	struct devlink_port *devlink_port;
 	int err;
 
-	trap_mngr = devlink_trap_get_trap_mngr_from_info(devlink, info);
-	if (list_empty(&trap_mngr->trap_list))
-		return -EOPNOTSUPP;
+	devlink_port = devlink_port_get_from_attrs(devlink, info->attrs);
+	if (IS_ERR(devlink_port)) {
+		trap_mngr =  &devlink->trap_mngr;
+		if (list_empty(&trap_mngr->trap_list))
+			goto loop_over_ports;
 
-	trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
-	if (!trap_item) {
-		NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap");
-		return -ENOENT;
+		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
+		if (!trap_item)
+			goto loop_over_ports;
+	} else {
+		trap_mngr = &devlink_port->trap_mngr;
+		if (list_empty(&trap_mngr->trap_list))
+			return -EOPNOTSUPP;
+
+		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
+		if (!trap_item) {
+			NL_SET_ERR_MSG_MOD(extack, "Port did not register this trap");
+			return -ENOENT;
+		}
 	}
 	return devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
 
-	err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
-	if (err)
-		return err;
+loop_over_ports:
+	if (list_empty(&devlink->port_list))
+		return -EOPNOTSUPP;
+	list_for_each_entry(devlink_port, &devlink->port_list, list) {
+		trap_mngr = &devlink_port->trap_mngr;
+		if (list_empty(&trap_mngr->trap_list))
+			continue;
 
+		trap_item = devlink_trap_item_get_from_info(trap_mngr, info);
+		if (!trap_item)
+			continue;
+		err = devlink_trap_action_set(devlink, trap_mngr, trap_item, info);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
-- 
2.14.1

