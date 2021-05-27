Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECB8E3929F9
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhE0Iu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbhE0It7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:49:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FC9C061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 01:48:24 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lmBgk-0002Ce-QT
        for netdev@vger.kernel.org; Thu, 27 May 2021 10:48:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AE86862D48B
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 08:45:43 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9F07D62D3EB;
        Thu, 27 May 2021 08:45:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a9907832;
        Thu, 27 May 2021 08:45:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 09/21] can: softing: Remove redundant variable ptr
Date:   Thu, 27 May 2021 10:45:20 +0200
Message-Id: <20210527084532.1384031-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527084532.1384031-1-mkl@pengutronix.de>
References: <20210527084532.1384031-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

The value stored to ptr in the calculations this patch removes is not
used, so the calculation and the assignment can be removed.

Cleans up the following clang-analyzer warning:

drivers/net/can/softing/softing_main.c:279:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

drivers/net/can/softing/softing_main.c:242:3: warning: Value stored to
'ptr' is never read [clang-analyzer-deadcode.DeadStores].

Link: https://lore.kernel.org/r/1619520767-80948-1-git-send-email-jiapeng.chong@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/softing/softing_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/softing/softing_main.c b/drivers/net/can/softing/softing_main.c
index c44f3411e561..cfc1325aad10 100644
--- a/drivers/net/can/softing/softing_main.c
+++ b/drivers/net/can/softing/softing_main.c
@@ -239,7 +239,6 @@ static int softing_handle_1(struct softing *card)
 				DPRAM_INFO_BUSSTATE2 : DPRAM_INFO_BUSSTATE]);
 		/* timestamp */
 		tmp_u32 = le32_to_cpup((void *)ptr);
-		ptr += 4;
 		ktime = softing_raw2ktime(card, tmp_u32);
 
 		++netdev->stats.rx_errors;
@@ -276,7 +275,6 @@ static int softing_handle_1(struct softing *card)
 		ktime = softing_raw2ktime(card, tmp_u32);
 		if (!(msg.can_id & CAN_RTR_FLAG))
 			memcpy(&msg.data[0], ptr, 8);
-		ptr += 8;
 		/* update socket */
 		if (cmd & CMD_ACK) {
 			/* acknowledge, was tx msg */
-- 
2.30.2


