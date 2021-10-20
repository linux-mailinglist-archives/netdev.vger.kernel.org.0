Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042A4434F75
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhJTP6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhJTP6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB776137C;
        Wed, 20 Oct 2021 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745387;
        bh=jp9qbUbD/R25WRi0fCjk2mPud+kOJsUFpPiMz3YYP4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0siUOA+aDMhKlrYJN+sIexJYmr1Tv32Lnr+/qzVtpC19SBIitspKwaq/CighmwOo
         m4wXQ0X2gufQ3jxqWoGRsCgkE4c3r+5YlRhCMWsdKdUYH2BuMXKCjwfijHBtvEIQfL
         9LQtSM3jOgGUeGWpBgb2PeRhPd4/1MkHs9NKm/X7XIT9MaV+De8bl/TyBunmyG848N
         g+hrKXOHzVyRlnHJURRaFYt34tBWMs1NsmMm2IV/3dEOkyIbpx1YzCTHD2KYSXmS5Q
         G30i/Vig9ytlw6jO7WnMhOjGdEegQYpkl22b5PhZfJKofBv4CofeEjm6w0PfMkYJH1
         ktQdU1F5h6iJA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jes@trained-monkey.org, linux-hippi@sunsite.dk
Subject: [PATCH net-next 08/12] net: hippi: use dev_addr_set()
Date:   Wed, 20 Oct 2021 08:56:13 -0700
Message-Id: <20211020155617.1721694-9-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
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

