Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE4238E9
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 15:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390696AbfETNyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 09:54:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45891 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732434AbfETNyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 09:54:05 -0400
Received: by mail-io1-f66.google.com with SMTP id b3so11031673iob.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 06:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=njKYp+14ITtVWnHaTIS/znCm9EIrcpgkV5g8TLL3fv0=;
        b=P0r2Nz9M5k5sdUMKG8tZN6/xXI3z2RMasXRwJ6C6IeCz245s8PRpWOVSujb7b9MgyZ
         J9/23EYY+ddUAUrMZfay1vIRvXEYHtG0hgkeSCVzvMevIlhSks1nyvB39qMm5SDJ1eGA
         BNG5V3yHIpt/nBHeGeT2bHxz/w8RAvaWxH4Tocn/u83KGX2u/CAyCKsAlG4UfjmeL0UE
         ebkV8fpgkCucrce5oUMX+XrHRZHReuOACoOcTTPouoyUp0MvZHd70Sxxhy9Hrocqf59x
         mYBWhTiIugfAAZMLNxxUDAJxJh3D0s0zOqlJNAX883i+rNwOr+FuGKKyonpz2Hu5Al+6
         uJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=njKYp+14ITtVWnHaTIS/znCm9EIrcpgkV5g8TLL3fv0=;
        b=DfzbSnvWZxh8AVvg2umSWYXVo3F7zS0RcwOvHF353bf9rXB+4K7EAqSX5xLPo3DgLp
         BpqTaCplHaqvadc7B5CyeTeLu4YBKfRxnmgUxXx8x16UTOiG9WPO55Zc0OVjhMahlajl
         o7/EaEcciFjSxmBg/UltH4Bcy0ppJyItYbRNEJevJ4LtLIm8+WtPjW/64d6P8pm0vmUD
         ERkqA4HA0EqLt3dFF5iqRC7k/K4+XsGu+oUl4eBCJT/lyE/PS5ZjVldmRyovgJtSc9vq
         ZtJCU6mA1C2V8Anb0QByiXjISVLwaXHGiOXPAcX1c/4jr3RyBlrj+nLQ78rIGH2AsqNM
         PNBA==
X-Gm-Message-State: APjAAAXtESRG2AgoX40gYnB6wszHIUCNyrZVMtA7lKdiFFIG6EksRBxL
        AzUOsPd49JvvUgp4b1qRrWukzw==
X-Google-Smtp-Source: APXvYqzj/S+XU04Ps+YBm6sesJFVcrQUv1xkS+ABddiyL4gw5WNdxLtQz26sYD5Yo18XZ6vi6RzsIw==
X-Received: by 2002:a5d:9687:: with SMTP id m7mr6337627ion.229.1558360444278;
        Mon, 20 May 2019 06:54:04 -0700 (PDT)
Received: from localhost.localdomain (c-71-195-29-92.hsd1.mn.comcast.net. [71.195.29.92])
        by smtp.gmail.com with ESMTPSA id n17sm6581185ioa.0.2019.05.20.06.54.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:54:03 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     arnd@arndb.de, subashab@codeaurora.org, david.brown@linaro.org,
        agross@kernel.org, davem@davemloft.net
Cc:     bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] net: qualcomm: rmnet: use field masks instead of C bit-fields
Date:   Mon, 20 May 2019 08:53:49 -0500
Message-Id: <20190520135354.18628-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520135354.18628-1-elder@linaro.org>
References: <20190520135354.18628-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using C bitfields (e.g. int foo : 3) is not portable.  So stop
using them for the command/data flag and the pad length fields in
the rmnet_map structure.  Instead, use the functions defined in
<linux/bitfield.h> along with field mask constants to extract or
assign values within an integral structure member of a known size.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 5 +++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      | 8 +++++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 5 ++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 4c1b62b72504..5fff6c78ecd5 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/netdev_features.h>
 #include <linux/if_arp.h>
@@ -70,7 +71,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	u16 len, pad;
 	u8 mux_id;
 
-	if (map_header->cd_bit) {
+	if (u8_get_bits(map_header->cmd_pad_len, RMNET_MAP_CMD_FMASK)) {
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
 
@@ -78,7 +79,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
 	}
 
 	mux_id = map_header->mux_id;
-	pad = map_header->pad_len;
+	pad = u8_get_bits(map_header->cmd_pad_len, RMNET_MAP_PAD_LEN_FMASK);
 	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index a30a7b405a11..a56209645c81 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -40,13 +40,15 @@ enum rmnet_map_commands {
 };
 
 struct rmnet_map_header {
-	u8  cd_bit:1;
-	u8  reserved_bit:1;
-	u8  pad_len:6;
+	u8  cmd_pad_len;	/* RMNET_MAP_* */
 	u8  mux_id;
 	__be16 pkt_len;
 }  __aligned(1);
 
+#define RMNET_MAP_CMD_FMASK		GENMASK(0, 0)   /* 0: data; 1: cmd */
+#define RMNET_MAP_RESERVED_FMASK	GENMASK(1, 1)
+#define RMNET_MAP_PAD_LEN_FMASK		GENMASK(7, 2)
+
 struct rmnet_map_dl_csum_trailer {
 	u8  reserved1;
 	u8  valid:1;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 498f20ba1826..10d2d582a9ce 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/bitfield.h>
 #include <linux/netdevice.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -301,7 +302,9 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
 
 done:
 	map_header->pkt_len = htons(map_datalen + padding);
-	map_header->pad_len = padding & 0x3F;
+	/* This is a data packet, so cmd field is 0 */
+	map_header->cmd_pad_len =
+			u8_encode_bits(padding, RMNET_MAP_PAD_LEN_FMASK);
 
 	return map_header;
 }
-- 
2.20.1

