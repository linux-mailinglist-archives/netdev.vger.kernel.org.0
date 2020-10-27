Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB5B29BACE
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807671AbgJ0QMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:12:54 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37918 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807544AbgJ0QLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:35 -0400
Received: by mail-io1-f67.google.com with SMTP id y20so2127523iod.5
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vdv8LjT2CgfUj8c+ccLLrRWl2zDtGgEY+2d5t9DuZoQ=;
        b=ezLz5t4Watnu8iYcnTyQEwoLmhxFfGy4kPGwfZ86E19HsahqY6zaqLXAlmA4z4mVFa
         MMUz7enZq7mit3DZosxtSNBAntOA6JLb15t04kakk32aYvD0kbkP6t9HPbWpFPYYlpW8
         IEp6YbPP8KHlGkh4AlcP11eeWzuAEUTBaZMl1Q4tVPt/bQJL+PYTSrmBPPdrHFqcI/rW
         BcPd5i9q5KadZobPhBgbPLcfgBms3A+FPf/8VkvE3FpM5v9KwB1n08+t37x5MI/F2o5P
         u5Ruo8Bh/C2+1OVSyhEe/G8lx8GTCuN747+OfdQwJD8wTge11T7yMRQIw92+hFgU5Qaz
         yopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vdv8LjT2CgfUj8c+ccLLrRWl2zDtGgEY+2d5t9DuZoQ=;
        b=sW8pdKF1kbF3jnDiicNszrGgqund6FH146T7Vd+6oUDpZ2xIrC9V6jZ9Be9GSG/N8U
         gM+PDwwxVzU2TLzJX85JkRCSCbLlMlm9tQ8BzRnw6L8WmH8k3UMZDvpH1X+fUIBtRCdf
         KnE3Slu/oAvvs1bVJ7mYHJAC7BKm1/yrKEb5zkC65LetfjuDfB1oVEBGFxij/FIEyCUm
         sX78r7PIVx5c1kniOkZC8GlnVii3zg09regczoTEkp4okQZH7AmkSn7E3ksaHCwoRWcC
         cNTBIIpM+zIGGilHP+SNVJQ8nxi0W9Ff6sWk75xfNTVwBbbif/l80pqG7rdQteLVxjqW
         0dhw==
X-Gm-Message-State: AOAM5324a+aJs5waHCyOQgQP9HozMGiOHmcdUImsojyTFIbvqxfACZmD
        mHQbhts/dMfAIZlDpWtX6/b1ZQ==
X-Google-Smtp-Source: ABdhPJzsG65sUR7AqIjdbpLtCTJXH5+gPLrpkrFPxzoI2R5xM8lFDvuk5lM7nqqHuzEBxRVqxl4nGw==
X-Received: by 2002:a02:cd2c:: with SMTP id h12mr3176363jaq.138.1603815094306;
        Tue, 27 Oct 2020 09:11:34 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 5/5] net: ipa: avoid going past end of resource group array
Date:   Tue, 27 Oct 2020 11:11:20 -0500
Message-Id: <20201027161120.5575-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201027161120.5575-1-elder@linaro.org>
References: <20201027161120.5575-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The minimum and maximum limits for resources assigned to a given
resource group are programmed in pairs, with the limits for two
groups set in a single register.

If the number of supported resource groups is odd, only half of the
register that defines these limits is valid for the last group; that
group has no second group in the pair.

Currently we ignore this constraint, and it turns out to be harmless,
but it is not guaranteed to be.  This patch addresses that, and adds
support for programming the 5th resource group's limits.

Rework how the resource group limit registers are programmed by
having a single function program all group pairs rather than having
one function program each pair.  Add the programming of the 4-5
resource group pair limits to this function.  If a resource group is
not supported, pass a null pointer to ipa_resource_config_common()
for that group and have that function write zeroes in that case.

Fixes: cdf2e9419dd91 ("soc: qcom: ipa: main code")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 89 +++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 74b1e15ebd6b2..09c8a16d216df 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -370,8 +370,11 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	u32 i;
 	u32 j;
 
+	/* We program at most 6 source or destination resource group limits */
+	BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
+
 	group_count = ipa_resource_group_src_count(ipa->version);
