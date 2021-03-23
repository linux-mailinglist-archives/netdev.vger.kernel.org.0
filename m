Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4283461EC
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhCWOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbhCWOvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 10:51:44 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFDBC0613D9
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:43 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e8so17963906iok.5
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 07:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mz7860lZzk6VZ253Yqzghlj/rfYbeBGQaKOgyWdMwc4=;
        b=pCVav1dzOO0huV0bd1PsGoJE/DJC6UFegHK7QKjr3rUIrdA+Y5CRr6vHP1XiflCGQE
         5vRhrPYQiGd7vM6N3VMV9PQNgf+bAeUMk2cR/0EfdkdWou/uZ0Gm+gd1JApbKO0g1zPM
         xA+luQnMdkiSgtbxdTdw5QHqtgodWE6GDs3VtFTcgVfC7CanQPSP9KGqKlQ8K4gCueMP
         /3NCLpRgUjbmsfT91tcUhQkAZRX5gypDGEsTCD2cbVxQga30FqefH/5C6lI6fQtEsMLL
         F87OAM7iL3d9sGot1ZAm6H3UHQuCFd8cfPcBye+PKrHMjuhVxmfnvmUBwG2n4Jjuym3X
         c5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mz7860lZzk6VZ253Yqzghlj/rfYbeBGQaKOgyWdMwc4=;
        b=nC6syklUAfc9b9drhHk3v9KQVcFKJPFdVeE9jFcnQQY5ohoriqB6XqzYjJMTd3fthq
         O3UoH17H0+oc656uWb/K+/nsGDoHf6sDLzb1CNurn95fhGxEqUOmjt1JxOs2Q4R0bvtl
         0Q0sjp7VyHfjD5BU4nzvo0T5opGeFiBTWFbd361dHp8UyVUkXFbFfmNpNwZlSwIrEbDI
         heJPMObRij8zh7Q0UA6b8WCjb7iQLZDF/mx8GTJwwkToWrKvU/Z6MbtVNKU40vZ6zfBh
         fLyehj691YZXL40P8RewD4nY3JoaSIS50DXvvidrIrnbRLPB1uUs0HMrYhMYlmnk7suw
         v4Vw==
X-Gm-Message-State: AOAM5335h8tKfyNknxEer6WzJDlmKGc9hnSmIaQSaD5sNJ1zjiseGbBZ
        pzdZFVJ7/Qv5/Qs4+fpt/Xk4Jw==
X-Google-Smtp-Source: ABdhPJwUbb2CkRxod9K93XDPC5V1Y0v85DqJTTPBlEnh0g5xnBWcFxt0/Dwpw49O8INdS8+yLpIpJg==
X-Received: by 2002:a02:9985:: with SMTP id a5mr4785921jal.122.1616511102767;
        Tue, 23 Mar 2021 07:51:42 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o13sm8961147iob.17.2021.03.23.07.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 07:51:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: move ipa_aggr_granularity_val()
Date:   Tue, 23 Mar 2021 09:51:31 -0500
Message-Id: <20210323145132.2291316-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210323145132.2291316-1-elder@linaro.org>
References: <20210323145132.2291316-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only use ipa_aggr_granularity_val() inside "ipa_main.c", so it
doesn't really need to be defined in a header file.  It makes some
sense to be grouped with the register definitions, but it is unlike
the other inline functions now defined in "ipa_reg.h".  So move it
into "ipa_main.c" where it's used.  TIMER_FREQUENCY is used only
by that function, so move that definition as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 15 +++++++++++++++
 drivers/net/ipa/ipa_reg.h  | 12 ------------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 62d82d48aed69..ba1bfc30210a3 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -287,6 +287,21 @@ ipa_hardware_config_qsb(struct ipa *ipa, const struct ipa_data *data)
 	iowrite32(val, ipa->reg_virt + IPA_REG_QSB_MAX_READS_OFFSET);
 }
 
+/* The internal inactivity timer clock is used for the aggregation timer */
+#define TIMER_FREQUENCY	32000		/* 32 KHz inactivity timer clock */
+
+/* Compute the value to use in the COUNTER_CFG register AGGR_GRANULARITY
+ * field to represent the given number of microseconds.  The value is one
+ * less than the number of timer ticks in the requested period.  0 is not
+ * a valid granularity value.
+ */
+static u32 ipa_aggr_granularity_val(u32 usec)
+{
+	/* assert(usec != 0); */
+
+	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
+}
+
 /* IPA uses unified Qtime starting at IPA v4.5, implementing various
  * timestamps and timers independent of the IPA core clock rate.  The
  * Qtimer is based on a 56-bit timestamp incremented at each tick of
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index cbfef27bbcf2c..86fe2978e8102 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -237,18 +237,6 @@ static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
 #define IPA_REG_COUNTER_CFG_OFFSET			0x000001f0
 #define AGGR_GRANULARITY_FMASK			GENMASK(8, 4)
 
-/* The internal inactivity timer clock is used for the aggregation timer */
-#define TIMER_FREQUENCY	32000		/* 32 KHz inactivity timer clock */
-
-/* Compute the value to use in the AGGR_GRANULARITY field representing the
- * given number of microseconds.  The value is one less than the number of
- * timer ticks in the requested period.  0 not a valid granularity value.
- */
-static inline u32 ipa_aggr_granularity_val(u32 usec)
-{
-	return DIV_ROUND_CLOSEST(usec * TIMER_FREQUENCY, USEC_PER_SEC) - 1;
-}
-
 /* The next register is not present for IPA v4.5 */
 #define IPA_REG_TX_CFG_OFFSET				0x000001fc
 /* The first three fields are present for IPA v3.5.1 only */
-- 
2.27.0

