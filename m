Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3F34D3F2
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhC2Pa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhC2Pax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:30:53 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A9FC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:30:52 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so6888240wmj.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DlMqjVJIl/mRJdDN04cE1xnw0hfFQzcOVg0gqetXyS0=;
        b=WSlGZcjTBqTRbQzV0nWM7i/VA5V9D4KvIOCESVMPWAUMlO5fYMIOwJW6mEvdGJ++yA
         JdW9N5cgODBttlNOyZdm7DkTllvZBJEcEt8LU1PdVSUPipwwRddJKeEh9kd0iedaX5XU
         9FPYHxgOIV9X5qQJ4mHKtLK4F3sleISuU/EAaVTF6wYeZaEHyu7ihA7oQAGcyZOvgZoI
         0ORGTax+s7eqy9l6po+UJ/LAd/X4NfrA81iy91XW97Hb2dgAtfhBDk/ff418NNJo3pgO
         55tK7qOTT11TDgXEvgh+/nPBMuUyvuMlX54oBXctVYGjXXaxx8n+89Lyc4mAgdEo8rb7
         OjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DlMqjVJIl/mRJdDN04cE1xnw0hfFQzcOVg0gqetXyS0=;
        b=qO66BkZB8nT2hrUVPe1to7I8QLeTno2l/lX+tyfhDu3ytCirHi+NSDUa8TI/oPL9xW
         DJ5a6OOdxIk5Fgw85G68r5gkix5nvjf2MZDVTFxJ3lFdoECUJ0XfCD1Va8LhwovPpr8b
         wM2q0XZ+bNlc3PpGVhuozMP0HXdagnQc7dgxFv7iEvJ+VNUsQ06vtAaLy6+Bee2PLVUf
         v9QIOBr5RAt2g82B0wFPu6eaO/7IiBv6b2niWjCoa6tIGv0N6Y76CkGMf24YpdXXk/Nb
         z3ilYOZZOvx2mBxOMajT+8J2UqnTgMb1C/hRkWvF4LYk9nnJmj4RcgwR4Um05/H2sVlJ
         4GDQ==
X-Gm-Message-State: AOAM532KZcpIWOxpg5905FGJZ3ltKjceeoBPb8DFgbF0DBZ5eRbsbxpi
        xUXThHTpQdzzeGvolAZI0cKPrQ==
X-Google-Smtp-Source: ABdhPJwBSKzEOzugVBEOkbx8DIyLgaQ5gw3jxv8QaJsGST45yBNLaJj7jwzt760FTPB30q5k1Kg4og==
X-Received: by 2002:a1c:9a09:: with SMTP id c9mr24665753wme.172.1617031851410;
        Mon, 29 Mar 2021 08:30:51 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:e89:f257:8111:afb6])
        by smtp.gmail.com with ESMTPSA id p12sm29200976wrx.28.2021.03.29.08.30.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 08:30:50 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 1/2] net: mhi: Add support for non-linear MBIM skb processing
Date:   Mon, 29 Mar 2021 17:39:31 +0200
Message-Id: <1617032372-2387-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if skb is non-linear, due to MHI skb chaining, it is
linearized in MBIM RX handler prior MBIM decoding, causing extra
allocation and copy that can be as large as the maximum MBIM frame
size (32K).

This change introduces MBIM decoding for non-linear skb, allowing to
process 'large' non-linear MBIM packets without skb linearization.
The IP packets are simply extracted from the MBIM frame using the
skb_copy_bits helper.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: added to the series for reducing chained skb processing overhead 
 v3: Fix missing net_err_ratelimited print param (ndev->name).

 drivers/net/mhi/proto_mbim.c | 51 ++++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index 75b5484..5a176c3 100644
--- a/drivers/net/mhi/proto_mbim.c
+++ b/drivers/net/mhi/proto_mbim.c
@@ -91,20 +91,11 @@ static int mbim_rx_verify_nth16(struct sk_buff *skb)
 	return le16_to_cpu(nth16->wNdpIndex);
 }
 
