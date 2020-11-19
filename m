Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70122B9DBD
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgKSWkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbgKSWku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:40:50 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A062C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:49 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r1so7881229iob.13
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4R2ny0eNytCOsjqToYvvw7xFj0yITV9HLKMp6fS2QIY=;
        b=R/z87x2ZYzGvDpZBP1BsgoS92JpA1eUs6xi8CcUAv/txyTA5TZKdw4xF+rEwMxmLB4
         Cnrl/JEqGJnhvHay8Y7hicOJ8mdaP/s3iJ/1+xLwDAURbVtuXaGJXI+2OafnYk81STuk
         14+uFm4uzRnELrjzPiQMBax3Ln9Ujn2AZRqAVkHf9MKQ3ICwTL/xYAlhu9p4fvOGOoEP
         fnA23dV4RHpagOItr/q5QkWnuHuUOWqNUmz9plWkJfYWufdUgx1HbWEcWyxxYX1P+Pjf
         x/7FKR6l5KJbxxB/76y2DACBTDx54faF0zuUYR4mXFfuUlByHJLg/FUlRyK0dq/hxcmh
         wYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4R2ny0eNytCOsjqToYvvw7xFj0yITV9HLKMp6fS2QIY=;
        b=CjvMwhh9WaNH4dX4SOA8d1cLW3R+jK4j854MmcFrJ0fKyKYyyO/dZ4/I/KCGfv3USJ
         zxflN5DLpnfssWMz2V9xoGX5NJHQde2C5CzRd6X/592+wKan3P9b3ZyrYpODx93tS8gr
         Jro+SRE0hnjOV/7yImAe37m7Z9mh3tP3rki3VEgTLnNkJxEf+8LtZP4AjtP6WxlhD0in
         9zxguanX1hpIsxrSoxwqhNnJQLP8K0PHrifidlgQPjWUTd4wLjHgza/NtATc6SvRpfHR
         tKky2sQfZr8X/BeyDZpIg2Yaze272CjAsToGbBr+2MpM1Zw4weRyNyOYVrbcdfzC8tWr
         UBCg==
X-Gm-Message-State: AOAM533XrOdfWXtC8zwhRTu6odfvbX9wCErJ3k45QbldQZ+5gKOZsSpi
        ABdKuoTX/rZBofFJ2wQrDHdJFQ==
X-Google-Smtp-Source: ABdhPJz/JAW+LKnwbhIroeL7GZKmLRwRvHIK21KvGw6ga1qQr/wE0hAdXHkXGm83OcdEeHSm4fPhLQ==
X-Received: by 2002:a05:6638:a27:: with SMTP id 7mr11425145jao.25.1605825648579;
        Thu, 19 Nov 2020 14:40:48 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id b4sm587797ile.13.2020.11.19.14.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:40:47 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] net: ipa: populate clock and interconnect data
Date:   Thu, 19 Nov 2020 16:40:40 -0600
Message-Id: <20201119224041.16066-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224041.16066-1-elder@linaro.org>
References: <20201119224041.16066-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Populate the core clock rate and interconnect average and peak
bandwidth data for SDM845 and SC7180 in their configuration data
files.  At this point we still don't *use* this data.

Note that SC7180 actually defines a new core clock rate (100 MHz
instead of 75 MHz) and new interconnect bandwidth values.  They
will be activated in the next commit, which uses the configured
values rather than the fixed constants.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 21 +++++++++++++++++++++
 drivers/net/ipa/ipa_data-sdm845.c | 21 +++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 37dada4da6808..5cc0ed77edb9c 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -309,6 +309,26 @@ static struct ipa_mem_data ipa_mem_data = {
 	.smem_size	= 0x00002000,
 };
 
+static struct ipa_clock_data ipa_clock_data = {
+	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz */
+	/* Interconnect rates are in 1000 byte/second units */
+	.interconnect = {
+		[IPA_INTERCONNECT_MEMORY] = {
+			.peak_rate	= 465000,	/* 465 MBps */
+			.average_rate	= 80000,	/* 80 MBps */
+		},
+		/* Average rate is unused for the next two interconnects */
+		[IPA_INTERCONNECT_IMEM] = {
+			.peak_rate	= 68570,	/* 68.570 MBps */
+			.average_rate	= 0,		/* unused */
+		},
+		[IPA_INTERCONNECT_CONFIG] = {
+			.peak_rate	= 30000,	/* 30 MBps */
+			.average_rate	= 0,		/* unused */
+		},
+	},
+};
+
 /* Configuration data for the SC7180 SoC. */
 const struct ipa_data ipa_data_sc7180 = {
 	.version	= IPA_VERSION_4_2,
@@ -316,4 +336,5 @@ const struct ipa_data ipa_data_sc7180 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
+	.clock_data	= &ipa_clock_data,
 };
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index bd92b619e7fec..f8fee8d3ca42a 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -329,6 +329,26 @@ static struct ipa_mem_data ipa_mem_data = {
 	.smem_size	= 0x00002000,
 };
 
+static struct ipa_clock_data ipa_clock_data = {
+	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
+	/* Interconnect rates are in 1000 byte/second units */
+	.interconnect = {
+		[IPA_INTERCONNECT_MEMORY] = {
+			.peak_rate	= 600000,	/* 600 MBps */
+			.average_rate	= 80000,	/* 80 MBps */
+		},
+		/* Average rate is unused for the next two interconnects */
+		[IPA_INTERCONNECT_IMEM] = {
+			.peak_rate	= 350000,	/* 350 MBps */
+			.average_rate	= 0,		/* unused */
+		},
+		[IPA_INTERCONNECT_CONFIG] = {
+			.peak_rate	= 40000,	/* 40 MBps */
+			.average_rate	= 0,		/* unused */
+		},
+	},
+};
+
 /* Configuration data for the SDM845 SoC. */
 const struct ipa_data ipa_data_sdm845 = {
 	.version	= IPA_VERSION_3_5_1,
@@ -336,4 +356,5 @@ const struct ipa_data ipa_data_sdm845 = {
 	.endpoint_data	= ipa_gsi_endpoint_data,
 	.resource_data	= &ipa_resource_data,
 	.mem_data	= &ipa_mem_data,
+	.clock_data	= &ipa_clock_data,
 };
-- 
2.20.1

