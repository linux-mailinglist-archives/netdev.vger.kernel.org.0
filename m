Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B0156561D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiGDMxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiGDMwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D636F1209D
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:36 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LYx-000162-VG
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:28 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7BB7BA79AC
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D5A25A7930;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 40ed0f92;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Liang He <windhl@126.com>,
        stable@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 05/15] can: grcan: grcan_probe(): remove extra of_node_get()
Date:   Mon,  4 Jul 2022 14:26:03 +0200
Message-Id: <20220704122613.1551119-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220704122613.1551119-1-mkl@pengutronix.de>
References: <20220704122613.1551119-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liang He <windhl@126.com>

In grcan_probe(), of_find_node_by_path() has already increased the
refcount. There is no need to call of_node_get() again, so remove it.

Link: https://lore.kernel.org/all/20220619070257.4067022-1-windhl@126.com
Fixes: 1e93ed26acf0 ("can: grcan: grcan_probe(): fix broken system id check for errata workaround needs")
Cc: stable@vger.kernel.org # v5.18
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/grcan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 76df4807d366..4c47c1055eff 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -1646,7 +1646,6 @@ static int grcan_probe(struct platform_device *ofdev)
 	 */
 	sysid_parent = of_find_node_by_path("/ambapp0");
 	if (sysid_parent) {
-		of_node_get(sysid_parent);
 		err = of_property_read_u32(sysid_parent, "systemid", &sysid);
 		if (!err && ((sysid & GRLIB_VERSION_MASK) >=
 			     GRCAN_TXBUG_SAFE_GRLIB_VERSION))
-- 
2.35.1


