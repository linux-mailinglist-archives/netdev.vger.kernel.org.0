Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EDA5F12FC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 21:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiI3Ttp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiI3Ttn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 15:49:43 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15CE10D5;
        Fri, 30 Sep 2022 12:49:38 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 10so1217448pli.0;
        Fri, 30 Sep 2022 12:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=FFv7BOpg0iK4hsJ/tgms8GW0ZAT2HoR9bwowWyDE/R4=;
        b=FFlFxH4okt0UjL+2P+qJVtGSA1DooFxcgzLgo90BxIvIetu6Y/ixRB98HyRHP0dp+9
         N/He5xaXp6UmnOQyspwZLuvPYSVXs2HxeFCT1lxykkqyF/BrEPkzpnr2V9HGUBnFIegf
         WaHck0aRv9qRfb+i/H6b/YCiwAatm1Qdwcz3qMkUUwz2JqYGGShPKQfZMNC670DSRNI8
         YvJjGr7lBWTDMCUs0X3xxvU8ubRjpzZ85mZWWFvqzRwTsMnungEj4YKwRr8/bPPxLYit
         1SgacgTbHxbLuJdou/bE9ehqSremnCvp+dWFrHmFI1ULCHbAl1L5Q5vB/IK84orKgNNM
         MGwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=FFv7BOpg0iK4hsJ/tgms8GW0ZAT2HoR9bwowWyDE/R4=;
        b=GTwOMWXXZOuiH3DYQHFEwmuYy71r3ROFGPk9LDF1d70xZeO4+gpx3e2XkXE0+rzth9
         v5NSAQsBXSoMQYscYESrlp3DO6JkpxphkmQ6P4hnWFzQ1EytSSG+Rn0hQvS+mXPc0XuC
         Y1rMuRhUkSQLzM4intQ38SGBLp/3Aw5phHqcuh1POFGreOcOVhUqGW1eDBn8cc2QI7bR
         OKeO4gCiigfhE2AzBlxscAEZIRMcLqGfC+atCGy2vMrH+4MNtZmmx2DzF/Rqu1hnc+nB
         v4I5Vh2VNCSiru622gkWN5WhuHX83Imj2iJoMfanTMCeteus49Yt1ALdK932Vc9QWpbo
         vkcw==
X-Gm-Message-State: ACrzQf3sUY7iaKlHSbHWnWZjU2hkJES/4xmz3gbGQPUL18dRN1maU+bX
        X6Rgxag14j98q+WtrVI92MWslOdvSbv/0d+qXIZyzA==
X-Google-Smtp-Source: AMsMyM7j6hpjHzQ4a3VVxw0fugl5ihuAZ8wo5744P4fSrtQc0J6rJ8SECfisb3WXTweN8DqnSjColA==
X-Received: by 2002:a17:90b:4b03:b0:202:eab3:e174 with SMTP id lx3-20020a17090b4b0300b00202eab3e174mr23317489pjb.12.1664567377808;
        Fri, 30 Sep 2022 12:49:37 -0700 (PDT)
Received: from y.dmz.cipunited.com ([104.28.245.203])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f70d00b00176cdd80148sm2211494plo.305.2022.09.30.12.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:49:37 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
To:     mmyangfl@gmail.com
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mv643xx_eth: support MII/GMII/RGMII modes
Date:   Sat,  1 Oct 2022 03:49:23 +0800
Message-Id: <20220930194923.954551-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On device reset all ports are automatically set to RGMII mode. MII
mode must be explicitly enabled.

If SoC has two Ethernet controllers, by setting both of them into MII
mode, the first controller enters GMII mode, while the second
controller is effectively disabled. This requires configuring (and
maybe enabling) the second controller in the device tree, even though
it cannot be used.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b6be0552a..e2216ce5e 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -108,6 +108,7 @@ static char mv643xx_eth_driver_version[] = "1.4";
 #define TXQ_COMMAND			0x0048
 #define TXQ_FIX_PRIO_CONF		0x004c
 #define PORT_SERIAL_CONTROL1		0x004c
+#define  RGMII_EN			0x00000008
 #define  CLK125_BYPASS_EN		0x00000010
 #define TX_BW_RATE			0x0050
 #define TX_BW_MTU			0x0058
@@ -1245,6 +1246,21 @@ static void mv643xx_eth_adjust_link(struct net_device *dev)
 
 out_write:
 	wrlp(mp, PORT_SERIAL_CONTROL, pscr);
+
+	/* If two Ethernet controllers present in the SoC, MII modes follow the
+	 * following matrix:
+	 *
+	 * Port0 Mode	Port1 Mode	Port0 RGMII_EN	Port1 RGMII_EN
+	 * RGMII	RGMII		1		1
+	 * RGMII	MII/MMII	1		0
+	 * MII/MMII	RGMII		0		1
+	 * GMII		N/A		0		0
+	 *
+	 * To enable GMII on Port 0, Port 1 must also disable RGMII_EN too.
+	 */
+	if (!phy_interface_is_rgmii(dev->phydev))
+		wrlp(mp, PORT_SERIAL_CONTROL1,
+		     rdlp(mp, PORT_SERIAL_CONTROL1) & ~RGMII_EN);
 }
 
 /* statistics ***************************************************************/
-- 
2.35.1

