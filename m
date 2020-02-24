Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6916B18D
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgBXVIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:08:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43581 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbgBXVIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:08:14 -0500
Received: by mail-wr1-f66.google.com with SMTP id r11so12105957wrq.10
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:08:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7IrBG6sDDSjH67uOMDiHoyP/usFuBXt0CiL+KAG9+8=;
        b=WhhBp2Zjplai00aaJcEwI4/svTbLg9jNxIJyafc0p0TE8n9nkVIFsNwa9kPL3tOqkb
         YmHHVg7VyjfgZ9uLxE5J/ifnnaM6MGMNTFng4qDqqWCNbDB5WJOEfeRJWwwDVvZkU/oG
         mV7YgZxrwVpKdHe6eXzvBDSlU+RlYB1JyEGJvC4QLJcg30cfWPt3NFIsgZoaBwUZDDZQ
         /h9HurYc0znhN0FOkjKxGX6IC4jRLUfOxfZGPy00Us/cBTykxvwTz7BEIyCKT8AmE5Pp
         0olzVNrXxfhhfuzGxCLTKImHQu6aYKTqfrxtw5+bWenoBnbYeDWwgYeGCFBqrXoOsE+e
         MKHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7IrBG6sDDSjH67uOMDiHoyP/usFuBXt0CiL+KAG9+8=;
        b=O3NrzoCt0Pk+bE2+RJYQqFdKMYIggDlhJKPzKU89zBtoM/xzC9RWbbr3S4LZmH9gj4
         r43RoP0sqz0w6tNNIWZTar8Nd4BUHQFN5/k0cxxRcuw4DjcU2t4I9sM4g3T0pr7kgDjP
         zfE63dDVYnPvEZlnhqn53mPN81Ylkzdkn83PNj3nQmf1KuYzJW3RnTf+qdZTc4oqPP4R
         jOHoFRWh4MxVOuCf5OWUAV09u8FqN1RVUVd2hBNUupmAarLujUJtbEK17Xh+4z7c5CRB
         Vhyh/ZnpwsMenDKnfxdLrTVc1JwzvWHgSbfF8YQLmiNYjlhFmYr910kaqpvtrT6TN3f1
         qDuQ==
X-Gm-Message-State: APjAAAVmgtlGic5xNcSAmAnGwYsiwUVQLrAcz4Rx2SXEt4ASvWNcr3s/
        EYZZp5hEVY+Dw1RJ6F498oOGW78Gbi8=
X-Google-Smtp-Source: APXvYqyxBBE740InurqGFvbPgwqHWfOMvf2tUDIMQZa/P4mAHe5/px3KEEf0oEepTVmlP7hrx15XsQ==
X-Received: by 2002:a5d:4b03:: with SMTP id v3mr71643539wrq.178.1582578491743;
        Mon, 24 Feb 2020 13:08:11 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a9sm21424039wrn.3.2020.02.24.13.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:08:11 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next 09/10] netdevsim: add ACL trap reporting cookie as a metadata
Date:   Mon, 24 Feb 2020 22:07:57 +0100
Message-Id: <20200224210758.18481-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200224210758.18481-1-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add new trap ACL which reports flow action cookie in a metadata. Allow
used to setup the cookie using debugfs file.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/netdevsim/dev.c       | 118 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   2 +
 2 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index aa17533c06e1..71b60e06b141 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <net/devlink.h>
 #include <net/ip.h>
+#include <net/flow_offload.h>
 #include <uapi/linux/devlink.h>
 #include <uapi/linux/ip.h>
 #include <uapi/linux/udp.h>
@@ -71,6 +72,99 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
 	.llseek = generic_file_llseek,
 };
 
