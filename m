Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B605A777FA
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387566AbfG0JpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:45:07 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41088 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbfG0JpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:45:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so53574526wrm.8
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 02:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MB81cqPRIqcl19hvpMZK8DdRpBi4Ryy1laaGbmSAsdQ=;
        b=RowiKzHMqQuWV6rVJk5/c2vtbTITmyJ9nRdNetM7ocoijyDxhLmS5EABD2EtNE1bT5
         wbok7n6n26FrwSX9XH/se7KWQmORlSV2TYaGW8dmjBEM/x2nqjuST5zHNGAUNocJj81p
         4tUaQNuvATQJT67qW63cxYlqerJoXyj/IQs5Pvu/SzyJcJye5Xbc6SxgUNJs6gwGOclJ
         LNkjj1e2yrqPEx1MLGvSoFrNa8Wclw6RSqsB3heYCGWt+E2l5J84t89hgXkUbTXPNXE/
         xdxENME8oupzBqL+C7o2/Uobo3lYqHYYYpDSxabNo2shvlvPSwZ4lbPp2poiCI0EwF3j
         HCuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MB81cqPRIqcl19hvpMZK8DdRpBi4Ryy1laaGbmSAsdQ=;
        b=L8PqdsJWyJvciAhYcfUYhYwljMpbbn4hW1JzVUFy1T+k4B+lTn0MISW6drJju3v9kw
         XXV3JRHwkLcHx4jIcvE3Y7B2p//FXejOcsUKF81rWP7DpVNnJgy/y5uLFDRepzhedPSl
         neN9DOShK+4ymGVnvVNvaWthu7etKIna5Szv8f45Au+8Z3TVOrktVGzw3O+hsY5eRMh4
         FL4SSkZK0jTWQal6A0pdiON+uJ/0qIcozySGN2WebhoK8cM+gIoNiZmpZSmOctblSYmZ
         t3ya1Z32ea03gU5o+NVdWZLT46xQM0f41lEBMGWrM/MOs8+nSf1EMNwIoI59VAIZXSEb
         c18A==
X-Gm-Message-State: APjAAAVC0XupyboLZPjxH5+7y44vsX6GPzRVo045jqRX94Iufp1MKAIp
        CYTDbibRwDcVxtV3IIIxjlvlPaP8
X-Google-Smtp-Source: APXvYqwGQfcatkmfGid+qYQZWNoaQtpqNPDw2zHsg54eztsa7wnP/IAwHgXZIrfIjb6BD/wft71sKg==
X-Received: by 2002:adf:e602:: with SMTP id p2mr70591531wrm.306.1564220703301;
        Sat, 27 Jul 2019 02:45:03 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id g19sm102293808wrb.52.2019.07.27.02.45.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 02:45:02 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next 3/3] netdevsim: create devlink and netdev instances in namespace
Date:   Sat, 27 Jul 2019 11:44:59 +0200
Message-Id: <20190727094459.26345-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

When user does create new netdevsim instance using sysfs bus file,
create the devlink instance and related netdev instance in the namespace
of the caller.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/bus.c       |  1 +
 drivers/net/netdevsim/dev.c       | 17 +++++++++++------
 drivers/net/netdevsim/netdev.c    |  4 +++-
 drivers/net/netdevsim/netdevsim.h |  5 ++++-
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 1a0ff3d7747b..6aeed0c600f8 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -283,6 +283,7 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 	nsim_bus_dev->dev.bus = &nsim_bus;
 	nsim_bus_dev->dev.type = &nsim_bus_dev_type;
 	nsim_bus_dev->port_count = port_count;
+	nsim_bus_dev->initial_net = current->nsproxy->net_ns;
 
 	err = device_register(&nsim_bus_dev->dev);
 	if (err)
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index c5c417a3c0ce..685dd21f5500 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -268,7 +268,8 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 };
 
 static struct nsim_dev *
-nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
+nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
+		unsigned int port_count)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -277,6 +278,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
 	if (!devlink)
 		return ERR_PTR(-ENOMEM);
+	devlink_net_set(devlink, net);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
@@ -335,7 +337,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	devlink_free(devlink);
 }
 
-static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+static int __nsim_dev_port_add(struct net *net, struct nsim_dev *nsim_dev,
 			       unsigned int port_index)
 {
 	struct nsim_dev_port *nsim_dev_port;
@@ -361,7 +363,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_dl_port_unregister;
 
-	nsim_dev_port->ns = nsim_create(nsim_dev, nsim_dev_port);
+	nsim_dev_port->ns = nsim_create(net, nsim_dev, nsim_dev_port);
 	if (IS_ERR(nsim_dev_port->ns)) {
 		err = PTR_ERR(nsim_dev_port->ns);
 		goto err_port_debugfs_exit;
@@ -404,17 +406,19 @@ static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
+	struct net *initial_net = nsim_bus_dev->initial_net;
 	struct nsim_dev *nsim_dev;
 	int i;
 	int err;
 
-	nsim_dev = nsim_dev_create(nsim_bus_dev, nsim_bus_dev->port_count);
+	nsim_dev = nsim_dev_create(initial_net, nsim_bus_dev,
+				   nsim_bus_dev->port_count);
 	if (IS_ERR(nsim_dev))
 		return PTR_ERR(nsim_dev);
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
 
 	for (i = 0; i < nsim_bus_dev->port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
+		err = __nsim_dev_port_add(initial_net, nsim_dev, i);
 		if (err)
 			goto err_port_del_all;
 	}
@@ -449,13 +453,14 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
+	struct net *net = devlink_net(priv_to_devlink(nsim_dev));
 	int err;
 
 	mutex_lock(&nsim_dev->port_list_lock);
 	if (__nsim_dev_port_lookup(nsim_dev, port_index))
 		err = -EEXIST;
 	else
-		err = __nsim_dev_port_add(nsim_dev, port_index);
+		err = __nsim_dev_port_add(net, nsim_dev, port_index);
 	mutex_unlock(&nsim_dev->port_list_lock);
 	return err;
 }
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 0740940f41b1..25c7de7a4a31 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -280,7 +280,8 @@ static void nsim_setup(struct net_device *dev)
 }
 
 struct netdevsim *
-nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
+nsim_create(struct net *net, struct nsim_dev *nsim_dev,
+	    struct nsim_dev_port *nsim_dev_port)
 {
 	struct net_device *dev;
 	struct netdevsim *ns;
@@ -290,6 +291,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
 
+	dev_net_set(dev, net);
 	ns = netdev_priv(dev);
 	ns->netdev = dev;
 	ns->nsim_dev = nsim_dev;
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 79c05af2a7c0..cdf53d0e0c49 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -19,6 +19,7 @@
 #include <linux/netdevice.h>
 #include <linux/u64_stats_sync.h>
 #include <net/devlink.h>
+#include <net/net_namespace.h>
 #include <net/xdp.h>
 
 #define DRV_NAME	"netdevsim"
@@ -75,7 +76,8 @@ struct netdevsim {
 };
 
 struct netdevsim *
-nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port);
+nsim_create(struct net *net, struct nsim_dev *nsim_dev,
+	    struct nsim_dev_port *nsim_dev_port);
 void nsim_destroy(struct netdevsim *ns);
 
 #ifdef CONFIG_BPF_SYSCALL
@@ -213,6 +215,7 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
+	struct net *initial_net;
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
 };
-- 
2.21.0

