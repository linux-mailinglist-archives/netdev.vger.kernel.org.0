Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B258433650
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhJSMu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbhJSMu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:50:57 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0241C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:48:44 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:b4c3:ba80:54db:46f])
        by albert.telenet-ops.be with bizsmtp
        id 7ooj2600412AN0U06oojrJ; Tue, 19 Oct 2021 14:48:43 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoXq-0069Sw-Tg; Tue, 19 Oct 2021 14:48:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mcoXp-00EJ7U-VP; Tue, 19 Oct 2021 14:48:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: wlcore: spi: Use dev_err_probe()
Date:   Tue, 19 Oct 2021 14:48:41 +0200
Message-Id: <465e76901b801ac0755088998249928fd546c08a.1634647460.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the existing dev_err_probe() helper instead of open-coding the same
operation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Compile-tested only.
---
 drivers/net/wireless/ti/wlcore/spi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index f26fc150ecd01460..354a7e1c3315c6e2 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -488,12 +488,9 @@ static int wl1271_probe(struct spi_device *spi)
 	spi->bits_per_word = 32;
 
 	glue->reg = devm_regulator_get(&spi->dev, "vwlan");
-	if (PTR_ERR(glue->reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-	if (IS_ERR(glue->reg)) {
-		dev_err(glue->dev, "can't get regulator\n");
-		return PTR_ERR(glue->reg);
-	}
+	if (IS_ERR(glue->reg))
+		return dev_err_probe(glue->dev, PTR_ERR(glue->reg),
+				     "can't get regulator\n");
 
 	ret = wlcore_probe_of(spi, glue, pdev_data);
 	if (ret) {
-- 
2.25.1

