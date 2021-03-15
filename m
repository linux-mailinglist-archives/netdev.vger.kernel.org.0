Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153433C8D7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhCOVwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhCOVwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:52:00 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB98C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:00 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f10so10817707ilq.5
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gzfg71vsx3VY2377GfG2oAcRHO8kBLm5otxChzsZJP0=;
        b=nU74m4/TDwYTcRC/4fEWoUrB1F9S8l7PAHZcvmRg2f+JWzVfWqpnrDrdGpuyijqwKv
         0VtF8OW7fWEsrbQRPQKSixSsr+JasVJfE8XHLoLRXl+S4Bksi2e6tJ6PhCepvmZYxPtQ
         MrHalaUfCsmWZiGWgYU9XdhCQdfKrgTQ8UB46iJoqkIrFy+X5sGOoevr2PIbZcrcbDsN
         Sm+GZBjEMwKnSoS16c7Im5ldPbS594ioQ2b08V25r7mB739a73pM6/lB6PXHmj7Mq8LA
         nYuMOH1kSyW9Y17ytEHmrv0ki/vD6YqWiITeYrlMcz063S8ctjkNa+75L4ryTwoDI3tF
         xYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gzfg71vsx3VY2377GfG2oAcRHO8kBLm5otxChzsZJP0=;
        b=dxYf9dl1pkKzXJJP5XbwJHrYGyaUVTaCVA+Gs5pb0Wmy/xhVI2Y3sRUAcuFbA4C7Qh
         YpLZgbJRfic1PpUC+Oc77PwHVZ260nkocyV7+krRGXl3hRhiWgn3hct0Z1YMHkab/uXZ
         bjrdpPJGvETrQHVYoYLDrYEWZszIU/c5hTuchWAisgi1WAzamHPt58N4FZQETC+qHEup
         fEzge/b+1cT31beaxRnOI3oK5c2ZfjnNczZlv/cP1Pr6zFVSxJwTKHZlxQbCheHw0xyR
         Mfbi9WCsaYKQCi92dtp98jGqMwimHYBCG8rR1q9BhOyYD1fUzs9IWKEYSFRr5OCUG5d3
         F6gA==
X-Gm-Message-State: AOAM532b1jbruCycy/BlE49dkfcFDwkdjELZpk0fptaXjNpvO0W4w/ys
        PvYI+45nX0EJoGX1f2r6P3pS/Q==
X-Google-Smtp-Source: ABdhPJzb+fiHI71TVXJZIbIUwv/0TxIExHewKZdhto2+aYzdKnq6tT8y8DLDh6cRibC4XVFcZ1zjig==
X-Received: by 2002:a05:6e02:c7:: with SMTP id r7mr1319971ilq.288.1615845119526;
        Mon, 15 Mar 2021 14:51:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:51:59 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v6 4/6] net: qualcomm: rmnet: use masks instead of C bit-fields
Date:   Mon, 15 Mar 2021 16:51:49 -0500
Message-Id: <20210315215151.3029676-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
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
fields in the rmnet_map structure, and define a single-byte flags
field instead.  Define a mask for the single-bit "command" flag,
and another mask for the encoded pad length.  The content of both
fields can be accessed using a simple bitwise AND operation.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
v4: - Don't use u8_get_bits() to access the pad length
    - Added BUILD_BUG_ON() to ensure field width is adequate
v3: - Use BIT(x) and don't use u8_get_bits() for the command flag

 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  4 ++--
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +++-
 include/linux/if_rmnet.h                      | 23 ++++++++-----------
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 2a6b2a609884c..0be5ac7ab2617 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -61,7 +61,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	u16 len, pad;
 	u8 mux_id;
 
-	if (map_header->cd_bit) {
+	if (map_header->flags & MAP_CMD_FLAG) {
 		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
@@ -70,7 +70,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	}
 
 	mux_id = map_header->mux_id;
-	pad = map_header->pad_len;
+	pad = map_header->flags & MAP_PAD_LEN_MASK;
 	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3af68368fc315..e7d0394cb2979 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -280,6 +280,7 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 		return map_header;
 	}
 
+	BUILD_BUG_ON(MAP_PAD_LEN_MASK < 3);
 	padding = ALIGN(map_datalen, 4) - map_datalen;
 
 	if (padding == 0)
@@ -293,7 +294,8 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-	map_header->pad_len = padding & 0x3F;
+	/* This is a data packet, so the CMD bit is 0 */
+	map_header->flags = padding & MAP_PAD_LEN_MASK;
 
 	return map_header;
 }
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 8c7845baf3837..a02f0a3df1d9a 100644
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
+	u8 flags;			/* MAP_CMD_FLAG, MAP_PAD_LEN_MASK */
+	u8 mux_id;
+	__be16 pkt_len;			/* Length of packet, including pad */
 }  __aligned(1);
 
+/* rmnet_map_header flags field:
+ *  PAD_LEN:	number of pad bytes following packet data
+ *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
+ */
+#define MAP_PAD_LEN_MASK		GENMASK(5, 0)
+#define MAP_CMD_FLAG			BIT(7)
+
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

