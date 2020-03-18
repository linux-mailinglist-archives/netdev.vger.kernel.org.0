Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3256189327
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgCRAlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:41:20 -0400
Received: from correo.us.es ([193.147.175.20]:45596 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbgCRAkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B838427F8B2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A91F1DA3A8
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9ECDCDA72F; Wed, 18 Mar 2020 01:39:41 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DFF0DA72F;
        Wed, 18 Mar 2020 01:39:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3ED9F426CCB9;
        Wed, 18 Mar 2020 01:39:39 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 02/29] netfilter: xtables: Add snapshot of hardidletimer target
Date:   Wed, 18 Mar 2020 01:39:29 +0100
Message-Id: <20200318003956.73573-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manoj Basapathi <manojbm@codeaurora.org>

This is a snapshot of hardidletimer netfilter target.

This patch implements a hardidletimer Xtables target that can be
used to identify when interfaces have been idle for a certain period
of time.

Timers are identified by labels and are created when a rule is set
with a new label. The rules also take a timeout value (in seconds) as
an option. If more than one rule uses the same timer label, the timer
will be restarted whenever any of the rules get a hit.

One entry for each timer is created in sysfs. This attribute contains
the timer remaining for the timer to expire. The attributes are
located under the xt_idletimer class:

/sys/class/xt_idletimer/timers/<label>

When the timer expires, the target module sends a sysfs notification
to the userspace, which can then decide what to do (eg. disconnect to
save power)

Compared to IDLETIMER, HARDIDLETIMER can send notifications when
CPU is in suspend too, to notify the timer expiry.

v1->v2: Moved all functionality into IDLETIMER module to avoid
code duplication per comment from Florian.

Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h |  12 +-
 net/netfilter/xt_IDLETIMER.c                | 247 ++++++++++++++++++++++++++--
 2 files changed, 246 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 3c586a19baea..434e6506abaa 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -1,4 +1,3 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 /*
  * linux/include/linux/netfilter/xt_IDLETIMER.h
  *
@@ -33,6 +32,7 @@
 #include <linux/types.h>
 
 #define MAX_IDLETIMER_LABEL_SIZE 28
+#define XT_IDLETIMER_ALARM 0x01
 
 struct idletimer_tg_info {
 	__u32 timeout;
@@ -43,4 +43,14 @@ struct idletimer_tg_info {
 	struct idletimer_tg *timer __attribute__((aligned(8)));
 };
 
+struct idletimer_tg_info_v1 {
+	__u32 timeout;
+
+	char label[MAX_IDLETIMER_LABEL_SIZE];
+
+	__u8 timer_type;
+
+	/* for kernel module internal use only */
+	struct idletimer_tg *timer __attribute__((aligned(8)));
+};
 #endif
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f56d3ed93e56..d620bbf13b30 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -18,6 +18,7 @@
 
 #include <linux/module.h>
 #include <linux/timer.h>
