Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114083F22F1
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhHSWUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 18:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236765AbhHSWUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 18:20:08 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2570BC061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:32 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b200so9675899iof.13
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 15:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RpntrM1ojw2u707sqzIhjLaMl82LdztxT4txCgjSHJ8=;
        b=Vp+d2kr1vHaaDyRPGeK1E7OMCamEZUKB9u0jcPpuxm5zdjLvv/fo5Zfbsvj/6gq62X
         DpaY7O2p2NRx3MkC+WdgXUnnT5OqCmy/VHZVWCvnCwjsga5IIg3giZukBsX/kh0ySd/Q
         6Y4heoDSiClADHXuAxJkp+vnBW4pVFC63VdS5ATO4NthNQ4eHsdMRYF79dN7C1lctE+n
         P5enikwYkgifcuPU23VogD9nTWb155j6kjbrQiWEZOAYc0dmHWhZbWu4d7oTj7THNn0y
         fqMr5BIjsHux2Iz0cw4zDGle3rF7V3I383BjDBZw2YCA4nsWlSlCLA/sDKqcCqdNwJoL
         raEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RpntrM1ojw2u707sqzIhjLaMl82LdztxT4txCgjSHJ8=;
        b=q170TtYlgs1GXTuLXy6AdUE9MzpKbUua7npJhC+GQA5ofr8eYp3bAOj7Kwc4zh0J07
         8sp3rJokyncxLkOMJYhJBWAsGO8AUav6CCpWrlfBVWbWfCOm/UMjYylt/XfpICAnTi3F
         pdCKvBO8/dPBkFPX/wnEhbNNweEdZTEkSof7kNu8dg5KG2RRGTdxo4BPBl8xYs4Nh33w
         pQWA28090w7FAMhliqSoRLHrWcKoXxeBUNVevT3e65Ods4hy+wNTC4zbjID8rIJbFXqV
         wHE+B3KGAEOyvQa/9H0PtRrf9gpBmlcPTiWASKBMzRAQoRPz3B4FjG4k3DPG2AdHlZen
         dCWQ==
X-Gm-Message-State: AOAM5337lm6r5AfAxnVnqu/KyBL/nFMwMoMIgzb2FCAus7nxf5tYkNoz
        YQDwQI5/o+q4Wi4vcs7i/QyR4Q==
X-Google-Smtp-Source: ABdhPJwp5kTH7J9nnlJpXw71z0mfj+pXaFp782gcf3aN+xOY9hwjNCk/EAx9nTbX6shoJXUAMbDB2A==
X-Received: by 2002:a5d:85cf:: with SMTP id e15mr13333195ios.208.1629411571614;
        Thu, 19 Aug 2021 15:19:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o15sm2245188ilo.73.2021.08.19.15.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 15:19:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: ipa: don't use ipa_clock_get() in "ipa_smp2p.c"
Date:   Thu, 19 Aug 2021 17:19:24 -0500
Message-Id: <20210819221927.3286267-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210819221927.3286267-1-elder@linaro.org>
References: <20210819221927.3286267-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the "modem-init" Device Tree property is present for a platform,
the modem performs early IPA hardware initialization, and signals
this is complete with an "ipa-setup-ready" SMP2P interrupt.  This
triggers a call to ipa_setup(), which requires the hardware to be
powered.

Replace the call to ipa_clock_get() in this case with a call to
pm_runtime_get_sync().  And replace the corresponding calls to
ipa_clock_put() with calls to pm_runtime_put() instead.

There is a chance we get an error when taking this power reference.
This is an unlikely scenario, where system suspend is initiated just
before the modem signals it has finished initializing the IPA
hardware.  For now we'll just accept that this could occur, and
report it if it does.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_smp2p.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 04b977cf91593..f6e2061cd391c 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -16,7 +16,6 @@
 #include "ipa_smp2p.h"
 #include "ipa.h"
 #include "ipa_uc.h"
-#include "ipa_clock.h"
 
 /**
  * DOC: IPA SMP2P communication with the modem
@@ -153,6 +152,7 @@ static void ipa_smp2p_panic_notifier_unregister(struct ipa_smp2p *smp2p)
 static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 {
 	struct ipa_smp2p *smp2p = dev_id;
+	struct device *dev;
 	int ret;
 
 	mutex_lock(&smp2p->mutex);
@@ -161,17 +161,20 @@ static irqreturn_t ipa_smp2p_modem_setup_ready_isr(int irq, void *dev_id)
 		goto out_mutex_unlock;
 	smp2p->disabled = true;		/* If any others arrive, ignore them */
 
-	/* The clock needs to be active for setup */
-	ret = ipa_clock_get(smp2p->ipa);
-	if (WARN_ON(ret < 0))
-		goto out_clock_put;
+	/* Power needs to be active for setup */
+	dev = &smp2p->ipa->pdev->dev;
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		dev_err(dev, "error %d getting power for setup\n", ret);
+		goto out_power_put;
+	}
 
 	/* An error here won't cause driver shutdown, so warn if one occurs */
 	ret = ipa_setup(smp2p->ipa);
 	WARN(ret != 0, "error %d from ipa_setup()\n", ret);
 
-out_clock_put:
-	(void)ipa_clock_put(smp2p->ipa);
+out_power_put:
+	(void)pm_runtime_put(dev);
 out_mutex_unlock:
 	mutex_unlock(&smp2p->mutex);
 
@@ -211,7 +214,7 @@ static void ipa_smp2p_clock_release(struct ipa *ipa)
 	if (!ipa->smp2p->clock_on)
 		return;
 
-	(void)ipa_clock_put(ipa);
+	(void)pm_runtime_put(&ipa->pdev->dev);
 	ipa->smp2p->clock_on = false;
 }
 
-- 
2.27.0

