Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6661234AB12
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCZPMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbhCZPLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:36 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681BDC0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:36 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id c17so5298292ilj.7
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r8MCXM9rweH39xKCcaLePx4yJlcBdDekCxD8KpCehno=;
        b=FoGSzOJjyXBWowm3oGpug3mjAbOr+Qoo5WNMpnOnqGRqBh+yVQwzVexrvRrcfsKIrR
         KYXnEjyHC+sc6P7lLoabkx0Jca/PS+43CuYWuyfa9a4E++j/ZrIQ5C9gENlMopYDkf/k
         HYjeNduL55MCO6IeGGyPwYjnS8QLNeZV2lYMPq8qkbKrJrHLL1rXgQny+OqC0EilpIOI
         maHsBeK6JrHptQV0b2mNBZKkcpOb1vOSZK7i0nU94kBpP4/BFHkYVTFe7JtmJKYZz/56
         sZgj6Tf0ma0Ym7EsyGq5MmTqedpQTip8LKZn2nH2MOA+aSlkcDKyONl7HBpjFCeb2IXW
         Pufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r8MCXM9rweH39xKCcaLePx4yJlcBdDekCxD8KpCehno=;
        b=s6/hGrIXgrBJMcoGyR9uWjLgNvUfg8YWAnXammBGbKn0MTx20rzxdyPWC6ZehsEvSi
         k8rWQ/UHn4N5w4lLo9NayV+LHztbOkbNesZL8PhWcqvEI+I2lWQB+F4RivkQvsHgD73n
         HS2HYQ8Z7JPqjGPGegfkq84P7PVLyjf9au39RGbeLvboUGsvDQ5FGbzkavhvudlm6fpu
         262sWXKz3Mk7UyBJPBYiUqgJzv1HoSj/PKwjvhGcn6Mlh/0pMaEommxseU0CWhVCn0A6
         RMI8lKwWDUF9r4aiuwJAbzh7NcAaSVhQLybQZozZ6yocVVnwjuu0ILauDWM3piHmUblq
         gzaw==
X-Gm-Message-State: AOAM531IQHPjThD/xEpFR3z7pVWzUr0rUcMujosriN0sHGpAbYX4ETJO
        su+FJhQc9Ig41g0t+RBtqBr2pA==
X-Google-Smtp-Source: ABdhPJxOOktTg0EdNhNlv81jv+1OzSjThuYd7R/NoQC/JpgdUCvaE5gBdOcNcDr+uU8gdx1Gz8ulXg==
X-Received: by 2002:a05:6e02:781:: with SMTP id q1mr10855183ils.59.1616771495867;
        Fri, 26 Mar 2021 08:11:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/12] net: ipa: pass data for source and dest resource config
Date:   Fri, 26 Mar 2021 10:11:20 -0500
Message-Id: <20210326151122.3121383-11-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass the resource data pointer to ipa_resource_config_src() and
ipa_resource_config_dst() to be used for configuring resource
limits.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_resource.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index c7edacfa7d19d..3db4dd3bda9cc 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -129,12 +129,15 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
 }
 
 static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
-				    const struct ipa_resource *resource)
+				    const struct ipa_resource_data *data)
 {
 	u32 group_count = ipa_resource_group_src_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
+	const struct ipa_resource *resource;
 	u32 offset;
 
+	resource = &data->resource_src[resource_type];
+
 	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
@@ -155,12 +158,15 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 }
 
 static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
-				    const struct ipa_resource *resource)
+				    const struct ipa_resource_data *data)
 {
 	u32 group_count = ipa_resource_group_dst_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
+	const struct ipa_resource *resource;
 	u32 offset;
 
+	resource = &data->resource_dst[resource_type];
+
 	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
@@ -189,10 +195,10 @@ int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 		return -EINVAL;
 
 	for (i = 0; i < data->resource_src_count; i++)
-		ipa_resource_config_src(ipa, i, &data->resource_src[i]);
+		ipa_resource_config_src(ipa, i, data);
 
 	for (i = 0; i < data->resource_dst_count; i++)
-		ipa_resource_config_dst(ipa, i, &data->resource_dst[i]);
+		ipa_resource_config_dst(ipa, i, data);
 
 	return 0;
 }
-- 
2.27.0

