Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A80748C4DA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353605AbiALNaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353586AbiALNaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:30:18 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A74C061756
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:30:18 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p7so3646478iod.2
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AdGgiTy1ca6E6R0J8IpPObnb+JKCw9LjIV8LaznMuzA=;
        b=VKRT5X/jiDsFfuzHXPgUMwAmChmh1p/Ck2bbOw2901tW0QBuV729R8eO7mlzdhdL8Q
         S32ua0PFiDyJoQBsMwsskiWPJt+WJ3WYWVPDnzX02eg2esSAOhizPT6kDO+fnOQAbCBu
         AaA5G+Tpbs1J9EFcg5Uzs8vddwGnrzQcZ3ubaf4tb3nSdq5ou0NrJXSaCcwMJvjMEWBc
         8QGF/cExVY0eISWPpfz2OsbO5oW5HjCU8ZvvQ1zMcCNeSUEVae7/GjkLtN+DxaesNh43
         /Bsf6PgdGqyjN25zYxrcgNXGDpfyBkbTJfPTlvrLkdF2iRlx3JvukTJfojQSjHVNhWfZ
         Wfqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdGgiTy1ca6E6R0J8IpPObnb+JKCw9LjIV8LaznMuzA=;
        b=iYRoqPCXXJyy7R24G/4NH19ZJV7SYCmh8fvpNAogViO3rx4uzjcXQzygOAd+y70mY+
         LpkyibncnQkmVLL3L30Lwoh85uUycQ0ZQKTsQ/Tm5d/sFLRvkVmDWO7japiA6wkPh09P
         +eoz3pjBml6tYUp9/cMYWCrD2nJvyuLKTW1Nq2rnLBZ/2N1al7KmtT0Xml8khPK4lN3c
         N19N1MZI3F89Lospfr136bOI2uSKqK71vCsZZJuxNWnmr6ZWXrQl05+bYyCDvpKoX/qT
         KED+cYettNuKMLSYvkHZcg7l71Hq1wvWPmMg6JzfRqSpxRyiwK1HaTEc3ZM0YgaO2qpR
         Ct7w==
X-Gm-Message-State: AOAM5307bkP8C1EAt84PmDItVjizpJPJdWp4NJOlGfnAb13daDvqg5F3
        SMgfH8962Q8/9AtwB1iweFNSNA==
X-Google-Smtp-Source: ABdhPJz7xAyhxz6eV25bqIWOiN4DD72PnUZDNw7Qd17sfeUEzdu9R8OSm4LBaClPke6BvVtzGSPf9A==
X-Received: by 2002:a5d:9da8:: with SMTP id ay40mr4396562iob.38.1641994217773;
        Wed, 12 Jan 2022 05:30:17 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e17sm7476742iow.30.2022.01.12.05.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 05:30:17 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     jponduru@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, agross@kernel.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, mka@chromium.org,
        evgreen@chromium.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 1/3] net: ipa: fix atomic update in ipa_endpoint_replenish()
Date:   Wed, 12 Jan 2022 07:30:10 -0600
Message-Id: <20220112133012.778148-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220112133012.778148-1-elder@linaro.org>
References: <20220112133012.778148-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_endpoint_replenish(), if an error occurs when attempting to
replenish a receive buffer, we just quit and try again later.  In
that case we increment the backlog count to reflect that the attempt
was unsuccessful.  Then, if the add_one flag was true we increment
the backlog again.

This second increment is not included in the backlog local variable
though, and its value determines whether delayed work should be
scheduled.  This is a bug.

Fix this by determining whether 1 or 2 should be added to the
backlog before adding it in a atomic_add_return() call.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Fixes: 84f9bd12d46db ("soc: qcom: ipa: IPA endpoints")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 49d9a077d0375..8b055885cf3cf 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1080,6 +1080,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 {
 	struct gsi *gsi;
 	u32 backlog;
+	int delta;
 
 	if (!endpoint->replenish_enabled) {
 		if (add_one)
@@ -1097,10 +1098,8 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint, bool add_one)
 
 try_again_later:
 	/* The last one didn't succeed, so fix the backlog */
-	backlog = atomic_inc_return(&endpoint->replenish_backlog);
-
-	if (add_one)
-		atomic_inc(&endpoint->replenish_backlog);
+	delta = add_one ? 2 : 1;
+	backlog = atomic_add_return(delta, &endpoint->replenish_backlog);
 
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even
-- 
2.32.0

