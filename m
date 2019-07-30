Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1A7A377
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 10:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbfG3I5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:57:44 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50270 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731222AbfG3I5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:57:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so56360474wml.0
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sOtgozJiOFMaFQ2w5V4pX8WVi8yTBi0K3VlVGO5H9kU=;
        b=AhWuKNRtQFqAKVx8VTVofdrj0ZyZGE2fx6r/Bv+Rpo9hWBdMYsU3KjA4LrnMkDKCt0
         1jwiG3an89x1+o8olp3FcFp6I173bgkHlxJE96gA5vQ7S+adseSwA7WSwnR9sjn8ytP3
         xuUg2JkAY8z1l6uDMht32+AvWMwwwTyLz68KIGoRNmfQjowfhW21znKOkTVhgpPnrZtA
         EplGU/aN1duVWbxopJhCUTUFiMGLPA1XOpUCrJaUi932CSCjY7+0HhS8hjfn2yvpaWUk
         uk4h1OJFjL3eb68dyKhXBhzsC4tyWZ40f3zBjn1xpEJpexR0G/c8q4XxpmoAMOzALJsi
         nbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sOtgozJiOFMaFQ2w5V4pX8WVi8yTBi0K3VlVGO5H9kU=;
        b=h54DLUvqlj791TRr6LVBrO5k3DBUZl38JH/Glxshs5QlBu0YC/COfF5qgNp4DzKXo3
         xz/jj4/Om8B16EA/2ExOVLmr/MjfOd1646LE0pFma2l71uN9UdTjCb/n7vqp1jrjKq+Z
         I0Fi5Rgnj21l2+uRpemombkkPYrEbwWGa12Q7hiuRg5o7Bs6gWPviPjHJx6uTJyIpogy
         nJ1prHXmmL/ZVUKLbB1nWpb8/vaGfZ+DkGU5n/aTxJ7GMXX3XMDXIWaHyWjvvd+xjiQz
         79AxztITqMZHW1QTmUCM0n+/Mhk5ckeNo/4ZeASlgNraM/sHu6dS5EWtd4cfcw3vFHHq
         KS8A==
X-Gm-Message-State: APjAAAV0sH1N9ZyaCBeuJ/0GPf5YacY/knfWLM2OPsdSDR4J2NkSS4XD
        5Z3Ho84ErvHk3bfhycdSMS4gt+8v
X-Google-Smtp-Source: APXvYqwqd1UaRvY/X6qkvUVFZZ7rJb2koiBHcOyszrUy92KE+wAtvpTn/txc3mpt0lycspUC+Jz10A==
X-Received: by 2002:a7b:cf0b:: with SMTP id l11mr109699772wmg.143.1564477058716;
        Tue, 30 Jul 2019 01:57:38 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id k9sm45398562wmi.33.2019.07.30.01.57.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:57:38 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch net-next v2 3/3] netdevsim: create devlink and netdev instances in namespace
Date:   Tue, 30 Jul 2019 10:57:34 +0200
Message-Id: <20190730085734.31504-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
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
index 79c05af2a7c0..9563acb61b03 100644
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
@@ -213,6 +216,9 @@ struct nsim_bus_dev {
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

