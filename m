Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD503DB435
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 09:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237623AbhG3HFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 03:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237775AbhG3HFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 03:05:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AE3C0613C1
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 00:05:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m9MaO-00065T-8i
        for netdev@vger.kernel.org; Fri, 30 Jul 2021 09:05:36 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6C48765B7BC
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 07:05:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 01B3365B792;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 57122f2c;
        Fri, 30 Jul 2021 07:05:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/6] can: hi311x: fix a signedness bug in hi3110_cmd()
Date:   Fri, 30 Jul 2021 09:05:22 +0200
Message-Id: <20210730070526.1699867-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730070526.1699867-1-mkl@pengutronix.de>
References: <20210730070526.1699867-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The hi3110_cmd() is supposed to return zero on success and negative
error codes on failure, but it was accidentally declared as a u8 when
it needs to be an int type.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Link: https://lore.kernel.org/r/20210729141246.GA1267@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/spi/hi311x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index dd17b8c53e1c..89d9c986a229 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -218,7 +218,7 @@ static int hi3110_spi_trans(struct spi_device *spi, int len)
 	return ret;
 }
 
-static u8 hi3110_cmd(struct spi_device *spi, u8 command)
+static int hi3110_cmd(struct spi_device *spi, u8 command)
 {
 	struct hi3110_priv *priv = spi_get_drvdata(spi);
 
-- 
2.30.2


