Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B063420E7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhCSPZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhCSPY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:24:29 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320BAC06175F
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id z136so6490955iof.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 08:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yEgGy53zxqbYoAAHRBLHP4wOELYTResxqXghESvaYfE=;
        b=l6c+CghayM6ncc//tyYD/YdI6iFgGh6PlOn9KNkBjEgf26U4ya8uxCrs+mQ73Fhaqi
         8YTi9whlGk4LPxDf/hGW0IV0eZSSMME8jophN4C3cvEi0k5xOYdVoOmtseuWPfGKG47/
         NIsh8sSOtpGQ7r3iQc01d3RW+3LS8iNcNFn6V0JICoLfXMbQDgq/8El/4LM1L+t7jEre
         Tlt70YzEEsR6RonIROOWQov0EV8JJ8AGy3HaUiaxuQQObrAC2yV9DUYoYPGunrOIPaLn
         lFgpgrU/bSDfUBWzQxcgVyY9esyArX4jjEDt4Zv15h/KWmhaV1m831a8eh04xIzebkRS
         SGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEgGy53zxqbYoAAHRBLHP4wOELYTResxqXghESvaYfE=;
        b=M2hYxxlGjM0lEvXvwotlLcNG2+znjT6y992a+rzEECzTayql+Fhkm80stBLuNrZFoA
         hrxTn6LnrrWXbLjqSc8ynuCrclLwO8eoeSRCrw4MsSYOXCnn+B5OPqiWCJfO3Jg96P21
         hFMEQ/0Shul6Pzk1r7p2rBc8Bdf1Ejgc0YfqRi1imXWYgjgkggvg99wOkDA5dKDBGxOZ
         uqhPtGxq6u5TK7385PO5NQS+ZHQ+RonpkjvEiOVe5ZlQT3tnoQbhqrh443/0qVnxbRsN
         4lBppT9lQA33WL6MiF0QqsSpYLj9210n0Yy4W5PjFdqxIBCxgNa2peTlgnOLExaZUfWG
         8PKw==
X-Gm-Message-State: AOAM531+g3mg6kl0ZAQByaGp+TXAsyoEMZFO1V8wkgmbrZe4Oq8AOqZU
        pv1S/wwHTx4EUIWd4ubuxPe0Xw==
X-Google-Smtp-Source: ABdhPJzLHNRgD4yREiltxoVkJt4ZKJtpJuOaKaaMT9MZZ4QqmXiYUDYTKGdXb7906IVVFf8iH8MxAw==
X-Received: by 2002:a6b:500c:: with SMTP id e12mr3039005iob.190.1616167468648;
        Fri, 19 Mar 2021 08:24:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b5sm2686887ioq.7.2021.03.19.08.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 08:24:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: define some new memory regions
Date:   Fri, 19 Mar 2021 10:24:21 -0500
Message-Id: <20210319152422.1803714-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210319152422.1803714-1-elder@linaro.org>
References: <20210319152422.1803714-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several memory regions that are defined starting with IPA
v4.0, but which were not used for the SC7180 SoC (IPA v4.2).  Even
though they're not used (yet), define them so they are ready to be
used for SoCs when they become supported.

There are two QUOTA statistics memory regions, one for the modem and
one for the AP.  Define distinct names for these regions, and get
rid of the definition of IPA_MEM_STATS_QUOTA.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c |  2 +-
 drivers/net/ipa/ipa_mem.h         | 10 +++++++++-
 drivers/net/ipa/ipa_qmi.c         |  2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 0bdb60f6755c4..f65abc19ae9d7 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -268,7 +268,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 		.size		= 0x0050,
 		.canary_count	= 2,
 	},
-	[IPA_MEM_STATS_QUOTA] = {
+	[IPA_MEM_STATS_QUOTA_MODEM] = {
 		.offset		= 0x0a50,
 		.size		= 0x0060,
 		.canary_count	= 2,
diff --git a/drivers/net/ipa/ipa_mem.h b/drivers/net/ipa/ipa_mem.h
index f99180f84f0dd..f82e8939622bb 100644
--- a/drivers/net/ipa/ipa_mem.h
+++ b/drivers/net/ipa/ipa_mem.h
@@ -28,6 +28,7 @@ struct ipa_mem_data;
  * The set of memory regions is defined in configuration data.  They are
  * subject to these constraints:
  * - a zero offset and zero size represents and undefined region
+ * - a region's size does not include space for its "canary" values
  * - a region's offset is defined to be *past* all "canary" values
  * - offset must be large enough to account for all canaries
  * - a region's size may be zero, but may still have canaries
@@ -56,9 +57,16 @@ enum ipa_mem_id {
 	IPA_MEM_AP_HEADER,		/* 0 canaries */
 	IPA_MEM_MODEM_PROC_CTX,		/* 2 canaries */
 	IPA_MEM_AP_PROC_CTX,		/* 0 canaries */
+	IPA_MEM_NAT_TABLE,		/* 4 canaries (IPA v4.5 and above) */
 	IPA_MEM_PDN_CONFIG,		/* 2 canaries (IPA v4.0 and above) */
-	IPA_MEM_STATS_QUOTA,		/* 2 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_QUOTA_MODEM,	/* 2 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_QUOTA_AP,		/* 0 canaries (IPA v4.0 and above) */
 	IPA_MEM_STATS_TETHERING,	/* 0 canaries (IPA v4.0 and above) */
+	IPA_MEM_STATS_V4_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
+	IPA_MEM_STATS_V6_FILTER,	/* 0 canaries (IPA v4.0-v4.2) */
+	IPA_MEM_STATS_V4_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
+	IPA_MEM_STATS_V6_ROUTE,		/* 0 canaries (IPA v4.0-v4.2) */
+	IPA_MEM_STATS_FILTER_ROUTE,	/* 0 canaries (IPA v4.5 and above) */
 	IPA_MEM_STATS_DROP,		/* 0 canaries (IPA v4.0 and above) */
 	IPA_MEM_MODEM,			/* 0 canaries */
 	IPA_MEM_UC_EVENT_RING,		/* 1 canary */
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 2fc64483f2753..af8666b89b375 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -378,7 +378,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	/* None of the stats fields are valid (IPA v4.0 and above) */
 
 	if (ipa->version != IPA_VERSION_3_5_1) {
-		mem = &ipa->mem[IPA_MEM_STATS_QUOTA];
+		mem = &ipa->mem[IPA_MEM_STATS_QUOTA_MODEM];
 		if (mem->size) {
 			req.hw_stats_quota_base_addr_valid = 1;
 			req.hw_stats_quota_base_addr =
-- 
2.27.0

