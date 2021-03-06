Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6217F32F7FC
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhCFDQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCFDQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:16:00 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3A4C061760
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:16:00 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id k2so4163265ioh.5
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v75WqFNEqmNfaFvo+fJoS+EBGR7oORQvhBv4GH6rgs0=;
        b=o4HiSXgu0idLl/ulWk8usLU0pMTEcPGiNrBY7cmCtob+2QUIgLgh0WGzC4tToMdqcr
         ZewxhKsdTKHknEEs/ImvzgvmJ93jjxcJiwWXxIFM2tNc4PiBVvQF/5uZkz3R19xRQKNq
         zi9SmowDHhzAR3r9x6aQo7zD0nF0PW+A2lMOf3iVEhOq1xLkai45OwKSdZnEAcpNPSQM
         aGic4P6rrBAGS0NqC9JN43LrD3koQJc7UQyG7jJFEe/rJKoertziZ57ucAhZucS48cY5
         /KCAZYk3zU2ptJDhGB/9gI1NnrxoUSFIkfCk7SrFS0fDbK0j/zOc8DDFmPp5QKXVgVuU
         4Maw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v75WqFNEqmNfaFvo+fJoS+EBGR7oORQvhBv4GH6rgs0=;
        b=dcIHRFDlKebD53Fq6DzKBARCZ+vqCODMY73AGGz4r3LKJ0MbESWiu7tKqdJ6Nuh0+/
         BUHZy/P559n44WqH14Bjkjz7mCLQM3/E5pjrMn6fVn/vBY4+gMulDPVuBLo7nImiz/9r
         J4YQPpdSMdupuLt5qTjy0lRJwLUxNPnghE2V507QNU15f+WXBr70C4+BgCdUzQIANoF9
         n6ziomqGMJKPzIFc7MXsGczYIknyPt4BrwrdJ83FrPihgnidMR645DwNWBurXTju8dJx
         ZFGKM2KNmcqJbZEvOvt2BW9VuDgerpfAEOeFtQ6uCbR3lHdkbmmcEvYmVQ3R/MSCau+a
         zYxQ==
X-Gm-Message-State: AOAM5322e9eyknGrwB38ml/VfRH//QCYT52nVcR2uxOSyecUsRp/NWyi
        F/34/e0D5QKTAJzmFVoNrEq0GI4UNB0BDA==
X-Google-Smtp-Source: ABdhPJweLcMc/ise0niUmOJXyK4ZVWQSoaa4YWoBzVuIsaW+t6Ln0kznijsuH/q4GGXlHy6s8JJ/Eg==
X-Received: by 2002:a02:9985:: with SMTP id a5mr13152384jal.122.1615000559695;
        Fri, 05 Mar 2021 19:15:59 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
Date:   Fri,  5 Mar 2021 21:15:49 -0600
Message-Id: <20210306031550.26530-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210306031550.26530-1-elder@linaro.org>
References: <20210306031550.26530-1-elder@linaro.org>
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
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c    |  2 +-
 include/linux/if_rmnet.h                        | 17 +++++++----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 3291f252d81b0..29d485b868a65 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -365,7 +365,7 @@ int rmnet_map_checksum_downlink_packet(struct sk_buff *skb, u16 len)
 
 	csum_trailer = (struct rmnet_map_dl_csum_trailer *)(skb->data + len);
 
-	if (!csum_trailer->valid) {
+	if (!u8_get_bits(csum_trailer->flags, MAP_CSUM_DL_VALID_FMASK)) {
 		priv->stats.csum_valid_unset++;
 		return -EINVAL;
 	}
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 4824c6328a82c..1fbb7531238b6 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -19,21 +19,18 @@ struct rmnet_map_header {
 #define MAP_PAD_LEN_FMASK		GENMASK(5, 0)
 
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
+	u8 flags;			/* MAP_CSUM_DL_*_FMASK */
 	__be16 csum_start_offset;
 	__be16 csum_length;
 	__be16 csum_value;
 } __aligned(1);
 
+/* rmnet_map_dl_csum_trailer flags field:
+ *  VALID:	1 = checksum and length valid; 0 = ignore them
+ */
+#define MAP_CSUM_DL_VALID_FMASK		GENMASK(0, 0)
+
 struct rmnet_map_ul_csum_header {
 	__be16 csum_start_offset;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-- 
2.27.0

