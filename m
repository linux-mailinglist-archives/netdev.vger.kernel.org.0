Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBF634E68B
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhC3Lq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhC3LqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56E2C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCp1-0005fJ-AU
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2EDB5603DFB
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8A0A0603DC7;
        Tue, 30 Mar 2021 11:46:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f33c78dd;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 04/39] can: dev: can_free_echo_skb(): don't crash the kernel if can_priv::echo_skb is accessed out of bounds
Date:   Tue, 30 Mar 2021 13:45:24 +0200
Message-Id: <20210330114559.1114855-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A out of bounds access to "struct can_priv::echo_skb" leads to a
kernel crash. Better print a sensible warning message instead and try
to recover.

This patch is similar to:

| e7a6994d043a ("can: dev: __can_get_echo_skb(): Don't crash the kernel
|               if can_priv::echo_skb is accessed out of bounds")

Link: https://lore.kernel.org/r/20210319142700.305648-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 22b0472a5fad..2256391ddbb3 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -157,7 +157,11 @@ void can_free_echo_skb(struct net_device *dev, unsigned int idx)
 {
 	struct can_priv *priv = netdev_priv(dev);
 
-	BUG_ON(idx >= priv->echo_skb_max);
+	if (idx >= priv->echo_skb_max) {
+		netdev_err(dev, "%s: BUG! Trying to access can_priv::echo_skb out of bounds (%u/max %u)\n",
+			   __func__, idx, priv->echo_skb_max);
+		return;
+	}
 
 	if (priv->echo_skb[idx]) {
 		dev_kfree_skb_any(priv->echo_skb[idx]);
-- 
2.30.2


