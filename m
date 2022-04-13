Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9763B4FEBD7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 02:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbiDMAOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 20:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiDMAOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 20:14:42 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9572183C;
        Tue, 12 Apr 2022 17:12:23 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id r18so355986ljp.0;
        Tue, 12 Apr 2022 17:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=95EdWt3P5OcczU2ZgA3mNWl4SQi5XpYA5t1o8tF8XYk=;
        b=c+FWgx0zV3p4uTzreCEpkwcL0sYI2IYIBoovHFkyJ4D68sPmtMIz6PN8OxzIvA85e1
         LBkB1zjlxhrx9xfrxKDPqVYliEb1WNg1v3T8ifr0Q4DrDJMlZFbBmFaEIFZyFLcrKKKS
         NckidXETcrx731FpkArx31gLDlwMGeRus75bihsNWbH9rhFZDSvJmdCcsrCX3gGWi6hW
         XTZ5dG+dP/fnUJuu/HUlq5s32MmcQmC7+9gq7y7yp7rjeIOh+h6fnCr1JqocDcwr+Aet
         A/aykxVA6cpp2MRnjshnk/7k2mjREHpjHpehoQ6wGWqTBouPTXFggj0syERTxOvMoUB3
         RjmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=95EdWt3P5OcczU2ZgA3mNWl4SQi5XpYA5t1o8tF8XYk=;
        b=pe2t7zjEe/z31Hrgo6d4eJy2XFGD2emeZn0LB7S6e1Jkna4wEKHE7qJT6WSZvsPUWk
         QMcYjeqlIf/XiMLcA2eBBnpWqlTQczbmdVatFPBAYKZxtL7vY+dPTkKStVVIqlU1YwVp
         SRT5OO0zraP9CmHhcgzRAor2e1CRBVerL9vwUJb0Q9rlh/Y5bI2602WS0BvQmefcMyYP
         noPefaeDlqjI3s+K91b63bhUDpR+xUhOcAcd+PY+5HsgI9LA3V6kFRkXnDPTXic3MDnW
         c0zvSXjLkX7qwGW5jX5IiWVBXrXnXg9YbuU9zNOHJR2MS0gQQOnygjl+5IwPF1MSSZId
         lkzA==
X-Gm-Message-State: AOAM530Q0QHTPbJSXdTST0zm1pAu7Opdv9Sd5GaC1j2HCZB1ftnTI5sR
        VyTK4/miPmRhsk5yXEy6r12BvuoJx2qzyA==
X-Google-Smtp-Source: ABdhPJxhbhcM+HcMeo8HVy50JWoZDZNCkkXm1dXSGPOKhMpkZcoWduYuCqLX3pNc1gl2eLaM3t9RBw==
X-Received: by 2002:a2e:bf25:0:b0:247:d216:43fc with SMTP id c37-20020a2ebf25000000b00247d21643fcmr25040685ljr.520.1649808741341;
        Tue, 12 Apr 2022 17:12:21 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id d6-20020a2e96c6000000b0024b4cd1b611sm1611731ljj.91.2022.04.12.17.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 17:12:21 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v2 2/3] rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
Date:   Wed, 13 Apr 2022 02:11:57 +0200
Message-Id: <20220413001158.1202194-3-lech.perczak@gmail.com>
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

Certain ZTE modems, namely: MF823. MF831, MF910, built-in modem from
MF286R, expose both CDC-ECM and RNDIS network interfaces.
They have a trait of ignoring the locally-administered MAC address
configured on the interface both in CDC-ECM and RNDIS part,
and this leads to dropping of incoming traffic by the host.
However, the workaround was only present in CDC-ECM, and MF286R
explicitly requires it in RNDIS mode.

Re-use the workaround in rndis_host as well, to fix operation of MF286R
module, some versions of which expose only the RNDIS interface. Do so by
introducing new flag, RNDIS_DRIVER_DATA_BOGUS_MAC, and testing for it in
rndis_rx_fixup. This is required, as RNDIS uses frame batching, and all
of the packets inside the batch need the fixup. This might introduce a
performance penalty, because test is done for every returned Ethernet
frame.

