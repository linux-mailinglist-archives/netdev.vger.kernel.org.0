Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA5426643
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhJHI4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:56:10 -0400
Received: from out0.migadu.com ([94.23.1.103]:51106 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233828AbhJHI4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 04:56:09 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633683250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iAYZBQ/3c+vBIDIjf/yASEljqPiYUlkZJ1BTMT57kY8=;
        b=f0rTDEpUEGRKhcMrCryykcAZ3UQqgdvNcCUFyjGKbcqBojGd87Go4nAS9i7k656H68S7YA
        OKKUjhGfj386hJIkKmnzxM4f0ynDoKx8fqocXas6lpOBZdgCa6HA0fMatW6kz026+5jm4c
        c/rgHWZPUDMHFYZnxgAiK6SwanXbpgY=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: dev_addr_list: Introduce __dev_addr_add() and __dev_addr_del()
Date:   Fri,  8 Oct 2021 16:53:54 +0800
Message-Id: <20211008085354.9961-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce helper functions __dev_addr_add() and __dev_addr_del() for
the same code, make the code more concise.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/dev_addr_lists.c | 117 ++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 69 deletions(-)

diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index f0cb38344126..f6e33bdc0a30 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -614,6 +614,38 @@ int dev_addr_del(struct net_device *dev, const unsigned char *addr,
 }
 EXPORT_SYMBOL(dev_addr_del);
 
+static int __dev_addr_add(struct net_device *dev, const unsigned char *addr,
+			  unsigned char addr_type, bool global, bool sync,
+			  bool exclusive)
+{
+	int err;
+
+	netif_addr_lock_bh(dev);
+	err = __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,
+			       addr_type, global, sync,
+			       0, exclusive);
+	if (!err)
+		__dev_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
+
+	return err;
+}
+
+static int __dev_addr_del(struct net_device *dev, const unsigned char *addr,
+			  unsigned char addr_type, bool global, bool sync)
+{
+	int err;
+
+	netif_addr_lock_bh(dev);
+	err = __hw_addr_del_ex(&dev->uc, addr, dev->addr_len,
+			       addr_type, global, sync);
+	if (!err)
+		__dev_set_rx_mode(dev);
+	netif_addr_unlock_bh(dev);
+
+	return err;
+}
+
 /*
  * Unicast list handling functions
  */
@@ -625,16 +657,9 @@ EXPORT_SYMBOL(dev_addr_del);
  */
 int dev_uc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
 
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_add_ex(&dev->uc, addr, dev->addr_len,
-			       NETDEV_HW_ADDR_T_UNICAST, true, false,
-			       0, true);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_UNICAST,
+			      true, false, true);
 }
 EXPORT_SYMBOL(dev_uc_add_excl);
 
@@ -648,15 +673,8 @@ EXPORT_SYMBOL(dev_uc_add_excl);
  */
 int dev_uc_add(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_add(&dev->uc, addr, dev->addr_len,
-			    NETDEV_HW_ADDR_T_UNICAST);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_UNICAST,
+			      false, false, false);
 }
 EXPORT_SYMBOL(dev_uc_add);
 
@@ -670,15 +688,8 @@ EXPORT_SYMBOL(dev_uc_add);
  */
 int dev_uc_del(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_del(&dev->uc, addr, dev->addr_len,
-			    NETDEV_HW_ADDR_T_UNICAST);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_addr_del(dev, addr, NETDEV_HW_ADDR_T_UNICAST,
+			      false, false);
 }
 EXPORT_SYMBOL(dev_uc_del);
 
@@ -810,33 +821,11 @@ EXPORT_SYMBOL(dev_uc_init);
  */
 int dev_mc_add_excl(struct net_device *dev, const unsigned char *addr)
 {
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_add_ex(&dev->mc, addr, dev->addr_len,
-			       NETDEV_HW_ADDR_T_MULTICAST, true, false,
-			       0, true);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
+	return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,
+			       true, false, true);
 }
 EXPORT_SYMBOL(dev_mc_add_excl);
 
-static int __dev_mc_add(struct net_device *dev, const unsigned char *addr,
-			bool global)
-{
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_add_ex(&dev->mc, addr, dev->addr_len,
-			       NETDEV_HW_ADDR_T_MULTICAST, global, false,
-			       0, false);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
-}
 /**
  *	dev_mc_add - Add a multicast address
  *	@dev: device
@@ -847,7 +836,8 @@ static int __dev_mc_add(struct net_device *dev, const unsigned char *addr,
  */
 int dev_mc_add(struct net_device *dev, const unsigned char *addr)
 {
-	return __dev_mc_add(dev, addr, false);
+	return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,
+			      false, false, false);
 }
 EXPORT_SYMBOL(dev_mc_add);
 
@@ -860,24 +850,11 @@ EXPORT_SYMBOL(dev_mc_add);
  */
 int dev_mc_add_global(struct net_device *dev, const unsigned char *addr)
 {
-	return __dev_mc_add(dev, addr, true);
+	return __dev_addr_add(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,
+			      true, false, false);
 }
 EXPORT_SYMBOL(dev_mc_add_global);
 
-static int __dev_mc_del(struct net_device *dev, const unsigned char *addr,
-			bool global)
-{
-	int err;
-
-	netif_addr_lock_bh(dev);
-	err = __hw_addr_del_ex(&dev->mc, addr, dev->addr_len,
-			       NETDEV_HW_ADDR_T_MULTICAST, global, false);
-	if (!err)
-		__dev_set_rx_mode(dev);
-	netif_addr_unlock_bh(dev);
-	return err;
-}
-
 /**
  *	dev_mc_del - Delete a multicast address.
  *	@dev: device
@@ -888,7 +865,8 @@ static int __dev_mc_del(struct net_device *dev, const unsigned char *addr,
  */
 int dev_mc_del(struct net_device *dev, const unsigned char *addr)
 {
-	return __dev_mc_del(dev, addr, false);
+	return __dev_addr_del(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,
+			      false, false);
 }
 EXPORT_SYMBOL(dev_mc_del);
 
@@ -902,7 +880,8 @@ EXPORT_SYMBOL(dev_mc_del);
  */
 int dev_mc_del_global(struct net_device *dev, const unsigned char *addr)
 {
-	return __dev_mc_del(dev, addr, true);
+	return __dev_addr_del(dev, addr, NETDEV_HW_ADDR_T_MULTICAST,
+			      true, false);
 }
 EXPORT_SYMBOL(dev_mc_del_global);
 
-- 
2.32.0

