Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65942FE00
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238924AbhJOWTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:19:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238838AbhJOWTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 18:19:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C3096120C;
        Fri, 15 Oct 2021 22:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634336223;
        bh=j+CU5Kyr/IB64ISV5Q9JVaEQJqrqMImhmPAvNVerqhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQcfIEO3P58kaTQyt/Jd76dmQQAD58t1E/pStcM0HFWUB/y1ENqO/ixZ8d8o60WSr
         FFbsEXXH9i1u4VeGi0KdK5KKJvL2RDCSqH0nBqarQxnHP/I+7Fj5ZGH+9pdvQVJ1iN
         +39z2ByOwVjEFX+Fa5TdAS7lk7+NckE97RayI/SwRy/SFXgLuTa/yujKjcD0wAB2+b
         t++p8K6kVqueetO3BVDeDLEUXcAJJC7l3tzZSuGZRBO3SP4+l7wh2Tg9Uq9EY3f12P
         2OViCDZSU/hYcEC6Ko+40bgn23qoZ1Mu9e1pVvUq/aI/L98jZBGX7dDyCJuqA6Tdmk
         jSIgfRheVd1Ag==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        reksio@newterm.pl
Subject: [PATCH net-next 09/12] ethernet: ec_bhf: use eth_hw_addr_set()
Date:   Fri, 15 Oct 2021 15:16:49 -0700
Message-Id: <20211015221652.827253-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015221652.827253-1-kuba@kernel.org>
References: <20211015221652.827253-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Copy the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: reksio@newterm.pl
---
 drivers/net/ethernet/ec_bhf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index b2d4fb3feb74..46e3a05e9582 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -479,6 +479,7 @@ static int ec_bhf_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct net_device *net_dev;
 	struct ec_bhf_priv *priv;
 	void __iomem *dma_io;
+	u8 addr[ETH_ALEN];
 	void __iomem *io;
 	int err = 0;
 
@@ -539,7 +540,8 @@ static int ec_bhf_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (err < 0)
 		goto err_free_net_dev;
 
-	memcpy_fromio(net_dev->dev_addr, priv->mii_io + MII_MAC_ADDR, 6);
+	memcpy_fromio(addr, priv->mii_io + MII_MAC_ADDR, ETH_ALEN);
+	eth_hw_addr_set(net_dev, addr);
 
 	err = register_netdev(net_dev);
 	if (err < 0)
-- 
2.31.1

