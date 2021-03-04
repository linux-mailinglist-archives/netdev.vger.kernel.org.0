Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D48A32DD26
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbhCDWeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhCDWel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 17:34:41 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C08C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 14:34:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id i18so148881ilq.13
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 14:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dqfVD44TkK3usd1mQweHKY2fltJlJNKQWu+x3+YLrx8=;
        b=LxZjtMdwVi1XkqzUFyHPVfOnN+aQagcCZLKwyxir0fVx75Av3MXALiVChEq1IwHJ3z
         w2ZX1lX+prMbcBACRU5vxpjcnAuyc6EJ4Tgx8bGuQJ5XrJLbSLrPhAIX4LiIYuBmlWyx
         WF3dSsJIhmv9t/ioU9c9wtvBD+rcjmtrJo7yKWcjStNOitB94bqZS0Q8xjjTyK+F9M23
         Q3C1pNNLo8VFGQKbMslmZp9i7CaTsUYvUfj3SSTlfrMJ4gFbqYP18kkhCx85zmq9PDJm
         SzE6EpqhiEq/l8l2eu8MIcrNeIuH98si3sIqRaWiC1Vsatq6ZS3oD8V9utj7JhK3u9vr
         Iu4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dqfVD44TkK3usd1mQweHKY2fltJlJNKQWu+x3+YLrx8=;
        b=pdbVD9f4Y8V/9qsTfdEjZrP14/cpLlvsAh9SDCSXcOozEHAfgZ4oi6vgZyTQOek3ts
         BmHL4M712QV7Oz8mLNS4eV7vqjFhbeaWcdhsjkR+OVwxiyp9X21ZE9HwX0zoILsXR58w
         0WbE9XtcO9H3iMxbcY+b9VtgSmUoG3hffWgtqmUe4ArL5NevccAB3Vo76P7o6ogBZZ4F
         a+zv1FdpVCsqpWFSziGAER5zToECr8t3Y2OOGk6lG9rJ7Xg3j2P8UgzQPK9S8Z3RvaEH
         CR8FjkjRq+7hg7Km95mWMe1GnxSX1/5Db7DrKU4fGTpfsoNxZ5f5xMKEYHb8uX+NiDGk
         dl8g==
X-Gm-Message-State: AOAM530iHrAYGau+cI0GzVo1+p0I++oYXvzrLecFg9CGkHi5M2qr1Lrf
        Xg4bVs6yh4NTpUbtPWEre5oVmQ==
X-Google-Smtp-Source: ABdhPJzILta4g3Xcf50Xt0zb78KJ5CcS3Xk8xZRItLD0SD1MaNv6iUHEC+CHXGhRahrq3j1EZLNWAA==
X-Received: by 2002:a92:d7ce:: with SMTP id g14mr5615815ilq.255.1614897279593;
        Thu, 04 Mar 2021 14:34:39 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s18sm399790ilt.9.2021.03.04.14.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 14:34:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
Date:   Thu,  4 Mar 2021 16:34:30 -0600
Message-Id: <20210304223431.15045-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210304223431.15045-1-elder@linaro.org>
References: <20210304223431.15045-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the use of C bit-fields in the rmnet_map_dl_csum_trailer
structure with a single one-byte field, using constant field masks
to encode or get at embedded values.

Signed-off-by: Alex Elder <elder@linaro.org>
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
2.20.1

