Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88943440C47
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhJ3XPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhJ3XPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D5760FC3;
        Sat, 30 Oct 2021 23:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635579;
        bh=iawlz1o4Sqi/Jf/ZodOUmTboON5zxnS/MQJfg/Jij/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OamYTv1ZcdMexfvMDo08JVSWOs8kZbWg/hS1gBFNKuu0nW+j4e2ohWNugxYe9L+t4
         lAsz61HPMF3HCjgI025hMfsKMXQAU8F/AN6vjzYiQ4z3UeSaxqc0/HLbnaX90AGRXP
         i8SWRiMV7xSFkZgWWYjOp1w9pI9ucGdKqM5qHtKxB3J7mT4lsxOK65umiiBT/agH7z
         TVTe4iaRGkR2IssyduyJkYQas6fGptNT1w6nSV+yXX0gkuO4NQSghGbVYvReAAWWJ1
         bMQMv2eIgp5/WsFyRRGQzfvUHoaV4hOWIpyNjGt1T8CWAu5dZj6esm/9V9Wp2peneH
         H97/AeiP5vKJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     leon@kernel.org, idosch@idosch.org
Cc:     edwin.peer@broadcom.com, jiri@resnulli.us, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 4/5] netdevsim: minor code move
Date:   Sat, 30 Oct 2021 16:12:53 -0700
Message-Id: <20211030231254.2477599-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231254.2477599-1-kuba@kernel.org>
References: <20211030231254.2477599-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the port add/del helpers

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/dev.c | 54 ++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 5db40d713d2a..b15763a8e89a 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -567,7 +567,32 @@ static void nsim_dev_dummy_region_exit(struct nsim_dev *nsim_dev)
 	devlink_region_destroy(nsim_dev->dummy_region);
 }
 
-static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port);
+static struct nsim_dev_port *
+__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
+		       unsigned int port_index)
+{
+	struct nsim_dev_port *nsim_dev_port;
+
+	port_index = nsim_dev_port_index(type, port_index);
+	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list)
+		if (nsim_dev_port->port_index == port_index)
+			return nsim_dev_port;
+	return NULL;
+}
+
+static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
+{
+	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
+
+	list_del(&nsim_dev_port->list);
+	if (nsim_dev_port_is_vf(nsim_dev_port))
+		devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
+	devlink_port_type_clear(devlink_port);
+	nsim_destroy(nsim_dev_port->ns);
+	nsim_dev_port_debugfs_exit(nsim_dev_port);
+	devlink_port_unregister(devlink_port);
+	kfree(nsim_dev_port);
+}
 
 static int nsim_esw_legacy_enable(struct nsim_dev *nsim_dev,
 				  struct netlink_ext_ack *extack)
@@ -1418,20 +1443,6 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev, enum nsim_dev_port_typ
 	return err;
 }
 
-static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
-{
-	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
-
-	list_del(&nsim_dev_port->list);
-	if (nsim_dev_port_is_vf(nsim_dev_port))
-		devlink_rate_leaf_destroy(&nsim_dev_port->devlink_port);
-	devlink_port_type_clear(devlink_port);
-	nsim_destroy(nsim_dev_port->ns);
-	nsim_dev_port_debugfs_exit(nsim_dev_port);
-	devlink_port_unregister(devlink_port);
-	kfree(nsim_dev_port);
-}
-
 static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 {
 	struct nsim_dev_port *nsim_dev_port, *tmp;
@@ -1674,19 +1685,6 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	dev_set_drvdata(&nsim_bus_dev->dev, NULL);
 }
 
-static struct nsim_dev_port *
-__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, enum nsim_dev_port_type type,
-		       unsigned int port_index)
-{
-	struct nsim_dev_port *nsim_dev_port;
-
-	port_index = nsim_dev_port_index(type, port_index);
-	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list)
-		if (nsim_dev_port->port_index == port_index)
-			return nsim_dev_port;
-	return NULL;
-}
-
 int nsim_drv_port_add(struct nsim_bus_dev *nsim_bus_dev, enum nsim_dev_port_type type,
 		      unsigned int port_index)
 {
-- 
2.31.1

