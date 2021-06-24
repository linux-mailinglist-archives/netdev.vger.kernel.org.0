Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533243B278D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhFXGob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhFXGo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:44:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746FBC061767
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:42:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lwJ3u-0008QU-QQ
        for netdev@vger.kernel.org; Thu, 24 Jun 2021 08:42:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 71D816427B9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 06:42:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2AB6F6427A5;
        Thu, 24 Jun 2021 06:42:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9b59a8a6;
        Thu, 24 Jun 2021 06:42:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/2] can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path
Date:   Thu, 24 Jun 2021 08:42:00 +0200
Message-Id: <20210624064200.2998085-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624064200.2998085-1-mkl@pengutronix.de>
References: <20210624064200.2998085-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephane Grosjean <s.grosjean@peak-system.com>

Rather than just indicating that transmission can start, this patch
requires the explicit flushing of the network TX queue when the driver
is informed by the device that it can transmit, next to its
configuration.

In this way, if frames have already been written by the application,
they will actually be transmitted.

Fixes: ffd137f7043c ("can: peak/pcie_fd: remove useless code when interface starts")
Link: https://lore.kernel.org/r/20210623142600.149904-1-s.grosjean@peak-system.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/peak_canfd/peak_canfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
index 00847cbaf7b6..d08718e98e11 100644
--- a/drivers/net/can/peak_canfd/peak_canfd.c
+++ b/drivers/net/can/peak_canfd/peak_canfd.c
@@ -351,8 +351,8 @@ static int pucan_handle_status(struct peak_canfd_priv *priv,
 				return err;
 		}
 
-		/* start network queue (echo_skb array is empty) */
-		netif_start_queue(ndev);
+		/* wake network queue up (echo_skb array is empty) */
+		netif_wake_queue(ndev);
 
 		return 0;
 	}
-- 
2.30.2


