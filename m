Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F04EFAE0
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 11:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbfKEKWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 05:22:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50644 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730633AbfKEKWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 05:22:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4178A61014; Tue,  5 Nov 2019 10:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572949360;
        bh=9EbxZEZV9X0B6w/lwrKzu3C3DCe9ei1aKt4Yhbt4/zU=;
        h=Date:From:To:Subject:From;
        b=XJQrOQRQBYmNFS5AeAyF5sDzyr+EsUSTYNHJJB/7AkAM8fH9qRixtnbW2+Rv+p4m/
         EjbDhpN7Xxpd9dZyniEJ73y0VuNbG1bkSJBEyai5O5NRjilKlD6QYJfOYiSuO3dqbg
         8ndd27CfOPFAeh4B2hqu6N4/Y3Oe6F0/hszlW3fM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from manojbm-linux.ap.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 64AFC6022B
        for <netdev@vger.kernel.org>; Tue,  5 Nov 2019 10:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572949359;
        bh=9EbxZEZV9X0B6w/lwrKzu3C3DCe9ei1aKt4Yhbt4/zU=;
        h=Date:From:To:Subject:From;
        b=Oul57YwcTJGZF8F/K1wgwHhE8Y48EUWtNzZ9PfdiXZZ8YmTZpm72KORheNvwvUHXm
         A3lYnEO23/kTml0Er1XVhzYmawYsr7zhbIBfJ7J67g72L1F//DfIVNg8nX5lGNHG+e
         0l6y+K6Y0bXc/Oy6PKTSuCO87y2hV6lpwssanoo4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 64AFC6022B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=manojbm@codeaurora.org
Date:   Tue, 5 Nov 2019 15:52:24 +0530
From:   Manoj Basapathi <manojbm@codeaurora.org>
To:     netdev@vger.kernel.org
Subject: [PATCH] netfilter: xtables: Add snapshot of hardidletimer target
Message-ID: <20191105102210.GA18988@manojbm-linux.ap.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a snapshot of hardifletimer netfilter target as of msm-4.4
commit 469a150b7426 ("netfilter: xtables: hardidletimer target implementation")

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

/sys/class/xt_hardidletimer/timers/<label>

When the timer expires, the target module sends a sysfs notification
to the userspace, which can then decide what to do (eg. disconnect to
save power)

Compared to xt_IDLETIMER, xt_HARDIDLETIMER can send notifications when
CPU is in suspend too, to notify the timer expiry.

CRs-Fixed: 1078373
Change-Id: Ib2e05af7267f3c86d1967f149f7e7e782c59807e
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
---
 .../uapi/linux/netfilter/xt_HARDIDLETIMER.h   |  51 +++
 net/netfilter/Kconfig                         |  14 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/xt_HARDIDLETIMER.c              | 381 ++++++++++++++++++
 net/netfilter/xt_IDLETIMER.c                  |   2 +
 5 files changed, 449 insertions(+)
 create mode 100644 include/uapi/linux/netfilter/xt_HARDIDLETIMER.h
 create mode 100644 net/netfilter/xt_HARDIDLETIMER.c

