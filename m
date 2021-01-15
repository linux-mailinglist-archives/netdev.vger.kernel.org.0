Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECD92F6F8B
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 01:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbhAOAcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 19:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731320AbhAOAcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 19:32:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E12C0613CF
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:31:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id m203so3606662ybf.1
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 16:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=OecE8mJTuQ3sRppsTjqxIwKDLyJK9rjkn/l7EUdvJ90=;
        b=GNQ9+peAbyKPOUtsz5fz0hw4He2lMOo5Py/caCyjOGtOQNN6+klQ7Tfsq/irZqD82A
         8QssErXshJHecMrQle53pt/Z0Jhcom3HfLag1hTInDNB4WyE6ksQF2VMak8/CtKBw1PO
         tWYSDbvc2N0NAWBdBRTeZRuYI6mf0eNGH8HM+JaCQzVeQSO9q8+u+VZqSB7qWG9OVYdx
         PjG0syacSnHBOy2Qf3CHym6iSHZJ14untSvttmRK7qcG2xoTTSV76wu7IMjyLwhoH4gJ
         rxHyPKeDdh+e1RhssK4rPKbR+0W0wEulmdaVVN/sj90ntwtgKKte6Cvzg04/zK+RnArG
         JCqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OecE8mJTuQ3sRppsTjqxIwKDLyJK9rjkn/l7EUdvJ90=;
        b=bCmq9pFj3CywhGmRKVZYWtJUb3A71QLgAslIlDBqsawmVrRcSylArThnwbMa5znoRW
         BrxhR4ekg9hqnTUQWrPPAztUCuMl+2x8BPcvNjOg2PZpwWnmzOKBoH555KbQhucz8ll9
         R5l6nYtV+xu9bTeEXFp7ltJXFZZ1sYYzrIO2Z9EIOi1OQXokNCk9cjyicc5J3ZbbdeT8
         lbztBtQhxLsUgDqkO0CEJkAVAiIaH6x94aAyk33qVFAkgwlUJvQDHfzGMAAHa6a04iEK
         76pVYt4pH48FjWCQaPGj03WG5w7AYbxo0yofm2/MqfmwlY/Oqen88aVkEzXiwdb+kW1T
         aFOQ==
X-Gm-Message-State: AOAM530jwrkKhbm6RI3Wnz7/eXnVoeK2AtKK/I/jo0M9U/TqqhjRHqL9
        nrxemmvBTII1mUur9ksQNQwxhIorebo=
X-Google-Smtp-Source: ABdhPJxAOj7Zjw5sxXV+Q7v7q4gvisFltRV54G4tkGqPbkbGQvfSK8w5smlhHLOhZ0db0zugsvjSfEaCDs0=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:743:: with SMTP id 64mr13826074ybh.333.1610670691335;
 Thu, 14 Jan 2021 16:31:31 -0800 (PST)
Date:   Thu, 14 Jan 2021 16:31:23 -0800
In-Reply-To: <20210115003123.1254314-1-weiwan@google.com>
Message-Id: <20210115003123.1254314-4-weiwan@google.com>
Mime-Version: 1.0
References: <20210115003123.1254314-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH net-next v6 3/3] net: add sysfs attribute to control napi
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
threaded mode for all the napi instances of the given network device.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Co-developed-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Wei Wang <weiwan@google.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 28 +++++++++++++++++
 net/core/net-sysfs.c      | 63 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c24ed232c746..11ae0c9b9350 100644
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
index edcfec1361e9..d5fb95316ea8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6754,6 +6754,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
 	return err;
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
index daf502c13d6d..2017f8f07b8d 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,68 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static ssize_t threaded_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct napi_struct *n;
+	bool enabled;
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
+	/* Only return true if all napi have threaded mode.
+	 * The inconsistency could happen when the device driver calls
+	 * napi_disable()/napi_enable() with dev->threaded set to true,
+	 * but napi_kthread_create() fails.
+	 * We return false in this case to remind the user that one or
+	 * more napi did not have threaded mode enabled properly.
+	 */
+	list_for_each_entry(n, &netdev->napi_list, dev_list) {
+		enabled = !!test_bit(NAPI_STATE_THREADED, &n->state);
+		if (!enabled)
+			break;
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
+	struct napi_struct *napi;
+	int ret;
+
+	if (list_empty(&dev->napi_list))
+		return -EOPNOTSUPP;
+
+	ret = dev_set_threaded(dev, !!val);
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
@@ -570,6 +632,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.30.0.284.gd98b1dd5eaa7-goog

