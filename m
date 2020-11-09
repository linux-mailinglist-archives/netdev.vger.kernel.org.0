Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1A2AC17F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbgKIQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729776AbgKIQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:56:42 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C162BC0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:56:40 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id n12so10508369ioc.2
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4yWrXzwfznxNU372UdbxuIAHo54u4g17q1CuRCAU4Gc=;
        b=jYHzo1/shxPWr7/tBwF8gfq6RrvxnXOGHH/E1Fa7/3/U7/J74dAGnw+6bPfm58XK8n
         ZF+CsKprjhQtuqJgD302DAM7pr6EE2hBXPfBzcT9d4M3Kwhrh7GqZYPayqPkXNGSIyD3
         MYjnueSZFkrqTsjENpheg2B4xQAVsjr9v7io2CHLNjXvmHxC+xeegYgfuXNq5Q4q8tgG
         OHshgukqDszdWe+IY2PmP5BNiu6ZZla76vGfqwi8FvXEFtQXr0/e7z4B3hCXONTUYIhl
         e+y/7cT7fePz9PBc3/pFPJ9gJr8VT5u/LEYsB51DPfnXvmJ47W96xAOSDJn2kYKPhuQ0
         SAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yWrXzwfznxNU372UdbxuIAHo54u4g17q1CuRCAU4Gc=;
        b=nBcJPlaA9EWJB5VweY3fw1NHoruIZKiqnow2uMYXjUCYJxTefhCCtj180Xhv07toD8
         tEdmbYptwFejYvdobqeMaO2oALiYyD4VYlsiztPHGdgU/8+16yU2CyB8IUcSoJhnUltV
         xN9pdg+spGuXTiUV03l8bnYMXuh2+SS6ALZiFxZ1O6ucOX+pvtc8yeEh1wFneTuZiy6Q
         Rb98fxhFmk/j6XVeFuWjv68aOV3Ul5sAYybB8CFOex2kaNKcE9pZmjw3ORqKwWAKHPSN
         TKc3CjWJMxt1aViCR1DD3BGIwNLUl8thwc+MCjn/iOXi003R1ZtLEGiRfZvCw2nnGW3J
         8wDw==
X-Gm-Message-State: AOAM533YqJEm+EnNHHGSOT9MQIwlKnSVCrI60XIE5EBeLttp+lmeNYCz
        V5QYaDuLr1DjNFM8rNMAIO0AXg==
X-Google-Smtp-Source: ABdhPJxvcCfXLOJfmraw+ovVfPKnpgsipKccPYgqGzi70V4WprW2vxvAfS7xedEDe5hPuFXlH8YgSQ==
X-Received: by 2002:a02:cd02:: with SMTP id g2mr11928881jaq.22.1604941000087;
        Mon, 09 Nov 2020 08:56:40 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j85sm7576556ilg.82.2020.11.09.08.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:56:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: don't break build on large transaction size
Date:   Mon,  9 Nov 2020 10:56:32 -0600
Message-Id: <20201109165635.5449-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201109165635.5449-1-elder@linaro.org>
References: <20201109165635.5449-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following call in ipa_validate_build() is erroneous:

    BUILD_BUG_ON(sizeof(struct gsi_trans) > 128);

The fact is, it is not a bug for the size of a GSI transaction to be
bigger than 128 bytes.  The correct operation of the driver is not
dependent on the size of this structure.  The only consequence of
the transaction being large is that the amount of memory required
is larger.

The problem this was trying to flag is that a *slight* increase in
the size of this structure will have a disproportionate effect on
the amount of memory used.  E.g. if the structure grew to 132 bytes
the memory requirement for the transaction arrays would be about
double.

With various debugging build flags enabled, the size grows to 160
bytes.  But there's no reason to treat that as a build-time bug.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a580cab794b1c..d1e582707800a 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -680,9 +680,6 @@ static void ipa_validate_build(void)
 	 */
 	BUILD_BUG_ON(GSI_TLV_MAX > U8_MAX);
 
-	/* Exceeding 128 bytes makes the transaction pool *much* larger */
-	BUILD_BUG_ON(sizeof(struct gsi_trans) > 128);
-
 	/* This is used as a divisor */
 	BUILD_BUG_ON(!IPA_AGGR_GRANULARITY);
 
-- 
2.20.1

