Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC0300047
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbhAVK3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbhAVJsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:17 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A407C06121F
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:59 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id e15so3777133wme.0
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOhGgb7y/DuZ0fHW4uLtmD1PoVTLNKXc3BKeuKC8gZg=;
        b=t+Z1cM7MAUoLbj7SYHvl96EQcqz+srKXheZ36Hi+lAxel2IER7bZhbu9DVJVliDecA
         1qAY1gS3RMuM0I7EY1vkU/nhnNv204FCkR+5xBOW0j6VagKa6RAqaJQs24ZlRaIbkg1t
         5BbYB8U+1I4P9VjlutVCcFlNRrceYkTp81X817KUwwNFC0x6c+R55F3KrQmzQFpdZIHv
         iCfpbxVKCReg1MO3kvUwdUfoXaibnBR51h76kYDv3MkzxoWvzLJ4mZ0QjLgsfJgARMjO
         o636v8K3ckTawn/pqFPTnyKfTBMaH8FzfH8XBKA1tcN5GBTejwyXCxZRrIqJ1QQvEP4c
         jZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOhGgb7y/DuZ0fHW4uLtmD1PoVTLNKXc3BKeuKC8gZg=;
        b=cN3csOIiJvpRhOLUvCaX0qBAmzQU3JLtpWCt3OtakbzJdRGMi0cIvyeqp8cLQ8GM+o
         //KU8zhBy0Stqq4cSTaYYkoSSCkGaCtn/A2UcGQSkYwnea3zoeSKSKl8w89D82Cz08/G
         6ZNxLwb9bZNQJtjz+UyDTvVmHLoQjtjfK/+cIqEDHB+MRSJflB9QNR47BjMUxywJLD3N
         I70wfLVnxlRNxve2UXsL95iqOUwCSYVneQ/J0cPHbpGYUc5e6enkZEH7i7HpQZSCfgdS
         NHQ8BYjD7MWR3aDHJmH8q8WaasIBh/t62mFimTfWXqnw5DTkxyqOLoyWipdHTTO/f9N0
         AT1Q==
X-Gm-Message-State: AOAM531F9w2321eSF27pMY8Vb+h7s7hm3Uxm6qTW2WKA7ZY0zyI5JYeZ
        SnA0pway1LyiFJkP5kQnkIGhaMmw6QVAMcEmqds=
X-Google-Smtp-Source: ABdhPJwHrlwCX6CFQ033LU9t7RXIRW2OGf42PC2mGWc+XJVDmIKBMwV9wnnPWkVyrfzCZBgR7T1dzA==
X-Received: by 2002:a1c:b682:: with SMTP id g124mr3147202wmf.10.1611308817682;
        Fri, 22 Jan 2021 01:46:57 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id j13sm10613188wmi.24.2021.01.22.01.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:57 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 07/10] netdevsim: allow port objects to be linked with line cards
