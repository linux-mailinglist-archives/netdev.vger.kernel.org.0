Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAD34A895A
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352583AbiBCRJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352554AbiBCRJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:45 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DDCC061759
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:41 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id m17so2617860ilj.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgsdnCvj6CM3pv7GIi7Q7qxhb/rwEQOt/gAxMz7ESwo=;
        b=CV9xhfZ4p0xRwN3tI5jIW7vkfasMn89uQPYfbgfEIRzmhSKWGFDIibcLrUd/XAE3LZ
         9lFBSDFl0HyFQ+r4NXc0NEMLC5cCgKDBQGtn3cM5IOwKhQuc2JSmeKxGagNlE4aB3u2T
         PrhktKmmbfJVOJAVYd2p8dyo9PwwgWdtRq5T7KFMFaFotAiOlBySMnyG7pMF0Nku1WtA
         4aKtoEYGT3s49glN2KXpPDtnWNe5E0+B0h/lripFYoNBWssVkWBZjwfYUmTdDvquEsKe
         PDqu8waRlxXthYp99P9TfH+I350rX0bJujYbjqOjnysdEcf6CaKeKAzBqMvD34eohO94
         RGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgsdnCvj6CM3pv7GIi7Q7qxhb/rwEQOt/gAxMz7ESwo=;
        b=Ofnx9Frqjq3qZjSfLDYm6ZvKEROplXIX5XOFFFEFmJ9sikRP5dAMeQGADsFIzmDvYR
         A2wDD15NlzKpvlza+l3guMedhd+j+/eRKMhr83ICQ6qRj/jUkVXH0r48RBBd2XTcAMBG
         ZmEW7w8kk/+2T6ylWuCHsw6urR69FilxHPC3xaLDi1cGCyRJHLGeBB3eAWDoUsfOO/Ce
         g1zZQ5d6CLr8Zu9wgeM0CG2XncNk6scpQ/YjSG3f85Sj9pJBh4jvEVq54m90U9sVwRI0
         k7rjw8xqWM4GeGx3/Qc3+bVit+EgeLh2MVyg/98o/RF2pM2g/yk7UppHuTi9P55SKsRQ
         TJXA==
X-Gm-Message-State: AOAM531faP/lRmjOWfIrij8Z5EMuD9eImakh2O5NlPAcZQsgK7RsakFv
        eJLos4KU1OirFkB1+TgiDszV1w==
X-Google-Smtp-Source: ABdhPJwPNHidFImaNmF7P2maK7ImXz0odBg3rq1AugQJbNWk9HprTIkONp3Cqhoc/6JALaNpiRutLw==
X-Received: by 2002:a05:6e02:1946:: with SMTP id x6mr5642505ilu.236.1643908180968;
        Thu, 03 Feb 2022 09:09:40 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/10] net: ipa: don't use replenish_backlog
Date:   Thu,  3 Feb 2022 11:09:23 -0600
Message-Id: <20220203170927.770572-7-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
References: <20220203170927.770572-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than determining when to stop replenishing using the
replenish backlog, just stop when we have exhausted all available
transactions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index f5367b902c27c..fba8728ce12e3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1087,11 +1087,8 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 	if (test_and_set_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags))
 		return;
 
-	while (atomic_dec_not_zero(&endpoint->replenish_backlog)) {
-		trans = ipa_endpoint_trans_alloc(endpoint, 1);
-		if (!trans)
-			break;
-
+	while ((trans = ipa_endpoint_trans_alloc(endpoint, 1))) {
+		WARN_ON(!atomic_dec_not_zero(&endpoint->replenish_backlog));
 		if (ipa_endpoint_replenish_one(endpoint, trans))
 			goto try_again_later;
 
-- 
2.32.0

