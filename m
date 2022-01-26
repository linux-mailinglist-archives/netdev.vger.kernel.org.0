Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0267949C03B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiAZAiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235355AbiAZAiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:38:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BF3C06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E63B81B9D
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11975C340EF;
        Wed, 26 Jan 2022 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643157487;
        bh=LnVgHwnzz6kGeN/ldDgS21isdYgANJXvfysLOD9AdlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cX1ybcKxR5AH7p62um6KGGPuqGN+7INBYDJRxyz95bCX/AM/0QWh3DZIF3a1X5Ciz
         8EaJd53F8f+2Ia+F1k1HYsOQg97F6VY1CEQKij6WYUlGFClYYD8rf04fEkOtVsWF+L
         /y0q7q0FisHyUfW7PSZYgzZA1fDg551Vs+/2ksG3//R3LwSj5CgTVe49hJwfVD55in
         XyNRt8OkAkpnVTub76iDKPBpouxoStnfmIniX8q1WTHrUkLqX+Dj3D+9h/ltq1a+Jk
         ZUoKZeKuyWs16xy258fX4RjIetmgR9g7n/66fz4zlyHv9+jjuD3G0wMJVR/ooemAJf
         vLZIkBSRCR/vg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dave@thedillows.org, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 5/6] ethernet: 8390/etherh: don't write directly to netdev->dev_addr
Date:   Tue, 25 Jan 2022 16:38:00 -0800
Message-Id: <20220126003801.1736586-6-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126003801.1736586-1-kuba@kernel.org>
References: <20220126003801.1736586-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev->dev_addr is const now.

Compile tested rpc_defconfig w/ GCC 8.5.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/8390/etherh.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index bd22a534b1c0..e7b879123bb1 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -655,6 +655,7 @@ etherh_probe(struct expansion_card *ec, const struct ecard_id *id)
 	struct ei_device *ei_local;
 	struct net_device *dev;
 	struct etherh_priv *eh;
+	u8 addr[ETH_ALEN];
 	int ret;
 
 	ret = ecard_request_resources(ec);
@@ -724,12 +725,13 @@ etherh_probe(struct expansion_card *ec, const struct ecard_id *id)
 	spin_lock_init(&ei_local->page_lock);
 
 	if (ec->cid.product == PROD_ANT_ETHERM) {
-		etherm_addr(dev->dev_addr);
+		etherm_addr(addr);
 		ei_local->reg_offset = etherm_regoffsets;
 	} else {
-		etherh_addr(dev->dev_addr, ec);
+		etherh_addr(addr, ec);
 		ei_local->reg_offset = etherh_regoffsets;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	ei_local->name          = dev->name;
 	ei_local->word16        = 1;
-- 
2.34.1