Date:   Fri, 22 Jan 2021 10:46:45 +0100
Message-Id: <20210122094648.1631078-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Line cards contain ports. Allow ports to be places on the line cards.
Track the ports that belong under certain line card. Make sure that
the line card port carrier is down, as it will be taken up later on
during "activation".

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/bus.c       |  4 +--
 drivers/net/netdevsim/dev.c       | 48 +++++++++++++++++++++++++------
 drivers/net/netdevsim/netdev.c    |  2 ++
 drivers/net/netdevsim/netdevsim.h |  4 +++
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ed57c012e660..a0afd30d76e6 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -113,7 +113,7 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_add(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_add(nsim_bus_dev, NULL, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
@@ -142,7 +142,7 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
 	devlink_reload_disable(devlink);
-	ret = nsim_dev_port_del(nsim_bus_dev, port_index);
+	ret = nsim_dev_port_del(nsim_bus_dev, NULL, port_index);
 	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d81ccfa05a28..e706317fc0f9 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -35,6 +35,21 @@
 
 #include "netdevsim.h"
 
+#define NSIM_DEV_LINECARD_PORT_INDEX_BASE 1000
+#define NSIM_DEV_LINECARD_PORT_INDEX_STEP 100
+
+static unsigned int
+nsim_dev_port_index(struct nsim_dev_linecard *nsim_dev_linecard,
+		    unsigned int port_index)
+{
+	if (!nsim_dev_linecard)
+		return port_index;
+
+	return NSIM_DEV_LINECARD_PORT_INDEX_BASE +
+	       nsim_dev_linecard->linecard_index * NSIM_DEV_LINECARD_PORT_INDEX_STEP +
+	       port_index;
+}
+
 static struct dentry *nsim_dev_ddir;
 
 #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
@@ -942,6 +957,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 #define NSIM_DEV_TEST1_DEFAULT true
 
 static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
+			       struct nsim_dev_linecard *nsim_dev_linecard,
 			       unsigned int port_index)
 {
 	struct devlink_port_attrs attrs = {};
@@ -952,8 +968,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	nsim_dev_port = kzalloc(sizeof(*nsim_dev_port), GFP_KERNEL);
 	if (!nsim_dev_port)
 		return -ENOMEM;
-	nsim_dev_port->port_index = port_index;
-
+	nsim_dev_port->port_index = nsim_dev_port_index(nsim_dev_linecard,
+							port_index);
+	nsim_dev_port->linecard = nsim_dev_linecard;
 	devlink_port = &nsim_dev_port->devlink_port;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = port_index + 1;
@@ -961,7 +978,7 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 	attrs.switch_id.id_len = nsim_dev->switch_id.id_len;
 	devlink_port_attrs_set(devlink_port, &attrs);
 	err = devlink_port_register(priv_to_devlink(nsim_dev), devlink_port,
-				    port_index);
+				    nsim_dev_port->port_index);
 	if (err)
 		goto err_port_free;
 
@@ -975,6 +992,11 @@ static int __nsim_dev_port_add(struct nsim_dev *nsim_dev,
 		goto err_port_debugfs_exit;
 	}
 
+	if (nsim_dev_linecard)
+		list_add(&nsim_dev_port->list_lc, &nsim_dev_linecard->port_list);
+	else
+		netif_carrier_on(nsim_dev_port->ns->netdev);
+
 	devlink_port_type_eth_set(devlink_port, nsim_dev_port->ns->netdev);
 	list_add(&nsim_dev_port->list, &nsim_dev->port_list);
 
@@ -994,6 +1016,8 @@ static void __nsim_dev_port_del(struct nsim_dev_port *nsim_dev_port)
 	struct devlink_port *devlink_port = &nsim_dev_port->devlink_port;
 
 	list_del(&nsim_dev_port->list);
+	if (nsim_dev_port->linecard)
+		list_del(&nsim_dev_port->list_lc);
 	devlink_port_type_clear(devlink_port);
 	nsim_destroy(nsim_dev_port->ns);
 	nsim_dev_port_debugfs_exit(nsim_dev_port);
@@ -1018,7 +1042,7 @@ static int nsim_dev_port_add_all(struct nsim_dev *nsim_dev,
 	int i, err;
 
 	for (i = 0; i < port_count; i++) {
-		err = __nsim_dev_port_add(nsim_dev, i);
+		err = __nsim_dev_port_add(nsim_dev, NULL, i);
 		if (err)
 			goto err_port_del_all;
 	}
@@ -1040,6 +1064,7 @@ static int __nsim_dev_linecard_add(struct nsim_dev *nsim_dev,
 		return -ENOMEM;
 	nsim_dev_linecard->nsim_dev = nsim_dev;
 	nsim_dev_linecard->linecard_index = linecard_index;
+	INIT_LIST_HEAD(&nsim_dev_linecard->port_list);
 
 	err = nsim_dev_linecard_debugfs_init(nsim_dev, nsim_dev_linecard);
 	if (err)
@@ -1286,10 +1311,13 @@ void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev)
 }
 
 static struct nsim_dev_port *
-__nsim_dev_port_lookup(struct nsim_dev *nsim_dev, unsigned int port_index)
+__nsim_dev_port_lookup(struct nsim_dev *nsim_dev,
+		       struct nsim_dev_linecard *nsim_dev_linecard,
+		       unsigned int port_index)
 {
 	struct nsim_dev_port *nsim_dev_port;
 
+	port_index = nsim_dev_port_index(nsim_dev_linecard, port_index);
 	list_for_each_entry(nsim_dev_port, &nsim_dev->port_list, list)
 		if (nsim_dev_port->port_index == port_index)
 			return nsim_dev_port;
@@ -1297,21 +1325,24 @@ __nsim_dev_port_lookup(struct nsim_dev *nsim_dev, unsigned int port_index)
 }
 
 int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+		      struct nsim_dev_linecard *nsim_dev_linecard,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	int err;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	if (__nsim_dev_port_lookup(nsim_dev, port_index))
+	if (__nsim_dev_port_lookup(nsim_dev, nsim_dev_linecard, port_index))
 		err = -EEXIST;
 	else
-		err = __nsim_dev_port_add(nsim_dev, port_index);
+		err = __nsim_dev_port_add(nsim_dev, nsim_dev_linecard,
+					  port_index);
 	mutex_unlock(&nsim_dev->port_list_lock);
 	return err;
 }
 
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+		      struct nsim_dev_linecard *nsim_dev_linecard,
 		      unsigned int port_index)
 {
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
@@ -1319,7 +1350,8 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
 	int err = 0;
 
 	mutex_lock(&nsim_dev->port_list_lock);
-	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, port_index);
+	nsim_dev_port = __nsim_dev_port_lookup(nsim_dev, nsim_dev_linecard,
+					       port_index);
 	if (!nsim_dev_port)
 		err = -ENOENT;
 	else
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index aec92440eef1..1e0dc298bf20 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -312,6 +312,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 
 	nsim_ipsec_init(ns);
 
+	netif_carrier_off(dev);
+
 	err = register_netdevice(dev);
 	if (err)
 		goto err_ipsec_teardown;
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index df10f9d11e9d..88b61b9390bf 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -184,6 +184,7 @@ struct nsim_dev_linecard;
 
 struct nsim_dev_port {
 	struct list_head list;
+	struct list_head list_lc; /* node in linecard list */
 	struct devlink_port devlink_port;
 	struct nsim_dev_linecard *linecard;
 	unsigned int port_index;
@@ -196,6 +197,7 @@ struct nsim_dev;
 struct nsim_dev_linecard {
 	struct list_head list;
 	struct nsim_dev *nsim_dev;
+	struct list_head port_list;
 	unsigned int linecard_index;
 	struct dentry *ddir;
 };
@@ -255,8 +257,10 @@ void nsim_dev_exit(void);
 int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);
 void nsim_dev_remove(struct nsim_bus_dev *nsim_bus_dev);
 int nsim_dev_port_add(struct nsim_bus_dev *nsim_bus_dev,
+		      struct nsim_dev_linecard *nsim_dev_linecard,
 		      unsigned int port_index);
 int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
+		      struct nsim_dev_linecard *nsim_dev_linecard,
 		      unsigned int port_index);
 
 struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
-- 
2.26.2

