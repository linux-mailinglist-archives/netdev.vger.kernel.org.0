Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F563D88E2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 09:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhG1HeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 03:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhG1HeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 03:34:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BAF60E78;
        Wed, 28 Jul 2021 07:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627457639;
        bh=iyHBZBMQHrLtGg3F5twV/u7oxW4MK9dAHrwhgymmVm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q5r1VcryvWbIv6cxbH6K9zVhHwFC7K7JPY+fBxfLMX3n34MIKVMc7XlXlbLmXVqhN
         0lKJelt7uxhcKNz2YbHInaIn5/QeG24KTaE01KTTAOjmkX6QUZwVAw6hF2HDG5qttL
         uxMwUo4bza7ExLiUMQWPQGkiGdA5It53UjHTzgw/P/ngDo4PCbVhItxKJX43wvBd7l
         D0JXnHtGCVmQSooGE2NvgW6qqD06Asf8oXQRzXoNI1Rx2ooMDAhsY4AfyopkQOk+Wl
         XNtXTuoL/6+YLSY4TvG+ISjcT8pB9BoP7D2HPkN2vr4VWbfjzIFAdfbV8y/SNavUcm
         Rzyh7O+0gpB0Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH net-next v1 3/3] devlink: Remove duplicated registration check
Date:   Wed, 28 Jul 2021 10:33:47 +0300
Message-Id: <986113be80bf487cf23e54265d4fbcabbcb096a6.1627456849.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627456849.git.leonro@nvidia.com>
References: <cover.1627456849.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Both registered flag and devlink pointer are set at the same time
and indicate the same thing - devlink/devlink_port are ready. Instead
of checking ->registered use devlink pointer as an indication.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/devlink.h |  4 +---
 net/core/devlink.c    | 19 ++++++++++---------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 57b738b78073..e48a62320407 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -55,8 +55,7 @@ struct devlink {
 			    * port, sb, dpipe, resource, params, region, traps and more.
 			    */
 	u8 reload_failed:1,
-	   reload_enabled:1,
-	   registered:1;
+	   reload_enabled:1;
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -158,7 +157,6 @@ struct devlink_port {
 	struct list_head region_list;
 	struct devlink *devlink;
 	unsigned int index;
-	bool registered;
 	spinlock_t type_lock; /* Protects type and type_dev
 			       * pointer consistency.
 			       */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 8fdd04f00fd7..b596a971b473 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -115,7 +115,7 @@ static void __devlink_net_set(struct devlink *devlink, struct net *net)
 
 void devlink_net_set(struct devlink *devlink, struct net *net)
 {
-	if (WARN_ON(devlink->registered))
+	if (WARN_ON(devlink->dev))
 		return;
 	__devlink_net_set(devlink, net);
 }
@@ -1043,7 +1043,7 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 	struct sk_buff *msg;
 	int err;
 
-	if (!devlink_port->registered)
+	if (!devlink_port->devlink)
 		return;
 
 	WARN_ON(cmd != DEVLINK_CMD_PORT_NEW && cmd != DEVLINK_CMD_PORT_DEL);
@@ -8817,8 +8817,8 @@ EXPORT_SYMBOL_GPL(devlink_alloc);
  */
 int devlink_register(struct devlink *devlink, struct device *dev)
 {
+	WARN_ON(devlink->dev);
 	devlink->dev = dev;
-	devlink->registered = true;
 	mutex_lock(&devlink_mutex);
 	list_add_tail(&devlink->list, &devlink_list);
 	devlink_notify(devlink, DEVLINK_CMD_NEW);
@@ -8960,9 +8960,10 @@ int devlink_port_register(struct devlink *devlink,
 		mutex_unlock(&devlink->lock);
 		return -EEXIST;
 	}
+
+	WARN_ON(devlink_port->devlink);
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
-	devlink_port->registered = true;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
@@ -9001,7 +9002,7 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 				    enum devlink_port_type type,
 				    void *type_dev)
 {
-	if (WARN_ON(!devlink_port->registered))
+	if (WARN_ON(!devlink_port->devlink))
 		return;
 	devlink_port_type_warn_cancel(devlink_port);
 	spin_lock_bh(&devlink_port->type_lock);
@@ -9121,7 +9122,7 @@ void devlink_port_attrs_set(struct devlink_port *devlink_port,
 {
 	int ret;
 
-	if (WARN_ON(devlink_port->registered))
+	if (WARN_ON(devlink_port->devlink))
 		return;
 	devlink_port->attrs = *attrs;
 	ret = __devlink_port_attrs_set(devlink_port, attrs->flavour);
@@ -9145,7 +9146,7 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->registered))
+	if (WARN_ON(devlink_port->devlink))
 		return;
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_PF);
@@ -9172,7 +9173,7 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->registered))
+	if (WARN_ON(devlink_port->devlink))
 		return;
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_VF);
@@ -9200,7 +9201,7 @@ void devlink_port_attrs_pci_sf_set(struct devlink_port *devlink_port, u32 contro
 	struct devlink_port_attrs *attrs = &devlink_port->attrs;
 	int ret;
 
-	if (WARN_ON(devlink_port->registered))
+	if (WARN_ON(devlink_port->devlink))
 		return;
 	ret = __devlink_port_attrs_set(devlink_port,
 				       DEVLINK_PORT_FLAVOUR_PCI_SF);
-- 
2.31.1

