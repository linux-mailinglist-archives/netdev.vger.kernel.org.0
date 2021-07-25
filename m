Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD8F3D4D54
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 14:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhGYLoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 07:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229538AbhGYLoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 07:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 373716056B;
        Sun, 25 Jul 2021 12:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627215887;
        bh=iyHBZBMQHrLtGg3F5twV/u7oxW4MK9dAHrwhgymmVm8=;
        h=From:To:Cc:Subject:Date:From;
        b=U2tuasGNjWrEjvplmPvlWtlB2oi63MZWioRC+p1b0txyBlUNYqqh8R9RYOvLOk3Le
         cfLH3tOJ6wsb8JmttnrIf4v8vba/5SNA8/D7/Lk0VQoAXiCCj97ByCs1WPFvnIn5u0
         xCt2V8j3XEIiROhrql7GQ5fj0KrK1F7s13Hbdout+SNggOR/zUOdrFulaDE1Bi8Kz3
         GGPRW3swRPryfkaRoS7faPiOv3HSYjhirpdrDPlMXT2aBT+xxq1s8sTZJuqduAZOyy
         SLLoqYHU5fmMfQHcq6S1IcAJ1+2kzaefR7RR4jubwXUIlPjiUyVxVFRLIofwhPcU9F
         Ffcf9ADyykRHw==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] devlink: Remove duplicated registration check
Date:   Sun, 25 Jul 2021 15:24:41 +0300
Message-Id: <ed7bbb1e4c51dd58e6035a058e93d16f883b09ce.1627215829.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
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

