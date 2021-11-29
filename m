Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87974623CE
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 22:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhK2V6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 16:58:50 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:52229 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhK2V4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 16:56:49 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id roaWmkOaeRLGproaWmw5eq; Mon, 29 Nov 2021 22:53:29 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 29 Nov 2021 22:53:29 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, atenart@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: marvell: mvpp2: Fix the computation of shared CPUs
Date:   Mon, 29 Nov 2021 22:53:27 +0100
Message-Id: <1093499694f6b375617197eae87db2083a17aaf4.1638222729.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'bitmap_fill()' fills a bitmap one 'long' at a time.
It is likely that an exact number of bits is expected.

Use 'bitmap_set()' instead in order not to set unexpected bits.

Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Having extra bits set looks harmless to me, but would require some
unneeded locking.
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a48e804c46f2..252e215a14f1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7454,7 +7454,7 @@ static int mvpp2_probe(struct platform_device *pdev)
 
 	shared = num_present_cpus() - priv->nthreads;
 	if (shared > 0)
-		bitmap_fill(&priv->lock_map,
+		bitmap_set(&priv->lock_map, 0,
 			    min_t(int, shared, MVPP2_MAX_THREADS));
 
 	for (i = 0; i < MVPP2_MAX_THREADS; i++) {
-- 
2.30.2

