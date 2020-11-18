Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91B52B854E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgKRUHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:20 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A3C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w8so4089621ybq.4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=AujCKgYJhnDkM058WtqUGOklnts1B0HNyUZaNDRuuQQ=;
        b=dApvoR09gTj3QUFLWQMo+ls1/rAizTC+a/7Fj5MjX3j9MHL5oJbcSbP0F5//XnXqYr
         hPlauMSV3LxXZ5IX6TKcDKfFC0rc6hmkcgk0Seq+ikD1hcy5kSkcrbOGExWtgQ7wVPNZ
         xNsMVEZvBF6sBsU4/eqioVarDS7gCc98rmv9TvXOl1Yae3puFveWW+vUI2dvA99g7A6X
         E3yd48tcFaD4/gx8iETI8NFPlqEIbIagRjiViDb/t/BA8JXHSunt/5v+SICaPS7F/OCK
         5QquxZH7+/c0v0v4PgFtr924r0+jVJPWKCv/quOZAcYJ9rMTx62P6XAwo/wv6C8lpHBO
         b3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AujCKgYJhnDkM058WtqUGOklnts1B0HNyUZaNDRuuQQ=;
        b=pPa6n2PNP5Tn2AvZ9x2Q53VLZtL4Jdo67rYWbimOUYFgFekE9NBl77e1GnCO9kzNYu
         /D+8EZeXCZELq0dQHNH7yfwOzj01IxarTtrpC62ySDSV+IDC8nS0kDHkZvtGODRRI8yJ
         pv7NxzZu2+PbYUbU8feruQWzZfCF7peiobOx8FQK/+G134Pp6ALtC7PjnD3Y3EMy1Tyn
         qgXqCRcQ5iI+7DGRIQ4yq+7veGIBeVXU8NAOq5K6yFgSQkJeQLnpi5tTtzL5arnSABeZ
         TpBbQA2w9KTfhMM+noCRdqykFCilOYd333mgVb7EHzx+VMNRsb0d0M/8Lg76UZMvUTSw
         /rKw==
X-Gm-Message-State: AOAM533S5Tn4axeNEFG6HRwauNwgECL7jWM8t7o1SP2B/6pPiP1Nq3zm
        feEkdlBua86ZhUPdA9ZqP/eoVsqLoMo=
X-Google-Smtp-Source: ABdhPJyYnX9dCYMVa7OXG3SSS364NblkClXfMTiQ6AkoF2DZwQiczxH/WVHhu5i50t+Z5u+4QfqP7kmqAIk=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:ba4c:: with SMTP id z12mr9344035ybj.366.1605730039293;
 Wed, 18 Nov 2020 12:07:19 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:06 -0800
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
Message-Id: <20201118191009.3406652-3-weiwan@google.com>
Mime-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 2/5] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com> 

this patch adds a new sysfs attribute to the network
device class. Said attribute is a bitmask that allows controlling
the threaded mode for all the napi instances of the given
network device.

The threaded mode can be switched only if related network device
is down.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/net-sysfs.c | 103 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 103 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 94fff0700bdd..df8dd25e5e4b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,108 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+static unsigned long *__alloc_thread_bitmap(struct net_device *netdev,
+					    int *bits)
+{
+	struct napi_struct *n;
+
+	*bits = 0;
+	list_for_each_entry(n, &netdev->napi_list, dev_list)
+		(*bits)++;
+
+	return kmalloc_array(BITS_TO_LONGS(*bits), sizeof(unsigned long),
+			     GFP_ATOMIC | __GFP_ZERO);
+}
+
+static ssize_t threaded_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct napi_struct *n;
+	unsigned long *bmap;
+	size_t count = 0;
+	int i, bits;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (!dev_isalive(netdev))
+		goto unlock;
+
+	bmap = __alloc_thread_bitmap(netdev, &bits);
+	if (!bmap) {
+		count = -ENOMEM;
+		goto unlock;
+	}
+
+	i = 0;
+	list_for_each_entry(n, &netdev->napi_list, dev_list) {
+		if (test_bit(NAPI_STATE_THREADED, &n->state))
+			set_bit(i, bmap);
+		i++;
+	}
+
+	count = bitmap_print_to_pagebuf(true, buf, bmap, bits);
+	kfree(bmap);
+
+unlock:
+	rtnl_unlock();
+
+	return count;
+}
+
+static ssize_t threaded_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t len)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct napi_struct *n;
+	unsigned long *bmap;
+	int i, bits;
+	size_t ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (!dev_isalive(netdev)) {
+		ret = len;
+		goto unlock;
+	}
+
+	if (netdev->flags & IFF_UP) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	bmap = __alloc_thread_bitmap(netdev, &bits);
+	if (!bmap) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	ret = bitmap_parselist(buf, bmap, bits);
+	if (ret)
+		goto free_unlock;
+
+	i = 0;
+	list_for_each_entry(n, &netdev->napi_list, dev_list) {
+		napi_set_threaded(n, test_bit(i, bmap));
+		i++;
+	}
+	ret = len;
+
+free_unlock:
+	kfree(bmap);
+
+unlock:
+	rtnl_unlock();
+	return ret;
+}
+static DEVICE_ATTR_RW(threaded);
+
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
 	&dev_attr_type.attr,
@@ -570,6 +672,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.29.2.454.gaff20da3a2-goog

