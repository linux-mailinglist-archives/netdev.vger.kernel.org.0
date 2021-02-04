Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD6730FF5A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhBDVc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhBDVcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 16:32:20 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7D4C06178C
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 13:31:26 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id t6so2962588pje.9
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 13:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vLAVWDvtnifMpRG3fKzFh3oaLPMvwLy+AB3n8yEmzGc=;
        b=q6KhSavC3sR6pDaU5VgKKIF6rgqp0p0rKSTJe3cqK6cmmqoTkzSc4r4cow75z1tF8h
         nqb/EUzwHt03iXeGX9+VYtLAfB9wV9mEM/YAaYK44+mrjLVZTgG1+27BdEV9NeaJavHf
         KIbw4OAWCLtoqVErwo/0heT7R5oUzhQKE3aYCszsTxQ0EMB4GQnVoHaVyMcm2YDfRGDm
         Dk41aUetE2uQGkLZgo9+KH9OMtDr8cdwqdHV2H/vIgRpIRgavdhEL/TbkZxOYhNZ8RSP
         j6kU46lAUR4lCPS7ENVwgTj17H1/jZNvsEZEDqbAx941S8iZ9vm9U+o4PRTdEVNq1VsP
         Zltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vLAVWDvtnifMpRG3fKzFh3oaLPMvwLy+AB3n8yEmzGc=;
        b=s7aJg3pvxxN6z1SoyGDeU9AMvAjIznmFxvah4EavUWr5T5lRBDXWkGiZRe65dsnSIS
         rOQDR8cjL8RIjENytMK2fXFcPlRfKjyjE4Iml2WDwj6ysJUjHb4rz7I71K7E7bsgT+pn
         qblIfW6RW78Ue0bKAKLov02JtoIS0+ZpLqdQHLTXmfaxDT92PY72ZE3N0Ae4/NVWK6kh
         u/8nJUOt+5Pt97o0cUfaQ3LsiVvARGq/d3a8nn3R4xLgVNtRT/ACozfOH2RyO49TTZIX
         j6NSVPGP0owfMk9TvqkfKvLip2Gubtg9yr0tOnhPyHj9Xo1F63WRPz3cSwNj875oPCgB
         JmRg==
X-Gm-Message-State: AOAM531XXavPmqMuJvzaOKxwEbPCI+eGQZiwNM7dWDgEVYfJ5VbCj5iS
        /eUce/wltL1tCiSMkjZnWo9d5XHW8Q8=
X-Google-Smtp-Source: ABdhPJy7Suf1k8bT6t7lHGXgDiWxiNiyo5tnsASNVEDrxtnUZ8jWM/tkSyEbIlGTm0A/b7gOJsU9F+tyoiE=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:819e:a51d:5f26:827c])
 (user=weiwan job=sendgmr) by 2002:a17:90a:d0c4:: with SMTP id
 y4mr913997pjw.212.1612474285659; Thu, 04 Feb 2021 13:31:25 -0800 (PST)
Date:   Thu,  4 Feb 2021 13:31:17 -0800
In-Reply-To: <20210204213117.1736289-1-weiwan@google.com>
Message-Id: <20210204213117.1736289-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210204213117.1736289-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH net-next v10 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>,
        Alexander Duyck <alexanderduyck@fb.com>
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
 Documentation/ABI/testing/sysfs-class-net | 15 +++++
 include/linux/netdevice.h                 |  2 +
 net/core/dev.c                            | 67 ++++++++++++++++++++++-
 net/core/net-sysfs.c                      | 45 +++++++++++++++
 4 files changed, 127 insertions(+), 2 deletions(-)

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
index a8c5eca17074..9cc9b245419e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4290,8 +4290,9 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 
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
@@ -6743,6 +6744,68 @@ static void init_gro_hash(struct napi_struct *napi)
 	napi->gro_bitmask = 0;
 }
 
+/* Setting/unsetting threaded mode on a napi might not immediately
+ * take effect, if the current napi instance is actively being
+ * polled. In this case, the switch between threaded mode and
+ * softirq mode will happen in the next round of napi_schedule().
+ * This should not cause hiccups/stalls to the live traffic.
+ */
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
index daf502c13d6d..969743567257 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,50 @@ static ssize_t phys_switch_id_show(struct device *dev,
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
@@ -570,6 +614,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.30.0.365.g02bc693789-goog

