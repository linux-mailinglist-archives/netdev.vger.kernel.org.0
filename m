Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7FF547C29
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbiFLVMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiFLVM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:12:29 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A23CCD6
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:12:25 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 0UsfoNjEHm7vs0UsfoeDyX; Sun, 12 Jun 2022 23:12:23 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 12 Jun 2022 23:12:23 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Date:   Sun, 12 Jun 2022 23:12:20 +0200
Message-Id: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after a successful call to p54spi_request_firmware(), it
must be undone by a corresponding release_firmware() as already done in
the error handling path of p54spi_request_firmware() and in the .remove()
function.

Add the missing call in the error handling path and remove it from
p54spi_request_firmware() now that it is the responsibility of the caller
to release the firmawre

Fixes: cd8d3d321285 ("p54spi: p54spi driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: reduce diffstat and take advantage on the fact that release_firmware()
checks for NULL
---
 drivers/net/wireless/intersil/p54/p54spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index f99b7ba69fc3..19152fd449ba 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -164,7 +164,7 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
 
 	ret = p54_parse_firmware(dev, priv->firmware);
 	if (ret) {
-		release_firmware(priv->firmware);
+		/* the firmware is released by the caller */
 		return ret;
 	}
 
@@ -659,6 +659,7 @@ static int p54spi_probe(struct spi_device *spi)
 	return 0;
 
 err_free_common:
+	release_firmware(priv->firmware);
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 err_free_gpio_irq:
 	gpio_free(p54spi_gpio_irq);
-- 
2.34.1