-static int mbim_rx_verify_ndp16(struct sk_buff *skb, int ndpoffset)
+static int mbim_rx_verify_ndp16(struct sk_buff *skb, struct usb_cdc_ncm_ndp16 *ndp16)
 {
 	struct mhi_net_dev *dev = netdev_priv(skb->dev);
-	struct usb_cdc_ncm_ndp16 *ndp16;
 	int ret;
 
-	if (ndpoffset + sizeof(struct usb_cdc_ncm_ndp16) > skb->len) {
-		netif_dbg(dev, rx_err, dev->ndev, "invalid NDP offset  <%u>\n",
-			  ndpoffset);
-		return -EINVAL;
-	}
-
-	ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
-
 	if (le16_to_cpu(ndp16->wLength) < USB_CDC_NCM_NDP16_LENGTH_MIN) {
 		netif_dbg(dev, rx_err, dev->ndev, "invalid DPT16 length <%u>\n",
 			  le16_to_cpu(ndp16->wLength));
@@ -130,9 +121,6 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 	struct net_device *ndev = mhi_netdev->ndev;
 	int ndpoffset;
 
-	if (skb_linearize(skb))
-		goto error;
-
 	/* Check NTB header and retrieve first NDP offset */
 	ndpoffset = mbim_rx_verify_nth16(skb);
 	if (ndpoffset < 0) {
@@ -142,12 +130,19 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 
 	/* Process each NDP */
 	while (1) {
-		struct usb_cdc_ncm_ndp16 *ndp16;
-		struct usb_cdc_ncm_dpe16 *dpe16;
-		int nframes, n;
+		struct usb_cdc_ncm_ndp16 ndp16;
+		struct usb_cdc_ncm_dpe16 dpe16;
+		int nframes, n, dpeoffset;
+
+		if (skb_copy_bits(skb, ndpoffset, &ndp16, sizeof(ndp16))) {
+			net_err_ratelimited("%s: Incorrect NDP offset (%u)\n",
+					    ndev->name, ndpoffset);
+			__mbim_length_errors_inc(mhi_netdev);
+			goto error;
+		}
 
 		/* Check NDP header and retrieve number of datagrams */
-		nframes = mbim_rx_verify_ndp16(skb, ndpoffset);
+		nframes = mbim_rx_verify_ndp16(skb, &ndp16);
 		if (nframes < 0) {
 			net_err_ratelimited("%s: Incorrect NDP16\n", ndev->name);
 			__mbim_length_errors_inc(mhi_netdev);
@@ -155,8 +150,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 		}
 
 		 /* Only IP data type supported, no DSS in MHI context */
-		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
-		if ((ndp16->dwSignature & cpu_to_le32(MBIM_NDP16_SIGN_MASK))
+		if ((ndp16.dwSignature & cpu_to_le32(MBIM_NDP16_SIGN_MASK))
 				!= cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN)) {
 			net_err_ratelimited("%s: Unsupported NDP type\n", ndev->name);
 			__mbim_errors_inc(mhi_netdev);
@@ -164,19 +158,24 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 		}
 
 		/* Only primary IP session 0 (0x00) supported for now */
-		if (ndp16->dwSignature & ~cpu_to_le32(MBIM_NDP16_SIGN_MASK)) {
+		if (ndp16.dwSignature & ~cpu_to_le32(MBIM_NDP16_SIGN_MASK)) {
 			net_err_ratelimited("%s: bad packet session\n", ndev->name);
 			__mbim_errors_inc(mhi_netdev);
 			goto next_ndp;
 		}
 
 		/* de-aggregate and deliver IP packets */
-		dpe16 = ndp16->dpe16;
-		for (n = 0; n < nframes; n++, dpe16++) {
-			u16 dgram_offset = le16_to_cpu(dpe16->wDatagramIndex);
-			u16 dgram_len = le16_to_cpu(dpe16->wDatagramLength);
+		dpeoffset = ndpoffset + sizeof(struct usb_cdc_ncm_ndp16);
+		for (n = 0; n < nframes; n++, dpeoffset += sizeof(dpe16)) {
+			u16 dgram_offset, dgram_len;
 			struct sk_buff *skbn;
 
+			if (skb_copy_bits(skb, dpeoffset, &dpe16, sizeof(dpe16)))
+				break;
+
+			dgram_offset = le16_to_cpu(dpe16.wDatagramIndex);
+			dgram_len = le16_to_cpu(dpe16.wDatagramLength);
+
 			if (!dgram_offset || !dgram_len)
 				break; /* null terminator */
 
@@ -185,7 +184,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 				continue;
 
 			skb_put(skbn, dgram_len);
-			memcpy(skbn->data, skb->data + dgram_offset, dgram_len);
+			skb_copy_bits(skb, dgram_offset, skbn->data, dgram_len);
 
 			switch (skbn->data[0] & 0xf0) {
 			case 0x40:
@@ -206,7 +205,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 		}
 next_ndp:
 		/* Other NDP to process? */
-		ndpoffset = (int)le16_to_cpu(ndp16->wNextNdpIndex);
+		ndpoffset = (int)le16_to_cpu(ndp16.wNextNdpIndex);
 		if (!ndpoffset)
 			break;
 	}
-- 
2.7.4

