Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC2447598
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 21:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhKGUP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 15:15:56 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:53389 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhKGUPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 15:15:55 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id joXLmnycNIEdljoXMmSodT; Sun, 07 Nov 2021 21:13:11 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 07 Nov 2021 21:13:11 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, gsomlo@gmail.com,
        joel@jms.id.au, caihuoqing@baidu.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] litex_liteeth: Fix a double free in the remove function
Date:   Sun,  7 Nov 2021 21:13:07 +0100
Message-Id: <25b34e3bea4da381228953e484e5c699796dafe8.1636315896.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'netdev' is a managed resource allocated in the probe using
'devm_alloc_etherdev()'.
It must not be freed explicitly in the remove function.

Fixes: ee7da21ac4c3 ("net: Add driver for LiteX's LiteETH network interface")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/litex/litex_liteeth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index 3d9385a4989b..24ed6e180c75 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -289,7 +289,6 @@ static int liteeth_remove(struct platform_device *pdev)
 	struct net_device *netdev = platform_get_drvdata(pdev);
 
 	unregister_netdev(netdev);
-	free_netdev(netdev);
 
 	return 0;
 }
-- 
2.30.2

