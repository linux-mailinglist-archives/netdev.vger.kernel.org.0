Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836E568F95E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjBHVBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjBHVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:01:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186324C6CE
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:00:42 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPrYA-00007d-Cu
        for netdev@vger.kernel.org; Wed, 08 Feb 2023 22:00:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C5D46173CE6
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:00:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 273C6173CD3;
        Wed,  8 Feb 2023 21:00:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ce03e731;
        Wed, 8 Feb 2023 21:00:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 2/2] can: bittiming: can_calc_bittiming(): add missing parameter to no-op function
Date:   Wed,  8 Feb 2023 22:00:14 +0100
Message-Id: <20230208210014.3169347-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208210014.3169347-1-mkl@pengutronix.de>
References: <20230208210014.3169347-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 286c0e09e8e0 ("can: bittiming: can_changelink() pass extack
down callstack") a new parameter was added to can_calc_bittiming(),
however the static inline no-op (which is used if
CONFIG_CAN_CALC_BITTIMING is disabled) wasn't converted.

Add the new parameter to the static inline no-op of
can_calc_bittiming().

Fixes: 286c0e09e8e0 ("can: bittiming: can_changelink() pass extack down callstack")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/20230207201734.2905618-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/linux/can/bittiming.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 6cb2ae308e3f..9b8a9c39614b 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -124,7 +124,7 @@ void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
 can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
-		   const struct can_bittiming_const *btc)
+		   const struct can_bittiming_const *btc, struct netlink_ext_ack *extack)
 {
 	netdev_err(dev, "bit-timing calculation not available\n");
 	return -EINVAL;
-- 
2.39.1