+#include <linux/alarmtimer.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/netfilter.h>
@@ -30,6 +31,7 @@
 
 struct idletimer_tg {
 	struct list_head entry;
+	struct alarm alarm;
 	struct timer_list timer;
 	struct work_struct work;
 
@@ -37,6 +39,7 @@ struct idletimer_tg {
 	struct device_attribute attr;
 
 	unsigned int refcnt;
+	u8 timer_type;
 };
 
 static LIST_HEAD(idletimer_tg_list);
@@ -62,20 +65,30 @@ static ssize_t idletimer_tg_show(struct device *dev,
 {
 	struct idletimer_tg *timer;
 	unsigned long expires = 0;
+	struct timespec64 ktimespec = {};
+	long time_diff = 0;
 
 	mutex_lock(&list_mutex);
 
 	timer =	__idletimer_tg_find_by_label(attr->attr.name);
-	if (timer)
+	if (timer) {
+		if (timer->timer_type & XT_IDLETIMER_ALARM) {
+			ktime_t expires_alarm = alarm_expires_remaining(&timer->alarm);
+			ktimespec = ktime_to_timespec64(expires_alarm);
+			time_diff = ktimespec.tv_sec;
+		} else {
 		expires = timer->timer.expires;
+			time_diff = jiffies_to_msecs(
+						expires - jiffies) / 1000;
+		}
+	}
 
 	mutex_unlock(&list_mutex);
 
-	if (time_after(expires, jiffies))
-		return sprintf(buf, "%u\n",
-			       jiffies_to_msecs(expires - jiffies) / 1000);
+	if (time_after(expires, jiffies) || ktimespec.tv_sec > 0)
+		return snprintf(buf, PAGE_SIZE, "%ld\n", time_diff);
 
-	return sprintf(buf, "0\n");
+	return snprintf(buf, PAGE_SIZE, "0\n");
 }
 
 static void idletimer_tg_work(struct work_struct *work)
@@ -95,6 +108,16 @@ static void idletimer_tg_expired(struct timer_list *t)
 	schedule_work(&timer->work);
 }
 
+static enum alarmtimer_restart idletimer_tg_alarmproc(struct alarm *alarm,
+							  ktime_t now)
+{
+	struct idletimer_tg *timer = alarm->data;
+
+	pr_debug("alarm %s expired\n", timer->attr.attr.name);
+	schedule_work(&timer->work);
+	return ALARMTIMER_NORESTART;
+}
+
 static int idletimer_check_sysfs_name(const char *name, unsigned int size)
 {
 	int ret;
@@ -160,6 +183,68 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 	return ret;
 }
 
+static int idletimer_tg_create_v1(struct idletimer_tg_info_v1 *info)
+{
+	int ret;
+
+	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	if (!info->timer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = idletimer_check_sysfs_name(info->label, sizeof(info->label));
+	if (ret < 0)
+		goto out_free_timer;
+
+	sysfs_attr_init(&info->timer->attr.attr);
+	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	if (!info->timer->attr.attr.name) {
+		ret = -ENOMEM;
+		goto out_free_timer;
+	}
+	info->timer->attr.attr.mode = 0444;
+	info->timer->attr.show = idletimer_tg_show;
+
+	ret = sysfs_create_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	if (ret < 0) {
+		pr_debug("couldn't add file to sysfs");
+		goto out_free_attr;
+	}
+
+	/*  notify userspace  */
+	kobject_uevent(idletimer_tg_kobj,KOBJ_ADD);
+
+	list_add(&info->timer->entry, &idletimer_tg_list);
+		pr_debug("timer type value is %u", info->timer_type);
+	info->timer->timer_type = info->timer_type;
+	info->timer->refcnt = 1;
+
+	INIT_WORK(&info->timer->work, idletimer_tg_work);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout;
+		alarm_init(&info->timer->alarm, ALARM_BOOTTIME,
+			   idletimer_tg_alarmproc);
+		info->timer->alarm.data = info->timer;
+		tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
+		timer_setup(&info->timer->timer, idletimer_tg_expired, 0);
+		mod_timer(&info->timer->timer,
+				msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
+
+	return 0;
+
+out_free_attr:
+	kfree(info->timer->attr.attr.name);
+out_free_timer:
+	kfree(info->timer);
+out:
+	return ret;
+}
+
 /*
  * The actual xt_tables plugin.
  */
@@ -177,13 +262,30 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
 	return XT_CONTINUE;
 }
 
-static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
+/*
+ * The actual xt_tables plugin.
+ */
+static unsigned int idletimer_tg_target_v1(struct sk_buff *skb,
+					 const struct xt_action_param *par)
 {
-	struct idletimer_tg_info *info = par->targinfo;
-	int ret;
+	const struct idletimer_tg_info_v1 *info = par->targinfo;
 
-	pr_debug("checkentry targinfo%s\n", info->label);
+	pr_debug("resetting timer %s, timeout period %u\n",
+		 info->label, info->timeout);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		ktime_t tout = ktime_set(info->timeout, 0);
+		alarm_start_relative(&info->timer->alarm, tout);
+	} else {
+		mod_timer(&info->timer->timer,
+				msecs_to_jiffies(info->timeout * 1000) + jiffies);
+	}
 
+	return XT_CONTINUE;
+}
+
+static int idletimer_tg_helper(struct idletimer_tg_info *info)
+{
 	if (info->timeout == 0) {
 		pr_debug("timeout value is zero\n");
 		return -EINVAL;
@@ -198,7 +300,23 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 		pr_debug("label is empty or not nul-terminated\n");
 		return -EINVAL;
 	}
+	return 0;
+}
 
+
+static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct idletimer_tg_info *info = par->targinfo;
+	int ret;
+
+	pr_debug("checkentry targinfo%s\n", info->label);
+
+	ret = idletimer_tg_helper(info);
+	if(ret < 0)
+	{
+		pr_debug("checkentry helper return invalid\n");
+		return -EINVAL;
+	}
 	mutex_lock(&list_mutex);
 
 	info->timer = __idletimer_tg_find_by_label(info->label);
@@ -222,6 +340,65 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
 	return 0;
 }
 
