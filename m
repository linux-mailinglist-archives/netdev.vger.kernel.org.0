Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415E8433FF2
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJSUvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 16:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJSUvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 16:51:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43DAC06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 13:49:24 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mcw31-0002kz-26; Tue, 19 Oct 2021 22:49:23 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mcw30-00044X-AO; Tue, 19 Oct 2021 22:49:22 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mcw30-0007YD-9c; Tue, 19 Oct 2021 22:49:22 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] nfc: st95hf: Make spi remove() callback return zero
Date:   Tue, 19 Oct 2021 22:49:16 +0200
Message-Id: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=kZ0CTEiz6LeB2V7myH/sjADyu3CifKW892VlRLobIFo=; m=X7YhcwI3QddZrN65kXhtB7oBQjLqkuDadkhSpOqDFDo=; p=bbGEDmgMONg2UqeLnOL3oxRsOUWfHmCoO07FJid88fM=; g=ce2863d9abbe684d6aaa60baa40742a248ba4501
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFvL0kACgkQwfwUeK3K7AkxRAgAnaa 9XIoVV/HOLOTYxepiZMZQ5Bh/4ipCaoKG7cN10XedO9+ZUnB1YZGwR5382enUs4xCaQsT91zNWfJm 4l3YAJrl0fq8gora62l8ClPrzsZpWoIJhjvvbyExszR5MI45kweYEEIXLXMGuvQnV/z00UJWXEEO/ vWNnU+0Bjs8n36ZGCWxiS4sekmJ6m02Dyse0+FBM36HRdCnvQ13Iiq8g9r4MClpKnY48/Un0KUaIF lJaG3L/oJ3dCguDBghh/26iItD1ilpwxaT2C2fvGRAPgrrYGyBziCe1WsTpJgbw7w43pT6erQcQUr ReowaS8IE4td4rrHZFF1I96+QBTdZOw==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If something goes wrong in the remove callback, returning an error code
just results in an error message. The device still disappears.

So don't skip disabling the regulator in st95hf_remove() if resetting
the controller via spi fails. Also don't return an error code which just
results in two error messages.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/nfc/st95hf/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index d16cf3ff644e..b23f47936473 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -1226,11 +1226,9 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 				 &reset_cmd,
 				 ST95HF_RESET_CMD_LEN,
 				 ASYNC);
-	if (result) {
+	if (result)
 		dev_err(&spictx->spidev->dev,
 			"ST95HF reset failed in remove() err = %d\n", result);
-		return result;
-	}
 
 	/* wait for 3 ms to complete the controller reset process */
 	usleep_range(3000, 4000);
@@ -1239,7 +1237,7 @@ static int st95hf_remove(struct spi_device *nfc_spi_dev)
 	if (stcontext->st95hf_supply)
 		regulator_disable(stcontext->st95hf_supply);
 
-	return result;
+	return 0;
 }
 
 /* Register as SPI protocol driver */
-- 
2.30.2

