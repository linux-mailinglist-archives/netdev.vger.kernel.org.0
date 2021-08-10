Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D692B3E539D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhHJGhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbhHJGhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 02:37:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7FCC061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 23:37:10 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mDLNs-0005xB-68
        for netdev@vger.kernel.org; Tue, 10 Aug 2021 08:37:08 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 03E87663C96
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:37:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A9ECD663C88;
        Tue, 10 Aug 2021 06:37:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 9b78e67d;
        Tue, 10 Aug 2021 06:37:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Hussein Alasadi <alasadi@arecs.eu>,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] can: m_can: m_can_set_bittiming(): fix setting M_CAN_DBTP register
Date:   Tue, 10 Aug 2021 08:37:02 +0200
Message-Id: <20210810063702.350109-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810063702.350109-1-mkl@pengutronix.de>
References: <20210810063702.350109-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hussein Alasadi <alasadi@arecs.eu>

This patch fixes the setting of the M_CAN_DBTP register contents:
- use DBTP_ (the data bitrate macros) instead of NBTP_ which area used
  for the nominal bitrate
- do not overwrite possibly-existing DBTP_TDC flag by ORing reg_btp
  instead of overwriting

Link: https://lore.kernel.org/r/FRYP281MB06140984ABD9994C0AAF7433D1F69@FRYP281MB0614.DEUP281.PROD.OUTLOOK.COM
Fixes: 20779943a080 ("can: m_can: use bits.h macros for all regmasks")
Cc: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Cc: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Signed-off-by: Hussein Alasadi <alasadi@arecs.eu>
[mkl: update patch description, update indention]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index bba2a449ac70..43bca315a66c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1164,10 +1164,10 @@ static int m_can_set_bittiming(struct net_device *dev)
 				    FIELD_PREP(TDCR_TDCO_MASK, tdco));
 		}
 
-		reg_btp = FIELD_PREP(NBTP_NBRP_MASK, brp) |
-			  FIELD_PREP(NBTP_NSJW_MASK, sjw) |
-			  FIELD_PREP(NBTP_NTSEG1_MASK, tseg1) |
-			  FIELD_PREP(NBTP_NTSEG2_MASK, tseg2);
+		reg_btp |= FIELD_PREP(DBTP_DBRP_MASK, brp) |
+			FIELD_PREP(DBTP_DSJW_MASK, sjw) |
+			FIELD_PREP(DBTP_DTSEG1_MASK, tseg1) |
+			FIELD_PREP(DBTP_DTSEG2_MASK, tseg2);
 
 		m_can_write(cdev, M_CAN_DBTP, reg_btp);
 	}
-- 
2.30.2


