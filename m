Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08191522C76
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbiEKGkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbiEKGkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:40:08 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C4C42421BA;
        Tue, 10 May 2022 23:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=RtS24
        7RW6ZxcuKLxbipUrhShdpX0VWnQy9+bo9nU/z0=; b=MtRl5z1q/6cIOBNpfGv+r
        d+HK7xlcGhnOB1NZz5JT3W5KP4euDRBauSrk4vaAOpt5albmVCDnmSajEf/SC1PR
        UpmtuSWazeyp5UUjAwiycAmy9zM6Jf5hicMy5+yiIv1h3XegS83EvDW951zrgfyL
        o7xWVdkvcAJbYDBU8hwWL8=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp1 (Coremail) with SMTP id C8mowAAXj9_8WXtiubKBBw--.33626S4;
        Wed, 11 May 2022 14:38:54 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Bernard Zhao <zhaojunkui2008@126.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     bernard@vivo.com
Subject: [PATCH] usb/peak_usb: cleanup code
Date:   Tue, 10 May 2022 23:38:38 -0700
Message-Id: <20220511063850.649012-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowAAXj9_8WXtiubKBBw--.33626S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWktF4fWF1fAryrWFyxGrg_yoWktrXEkr
        W7Zr4kJF1UCrWjqF4DJw4Svry2y3WkuFs7XwnrKFs3G34YyF4UXrWxCFZ3Gw43WF1ayF9I
        kr1UJr4xAr18tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRAR6w3UUUUU==
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiuR79qlpD854fggAAsZ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable fi and bi only used in branch if (!dev->prev_siblings)
, fi & bi not kmalloc in else branch, so move kfree into branch
if (!dev->prev_siblings),this change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
index ebe087f258e3..70c5aef57247 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
@@ -903,6 +903,9 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 		     pcan_usb_pro.name,
 		     bi->hw_rev, bi->serial_num_hi, bi->serial_num_lo,
 		     pcan_usb_pro.ctrl_count);
+
+		kfree(bi);
+		kfree(fi);
 	} else {
 		usb_if = pcan_usb_pro_dev_if(dev->prev_siblings);
 	}
@@ -913,9 +916,6 @@ static int pcan_usb_pro_init(struct peak_usb_device *dev)
 	/* set LED in default state (end of init phase) */
 	pcan_usb_pro_set_led(dev, PCAN_USBPRO_LED_DEVICE, 1);
 
-	kfree(bi);
-	kfree(fi);
-
 	return 0;
 
  err_out:
-- 
2.33.1

