Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8592853E4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgJFVbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbgJFVbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:31:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C293C0613D4
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:30:59 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id 67so25068iob.8
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 14:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SeRQNuUdnOGTder7Ky3iLwHcr5kl6r9wzx3ytZhXRHM=;
        b=fJ1d5oEdTTRDoZEZYc7+uJD9E26J1Ulv2STtWruQ/rVOpCh8/JQoD7CeGhsVDMUUzq
         vWmfmY+74UnmgTAVJ/cAhw7QTP1Y48rz5/yZE+HIviCHEu+NKvrfmDMQLFmveT3isahZ
         iX8we2w3S6LOpPexhnjQK8dWXziqzgTAn2FB+y/74qTiRdhKCLzeFFGrISK9B83XIwrn
         rRlBZUmnvFVFuSXXTnaKd55jKDSxP/hqVxA4ZlWQCps3BazpNfdmmnx5Al9AF6j5HPJB
         iHaZiDgnrGi8Vn4pFZhS0uUUEKkjiSCECvP9HvvmzlGgf4Lp9M714NlzDU+CG1UqLZZf
         UVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SeRQNuUdnOGTder7Ky3iLwHcr5kl6r9wzx3ytZhXRHM=;
        b=dBYPr8CELO6wyfG4rDUy7SGHIEvIq/dC0UMoGDiYBJThYOSQcthDF4Cu7x3ZmZS4aD
         k2KJnOVpBfIq4h2zcy4qAYfNuYF0QbL51PKBiG8dNcPnx90nQJMGwwF59qGuR3ZdN7Bc
         MBGEbzck9X5MBu27Ax/3L06WLKgspb1eo5SJByGiJT4vxO214zfi+wDq2KRKrnSfRLMP
         /ylpAz/0Obd7OVy8zsTeoGWKj48bsRfonJ++13yO7p4oqxpDbH1vGcy7p61UUFjuWlI8
         AKBPbkvKuT96cKD6Gh5Jsp+m/f5Wll+IX4E31Dalep99nXjSMu8Gdx2H0sZSluyCy3i7
         hkdQ==
X-Gm-Message-State: AOAM532dcdDJ5E4qz4ptfIjvuXPbotXDAEvnYeI99BlFvZ50At20G/Ec
        eUbW79ycoFufQ4vHgRMaLUzz4l4oI1hC8g==
X-Google-Smtp-Source: ABdhPJzDr4PRceMlDmLxQwdrbTzP3K8MGoWz3gki9rB86SibkOnGYFFTCykXgk1plTn1ocsbTsCDkg==
X-Received: by 2002:a05:6602:2f07:: with SMTP id q7mr2795506iow.191.1602019858519;
        Tue, 06 Oct 2020 14:30:58 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z20sm2043215ior.2.2020.10.06.14.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 14:30:57 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: skip suspend/resume activities if not set up
Date:   Tue,  6 Oct 2020 16:30:47 -0500
Message-Id: <20201006213047.31308-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201006213047.31308-1-elder@linaro.org>
References: <20201006213047.31308-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing a system suspend request we suspend modem endpoints
if they are enabled, and call ipa_cmd_tag_process() (which issues
IPA commands) to ensure the IPA pipeline is cleared.  It is an error
to attempt to issue an IPA command before setup is complete, so this
is clearly a bug.  But we also shouldn't suspend or resume any
endpoints that have not been set up.

Have ipa_endpoint_suspend() and ipa_endpoint_resume() immediately
return if setup hasn't completed, to avoid any attempt to configure
endpoints or issue IPA commands in that case.

Fixes: 84f9bd12d46d ("soc: qcom: ipa: IPA endpoints")
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b7efd7c95e9c8..ed60fa5bcdaca 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1471,6 +1471,9 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 
 void ipa_endpoint_suspend(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
@@ -1482,6 +1485,9 @@ void ipa_endpoint_suspend(struct ipa *ipa)
 
 void ipa_endpoint_resume(struct ipa *ipa)
 {
+	if (!ipa->setup_complete)
+		return;
+
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 	ipa_endpoint_resume_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 
-- 
2.20.1

