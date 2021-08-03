Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94AB3DEDF6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 14:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhHCMjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 08:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235721AbhHCMjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 08:39:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141F560F58;
        Tue,  3 Aug 2021 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627994364;
        bh=1zkiaZrNIb78NDgNIblVRJ+gPwQaL5KGzP/OjD0DrTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=fAI1WdR8g8LwYB5ViXOxYD8e/37/zVt/DOd6qarOxQ8MsAdxJ9GrkYdJEx1KXdOKw
         /V/ewK5xDuVkYPkdGK03VmNQPYatxMuLgpHXKZnpQuc7FrAhGW8kF29xufODwVANnu
         nV7ppzdsXlwoSpg/eHx7GYZ7ZVJBfrHMMflRRH8YgoJdi5aT8Sc/sA5EjSUwNhlUbO
         vrO3/Fz2wkMO42lKVgeweLX6+LRgUMd3ga+mvtyKVLFdKZAEJvcrHaSh0/SIrpPDSy
         cOFokUgkpnbfiWoHquKwJgvXswR86QSWPZ06g0OthgMhOOWnM9C6o80Wa67uyp/r/M
         0A6uG+QLS0s7Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        peilin.ye@bytedance.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Date:   Tue,  3 Aug 2021 05:39:21 -0700
Message-Id: <20210803123921.2374485-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit d4861fc6be581561d6964700110a4dede54da6a6.

netdevsim is for enabling upstream tests, two weeks in
and there's no sign of upstream test using the "mutli-queue"
option.

We can add this option back when such test materializes.
Right now it's dead code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c       | 17 +++++++----------
 drivers/net/netdevsim/netdev.c    |  6 ++----
 drivers/net/netdevsim/netdevsim.h |  1 -
 3 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ff01e5bdc72e..ccec29970d5b 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -262,31 +262,29 @@ static struct device_type nsim_bus_dev_type = {
 };
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queues);
+nsim_bus_dev_new(unsigned int id, unsigned int port_count);
 
 static ssize_t
 new_device_store(struct bus_type *bus, const char *buf, size_t count)
 {
-	unsigned int id, port_count, num_queues;
 	struct nsim_bus_dev *nsim_bus_dev;
+	unsigned int port_count;
+	unsigned int id;
 	int err;
 
-	err = sscanf(buf, "%u %u %u", &id, &port_count, &num_queues);
+	err = sscanf(buf, "%u %u", &id, &port_count);
 	switch (err) {
 	case 1:
 		port_count = 1;
 		fallthrough;
 	case 2:
-		num_queues = 1;
-		fallthrough;
-	case 3:
 		if (id > INT_MAX) {
 			pr_err("Value of \"id\" is too big.\n");
 			return -EINVAL;
 		}
 		break;
 	default:
-		pr_err("Format for adding new device is \"id port_count num_queues\" (uint uint unit).\n");
+		pr_err("Format for adding new device is \"id port_count\" (uint uint).\n");
 		return -EINVAL;
 	}
 
@@ -297,7 +295,7 @@ new_device_store(struct bus_type *bus, const char *buf, size_t count)
 		goto err;
 	}
 
-	nsim_bus_dev = nsim_bus_dev_new(id, port_count, num_queues);
+	nsim_bus_dev = nsim_bus_dev_new(id, port_count);
 	if (IS_ERR(nsim_bus_dev)) {
 		err = PTR_ERR(nsim_bus_dev);
 		goto err;
@@ -399,7 +397,7 @@ static struct bus_type nsim_bus = {
 #define NSIM_BUS_DEV_MAX_VFS 4
 
 static struct nsim_bus_dev *
-nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queues)
+nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 {
 	struct nsim_bus_dev *nsim_bus_dev;
 	int err;
@@ -415,7 +413,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count, unsigned int num_queu
 	nsim_bus_dev->dev.bus = &nsim_bus;
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
-	nsim_bus_dev->num_queues = num_queues;
 	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 	nsim_bus_dev->max_vfs = NSIM_BUS_DEV_MAX_VFS;
 	mutex_init(&nsim_bus_dev->nsim_bus_reload_lock);
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 50572e0f1f52..c3aeb15843e2 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -347,8 +347,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	struct netdevsim *ns;
 	int err;
 
-	dev = alloc_netdev_mq(sizeof(*ns), "eth%d", NET_NAME_UNKNOWN, nsim_setup,
-			      nsim_dev->nsim_bus_dev->num_queues);
+	dev = alloc_netdev(sizeof(*ns), "eth%d", NET_NAME_UNKNOWN, nsim_setup);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -393,8 +392,7 @@ void nsim_destroy(struct netdevsim *ns)
 static int nsim_validate(struct nlattr *tb[], struct nlattr *data[],
 			 struct netlink_ext_ack *extack)
 {
-	NL_SET_ERR_MSG_MOD(extack,
-			   "Please use: echo \"[ID] [PORT_COUNT] [NUM_QUEUES]\" > /sys/bus/netdevsim/new_device");
+	NL_SET_ERR_MSG_MOD(extack, "Please use: echo \"[ID] [PORT_COUNT]\" > /sys/bus/netdevsim/new_device");
 	return -EOPNOTSUPP;
 }
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 1c20bcbd9d91..ae462957dcee 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -352,7 +352,6 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
-	unsigned int num_queues; /* Number of queues for each port on this bus */
 	struct net *initial_net; /* Purpose of this is to carry net pointer
 				  * during the probe time only.
 				  */
-- 
2.31.1

