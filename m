Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB40967A209
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbjAXTB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjAXTB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:01:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696E54DBCA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:01:25 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id g23so15636525plq.12
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SEJDfnpuHczelrJ6vp0fb1JDaeIwWS2iq2BACn7e/IE=;
        b=ZPjYuk0ya4aeNvJO7qCFVWhUdg0oqrtCfCmpbpBLA+ntney22BIz/3+x+FcjsEArwy
         EhC1rTUOzPpnWRcgDlgTPkpWxjQVhxbNJKGVBjVKQb4u+qsL8owwjnObWFkBj3oGR3sl
         BW7yKEPe0fUVC9ATGwooiBc7H5EhIV8q26nao=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SEJDfnpuHczelrJ6vp0fb1JDaeIwWS2iq2BACn7e/IE=;
        b=FemTqOT05r7jeAHZr38GYqfJpzMVPnfjBhdcfqwSVV+FLXKViLPIlbdAwf3ATFaVcR
         GbzHSbES/RVppd0kQQ8m4EZYIYQj/QUWgkQePOscqo0X4rtBebGYnLyiNJIJCanLPJkr
         IiWnn0cT3l4YOlIuxGPBBZSMN2cK3tGLBRN20Uj+3F8Uk/bt/N2uSRo6c7+Pd4b1HXYb
         bkO4jLaK9arja03Rpn/ERh1wvasJgVcpwu1OHjta0Ixi3IS7MCENyyMI0TrymWlPxNuC
         J0/y2A6vr6fqX1sm81ZRMI2ZOKOSrclLf8oLSOe9jDcy72DDks0igtzE8M0ZlaDkw2SH
         v+NQ==
X-Gm-Message-State: AO0yUKVvpoly5jRi05WD31kDhBF3bm3cRCyfdcEiKCwaBldvqDqbj8tf
        RcHhHdS/kg5mZ5z8gLLT2OsHeA==
X-Google-Smtp-Source: AK7set9PfKKjjgxVS13+YwcKa14yZ/3qzh0IOTUKCI7B6Y/ZCJe76Mnqs2L7VttHh0r/YqkC2bCS7Q==
X-Received: by 2002:a17:902:e747:b0:196:1d89:7002 with SMTP id p7-20020a170902e74700b001961d897002mr1941570plf.31.1674586884928;
        Tue, 24 Jan 2023 11:01:24 -0800 (PST)
Received: from tictac2.mtv.corp.google.com ([2620:15c:9d:2:7b28:de8d:ee0:2cd6])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001948720f6bdsm2010415plt.98.2023.01.24.11.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 11:01:24 -0800 (PST)
From:   Douglas Anderson <dianders@chromium.org>
To:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        junyuu@chromium.org, Kalle Valo <kvalo@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] wifi: ath11k: Use platform_get_irq() to get the interrupt
Date:   Tue, 24 Jan 2023 11:01:00 -0800
Message-Id: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the same reasons talked about in commit 9503a1fc123d ("ath9k: Use
platform_get_irq() to get the interrupt"), we should be using
platform_get_irq() in ath11k. Let's make the switch.

Without this change, WiFi wasn't coming up on my Qualcomm sc7280-based
hardware. Specifically, "platform_get_resource(pdev, IORESOURCE_IRQ,
i)" was failing even for i=0. Digging into the platform device there
truly were no IRQs present in the list of resources when the call was
made.

I didn't dig into what changed between 5.15 (where
platform_get_resource() seems to work) and mainline Linux (where it
doesn't). Given the zeal robot report for ath9k I assume it's a known
issue. I'll mark this as "fixing" the patch that introduced the
platform_get_resource() call since it should have always been fine to
just call platform_get_irq() and that'll make sure it goes back as far
as it needs to go.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---

 drivers/net/wireless/ath/ath11k/ahb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index d34a4d6325b2..f70a119bb5c8 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -859,11 +859,11 @@ static int ath11k_ahb_setup_msi_resources(struct ath11k_base *ab)
 	ab->pci.msi.ep_base_data = int_prop + 32;
 
 	for (i = 0; i < ab->pci.msi.config->total_vectors; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
-		if (!res)
-			return -ENODEV;
+		ret = platform_get_irq(pdev, i);
+		if (ret < 0)
+			return ret;
 
-		ab->pci.msi.irqs[i] = res->start;
+		ab->pci.msi.irqs[i] = ret;
 	}
 
 	set_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags);
-- 
2.39.1.405.gd4c25cc71f-goog