+static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
+{
+	struct idletimer_tg_info_v1 *info = par->targinfo;
+	int ret;
+
+	pr_debug("checkentry targinfo%s\n", info->label);
+
+	ret = idletimer_tg_helper((struct idletimer_tg_info *)info);
+	if(ret < 0)
+	{
+		pr_debug("checkentry helper return invalid\n");
+		return -EINVAL;
+	}
+
+	if (info->timer_type > XT_IDLETIMER_ALARM) {
+		pr_debug("invalid value for timer type\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&list_mutex);
+
+	info->timer = __idletimer_tg_find_by_label(info->label);
+	if (info->timer) {
+		if (info->timer->timer_type != info->timer_type) {
+			pr_debug("Adding/Replacing rule with same label and different timer type is not allowed\n");
+			mutex_unlock(&list_mutex);
+			return -EINVAL;
+		}
+
+		info->timer->refcnt++;
+		if (info->timer_type & XT_IDLETIMER_ALARM) {
+			/* calculate remaining expiry time */
+			ktime_t tout = alarm_expires_remaining(&info->timer->alarm);
+			struct timespec64 ktimespec = ktime_to_timespec64(tout);
+
+			if (ktimespec.tv_sec > 0) {
+				pr_debug("time_expiry_remaining %lld\n",
+					 ktimespec.tv_sec);
+				alarm_start_relative(&info->timer->alarm, tout);
+			}
+		} else {
+				mod_timer(&info->timer->timer,
+					msecs_to_jiffies(info->timeout * 1000) + jiffies);
+		}
+		pr_debug("increased refcnt of timer %s to %u\n",
+			 info->label, info->timer->refcnt);
+	} else {
+		ret = idletimer_tg_create_v1(info);
+		if (ret < 0) {
+			pr_debug("failed to create timer\n");
+			mutex_unlock(&list_mutex);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&list_mutex);
+	return 0;
+}
+
 static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	const struct idletimer_tg_info *info = par->targinfo;
@@ -247,7 +424,38 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 	mutex_unlock(&list_mutex);
 }
 
-static struct xt_target idletimer_tg __read_mostly = {
+static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
+{
+	const struct idletimer_tg_info_v1 *info = par->targinfo;
+
+	pr_debug("destroy targinfo %s\n", info->label);
+
+	mutex_lock(&list_mutex);
+
+	if (--info->timer->refcnt == 0) {
+		pr_debug("deleting timer %s\n", info->label);
+
+		list_del(&info->timer->entry);
+		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+			alarm_cancel(&info->timer->alarm);
+		} else {
+			del_timer_sync(&info->timer->timer);
+		}
+		cancel_work_sync(&info->timer->work);
+		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+		kfree(info->timer->attr.attr.name);
+		kfree(info->timer);
+	} else {
+		pr_debug("decreased refcnt of timer %s to %u\n",
+			 info->label, info->timer->refcnt);
+	}
+
+	mutex_unlock(&list_mutex);
+}
+
+
+static struct xt_target idletimer_tg[] __read_mostly = {
+	{
 	.name		= "IDLETIMER",
 	.family		= NFPROTO_UNSPEC,
 	.target		= idletimer_tg_target,
@@ -256,6 +464,20 @@ static struct xt_target idletimer_tg __read_mostly = {
 	.checkentry	= idletimer_tg_checkentry,
 	.destroy        = idletimer_tg_destroy,
 	.me		= THIS_MODULE,
+	},
+	{
+	.name		= "IDLETIMER",
+	.family		= NFPROTO_UNSPEC,
+	.revision	= 1,
+	.target		= idletimer_tg_target_v1,
+	.targetsize     = sizeof(struct idletimer_tg_info_v1),
+	.usersize	= offsetof(struct idletimer_tg_info_v1, timer),
+	.checkentry	= idletimer_tg_checkentry_v1,
+	.destroy        = idletimer_tg_destroy_v1,
+	.me		= THIS_MODULE,
+	},
+
+
 };
 
 static struct class *idletimer_tg_class;
@@ -283,7 +505,8 @@ static int __init idletimer_tg_init(void)
 
 	idletimer_tg_kobj = &idletimer_tg_device->kobj;
 
-	err = xt_register_target(&idletimer_tg);
+	err = xt_register_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
+
 	if (err < 0) {
 		pr_debug("couldn't register xt target\n");
 		goto out_dev;
@@ -300,7 +523,7 @@ static int __init idletimer_tg_init(void)
 
 static void __exit idletimer_tg_exit(void)
 {
-	xt_unregister_target(&idletimer_tg);
+	xt_unregister_targets(idletimer_tg, ARRAY_SIZE(idletimer_tg));
 
 	device_destroy(idletimer_tg_class, MKDEV(0, 0));
 	class_destroy(idletimer_tg_class);
-- 
2.11.0

