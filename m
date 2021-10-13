Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BF942CB45
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhJMUqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229892AbhJMUqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03B0E6113D;
        Wed, 13 Oct 2021 20:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634157885;
        bh=LodjF69f+UYXGKA7PpcABtj4HTTxvWlBt3KEMjSgE48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZe0GGblrEjb8Y1lXsd+6MQMdwSRnjU8v80t4tobxE9Y+oU1dHMm7WZNkWVbSisyb
         B53iFLqFlmQKNw4+Fz/C0dL50kJ225GMRnmFy78Q/aDv4GO3fvIStnEwMUzxTv9zle
         1p97xb5cfTb4QLoohvy0o0LNn8njXDbE/Tt4UwvgcgUfBjLts6/p6bceobrwqUnCni
         g5NzBvj9/5lX1lE8a96++0xyIVgsQ5ww/aB/0k5pG1tj9DHWktH8E+MLi2UxeYLPFe
         RUvoZpbEAmxdGxd7gb0aI6uHNUHXNwgp9MZE/Vlk53ek/vBx2mAzlkYhvjZI8iadmA
         94i20LQMfWodA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/7] ethernet: make eth_hw_addr_random() use dev_addr_set()
Date:   Wed, 13 Oct 2021 13:44:30 -0700
Message-Id: <20211013204435.322561-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013204435.322561-1-kuba@kernel.org>
References: <20211013204435.322561-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/etherdevice.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 3cf546d2ffd1..76f7ff684cbf 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -269,8 +269,11 @@ static inline void eth_zero_addr(u8 *addr)
  */
 static inline void eth_hw_addr_random(struct net_device *dev)
 {
+	u8 addr[ETH_ALEN];
+
+	eth_random_addr(addr);
+	__dev_addr_set(dev, addr, ETH_ALEN);
 	dev->addr_assign_type = NET_ADDR_RANDOM;
-	eth_random_addr(dev->dev_addr);
 }
 
 /**
-- 
2.31.1

