Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14C34F6F13
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 02:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiDGAWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 20:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiDGAWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 20:22:44 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C3910FADE;
        Wed,  6 Apr 2022 17:20:46 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id b17so6926751lfv.3;
        Wed, 06 Apr 2022 17:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=00Hbk/0CidWttLq2MxZDyxIW9qLxajk7I76V56fwuVM=;
        b=FXEDV1gzXsqcLwR7v+J9+xAJz5qrkNi8cjuXkTVNIbrFDlEyKJwNwLtRvCkoOpx/CA
         JFCugI0MvygP9U33Qs7ps27MCd1N0Jvq3OeLU15bNuTj7Fal/Kb5Jh+LgL+yRfrmPyWE
         dbBBmiBF3LeBf6RNlo81mSUQQd6+XRJXaSme3uOPKcafS0Epq4kjQOntkMB4OsrlVp7P
         SuZIdGSVavcrx38jmzs+kDKyuIvo3KqTmbrfOH3PQSx8XVR+EgX7mHWB0wyI+sA+5Ywc
         aczyq664quY2ZWGnyFcH7DUdHD4Ex6YND+FUaeENzfmab9vXhC53kOl0O7pg0+PjFl8+
         P4yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=00Hbk/0CidWttLq2MxZDyxIW9qLxajk7I76V56fwuVM=;
        b=kp0Xp4OOaJ25JgAMfGq4/KPk06zi+AEto54vaTN0eFSzyRAe70mgKjBpUcnoTi/Vub
         DTbn0cLyMn/FeK1/KG9aV53Q40NrNzvpwdW/R6NoaunKT3zfhl3VvLcokeQ6TQK9JSmW
         U5C3dGyfs7wI+Lou3BZQG6JaOLNtRj6caiZbUK77RURkIcYkryfkJX6JsuoABnqNR4uG
         cQO5NX13yUCccZy5Z6gg5WKQbyeDMe5CESfA9pXJIdiQkgoxI4xd0/ofPsj8xaZSbtpr
         WsCd7hxXj9L+jajvXHJc2Lbf3YGGiAPFX4yQJ9xzcPT/w8ChK5JUc/I6Bl4jxV4fyMK1
         B1iw==
X-Gm-Message-State: AOAM531MLVZ0CxdL7p24htIQE72RylMi9YtyJvKG6+GtrbpzhCTxMe2y
        Vmf5lCpf49V1wiedf/oRgGGt6bOlnvk=
X-Google-Smtp-Source: ABdhPJz87rNyQmthxWbh6mUxn/7oViulh+uFXYdzZKeziL6198Dd9SPuMbYEWqXsYDOPdAEgtsJnSQ==
X-Received: by 2002:a05:6512:1153:b0:44a:3b47:4f88 with SMTP id m19-20020a056512115300b0044a3b474f88mr7372702lfg.447.1649290844529;
        Wed, 06 Apr 2022 17:20:44 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id n12-20020a2e86cc000000b0024b121fbb2csm1413879ljj.46.2022.04.06.17.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 17:20:44 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 2/3] rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
Date:   Thu,  7 Apr 2022 02:19:25 +0200
Message-Id: <20220407001926.11252-3-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407001926.11252-1-lech.perczak@gmail.com>
References: <20220407001926.11252-1-lech.perczak@gmail.com>
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

Certain ZTE modems, namely: MF823. MF831, MF910, built-in modem from
MF286R, expose both CDC-ECM and RNDIS network interfaces.
They have a trait of ignoring the locally-administered MAC address
configured on the interface both in CDC-ECM and RNDIS part,
and this leads to dropping of incoming traffic by the host.
However, the workaround was only present in CDC-ECM, and MF286R
explicitly requires it in RNDIS mode.

Re-use the workaround in rndis_host as well, to fix operation of MF286R
module, some versions of which expose only the RNDIS interface.

Apply the workaround to both "flavors" of RNDIS interfaces, as older ZTE
modems, like MF823 found in the wild, report the USB_CLASS_COMM class
interfaces, while MF286R reports USB_CLASS_WIRELESS_CONTROLLER.

Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
 drivers/net/usb/rndis_host.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 247f58cb0f84..a7eb032115e8 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -578,6 +578,10 @@ rndis_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 }
 EXPORT_SYMBOL_GPL(rndis_tx_fixup);
 
+static int zte_rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+{
+	return rndis_rx_fixup(dev, skb) && usbnet_cdc_zte_rx_fixup(dev, skb);
+}
 
 static const struct driver_info	rndis_info = {
 	.description =	"RNDIS device",
@@ -600,6 +604,16 @@ static const struct driver_info	rndis_poll_status_info = {
 	.tx_fixup =	rndis_tx_fixup,
 };
 
+static const struct driver_info	zte_rndis_info = {
+	.description =	"ZTE RNDIS device",
+	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.bind =		rndis_bind,
+	.unbind =	rndis_unbind,
+	.status =	rndis_status,
+	.rx_fixup =	zte_rndis_rx_fixup,
+	.tx_fixup =	rndis_tx_fixup,
+};
+
 /*-------------------------------------------------------------------------*/
 
 static const struct usb_device_id	products [] = {
@@ -613,6 +627,16 @@ static const struct usb_device_id	products [] = {
 	USB_VENDOR_AND_INTERFACE_INFO(0x238b,
 				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
 	.driver_info = (unsigned long)&rndis_info,
+}, {
+	/* ZTE WWAN modules */
+	USB_VENDOR_AND_INTERFACE_INFO(0x19d2,
+				      USB_CLASS_WIRELESS_CONTROLLER, 1, 3),
+	.driver_info = (unsigned long)&zte_rndis_info,
+}, {
+	/* ZTE WWAN modules, ACM flavour */
+	USB_VENDOR_AND_INTERFACE_INFO(0x19d2,
+				      USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
+	.driver_info = (unsigned long)&zte_rndis_info,
 }, {
 	/* RNDIS is MSFT's un-official variant of CDC ACM */
 	USB_INTERFACE_INFO(USB_CLASS_COMM, 2 /* ACM */, 0x0ff),
-- 
2.30.2

