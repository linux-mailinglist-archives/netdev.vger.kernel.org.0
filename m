Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C161C3A202B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFIWhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFIWhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 18:37:16 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5ADAC0617A8
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 15:35:10 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id w14so18549365ilv.1
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 15:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Efo2gR8r+knWoJXWPdLdHsqFiu2EgVFjf/ge0HSla8U=;
        b=KVKhqx4Mnv3fjswbSoNCoQbwzPRlJ4ZGiyZNmLd7mAQ5fJXSxiIN6GtCXdDG6Wp+O6
         sSuLmIVGMue/FN+BnQhmgJsQ4y5Ff6+OPCXHtzVItZGgoPUkaMF/MUjedaFy7Bb6Ssrj
         SqvYas93GrdCzrJgver2lOfGenlBsJ6/9+iOOQMZwiLpA5SbPhRlVqS0fCI2C1gPGZ4z
         ssPcjutvtjDUcR0mnjuThp3dN/HPvJUl3+e3fnS4vleg7FuzDKt8dNLL8k02CYJygS+c
         PHbOCrN26tfxXImd7uRdNK1znvjC+uP/oKZjY3w0wyyaQSG/zbeFtSZ0A/2iRqtcTbMP
         bojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Efo2gR8r+knWoJXWPdLdHsqFiu2EgVFjf/ge0HSla8U=;
        b=se6G1MxeiMSyasZc1kKdR4mvqzjFu31TH2KqSWqqWZT90NbVZnBBndYKKzmX2ymPQR
         KKgpCU5q3DlH8gKiRgKj0qvzIAKGIkfCtgpWAMXBKx6ro6LP5gPi3xRR2ETro4LcrMuv
         v6wtEguVviXtAa0sMx+4ln+Lwi4A6okmkCf8zSqz8/IjSnbxalvH9rU5VUug16YiJ+81
         5qHzTGVhhfju0dHddTvnrx4r1nOT8zlF03b1UEhg8xZPqFp2/uXleSZ3rBqvYWsIJIDk
         o8CE5jEmr7jWQ4gEwwg/rCeJDfI+BBrCrjIi+7h5kepVreUZQLP5iMddVLxspLCfujp8
         YKig==
X-Gm-Message-State: AOAM532VDrq1pyEdh0ODO9wLurb6C2/psthunhMaNC9vZmMYllVd+wXe
        Cd8lL5fCIkYSuUrjS3tu7uc1UA==
X-Google-Smtp-Source: ABdhPJz3ac2PvWV008X5ipNBFR3YRyTsoyUndUVbHbZfTHeDcUhJSjpqsecOkGcFiPY7DRFHjOsKEg==
X-Received: by 2002:a92:d245:: with SMTP id v5mr1436873ilg.245.1623278110263;
        Wed, 09 Jun 2021 15:35:10 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c19sm750165ili.62.2021.06.09.15.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 15:35:09 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/11] net: ipa: separate memory validation from initialization
Date:   Wed,  9 Jun 2021 17:34:56 -0500
Message-Id: <20210609223503.2649114-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210609223503.2649114-1-elder@linaro.org>
References: <20210609223503.2649114-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, memory regions are validated in the loop that initializes
them.  Instead, validate them separately.

Rename ipa_mem_valid() to be ipa_mem_valid_one().  Define a *new*
function named ipa_mem_valid() that performs validation of the array
of memory regions provided.  This function calls ipa_mem_valid_one()
for each region in turn.

Skip validation for any "empty" region descriptors, which have zero
size and are not preceded by any canary values.  Issue a warning for
such descriptors if the offset is non-zero.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_mem.c | 40 +++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index effaa745a4061..62e1b8280d982 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -99,7 +99,7 @@ int ipa_mem_setup(struct ipa *ipa)
 	return 0;
 }
 
-static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem *mem)
+static bool ipa_mem_valid_one(struct ipa *ipa, const struct ipa_mem *mem)
 {
 	struct device *dev = &ipa->pdev->dev;
 	enum ipa_mem_id mem_id = mem->id;
@@ -126,6 +126,31 @@ static bool ipa_mem_valid(struct ipa *ipa, const struct ipa_mem *mem)
 	return false;
 }
 
+/* Verify each defined memory region is valid. */
+static bool ipa_mem_valid(struct ipa *ipa)
+{
+	struct device *dev = &ipa->pdev->dev;
+	enum ipa_mem_id mem_id;
+
+	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
+		const struct ipa_mem *mem = &ipa->mem[mem_id];
+
+		/* Defined regions have non-zero size and/or canary count */
+		if (mem->size || mem->canary_count) {
+			if (ipa_mem_valid_one(ipa, mem))
+				continue;
+			return false;
+		}
+
+		/* It's harmless, but warn if an offset is provided */
+		if (mem->offset)
+			dev_warn(dev, "empty region %u has non-zero offset\n",
+				 mem_id);
+	}
+
+	return true;
+}
+
 /**
  * ipa_mem_config() - Configure IPA shared memory
  * @ipa:	IPA pointer
@@ -167,19 +192,18 @@ int ipa_mem_config(struct ipa *ipa)
 	ipa->zero_virt = virt;
 	ipa->zero_size = IPA_MEM_MAX;
 
-	/* Verify each defined memory region is valid, and if indicated
-	 * for the region, write "canary" values in the space prior to
-	 * the region's base address.
+	/* Make sure all defined memory regions are valid */
+	if (!ipa_mem_valid(ipa))
+		goto err_dma_free;
+
+	/* For each region, write "canary" values in the space prior to
+	 * the region's base address if indicated.
 	 */
 	for (mem_id = 0; mem_id < ipa->mem_count; mem_id++) {
 		const struct ipa_mem *mem = &ipa->mem[mem_id];
 		u16 canary_count;
 		__le32 *canary;
 
-		/* Validate all regions (even undefined ones) */
-		if (!ipa_mem_valid(ipa, mem))
-			goto err_dma_free;
-
 		/* Skip over undefined regions */
 		if (!mem->offset && !mem->size)
 			continue;
-- 
2.27.0

