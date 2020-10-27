Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141EA29BAD4
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807695AbgJ0QNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:13:09 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:44887 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807521AbgJ0QLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:31 -0400
Received: by mail-il1-f195.google.com with SMTP id z2so1980820ilh.11
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sNsja6RVkW4lCiOuiuPXRLZQ8pFPcNRAN/TOMPINMPw=;
        b=kCJEcAdEsNHqBQ8Cjwn1oY56xM29srDtn9h/gH2iJnw90q6FYSMQeB+oXsedzvFvFH
         Uw61dhZwme9Ws8p/VyvOZoN8nFF2MaLQxTe6XsuLvQOkcgBvpJ59DC0AKpMwc1ZjMEZo
         VtmKKesT8jz+mWRPt1mzhorgM9GpoXqvJmEugxXO+aV1kCBqCAKpIVDjWZnKEcJtWA42
         VQpILjb6Suq8OPuH4aiiPYRwu+bRC/e1DOa4lDsQ1MldvR6GfujUYs4mSmnKzfdOrzwU
         1cPd8fLX1dSMvEcvaKdV1NpTlXiiAiPAuuPuN1nGZZ3icwUqX58ANu+vufWOuFH3WTl8
         +mgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sNsja6RVkW4lCiOuiuPXRLZQ8pFPcNRAN/TOMPINMPw=;
        b=rFx80RkwTO9GxNcjF4FH1GLnQhExFNf1/Pg0FGvtadgpSZ2MYxhsdl4U6t5shcMo3h
         kYLPwjMxrLxZGwowhC9rHT7330bjzSY4KJIBqvwaWf5lfqOGWVo5Bow/yMn3ZTIzCJr6
         ubTIfzWUb1XOf7WEX3DNCI1FzuLXx2URnr2J65vYHSYgmBlB7bPd6GUydmHCqwU+JbEr
         0k7CaMkSkdOV43o+egWVCakNhuESea2hT47WxAzstq8II+f+7VUh+fNtlhYihv61A7pe
         X9wJ57w020bNZtoaK3OijOlr7csNr+LpuXBemhglr8KJkfGxl/O73ow8tJIzGIOfM1ZV
         o8bA==
X-Gm-Message-State: AOAM5324o2ckrF+n9njkP/qjw6eTRL6ldTv8flcjqCfsh4jt3ZTWXjCu
        bDjFhCQhtLwcJJUyDoqTlexUoUno/x5J+8Lk
X-Google-Smtp-Source: ABdhPJxm5yerevmzw+p9qviPw7+KsESVEG93n9dAl7HKta/X1ZmrUjmYg6DDMgwr88fsL3ZPKguN2g==
X-Received: by 2002:a92:740c:: with SMTP id p12mr2306704ilc.277.1603815089887;
        Tue, 27 Oct 2020 09:11:29 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/5] net: ipa: fix resource group field mask definition
Date:   Tue, 27 Oct 2020 11:11:17 -0500
Message-Id: <20201027161120.5575-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201027161120.5575-1-elder@linaro.org>
References: <20201027161120.5575-1-elder@linaro.org>
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

