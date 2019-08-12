Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A568A005
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfHLNr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:47:58 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50960 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfHLNr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:47:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so12237338wml.0
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/WbW1qa+0UwTo+5uVRMiymC8PerdbqS4eEzbcnSkiCE=;
        b=NvOpEBDenlco0Zis2uHO/gsWRrEyPb66Fd6te41hixniEKZLgtZVSAAxr5eGyIRh/q
         Ir2iFM0WST1C/7AR/kAsoMiEP0taUGOqDLiHmjqCy8D2aNOnhsYF9WpQE/AeEhB4bhUV
         Raw2+vDBaIGAvANUvW/dda+qCblRY94kUi2H7aP+zp0o83W7NwdaKxKnV6QiqaMTJW4n
         1jPcSbdzYDxpOSTzQo9EAML4Jcal/yS7WPcu/NFk3lu0sTUDHf/1JXn5uzTIEcNI6Css
         lv+joGn/x3QFzWPT5L+Ok656kM1MXBzsf8oTlbAX5aXUr/1xFdMm/LoJp+7+eRblx4sJ
         +9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/WbW1qa+0UwTo+5uVRMiymC8PerdbqS4eEzbcnSkiCE=;
        b=dZUSOMhYZoksLnSZSzyaHGTHK/c5rTKxKVCQEMV2FMewbNNg+YqVyAAwQId5fTb4sm
         /YeZ8YubDrzp7e9hU4d78erM26B+8k8+usrj8FuIxDGzYJoFqL0IViOEDBKCCak3mkW5
         SzjUHCuwu4S5X7QIAXoD0p1VX3P0hZBUI5EFlFx+H5eZ/U+ecD0U+dstyQYE47KGRmvC
         zROti58aN5+w87hX52myxxfGu7M19imLCqDsnds4YVMZqu9ptooi90CcpNJlrjRnwP92
         jcM+eMxMmKxb0YF9ek7jH76sVrh74KCp9aH6OcYQDBKtrBPljV+NRrAOUYCel6deYFBN
         xYuA==
X-Gm-Message-State: APjAAAVg86ValFCiN/+YpZGLIXCoAxWXdhW2DEqQ7Px7r3i/rH6Rw14L
        XYQbSOFZisrR/iksJ5Au9xK+MjJuRtE=
X-Google-Smtp-Source: APXvYqzRHEQO2FI/80OxGc4p/b9g2TeYumsIHgsI9tShmlHxxTBSc9ewItyL3e4J+HiWVfAY0FEW5Q==
X-Received: by 2002:a05:600c:2102:: with SMTP id u2mr28713334wml.105.1565617675800;
        Mon, 12 Aug 2019 06:47:55 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id w13sm45604383wre.44.2019.08.12.06.47.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:47:55 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v3 3/3] netdevsim: create devlink and netdev instances in namespace
Date:   Mon, 12 Aug 2019 15:47:51 +0200
Message-Id: <20190812134751.30838-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
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
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
v1->v2:
- remove net_namespace.h include and forward decralared net struct
- add comment to initial_net pointer
---
 drivers/net/netdevsim/bus.c       |  1 +
 drivers/net/netdevsim/dev.c       | 17 +++++++++++------
 drivers/net/netdevsim/netdev.c    |  4 +++-
 drivers/net/netdevsim/netdevsim.h |  8 +++++++-
 4 files changed, 22 insertions(+), 8 deletions(-)

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
index e76ea6a3cb60..8485dd805f7c 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -381,7 +381,8 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 #define NSIM_DEV_TEST1_DEFAULT true
 
 static struct nsim_dev *
-nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
+nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
+		unsigned int port_count)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -390,6 +391,7 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	devlink = devlink_alloc(&nsim_dev_devlink_ops, sizeof(*nsim_dev));
 	if (!devlink)
 		return ERR_PTR(-ENOMEM);
+	devlink_net_set(devlink, net);
 	nsim_dev = devlink_priv(devlink);
 	nsim_dev->nsim_bus_dev = nsim_bus_dev;
 	nsim_dev->switch_id.id_len = sizeof(nsim_dev->switch_id.id);
@@ -469,7 +471,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	devlink_free(devlink);
 }
 
-static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+static int __nsim_dev_port_add(struct net *net, struct nsim_dev *nsim_dev,
 			       unsigned int port_index)
 {
 	struct nsim_dev_port *nsim_dev_port;
@@ -495,7 +497,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	if (err)
 		goto err_dl_port_unregister;
 
-	nsim_dev_port->ns = nsim_create(nsim_dev, nsim_dev_port);
+	nsim_dev_port->ns = nsim_create(net, nsim_dev, nsim_dev_port);
 	if (IS_ERR(nsim_dev_port->ns)) {
 		err = PTR_ERR(nsim_dev_port->ns);
 		goto err_port_debugfs_exit;
@@ -538,17 +540,19 @@ static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
 
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
@@ -583,13 +587,14 @@ int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
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
index 4c758c6919f5..521802d429a0 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -74,8 +74,11 @@ struct netdevsim {
 	struct nsim_ipsec ipsec;
 };
 
+struct net;
+
 struct netdevsim *
-nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port);
+nsim_create(struct net *net, struct nsim_dev *nsim_dev,
+	    struct nsim_dev_port *nsim_dev_port);
 void nsim_destroy(struct netdevsim *ns);
 
 #ifdef CONFIG_BPF_SYSCALL
@@ -216,6 +219,9 @@ struct nsim_bus_dev {
 	struct device dev;
 	struct list_head list;
 	unsigned int port_count;
+	struct net *initial_net; /* Purpose of this is to carry net pointer
+				  * during the probe time only.
+				  */
 	unsigned int num_vfs;
 	struct nsim_vf_config *vfconfigs;
 };
-- 
2.21.0

