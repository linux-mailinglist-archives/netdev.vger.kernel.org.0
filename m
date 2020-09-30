Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282B227F284
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgI3TWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:22:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B311DC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id c26so1492764pgl.9
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2Fv/RrWoLcbM9P0duMxErv9yg1yz6MFdGnuq0GYXBxw=;
        b=bGqrpYKx4Jc85dJFg9s7r6LwTE4wK+xHdPMw5nhn6JvQkO95uy1HOLptRKtZyqNs/4
         VVVMqVuXxnJBSGPUVvPKOHrLtbeutECHE52oHAsp1GJXqTc3WRF2/AFL7KWeYLPD1El6
         /urin9faYJMfx5hnlqykz2ulraKaaJSCJ5u+slffb9aocxPNjBLsOOr2BwqMd/LCraFe
         C1eguknDpkjVlmAbux0EzKCBbPyOhaokxnbSpGERXHSXRCSpKfxZ7AaiVFTSDcRaAUTX
         rAI3CF2vb3328HZFRKT8buakfa54LERHre4LNHFtoD5AMBn0+xVa8e56j8RS4EdptwcE
         YevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2Fv/RrWoLcbM9P0duMxErv9yg1yz6MFdGnuq0GYXBxw=;
        b=AWX/eKCL/gbMSHyVld814GFy/0VVkSoCV4ijDaZIP+02QbQrbyMwM0jZ/0s/8Dc0ON
         yUt2Ssa94Zy8l2eLKYnoI3DoHe1bwX8ggLOgtQZoMRiMzFdSdnJp89k4mw7o9s8CE5NR
         nvgnatsQWIcaS8lTz2T5ypcuqKhzxvjMHkd1p62316rPGuARewN20m7yycz+PJ52tkBv
         HyQqTLh1TqzTcaAMkDwRM0dPBMVVsR0jSwlxd4pmjfVVQTwcqhVL/FyFzOQnrpW8nw+2
         v5w5zvxUduj6V5MCWhn4BEHX05Ct6Niy29c050jxvq98oPTNYo9SOxy/jTvzsViW9V9N
         ro1g==
X-Gm-Message-State: AOAM530coAegGQRWvsooMestmcISK0IvucnbdaikLlVdYgsgAcHyoNsL
        Xpnso739G/OGf4SQbukB8xoFa9W0VNM=
X-Google-Smtp-Source: ABdhPJzeh5hXnILpNcKopyCOuPM/7zTUE1URK1dGFn/J+M6UOzvBzEuSjc7sdRzX/enu68NuEnYwspqfn5U=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a17:90a:940c:: with SMTP id
 r12mr9582pjo.1.1601493748282; Wed, 30 Sep 2020 12:22:28 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:21:37 -0700
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
Message-Id: <20200930192140.4192859-3-weiwan@google.com>
Mime-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next 2/5] net: add sysfs attribute to control napi
 threaded mode
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Wei Wang <weiwan@google.com>
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
index efec66fa78b7..fe81b344447d 100644
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
2.28.0.709.gb0816b6eb0-goog

