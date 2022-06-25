Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1FA55A9DA
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 14:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiFYMG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 08:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiFYMGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 08:06:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C6E140BD
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:06:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o54YJ-0002Tv-QQ
        for netdev@vger.kernel.org; Sat, 25 Jun 2022 14:06:15 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3855C9F248
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 12:05:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 885ED9F20F;
        Sat, 25 Jun 2022 12:04:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9919699e;
        Sat, 25 Jun 2022 12:03:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Max Staudt <max@enpas.org>
Subject: [PATCH net-next 17/22] can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback
Date:   Sat, 25 Jun 2022 14:03:30 +0200
Message-Id: <20220625120335.324697-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220625120335.324697-1-mkl@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
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

This patch is similar to 7e193a42c37c ("can: netlink: allow
configuring of fixed bit rates without need for do_set_bittiming
callback") but for data bit rates instead of bit rates.

Usually CAN devices support configurable data bit rates. The limits
are defined by struct can_priv::data_bittiming_const. Another way is
to implement the struct can_priv::do_set_data_bittiming callback.

If the bit rate is configured via netlink, the can_changelink()
function checks that either can_priv::data_bittiming_const or struct
can_priv::do_set_data_bittiming is implemented.

In commit 431af779256c ("can: dev: add CAN interface API for fixed
bitrates") an API for configuring bit rates on CAN interfaces that
only support fixed bit rates was added. The supported bit rates are
defined by struct can_priv::bitrate_const.

However the above mentioned commit forgot to add the struct
can_priv::data_bitrate_const to the check in can_changelink().

In order to avoid to implement a no-op can_priv::do_set_data_bittiming
callback on devices with fixed data bit rates, extend the check in
can_changelink() accordingly.

Link: https://lore.kernel.org/all/20220613143633.4151884-1-mkl@pengutronix.de
Fixes: 431af779256c ("can: dev: add CAN interface API for fixed bitrates")
Acked-by: Max Staudt <max@enpas.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 667ddd28fcdc..037824011266 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -279,7 +279,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		 * directly via do_set_bitrate(). Bail out if neither
 		 * is given.
 		 */
-		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming)
+		if (!priv->data_bittiming_const && !priv->do_set_data_bittiming &&
+		    !priv->data_bitrate_const)
 			return -EOPNOTSUPP;
 
 		memcpy(&dbt, nla_data(data[IFLA_CAN_DATA_BITTIMING]),
-- 
2.35.1


