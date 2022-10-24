Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBFF6099E9
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 07:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiJXFmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 01:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiJXFmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 01:42:15 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C26748E9;
        Sun, 23 Oct 2022 22:42:13 -0700 (PDT)
Received: from localhost.localdomain ([172.16.0.254])
        (user=dzm91@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 29O5ctoA012184-29O5ctoD012184
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Oct 2022 13:38:59 +0800
From:   Dongliang Mu <dzm91@hust.edu.cn>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?q?Sebastian=20W=C3=BCrl?= <sebastian.wuerl@ororatech.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: mcp251x: fix error handling code in mcp251x_can_probe
Date:   Mon, 24 Oct 2022 13:37:07 +0800
Message-Id: <20221024053711.696124-1-dzm91@hust.edu.cn>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: dzm91@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mcp251x_can_probe, if mcp251x_gpio_setup fails, it forgets to
unregister the can device.

Fix this by unregistering can device in mcp251x_can_probe.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/net/can/spi/mcp251x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index c320de474f40..b4b280c0699d 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1415,11 +1415,14 @@ static int mcp251x_can_probe(struct spi_device *spi)
 
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
-		goto error_probe;
+		goto err_reg_candev;
 
 	netdev_info(net, "MCP%x successfully initialized.\n", priv->model);
 	return 0;
 
+err_reg_candev:
+	unregister_candev(net);
+
 error_probe:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
-- 
2.35.1

