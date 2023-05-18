Return-Path: <netdev+bounces-3517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B508707AA3
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB61528176F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F302A9CA;
	Thu, 18 May 2023 07:10:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6837A17F7
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:10:52 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB3E10D8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 00:10:46 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id zXmapJCyDEQ0YzXmbpoAuZ; Thu, 18 May 2023 09:10:44 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1684393844;
	bh=F+zInelYRTBn1Bc3nl++TZglWSkvYGCgphkwfxYXGUI=;
	h=From:To:Cc:Subject:Date;
	b=jj5h5i+UBg8mXjxtMytCz3rOb/3ZuplCgQI7Qtmube/kc/QQnYDVSVNeRw4htK//5
	 JtCtXmMUqbJq96EQ2dpuiOHjg3Is7ZG3zDKWOUrK+ko4kGTcuDsrPINQ6qhP5Q0q70
	 yCn5VgPnQDvFvZ/NgNCMuopUozdGtPGJWiSWC+634Ft55qDtM1WNMC+fpjx/BEnGQ/
	 GTzk4kULOfnMzjSEIk14pCoEN08qbs9IO0TWBuIvrauEetjnYGh36xT/pXmczco7lV
	 6obaf4B7UzFX1Vln9AD8XW0fvSx3pgLG21OZTLdYyeIWjG0M4m4dIHHhdVnU2JUzOb
	 AkY+DDx1mDgkA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 18 May 2023 09:10:44 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Ondrej Ille <ondrej.ille@gmail.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-can@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH] can: ctucanfd: Remove a useless netif_napi_del() call
Date: Thu, 18 May 2023 09:10:39 +0200
Message-Id: <58500052a6740806e8af199ece45e97cb5eeb1b8.1684393811.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

free_candev() already calls netif_napi_del(), so there is no need to call
it explicitly. It is harmless, but useless.

This makes the code mode consistent with the error handling path of
ctucan_probe_common().

While at it, remove a wrong comment about the return value of this
function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
The comment went wrong after 45413bf75919 ("can: ctucanfd: Convert to platform remove callback returning void")
---
 drivers/net/can/ctucanfd/ctucanfd_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_platform.c b/drivers/net/can/ctucanfd/ctucanfd_platform.c
index 55bb10b157b4..8fe224b8dac0 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_platform.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
@@ -84,7 +84,6 @@ static int ctucan_platform_probe(struct platform_device *pdev)
  * @pdev:	Handle to the platform device structure
  *
  * This function frees all the resources allocated to the device.
- * Return: 0 always
  */
 static void ctucan_platform_remove(struct platform_device *pdev)
 {
@@ -95,7 +94,6 @@ static void ctucan_platform_remove(struct platform_device *pdev)
 
 	unregister_candev(ndev);
 	pm_runtime_disable(&pdev->dev);
-	netif_napi_del(&priv->napi);
 	free_candev(ndev);
 }
 
-- 
2.34.1


