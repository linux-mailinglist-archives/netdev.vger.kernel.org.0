Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F2A2C4947
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730685AbgKYUpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730564AbgKYUpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 15:45:43 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBADC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:30 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id z5so2754324iob.11
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 12:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=17RumLVAn5UfdPbTYAvhoBEDzwtSfk/5DXo1nQgiciA=;
        b=u0HuCy0OAdlbZLkbvWbfH0HySruX3gBELz07DNub7sPRF2SqRKpsFLfPgrr3RHfKDA
         WsBGAKLCl8Z0JP2U5fqURn/F++/0+IT3PLI/gImiT7QK9cN4hcefTAR2k0o09dQr7nQC
         d4BDhDMfaumwZyyOskhxKKn2E8R0ZM63iG6Hf6s6RFPhDLpeiUV1PcK9IEcw02AlFDD8
         Gxl+OTZRM5QXmc7QvdP6DxMd6UjGuHCtoJyaSvAe8VB+aH6LwZs1exkPCx+h2QAB/uf8
         eLiGs2b/bi/3lYtbUzHN6B5v/yMg31oXGzpIOZHb/LavKQlYcASu14Gj7Xvr0DdgYGFB
         4RdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=17RumLVAn5UfdPbTYAvhoBEDzwtSfk/5DXo1nQgiciA=;
        b=VAsk/MO6hWAQ07uMSMo6WjCLUJ/o28rLH5ho73vr6BbdjnqQ4FSHFgxtTh/y8lYVmL
         zpe6qrMaHhqJQ8YtCnSKZ4Y1qFI3pAg5HxmeZOE7Mj9H4yQZWyEbpyCXqLFl5sxwK7iS
         1nMYJZiBvZCLrv1Jp+axc47Z2KdX2pPZV4rLzpxNKhhH0bxOcTeyjYtYk/6tJsrDmNrO
         CkhpkTL6RNSVo7nPHlh1uUk9U/oubrGfGz/PBqqywUCZ+uY00DvLr4leRmGaBRs7dHgc
         SZAV/xNqR4WatZJSHEPCXF3HUumtjJUyUzGvz51WqIGzqaylhmkIHONe0N7Cp7kUkCaM
         2HgA==
X-Gm-Message-State: AOAM532yMunI+HOMzLbdIcWJdLpFgCQWT9xUKO3YLU6biBvTbufiMU84
        wAGvhBvtUuIO2h6W8Luy0W6CCw==
X-Google-Smtp-Source: ABdhPJyjl3KceJVby0AIGPBUf0JmEZ38DfWuiYVJOOoxL1+6TMRzXZsK3M0A4tI0dYUVcSYEXL3Ccw==
X-Received: by 2002:a02:4c8:: with SMTP id 191mr12903jab.70.1606337129858;
        Wed, 25 Nov 2020 12:45:29 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm1462225iom.36.2020.11.25.12.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 12:45:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: reverse logic on escape buffer use
Date:   Wed, 25 Nov 2020 14:45:17 -0600
Message-Id: <20201125204522.5884-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Starting with IPA v4.2 there is a GSI channel option to use an
"escape buffer" instead of prefetch buffers.  This should be used
for all channels *except* the AP command TX channel.  The logic
that implements this has it backwards; fix this bug.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index eb4c5d408a835..2cf10c9f0143d 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -781,8 +781,10 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 	if (gsi->version == IPA_VERSION_3_5_1 && doorbell)
 		val |= USE_DB_ENG_FMASK;
 
-	/* Starting with IPA v4.0 the command channel uses the escape buffer */
-	if (gsi->version != IPA_VERSION_3_5_1 && channel->command)
+	/* v4.0 introduces an escape buffer for prefetch.  We use it
+	 * on all but the AP command channel.
+	 */
+	if (gsi->version != IPA_VERSION_3_5_1 && !channel->command)
 		val |= USE_ESCAPE_BUF_ONLY_FMASK;
 
 	iowrite32(val, gsi->virt + GSI_CH_C_QOS_OFFSET(channel_id));
-- 
2.20.1

