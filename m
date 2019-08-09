Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30BCE8782C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406260AbfHILFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:05:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35757 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405954AbfHILFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:05:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id k2so12004862wrq.2
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 04:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u/WqoW8pObnjtOoRl9ErmLFITB0o+RyIX2FMWykPUco=;
        b=adDDzrEdH1ZNfIodFd0y2E9eC9SvyWgidjzBCj9Wx9yCVwgbnhFMkkp1DgLKjJ60Qc
         MiwJTcq8bzQrWSJ0i/GutN3hA8NGuBZ48fr6W6qs8W8638UJNrjDaSCDYYhOqm3Mdy5P
         hfrG56gmojkX88C5TePfaIadoEIn9fwb4Ys0fZ9dHFkxcg8aQE2RaqI1pkp/Twt4orHF
         dCRHnVq2yY4NsjXpNTqneig2UnMWit2jI7NFPqdrevLCkKs3YzxH7ZUJVvo9ZnKoPdXp
         XfBHrgyk8rEv8VSCp9QA694EcFg744Xt1wPXtBKO0QCV1ylki2K/Hyx2j6oZO3RNFJ15
         Np2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u/WqoW8pObnjtOoRl9ErmLFITB0o+RyIX2FMWykPUco=;
        b=aWLUU1xpg+4W9hKy+UbOfB7gJt3CsT6DD5YNe4hQ8od8mCWDkvMV1UE1uADkz3TTp7
         lZpWR4g0MMz0+gs18iGWGPdritClzjwkinVANwnBbJ6o+D1JkqtrUwcS1SSHiWHgJf42
         Vf6V24qvOCODqwRsvZQEDJeIa5T855AlsfI5ZPpatPoYHq9d80PfOARNT8WY/ON0pvra
         ZuELjMKPwrgMsEN6ot0DW5H9kHQVWflGqQjarKI4X7n/JGXM+PEXRf++9nz3uVNb72Do
         euin0CZDJxONOpyJ9jdKmxRYOew804vRF+Z/Pg7mU7n5OZvyCEXhHCWA5EQ7x2gwOnfA
         yMYw==
X-Gm-Message-State: APjAAAWxvCzFumhTuAdlCNyYQg6TWhuYN9EXuWeIUCCoa8BS7fVbO5gW
        7TlreJs6IGI/5zsMGodm4hF4Ik0VsDw=
X-Google-Smtp-Source: APXvYqwoxmGl2bRjQxTcBUIIepjDM+eeL/Sf7fgKwZgdrmn1OcYm5QBI//GRYr9Ygcil5lrH1YPl2A==
X-Received: by 2002:a5d:4d81:: with SMTP id b1mr24601007wru.27.1565348714067;
        Fri, 09 Aug 2019 04:05:14 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f10sm85599582wrs.22.2019.08.09.04.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2019 04:05:13 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: [patch net-next] netdevsim: register couple of devlink params
Date:   Fri,  9 Aug 2019 13:05:12 +0200
Message-Id: <20190809110512.31779-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Register couple of devlink params, one generic, one driver-specific.
Make the values available over debugfs.

Example:
$ echo "111" > /sys/bus/netdevsim/new_device
$ devlink dev param
netdevsim/netdevsim111:
  name max_macs type generic
    values:
      cmode driverinit value 32
  name test1 type driver-specific
    values:
      cmode driverinit value true
$ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
32
$ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
Y
$ devlink dev param set netdevsim/netdevsim111 name max_macs cmode driverinit value 16
$ devlink dev param set netdevsim/netdevsim111 name test1 cmode driverinit value false
$ devlink dev reload netdevsim/netdevsim111
$ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
16
$ cat /sys/kernel/debug/netdevsim/netdevsim111/test1

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 72 ++++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |  2 +
 2 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 685dd21f5500..127aef85dc99 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -40,6 +40,10 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		return PTR_ERR_OR_ZERO(nsim_dev->ports_ddir) ?: -EINVAL;
 	debugfs_create_bool("fw_update_status", 0600, nsim_dev->ddir,
 			    &nsim_dev->fw_update_status);
+	debugfs_create_u32("max_macs", 0600, nsim_dev->ddir,
+			   &nsim_dev->max_macs);
+	debugfs_create_bool("test1", 0600, nsim_dev->ddir,
+			    &nsim_dev->test1);
 	return 0;
 }
 
@@ -196,6 +200,54 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 	return err;
 }
 
