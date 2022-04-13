Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7F4FEBD8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiDMAOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiDMAOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:14:43 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D9023157;
        Tue, 12 Apr 2022 17:12:24 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id c15so291328ljr.9;
        Tue, 12 Apr 2022 17:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8nBiXf+DqAHduPvS/hZ0dn5wt8Ro59nVlIHK+Vhdc5k=;
        b=a201yrJaXTcomsccXmr0UKd66u8v8gBKyVobnEphmTEXNkNtb4tH7EK8hJGo6kjw1t
         wJOAK39ScUc/cw0SznPgwfbOGR1cRychpUxC1azekQQtoWiII4jV4kKdt+K3w6+wEMX+
         DoqI4bjl3PBm+ml/YlJe1pcvUlI5AZDFq/4HTVrlvAoQReNZlg3VRNUDOj2I7o5CqTWI
         e4uLu1anc33oIg0AwXen3FjVGobt+GKp/nr/BVnKYTLAyOXlZgsO8+nRufDVwx6jQGBj
         W2Ua3AdSuNx7LWd79peC89a2wGDUm2lcUHYYW6hAuYS3MyQMsIo3hYqL9V9wYtFRab9U
         FnBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8nBiXf+DqAHduPvS/hZ0dn5wt8Ro59nVlIHK+Vhdc5k=;
        b=V4prLDwANhpd/hbWF5F0cikUIDljdQvC3qea3y2v5yTTmkPvIvgWRBUmbiEJl6gbXx
         VnJ0wA8Vw6NJgSAIB858o/iiTFxYINMJVgd9NC9CpvyOJCDck9+Bshffj5cjaJo0NXHS
         4xTmvziogXdJ4re79dGvOHdc5Qe/oEG/qRWWGzOm0r8sjwDPxsPttcuAYZD0/27woJt+
         RdAW95FJio4z29O4NApJwhuJH3XJgl/n+wkSiMFmuGJOfRMo0H8BnWhv5IFiIyzHGXqU
         B8NVMfy6MKffwjWsW59+TQtzyIbbGM+xEioOmFz1TPN0uqxWHcOWT8hFK3fa9dz0+7Fp
         H8mw==
X-Gm-Message-State: AOAM530/xWFuxnV/6ybe4axCdCVosf4ZnTyAr5ccJZ5nnmNsKFL662Me
        GTd8TJMG2ez6/Y5vWWXFRRI23H+vIBBFag==
X-Google-Smtp-Source: ABdhPJxg6rkgSwRSE+mkDpxStXDQSRUttkodtSBl1JRGEeVLR4p7sb9o7aIbXmDh25M1aJX4g9Pjtg==
X-Received: by 2002:a2e:8007:0:b0:24a:c2d6:50c7 with SMTP id j7-20020a2e8007000000b0024ac2d650c7mr24850624ljg.94.1649808742499;
        Tue, 12 Apr 2022 17:12:22 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id d6-20020a2e96c6000000b0024b4cd1b611sm1611731ljj.91.2022.04.12.17.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:12:21 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v2 3/3] rndis_host: limit scope of bogus MAC address detection to ZTE devices
Date:   Wed, 13 Apr 2022 02:11:58 +0200
Message-Id: <20220413001158.1202194-4-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220413001158.1202194-1-lech.perczak@gmail.com>
References: <20220413001158.1202194-1-lech.perczak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reporting of bogus MAC addresses and ignoring configuration of new
destination address wasn't observed outside of a range of ZTE devices,
among which this seems to be the common bug. Align rndis_host driver
with implementation found in cdc_ether, which also limits this workaround
to ZTE devices.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---

v2:
- No logical changes, just rebased on top of previous patches.

 drivers/net/usb/rndis_host.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 18b27a4ed8bd..c5e0a5f659b1 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -418,10 +418,7 @@ generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf, int flags)
 		goto halt_fail_and_release;
 	}
 
-	if (bp[0] & 0x02)
-		eth_hw_addr_random(net);
-	else
-		eth_hw_addr_set(net, bp);
+	eth_hw_addr_set(net, bp);
 
 	/* set a nonzero filter to enable data transfers */
 	memset(u.set, 0, sizeof *u.set);
@@ -463,6 +460,16 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
 	return generic_rndis_bind(dev, intf, FLAG_RNDIS_PHYM_NOT_WIRELESS);
 }
 
+static int zte_rndis_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int status = rndis_bind(dev, intf);
+
+	if (!status && (dev->net->dev_addr[0] & 0x02))
+		eth_hw_addr_random(dev->net);
+
+	return status;
+}
+
 void rndis_unbind(struct usbnet *dev, struct usb_interface *intf)
 {
 	struct rndis_halt	*halt;
@@ -614,7 +621,7 @@ static const struct driver_info	zte_rndis_info = {
 	.description =	"ZTE RNDIS device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
 	.data =		RNDIS_DRIVER_DATA_DST_MAC_FIXUP,
-	.bind =		rndis_bind,
+	.bind =		zte_rndis_bind,
 	.unbind =	rndis_unbind,
 	.status =	rndis_status,
 	.rx_fixup =	rndis_rx_fixup,
-- 
2.30.2

