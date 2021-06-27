Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8432A3B54B0
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 20:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhF0SsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 14:48:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231288AbhF0SsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Jun 2021 14:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C6B460238;
        Sun, 27 Jun 2021 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624819552;
        bh=3hhruk8vsdFYQE9Ix7WJ83E7zQ+QcT3hQRPYO9nBSIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=CBWdslT8I612HJasa5MRKDWsMgFYzySb+kj1GYAQtP49EAxdFwVq4sWMdQwOjOrjg
         DL6JLizYG42iOUrqGIs268wxrvdQ/6g9HSsg8nt7kKTFYzSPZ3QUvrvu1Jo8t0wSX6
         Kn6ySjWXlvBH6yU5tcNb6MRqDMlWq5G7CNLiuwiHdRwp600pWJ54m72kXvxSEQT3X4
         wBAcc8G4K0olko4fiZd1Sdke6U7Bbv9om/VWqEoUIdfA25xRAtjooXSrDYZBQp+sZ1
         WHMvmbhkP+yLCGOB2snAs0U1UWV3XEc+kNhYSRqF03sMvgkV7g1LCS7xhxPRCuSo4p
         GrouzVj3EyuWw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net: sparx5: Do not use mac_addr uninitialized in mchp_sparx5_probe()
Date:   Sun, 27 Jun 2021 11:45:43 -0700
Message-Id: <20210627184543.4122478-1-nathan@kernel.org>
X-Mailer: git-send-email 2.32.0.93.g670b81a890
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/ethernet/microchip/sparx5/sparx5_main.c:760:29: warning:
variable 'mac_addr' is uninitialized when used here [-Wuninitialized]
        if (of_get_mac_address(np, mac_addr)) {
                                   ^~~~~~~~
drivers/net/ethernet/microchip/sparx5/sparx5_main.c:669:14: note:
initialize the variable 'mac_addr' to silence this warning
        u8 *mac_addr;
                    ^
                     = NULL
1 warning generated.

mac_addr is only used to store the value retrieved from
of_get_mac_address(), which is then copied into the base_mac member of
the sparx5 struct using ether_addr_copy(). It is easier to just use the
base_mac address directly, which avoids the warning and the extra copy.

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/1413
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index a325f7c05a07..c73359de3fdd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -666,7 +666,6 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	struct reset_control *reset;
 	struct sparx5 *sparx5;
 	int idx = 0, err = 0;
-	u8 *mac_addr;
 
 	if (!np && !pdev->dev.platform_data)
 		return -ENODEV;
@@ -757,12 +756,10 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_config;
 
-	if (of_get_mac_address(np, mac_addr)) {
+	if (!of_get_mac_address(np, sparx5->base_mac)) {
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
-	} else {
-		ether_addr_copy(sparx5->base_mac, mac_addr);
 	}
 
 	sparx5->xtr_irq = platform_get_irq_byname(sparx5->pdev, "xtr");

base-commit: ff8744b5eb116fdf9b80a6ff774393afac7325bd
-- 
2.32.0.93.g670b81a890

