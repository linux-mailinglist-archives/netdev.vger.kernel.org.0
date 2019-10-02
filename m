Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C19CC8DF9
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfJBQMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:12:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37285 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbfJBQMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 12:12:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id i1so20363839wro.4
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 09:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LY1sIlM8RWpcmUNBp++7MTdTqYMoHVrP/zF0XtPCYo=;
        b=LvmtBTwQEZN6kZHgcoOnFt3x2iQWNtOShOcJYLRoEumKBNvMymvi/701rtu66HazBu
         P4vdTNuhcfbyAI5AU/ocm6DrIbSbr4WR387Kt4y0G7kmkIpCgf1CdAdTTcw9n6mP+WTx
         qWaAn9yYs9oKwJb+sCf+YBttdG4kOfEBqurU9zGpwGlD3SsWVhBJq801L22R65PAukce
         /PL+1uvvcmeXcCqhGBolQZ6NNHzfLZYEKpBADMsXVK30/7J+/1MGnUqbPNIQ5syjx718
         yjjuorCfaz8Ab1iYjUeqojFXy0adgqhzJ4A+lYIA7iamsHcFG6nCS6mmdhEJjzN06oiH
         ZEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LY1sIlM8RWpcmUNBp++7MTdTqYMoHVrP/zF0XtPCYo=;
        b=U/IJXn7et9X8BcwAQU9HKFE7+9FP/z/wyNZocgPxyeVSGHN7HwIwNQWQhBdlUry1st
         IOvz8/gDBAurDDAsfHhd8xVBeoEP9Rwm8zFdX2xCUnyNWazIJuUu3bnoyOzvkX9r6anh
         AEA4YHWTEUYZI6VpTSmmpUsZNxOhE+XswenobTytCfJY74RHgHZVDx+JALBWdEooRgQK
         rCMTvkwAqrtvs8Ncn2YP/SF7gBqsDd1Z/IjNKhqa5TN9m3TWY8iY7atqdntt234bx/l3
         hCntZ62YIeyxbfuRx8OUaNtNFUJ+ZIODeDjEuqbr1+OsshpxBROt06UpiLvOjDnk9yV2
         enOw==
X-Gm-Message-State: APjAAAWDhx0PX8fhbnVxBXFf4jRGYx3OlSvUqSL8ec54kbU0C5OodPbn
        rKdDiCQvjO3ppUcCpAb18cFSQ35ockE=
X-Google-Smtp-Source: APXvYqykLIe0ZNdgQR/KLxRieHBFfESXv6CsrTf5PQlb8jqu7IG78TwAXHH6FadkPN1zE7kSDPSrUQ==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr3388305wrn.335.1570032763864;
        Wed, 02 Oct 2019 09:12:43 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b12sm19892502wrt.21.2019.10.02.09.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 09:12:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v2 10/15] netdevsim: add all ports in nsim_dev_create() and del them in destroy()
Date:   Wed,  2 Oct 2019 18:12:26 +0200
Message-Id: <20191002161231.2987-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002161231.2987-1-jiri@resnulli.us>
References: <20191002161231.2987-1-jiri@resnulli.us>
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
index 6087f5b99e47..3cc101aee991 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -603,8 +603,92 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
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
@@ -659,9 +743,15 @@ nsim_dev_create(struct nsim_bus_dev *nsim_bus_dev, unsigned int port_count)
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
@@ -686,6 +776,7 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	nsim_dev_port_del_all(nsim_dev);
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
 	nsim_dev_traps_exit(devlink);
@@ -699,102 +790,22 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
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

