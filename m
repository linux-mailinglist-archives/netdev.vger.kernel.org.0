Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A8B433C91
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhJSQls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234690AbhJSQln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBA261052;
        Tue, 19 Oct 2021 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634661570;
        bh=5AiV/Fg4kVHmp2RjjSnThXkie9e67PDPXHZsklVPG5U=;
        h=From:To:Cc:Subject:Date:From;
        b=mz64BoZhV1gzW0UpYELV6ImaoRjOoCo5LWS0l2qN2V0DmjWBcpsBTq9LLqNtpbjmx
         jz6tc5skrSHGHzSF0/yFByjx8FmrhvObtFdM8jCTCgOX6ZSIrPRdXXn7ZYXT/Fa3MZ
         G22lXfF0b9O/QwI/adSRBy4D3lPD7gDISoP3qpqYSBci7qfYWcm5GyugGaWJ7lO8Hq
         Tkjn2nVd/4NK1nH4aoopM+8d6uIxfhZwIwR0VDZHVXHeZ11gqjw2ifxUwrjbtve02+
         nUvIgx18naEH5NoIxzynWluuWjhVRaSxNKkWywucmM79SViE4RSmoG2TXvCbkFOmWZ
         bMBJWvdchnG7A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] batman-adv: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Tue, 19 Oct 2021 09:39:27 -0700
Message-Id: <20211019163927.1386289-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Convert batman from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/batman-adv/soft-interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 0604b0279573..7ee09337fc40 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -134,7 +134,7 @@ static int batadv_interface_set_mac_addr(struct net_device *dev, void *p)
 		return -EADDRNOTAVAIL;
 
 	ether_addr_copy(old_addr, dev->dev_addr);
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	/* only modify transtable if it has been initialized before */
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
-- 
2.31.1

