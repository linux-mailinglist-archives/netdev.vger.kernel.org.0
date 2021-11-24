Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C500A45CDFE
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhKXU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhKXU2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:31 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF5DC061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:21 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id j7so3649275ilk.13
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U+1ZMb25RFdAwm161yRXw6iBBPms0tJ9oVdKiifaLz0=;
        b=DmEJN+qF6u5mk/dHhx+SeBOWwoxgNw9+v1x1zW3vbp4SxbwlksSwIA2h2wu1UqNXFL
         WxfBoL4TmFqOAhO7q3U3mNfFZQ5/SHK6H6WvzJgZQlvermSpYHyuD9H46+uq74pR/fWT
         OSPrZCQIbL0fPvo6GgRAlqabZHvdaGtasLtO/iv9f+GmeorNoOSKdWOH1ulZHDvqmPgn
         rcUOucWNRiYfULyowOl5eIZ0mTmgqw7JhXXbLp2YRohvQw7XTkHmZ6bDSW9R3Oy4t4zm
         87CmWU7WJ+8J2+PkS2kMvsx7lsEHdrumxu80nI3b28YxMLxuGNOsVenLcv42RodMWcWj
         Bygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U+1ZMb25RFdAwm161yRXw6iBBPms0tJ9oVdKiifaLz0=;
        b=XjCaJvJQOg76xiu9lBNggjBfV4uRB7nJpKa7cSiAO+4rowOh+g/Q8z1EM/RAYeSPrq
         UcEwXVjmJsaSpjZ1+WZYR4TjDtWZbMmK5ogYOqFVuw3uxArnJNZtM8QjB3gtCeb12NeD
         mbpZOFyR8sceYEnUEGNkHCoc3vP/QabuHXzGd/6lo+70HvXQ6EPc4sZ4mELDXdQAsFxG
         RT4dUz7VUie1D8HN32Ok/OtjljDk1z1hbcZtdH0Hmu8ttRcb+KzFPmkONrAIdJxxP3xH
         PQVKZ/GhyjrTcI9z4sfIlgHKIdcTq2PvyJVPPGEpSGhZAPmQykBoG5GDNH61/VFp9nAj
         pBGw==
X-Gm-Message-State: AOAM5323rPDycIAz8PF2cqj+dW4a3P4AynZEThIaIOf0xuaS/0kud1ei
        JyMCMtLKk50xgyQFMyWr00ax9w==
X-Google-Smtp-Source: ABdhPJy6NMfLKmLLwqCdQ0mqYzjtcIr124BMXvfDpKPKfCK9adSmC7aHNl4K+T2J81c9Ph/X9DldoQ==
X-Received: by 2002:a92:ca46:: with SMTP id q6mr15013771ilo.54.1637785520542;
        Wed, 24 Nov 2021 12:25:20 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:20 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: explicitly disable HOLB drop during setup
Date:   Wed, 24 Nov 2021 14:25:08 -0600
Message-Id: <20211124202511.862588-5-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During setup, ipa_endpoint_program() programs each endpoint with
various configuration parameters.  One of those registers defines
whether to drop packets when a head-of-line blocking condition is
detected on an RX endpoint.  We currently assume this is disabled;
instead, explicitly set it to be disabled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 405410a6222ce..eeb9f082a0e4c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1542,6 +1542,8 @@ static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 	ipa_endpoint_init_hdr_metadata_mask(endpoint);
 	ipa_endpoint_init_mode(endpoint);
 	ipa_endpoint_init_aggr(endpoint);
+	if (!endpoint->toward_ipa)
+		ipa_endpoint_init_hol_block_disable(endpoint);
 	ipa_endpoint_init_deaggr(endpoint);
 	ipa_endpoint_init_rsrc_grp(endpoint);
 	ipa_endpoint_init_seq(endpoint);
-- 
2.32.0

