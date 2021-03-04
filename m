Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD74532DD23
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhCDWem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbhCDWej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:39 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E89C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:39 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id z13so31578137iox.8
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u8rJljDcSCEpHYCyMqU7xoqI25apaSt0GBEi+BjNLKI=;
        b=QBTvL34eQtIQoFiQiYSsWb8p+CLGzKt6R69kgY6VbPQSAq8I74oHLwra/+1KZT0AHf
         IhGAP2Gbfc2q9cwPbpX19pdw+H0LIoncjV+1bWgDT2I8XDA7pLqvmoIrAwanGyGFpUwV
         ZBoQWZs6VyC9fE2oUbw3m1Am9l+tjb2BAUI5JE00y1nutlSGhyII1NM0J3rPblwlfXJR
         +qcpxjUj6cA+GDvxTIxOVqUBKPPVlein1HjqXa8aM3sIb7EBRyyUwie6JniffuWmKkzr
         5MzFUnjLw5A6IxWwd4tUNpYbvR2geeGhJUsWKgOY1x/Mqhz9cKTGJaq1kPFnu/OytKrD
         1bIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u8rJljDcSCEpHYCyMqU7xoqI25apaSt0GBEi+BjNLKI=;
        b=JDbpk2qEdbiipZrG7U/arkvNrIISwoR/hTopntqlxThCdN487UJNLexa8d+BfPWAlA
         B/RNQcQsR7fSSpud6FBAUCCrS80l6pFTjPD1Cd/5WliEMOgun1Ghj86WnhahdMefAoxL
         Ylo2vGklTUmonc08OuTjCzuSzqX2UpxSL5H4ya+mVb7P0YNdYLbovCfG3VN2PqPUH8YY
         sBxYBQfqKk6Co14WIH8zTmushiUX5ACSPMjQdxJEBLXNfGDXv3z8Pp03hlcMofzMi6fZ
         6SMfhWUnx6kSVI4NIQ4mFqbQPfJSLiptCZ4EXgwvvRPxSflZv30ay3bSUqTZjpIXyFwQ
         G0VQ==
X-Gm-Message-State: AOAM530kKfkDs27y/mcB9F4rNzkfQk7Ys7DsfJMYKpeP2U0EB98uMgvi
        V04+aK8DIA1BahHy9GTQ4cRQBg==
X-Google-Smtp-Source: ABdhPJwagmJDSZpFApsu1HguKbDhqjP37QhqzMEeLfCvLX5Xl8wx8YuECoQYd/P0iLbmzCPcb2feVw==
X-Received: by 2002:a05:6602:2d83:: with SMTP id k3mr5513960iow.26.1614897278700;
        Thu, 04 Mar 2021 14:34:38 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:38 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: qualcomm: rmnet: use field masks instead of C bit-fields
Date:   Thu,  4 Mar 2021 16:34:29 -0600
Message-Id: <20210304223431.15045-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
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
2.20.1

