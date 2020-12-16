Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4E412DB86A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgLPB0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgLPB0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 20:26:05 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0A2C0617A7
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:23 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id gj22so604793pjb.6
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 17:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zPjiPuZpx1pDkxZjivaNHg4/NA/ghJG85C+g2T7/icU=;
        b=RmsKzXUj/bpw0ylitIBTeC4ZT/mIHTyp3zt3Q2+nhgj0vaQTtOMnZopoQx/mixOluJ
         SthlZEGLDKtSRh6QHoUq2Q1qX0BvxvXioUB8A7avBB6Blr3wERazo4tHy3jlj/sZ5gik
         JheJGCqvkPxkv/ZNy2Y2skVHUBtxEPeDs3dCsMz/mJDeqjLQxsqCE0R1A+oP70rJPdnu
         7E75LhhbevHrKeFur67J26oOZREVgsOBuOArBpn7BbMOpaRcWD/cGdA6VrwK59QU3fdU
         Wo6LuU+NsV4jywlkaQ5BhpqFTWt22D3ffxtXHi1f+fKe3WkTDaYY6CVPZowp9pXT2WTh
         YmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zPjiPuZpx1pDkxZjivaNHg4/NA/ghJG85C+g2T7/icU=;
        b=nmrdfz+jTYdZcV77ubabKUI8q7pdDQUxvbIufY/zI88VhdAnVqwsRWiV1VIou8FNFl
         Rb/u3MUQBz6jrgmej31zKQiBJ0f6krmYPP0i1b7n/3kkZDry8zBNnfjK4Gj5F9F33ZRA
         vvfBJ9hD8LWofjddqoi3iBTVxS7UYbpkMOsboLUEnv4PBZXnN6MACIFPzoJsCOsvNvrQ
         qeXa4vCK3+ABtHlITVIyYRdgAVyzIWIE7vACLDaQ1Xarrm9VydRU2oNTzyeuN9FMBWiY
         kbFB+yzrgbqFo7T7jP365z5/KFJPc+qQeb2ecsvkKRBVUNdFOrp41dAP4OpWS+NAHHqa
         +Ihg==
X-Gm-Message-State: AOAM532rLPkSLgQeWgzR/qkjMWn5X9IbXm8zRisHRyNpEZ5NUOaFeMx5
        aimh7dKBGnRK/CitFtJz6qGoUTpNUuQ=
X-Google-Smtp-Source: ABdhPJxyO82m8MvjjJYYU+07R9TCBU00UkQNxypp8Ahe0KFihAONQuyKCMcKQjTI+11fUQezJ7yqhWrariE=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a05:6a00:804:b029:198:28cb:5564 with SMTP
 id m4-20020a056a000804b029019828cb5564mr21032374pfk.34.1608081922961; Tue, 15
 Dec 2020 17:25:22 -0800 (PST)
Date:   Tue, 15 Dec 2020 17:25:15 -0800
In-Reply-To: <20201216012515.560026-1-weiwan@google.com>
Message-Id: <20201216012515.560026-4-weiwan@google.com>
Mime-Version: 1.0
References: <20201216012515.560026-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH net-next v5 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        Eric Dumazet <edumazet@google.com>
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
index 2cd1e3975103..8fd54a14cb78 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -498,6 +498,8 @@ static inline bool napi_complete(struct napi_struct *n)
 	return napi_complete_done(n, 0);
 }
 
+int dev_set_threaded(struct net_device *dev, bool threaded);
+
 /**
  *	napi_disable - prevent NAPI from scheduling
  *	@n: NAPI context
diff --git a/net/core/dev.c b/net/core/dev.c
index 47c33affaa80..9737f149ff50 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6749,6 +6749,34 @@ static int napi_set_threaded(struct napi_struct *n, bool threaded)
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
index 94fff0700bdd..3c9ef4692b3d 100644
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
2.29.2.684.gfbc64c5ab5-goog

