Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE3024E042
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgHUTCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgHUTB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:01:56 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68809C061574
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 12:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MCq6QpM/14v/lsUwjEJZiTJRETK/2QTs7panQQZaVx8=; b=qV2a1USt/zB1Hd/iac3equ8FJU
        lWXQ5YrE2Ior4VL0is0E4pU2E0zjrjXvP1rWXp3NVfqXzZuPv/Wh6NjhbUt9p2Xp1SMsoFbOHCVck
        ciCNJtbh5UOut/KVmDi0/QABC+ak4csAgdEivZToNyEDBc9b3bNhZYgxdsPKqrKwpW9E=;
Received: from p5b206497.dip0.t-ipconnect.de ([91.32.100.151] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1k9CIS-0005vO-MZ; Fri, 21 Aug 2020 21:01:52 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Hillf Danton <hdanton@sina.com>
Subject: [PATCH v3 2/2] net: add sysfs attribute for enabling threaded NAPI
Date:   Fri, 21 Aug 2020 21:01:51 +0200
Message-Id: <20200821190151.9792-2-nbd@nbd.name>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200821190151.9792-1-nbd@nbd.name>
References: <20200821190151.9792-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be used to enable threaded NAPI on drivers that did not explicitly
request it.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/core/net-sysfs.c | 47 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index efec66fa78b7..d7f7df715b60 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -472,6 +472,52 @@ static ssize_t proto_down_store(struct device *dev,
 }
 NETDEVICE_SHOW_RW(proto_down, fmt_dec);
 
+static int change_napi_threaded(struct net_device *dev, unsigned long val)
+{
+	struct napi_struct *napi;
+
+	if (list_empty(&dev->napi_list))
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(napi, &dev->napi_list, dev_list) {
+		if (val)
+			set_bit(NAPI_STATE_THREADED, &napi->state);
+		else
+			clear_bit(NAPI_STATE_THREADED, &napi->state);
+	}
+
+	return 0;
+}
+
+static ssize_t napi_threaded_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	return netdev_store(dev, attr, buf, len, change_napi_threaded);
+}
+
+static ssize_t napi_threaded_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct napi_struct *napi;
+	bool enabled = false;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	list_for_each_entry(napi, &netdev->napi_list, dev_list) {
+		if (test_bit(NAPI_STATE_THREADED, &napi->state))
+			enabled = true;
+	}
+
+	rtnl_unlock();
+
+	return sprintf(buf, fmt_dec, enabled);
+}
+static DEVICE_ATTR_RW(napi_threaded);
+
 static ssize_t phys_port_id_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
@@ -564,6 +610,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_tx_queue_len.attr,
 	&dev_attr_gro_flush_timeout.attr,
 	&dev_attr_napi_defer_hard_irqs.attr,
+	&dev_attr_napi_threaded.attr,
 	&dev_attr_phys_port_id.attr,
 	&dev_attr_phys_port_name.attr,
 	&dev_attr_phys_switch_id.attr,
-- 
2.28.0

