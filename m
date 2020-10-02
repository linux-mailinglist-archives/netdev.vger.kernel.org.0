Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8732281E46
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgJBWZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgJBWZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DDBC0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v4so3190991ybk.5
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=HMGl8RgPHbOfJMMQ5ObBOMaCDpe5l4zVOjyOlhKjxwM=;
        b=GOqlNMjRuAEHzpMQWaGR2zOlXEDtJA5pD+Ny2PFrD6rB9j8jOBo4XdYDy3RueVfzGM
         EOKwAD/ltxT37vQei3F0RVERDw6Xb844Hln+3ZT/ohSpYFtA3tGzPJEDpiCppJ0S3tAB
         eFC3fFnOU6W/NVJosLcyh4QjF02zFG5A1pbc+cpGRqsz5d6jGW90yioVQ1N8Fdyv+PLA
         Za6hVMPXQsBkn6+pGNSdRJQLeYSZU9hEYn+9cAR94Wkhlnpr6KMWBVeERSkLaMm8ZtPv
         6AjlBBc1kjcUs8wxkAjfqkyltesJgcz2vnKTIHX5ccDTCb5MjFdYe0HcS29ITDZ/MTfw
         Jfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HMGl8RgPHbOfJMMQ5ObBOMaCDpe5l4zVOjyOlhKjxwM=;
        b=R2vXMizKh51aJPqElfxNONkM4jARBpCQb/I6NPMShCT/e1Atf5o4nGsbnkwqe14qIH
         ZdGVzw27bxHFRPUd19Kld1xGUOx5iSWRn8Wy5Qbzo3gWsPo9CS5sfrynNQ40wGV5QnGV
         Z+CdVdSTl9WeYRFUjeLVjmJRmrBiRyvAGVfbowXbDxUa7iVP7pWgP1ljscmk9sROmUw7
         L9mFLHWKrB0nAPJqo0PYu3UfsQQ38BMUlZ1aobrVECJ3dxSmL5AELNgPezobVdD1/moN
         wVaVFYZnemctolc10c7l+v3ZOoXR7uKn93TfTm23sfg4fACoOFg75ZKUwLdxFbVp2Czk
         P9SQ==
X-Gm-Message-State: AOAM531uFTWEqP29/dDojLSx0BHx7qdqoNY5lM8dyZJqW/a+LYWQ5pBq
        FsNgFa7rae1FrQFJjf2CroKAXmgTsn4=
X-Google-Smtp-Source: ABdhPJxgNMDGYxtVbHo/AC3eUyZDUDkYXCHwQomxruKIKSLRuMZNqi9UvR8qIrqLyp67EFqglvRNekG5EhU=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a25:7d04:: with SMTP id y4mr6142288ybc.246.1601677537559;
 Fri, 02 Oct 2020 15:25:37 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:11 -0700
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
Message-Id: <20201002222514.1159492-3-weiwan@google.com>
Mime-Version: 1.0
References: <20201002222514.1159492-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 2/5] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
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
2.28.0.806.g8561365e88-goog

