Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34A440C4A
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 01:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhJ3XRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 19:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhJ3XRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 19:17:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1066060F4C;
        Sat, 30 Oct 2021 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635635714;
        bh=xmO0M28RluItCTYskEYW/9cgDS1g/C2qVeETTSyk77o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEGWmGhT+k+vkulQAUXFetQTVp6on6n8UUUeVkIDaY3WnV668y12LEkOVCwNBRB2R
         nIzvSzTNRA/rA0SnTZL1eNybtBFKpnhW2oHBmNQLdq+E3BcExVqOqZPxr9H8jkYmf5
         yrpiLJ3WQL3CHSool/z4g/YONXMnj0LSuWGtkZGShMJ2z5w4QoHaoXMOzlAhhId+Xs
         +T5Lz6WYg+spp8hR8MG9lRi4wRPqMZIH3zKzF5c0tKLe0w2xw7ZRjdD8GlMuJlu8gH
         4C+m+NwJbNyyXtM5gFhDbZK5F35hQTh4SFGr/Na68h8NNHRGws0G0prLTFmwqPJu3H
         iCZ+JOwj4ficw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/5] netdevsim: take rtnl_lock when assigning num_vfs
Date:   Sat, 30 Oct 2021 16:15:01 -0700
Message-Id: <20211030231505.2478149-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030231505.2478149-1-kuba@kernel.org>
References: <20211030231505.2478149-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy VF NDOs look at num_vfs and then based on that
index into vfconfig. If we don't rtnl_lock() num_vfs
may get set to 0 and vfconfig freed/replaced while
the NDO is running.

We don't need to protect replacing vfconfig since it's
only done when num_vfs is 0.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 29f5627d11e6..284223108d25 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -24,6 +24,14 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 	return container_of(dev, struct nsim_bus_dev, dev);
 }
 
+static void
+nsim_bus_dev_set_vfs(struct nsim_bus_dev *nsim_bus_dev, unsigned int num_vfs)
+{
+	rtnl_lock();
+	nsim_bus_dev->num_vfs = num_vfs;
+	rtnl_unlock();
+}
+
 static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 				   unsigned int num_vfs)
 {
@@ -35,13 +43,13 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
-	nsim_bus_dev->num_vfs = num_vfs;
+	nsim_bus_dev_set_vfs(nsim_bus_dev, num_vfs);
 
 	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	if (nsim_esw_mode_is_switchdev(nsim_dev)) {
 		err = nsim_esw_switchdev_enable(nsim_dev, NULL);
 		if (err)
-			nsim_bus_dev->num_vfs = 0;
+			nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
 	}
 
 	return err;
@@ -51,7 +59,7 @@ void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 
-	nsim_bus_dev->num_vfs = 0;
+	nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
 	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	if (nsim_esw_mode_is_switchdev(nsim_dev))
 		nsim_esw_legacy_enable(nsim_dev, NULL);
-- 
2.31.1

