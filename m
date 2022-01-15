Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226EF48F6E3
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 13:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiAOMpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 07:45:20 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:62136 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231296AbiAOMpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 07:45:19 -0500
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id 8iQinzVVSIz5V8iQinfmtS; Sat, 15 Jan 2022 13:45:18 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sat, 15 Jan 2022 13:45:18 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Conley Lee <conleylee@foxmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: [PATCH] net: ethernet: sun4i-emac: Fix an error handling path in emac_probe()
Date:   Sat, 15 Jan 2022 13:45:03 +0100
Message-Id: <aa2344da574f58aeba869a9219b3549dbd65d8e4.1642250684.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A dma_request_chan() call is hidden in emac_configure_dma().
It must be released in the probe if an error occurs, as already done in
the remove function.

Add the corresponding dma_release_channel() call.

Fixes: 47869e82c8b8 ("sun4i-emac.c: add dma support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 74635a6fa8ca..621ce742ad21 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -1072,6 +1072,7 @@ static int emac_probe(struct platform_device *pdev)
 	clk_disable_unprepare(db->clk);
 out_dispose_mapping:
 	irq_dispose_mapping(ndev->irq);
+	dma_release_channel(db->rx_chan);
 out_iounmap:
 	iounmap(db->membase);
 out:
-- 
2.32.0

