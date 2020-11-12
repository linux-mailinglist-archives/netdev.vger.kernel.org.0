Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89582B04BE
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 13:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgKLMMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 07:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgKLMMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 07:12:02 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACBEC0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 04:12:02 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id p7so5770589ioo.6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 04:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0z9Su447OPUlHIEYfLPhmXqBnr1rEvvT1M7lmEXZzGk=;
        b=mAvmCj4iAAwVkMzvQQdU9BOE9ZQe/Ou5+PwdAZRZzGhdykJywK2+nLEN/RrB0+KNdq
         eNMsS9RrvhZi9FAX2kMbYvJPZJVMREgdngIjDApBwI1A1xFF2/y1qbogL62W7w40e4RU
         UCXBsSrzSwSeRIn1oYu4yFBS3pNWpho3EpPgpfsOG7wOxCJq5q04n4neG0EXk92HzZbC
         79CUKDQDinFKkGOMzP6JKT9usk9B2O0LpJFPNm1bWC/2fveGxe8TE5OsYG1kZN5XTPk/
         l1nztzq3ogy8IMfNnJAxqcFOiG8ZBbATOrBYqqm2pxrcu5JuWud8Wg6IaOsMr1aXknA7
         8nlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0z9Su447OPUlHIEYfLPhmXqBnr1rEvvT1M7lmEXZzGk=;
        b=A5Klv+sIOjvnciuaQ3zmE0jIociGKNTIM0jNtGVlJcT2XQ811bpppZ1W0vADqFE/IB
         F+aWDGBMj7zGDqlLh14v5i/XhhzlOYy/WCGmfj40n3GEjB3BJUzMpOx66WJ4aY6yz10N
         EhNfiMLTLSSTs5BPvtpOVX1ZOvgNkkwrSdyQH8xxYvbL/BpmB6RKvSaggfDp+CG9S6+H
         NWv5uYxOFWEWJHktSZMlTfzjTRtkx5Bz9cYMbtz/GGQsr5VnTLmhqvaw1OSVUCjDjhQn
         bT0VkM6R5EYRHlFlWhhfO4uRq2j87bKwF8WWk0ys9cwVSmsMZ5QRz7oRk4sm78QUUpox
         Zckw==
X-Gm-Message-State: AOAM532GFe3iYNDTLd7jAB8LA1pRj5HL9QPYLLBteldqlBNw9b8bGI3i
        BntFpkJiN5GsmFp/OOR4NYR3kQ==
X-Google-Smtp-Source: ABdhPJzaynBvIGl23OX0H+PGygvTSLGmzTxbF5bG2BdPMepJLbLo2Bt80bXWlgqpRKZcgsREOGqEXw==
X-Received: by 2002:a6b:630b:: with SMTP id p11mr21931296iog.97.1605183121958;
        Thu, 12 Nov 2020 04:12:01 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i14sm2609563iow.13.2020.11.12.04.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 04:12:01 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: fix source packet contexts limit
Date:   Thu, 12 Nov 2020 06:11:56 -0600
Message-Id: <20201112121157.19784-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201112121157.19784-1-elder@linaro.org>
References: <20201112121157.19784-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have discovered that the maximum number of source packet contexts
configured for SDM845 is incorrect.  Fix this error.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index a9a992404b39f..bd92b619e7fec 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -150,11 +150,11 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
 		.limits[0] = {
 			.min = 1,
-			.max = 63,
+			.max = 255,
 		},
 		.limits[1] = {
 			.min = 1,
-			.max = 63,
+			.max = 255,
 		},
 	},
 	{
-- 
2.20.1

