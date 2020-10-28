Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C51729D66C
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbgJ1WOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731053AbgJ1WOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:14:48 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F48C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:14:48 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id h21so1159577iob.10
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vv7cM6cxI+6JCDep4JnUcjGnf8IzXZFWl325bdBt8FU=;
        b=MuGa/5QyLjLCSan3+a/ID5Uj9b0l5h6XG27Gg1WaLw7OUcCnflsfGrQMtNo7Ajp7dT
         h9MomlEONXAtrC7V48aXJvKFehNypCfiI1n1CWQ57AsfTJ18jewJRNmKUdNu9/qBQVn1
         Z+SRho1wg4HlatqQFjENTymMX96YN4o+GlPhj+rb9E323kWlbbVEUGRCYPyEvB3prWub
         6PsIw+8Au+yqpXiIROY9aqetp/v/Web21sNtrwZSFVs9hX5ATrL2zfX33aHfLp/LuMGX
         WxRlwDzvD12IhYZNN64hpsqN1FwU7dFuEm1QYgeueS7zPZ7Gt6krvaSDMxPEr9Ddbg12
         qQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vv7cM6cxI+6JCDep4JnUcjGnf8IzXZFWl325bdBt8FU=;
        b=WnAYz2+bTzG7IoJQ22cR1w/zOAg8oUj7tYB0INz+BUm7KYWWTEXH+lYdadeul+lrdG
         d92e8JlcjqZG/fRG3059LiRoClnnjJ+66JlHZWGjzKiFEbYtKYPfiySTXcfz4Iih4yJY
         f4v2mCQkVUiz9yilAKX75bjht05KRngY/dUv8AztCXtzJFcTnzCmojvVR7zC0WH9f1W0
         SwAYi5BPnV1HzGRse43vgk7SDTuaDgosJsV2jdqXlrxGduNVGe/UKctT/loxk57Aixdw
         2xuGpJoNWcBGodwFanjH2MdKsVQJ88OT4NxXli7adumTFBvl6mnQJE1rLgEcBkXw53eh
         lbfA==
X-Gm-Message-State: AOAM532PBUeLpozBj6uaxmevHegsRjdAEbPmy1/s4j6VwnQmL15PfWE7
        oBj6WhxvL0NVMkGJ0QHnvMd5TV7Nj0/e1ZHd
X-Google-Smtp-Source: ABdhPJw3SgzDh8DIIk28Wo4UBPoho6XScmnSVYzX7wUknzDiLfnO3SO8FAqqIIyaLoqgIQQ6vzsprw==
X-Received: by 2002:a05:6602:e:: with SMTP id b14mr838956ioa.114.1603914116152;
        Wed, 28 Oct 2020 12:41:56 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m66sm359828ill.69.2020.10.28.12.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 12:41:55 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        sujitka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 2/5] net: ipa: fix resource group field mask definition
Date:   Wed, 28 Oct 2020 14:41:45 -0500
Message-Id: <20201028194148.6659-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028194148.6659-1-elder@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mask for the RSRC_GRP field in the INIT_RSRC_GRP endpoint
initialization register is incorrectly defined for IPA v4.2 (where
it is only one bit wide).  So we need to fix this.

The fix is not straightforward, however.  Field masks are passed to
functions like u32_encode_bits(), and for that they must be constant.

To address this, we define a new inline function that returns the
*encoded* value to use for a given RSRC_GRP field, which depends on
the IPA version.  The caller can then use something like this, to
assign a given endpoint resource id 1:

    u32 offset = IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(endpoint_id);
    u32 val = rsrc_grp_encoded(ipa->version, 1);

    iowrite32(val, ipa->reg_virt + offset);

The next patch requires this fix.

Fixes: cdf2e9419dd91 ("soc: qcom: ipa: main code")
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_reg.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index e542598fd7759..7dcfa07180f9f 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -341,7 +341,16 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 
 #define IPA_REG_ENDP_INIT_RSRC_GRP_N_OFFSET(ep) \
 					(0x00000838 + 0x0070 * (ep))
-#define RSRC_GRP_FMASK				GENMASK(1, 0)
+/* Encoded value for RSRC_GRP endpoint register RSRC_GRP field */
+static inline u32 rsrc_grp_encoded(enum ipa_version version, u32 rsrc_grp)
+{
+	switch (version) {
+	case IPA_VERSION_4_2:
+		return u32_encode_bits(rsrc_grp, GENMASK(0, 0));
+	default:
+		return u32_encode_bits(rsrc_grp, GENMASK(1, 0));
+	}
+}
 
 /* Valid only for TX (IPA consumer) endpoints */
 #define IPA_REG_ENDP_INIT_SEQ_N_OFFSET(txep) \
-- 
2.20.1