-	if (!group_count)
+	if (!group_count || group_count >= IPA_RESOURCE_GROUP_SRC_MAX)
 		return false;
 
 	/* Return an error if a non-zero resource limit is specified
@@ -387,7 +390,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	}
 
 	group_count = ipa_resource_group_dst_count(ipa->version);
-	if (!group_count)
+	if (!group_count || group_count >= IPA_RESOURCE_GROUP_DST_MAX)
 		return false;
 
 	for (i = 0; i < data->resource_dst_count; i++) {
@@ -421,46 +424,64 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
 
 	val = u32_encode_bits(xlimits->min, X_MIN_LIM_FMASK);
 	val |= u32_encode_bits(xlimits->max, X_MAX_LIM_FMASK);
-	val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
-	val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+	if (ylimits) {
+		val |= u32_encode_bits(ylimits->min, Y_MIN_LIM_FMASK);
+		val |= u32_encode_bits(ylimits->max, Y_MAX_LIM_FMASK);
+	}
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-static void ipa_resource_config_src_01(struct ipa *ipa,
-				       const struct ipa_resource_src *resource)
+static void ipa_resource_config_src(struct ipa *ipa,
+				    const struct ipa_resource_src *resource)
 {
-	u32 offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	u32 group_count = ipa_resource_group_src_count(ipa->version);
+	const struct ipa_resource_limits *ylimits;
+	u32 offset;
 
-	ipa_resource_config_common(ipa, offset,
-				   &resource->limits[0], &resource->limits[1]);
-}
+	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 1 ? NULL : &resource->limits[1];
+	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
-static void ipa_resource_config_src_23(struct ipa *ipa,
-				       const struct ipa_resource_src *resource)
-{
-	u32 offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	if (group_count < 2)
+		return;
 
-	ipa_resource_config_common(ipa, offset,
-				   &resource->limits[2], &resource->limits[3]);
-}
+	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 3 ? NULL : &resource->limits[3];
+	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
-static void ipa_resource_config_dst_01(struct ipa *ipa,
-				       const struct ipa_resource_dst *resource)
-{
-	u32 offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	if (group_count < 4)
+		return;
 
-	ipa_resource_config_common(ipa, offset,
-				   &resource->limits[0], &resource->limits[1]);
+	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 5 ? NULL : &resource->limits[5];
+	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 }
 
-static void ipa_resource_config_dst_23(struct ipa *ipa,
-				       const struct ipa_resource_dst *resource)
+static void ipa_resource_config_dst(struct ipa *ipa,
+				    const struct ipa_resource_dst *resource)
 {
-	u32 offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	u32 group_count = ipa_resource_group_dst_count(ipa->version);
+	const struct ipa_resource_limits *ylimits;
+	u32 offset;
+
+	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 1 ? NULL : &resource->limits[1];
+	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
+
+	if (group_count < 2)
+		return;
+
+	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 3 ? NULL : &resource->limits[3];
+	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
+
+	if (group_count < 4)
+		return;
 
-	ipa_resource_config_common(ipa, offset,
-				   &resource->limits[2], &resource->limits[3]);
+	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	ylimits = group_count == 5 ? NULL : &resource->limits[5];
+	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 }
 
 static int
@@ -471,15 +492,11 @@ ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 	if (!ipa_resource_limits_valid(ipa, data))
 		return -EINVAL;
 
-	for (i = 0; i < data->resource_src_count; i++) {
-		ipa_resource_config_src_01(ipa, &data->resource_src[i]);
-		ipa_resource_config_src_23(ipa, &data->resource_src[i]);
-	}
+	for (i = 0; i < data->resource_src_count; i++)
+		ipa_resource_config_src(ipa, data->resource_src);
 
-	for (i = 0; i < data->resource_dst_count; i++) {
-		ipa_resource_config_dst_01(ipa, &data->resource_dst[i]);
-		ipa_resource_config_dst_23(ipa, &data->resource_dst[i]);
-	}
+	for (i = 0; i < data->resource_dst_count; i++)
+		ipa_resource_config_dst(ipa, data->resource_dst);
 
 	return 0;
 }
-- 
2.20.1

