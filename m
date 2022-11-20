Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189C063134A
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 11:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiKTKPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 05:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKTKPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 05:15:13 -0500
Received: from mail-m972.mail.163.com (mail-m972.mail.163.com [123.126.97.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DCD41D336;
        Sun, 20 Nov 2022 02:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AlZgy
        GzJSksbiSVnwu7EnHZCXOjLRMJSW611pKd6AVw=; b=Kwm7NayBh3mQjmPLXeDOy
        miId3jIeCSmEC078Ebg7vopeSk7l6D5eOHQX4eVjz11QAkECDbZNVsJjHg2XugCV
        9bHRjNr2TvUzfuZPGH5Gv2aFI3r2glHy7HPK8nptadliwquPnbcA2S1t5CxpCopg
        Zcn0ItMaYuslY5nLPeZk0U=
Received: from localhost.localdomain (unknown [36.112.3.106])
        by smtp2 (Coremail) with SMTP id GtxpCgCnIgz4_XljPtHttg--.23124S4;
        Sun, 20 Nov 2022 18:14:24 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     yashi@spacecubics.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mailhol.vincent@wanadoo.fr,
        stefan.maetje@esd.eu, socketcan@hartkopp.net, hbh25y@gmail.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] can: mcba_usb: fix potential resource leak in mcba_usb_xmit_cmd()
Date:   Sun, 20 Nov 2022 18:14:14 +0800
Message-Id: <20221120101414.6071-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GtxpCgCnIgz4_XljPtHttg--.23124S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFy7ZF13Jr1DWFy3ur1fXrb_yoWDCFX_K3
        y7Gry8WayUJrn09w18K3yxJ34FywsrZr4kuFs3t343JFW2ya18JFnFgr9rGr1ruw4aqa9x
        CwnrZF1DJw4SvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRisXo5UUUUU==
X-Originating-IP: [36.112.3.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbiWwC-jGI0XGfXSAAAsa
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mcba_usb_xmit_cmd() gets free ctx by mcba_usb_get_free_ctx(). When
mcba_usb_xmit() fails, the ctx should be freed with mcba_usb_free_ctx()
like mcba_usb_start_xmit() does in label "xmit_failed" to avoid potential
resource leak.

Fix it by calling mcba_usb_free_ctx() when mcba_usb_xmit() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/can/usb/mcba_usb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 218b098b261d..471f6be6e030 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -380,9 +380,11 @@ static void mcba_usb_xmit_cmd(struct mcba_priv *priv,
 	}
 
 	err = mcba_usb_xmit(priv, usb_msg, ctx);
-	if (err)
+	if (err) {
+		mcba_usb_free_ctx(ctx);
 		netdev_err(priv->netdev, "Failed to send cmd (%d)",
 			   usb_msg->cmd_id);
+	}
 }
 
 static void mcba_usb_xmit_change_bitrate(struct mcba_priv *priv, u16 bitrate)
-- 
2.25.1

