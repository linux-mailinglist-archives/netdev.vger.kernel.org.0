Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A292D3806
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgLIAzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgLIAzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:55:39 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D141BC0617A6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 16:54:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c8so408548plo.13
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 16:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=J8dECfyOQwvK0nUOqNfD0kSF+CNbpd+Jpy6icYbjYWg=;
        b=cOciLv1eJXb7/ItKK0lsl1KE5mLgql7vQ+lR2yWzZ8xLWtvs+Ec97aLcxtZxmNAU9a
         J1PEBxWacntrhjqw0n/msy8jNYxlnf6/g5edEXqYpXM0o/fDyWzdwvRaq6woKeA7M3Aw
         KMxasZJbmzCBkCPnEvkHcWZfxzMH3btCJQlqSbLAY76tUfcry2aTg97blbdYKYXYwCFa
         jE6u+SMmsZrBZNqkCFaIjjvjGTl/+T+PNkKTeA54gWzu1Qwx5NveEFTH9MnYkT29dIpe
         NUS6YLcalGyFS0drr6ou0V66bbcaO5xcn+Uys2f2msdAhplm4jJQKJ/NGSpqiwDvTSjM
         U6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J8dECfyOQwvK0nUOqNfD0kSF+CNbpd+Jpy6icYbjYWg=;
        b=KVmnascTlBHdvTnWF5Hn5/jmYt/vg7NQfrk7GCEGWuTfKZivzkoIa3tQ6bjQCuDfma
         yFOuLP3cd5D6ZNUlvcMi2Zctlr930JGPebYAcU9oGKPI7is7Sw34TxtFUc2fkh2PBbdz
         37cAtingv2ZT1LSgAQc3zAehARJnoz/U6dkswGhapevdu0QAbxM5P0Fs6JDwonhoZQse
         TQL28xmccrKfsoK4GU/WfAR9CCW6fqsC/dEs/iwSjBKnOELl38hfJDkMj4+AViMtDH0P
         q2P5LvfETLc56NOgDqX0xq6c2gHwEHWnJgA8jGtW0x0koBn9gg/kUltoNIaetDm9i2Rz
         JsKg==
X-Gm-Message-State: AOAM531GtaJhAPYik2lr/6sMfrQ4wyJ7VCWsP+wwzrKGVOjO9lTMoJ5D
        hEPnA3Ee0M8wJD95zIBan47S/FwQVeI=
X-Google-Smtp-Source: ABdhPJxKTT5tsc0vlbMxsSWTJ6T/JpwftXZ2rdWmvaK8Ztawcj6y0TwEzRrFsPV3uRKGfyhDQi7NnPwWUjA=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a17:90a:17a4:: with SMTP id
 q33mr14537pja.0.1607475292041; Tue, 08 Dec 2020 16:54:52 -0800 (PST)
Date:   Tue,  8 Dec 2020 16:54:44 -0800
In-Reply-To: <20201209005444.1949356-1-weiwan@google.com>
Message-Id: <20201209005444.1949356-4-weiwan@google.com>
Mime-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next v4 3/3] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
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
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/net-sysfs.c | 70 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 94fff0700bdd..d14dc1da4c97 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,75 @@ static ssize_t phys_switch_id_show(struct device *dev,
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
+	n = list_first_entry(&netdev->napi_list, struct napi_struct, dev_list);
+	enabled = !!test_bit(NAPI_STATE_THREADED, &n->state);
+
+	ret = sprintf(buf, fmt_dec, enabled);
+
+unlock:
+	rtnl_unlock();
+	return ret;
+}
+
+static void dev_disable_threaded_all(struct net_device *dev)
+{
+	struct napi_struct *napi;
+
+	list_for_each_entry(napi, &dev->napi_list, dev_list)
+		napi_set_threaded(napi, false);
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
+	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+		ret = napi_set_threaded(napi, !!val);
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
@@ -570,6 +639,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.29.2.576.ga3fc446d84-goog

