Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E77B1F6E32
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFKTso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgFKTsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:42 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ADFC08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:42 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id p5so6653462ile.6
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NjH1etSnlY+P/0B3j0s0VstfhJWLswlmVgehJV9D28o=;
        b=SJufooEaW2oJZ97ZN0HwRFnWu1rB4LQXcCpBXvfjHIBZLtyZHH4hamqeq9bvjSRIRg
         TQh31oC9nwmoEthyhS6ksvUy87cVLZDuzBd+3y524NlA8yvOHu6X9qd1Ij8x6rcWAnI9
         I7I9DQcvXxwWkXN73NmxK+J3v6R9mCS+AaAPfG23E3zsKOVNl4qmqXpT0ZSNESX/27U6
         ueQKhQH+BrYJUzbUBokJ8J6qWP1kS3zsy/1aWWqfGhsGbs2Jtjb3N2fd2+RSIaV9tOlI
         Z76r3zE51nhcs6NzZG9PkQ37kMA8jUHbULqU0uCsJFBqtMPjXoV6djy2BmJQTIQgvUnm
         ysVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjH1etSnlY+P/0B3j0s0VstfhJWLswlmVgehJV9D28o=;
        b=WDe4b3yS3ybVjXakf9voGmmw98uohbIaUbdKr8H4iKsdLLYBWD9EwaWhtVP1CQLS44
         +A+2O/odtWi+M1pbvUXzok9gP2CxkZ+fhWt0cpEgcqqeR7khdbJUoBMk5gq4meDUVy3J
         7CX3OTaFjlKCDUSUorgZBedepHJjpDQUq47/N0PINNqMELYH8AmrTBxL/of8/qr3D/SU
         aAG3Z7uoLiLU64XPU9LuerCEWz8LTDzmAE4Wge/uMLwKO+Cyne4/parqHN78r6wgVEpX
         yiQX/gRpMYBuxSjG+Ybu+IxShs6a64hIkpgaVBbx2Gj32bzFmHo4upeFArhLxSeyRB4V
         6+LQ==
X-Gm-Message-State: AOAM530n9qOUOJ1asWBTJxCguHp+LxOMMGoH0Eekaf6QZOFHEQ6dOewD
        ZLRp+qDR48fJqz5QXFK7b+vldA==
X-Google-Smtp-Source: ABdhPJxIZ1W5PWpzI2JELMo4hBXi4JDXJKv6zkKL4Ga5JpwW6NobhFMwC2Of5JhA9DTjhXgXmo5ytw==
X-Received: by 2002:a05:6e02:1181:: with SMTP id y1mr8955423ili.111.1591904920921;
        Thu, 11 Jun 2020 12:48:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d13sm1981397ilo.40.2020.06.11.12.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 12:48:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/4] net: ipa: fix modem LAN RX endpoint id
Date:   Thu, 11 Jun 2020 14:48:31 -0500
Message-Id: <20200611194833.2640177-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200611194833.2640177-1-elder@linaro.org>
References: <20200611194833.2640177-1-elder@linaro.org>
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