Apply the workaround to both "flavors" of RNDIS interfaces, as older ZTE
modems, like MF823 found in the wild, report the USB_CLASS_COMM class
interfaces, while MF286R reports USB_CLASS_WIRELESS_CONTROLLER.

Suggested-by: Bjørn Mork <bjorn@mork.no>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
---
v2:
- Ensured that MAC fixup is applied to all Ethernet frames inside an
  RNDIS batch. Thanks to Bjørn for finding the issue. 
- Introduced new driver flag to facilitate the above.

 drivers/net/usb/rndis_host.c   | 33 ++++++++++++++++++++++++++++++++-
 include/linux/usb/rndis_host.h |  1 +
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index 247f58cb0f84..18b27a4ed8bd 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -485,10 +485,14 @@ EXPORT_SYMBOL_GPL(rndis_unbind);
  */
 int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
+	bool dst_mac_fixup;
+
 	/* This check is no longer done by usbnet */
 	if (skb->len < dev->net->hard_header_len)
 		return 0;
 
+	dst_mac_fixup = !!(dev->driver_info->data & RNDIS_DRIVER_DATA_DST_MAC_FIXUP);
+
 	/* peripheral may have batched packets to us... */
 	while (likely(skb->len)) {
 		struct rndis_data_hdr	*hdr = (void *)skb->data;
@@ -523,10 +527,17 @@ int rndis_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			break;
 		skb_pull(skb, msg_len - sizeof *hdr);
 		skb_trim(skb2, data_len);
+
+		if (unlikely(dst_mac_fixup))
+			usbnet_cdc_zte_rx_fixup(dev, skb2);
+
 		usbnet_skb_return(dev, skb2);
 	}
 
 	/* caller will usbnet_skb_return the remaining packet */
+	if (unlikely(dst_mac_fixup))
+		usbnet_cdc_zte_rx_fixup(dev, skb);
+
 	return 1;
 }
 EXPORT_SYMBOL_GPL(rndis_rx_fixup);
@@ -578,7 +589,6 @@ rndis_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 }
 EXPORT_SYMBOL_GPL(rndis_tx_fixup);
 
-
 static const struct driver_info	rndis_info = {
 	.description =	"RNDIS device",
 	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
@@ -600,6 +610,17 @@ static const struct driver_info	rndis_poll_status_info = {
 	.tx_fixup =	rndis_tx_fixup,
 };
 
+static const struct driver_info	zte_rndis_info = {
+	.description =	"ZTE RNDIS device",
+	.flags =	FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
+	.data =		RNDIS_DRIVER_DATA_DST_MAC_FIXUP,
+	.bind =		rndis_bind,
+	.unbind =	rndis_unbind,
+	.status =	rndis_status,
+	.rx_fixup =	rndis_rx_fixup,
+	.tx_fixup =	rndis_tx_fixup,
+};
+
 /*-------------------------------------------------------------------------*/
 
 static const struct usb_device_id	products [] = {
@@ -613,6 +634,16 @@ static const struct usb_device_id	products [] = {
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
diff --git a/include/linux/usb/rndis_host.h b/include/linux/usb/rndis_host.h
index 809bccd08455..cc42db51bbba 100644
--- a/include/linux/usb/rndis_host.h
+++ b/include/linux/usb/rndis_host.h
@@ -197,6 +197,7 @@ struct rndis_keepalive_c {	/* IN (optionally OUT) */
 
 /* Flags for driver_info::data */
 #define RNDIS_DRIVER_DATA_POLL_STATUS	1	/* poll status before control */
+#define RNDIS_DRIVER_DATA_DST_MAC_FIXUP	2	/* device ignores configured MAC address */
 
 extern void rndis_status(struct usbnet *dev, struct urb *urb);
 extern int
-- 
2.30.2

