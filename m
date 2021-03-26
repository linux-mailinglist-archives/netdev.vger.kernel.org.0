Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6934AB13
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhCZPMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhCZPLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:35 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D42C0613B5
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:34 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x17so5737402iog.2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/5IZFT/IwO11mtS+DXxe3NtvichQwOJMJ1ayd2gN1yo=;
        b=ixexIqirmRdA+c2o4TECW8V8V4Gwi+ZzcC0cLlqgrkkCjNUrNVWx9/v2SbU6xHFUNB
         OKwxejb4yKc22ZNjtaYKZ1jMPRV71zYwkP5vuUbW7NmgLGIouur87Rp5YinP0mhCBrfn
         Z/5IpULs+1me7bxb/jKmwuKuIqEaYGQbI51TY4UQrJC5aE0AbWyxvgAm2vROguaGKzyl
         QHrK2Z8uliO/ig6ejLTdTtvp6HhwB61i7F5tT6Fm/EQMFInaZDFokIuJVSLUvAqMpyMQ
         sWuyiIyNXz9i850Iur41SE+HrrIpUaAANh4tTqgZs8VDLrrqncsJSwmfjYFaWq7FHsEc
         Jz0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/5IZFT/IwO11mtS+DXxe3NtvichQwOJMJ1ayd2gN1yo=;
        b=aS/a5Csxx4Lq9bd3f/WkmKVvNIv36jZzAJgSjI8gxjUx6nl+2IsIhk8T8bCD4EKcuY
         MG6TapNj4WJq7x4Yr9uZRBRNb2GQ/Q9F+g6FVjDxfbvSc1gSJbJTcFpSMRkL5H8Uo1Fa
         KgdVhvC76xMuTUsFDD7oRDPPHpXBAZVtuEaIeWUTKo0L40Kmjjw/2lKvKucUoMmSMKL1
         AMmU8LcuczSmHiFBaNJTlpvDzXGM1nooCCkxHKty+zfeLQQ/GoIjIdqeGb+JptfHFY6o
         Z+eM3Ycwzvh5sHHqHkv8rtH0kj7oCgBDHmy6kEhQ+d8Vif7pI80pW65oxPfOK55XyUhg
         NDoQ==
X-Gm-Message-State: AOAM530VlhlMuxuzoICFAtP+/2OiDMsu1W8XUn5VHfM8dOZc32pxhFs1
        duthYYHK9a3FUWN8xEkRH7G6dA==
X-Google-Smtp-Source: ABdhPJw12BX+f0Iid23epG+hleKB1BWk29y55EqBGTjt5RmKpNlk31ys4BePoGKv/KEyST33vychdg==
X-Received: by 2002:a02:ccd9:: with SMTP id k25mr12310553jaq.43.1616771494040;
        Fri, 26 Mar 2021 08:11:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/12] net: ipa: combine source and destination group limits
Date:   Fri, 26 Mar 2021 10:11:18 -0500
Message-Id: <20210326151122.3121383-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace IPA_RESOURCE_GROUP_SRC_MAX and IPA_RESOURCE_GROUP_DST_MAX
with a single symbol, IPA_RESOURCE_GROUP_MAX.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h     | 11 +++++------
 drivers/net/ipa/ipa_resource.c | 10 +++++-----
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e1096d8ba5751..d6d14818a3968 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -47,8 +47,7 @@
  */
 
 /* The maximum value returned by ipa_resource_group_{src,dst}_count() */
-#define IPA_RESOURCE_GROUP_SRC_MAX	5
-#define IPA_RESOURCE_GROUP_DST_MAX	5
+#define IPA_RESOURCE_GROUP_MAX	5
 
 /** enum ipa_qsb_master_id - array index for IPA QSB configuration data */
 enum ipa_qsb_master_id {
@@ -206,18 +205,18 @@ struct ipa_resource_limits {
 
 /**
  * struct ipa_resource_src - source endpoint group resource usage
- * @limits:	array of limits to use for each resource group
+ * @limits:	array of source resource limits, indexed by group
  */
 struct ipa_resource_src {
-	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_SRC_MAX];
+	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_MAX];
 };
 
 /**
  * struct ipa_resource_dst - destination endpoint group resource usage
- * @limits:	array of limits to use for each resource group
+ * @limits:	array of destination resource limits, indexed by group
  */
 struct ipa_resource_dst {
-	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_DST_MAX];
+	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_MAX];
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 506bcccaef64f..38b95b6a5193d 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -77,10 +77,10 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	u32 j;
 
 	/* We program at most 6 source or destination resource group limits */
-	BUILD_BUG_ON(IPA_RESOURCE_GROUP_SRC_MAX > 6);
+	BUILD_BUG_ON(IPA_RESOURCE_GROUP_MAX > 6);
 
 	group_count = ipa_resource_group_src_count(ipa->version);
-	if (!group_count || group_count > IPA_RESOURCE_GROUP_SRC_MAX)
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
 	/* Return an error if a non-zero resource limit is specified
@@ -90,20 +90,20 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 		const struct ipa_resource_src *resource;
 
 		resource = &data->resource_src[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_SRC_MAX; j++)
+		for (j = group_count; j < IPA_RESOURCE_GROUP_MAX; j++)
 			if (resource->limits[j].min || resource->limits[j].max)
 				return false;
 	}
 
 	group_count = ipa_resource_group_dst_count(ipa->version);
-	if (!group_count || group_count > IPA_RESOURCE_GROUP_DST_MAX)
+	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
 	for (i = 0; i < data->resource_dst_count; i++) {
 		const struct ipa_resource_dst *resource;
 
 		resource = &data->resource_dst[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_DST_MAX; j++)
+		for (j = group_count; j < IPA_RESOURCE_GROUP_MAX; j++)
 			if (resource->limits[j].min || resource->limits[j].max)
 				return false;
 	}
-- 
2.27.0

