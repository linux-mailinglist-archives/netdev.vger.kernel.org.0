Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27ED436284
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhJUNOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhJUNOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:14:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB59C61284;
        Thu, 21 Oct 2021 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821942;
        bh=jp9qbUbD/R25WRi0fCjk2mPud+kOJsUFpPiMz3YYP4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyLgP+7IRgEYCv2XKlKIY3LNgIiW3+6BM0vPcIxCrLS4xXbeGXNN8UGzH2QoXbNdd
         /Nh0oI7EKbN/IyUngbZKphxXKqzI7YWrN9qvmoo0PpJRFJcDBekH+1q05XNAxgJ2C9
         RJTKRxm2fIpVtwceaRFqPXVM+kyFHkRM7bNUq/2gkOAIdnDeuoLSXcv2WL2YmqPEfQ
         YC9W+gVQ1R3fZRJ/KwQ7Zm4zOsgeyxVrycrOrU3VpJ3cvPlMdx7m0YVuHCCRktwpxA
         +feqTO+QoOgbP2NHOaY/PtGzOTcCMT6OADhPoD/4ARny5Y8PXuv3P280rlgwlmuEZX
         zQMX8Y0IEMIug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jes@trained-monkey.org, linux-hippi@sunsite.dk
Subject: [PATCH net-next v2 08/12] net: hippi: use dev_addr_set()
Date:   Thu, 21 Oct 2021 06:12:10 -0700
Message-Id: <20211021131214.2032925-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211021131214.2032925-1-kuba@kernel.org>
References: <20211021131214.2032925-1-kuba@kernel.org>
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
CC: jes@trained-monkey.org
CC: linux-hippi@sunsite.dk
---
 drivers/net/hippi/rrunner.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 7661dbb31162..16105292b140 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -502,6 +502,7 @@ static unsigned int write_eeprom(struct rr_private *rrpriv,
 
 static int rr_init(struct net_device *dev)
 {
+	u8 addr[HIPPI_ALEN] __aligned(4);
 	struct rr_private *rrpriv;
 	struct rr_regs __iomem *regs;
 	u32 sram_size, rev;
@@ -537,10 +538,11 @@ static int rr_init(struct net_device *dev)
 	 * other method I've seen.  -VAL
 	 */
 
-	*(__be16 *)(dev->dev_addr) =
+	*(__be16 *)(addr) =
 	  htons(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA)));
-	*(__be32 *)(dev->dev_addr+2) =
+	*(__be32 *)(addr+2) =
 	  htonl(rr_read_eeprom_word(rrpriv, offsetof(struct eeprom, manf.BoardULA[4])));
+	dev_addr_set(dev, addr);
 
 	printk("  MAC: %pM\n", dev->dev_addr);
 
-- 
2.31.1

