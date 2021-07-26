Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA1D3D64D1
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhGZQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbhGZQFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:05:00 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A35BC0617A3
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 09:45:10 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id r1so9554037iln.6
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 09:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xP0AMO1smf3f/g3BuMgB5g/Gkz29iY6fkAqpW8hERkA=;
        b=egVAZIreI5f9s+TkdRONsI3WnQBUt2mz0nhMRS0iJcXZnAYB3332Ek9VWkLT2ZadT3
         7E5TLTJCho8DPheOztM3wXbyPfekBkyn8aBPqqInFBjGpuBMHPWCjscp+DAg7mFnGFF0
         u44mbVZFYAv6yfVZsu0/OuB4lvcOgr2qdO7HO3rVA2WXzR7+6RT8G9ikNz4t2w2vQuzO
         KNRlgaJQ2COgbYdmzrWjjAoAX88N7wlnROVUMAyOSKRrrQWjvj1pH5fyFYRQdyri5Emd
         xFAgyTjlzdpSI3OmBkvKgJqsl377Wnw2QsUZOs1jYfPPopr6l6Pp6JuihnyxcmD9jq8j
         XD5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xP0AMO1smf3f/g3BuMgB5g/Gkz29iY6fkAqpW8hERkA=;
        b=ZL8B3vZn/v8ehaBouuy0NrQB8glknrQlogP3Ngsbn1WEa9KLB/jmQGDBSgcm+C5l2O
         CnAYS3EicwwrxJBpRI+cttQkIN/AfXE70cbzFbx+IG+nIv9eviGiqBF071KYNupCRHI5
         5456dyWfT1q58H9L79OxQBsQG9nss4lhA3MOWifukM1IGB6S9EE5QT885yb9ibviFgkb
         3qMpL91Mq37LFrZhqAYou4BJX7GdNahURwczm7J1ma4eWTEu5wanVg54jf7YydVWTJGg
         tRwXeSq8aNIssRieiyNL7ug7mNEIYcK7c1hVcpAWWyqwbeUwu0ZAdJKcKSYNN7Dt5aHD
         ypQA==
X-Gm-Message-State: AOAM532014+zFefnsqhkKBuyh3xHJHHTsjFj0xcwD9fOjaLTbwhJ5oRu
        Eu7khZ9A4yyZZbXwZxlm4tgnKQ==
X-Google-Smtp-Source: ABdhPJxDyHV4a/N6+0t2Oul4H1NPiCaWGYJheRhNWVPSquOqjLGkOlwMaZ9vUWQvp0VoOiyZaqUACg==
X-Received: by 2002:a92:8712:: with SMTP id m18mr13025054ild.132.1627317909970;
        Mon, 26 Jul 2021 09:45:09 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r198sm244436ior.7.2021.07.26.09.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 09:45:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/1] net: ipa: enable inline checksum offload for IPA v4.5+
Date:   Mon, 26 Jul 2021 11:45:04 -0500
Message-Id: <20210726164504.323812-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RMNet and IPA drivers both support inline checksum offload now.
So enable it for the TX and RX modem endoints for IPA version 4.5+.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-v4.11.c | 2 ++
 drivers/net/ipa/ipa_data-v4.5.c  | 2 ++
 drivers/net/ipa/ipa_data-v4.9.c  | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 598b410cd7ab4..782f67e3e079f 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -105,6 +105,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -128,6 +129,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
diff --git a/drivers/net/ipa/ipa_data-v4.5.c b/drivers/net/ipa/ipa_data-v4.5.c
index a99b6478fa3a5..db6fda2fe43da 100644
--- a/drivers/net/ipa/ipa_data-v4.5.c
+++ b/drivers/net/ipa/ipa_data-v4.5.c
@@ -114,6 +114,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -137,6 +138,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 798d43e1eb133..6ab928266b5c1 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -106,6 +106,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
+				.checksum       = true,
 				.qmap		= true,
 				.status_enable	= true,
 				.tx = {
@@ -129,6 +130,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.config = {
 				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
+				.checksum       = true,
 				.qmap		= true,
 				.aggregation	= true,
 				.rx = {
-- 
2.27.0

