Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37C35308C49
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 19:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhA2SUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 13:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbhA2STK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 13:19:10 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99625C061786
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:20 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id z19so6606593qtv.20
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 10:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WDNro0VPXt/zC9TqV9DmvFjd3UBXqKHBzoaBbsunom4=;
        b=Bp506A/Q41AFHMS1hd5xrq0L1Ypi0R5HhgWjABMBui2/hxIC4CGw/AZo9n+Vcwj80/
         +Z6DBrwORTCWHYR1sP6m5PqkE7KCvIIn/RMJFGtMGr9UaVX0QD+/tyGjw7ZeoCO8VK+C
         fnpvxfPSx94s5DUZy5P6itmbjnAY1ojpd7a1NzHR5mP7CJ3LOGTSES3RyDaIScVABjr7
         I8fLWX8K6ai59GDZX4O8QM+SqzeLjB2FGT0n+1hu9Jwg/hEv5eQtBcLUeaOT+FcOLyB2
         Ttq14wkb9dFlIxccEZS2hbpXKPWjuMa0+3IpxrDWM/QvyZnt5KIwEOC20jVKaJMlhl1Q
         aa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WDNro0VPXt/zC9TqV9DmvFjd3UBXqKHBzoaBbsunom4=;
        b=p3MG608EuWX2/KkXt0S6IL5FrYkZXNSzaIyJV+L2Gy+HGkexU+W/p4wGoss/3emOxa
         CtLBYr727IATbUM++NBmnNcLHGnYqUbTnb/9jHmbC+SPZfhnCMoVKbdiY0PhnrrYneVj
         OuAbKWiMjc+RiSxkf1VTPrCLk0wwlRaqh8ZXTE/KXmX5N/patPo4Z6nTP9G3bIQvlIIJ
         aLOW2ND0+Vvila+s40PmJUqPzgmxCvqnLT62ktJpOtof0dfKBlmNyaFBpQhYa+56rZPx
         495lK0yk443Z+EVUM7ES+K6XZ0KFlDL3qSrgZb9oEDz2hXy7L8l9m5UNx80eyT+8jpFy
         udow==
X-Gm-Message-State: AOAM533FxLu+UZJPK91DQbRgkEQP46ps9ysnYCQV3yiCEsGp/TcKCXW3
        Jf0jvIFyx43/isQW/o7AtEvyBkBiCm4=
X-Google-Smtp-Source: ABdhPJyO+cnv6gtR8rfGLZnyv5vlqhLUAzJyPHSzxuJ2HMcniBF0PFxS19GmEECFtx3G+Jev5byonqTQLsw=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:69ee:ceb1:90eb:1722])
 (user=weiwan job=sendgmr) by 2002:ad4:56e8:: with SMTP id cr8mr5041740qvb.6.1611944299847;
 Fri, 29 Jan 2021 10:18:19 -0800 (PST)
Date:   Fri, 29 Jan 2021 10:18:12 -0800
In-Reply-To: <20210129181812.256216-1-weiwan@google.com>
Message-Id: <20210129181812.256216-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210129181812.256216-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v9 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
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

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 Documentation/ABI/testing/sysfs-class-net | 15 ++++++
 include/linux/netdevice.h                 |  2 +
 net/core/dev.c                            | 61 ++++++++++++++++++++++-
 net/core/net-sysfs.c                      | 50 +++++++++++++++++++
 4 files changed, 126 insertions(+), 2 deletions(-)

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
index f1e9fe9017ac..8ac2db361ae3 100644
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
index 743dd69fba19..1897af6a46eb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4288,8 +4288,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 
 	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		/* Paired with smp_mb__before_atomic() in
-		 * napi_enable(). Use READ_ONCE() to guarantee
-		 * a complete read on napi->thread. Only call
+		 * napi_enable()/napi_set_threaded().
+		 * Use READ_ONCE() to guarantee a complete
+		 * read on napi->thread. Only call
 		 * wake_up_process() when it's not NULL.
 		 */
 		thread = READ_ONCE(napi->thread);
@@ -6740,6 +6741,62 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+static int napi_set_threaded(struct napi_struct *n, bool threaded)
+{
+	int err = 0;
+
+	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
+		return 0;
+
+	if (!threaded) {
+		clear_bit(NAPI_STATE_THREADED, &n->state);
+		return 0;
+	}
+
+	if (!n->thread) {
+		err = napi_kthread_create(n);
+		if (err)
+			return err;
+	}
+
+	/* Make sure kthread is created before THREADED bit
+	 * is set.
+	 */
+	smp_mb__before_atomic();
+	set_bit(NAPI_STATE_THREADED, &n->state);
+
+	return 0;
+}
+
+static void dev_disable_threaded_all(struct net_device *dev)
+{
+	struct napi_struct *napi;
+
+	list_for_each_entry(napi, &dev->napi_list, dev_list)
+		napi_set_threaded(napi, false);
+	dev->threaded = 0;
+}
+
+int dev_set_threaded(struct net_device *dev, bool threaded)
+{
+	struct napi_struct *napi;
+	int ret;
+
+	dev->threaded = threaded;
+	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+		ret = napi_set_threaded(napi, threaded);
+		if (ret) {
+			/* Error occurred on one of the napi,
+			 * reset threaded mode on all napi.
+			 */
+			dev_disable_threaded_all(dev);
+			break;
+		}
+	}
+
+	return ret;
+}
+
 void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
 		    int (*poll)(struct napi_struct *, int), int weight)
 {
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index daf502c13d6d..884f049ee395 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,55 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static ssize_t threaded_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	int ret;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (!dev_isalive(netdev)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	if (list_empty(&netdev->napi_list)) {
+		ret = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	ret = sprintf(buf, fmt_dec, netdev->threaded);
+
+unlock:
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
@@ -570,6 +619,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.30.0.365.g02bc693789-goog

