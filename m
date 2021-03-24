Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE734795C
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhCXNQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbhCXNPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:35 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BAAC0613E4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:35 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id j26so21396654iog.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=urnf0slLMOPXg7nga5dabZHaUvtoQMaa3zOQvFLPfpg=;
        b=XXnUftby1PJstg1QGnrNCyvVockAvhoQ4xBqC3Kf5fXe0U9HwzNSpk/AcZ6lMxVnV5
         YpIHmEPU26v+ECSQKHWVT15lyU8o90U+CdvemETr7dq3mWdRX89pRvWPVH0uCSq5BIcs
         oZhyUN3H7ptyM0YL7XbZ4AvLU8CLuY0vM1bpVE9rwnl2GsYK+MO0tAWcKzxMRdSMTc+K
         GKwQA294TDJ0NoaOOzaZLFpDIOlg1JPImV/q9OyZS2cGs0Shc73ISRQF5w9x1Tvl435X
         pTn97IR50kxQ8CsvOXIDGhuQStJ6UTPv2WcpJQm9ZnKB+S7AbTWDU7z4TNEd0VqWfvQE
         sGUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=urnf0slLMOPXg7nga5dabZHaUvtoQMaa3zOQvFLPfpg=;
        b=DSQ/41xBLP57tqKg5KOX7fb8tv6/8uDHCag6iIaVtlgWsA2mENer6iTHsQdp1Jd5Fd
         d8zQoIOKdWCxf8+rjQvveZD69ZJdQGOMSgJ7JIWRDSsKR6WgT5iJCaomtgSHvBofGjqO
         fziFE5QYV/cBJOcAOITQvoq+7X20iWgtNl+BnfPhi9OkWt5PJRWicf1FgQbrm+THVuz8
         JQv0bZI76WlGK2DdsIFbHuddQjaqr4+aaAKh1jrG1upB5rJ9U/aSvjC3afgMxW2vu+5Z
         RjIo3Iqu32IeO69pN/6GUVph6t4qrvgpVm2sF2eI7DoYhzsKh8mBUyDoGjcz/QuqySsa
         Gvyw==
X-Gm-Message-State: AOAM530je6lhKa+ED6SYqKixTq5fU0MAsY7crZPWWw+Knp5RBiRui2u3
        ucbOy5FzXR82lM+Z6OZYQrzrqegAnZeEWdQW
X-Google-Smtp-Source: ABdhPJwhm6deOM+Slv8dvjshL8No2AngclJGGLSLkeePXmkZ61SPgto/1KAIFFtRV6Yn6foyp7Hgiw==
X-Received: by 2002:a02:cad9:: with SMTP id f25mr2799645jap.26.1616591734490;
        Wed, 24 Mar 2021 06:15:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net: ipa: limit local processing context address
Date:   Wed, 24 Mar 2021 08:15:26 -0500
Message-Id: <20210324131528.2369348-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
References: <20210324131528.2369348-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all of the bits of the LOCAL_PKT_PROC_CNTXT register are valid.
Until IPA v4.5, there are 17 valid bits (though the bottom three
must be zero).  Starting with IPA v4.5, 18 bits are valid.

Introduce proc_cntxt_base_addr_encoded() to encode the base address
for use in the register using only the valid bits.

Shorten the name of the register (omit "_BASE") to avoid the need to
wrap the line in the one place it's used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c |  6 ++++--
 drivers/net/ipa/ipa_reg.h | 14 ++++++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index f25029b9ec857..32907dde5dc6a 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -61,6 +61,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	struct gsi_trans *trans;
 	u32 offset;
 	u16 size;
+	u32 val;
 
 	/* Get a transaction to define the header memory region and to zero
 	 * the processing context and modem memory regions.
@@ -89,8 +90,9 @@ int ipa_mem_setup(struct ipa *ipa)
 	gsi_trans_commit_wait(trans);
 
 	/* Tell the hardware where the processing context area is located */
-	iowrite32(ipa->mem_offset + ipa->mem[IPA_MEM_MODEM_PROC_CTX].offset,
-		  ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET);
+	offset = ipa->mem_offset + ipa->mem[IPA_MEM_MODEM_PROC_CTX].offset;
+	val = proc_cntxt_base_addr_encoded(ipa->version, offset);
+	iowrite32(val, ipa->reg_virt + IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET);
 
 	return 0;
 }
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index bba088e80cd1e..cbfef27bbcf2c 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -217,8 +217,18 @@ static inline u32 ipa_reg_bcr_val(enum ipa_version version)
 	return 0x00000000;
 }
 
-/* The value of the next register must be a multiple of 8 */
-#define IPA_REG_LOCAL_PKT_PROC_CNTXT_BASE_OFFSET	0x000001e8
+/* The value of the next register must be a multiple of 8 (bottom 3 bits 0) */
+#define IPA_REG_LOCAL_PKT_PROC_CNTXT_OFFSET		0x000001e8
+
+/* Encoded value for LOCAL_PKT_PROC_CNTXT register BASE_ADDR field */
+static inline u32 proc_cntxt_base_addr_encoded(enum ipa_version version,
+					       u32 addr)
+{
+	if (version < IPA_VERSION_4_5)
+		return u32_encode_bits(addr, GENMASK(16, 0));
+
+	return u32_encode_bits(addr, GENMASK(17, 0));
+}
 
 /* ipa->available defines the valid bits in the AGGR_FORCE_CLOSE register */
 #define IPA_REG_AGGR_FORCE_CLOSE_OFFSET			0x000001ec
-- 
2.27.0