+enum nsim_devlink_param_id {
+	NSIM_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	NSIM_DEVLINK_PARAM_ID_TEST1,
+};
+
+static const struct devlink_param nsim_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(MAX_MACS,
+			      BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, NULL),
+	DEVLINK_PARAM_DRIVER(NSIM_DEVLINK_PARAM_ID_TEST1,
+			     "test1", DEVLINK_PARAM_TYPE_BOOL,
+			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			     NULL, NULL, NULL),
+};
+
+static void nsim_devlink_set_params_init_values(struct nsim_dev *nsim_dev,
+						struct devlink *devlink)
+{
+	union devlink_param_value value;
+
+	value.vu32 = nsim_dev->max_macs;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					   value);
+	value.vbool = nsim_dev->test1;
+	devlink_param_driverinit_value_set(devlink,
+					   NSIM_DEVLINK_PARAM_ID_TEST1,
+					   value);
+}
+
+static void nsim_devlink_param_load_driverinit_values(struct devlink *devlink)
+{
+	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	union devlink_param_value saved_value;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+						 &saved_value);
+	if (!err)
+		nsim_dev->max_macs = saved_value.vu32;
+	err = devlink_param_driverinit_value_get(devlink,
+						 NSIM_DEVLINK_PARAM_ID_TEST1,
+						 &saved_value);
+	if (!err)
+		nsim_dev->test1 = saved_value.vbool;
+}
+
 static int nsim_dev_reload(struct devlink *devlink,
 			   struct netlink_ext_ack *extack)
 {
@@ -218,6 +270,7 @@ static int nsim_dev_reload(struct devlink *devlink,
 				return err;
 		}
 	}
+	nsim_devlink_param_load_driverinit_values(devlink);
 
 	return 0;
 }
@@ -267,6 +320,9 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
 	.flash_update = nsim_dev_flash_update,
 };
 
+#define NSIM_DEV_MAX_MACS_DEFAULT 32
+#define NSIM_DEV_TEST1_DEFAULT true
+
 static struct nsim_dev *
 nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
 		unsigned int port_count)
@@ -286,6 +342,8 @@ nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
 	INIT_LIST_HEAD(&nsim_dev->port_list);
 	mutex_init(&nsim_dev->port_list_lock);
 	nsim_dev->fw_update_status = true;
+	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
+	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
 
 	nsim_dev->fib_data = nsim_fib_create();
 	if (IS_ERR(nsim_dev->fib_data)) {
@@ -301,18 +359,28 @@ nsim_dev_create(struct net *net, struct nsim_bus_dev *nsim_bus_dev,
 	if (err)
 		goto err_resources_unregister;
 
-	err = nsim_dev_debugfs_init(nsim_dev);
+	err = devlink_params_register(devlink, nsim_devlink_params,
+				      ARRAY_SIZE(nsim_devlink_params));
 	if (err)
 		goto err_dl_unregister;
+	nsim_devlink_set_params_init_values(nsim_dev, devlink);
+
+	err = nsim_dev_debugfs_init(nsim_dev);
+	if (err)
+		goto err_params_unregister;
 
 	err = nsim_bpf_dev_init(nsim_dev);
 	if (err)
 		goto err_debugfs_exit;
 
+	devlink_params_publish(devlink);
 	return nsim_dev;
 
 err_debugfs_exit:
 	nsim_dev_debugfs_exit(nsim_dev);
+err_params_unregister:
+	devlink_params_unregister(devlink, nsim_devlink_params,
+				  ARRAY_SIZE(nsim_devlink_params));
 err_dl_unregister:
 	devlink_unregister(devlink);
 err_resources_unregister:
@@ -330,6 +398,8 @@ static void nsim_dev_destroy(struct nsim_dev *nsim_dev)
 
 	nsim_bpf_dev_exit(nsim_dev);
 	nsim_dev_debugfs_exit(nsim_dev);
+	devlink_params_unregister(devlink, nsim_devlink_params,
+				  ARRAY_SIZE(nsim_devlink_params));
 	devlink_unregister(devlink);
 	devlink_resources_unregister(devlink, NULL);
 	nsim_fib_destroy(nsim_dev->fib_data);
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 9563acb61b03..ef879892dd6f 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -161,6 +161,8 @@ struct nsim_dev {
 	struct list_head port_list;
 	struct mutex port_list_lock; /* protects port list */
 	bool fw_update_status;
+	u32 max_macs;
+	bool test1;
 };
 
 int nsim_dev_init(void);
-- 
2.21.0

