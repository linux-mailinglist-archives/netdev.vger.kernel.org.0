Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B918F39FADE
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233146AbhFHPha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhFHPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:37:23 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2359C061789
        for <netdev@vger.kernel.org>; Tue,  8 Jun 2021 08:35:30 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970dd3e020a52263b5aabfb3.dip0.t-ipconnect.de [IPv6:2003:c5:970d:d3e0:20a5:2263:b5aa:bfb3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 71C1E17405A;
        Tue,  8 Jun 2021 17:27:06 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 10/11] batman-adv: Don't manually reattach hard-interface
Date:   Tue,  8 Jun 2021 17:26:59 +0200
Message-Id: <20210608152700.30315-11-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210608152700.30315-1-sw@simonwunderlich.de>
References: <20210608152700.30315-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The batadv_hardif_enable_interface is now only called from the callback
ndo_add_slave. This callback is only used by do_set_master in the rtnetlink
code which only does two things:

1. remove the net_device from its old master
2. add the net_device to its new batadv master

The code to replicate the first step in batman-adv is therefore unused
since the sysfs code was dropped.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/hard-interface.c | 34 ---------------------------------
 1 file changed, 34 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 81d201cc343d..44b0aa30c30a 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -677,31 +677,6 @@ batadv_hardif_deactivate_interface(struct batadv_hard_iface *hard_iface)
 	batadv_update_min_mtu(hard_iface->soft_iface);
 }
 
-/**
- * batadv_master_del_slave() - remove hard_iface from the current master iface
- * @slave: the interface enslaved in another master
- * @master: the master from which slave has to be removed
- *
- * Invoke ndo_del_slave on master passing slave as argument. In this way the
- * slave is free'd and the master can correctly change its internal state.
- *
- * Return: 0 on success, a negative value representing the error otherwise
- */
-static int batadv_master_del_slave(struct batadv_hard_iface *slave,
-				   struct net_device *master)
-{
-	int ret;
-
-	if (!master)
-		return 0;
-
-	ret = -EBUSY;
-	if (master->netdev_ops->ndo_del_slave)
-		ret = master->netdev_ops->ndo_del_slave(master, slave->net_dev);
-
-	return ret;
-}
-
 /**
  * batadv_hardif_enable_interface() - Enslave hard interface to soft interface
  * @hard_iface: hard interface to add to soft interface
@@ -713,7 +688,6 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 				   struct net_device *soft_iface)
 {
 	struct batadv_priv *bat_priv;
-	struct net_device *master;
 	__be16 ethertype = htons(ETH_P_BATMAN);
 	int max_header_len = batadv_max_header_len();
 	int ret;
@@ -732,14 +706,6 @@ int batadv_hardif_enable_interface(struct batadv_hard_iface *hard_iface,
 		goto err_dev;
 	}
 
-	/* check if the interface is enslaved in another virtual one and
-	 * in that case unlink it first
-	 */
-	master = netdev_master_upper_dev_get(hard_iface->net_dev);
-	ret = batadv_master_del_slave(hard_iface, master);
-	if (ret)
-		goto err_dev;
-
 	hard_iface->soft_iface = soft_iface;
 	bat_priv = netdev_priv(hard_iface->soft_iface);
 
-- 
2.20.1

