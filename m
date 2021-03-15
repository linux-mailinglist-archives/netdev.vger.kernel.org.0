Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8085433C61A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhCOSuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhCOStj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 14:49:39 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC76C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:38 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id o11so34591962iob.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 11:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jKWpv2lC6idRAW4U2uy3fxWpPmNFe54usond8BqeY/A=;
        b=GshvCtSdibj2Ffh/vsYup4grJLYSBDrLhGFzj8q7C2rsrUWkzrGgiNA/JGfpzuREt/
         +z30ti8N7gKvy/Ar8+Czba+I3X+RoeQtsJYT7GJQIKeb1MydifhTy5ZTtsAuNc7r+UoT
         ZkDrpwaBP0iVnYaB8JN6rZRZp+5hCBEYLbELrGnAMTcSIhvgYxU7qkqOQ1v4e0T5cY3E
         MatXOqMHnSaW+uDQjC8vERY5EuhIwT7ofjB1lOc2wqydqRXkViOBkc+PWS+ONVV/Mujh
         oHxWj0CyOhdFojKrY2dH6VbuHJFna0BSyUxyB7ul92IbWm513OMqrkoqJ2HpMrOgxA9G
         nTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jKWpv2lC6idRAW4U2uy3fxWpPmNFe54usond8BqeY/A=;
        b=ZpkUh8mvw+1LIoq1ZwOF3nlVJP4r9sZtCOFimeM9RI8ZtXFNslnSAAigbMdr2B7WJd
         na+MahBQmoz26jfMlip9bHVd5LvNp15XnETKrxb1NSGAlBSBaGcZRgTU8EjUByPthyzw
         4J4ge693RfITp66J4iiboy79PLlJFGKlqIOKYZ2xbxq53njQZuMOrSLfvpeWKjwWMEAo
         V8YZsZh3OsfPrwzuV8yfvh/zqHVfcSynvKfSXNOHyZbooaHGD8gkwJIr23Or+yt27Vhx
         xMjU/znXew6m+EeZIUYfxEXxuTP90GwAfVwx4dWlZUA5HheFDdxiLoRIl96UCT1jKLut
         xPbw==
X-Gm-Message-State: AOAM531MU2E2O+ZYD+nF8DcRhxPRnugZXS6aSBRvG3XdkgCYYlEE5wRk
        hRtmdhmWNxttNPCu+iMZBj5FKg==
X-Google-Smtp-Source: ABdhPJx75Z0hNEPSA2mIGdL/bS4OvWvLxRiLo4nVeh0ZU4azGr2SFrGanXb1A3JmMIbhjh8iC6edrA==
X-Received: by 2002:a5e:cb4c:: with SMTP id h12mr668803iok.183.1615834178223;
        Mon, 15 Mar 2021 11:49:38 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a5sm8212162ilk.14.2021.03.15.11.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 11:49:37 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        David.Laight@ACULAB.COM, olteanv@gmail.com,
        alexander.duyck@gmail.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5 5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
Date:   Mon, 15 Mar 2021 13:49:27 -0500
Message-Id: <20210315184928.2913264-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210315184928.2913264-1-elder@linaro.org>
References: <20210315184928.2913264-1-elder@linaro.org>
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