diff --git a/include/uapi/linux/netfilter/xt_HARDIDLETIMER.h b/include/uapi/linux/netfilter/xt_HARDIDLETIMER.h
new file mode 100644
index 000000000000..7cd4a2e39b86
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_HARDIDLETIMER.h
@@ -0,0 +1,51 @@
+/*
+ * linux/include/linux/netfilter/xt_HARDIDLETIMER.h
+ *
+ * Header file for Xtables timer target module.
+ *
+ * Copyright (c) 2014, 2017 The Linux Foundation. All rights reserved.
+ *
+ * Copyright (C) 2004, 2010 Nokia Corporation
+ *
+ * Written by Timo Teras <ext-timo.teras@nokia.com>
+ *
+ * Converted to x_tables and forward-ported to 2.6.34
+ * by Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#ifndef _XT_HARDIDLETIMER_H
+#define _XT_HARDIDLETIMER_H
+
+#include <linux/types.h>
+
+#define MAX_HARDIDLETIMER_LABEL_SIZE 28
+#define NLMSG_MAX_SIZE 64
+
+#define NL_EVENT_TYPE_INACTIVE 0
+#define NL_EVENT_TYPE_ACTIVE 1
+
+struct hardidletimer_tg_info {
+	__u32 timeout;
+
+	char label[MAX_HARDIDLETIMER_LABEL_SIZE];
+
+	/* Use netlink messages for notification in addition to sysfs */
+	__u8 send_nl_msg;
+
+	/* for kernel module internal use only */
+	struct hardidletimer_tg *timer __attribute__((aligned(8)));
+};
+
+#endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 91efae88e8c2..cd0ce929a59f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -893,6 +893,20 @@ config NETFILTER_XT_TARGET_IDLETIMER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_HARDIDLETIMER
+	tristate  "HARDIDLETIMER target support"
+	depends on NETFILTER_ADVANCED
+	help
+
+	  This option adds the `HARDIDLETIMER' target.  Each matching packet
+	  resets the timer associated with label specified when the rule is
+	  added.  When the timer expires, it triggers a sysfs notification.
+	  The remaining time for expiration can be read via sysfs.
+	   Compared to IDLETIMER HARDIDLETIMER will send notification when
+	   CPU in suspend too.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_LED
 	tristate '"LED" target support'
 	depends on LEDS_CLASS && LEDS_TRIGGERS
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4fc075b612fe..ecbe48437fbd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -157,6 +157,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_HARDIDLETIMER) += xt_HARDIDLETIMER.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_ADDRTYPE) += xt_addrtype.o
diff --git a/net/netfilter/xt_HARDIDLETIMER.c b/net/netfilter/xt_HARDIDLETIMER.c
new file mode 100644
index 000000000000..ea8b103a3f39
--- /dev/null
+++ b/net/netfilter/xt_HARDIDLETIMER.c
@@ -0,0 +1,381 @@
+/*
+ * linux/net/netfilter/xt_HARDIDLETIMER.c
+ *
+ * Netfilter module to trigger a timer when packet matches.
+ * After timer expires a kevent will be sent.
+ *
+ * Copyright (c) 2014-2015, 2017-2018, The Linux Foundation.
+ * All rights reserved.
+ *
+ * Copyright (C) 2004, 2010 Nokia Corporation
+ *
+ * Written by Timo Teras <ext-timo.teras@nokia.com>
+ *
+ * Converted to x_tables and reworked for upstream inclusion
+ * by Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/timer.h>
+#include <linux/alarmtimer.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_HARDIDLETIMER.h>
+#include <linux/kdev_t.h>
+#include <linux/kobject.h>
+#include <linux/skbuff.h>
+#include <linux/workqueue.h>
+#include <linux/sysfs.h>
+#include <net/net_namespace.h>
+
+struct hardidletimer_tg_attr {
+	struct attribute attr;
+	ssize_t	(*show)(struct kobject *kobj,
+			struct attribute *attr, char *buf);
+};
+
+struct hardidletimer_tg {
+	struct list_head entry;
+	struct alarm alarm;
+	struct work_struct work;
+
+	struct kobject *kobj;
+	struct hardidletimer_tg_attr attr;
+
+	unsigned int refcnt;
+	bool send_nl_msg;
+	bool active;
+};
+
+static LIST_HEAD(hardidletimer_tg_list);
+static DEFINE_MUTEX(list_mutex);
+
+static struct kobject *hardidletimer_tg_kobj;
+
+static void notify_netlink_uevent(const char *iface,
+				  struct hardidletimer_tg *timer)
+{
+	char iface_msg[NLMSG_MAX_SIZE];
+	char state_msg[NLMSG_MAX_SIZE];
+	char *envp[] = { iface_msg, state_msg, NULL };
+	int res;
+
+	res = snprintf(iface_msg, NLMSG_MAX_SIZE, "INTERFACE=%s",
+		       iface);
+	if (res >= NLMSG_MAX_SIZE) {
+		pr_err("message too long (%d)", res);
+		return;
+	}
+	res = snprintf(state_msg, NLMSG_MAX_SIZE, "STATE=%s",
+		       timer->active ? "active" : "inactive");
+	if (res >= NLMSG_MAX_SIZE) {
+		pr_err("message too long (%d)", res);
+		return;
+	}
+	pr_debug("putting nlmsg: <%s> <%s>\n", iface_msg, state_msg);
+	kobject_uevent_env(hardidletimer_tg_kobj, KOBJ_CHANGE, envp);
+}
+
+static
+struct hardidletimer_tg *__hardidletimer_tg_find_by_label(const char *label)
+{
+	struct hardidletimer_tg *entry;
+
+	WARN_ON(!label);
+
+	list_for_each_entry(entry, &hardidletimer_tg_list, entry) {
+		if (!strcmp(label, entry->attr.attr.name))
+			return entry;
+	}
+
+	return NULL;
+}
+
+static ssize_t hardidletimer_tg_show(struct kobject *kobj,
+				     struct attribute *attr, char *buf)
+{
+	struct hardidletimer_tg *timer;
+	ktime_t expires;
+	struct timespec ktimespec;
+
+	memset(&ktimespec, 0, sizeof(struct timespec));
+	mutex_lock(&list_mutex);
+
+	timer =	__hardidletimer_tg_find_by_label(attr->name);
+	if (timer) {
+		expires = alarm_expires_remaining(&timer->alarm);
+		ktimespec = ktime_to_timespec(expires);
+	}
+
+	mutex_unlock(&list_mutex);
+
+	if (ktimespec.tv_sec >= 0)
+		return snprintf(buf, PAGE_SIZE, "%ld\n", ktimespec.tv_sec);
+
+	if ((timer) && timer->send_nl_msg)
+		return snprintf(buf, PAGE_SIZE, "0 %ld\n", ktimespec.tv_sec);
+	else
+		return snprintf(buf, PAGE_SIZE, "0\n");
+}
+
+static void hardidletimer_tg_work(struct work_struct *work)
+{
+	struct hardidletimer_tg *timer = container_of(work,
+				struct hardidletimer_tg, work);
+
+	sysfs_notify(hardidletimer_tg_kobj, NULL, timer->attr.attr.name);
+
+	if (timer->send_nl_msg)
+		notify_netlink_uevent(timer->attr.attr.name, timer);
+}
+
+static enum alarmtimer_restart hardidletimer_tg_alarmproc(struct alarm *alarm,
+							  ktime_t now)
+{
+	struct hardidletimer_tg *timer = alarm->data;
+
+	pr_debug("alarm %s expired\n", timer->attr.attr.name);
+
+	timer->active = false;
+	schedule_work(&timer->work);
+	return ALARMTIMER_NORESTART;
+}
+
+static int hardidletimer_tg_create(struct hardidletimer_tg_info *info)
+{
+	int ret;
+	ktime_t tout;
+
+	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	if (!info->timer) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	info->timer->attr.attr.name = kstrdup(info->label, GFP_KERNEL);
+	if (!info->timer->attr.attr.name) {
+		ret = -ENOMEM;
+		goto out_free_timer;
+	}
+	info->timer->attr.attr.mode = 0444;
+	info->timer->attr.show = hardidletimer_tg_show;
+
+	ret = sysfs_create_file(hardidletimer_tg_kobj, &info->timer->attr.attr);
+	if (ret < 0) {
+		pr_debug("couldn't add file to sysfs");
+		goto out_free_attr;
+	}
+	/*  notify userspace  */
+	kobject_uevent(hardidletimer_tg_kobj, KOBJ_ADD);
+
+	list_add(&info->timer->entry, &hardidletimer_tg_list);
+
+	alarm_init(&info->timer->alarm, ALARM_BOOTTIME,
+		   hardidletimer_tg_alarmproc);
+	info->timer->alarm.data = info->timer;
+	info->timer->refcnt = 1;
+	info->timer->send_nl_msg = (info->send_nl_msg == 0) ? false : true;
+	info->timer->active = true;
+	tout = ktime_set(info->timeout, 0);
+	alarm_start_relative(&info->timer->alarm, tout);
+
+	INIT_WORK(&info->timer->work, hardidletimer_tg_work);
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
+/* The actual xt_tables plugin. */
+static unsigned int hardidletimer_tg_target(struct sk_buff *skb,
+					    const struct xt_action_param *par)
+{
+	const struct hardidletimer_tg_info *info = par->targinfo;
+	ktime_t tout;
+
+	pr_debug("resetting timer %s, timeout period %u\n",
+		 info->label, info->timeout);
+
+	WARN_ON(!info->timer);
+
+	if (!info->timer->active) {
+		schedule_work(&info->timer->work);
+		pr_debug("Starting timer %s\n", info->label);
+	}
+
+	info->timer->active = true;
+	/* TODO: Avoid modifying timers on each packet */
+	tout = ktime_set(info->timeout, 0);
+	alarm_start_relative(&info->timer->alarm, tout);
+
+	return XT_CONTINUE;
+}
+
+static int hardidletimer_tg_checkentry(const struct xt_tgchk_param *par)
+{
+	struct hardidletimer_tg_info *info = par->targinfo;
+	int ret;
+	ktime_t tout;
+	struct timespec ktimespec;
+
+	memset(&ktimespec, 0, sizeof(struct timespec));
+
+	pr_debug("checkentry targinfo %s\n", info->label);
+
+	if (info->timeout == 0) {
+		pr_debug("timeout value is zero\n");
+		return -EINVAL;
+	}
+
+	if (info->label[0] == '\0' ||
+	    strnlen(info->label, MAX_HARDIDLETIMER_LABEL_SIZE)
+				== MAX_HARDIDLETIMER_LABEL_SIZE) {
+		pr_debug("label is empty or not nul-terminated\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&list_mutex);
+
+	info->timer = __hardidletimer_tg_find_by_label(info->label);
+	if (info->timer) {
+		info->timer->refcnt++;
+		/* calculate remaining expiry time */
+		tout = alarm_expires_remaining(&info->timer->alarm);
+		ktimespec = ktime_to_timespec(tout);
+
+		if (ktimespec.tv_sec > 0) {
+			pr_debug("time_expiry_remaining %ld\n",
+				 ktimespec.tv_sec);
+			alarm_start_relative(&info->timer->alarm, tout);
+		}
+
+		pr_debug("increased refcnt of timer %s to %u\n",
+			 info->label, info->timer->refcnt);
+	} else {
+		ret = hardidletimer_tg_create(info);
+		if (ret < 0) {
+			pr_debug("failed to create timer\n");
+			mutex_unlock(&list_mutex);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&list_mutex);
+
+	return 0;
+}
+
+static void hardidletimer_tg_destroy(const struct xt_tgdtor_param *par)
+{
+	const struct hardidletimer_tg_info *info = par->targinfo;
+
+	pr_debug("destroy targinfo %s\n", info->label);
+
+	mutex_lock(&list_mutex);
+
+	if (--info->timer->refcnt == 0) {
+		pr_debug("deleting timer %s\n", info->label);
+
+		list_del(&info->timer->entry);
+		alarm_cancel(&info->timer->alarm);
+		cancel_work_sync(&info->timer->work);
+		sysfs_remove_file(hardidletimer_tg_kobj,
+				  &info->timer->attr.attr);
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
+static struct xt_target hardidletimer_tg __read_mostly = {
+	.name		= "HARDIDLETIMER",
+	.revision	= 1,
+	.family		= NFPROTO_UNSPEC,
+	.target		= hardidletimer_tg_target,
+	.targetsize     = sizeof(struct hardidletimer_tg_info),
+	.checkentry	= hardidletimer_tg_checkentry,
+	.destroy        = hardidletimer_tg_destroy,
+	.me		= THIS_MODULE,
+};
+
+static struct class *hardidletimer_tg_class;
+
+static struct device *hardidletimer_tg_device;
+
+static int __init hardidletimer_tg_init(void)
+{
+	int err;
+
+	hardidletimer_tg_class = class_create(THIS_MODULE, "xt_hardidletimer");
+	err = PTR_ERR(hardidletimer_tg_class);
+	if (IS_ERR(hardidletimer_tg_class)) {
+		pr_debug("couldn't register device class\n");
+		goto out;
+	}
+
+	hardidletimer_tg_device = device_create(hardidletimer_tg_class, NULL,
+						MKDEV(0, 0), NULL, "timers");
+	err = PTR_ERR(hardidletimer_tg_device);
+	if (IS_ERR(hardidletimer_tg_device)) {
+		pr_debug("couldn't register system device\n");
+		goto out_class;
+	}
+
+	hardidletimer_tg_kobj = &hardidletimer_tg_device->kobj;
+
+	err = xt_register_target(&hardidletimer_tg);
+	if (err < 0) {
+		pr_debug("couldn't register xt target\n");
+		goto out_dev;
+	}
+
+	return 0;
+out_dev:
+	device_destroy(hardidletimer_tg_class, MKDEV(0, 0));
+out_class:
+	class_destroy(hardidletimer_tg_class);
+out:
+	return err;
+}
+
+static void __exit hardidletimer_tg_exit(void)
+{
+	xt_unregister_target(&hardidletimer_tg);
+
+	device_destroy(hardidletimer_tg_class, MKDEV(0, 0));
+	class_destroy(hardidletimer_tg_class);
+}
+
+module_init(hardidletimer_tg_init);
+module_exit(hardidletimer_tg_exit);
+
+MODULE_AUTHOR("Timo Teras <ext-timo.teras@nokia.com>");
+MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_DESCRIPTION("Xtables: idle time monitor");
+MODULE_LICENSE("GPL v2");
+
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f56d3ed93e56..68491e1bb66d 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -139,6 +139,8 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 		pr_debug("couldn't add file to sysfs");
 		goto out_free_attr;
 	}
+	/* notify userspace */
+	kobject_uevent(idletimer_tg_kobj, KOBJ_ADD);
 
 	list_add(&info->timer->entry, &idletimer_tg_list);
 
-- 
2.23.0

