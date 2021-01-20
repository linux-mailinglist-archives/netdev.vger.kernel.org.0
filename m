Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E62FC926
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbhATDg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 22:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbhATDfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 22:35:43 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D838C0613CF
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:35:03 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id j24so21793673qvg.8
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 19:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=p4DrgjPMTr8A47ZMSniVNKQfN5GX1SjIZ9C94HkITXY=;
        b=t64NmuxvRcJUNcUjzHZmk6vlztT+jTiyO+CIzsA7VUG7J+IaBjdtd67qdx0B7jODcZ
         RZsisufPA03NMvK+FGyGm3f2+Ipi93RDi5+5k1dyeMUZ6l+AmkNpfDJ5DfgruSovnUff
         825lZ4edZSlbpiATt9+s5egbCtBp65Ypt+F48Ey/5vnppQn9x0swY+3ygVbbRCuUW2mG
         XKNO3Qi+NMH6FcF9K0R1GheaESOdoabj9fTXaPt0YxD0ZCHI3wLZaN5At7VMTBaaHv+Y
         agUNJNlPiuhtAAkcR3/N2j3l2yHb2tp1Ffgva7fOHCYvm7g/l6ACUNJd8dLOIj+MHNyL
         7DlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p4DrgjPMTr8A47ZMSniVNKQfN5GX1SjIZ9C94HkITXY=;
        b=CgiiJ97pcPLVS1MuMluG9L3mtNKNv3XOnlsEM9/Vf92fcdRwnA17YNBmQux0nHfD2S
         MuIAUqyKeBEiTWC9+g5g3jL2PEDSlcBBxnazdPVBmwY4rdaa24h9xdzAAdv/LV+VLggo
         gUgVY8zJNB4sixg6w7BhMWMZCkMParKrgFWC1V5ltiS1LicvXv6Oot4ICXfHdU7Iws7r
         cWC5cbwOMlpiXYznKhWKghifuebilH0dxJfZH2UP9GsafgCKllq3veyaT++Ds/4EVZz+
         qgRD84y5emRqWNdA2zuXuSYUJL8Gvv157ESz2hPet5XClDD7ub0a9ZomLlNy5GqW+v4e
         9qyQ==
X-Gm-Message-State: AOAM533lpiC0SifhsDBEiHSCn/sGJFzQlNRSB5GpL8zjaDcrCg+c2zGI
        tpO+RRi1Tl8lONqu+iIQHGYGdwLajTU=
X-Google-Smtp-Source: ABdhPJzPUARMKGY4mpgy7K0/1kCM5w9tZ3nlp6H1mCC+5L/+K1TomuH5Y3CE+fztOlK3lOYAgZRUIzX9/Jg=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:fb0d:: with SMTP id c13mr7809029qvp.1.1611113702544;
 Tue, 19 Jan 2021 19:35:02 -0800 (PST)
Date:   Tue, 19 Jan 2021 19:34:55 -0800
In-Reply-To: <20210120033455.4034611-1-weiwan@google.com>
Message-Id: <20210120033455.4034611-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210120033455.4034611-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next v7 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new sysfs attribute to the network device class.
Said attribute provides a per-device control to enable/disable the
threaded mode for all the napi instances of the given network device.
User sets it to 1 or 0 to enable or disable threaded mode per device.
However, when user reads from this sysfs entry, it could return:
  1: means all napi instances belonging to this device have threaded
mode enabled.
  0: means all napi instances belonging to this device have threaded
mode disabled.
  -1: means the system fails to enable threaded mode for certain napi
instances when user requests to enable threaded mode. This happens
when the kthread fails to be created for certain napi instances.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 28 ++++++++++++++++
 net/core/net-sysfs.c      | 68 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8cb8d43ea5fa..26c3e8cf4c01 100644
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
index 7ffa91475856..e71c2fd91595 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6767,6 +6767,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
 	return 0;
 }
 
+static void dev_disable_threaded_all(struct net_device *dev)
+{
+	struct napi_struct *napi;
+
+	list_for_each_entry(napi, &dev->napi_list, dev_list)
+		napi_set_threaded(napi, false);
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
index daf502c13d6d..bf62a20fbb81 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,73 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static ssize_t threaded_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct napi_struct *n;
+	int enabled;
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
+	/* Check if there is inconsistency between napi_state and
+	 * dev->threaded for each napi first.
+	 * The inconsistency could happen when the device driver calls
+	 * napi_disable()/napi_enable() with dev->threaded set to true,
+	 * but napi_kthread_create() fails for certain napi instances.
+	 * Return -1 in this inconsistent state.
+	 * Otherwise, return what is set in dev->threaded.
+	 */
+	list_for_each_entry(n, &netdev->napi_list, dev_list) {
+		enabled = !!test_bit(NAPI_STATE_THREADED, &n->state);
+		if (enabled != netdev->threaded) {
+			enabled = -1;
+			break;
+		}
+	}
+
+	ret = sprintf(buf, fmt_dec, enabled);
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
@@ -570,6 +637,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

