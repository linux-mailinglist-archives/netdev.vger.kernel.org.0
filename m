Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92D3CC9B0B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbfJCJt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:49:59 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40200 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729259AbfJCJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:49:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so1754436wmj.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LY1sIlM8RWpcmUNBp++7MTdTqYMoHVrP/zF0XtPCYo=;
        b=NTyneLGxp3fNpuw9kcHc59XJbJMaWTFhR84ehgrZajTfTqVUIAavrvCPm48kiT1aya
         P5iCyiL7oacD39vV4DeNWojk0z7fM3FOndmIHIWPyXtRrWBa/Fa+QPCopNXFFl7VzWwq
         zG6tJqUOmN/4YcqDSKXoEXpYLY3FPWv1X/QsOIl/ePYfgVlPjYv9bcIeXElldaY9byCr
         OFjMETl8I/SwFdN/GRhIYaajRJN9jJv6/Pe20cEPuoKdudayRbOkpFYtzcMxsmKF/C++
         4YG66eWGGw7eVZQFqyT3gUQxdKHKxzcvJFrxkCnIA7Q1KSvEAYHbSzdScOnJtiJOChE8
         keCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LY1sIlM8RWpcmUNBp++7MTdTqYMoHVrP/zF0XtPCYo=;
        b=Gq/fhiX1/rm16YveBY2B3l27wrNkldimi766S/028Hj9miah8LxkwiFc6AKKZ9GZWY
         KbaGmhDBgyeJLA015TW6SsI0WGJnrufXQpU2TWSb9EYviojFt7mIhAU4duHELiXYNmzf
         sNon0xemsVSgCO84xxOtgMcBTw014v142N8GqwPPu16zLf4tEsJg7FrbVKkPXzV0M3+G
         NNJZ8Af8VFZxB0ndnsk4HG6FujNu65m0JXfNsrblmElQlN1j2/ZbFVr3mEzBhWTN9QMi
         mWN6jLb55SB8/dCzVt3q/WbAIVRHz2WOy4aeXsOEKazxEeonWyf9hCtRQyYDK0eT8GaH
         UPog==
X-Gm-Message-State: APjAAAX3cWy+7zcTfGkP8TcOYVnf0sndxuRoeDXjVdc/4gbXghpP+/z5
        ZeM5XESXvmHl9KQr4LjQx/ffkGdZlGc=
X-Google-Smtp-Source: APXvYqynubOwhVKBGee8WSr6J2z01/q8rVkVs4xInzX0kAh0OFvKsmyLnS7trepqLjzFTxqK5cEPDQ==
X-Received: by 2002:a1c:f30d:: with SMTP id q13mr5773201wmq.60.1570096193600;
        Thu, 03 Oct 2019 02:49:53 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id g1sm2160894wrv.68.2019.10.03.02.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:49:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch net-next v3 10/15] netdevsim: add all ports in nsim_dev_create() and del them in destroy()
Date:   Thu,  3 Oct 2019 11:49:35 +0200
Message-Id: <20191003094940.9797-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
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

