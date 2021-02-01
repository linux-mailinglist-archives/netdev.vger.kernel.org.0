Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E860730B387
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhBAX1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhBAX1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 18:27:35 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC40C061788
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 15:26:16 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id y5so17351201ilg.4
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 15:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4p3cO0YhU77yiKrmXUdqUneMp2jPhjqG6jsuBLPBK3I=;
        b=fzhtc7G12o7cHQ/MNxt58fASJM++yTIgQXR2x/P9wu6V2kwj0XRPFgzlqmWSeDM6mx
         Tx3an9GGlh1C6/EimXvEuqw/Qepskh6UMcU5YpKwSJTGFtjvPTffqv8z03Laq02QmCBl
         rtacQ3zeR8qBBUGsHGV2HYqupXFUDYiCDTNHcAJtJkOQldKz7alS7HtCDEnIXYubmG/i
         vu77DKOSnGBfCoPH8BZkEIE3FEF55H8D6gkflW9wSkB4MgUlqzdmvFqw2QXui1kaqALM
         LEbPEMF3nJiQkVUadJwU6avT30b7TCXVHqEwqRsomfMHD5/fA4bJAVfYQ+DpON38ugKT
         HK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4p3cO0YhU77yiKrmXUdqUneMp2jPhjqG6jsuBLPBK3I=;
        b=U5rd/s+EmTgZVHtaSLbHXpZHwJ6KYPwWvkDCpPaPyA8e1t3dbQMl348dDLDRsw+bPU
         u0/EXLSY5fEQOKsmFzb3zHrgfkXHvXuoZIpxqf8Ne2OIBoNH9VD3Xy57wzbvgxmPvJ3/
         EtE5BrrH7x4A1tjin6NFuHjctpSgo8raJCCqTNf65rXO3T4GIwX+SEqv7shZhjl6f9mx
         nqCQ3OLNB5eEOZ9yefW0ZOoPWHwiSDcZeAK5cjWJTN/7q4eOXGYLHkibvtuinC26YXMf
         9NLdpM1h+8+BkDX7Ynsf7q4d2YpcdjETWqsUgMnw1mhBvEDZ0FjcIZn/PVvkacCoToYn
         mQaw==
X-Gm-Message-State: AOAM533dWxNXhKZqanL9alb7G4mlQTZwszIulifUJJF7UOBHOV2gGAfd
        HhIh+EkTJ+JpAELEujkP3lNBXg==
X-Google-Smtp-Source: ABdhPJxNv2yO2GOGS6/2Ka74PIcJhsi0vaa+Pfwh3gDDzdWTaNIvB+ScVb6NrGtPTiwItSRS8SY6Ww==
X-Received: by 2002:a92:cccb:: with SMTP id u11mr14751002ilq.44.1612221976467;
        Mon, 01 Feb 2021 15:26:16 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v18sm10359588ila.29.2021.02.01.15.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 15:26:15 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/4] net: ipa: use the right accessor in ipa_endpoint_status_skip()
Date:   Mon,  1 Feb 2021 17:26:08 -0600
Message-Id: <20210201232609.3524451-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201232609.3524451-1-elder@linaro.org>
References: <20210201232609.3524451-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When extracting the destination endpoint ID from the status in
ipa_endpoint_status_skip(), u32_get_bits() is used.  This happens to
work, but it's wrong: the structure field is only 8 bits wide
instead of 32.

Fix this by using u8_get_bits() to get the destination endpoint ID.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 448d89da1e456..612afece303f3 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1164,8 +1164,8 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 		return true;
 	if (!status->pkt_len)
 		return true;
-	endpoint_id = u32_get_bits(status->endp_dst_idx,
-				   IPA_STATUS_DST_IDX_FMASK);
+	endpoint_id = u8_get_bits(status->endp_dst_idx,
+				  IPA_STATUS_DST_IDX_FMASK);
 	if (endpoint_id != endpoint->endpoint_id)
 		return true;
 
-- 
2.27.0

