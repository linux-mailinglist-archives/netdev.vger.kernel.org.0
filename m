Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6212B5535
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgKPXiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730922AbgKPXiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:38:19 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6D1C0613D2
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:19 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id m9so19264346iox.10
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ibvkktNZHObaQcpICoKzhru5nZ1s0dOfq/+z59Thq90=;
        b=PRYejMotlMrjs0eJGE1V3DsLE1A7XOXtVpntptTt4gC6Kn9g7/wRsrJ8L5hpcCq3iG
         86ZepbczjQ+i8RxzWDEUfXeFAd/eAQvp354Q1cQrFK+dGRfb9yFGxR/URk0tOe3mKz7g
         XIyDMdgVbftJ7Gko/vpHNN7YWzuTBykfyNLXWXnd3T6oHa7NYldvNzTqWwldKy8dWs8t
         FKV4eqV+dZFazLpDrcZm6YbrnKg412FyH5SET9HLjBV6t93lTWEsll8cWfQKxhvxFNoM
         8E7Swp63bm/M3TfAcTCs84I+VVcyGPhIZ6MWbG00DPGuR70XofOy+YCTSskEUO7Bz26U
         lF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ibvkktNZHObaQcpICoKzhru5nZ1s0dOfq/+z59Thq90=;
        b=YdbF8t5tXBhp7IY4w17vrgC9ga2xbAXSYTHxsZXqlUdbQ+/QFXKJhX4M8fEIblkQL+
         Yz4Ev2BsjxQrXbyj/Xpu+k/YWWSFBxBSrUfYes1TGXYub3tOrsCOKXFnzJ3v3W6oIfZ2
         piCtkieXJwxjo6+iQ7LjRaT+GrL1y1zWHt0bsj5pnPu0AFkY001ct1m1CkVAmrxt7Ufw
         EY6sSMmYhn6V1rleJu0j/rox/taEC2fYZlLnr1+8+bTYMAOnTQa/XwtKCRJKCeb1j19o
         Zsy/ZJZ0gygBwD+LZabfU5NRvhGXwNUu4sOl4y6xbxQ7lklF7sHzTFnHt9ddQgYR0RO2
         3ZHg==
X-Gm-Message-State: AOAM531zSOHjGGO9t+f+FC8Gu0hPMASYmyLehLOiYYzsCvl0+elJNmX9
        O23TtdQByeTsb4r/wQKlA8nz/g==
X-Google-Smtp-Source: ABdhPJw4qdh8NCJNcGBrafOS43FUhLk+aYch0J88kVZb3uPIdnZsZRQebl/8xqPrw3Yuf5obk1nYhg==
X-Received: by 2002:a05:6638:3f1:: with SMTP id s17mr1542024jaq.102.1605569898517;
        Mon, 16 Nov 2020 15:38:18 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f18sm10180099ill.22.2020.11.16.15.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:38:18 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/11] net: ipa: support more versions for HOLB timer
Date:   Mon, 16 Nov 2020 17:37:57 -0600
Message-Id: <20201116233805.13775-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116233805.13775-1-elder@linaro.org>
References: <20201116233805.13775-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA version 3.5.1 represents the timer used in avoiding head-of-line
blocking with a simple tick count.  IPA v4.2 changes that, instead
splitting the timer field into two parts (base and scale) to
represent the ticks in the timer period.

IPA v4.0 and IPA v4.1 use the same method as IPA v3.5.1.  Change the
test in ipa_reg_init_hol_block_timer_val() so the result is correct
for those versions as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 548121b1531b7..3c9bbe2bf81c9 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -665,8 +665,8 @@ static u32 ipa_reg_init_hol_block_timer_val(struct ipa *ipa, u32 microseconds)
 	/* ...but we still need to fit into a 32-bit register */
 	WARN_ON(ticks > U32_MAX);
 
-	/* IPA v3.5.1 just records the tick count */
-	if (ipa->version == IPA_VERSION_3_5_1)
+	/* IPA v3.5.1 through v4.1 just record the tick count */
+	if (ipa->version < IPA_VERSION_4_2)
 		return (u32)ticks;
 
 	/* For IPA v4.2, the tick count is represented by base and
-- 
2.20.1

