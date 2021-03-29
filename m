Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5683E34D35A
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhC2PKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhC2PJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:09:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E7DC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:09:44 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id c8so13202027wrq.11
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=tOvOPLVCfwLiB7xIEPiMjsyZHcZMpEfWNqr4+JSwO0c=;
        b=JrlhhBc/BkL6VZkGdEI6LjvjPNV1Oov0v49OcxHgaR5w5XbMJMq5+UAjo1wnH6yW7L
         Pobsz3YqjxFrgNHq+f2TUOr5V63GYiNtUB25SPDnL3qz0VaIMrlSAVwf/T1/wkwtynCP
         5Yx8sg/uo3KLwHGCIaGAKDBmY1I1nuuzDk3abb86yCGZCf4YreoIKKryo1P+IDUj9Qc0
         kub12402cCn/s1FqnOBJ/cnGiL6yZCd0D82fjh1OjRD+XzFZVVguM+9k50vb6HI2duMg
         c7xSTjxu8+/Il6v4/sfh4rWwearD2m7up0ecN/pqy8KiASF9Vs+2Z2C88xxMmiJgyEm2
         lGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tOvOPLVCfwLiB7xIEPiMjsyZHcZMpEfWNqr4+JSwO0c=;
        b=jcCEsQRMhAqIPaoeWJzd8mAWWEtK1Xi9HcqOxKlzsM5GRwf96FQjVQbRWVpJ4opgm/
         5gQ+81z38q4gRqWnIkzXjm/bqD3EcHpfIdLM+hLdY9ik/B0VBRGXtHHnFx+RPkGBKG8J
         hzJy1mP6nfL+82LoZ4cDQttq0dfYbdEBPQVbe2sgt1+QhPaweKiOfOdunEcam7ffpKFC
         09qwYePO/JYzkUrd1ZYhZUP3nc1ICHMbIbYI2TpEvYbXxqYNfZV3gCBg3e96UH0j55Q6
         SLSDTcZwuZ2qLBXUWCJJRd8To1N6mm01nkYp61x/+BbDWs55ud8ihiWlnRMuprNVLho8
         doPg==
X-Gm-Message-State: AOAM533CUatSbISlXspQEnx2PGXd982BL1wZR2uwkBud/yVkm8zJySvy
        R6j/z/XwrPzfCsC4u+eNzRlr5w==
X-Google-Smtp-Source: ABdhPJzrrkAgagYlj5yMJvPCYpFmAD7XU2bQkypH8xRuPeHxl8uHSoRDjagfd5geAsu7vDIZhCatEg==
X-Received: by 2002:adf:f005:: with SMTP id j5mr28363939wro.423.1617030583633;
        Mon, 29 Mar 2021 08:09:43 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:e89:f257:8111:afb6])
        by smtp.gmail.com with ESMTPSA id x11sm24963636wmi.3.2021.03.29.08.09.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 08:09:42 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 1/2] net: mhi: Add support for non-linear MBIM skb processing
Date:   Mon, 29 Mar 2021 17:18:24 +0200
Message-Id: <1617031105-3147-1-git-send-email-loic.poulain@linaro.org>
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

 drivers/net/mhi/proto_mbim.c | 50 +++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/net/mhi/proto_mbim.c b/drivers/net/mhi/proto_mbim.c
index 75b5484..10ffb97 100644
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
@@ -142,12 +130,18 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 
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
+			net_err_ratelimited("%s: Incorrect NDP offset (%u)\n", ndpoffset);
+			__mbim_length_errors_inc(mhi_netdev);
+			goto error;
+		}
 
 		/* Check NDP header and retrieve number of datagrams */
-		nframes = mbim_rx_verify_ndp16(skb, ndpoffset);
+		nframes = mbim_rx_verify_ndp16(skb, &ndp16);
 		if (nframes < 0) {
 			net_err_ratelimited("%s: Incorrect NDP16\n", ndev->name);
 			__mbim_length_errors_inc(mhi_netdev);
@@ -155,8 +149,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 		}
 
 		 /* Only IP data type supported, no DSS in MHI context */
-		ndp16 = (struct usb_cdc_ncm_ndp16 *)(skb->data + ndpoffset);
-		if ((ndp16->dwSignature & cpu_to_le32(MBIM_NDP16_SIGN_MASK))
+		if ((ndp16.dwSignature & cpu_to_le32(MBIM_NDP16_SIGN_MASK))
 				!= cpu_to_le32(USB_CDC_MBIM_NDP16_IPS_SIGN)) {
 			net_err_ratelimited("%s: Unsupported NDP type\n", ndev->name);
 			__mbim_errors_inc(mhi_netdev);
@@ -164,19 +157,24 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
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
 
@@ -185,7 +183,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
 				continue;
 
 			skb_put(skbn, dgram_len);
-			memcpy(skbn->data, skb->data + dgram_offset, dgram_len);
+			skb_copy_bits(skb, dgram_offset, skbn->data, dgram_len);
 
 			switch (skbn->data[0] & 0xf0) {
 			case 0x40:
@@ -206,7 +204,7 @@ static void mbim_rx(struct mhi_net_dev *mhi_netdev, struct sk_buff *skb)
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

