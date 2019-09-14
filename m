Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9221B2A31
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfINGqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:46:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36131 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbfINGqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:46:22 -0400
Received: by mail-wm1-f65.google.com with SMTP id t3so4869385wmj.1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i3fVP7qLcz/8ei/VSV5/mbxcUo6PzFjnqSr9uT2vBAA=;
        b=jcRq6LF1KTk852GAOwAKakI9rQQB2UNSKK4kqlAOL4h9y3X89iqj8E+0921AoHVZzH
         4kNPhUHvFnvrAkfh+NivaCGz1yTdMhZpO6bUHvjZvN7tdl2pUW3Rm7HLqg3D5GzADJox
         UX1Iz3O5d2m2YSSTKyhm/Nc/W5aYi1bgzJJfj9VeblcW3H4SPwydICsdz6k0sBNGQSxB
         YwPm7MT+ozMI1Mh8TVELsbjJeB7KzYdAEcnwnHbdQCA5x2BSfNRVx03vodIJKRK6hveY
         mjHAaTAjGX0aIL3epN9fd9B4SFDwAee1vibbpH9erGepPAO9zLMn1ueHmA96CROhEtBU
         +dfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i3fVP7qLcz/8ei/VSV5/mbxcUo6PzFjnqSr9uT2vBAA=;
        b=Fr61h7+g1hEOMGDihm70kgbABs4DL/bB9ef5og+akJKb15d8dC5eo6WNCzutIDc7hM
         MOn2nG3dHsEuFKXpjNRcJKteDz6g566yDMhiwfzwi7n2CuI8xs3Ni3jPUbRwYacwJ1a8
         545EUAK1JVxWF/kZuJcRqddIc3bYSdDIyFGhDInZbHkOXP8c6aHWtgKh1A9RZ3R3y1f9
         Guj04O40D1fULjt0xjExm5gYBi/d/FQmC5mowhayH0BiFLFn3iu57nHhRzqLTOBIipWB
         zDATw5rV7Uo08iH8nF25uNwP3k9+PWbCO95qlLEZrY8/DQtaF/7kBgQU8LhHi1DBds44
         RF1g==
X-Gm-Message-State: APjAAAUeJwnLC2gYGpLDaO/QvbCTLe/MZXmX1uu4CqFc0DFBCzaZPe1d
        HFfXjK/0ITNUQ3JXzBedi+4dCXWjgHw=
X-Google-Smtp-Source: APXvYqybYBPUuKceIg1prl6OYJxKLTPjTtzJuLYSnqv/YzeSzWXhn5FwVWcHKQ9Ajq10LIqn4tAzEA==
X-Received: by 2002:a1c:f515:: with SMTP id t21mr5616480wmh.74.1568443579967;
        Fri, 13 Sep 2019 23:46:19 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z189sm8893802wmc.25.2019.09.13.23.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:46:19 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next 10/15] netdevsim: add all ports in nsim_dev_create() and del them in destroy()
Date:   Sat, 14 Sep 2019 08:46:03 +0200
Message-Id: <20190914064608.26799-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently the probe/remove function does this separately. Put the
addition an deletion of ports into nsim_dev_create() and
nsim_dev_destroy().

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c | 175 +++++++++++++++++++-----------------
 1 file changed, 93 insertions(+), 82 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d623501de3ea..65e02b933aa3 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -600,8 +600,92 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 #define NSIM_DEV_MAX_MACS_DEFAULT 32
 #define NSIM_DEV_TEST1_DEFAULT true
 
