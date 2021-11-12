Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F2944EF2B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 23:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhKLWZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 17:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbhKLWZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 17:25:09 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E286FC061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:22:16 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id k21so13051536ioh.4
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 14:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C9+HbK+YTHePHOpXtIwPV+2M8nlPz7ZK9WcWxIle/6U=;
        b=mIwWb2XCoeYeyi+EfWBZKHXHQQVpQof5ukBsLAVOlNPoE1tzc0mNtvvh+ML41Hkojz
         /9VXZBLYnfX562DQaxr0s99Zi8VB6J4x3OR3Z97BLRvEWGeOE8mc36z1gDEBVdlRtpUL
         dC0dHu1E08TYWXSOKXM02pGZUBbKE+UW9fxF77sIGlptnBMc2F9NABi6G7cjzEfD5b/C
         aEWubFg12MphlH7EE3iKZSzTNgTCc47geG1cCKf3g4GurvjfKH76+mxYMN9QUaIIbMXr
         Un7AUAi/znACIFHugswKWh2Yc9EdW2t2aVVIbd9vk6RjwQhEoaC4M1WkGoLoqskM8AzZ
         gWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C9+HbK+YTHePHOpXtIwPV+2M8nlPz7ZK9WcWxIle/6U=;
        b=F8Qxj9du41m9j7SNXjpH9tkCLcEYra6QdvodwJKO9/BFmf3ZgQ+flFdofKBeukwXzb
         lx4uTOOo/lyEHCiCuW/R5aGVoUBfk+c94D8CEdZyP86sEN2T33MXb0/iwDyhkqt1IDIm
         36SEdG1uzeCaJ9GH4PyHVldZhMLv3NzN77VajLeijfkA4PrMsaHLvjuJUR0gH3XgMMYb
         Fs0yy7pbFaBG3VVZKVrRX/NHBmEMp340Wvt44+xMzsEi/G8aRybjUUfx30Jyot0wFg4S
         VPJ81OBbqOG6uUX8CwGEDKXezfecBgZwBXGbeIFQL8Eo5yVzxXPCALmyak/ygrwP0RLK
         z7Jg==
X-Gm-Message-State: AOAM533dCnLfXWWYA1qraXjJWpCwkrfNnZa796XUR8uERK58VXuTaGod
        LbGqlFTlWGhU08feUtACubOy9Q==
X-Google-Smtp-Source: ABdhPJwgQu+M6BYQWNsyZqz2iiMmIGeKgQJPUg/vkx1V3FC/qVw6nRrtxHWPnHM8u77ch7Rw5sAsFw==
X-Received: by 2002:a6b:7c46:: with SMTP id b6mr12996272ioq.129.1636755736369;
        Fri, 12 Nov 2021 14:22:16 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y6sm5241117ilu.38.2021.11.12.14.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 14:22:15 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: ipa: HOLB register sometimes must be written twice
Date:   Fri, 12 Nov 2021 16:22:09 -0600
Message-Id: <20211112222210.224057-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112222210.224057-1-elder@linaro.org>
References: <20211112222210.224057-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with IPA v4.5, the HOL_BLOCK_EN register must be written
twice when enabling head-of-line blocking avoidance.

Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 5528d97110d56..006da4642a0ba 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -868,6 +868,9 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 	val = enable ? HOL_BLOCK_EN_FMASK : 0;
 	offset = IPA_REG_ENDP_INIT_HOL_BLOCK_EN_N_OFFSET(endpoint_id);
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
+	/* When enabling, the register must be written twice for IPA v4.5+ */
+	if (enable && endpoint->ipa->version >= IPA_VERSION_4_5)
+		iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
 void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
-- 
2.32.0

