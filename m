Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8293A269331
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgINR0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgINR0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9B2C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:08 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id r128so656354qkc.9
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=RgCsCaqgYmgC1Mfvq5pQLQQYxiHHLMC+4ovtFO74twY=;
        b=a5opZK4rIQ7YDjDbYJ+2QVaMYI2KAbXkyKoDpN6EhfLpxLKrOpgJxGArBJKzRP9TgP
         fqWGwi7Zs16jcFSADA/YMarv6KYd7COZqI3/myEXOutxOInstfoWvosR7JDphj88/ZVs
         R9dDVAISE0Y8/kX0Jj1mR52jbLDLnIA/oJHnUYT5t/pjL/abM7O3Pen3yuWEfweHxAEe
         WDKDlZnXLjFRxhAsUMh0GLkoW+xD9dScICQoBCB8itkqQOqHQdxel0TbxX7QR3ijj5Qc
         4imAOfPNrmteUL40AYJNW5VQ6YZln6xUuSv6mEzntBDZXIcCWT9y9dkgY+3wnmvJY7/t
         gsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RgCsCaqgYmgC1Mfvq5pQLQQYxiHHLMC+4ovtFO74twY=;
        b=bTzw3+/47jUU7L31vs782OUO5dE55bKEk9YRw2oQ8uKerEXrm3oKY+NFfOqmsOMU4G
         ymOHW+iKMyjVcOg8RVQA32Gh4QDIGMEp/l8Js4CJElfr2fVxUpm6JI6ec65GAWnbmx6Z
         XkBpnIzDxqvTgONdT24SOZJZkSnOe5ZLy1XSMLJaYgiYLgZfuqqVpFHZMvd07CaZb2Yg
         O2QOpfELBtDE0JcwI4Apf1N0asDa2JGJuG2ZSugUIC+mKQSOyZhxM0b1FfGO4xR873ms
         O1ctnMX4bxX7xbnImAhPxeQUnZv+x9mbBoqVWVDKHbeGzDJWbSKTYbFx6LF81faOFMXI
         DQZg==
X-Gm-Message-State: AOAM530HZiA6ICWBv1y5hHFEvL2WVmHBrhUwiNe6RXVwj0YJmmeNz70O
        JQIod3LoNw0nCxglcgtyvVDxWudXLxo=
X-Google-Smtp-Source: ABdhPJzSc5vtgLiMS/r8RgBBjpYhyUOUivM35PDt0VyyHE24tGqdkgNAw14ZgJccRp+aJMqLyaPxT1elDS0=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:c390:: with SMTP id o16mr14569352qvi.0.1600104367439;
 Mon, 14 Sep 2020 10:26:07 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:49 -0700
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
Message-Id: <20200914172453.1833883-3-weiwan@google.com>
Mime-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 2/6] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
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
---
 include/linux/netdevice.h |   1 +
 net/core/net-sysfs.c      | 102 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6797eb356e2e..37941d6a911d 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1965,6 +1965,7 @@ struct net_device {
 	spinlock_t		addr_list_lock;
 	unsigned char		name_assign_type;
 	bool			uc_promisc;
+	bool			napi_threaded;
 	struct netdev_hw_addr_list	uc;
 	struct netdev_hw_addr_list	mc;
 	struct netdev_hw_addr_list	dev_addrs;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index efec66fa78b7..0172457a1bfe 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -538,6 +538,107 @@ static ssize_t phys_switch_id_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(phys_switch_id);
 
+unsigned long *__alloc_thread_bitmap(struct net_device *netdev, int *bits)
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
@@ -570,6 +671,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_proto_down.attr,
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
+	&dev_attr_threaded.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.28.0.618.gf4bc123cb7-goog