+static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+			       unsigned int port_index)
+{
+	struct nsim_dev_port *nsim_dev_port;
+	struct devlink_port *devlink_port;
+	int err;
+
+	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
+	if (!nsim_dev_port)
+		return -ENOMEM;
+	nsim_dev_port->port_index = port_index;
+
+	devlink_port = &nsim_dev_port->devlink_port;
+	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
+			       port_index + 1, 0, 0,
+			       nsim_dev->switch_id.id,
+			       nsim_dev->switch_id.id_len);
+	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
+				    port_index);
+	if (err)
+		goto err_port_free;
+
+	err = nsim_dev_port_debugfs_init(nsim_dev, nsim_dev_port);
+	if (err)
+		goto err_dl_port_unregister;
+
+	nsim_dev_port->ns = nsim_create(nsim_dev, nsim_dev_port);
+	if (IS_ERR(nsim_dev_port->ns)) {
+		err = PTR_ERR(nsim_dev_port->ns);
+		goto err_port_debugfs_exit;
+	}
+
+	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
+	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
+
+	return 0;
+
+err_port_debugfs_exit:
+	nsim_dev_port_debugfs_exit(nsim_dev_port);
+err_dl_port_unregister:
+	devlink_port_unregister(devlink_port);
+err_port_free:
+	kfree(nsim_dev_port);
+	return err;
+}
+
+static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
+{
+	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
+
+	list_del(&nsim_dev_port->list);
+	devlink_port_type_clear(devlink_port);
+	nsim_destroy(nsim_dev_port->ns);
+	nsim_dev_port_debugfs_exit(nsim_dev_port);
+	devlink_port_unregister(devlink_port);
+	kfree(nsim_dev_port);
+}
+
+static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
+{
+	struct nsim_dev_port *nsim_dev_port, *tmp;
+
+	list_for_each_entry_safe(nsim_dev_port, tmp,
+				 &nsim_dev->port_list, list)
+		__nsim_dev_port_del(nsim_dev_port);
+}
+
+static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
+				 unsigned int port_count)
+{
+	int i, err;
+
+	for (i = 0; i < port_count; i++) {
+		err = __nsim_dev_port_add(nsim_dev, i);
+		if (err)
+			goto err_port_del_all;
+	}
+	return 0;
+
+err_port_del_all:
+	nsim_dev_port_del_all(nsim_dev);
+	return err;
+}
+
 static struct nsim_dev *
-nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
+nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 	struct devlink *devlink;
@@ -656,9 +740,15 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
 	if (err)
 		goto err_debugfs_exit;
 
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	if (err)
+		goto err_bpf_dev_exit;
+
 	devlink_params_publish(devlink);
 	return nsim_dev;
 
+err_bpf_dev_exit:
+	nsim_bpf_dev_exit(nsim_dev);
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
 err_traps_exit:
@@ -683,6 +773,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	nsim_dev_port_del_all(nsim_dev);
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
@@ -696,102 +787,22 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 	devlink_free(devlink);
 }
 
-static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
-			       unsigned int port_index)
-{
-	struct nsim_dev_port *nsim_dev_port;
-	struct devlink_port *devlink_port;
-	int err;
-
-	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
-	if (!nsim_dev_port)
-		return -ENOMEM;
-	nsim_dev_port->port_index = port_index;
-
-	devlink_port = &nsim_dev_port->devlink_port;
-	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
-			       port_index + 1, 0, 0,
-			       nsim_dev->switch_id.id,
-			       nsim_dev->switch_id.id_len);
-	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    port_index);
-	if (err)
-		goto err_port_free;
-
-	err = nsim_dev_port_debugfs_init(nsim_dev, nsim_dev_port);
-	if (err)
-		goto err_dl_port_unregister;
-
-	nsim_dev_port->ns = nsim_create(nsim_dev, nsim_dev_port);
-	if (IS_ERR(nsim_dev_port->ns)) {
-		err = PTR_ERR(nsim_dev_port->ns);
-		goto err_port_debugfs_exit;
-	}
-
-	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
-	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
-
-	return 0;
-
-err_port_debugfs_exit:
-	nsim_dev_port_debugfs_exit(nsim_dev_port);
-err_dl_port_unregister:
-	devlink_port_unregister(devlink_port);
-err_port_free:
-	kfree(nsim_dev_port);
-	return err;
-}
-
-static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
-{
-	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
-
-	list_del(&nsim_dev_port->list);
-	devlink_port_type_clear(devlink_port);
-	nsim_destroy(nsim_dev_port->ns);
-	nsim_dev_port_debugfs_exit(nsim_dev_port);
-	devlink_port_unregister(devlink_port);
-	kfree(nsim_dev_port);
-}
-
-static void nsim_dev_port_del_all(struct nsim_dev *nsim_dev)
-{
-	struct nsim_dev_port *nsim_dev_port, *tmp;
-
-	list_for_each_entry_safe(nsim_dev_port, tmp,
-				 &nsim_dev->port_list, list)
-		__nsim_dev_port_del(nsim_dev_port);
-}
-
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
-	int i;
-	int err;
 
-	nsim_dev = nsim_dev_create(nsim_bus_dev, nsim_bus_dev->port_count);
+	nsim_dev = nsim_dev_create(nsim_bus_dev);
 	if (IS_ERR(nsim_dev))
 		return PTR_ERR(nsim_dev);
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
 
-	for (i = 0; i < nsim_bus_dev->port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
-		if (err)
-			goto err_port_del_all;
-	}
 	return 0;
-
-err_port_del_all:
-	nsim_dev_port_del_all(nsim_dev);
-	nsim_dev_destroy(nsim_dev);
-	return err;
 }
 
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 
-	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_destroy(nsim_dev);
 }
 
-- 
2.21.0

