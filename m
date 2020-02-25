Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E7816BF0C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgBYKpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:45:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45177 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbgBYKpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 05:45:41 -0500
Received: by mail-wr1-f67.google.com with SMTP id g3so14078777wrs.12
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 02:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xEVbBsf2xl+NdwgFKpECjZSEK5xH+edT+7ckGVaAWxI=;
        b=dP5atwxhUp+We4p7jJH5C2+H03hfJ46lDfrAnKhgugujArWJgJKBh6S9QJ+dWeacX4
         BnCVfBy2Il2wrv+uinlhh9BNihvpn3gWIfodqXK+9BlZI9LP9to3pv35+71Zf8uB8N/s
         /58rZv9NmLiCECmNnh/QBq3MeBy8LnTkOswtaUn3lSEWokJqg92DJDBFWWiEF8j6FBCh
         MoO3YPZ0ZyROtCSnVHo317rq/x+N78Z7cLzppBF3C/HBtLf1U7FUUSyHHNBjRunsH9np
         MhwQ6KnJchSvi7AHLWHmnEwwS3/dCLSgfxUKI6rdfeEdFvc90u4eizL20lDbEG2iEYrr
         cKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xEVbBsf2xl+NdwgFKpECjZSEK5xH+edT+7ckGVaAWxI=;
        b=MsyPL9Qx5EYCsj8fdAXVzWrTnpg2ekkcg47lQrUSVgMpLvVEkeH4Odp+14r8pZZ+Yc
         XMBHAtpelFTGmIL5p1r1nlxCiLTakBs4ZB/KuAQq11VvRWrc7Q8moXwxAJr1LdcuVunO
         VcTzaH/+C5oZSrqmh5CJWS2GfEu7Xi+nh73Ubz1FM7sEiTUM6u3bms40Gvv5Nys7PLwq
         oOVg8rBanbvWQCSb25YgXozBTZZXxVgAGu2dXAM9Sh9Re+mFNVJCOyMsNq0RP3lbCztq
         YwjsuxCybWRapMxXhndpn7BNYSzBmM2Vgc22S3W3ttFeWyA1fmbgtVqbnqwSDcyd4+Y0
         lmOw==
X-Gm-Message-State: APjAAAXdisMXBAkF/lmzkH+ilBs/+08WeZDah11o3iSOyEHQEMBQEdPx
        f75EaU/9GBMuizemKrIy5FiJNSy1gws=
X-Google-Smtp-Source: APXvYqxiLG3dK/KtNOrZ97iAXRPK9Q0iJCCwQ8GgbVkgA+uq68etmLkkigWH+sJgrn8R239t3FCkEw==
X-Received: by 2002:a5d:4bcf:: with SMTP id l15mr10253472wrt.0.1582627539766;
        Tue, 25 Feb 2020 02:45:39 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id a184sm3677619wmf.29.2020.02.25.02.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 02:45:39 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [patch net-next v2 09/10] netdevsim: add ACL trap reporting cookie as a metadata
Date:   Tue, 25 Feb 2020 11:45:26 +0100
Message-Id: <20200225104527.2849-10-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225104527.2849-1-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
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
v1->v2:
- remove cookie_len initialization
- return -EINVAL if (*ppos != 0)
- added __GFP_NOWARN flag to buf malloc
- removed u8 * cast in hex2bin call which is no longer needed
- changed names of error path labels
---
 drivers/net/netdevsim/dev.c       | 117 +++++++++++++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h |   2 +
 2 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index aa17533c06e1..f81c47377f32 100644
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
@@ -71,6 +72,98 @@ static const struct file_operations nsim_dev_take_snapshot_fops = {
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
+	size_t cookie_len;
+	ssize_t ret;
+	char *buf;
+
+	if (*ppos != 0)
+		return -EINVAL;
+	cookie_len = (count - 1) / 2;
+	if ((count - 1) % 2)
+		return -EINVAL;
+	buf = kmalloc(count, GFP_KERNEL | __GFP_NOWARN);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = simple_write_to_buffer(buf, count, ppos, data, count);
+	if (ret < 0)
+		goto free_buf;
+
+	fa_cookie = kmalloc(sizeof(*fa_cookie) + cookie_len,
+			    GFP_KERNEL | __GFP_NOWARN);
+	if (!fa_cookie) {
+		ret = -ENOMEM;
+		goto free_buf;
+	}
+
+	fa_cookie->cookie_len = cookie_len;
+	ret = hex2bin(fa_cookie->cookie, buf, cookie_len);
+	if (ret)
+		goto free_fa_cookie;
+	kfree(buf);
+
+	spin_lock(&nsim_dev->fa_cookie_lock);
+	kfree(nsim_dev->fa_cookie);
+	nsim_dev->fa_cookie = fa_cookie;
+	spin_unlock(&nsim_dev->fa_cookie_lock);
+
+	return count;
+
+free_fa_cookie:
+	kfree(fa_cookie);
+free_buf:
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
@@ -97,6 +190,8 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 			    &nsim_dev->dont_allow_reload);
 	debugfs_create_bool("fail_reload", 0600, nsim_dev->ddir,
 			    &nsim_dev->fail_reload);
+	debugfs_create_file("trap_flow_action_cookie", 0600, nsim_dev->ddir,
+			    nsim_dev, &nsim_dev_trap_fa_cookie_fops);
 	return 0;
 }
 
@@ -288,6 +383,10 @@ enum {
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
@@ -309,6 +408,10 @@ static const struct devlink_trap nsim_traps_arr[] = {
 	NSIM_TRAP_DROP(BLACKHOLE_ROUTE, L3_DROPS),
 	NSIM_TRAP_EXCEPTION(TTL_ERROR, L3_DROPS),
 	NSIM_TRAP_DROP(TAIL_DROP, BUFFER_DROPS),
+	NSIM_TRAP_DROP_EXT(INGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
+	NSIM_TRAP_DROP_EXT(EGRESS_FLOW_ACTION_DROP, ACL_DROPS,
+			   DEVLINK_TRAP_METADATA_TYPE_F_FA_COOKIE),
 };
 
 #define NSIM_TRAP_L4_DATA_LEN 100
@@ -366,8 +469,13 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
 
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
@@ -383,10 +491,12 @@ static void nsim_dev_trap_report(struct nsim_dev_port *nsim_dev_port)
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
@@ -780,6 +890,7 @@ int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev)
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

