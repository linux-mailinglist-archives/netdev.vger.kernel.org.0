Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF864ED623
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiCaIsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbiCaIse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:48:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635C71F9759
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:46:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZqS1-0000Fv-Mt
        for netdev@vger.kernel.org; Thu, 31 Mar 2022 10:46:41 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E29A057A0F
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 901A4579EB;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 14faa9bc;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com
Subject: [PATCH net 8/8] can: gs_usb: gs_make_candev(): fix memory leak for devices with extended bit timing configuration
Date:   Thu, 31 Mar 2022 10:46:34 +0200
Message-Id: <20220331084634.869744-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some CAN-FD capable devices offer extended bit timing information for
the data bit timing. The information must be read with an USB control
message. The memory for this message is allocated but not free()ed (in
the non error case). This patch adds the missing free.

Fixes: 6679f4c5e5a6 ("can: gs_usb: add extended bt_const feature")
Link: https://lore.kernel.org/all/20220329193450.659726-1-mkl@pengutronix.de
Reported-by: syzbot+4d0ae90a195b269f102d@syzkaller.appspotmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 67408e316062..b29ba9138866 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -1092,6 +1092,8 @@ static struct gs_can *gs_make_candev(unsigned int channel,
 		dev->data_bt_const.brp_inc = le32_to_cpu(bt_const_extended->dbrp_inc);
 
 		dev->can.data_bittiming_const = &dev->data_bt_const;
+
+		kfree(bt_const_extended);
 	}
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
-- 
2.35.1


