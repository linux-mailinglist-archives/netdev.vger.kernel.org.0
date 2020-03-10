Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4824717EE76
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCJCPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbgCJCPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 22:15:23 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18ED024673;
        Tue, 10 Mar 2020 02:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583806523;
        bh=P3RlZiF5EhB8h9sJiafMnWBG3Icyos8K0DVn7y/OSPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bs/fm9yyW0T8j7VqZessdGjxThUgSUr77nf85rfn3x/uVroG+dktch8yoNhNFzHnv
         DI1XYhWNkkC5Rl6wKegkEgzkp5RSd1tRhv0b4MnII0wLXohgdnWRqBq2X8c5mVenk2
         Y069Tr2atb0e7Izw+DNEyn0Fo4IW5BBt/6TwTbR0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, akiyano@amazon.com, netanel@amazon.com,
        gtzalik@amazon.com, irusskikh@marvell.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, rmody@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, aelior@marvell.com,
        skalluru@marvell.com, GR-everest-linux-l2@marvell.com,
        opendmb@gmail.com, siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, dchickles@marvell.com, sburla@marvell.com,
        fmanlunas@marvell.com, tariqt@mellanox.com, vishal@chelsio.com,
        leedom@chelsio.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/15] net: bcmgenet: reject unsupported coalescing params
Date:   Mon,  9 Mar 2020 19:15:03 -0700
Message-Id: <20200310021512.1861626-7-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310021512.1861626-1-kuba@kernel.org>
References: <20200310021512.1861626-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject all unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index c2fda12cf773..c476f13d0eaf 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -686,10 +686,6 @@ static int bcmgenet_set_coalesce(struct net_device *dev,
 	 * always generate an interrupt either after MBDONE packets have been
 	 * transmitted, or when the ring is empty.
 	 */
-	if (ec->tx_coalesce_usecs || ec->tx_coalesce_usecs_high ||
-	    ec->tx_coalesce_usecs_irq || ec->tx_coalesce_usecs_low ||
-	    ec->use_adaptive_tx_coalesce)
-		return -EOPNOTSUPP;
 
 	/* Program all TX queues with the same values, as there is no
 	 * ethtool knob to do coalescing on a per-queue basis
@@ -1113,6 +1109,9 @@ static int bcmgenet_set_eee(struct net_device *dev, struct ethtool_eee *e)
 
 /* standard ethtool support functions. */
 static const struct ethtool_ops bcmgenet_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS |
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE_RX,
 	.begin			= bcmgenet_begin,
 	.complete		= bcmgenet_complete,
 	.get_strings		= bcmgenet_get_strings,
-- 
2.24.1

