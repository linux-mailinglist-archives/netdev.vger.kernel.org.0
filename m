Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB22623FA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgIIAWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgIIAVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:41 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF63EC061786
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:34 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u126so1286015iod.12
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CLkAtO8yV6hC5XQeCIKds/Y/O7Y4arloVOta9bNoDaY=;
        b=hq5DELpR+vU0Y9o5e2HUj0mATndL/qH/lvWoOo5vpdPAnLmfDyqNVW2XmT94onsQsr
         qsowN6z3HwhMa7tuAn8DwOQrm6Va35JvqXV2sda28FRc5mgRitvOeT2mN3Ane0hyyDbU
         WYrH9+XjpJoYQz6usO7IoYk33gAKTd8gGyjs5nC9rd7DQk67XFE+YfhvlwrOzJJaf83w
         jqsDM1wexcB9D9Pc1af4smM3lwmMrlpX00yLkLx5ky2Q7GJRcpEDoZJ7+Ax5AZrPGVJZ
         hlgEBHyUZMu0dGFEZ5sa2cJ+/fb8ifo+9EtvXPcHkwQ4eFTqslM3Yt3+exuWte+6VHRt
         QulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CLkAtO8yV6hC5XQeCIKds/Y/O7Y4arloVOta9bNoDaY=;
        b=i4Bq7UBZGxKE4I545VCsmBaPcQMVk53pSYANLzRwKg6n7zXxgKReoxFF84SJcXm+KL
         xyez4AiXMmvomEfv/2kEFZQq7U5XNId1jNleDNKXTXJ1BnuNKlFOH9Gn8IqsXVjyMkXM
         sXrunUYuUepW7EUkc6Mnd6afK6CV3sjkgbtub7pSZrfyENLHvU75ezoQW3a30Veov9w2
         TWcGG/BxX3+9Y80/6RUpw8tTfYfl42FpnvY55eIM+HUAIIjh05PJp6pWd328Kh4/bPyq
         hyix3E7O7tKEw4sXzx4fPZrjBshNbpfa9kRnac4Ey7xMiKRHbRprkzn0MbMVKdebktFz
         EjEQ==
X-Gm-Message-State: AOAM530Wgcce380c5vAD+ZsnV/XYn14jF8fFJ7klBCR12N5r40pfcnT+
        8jRpHW+PKi27/0EtcYtM/yYQSg==
X-Google-Smtp-Source: ABdhPJyzaytMOdMELvsLiAoxAUyb2niwFIKcmbNaUbQfBW1zi44brpxBXl/X/F5gRw/0l7C1M2zV+Q==
X-Received: by 2002:a02:ac5:: with SMTP id 188mr1673917jaw.79.1599610894247;
        Tue, 08 Sep 2020 17:21:34 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:33 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: ipa: manage endpoints separate from clock
Date:   Tue,  8 Sep 2020 19:21:24 -0500
Message-Id: <20200909002127.21089-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909002127.21089-1-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when (before) the last IPA clock reference is dropped,
all endpoints are suspended.  And whenever the first IPA clock
reference is taken, all endpoints are resumed (or started).

In most cases there's no need to start endpoints when the clock
starts.  So move the calls to ipa_endpoint_suspend() and
ipa_endpoint_resume() out of ipa_clock_put() and ipa_clock_get(),
respectiely.  Instead, only suspend endpoints when handling a system
suspend, and only resume endpoints when handling a system resume.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 4 ----
 drivers/net/ipa/ipa_main.c  | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 398f2e47043d8..f2d61c35ef941 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -229,8 +229,6 @@ void ipa_clock_get(struct ipa *ipa)
 		goto out_mutex_unlock;
 	}
 
-	ipa_endpoint_resume(ipa);
-
 	atomic_inc(&clock->count);
 
 out_mutex_unlock:
@@ -249,8 +247,6 @@ void ipa_clock_put(struct ipa *ipa)
 	if (!atomic_dec_and_mutex_lock(&clock->count, &clock->mutex))
 		return;
 
-	ipa_endpoint_suspend(ipa);
-
 	ipa_clock_disable(ipa);
 
 	mutex_unlock(&clock->mutex);
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 6b843fc989122..b8e4a2532fc1a 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -917,6 +917,8 @@ static int ipa_suspend(struct device *dev)
 {
 	struct ipa *ipa = dev_get_drvdata(dev);
 
+	ipa_endpoint_suspend(ipa);
+
 	ipa_clock_put(ipa);
 	if (!atomic_xchg(&ipa->suspend_ref, 0))
 		dev_err(dev, "suspend: missing suspend clock reference\n");
@@ -943,6 +945,8 @@ static int ipa_resume(struct device *dev)
 		dev_err(dev, "resume: duplicate suspend clock reference\n");
 	ipa_clock_get(ipa);
 
+	ipa_endpoint_resume(ipa);
+
 	return 0;
 }
 
-- 
2.20.1

