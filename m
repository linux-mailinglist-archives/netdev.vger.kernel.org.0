Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBE238EC4C
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbhEXPNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234234AbhEXPHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:07:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 999B261864;
        Mon, 24 May 2021 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867879;
        bh=RoB6vYWZYdd+NFdYaGdOcUCdT3LohU7v+XM3Bfae6t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDRJ7iextn6tZPuw8yPUcphJkLikbMoo7OL9OO+sUygKxXLr/niUsYClX2NEF6Msi
         pkxB5wbo23dxSn6aGljsdVeZa58ACvg9UUKtsR0enRKun6XAtvTB6uo9GB4UctRzaz
         X0DUL+AVXDhC/Y0L3g7RSLb0if7hTxVtKD1dn7jzGi6/na/NFH20BdUwpJKvvCwtIt
         GoeFytnffUfPaZlU3Veed37PJaWlGsSdQT5AXxDVGfJEiY23u6mKtHZea95cLN0BmJ
         CL4dwJpMbxyb9aY5D52pUdDgNtZe+31seRvEh/x7ATfeThNYqsHdPG567aLQbzh9iC
         ZJZpvwHP7FO4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/19] libertas: register sysfs groups properly
Date:   Mon, 24 May 2021 10:50:57 -0400
Message-Id: <20210524145106.2499571-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145106.2499571-1-sashal@kernel.org>
References: <20210524145106.2499571-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 7e79b38fe9a403b065ac5915465f620a8fb3de84 ]

The libertas driver was trying to register sysfs groups "by hand" which
causes them to be created _after_ the device is initialized and
announced to userspace, which causes races and can prevent userspace
tools from seeing the sysfs files correctly.

Fix this up by using the built-in sysfs_groups pointers in struct
net_device which were created for this very reason, fixing the race
condition, and properly allowing for any error that might have occured
to be handled properly.

Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-54-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 28 +++-----------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index d0c881dd5846..f1e9cbcfdc16 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -797,19 +797,6 @@ static const struct attribute_group mesh_ie_group = {
 	.attrs = mesh_ie_attrs,
 };
 
-static void lbs_persist_config_init(struct net_device *dev)
-{
-	int ret;
-	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
-	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-
-static void lbs_persist_config_remove(struct net_device *dev)
-{
-	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
-	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-
 
 /***************************************************************************
  * Initializing and starting, stopping mesh
@@ -1021,6 +1008,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	mesh_dev->sysfs_groups[0] = &lbs_mesh_attr_group;
+	mesh_dev->sysfs_groups[1] = &boot_opts_group;
+	mesh_dev->sysfs_groups[2] = &mesh_ie_group;
+
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
 	if (ret) {
@@ -1028,19 +1019,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
 		goto err_free_netdev;
 	}
 
-	ret = sysfs_create_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	if (ret)
-		goto err_unregister;
-
-	lbs_persist_config_init(mesh_dev);
-
 	/* Everything successful */
 	ret = 0;
 	goto done;
 
-err_unregister:
-	unregister_netdev(mesh_dev);
-
 err_free_netdev:
 	free_netdev(mesh_dev);
 
@@ -1063,8 +1045,6 @@ void lbs_remove_mesh(struct lbs_private *priv)
 	lbs_deb_enter(LBS_DEB_MESH);
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(mesh_dev);
-	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	lbs_persist_config_remove(mesh_dev);
 	unregister_netdev(mesh_dev);
 	priv->mesh_dev = NULL;
 	kfree(mesh_dev->ieee80211_ptr);
-- 
2.30.2

