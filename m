Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D594553AE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbhKREST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242865AbhKRESH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BEAD61B73;
        Thu, 18 Nov 2021 04:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208907;
        bh=Rt7UQtKMq8/Bd8T0ZsSpL90p1gd7biIUF2/FTp9ghtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j1FHvDeRSOChpeSQjxRrmvL8zdkeFNc8PIY+mV2S0o4nJFgOUWlae1X0LmZ/SIzco
         F+hwLUkpYa2fA5zwtGaD4kyBUHoYC3WdowIBo7LOnZzsBglqXf4LGE4CBeSUvfNCH0
         Zj6f1g34jwrKSNbRC3o7CmTHRpeDYJfGon5SZz5CrOdeA3RyI/c9zuYRHrDzgLCjAL
         2LC2xzpwhjQW66foq17vFFmJ5LakFkyVBtYVNmNul9mgMc7wytLiyNAdjaTLX7LAYG
         CUKPH68r7N7H84UXLti18L+DclOk+D/32bP7OgK+25rde+SBFD9nAWxKnUKF1xXRAu
         R9XX1QbzoXokA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/9] net: constify netdev->dev_addr
Date:   Wed, 17 Nov 2021 20:14:57 -0800
Message-Id: <20211118041501.3102861-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. We converted all users to make modifications via appropriate
helpers, make netdev->dev_addr const.

The update helpers need to upcast from the buffer to
struct netdev_hw_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 14 +++++---------
 net/core/dev_addr_lists.c | 10 ++++++++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f4a299e92de..2462195784a9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2117,7 +2117,7 @@ struct net_device {
  * Cache lines mostly used on receive path (including eth_type_trans())
  */
 	/* Interface address info used in eth_type_trans() */
-	unsigned char		*dev_addr;
+	const unsigned char	*dev_addr;
 
 	struct netdev_rx_queue	*_rx;
 	unsigned int		num_rx_queues;
@@ -4268,10 +4268,13 @@ void __hw_addr_unsync_dev(struct netdev_hw_addr_list *list,
 void __hw_addr_init(struct netdev_hw_addr_list *list);
 
 /* Functions used for device addresses handling */
+void dev_addr_mod(struct net_device *dev, unsigned int offset,
+		  const void *addr, size_t len);
+
 static inline void
 __dev_addr_set(struct net_device *dev, const void *addr, size_t len)
 {
-	memcpy(dev->dev_addr, addr, len);
+	dev_addr_mod(dev, 0, addr, len);
 }
 
 static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
@@ -4279,13 +4282,6 @@ static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
 	__dev_addr_set(dev, addr, dev->addr_len);
 }
 
-static inline void
-dev_addr_mod(struct net_device *dev, unsigned int offset,
-	     const void *addr, size_t len)
-{
-	memcpy(&dev->dev_addr[offset], addr, len);
-}
-
 int dev_addr_add(struct net_device *dev, const unsigned char *addr,
 		 unsigned char addr_type);
 int dev_addr_del(struct net_device *dev, const unsigned char *addr,
diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
index f0cb38344126..ae8b1ef00fec 100644
--- a/net/core/dev_addr_lists.c
+++ b/net/core/dev_addr_lists.c
@@ -549,6 +549,16 @@ int dev_addr_init(struct net_device *dev)
 }
 EXPORT_SYMBOL(dev_addr_init);
 
+void dev_addr_mod(struct net_device *dev, unsigned int offset,
+		  const void *addr, size_t len)
+{
+	struct netdev_hw_addr *ha;
+
+	ha = container_of(dev->dev_addr, struct netdev_hw_addr, addr[0]);
+	memcpy(&ha->addr[offset], addr, len);
+}
+EXPORT_SYMBOL(dev_addr_mod);
+
 /**
  *	dev_addr_add - Add a device address
  *	@dev: device
-- 
2.31.1

