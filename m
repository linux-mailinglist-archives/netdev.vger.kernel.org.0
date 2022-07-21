Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C657157C1A1
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiGUA2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiGUA2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F8362A4C;
        Wed, 20 Jul 2022 17:28:31 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id w7so294491ply.12;
        Wed, 20 Jul 2022 17:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oYqwhUvuzOKnMbHAPG9U5QnaJ2YWw3cAfEUA2j4IMXU=;
        b=QKoH+8Q6OhWT+Tc75DidMLHVOSVR8+BVWbfRGuVGxGEQ5I15+ifRAgExh0v8b+ucRx
         qikNa45KYWXZCvq/FPrMeZSAltEXWoVxZ/cXgfSOO6SJmY5X3due06l9FOPD2BZq2cZ+
         6MhrR8x/1FJMPRIKj4MZYZ4xnDddLgKdHx/EIl0wJK8Y0JahRa6leXTImVlhWIiHa2EX
         Vytll/bZQDvLhUUNB050D0IlJhYXVDkmFnyBMNfcux7+UnkhrWRggGJXF14jLnxf/OEC
         4tMkSvhqManVS3lLwfhIcknh75Fb38leJZw8r7N078FcOGi0EBSKG/3GfS3pN1cUqwx0
         DKJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oYqwhUvuzOKnMbHAPG9U5QnaJ2YWw3cAfEUA2j4IMXU=;
        b=IzvrhnwalR32pFP0mTDQCLOae2IPyvXLxXUSxcfAkfc+AE3sADpQaybUfb4RVbrfS8
         VzxdyQ3uj3KN5Su6USrGNF1Nh97x0ddGtrdhsPvGVsSv3Jrmql1AWn9lD9j0rOMoil9w
         RdB13i7v37ImvXtpco/LIj2tpUKLJWeZuB+ZGGFO4uhgzmNoJTHjPDX4BAnfs0Zi22UA
         kanjLk0VRkMpurv0rw6bCjvbLLi3Vz5TWY7RprjJViVXkbQhJSEY/1ZIF+vTcDlH+0cv
         5/TaTxlRULcxChJ2L1KgYQSXZ2zyFAdQGtKNhf58/yCV/BeEpnSjA7mqyr26/pj3M5/j
         Ce6Q==
X-Gm-Message-State: AJIora/vKEr50/VaU2Rll0UNRnskDmaOLMDOJvPbvDNjW8ay0DrWa5Eo
        mOIU/3dMicf4nJmSc0UsTqM=
X-Google-Smtp-Source: AGRyM1uDkhKrq02BurmxhTD3i5UOSOUwa4q36ylI1ri0aBH14wKU8Dh+8mgEq+mzZ653I5hdO4tunQ==
X-Received: by 2002:a17:90b:4a47:b0:1f0:3f92:8c80 with SMTP id lb7-20020a17090b4a4700b001f03f928c80mr8188906pjb.199.1658363311120;
        Wed, 20 Jul 2022 17:28:31 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:30 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 3/5] net: usb: ax88179_178a: restore state on resume
Date:   Wed, 20 Jul 2022 17:28:14 -0700
Message-Id: <1658363296-15734-4-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
References: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

The hardware state was only partially restored, which meant certain
functionality was broken on resume. Do a full HW reset on resume to
fix this.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index c641fd4..1cc388a 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -465,37 +465,12 @@ static int ax88179_auto_detach(struct usbnet *dev)
 static int ax88179_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	u16 tmp16;
-	u8 tmp8;
 
 	ax88179_set_pm_mode(dev, true);
 
 	usbnet_link_change(dev, 0, 0);
 
-	/* Power up ethernet PHY */
-	tmp16 = 0;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			  2, 2, &tmp16);
-	udelay(1000);
-
-	tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			  2, 2, &tmp16);
-	msleep(200);
-
-	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev);
-
-	/* Enable clock */
-	ax88179_read_cmd(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
-	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
-	msleep(100);
-
-	/* Configure RX control register => start operation */
-	tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
-		AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_reset(dev);
 
 	ax88179_set_pm_mode(dev, false);
 
-- 
2.7.4

