Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7263A202C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFIWhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhFIWhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:37:16 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24FDC0617AF
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:35:14 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id i17so28135876ilj.11
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcMIaajbznc6hYyMRbhNBSraS3zhVHZ7jf9G3+NJR/4=;
        b=DpAj19oKFE0na3zpXmKvdXRUqlQCWWA8/ecy5iFrAnEcoNt1HCnmIBTu0/rjeoWS+F
         NYGEM705Vm0fXIRja9kh2d5MA8qZ3MGOVY+r+BVX4w1QsX2HYK9NmI+NXoJ5ZSuCGy4o
         gadjjfekDXXY4CwzGg45sL4b+/j6YVp1VYBipBxMb2hpmMOjtUHnIw1a3JmTePDsd4r7
         9bdat8SlR43Dx5Um/wcGG5kzgUad0JW2F/vTJrHy9R3agfdVupqFCp4z9g0cJX2gZ5PQ
         D01uMmdAFWf88LoqP9esn81AUHOpjLR4Pl675uSJ2acHkTIoPaTqMuwTS5GFl7P6Vl+D
         0xCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcMIaajbznc6hYyMRbhNBSraS3zhVHZ7jf9G3+NJR/4=;
        b=aHVU7xi9TfrfHsXeM+xXVPFXXCTkFdbY6HisZfbUSTAgVGHR7bq2OduvKWoh/IKWuP
         lu3rLilQeoszN6UwFxYFtIWRbTKF/2ZSEnG0E8pxfwK83Lp3nthcUXE5ow+miXLROihu
         OZnJFLPzJOBiUsQ3oP0Xnqa/qSwe1lOP09riM6lEIeblWp/I4qEwAO7QcNu7KgkfwZKL
         bAXkvVcI+ZxNbecYWwm0gD+84gVgN8T2IM/+VaIeiulicb5p6Fd2Oed77nQJNpCFi2u0
         570V3X0TvOaytoZ8iY0kiJjhuCOug/QQDMLBxBjcZQgXFYNt9ep6Nyz0kTF+nYyyFwjK
         Qusw==
X-Gm-Message-State: AOAM532YPtWu4q37aAnuzCSnRK/z2CiBsAyTxdHqLyfGs6wWgyTjruC8
        fExpsLIyPUlpe7lzlBA3mYOpJw==
X-Google-Smtp-Source: ABdhPJzMHPE80Ul7zhiuDaboHknpQMsVLheVy3XqyNDOCQRmISTJ95MbUGF1QvztpU6lvniBf3JXvw==
X-Received: by 2002:a05:6e02:12ef:: with SMTP id l15mr1457316iln.153.1623278114351;
        Wed, 09 Jun 2021 15:35:14 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:14 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/11] net: ipa: introduce ipa_mem_id_optional()
Date:   Wed,  9 Jun 2021 17:35:00 -0500
Message-Id: <20210609223503.2649114-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new function that indicates whether a given memory
region is required for a given version of IPA hardware.  Use it to
verify that all required regions are present during initialization.

Reorder the definitions of the memory region IDs to be based on
the version in which they're first defined.  Use "+" rather than
"and above" where defining the IPA versions in which memory IDs are
used, and indicate which regions are optional (many are not).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 42 +++++++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_mem.h | 21 ++++++++++----------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index cb70f063320c5..29c626c46abfd 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -99,6 +99,36 @@ int ipa_mem_setup(struct ipa *ipa)
 	return 0;
 }
 
