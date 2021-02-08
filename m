Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF84313F31
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbhBHThK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbhBHTfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 14:35:07 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04055C0617A9
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 11:34:18 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id x18so5814319qki.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 11:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=lyNvFzLMOm6Vlunzw+chJzXZCFsEIptRnlpon2EJ7QE=;
        b=D71Zn6vuK8XSlgxDzvRcEJQl4Ibd6KtdKQeHiwNak5jL5Hy6YXscqQXfPiAwzI4dBk
         MGmCXys+LDyB1DSCJG/IGgXacfru34iy07yhfF1uQzK+TU7HJ//22SjpsO6FIvGSHg3L
         OO0mXoHC4CITBM0vEu9GIUGk/gvugo23FjGJeciKxVgfL6cTb1ST43SkmoLJvyP0NbUK
         v2rVXRPI/05hmrQTFYpGPlEo+eWXfLnauX0qUJbC+jw6XAsx8juovXX8owcBSJ1eKscm
         5wDuS6227EtPCiVW/kzAyUyoSw5qvpbULNZkVGxAmVY/iVlfPM0YxkrZLNL4HywkraVp
         EFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lyNvFzLMOm6Vlunzw+chJzXZCFsEIptRnlpon2EJ7QE=;
        b=az3ZyQxxD12KU8qvvb/QuFlcvSJ7thl9+8Wo1O80/p8iEn57gaiiVVsuGtHogvYhv5
         K4n0AfikJGRvLHOAFP1FVDDaalW7VsfLM6Sw4Xf0eZDyLbLphHOJCELjH8fHDmaTUwb+
         AuUpqCgjeXos+uaTiXjrj2QsOtnFvAx7504ZDpjw3WJXl7xCbeq8bI7d6gaN7/kpLC9c
         9zv0TJm69U1J+YkdbWQ7HCvBbeGA8JrsKp3cYPRUmzc/zqZIRnrGH+VzLox4+E+rgjpc
         aX2krE2DQ5S3kI8bfrE5tSVJHtgtrIjHqSaZlAxdV48DJM8oihnk3DEQTmXpMDwIAbsp
         zJoA==
X-Gm-Message-State: AOAM531qRN/W0TYAd0pdZnVSh6uK1yYhaMqog9x4nnZxuz+cS1FuthNm
        7PQhOVZKZRKAphxL0Fa2t0vmlPM7Wuw=
X-Google-Smtp-Source: ABdhPJyoHBuestLi2dUzbpIEFWD/NQC6hlVGGNAgyvsKzrZAXn3lpS/oj+1Lt+9nWMCJJ++S7iTXYBjhY/s=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:35a9:bca1:5bb0:4132])
 (user=weiwan job=sendgmr) by 2002:a0c:f94a:: with SMTP id i10mr17801668qvo.22.1612812857196;
 Mon, 08 Feb 2021 11:34:17 -0800 (PST)
Date:   Mon,  8 Feb 2021 11:34:10 -0800
In-Reply-To: <20210208193410.3859094-1-weiwan@google.com>
Message-Id: <20210208193410.3859094-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210208193410.3859094-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH net-next v11 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new sysfs attribute to the network device class.
Said attribute provides a per-device control to enable/disable the
threaded mode for all the napi instances of the given network device,
without the need for a device up/down.
User sets it to 1 or 0 to enable or disable threaded mode.
Note: when switching between threaded and the current softirq based mode
for a napi instance, it will not immediately take effect if the napi is
currently being polled. The mode switch will happen for the next time
napi_schedule() is called.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 Documentation/ABI/testing/sysfs-class-net | 15 +++++++
 include/linux/netdevice.h                 |  2 +
 net/core/dev.c                            | 48 ++++++++++++++++++++++-
 net/core/net-sysfs.c                      | 40 +++++++++++++++++++
 4 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 1f2002df5ba2..1419103d11f9 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -337,3 +337,18 @@ Contact:	netdev@vger.kernel.org
 Description:
 		32-bit unsigned integer counting the number of times the link has
 		been down
+
+What:		/sys/class/net/<iface>/threaded
+Date:		Jan 2021
+KernelVersion:	5.12
+Contact:	netdev@vger.kernel.org
+Description:
+		Boolean value to control the threaded mode per device. User could
+		set this value to enable/disable threaded mode for all napi
+		belonging to this device, without the need to do device up/down.
+
+		Possible values:
+		== ==================================
+		0  threaded mode disabled for this dev
+		1  threaded mode enabled for this dev
+		== ==================================
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 99fb4ec9573e..1340327f7abf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -497,6 +497,8 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
+int dev_set_threaded(struct net_device *dev, bool threaded);
+
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 1e35f4f44f3b..7647278e46f0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4291,8 +4291,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		/* Paired with smp_mb__before_atomic() in
-		 * napi_enable(). Use READ_ONCE() to guarantee
-		 * a complete read on napi->thread. Only call
+		 * napi_enable()/dev_set_threaded().
+		 * Use READ_ONCE() to guarantee a complete
+		 * read on napi->thread. Only call
 		 * wake_up_process() when it's not NULL.
 		 */
 		thread = READ_ONCE(napi->thread);
@@ -6738,6 +6739,49 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+int dev_set_threaded(struct net_device *dev, bool threaded)
+{
+	struct napi_struct *napi;
+	int err = 0;
+
+	if (dev->threaded == threaded)
+		return 0;
+
+	if (threaded) {
+		list_for_each_entry(napi, &dev->napi_list, dev_list) {
+			if (!napi->thread) {
+				err = napi_kthread_create(napi);
+				if (err) {
+					threaded = false;
+					break;
+				}
+			}
+		}
+	}
+
+	dev->threaded = threaded;
+
+	/* Make sure kthread is created before THREADED bit
+	 * is set.
+	 */
+	smp_mb__before_atomic();
+
+	/* Setting/unsetting threaded mode on a napi might not immediately
+	 * take effect, if the current napi instance is actively being
+	 * polled. In this case, the switch between threaded mode and
+	 * softirq mode will happen in the next round of napi_schedule().
+	 * This should not cause hiccups/stalls to the live traffic.
+	 */
+	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+		if (threaded)
+			set_bit(NAPI_STATE_THREADED, &napi->state);
+		else
+			clear_bit(NAPI_STATE_THREADED, &napi->state);
+	}
+
+	return err;
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index daf502c13d6d..e72d474c2623 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,45 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static ssize_t threaded_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	ssize_t ret = -EINVAL;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (dev_isalive(netdev))
+		ret = sprintf(buf, fmt_dec, netdev->threaded);
+
+	rtnl_unlock();
+	return ret;
+}
+
+static int modify_napi_threaded(struct net_device *dev, unsigned long val)
+{
+	int ret;
+
+	if (list_empty(&dev->napi_list))
+		return -EOPNOTSUPP;
+
+	if (val != 0 && val != 1)
+		return -EOPNOTSUPP;
+
+	ret = dev_set_threaded(dev, val);
+
+	return ret;
+}
+
+static ssize_t threaded_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	return netdev_store(dev, attr, buf, len, modify_napi_threaded);
+}
+static DEVICE_ATTR_RW(threaded);
+
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
 	&dev_attr_type.attr,
@@ -570,6 +609,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.30.0.478.g8a0d178c01-goog

