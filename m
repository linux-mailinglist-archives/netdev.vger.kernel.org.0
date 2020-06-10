Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7911F5C3C
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 21:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgFJTxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 15:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730362AbgFJTxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 15:53:50 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA5EC08C5C1
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:50 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c75so3175611ila.8
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 12:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NjH1etSnlY+P/0B3j0s0VstfhJWLswlmVgehJV9D28o=;
        b=LmFsn+i7H0lG2owSIrQFk7zD3AEzxMUy0bdlLNPUyt5D6sfBVlNAeQo1nctCYCk1uZ
         A8Oq1TnLOoPFvzNCduPaZ21+uWYg6XIj9+TKMWGjY2DXujGxKx4R9w6GzJwGYgRsgklc
         fwhWicjuXSiNxgMFEezobW7wnNOwDsZDqpXxvFe5n+FdfD+lJFob4cWqWeC/RQtaGObQ
         CI7EmdbO1jl2BoxWSMWJm96WPMllkMlihSQDKO+Zms2sw11jGNuq5A7wnFYaAjRG8375
         aPA0QV8ZJr94xd6FXol4D7j7Yzj9y4ViTDVz6ASnjsE2uL/jhi3M8axgU60ZDOtybEl6
         Gj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjH1etSnlY+P/0B3j0s0VstfhJWLswlmVgehJV9D28o=;
        b=QG6j76nbsBnfYsgebYtr/0h5Vi6q3k99slo05GdRFVsqf4qSC85PIFbrmlFX9/Cle9
         K9gMG1Octj3pRnQdsBmSBZihv4cw+yznXmqs3s1mTXZ9OkVhRUQEy/P1rhdA1/nUFKp/
         Qxf6GgzgA6jC1G8Wfz16+qukTw1CmffJAkWbKC3+bfS30KR/x01H4MGRD5yKD8uTB4Yh
         Oo1weIW+Cy+euiO+DiMIuw9hsDmf9mnP+er+8uPYn/NBV4h5ezxefzkSDO4BJeEiKYuN
         KyGLnQpNoZZfGimb8Bf8xQKZVcwrkCXqgjaz5t+xhIMo5hAdb+4KuFbFiRHdlAZEMBLn
         uv7Q==
X-Gm-Message-State: AOAM531kzK3hixOA1vAL045RA0h/p33jjzlpe0FwFJsjRtdWcFrGNpKQ
        6yXi/SoPb+Xn5yqUf9uT7kxTmA==
X-Google-Smtp-Source: ABdhPJz821OjuAkME6+VmAG0pbeCmuP/PzMRiXX+0/SyO8sxyqVwfRNkfhtXMX7JQoSgj3JXAyI2cQ==
X-Received: by 2002:a92:9f12:: with SMTP id u18mr4539197ili.287.1591818829501;
        Wed, 10 Jun 2020 12:53:49 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r10sm408828ile.36.2020.06.10.12.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 12:53:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/5] net: ipa: fix modem LAN RX endpoint id
Date:   Wed, 10 Jun 2020 14:53:29 -0500
Message-Id: <20200610195332.2612233-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200610195332.2612233-1-elder@linaro.org>
References: <20200610195332.2612233-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The endpoint id assigned to the modem LAN RX endpoint for the SC7180 SoC
is incorrect.  The erroneous value might have been copied from SDM845 and
never updated.  The correct endpoint id to use for this SoC is 11.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 43faa35ae726..d4c2bc7ad24b 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -106,7 +106,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	[IPA_ENDPOINT_MODEM_LAN_RX] = {
 		.ee_id		= GSI_EE_MODEM,
 		.channel_id	= 3,
-		.endpoint_id	= 13,
+		.endpoint_id	= 11,
 		.toward_ipa	= false,
 	},
 	[IPA_ENDPOINT_MODEM_AP_TX] = {
-- 
2.25.1