+/* Must the given memory region be present in the configuration? */
+static bool ipa_mem_id_required(struct ipa *ipa, enum ipa_mem_id mem_id)
+{
+	switch (mem_id) {
+	case IPA_MEM_UC_SHARED:
+	case IPA_MEM_UC_INFO:
+	case IPA_MEM_V4_FILTER_HASHED:
+	case IPA_MEM_V4_FILTER:
+	case IPA_MEM_V6_FILTER_HASHED:
+	case IPA_MEM_V6_FILTER:
+	case IPA_MEM_V4_ROUTE_HASHED:
+	case IPA_MEM_V4_ROUTE:
+	case IPA_MEM_V6_ROUTE_HASHED:
+	case IPA_MEM_V6_ROUTE:
+	case IPA_MEM_MODEM_HEADER:
+	case IPA_MEM_MODEM_PROC_CTX:
+	case IPA_MEM_AP_PROC_CTX:
+	case IPA_MEM_MODEM:
+		return true;
+
+	case IPA_MEM_PDN_CONFIG:
+	case IPA_MEM_STATS_QUOTA_MODEM:
+	case IPA_MEM_STATS_TETHERING:
+		return ipa->version >= IPA_VERSION_4_0;
+
+	default:
+		return false;		/* Anything else is optional */
+	}
+}
+
 static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 {
 	struct device *dev = &ipa->pdev->dev;
@@ -149,8 +179,20 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem_data *mem_data)
 		if (mem->offset)
 			dev_warn(dev, "empty region %u has non-zero offset\n",
 				 mem_id);
+
+		if (ipa_mem_id_required(ipa, mem_id)) {
+			dev_err(dev, "required memory region %u missing\n",
+				mem_id);
+			return false;
+		}
 	}
 
+	/* Now see if any required regions are not defined */
+	while (mem_id < IPA_MEM_COUNT)
+		if (ipa_mem_id_required(ipa, mem_id++))
+			dev_err(dev, "required memory region %u missing\n",
+				mem_id);
+
 	return true;
 }
 
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index ce692f948d59a..effe01f7310a2 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -55,22 +55,23 @@ enum ipa_mem_id {
 	IPA_MEM_V6_ROUTE_HASHED,	/* 2 canaries */
 	IPA_MEM_V6_ROUTE,		/* 2 canaries */
 	IPA_MEM_MODEM_HEADER,		/* 2 canaries */
-	IPA_MEM_AP_HEADER,		/* 0 canaries */
+	IPA_MEM_AP_HEADER,		/* 0 canaries, optional */
 	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
 	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
-	IPA_MEM_NAT_TABLE,		/* 4 canaries (IPA v4.5 and above) */
-	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0 and above) */
-	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0 and above) */
-	IPA_MEM_STATS_QUOTA_AP,		/* 0 canaries (IPA v4.0 and above) */
-	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0 and above) */
+	IPA_MEM_MODEM,			/* 0/2 canaries */
+	IPA_MEM_UC_EVENT_RING,		/* 1 canary, optional */
+	IPA_MEM_PDN_CONFIG,		/* 0/2 canaries (IPA v4.0+) */
+	IPA_MEM_STATS_QUOTA_MODEM,	/* 2/4 canaries (IPA v4.0+) */
+	IPA_MEM_STATS_QUOTA_AP,		/* 0 canaries, optional (IPA v4.0+) */
+	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0+) */
+	IPA_MEM_STATS_DROP,		/* 0 canaries, optional (IPA v4.0+) */
+	/* The next 5 filter and route statistics regions are optional */
 	IPA_MEM_STATS_V4_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V6_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V4_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
 	IPA_MEM_STATS_V6_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
-	IPA_MEM_STATS_FILTER_ROUTE,	/* 0 canaries (IPA v4.5 and above) */
-	IPA_MEM_STATS_DROP,		/* 0 canaries (IPA v4.0 and above) */
-	IPA_MEM_MODEM,			/* 0/2 canaries */
-	IPA_MEM_UC_EVENT_RING,		/* 1 canary */
+	IPA_MEM_STATS_FILTER_ROUTE,	/* 0 canaries (IPA v4.5+) */
+	IPA_MEM_NAT_TABLE,		/* 4 canaries, optional (IPA v4.5+) */
 	IPA_MEM_END_MARKER,		/* 1 canary (not a real region) */
 	IPA_MEM_COUNT,			/* Number of regions (not an index) */
 };
-- 
2.27.0

