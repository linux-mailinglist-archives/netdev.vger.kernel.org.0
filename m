Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8F29D759
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbgJ1WXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732731AbgJ1WWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:22:51 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0247C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:22:50 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b69so506152qkg.8
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nP3MQU8G+NZhAzitdmwy6AlCbQvBr5GUXkIbmBlAkpw=;
        b=sZI9EN1o4DdLSN0nkdlMc0F05VxohxEjHcdqbRDc8xUh73UKjUwd+xiZu6dTFBCVhF
         YlpT0NN4s0boGSj9Wonvwk5teEYQk9svAgU6xXIpfjq43GLV5bcuJRtSW8SEG0lRwAfS
         3EfR4NqI81KRV8/ctmHrKu/smncjn2131FU2Mgp6DZPoRxK//WTpn8DAl4+0p7BQP8lH
         RznzugM8jWV4ZVAkK8dK1H1cJNCgkR2Kp/3W9E4R0iBYNwcTFiwKIQwJwQqdffub0SX3
         bOcOIudsYbozLBJaSr8+9UtELeJ1sYtamAuxy95n1FMLJl9qwNxIJbx7AeJBEQMcFVV0
         Bi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nP3MQU8G+NZhAzitdmwy6AlCbQvBr5GUXkIbmBlAkpw=;
        b=d0Z5lbr+cltT2EMhmqYa0xonY8LUIyZxHqzJ53YBakCQyfcb82L5TtGFvJtl3bkkZ8
         1rMX3K1P6m9ufycWdvxmsDu+GSLzBQ4n5DmhV2VvSa83m3pgHZgUn4KJXdnGwbTzbSL+
         zeU7JTi8rpCp4HTY+2JjWZc62lJQB+OW4sfUQ/WQ+7IMgLkE2qnGME+toJomKBCQh4oQ
         ilmNAHuHVucSjtWDJnnpj2iPDSlVBOo7T/zc/uMfj/4/9wmK+BiJ3nMnmZb9RemyhPZt
         HOddVa/Mb8VEigey/s9UPsf6elJnqoDNyVB7ap53Z5pTPqWXr/7zv3g/jIa4bf3qqRHQ
         98gw==
X-Gm-Message-State: AOAM532oNSPDQECi05/urD+/CrCjVPtjEN0jCVU+ELy0G8rxZnNep5g8
        nlCb5NzVclkbIyr1cs77W9EbgqpPvfvPYc4R
X-Google-Smtp-Source: ABdhPJxWkVqYKo0f/78uYBARYXx/X8aXb6FzydzdsvrrY9i1JSW/wuO7rV4BwSp9AtLC8R/RuTWqmA==
X-Received: by 2002:a05:6638:2208:: with SMTP id l8mr740026jas.22.1603914120719;
        Wed, 28 Oct 2020 12:42:00 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m66sm359828ill.69.2020.10.28.12.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 12:42:00 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 5/5] net: ipa: avoid going past end of resource group array
Date:   Wed, 28 Oct 2020 14:41:48 -0500
Message-Id: <20201028194148.6659-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028194148.6659-1-elder@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
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
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Fixed comparison error identified by Willem de Bruijn.

 drivers/net/ipa/ipa_main.c | 89 +++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 74b1e15ebd6b2..f4dd14d9550fe 100644
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
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_SRC_MAX)
 		return false;
 
 	/* Return an error if a non-zero resource limit is specified
@@ -387,7 +390,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	}
 
 	group_count = ipa_resource_group_dst_count(ipa->version);
-	if (!group_count)
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_DST_MAX)
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

