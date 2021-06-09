Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2460E3A2039
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhFIWiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:38:13 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:42598 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhFIWiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:38:11 -0400
Received: by mail-io1-f42.google.com with SMTP id k22so24604647ioa.9
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MjaLCCuhPqeJB8iNJffoDPKJK2p3mA4oFWzwOxWZ3Gw=;
        b=E2TZ9ZBGuLHUiQK7Yms2LgZqA8CQbRI52tWDzbVotpLaCpPqFveHfFyQ4JGEVhcRoz
         Y0Szz2VwkJX+cD0aaqWPL5gADQqxpY6L5DXl6Uhhh0mZVQg4EVoHsfxbQCF/I4B9B7Vn
         ZHcn0y5Nj862uB7UwJStB4DMxbVJqhCw9iy8fiK391dscbkxWHeLaoyeKvafLsvntoyL
         cANjDfBL79EJfmEpg/8cV1cZfeuilQxTwD38zBsJ4u6d0PfnCTIcZr10M8g6ugTFO9I3
         jCcCs/583CdKsfWlTsf6MgjnL9NL82QS3Bi7YKencTm440dJR1rb4GVKQJYpxKE2+R2I
         TrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjaLCCuhPqeJB8iNJffoDPKJK2p3mA4oFWzwOxWZ3Gw=;
        b=VPnDemRHeZh6EBCxam9wzcJPg3sQY+2K7dYghYZPpy093iXmHz9KMpNhBIfjiP+CWK
         fM1oAT3dRN0McvqWiog2p8gxNXMFvMWililMWLV/0OtZr2jK/dG0rz9dL5WS5ptck5sn
         XUOW7ZXZYUvou6hdQPNNgBpnluWvrDlflV4d1ZNGqu6Tsv55LYJ5tLk7JZdtarAUyvzo
         K3pmJN6DEu0dGf/bh6a7l6cUTECKS4awcL2l3Ua8pCiSxIYQ8c+Kh92vvZh4wXl4+4mc
         OknHm0JWRib8ikZwmRfDBXLGriGqhCALeyBZ2Ri3Y7S8xG4ahkK76PQ51DkktmiEO8sg
         DdPw==
X-Gm-Message-State: AOAM533LaqjAbj7al1Egd9topz9IeYzMtsSxUhS+JZevtBCQ035ekmEl
        RXltWb8dNejQmQqhCQcPkPhsXPcDWSBL911b
X-Google-Smtp-Source: ABdhPJzidWM2NyA5/lLxV57Hs64dJ8zxd24pSEobv7sxyj2/5GPr7tAfmtNOym13cCaEOE+k5Voc+Q==
X-Received: by 2002:a02:8784:: with SMTP id t4mr1614284jai.26.1623278116257;
        Wed, 09 Jun 2021 15:35:16 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:15 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/11] net: ipa: flag duplicate memory regions
Date:   Wed,  9 Jun 2021 17:35:02 -0500
Message-Id: <20210609223503.2649114-11-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test in ipa_mem_valid() to ensure no memory region is defined
more than once, using a bitmap to record each defined memory region.
Skip over undefined regions when checking (we can have any number of
those).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index e5ca6a2ac626a..7b79aeb5f68fc 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -217,6 +217,7 @@ static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 /* Verify each defined memory region is valid. */
 static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 {
+	DECLARE_BITMAP(regions, IPA_MEM_COUNT) = { };
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_mem_id mem_id;
 
@@ -229,6 +230,14 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 	for (mem_id = 0; mem_id < mem_data->local_count; mem_id++) {
 		const struct ipa_mem *mem = &mem_data->local[mem_id];
 
+		if (mem_id == IPA_MEM_UNDEFINED)
+			continue;
+
+		if (__test_and_set_bit(mem->id, regions)) {
+			dev_err(dev, "duplicate memory region %u\n", mem->id);
+			return false;
+		}
+
 		/* Defined regions have non-zero size and/or canary count */
 		if (mem->size || mem->canary_count) {
 			if (ipa_mem_valid_one(ipa, mem))
-- 
2.27.0

