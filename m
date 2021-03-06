Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDD232F7FE
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCFDQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhCFDP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:15:59 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9FDC0613D8
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:15:59 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id v14so3835471ilj.11
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cz9pvy9/DMfTSTzewlxOLsfS473feLrBEN4uWmNYcUQ=;
        b=mGtVXYn/bwhRQsYvtNd7ZGXWKsevaqd53fLNz1Q3QEtpsF5uML8Js98pB8bnacaMXQ
         k20khoRHAscRm7jho+f0O3zgfzuomc0jjJz9MFhbMmIa7+1HsGXR+DwgVPldRUw/gPkT
         a5n+FXp5+blFq4dWiFVXf+e00GkNZZ9ygi9GTYk6/SGxzLGDjrvJI9aMME4v/v0fe73P
         7pyH/IXordCMPDiLWa5hY16XKva+suxJyAic1K9xkeMxr22Y07baCLYlh9LCn0ltjyaM
         cKl5p2TfOxszF24qnSoXvt3Maf8/ooGFRpT2amEBrsk2IKG9rGQmp+rtVGw0jjHgiUAg
         SF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cz9pvy9/DMfTSTzewlxOLsfS473feLrBEN4uWmNYcUQ=;
        b=oKjKMMRZFu8MjSFc1HXF4DtfiQLhq3TGVrwIgaRCLNblCLbAbN2C/613brBATlmYF/
         bgssidaDDlI+0Cuce5YwCdbIiib0kbxAP6HQvOEHQj3mnVrCg3KNx6XvlIrkwEBZt931
         fD0OHQE9zFuNcZJCULUnImr8+Ov0axn+tJecfiqmA50N1xUr5HLvIKSFbP7i6yA4xjRQ
         kusufXM5QRmCIqqTnPYdpFyeutn6GKMfEftXd9DGAuyud6quv3JT/+o1kBf00NRM7Oqn
         TmbSDMWhHaB0F4XOCfiLKYwtNdSjZ/K0gunGt9lTQZBgs/Fjz7qzo4ciHCfaaa3k+25+
         rfuw==
X-Gm-Message-State: AOAM533jXME6nrzHPqWzzJ34IMOemSCJqvd+h37G7cJO+ZGBn2foGO3j
        bATX1bj+IfX0CIrtzYOKBHpN0Q==
X-Google-Smtp-Source: ABdhPJw06LUFkB6pq+YgJO/WcE6so1Ux1f3QQA9fLPTKXOi2jyygXhn/tjlMyjgd1mt9JCNBWfNCnw==
X-Received: by 2002:a92:cda2:: with SMTP id g2mr11834168ild.297.1615000558717;
        Fri, 05 Mar 2021 19:15:58 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:58 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net: qualcomm: rmnet: use field masks instead of C bit-fields
Date:   Fri,  5 Mar 2021 21:15:48 -0600
Message-Id: <20210306031550.26530-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210306031550.26530-1-elder@linaro.org>
References: <20210306031550.26530-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The actual layout of bits defined in C bit-fields (e.g. int foo : 3)
is implementation-defined.  Structures defined in <linux/if_rmnet.h>
address this by specifying all bit-fields twice, to cover two
possible layouts.

I think this pattern is repetitive and noisy, and I find the whole
notion of compiler "bitfield endianness" to be non-intuitive.

Stop using C bit-fields for the command/data flag and the pad length
fields in the rmnet_map structure.  Instead, define a single-byte
flags field, and use the functions defined in <linux/bitfield.h>,
along with field mask constants to extract or assign values within
that field.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  5 ++--
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +++-
 include/linux/if_rmnet.h                      | 23 ++++++++-----------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 2a6b2a609884c..30f8e2f02696b 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -4,6 +4,7 @@
  * RMNET Data ingress/egress handler
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/netdev_features.h>
 #include <linux/if_arp.h>
@@ -61,7 +62,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	u16 len, pad;
 	u8 mux_id;
 
-	if (map_header->cd_bit) {
+	if (u8_get_bits(map_header->flags, MAP_CMD_FMASK)) {
 		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
@@ -70,7 +71,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	}
 
 	mux_id = map_header->mux_id;
-	pad = map_header->pad_len;
+	pad = u8_get_bits(map_header->flags, MAP_PAD_LEN_FMASK);
 	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index fd55269c2ce3c..3291f252d81b0 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -4,6 +4,7 @@
  * RMNET Data MAP protocol
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -299,7 +300,8 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-	map_header->pad_len = padding & 0x3F;
+	/* This is a data packet, so the CMD bit is 0 */
+	map_header->flags = u8_encode_bits(padding, MAP_PAD_LEN_FMASK);
 
 	return map_header;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 8c7845baf3837..4824c6328a82c 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -6,21 +6,18 @@
 #define _LINUX_IF_RMNET_H_
 
 struct rmnet_map_header {
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u8  pad_len:6;
-	u8  reserved_bit:1;
-	u8  cd_bit:1;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u8  cd_bit:1;
-	u8  reserved_bit:1;
-	u8  pad_len:6;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
-	u8  mux_id;
-	__be16 pkt_len;
+	u8 flags;			/* MAP_*_FMASK */
+	u8 mux_id;
+	__be16 pkt_len;			/* Length of packet, including pad */
 }  __aligned(1);
 
+/* rmnet_map_header flags field:
+ *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ *  PAD_LEN:	number of pad bytes following packet data
+ */
+#define MAP_CMD_FMASK			GENMASK(7, 7)
+#define MAP_PAD_LEN_FMASK		GENMASK(5, 0)
+
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

