Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFC33C8DB
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhCOVwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbhCOVwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:52:01 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28757C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:01 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id k2so10849216ili.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKWpv2lC6idRAW4U2uy3fxWpPmNFe54usond8BqeY/A=;
        b=WT2SPDCt/BK2FqNOeKVfL1HqHZKyUA2Fk0ToapiSvU7lZKzAPSeWBRUQaqt7Z+DwxF
         BuTLK50vY0YWuCAubl4C5Kax6XAe+05A6XwEOTy5KG2tF8iZLUofEPyCJ2Mz8x9fUKtl
         KVxl44arefLIEsu/uQ8+Q2d79Rhto30uV5VYJlEV3+yIdAAKSUSMA54tIVV+OdU4c/fD
         Nlz6c6nHRFoFRn51lQ+o3e60TpqqfKVuujxd3iesHfvc+glT59tiyowIooaQTGvHbrjx
         XIc0rr/PujF9CZxruUypmthmiDFDZU19ZK9QEUyAQgaLwI6sTME4TZ2GfRatB0yxksve
         Z7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKWpv2lC6idRAW4U2uy3fxWpPmNFe54usond8BqeY/A=;
        b=Yw6I0SYsQaSMwifI3ljAGk+Rp7YPLlCYr7H8TnrRmFcRkRHmQPKPDWSo/DMRmMQ1Ww
         30qFAj9ugjgNsUIBRxJQ4Xhro5VHAXMlJ2i8bnqMjthL77aKIpfUmAEWXgphU1Gh2qEf
         ZZq4qSO5SOUHCWia9PjHYDjMxj9PCGbhiyC2KFpGdiZ7WUGrdP+3pt9xj/VwqjMohGW/
         WGP9AG9z6uGBsdKrNkNzVn3qZP2eRU8Kj9+TIKQE5aoULpyaLAeeOoRRWkofHQF5oRX7
         f9BKMviY0jWBlrYXYRU3oS8RRoXTaFIrl3SGNn99APhhsp2+57goLZmDaZKXtQcUv/Jx
         m8nw==
X-Gm-Message-State: AOAM533HzFSE/PzGfflKRvDvTSBWkb3UPmtwUctWYfWRjHE7dx7fdvcO
        fdjHtxQig9s9y90anwdMOH0ZZw==
X-Google-Smtp-Source: ABdhPJzMqO2+Iipj2Mb3BD3O1Tg9iDpTmuo1wMomjWWtuNHJWPwLB790ppYvyTHfRibQyUMGi4rrWA==
X-Received: by 2002:a05:6e02:1044:: with SMTP id p4mr1376472ilj.238.1615845120635;
        Mon, 15 Mar 2021 14:52:00 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y3sm7424625iot.15.2021.03.15.14.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:52:00 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v6 5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
Date:   Mon, 15 Mar 2021 16:51:50 -0500
Message-Id: <20210315215151.3029676-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315215151.3029676-1-elder@linaro.org>
References: <20210315215151.3029676-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
structure with a single one-byte field, using constant field masks
to encode or get at embedded values.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
---
v3: - Use BIT(x) and don't use u8_get_bits() for the checksum valid flag

 .../ethernet/qualcomm/rmnet/rmnet_map_data.c    |  2 +-
 include/linux/if_rmnet.h                        | 17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index e7d0394cb2979..c336c17e01fe4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -359,7 +359,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 
 	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
 
-	if (!csum_trailer->valid) {
+	if (!(csum_trailer->flags & MAP_CSUM_DL_VALID_FLAG)) {
 		priv->stats.csum_valid_unset++;
 		return -EINVAL;
 	}
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index a02f0a3df1d9a..941997df9e088 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -19,21 +19,18 @@ struct rmnet_map_header {
 #define MAP_CMD_FLAG			BIT(7)
 
 struct rmnet_map_dl_csum_trailer {
-	u8  reserved1;
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	u8  valid:1;
-	u8  reserved2:7;
-#elif defined (__BIG_ENDIAN_BITFIELD)
-	u8  reserved2:7;
-	u8  valid:1;
-#else
-#error	"Please fix <asm/byteorder.h>"
-#endif
+	u8 reserved1;
+	u8 flags;			/* MAP_CSUM_DL_VALID_FLAG */
 	__be16 csum_start_offset;
 	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
+/* rmnet_map_dl_csum_trailer flags field:
+ *  VALID:	1 = checksum and length valid; 0 = ignore them
+ */
+#define MAP_CSUM_DL_VALID_FLAG		BIT(0)
+
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