+static ssize_t nsim_dev_trap_fa_cookie_read(struct file *file,
+					    char __user *data,
+					    size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	struct flow_action_cookie *fa_cookie;
+	unsigned int buf_len;
+	ssize_t ret;
+	char *buf;
+
+	spin_lock(&nsim_dev->fa_cookie_lock);
+	fa_cookie = nsim_dev->fa_cookie;
+	if (!fa_cookie) {
+		ret = -EINVAL;
+		goto errout;
+	}
+	buf_len = fa_cookie->cookie_len * 2;
+	buf = kmalloc(buf_len, GFP_ATOMIC);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto errout;
+	}
+	bin2hex(buf, fa_cookie->cookie, fa_cookie->cookie_len);
+	spin_unlock(&nsim_dev->fa_cookie_lock);
+
+	ret = simple_read_from_buffer(data, count, ppos, buf, buf_len);
+
+	kfree(buf);
+	return ret;
+
+errout:
+	spin_unlock(&nsim_dev->fa_cookie_lock);
+	return ret;
+}
+
+static ssize_t nsim_dev_trap_fa_cookie_write(struct file *file,
+					     const char __user *data,
+					     size_t count, loff_t *ppos)
+{
+	struct nsim_dev *nsim_dev = file->private_data;
+	struct flow_action_cookie *fa_cookie;
+	size_t cookie_len = count / 2;
+	ssize_t ret;
+	char *buf;
+
+	if (*ppos != 0)
+		return 0;
+	cookie_len = (count - 1) / 2;
+	if ((count - 1) % 2)
+		return -EINVAL;
+	buf = kmalloc(count, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buf, count, ppos, data, count);
+	if (ret < 0)
+		goto err_write_to_buffer;
+
+	fa_cookie = kmalloc(sizeof(*fa_cookie) + cookie_len,
+			    GFP_KERNEL | __GFP_NOWARN);
+	if (!fa_cookie) {
+		ret = -ENOMEM;
+		goto err_alloc_cookie;
+	}
+
+	fa_cookie->cookie_len = cookie_len;
+	ret = hex2bin((u8 *) fa_cookie->cookie, buf, cookie_len);
+	if (ret)
+		goto err_hex2bin;
+	kfree(buf);
+
+	spin_lock(&nsim_dev->fa_cookie_lock);
+	kfree(nsim_dev->fa_cookie);
+	nsim_dev->fa_cookie = fa_cookie;
+	spin_unlock(&nsim_dev->fa_cookie_lock);
+
+	return count;
+
+err_hex2bin:
+	kfree(fa_cookie);
+err_alloc_cookie:
+err_write_to_buffer:
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations nsim_dev_trap_fa_cookie_fops = {
+	.open = simple_open,
+	.read = nsim_dev_trap_fa_cookie_read,
+	.write = nsim_dev_trap_fa_cookie_write,
+	.llseek = generic_file_llseek,
+};
+
 static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 {
 	char dev_ddir_name[sizeof(DRV_NAME) + 10];
@@ -97,6 +191,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->dont_allow_reload);
 	debugfs_create_bool("fail_reload", 0600, nsim_dev->ddir,
 			    &nsim_dev->fail_reload);
+	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
+			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
 	return 0;
 }
 
@@ -288,6 +384,10 @@ enum {
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
 			     NSIM_TRAP_METADATA)
+#define NSIM_TRAP_DROP_EXT(_id, _group_id, _metadata)			      \
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				      \
+			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
+			     NSIM_TRAP_METADATA | (_metadata))
 #define NSIM_TRAP_EXCEPTION(_id, _group_id)				      \
 	DEVLINK_TRAP_GENERIC(EXCEPTION, TRAP, _id,			      \
 			     DEVLINK_TRAP_GROUP_GENERIC(_group_id),	      \
@@ -309,6 +409,10 @@ static const struct devlink_trap nsim_traps_arr[] = {
 	NSIM_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
 	NSIM_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
 	NSIM_TRAP_DROP(TAIL_DROP, BUFFER_DROPS),
+	NSIM_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+	NSIM_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
 };
 
 #define NSIM_TRAP_L4_DATA_LEN 100
@@ -366,8 +470,13 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
 
 	spin_lock(&nsim_trap_data->trap_lock);
 	for (i = 0; i < ARRAY_SIZE(nsim_traps_arr); i++) {
+		struct flow_action_cookie *fa_cookie = NULL;
 		struct nsim_trap_item *nsim_trap_item;
 		struct sk_buff *skb;
+		bool has_fa_cookie;
+
+		has_fa_cookie = nsim_traps_arr[i].metadata_cap &
+				DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE;
 
 		nsim_trap_item = &nsim_trap_data->trap_items_arr[i];
 		if (nsim_trap_item->action == DEVLINK_TRAP_ACTION_DROP)
@@ -383,10 +492,12 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
 		 * softIRQs to prevent lockdep from complaining about
 		 * "incosistent lock state".
 		 */
-		local_bh_disable();
+
+		spin_lock_bh(&nsim_dev->fa_cookie_lock);
+		fa_cookie = has_fa_cookie ? nsim_dev->fa_cookie : NULL;
 		devlink_trap_report(devlink, skb, nsim_trap_item->trap_ctx,
-				    &nsim_dev_port->devlink_port, NULL);
-		local_bh_enable();
+				    &nsim_dev_port->devlink_port, fa_cookie);
+		spin_unlock_bh(&nsim_dev->fa_cookie_lock);
 		consume_skb(skb);
 	}
 	spin_unlock(&nsim_trap_data->trap_lock);
@@ -780,6 +891,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
 	nsim_dev->fw_update_status = true;
 	nsim_dev->max_macs = NSIM_DEV_MAX_MACS_DEFAULT;
 	nsim_dev->test1 = NSIM_DEV_TEST1_DEFAULT;
+	spin_lock_init(&nsim_dev->fa_cookie_lock);
 
 	dev_set_drvdata(&nsim_bus_dev->dev, nsim_dev);
 
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 2eb7b0dc1594..e46fc565b981 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -178,6 +178,8 @@ struct nsim_dev {
 	bool fail_reload;
 	struct devlink_region *dummy_region;
 	struct nsim_dev_health health;
+	struct flow_action_cookie *fa_cookie;
+	spinlock_t fa_cookie_lock; /* protects fa_cookie */
 };
 
 static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
-- 
2.21.1

