Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912AC45CE00
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235929AbhKXU2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhKXU2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:32 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C467C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:22 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id w15so3728993ill.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZCqaOer2ok1ocDOYiRL6Fx51PuC9d9Pr4rUsp1pZAp8=;
        b=EQYoknl5iHBH/JH9MgOiuwzo4aHCMCUs8dv+XfTbwTKAEzeJh7uzbUqJ2wd52ZJxNK
         qj7OFqPo6K0TiNFilTAj8n4wnvnF3Zaalw+QsdAHMIbDvjAf7xEBFTvXt8/CvFb4tyCw
         TkXzqkPDaw5VXmZabft2uvsYTa/kxJw+0Lg1Z1mgp1MGPpyvl0LjJ7tN1TmzA+oqpvgA
         hRc0T8xs9kIHLLdNyIJGjUmPuZ5jnQ/J4nvzGEieOCdDrn9wW9cLxnIupUBE8RRxDKrC
         PbF18D3Vw/zLRp5WWZq9bfTVimrhCg4KmTKrxWqPzigbJ1EmW1E+b0csPfqanRHjJvMA
         ylVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCqaOer2ok1ocDOYiRL6Fx51PuC9d9Pr4rUsp1pZAp8=;
        b=1QxA1qi5yqpunPKid4P5hg5zbUZGjFd68Is2aTLHdONl122Zt11KZwqV1JjB6gDvhU
         wwmNYinWZS6TC1jsy+5nZ0mn4kKvQWgu27gcPni0qHMhPEBCwV/l+BU6WDpUNZWjn/A8
         SKJHh+exg5IgXD5dMt7NfkyTRXiF6Id1vq6Kdf2C0LZa1CUIHin8edMSnzyQiPjIjlrn
         RA2TQNG6w48MSiKDtKH4pl3wviE6tX4XFd58ZyUl3U2scBrPAmtpbqCxigVkGoSEN2FR
         LDP02MwCt1PNGrkQCYWTbzc2pZnl9ZFcV5H5QuMjJtK/BdBTyFeXnRYuVm0YzB0bDVP7
         qZwg==
X-Gm-Message-State: AOAM531k5zHm6bjsDb50oAnz1CgW52R6WYsqj30TbfNlfeg1IcPEARUK
        Oy8ht0+EDLT5eJR7d29rC3x5UQ==
X-Google-Smtp-Source: ABdhPJwG9gEfx0GFEigZB6slQU6RWL9OQuF35yu01FXi7vGpSfutK5fHIrg/UuDZeBgF6+bx7VKjkw==
X-Received: by 2002:a05:6e02:1bec:: with SMTP id y12mr15676800ilv.40.1637785521741;
        Wed, 24 Nov 2021 12:25:21 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: skip SKB copy if no netdev
Date:   Wed, 24 Nov 2021 14:25:09 -0600
Message-Id: <20211124202511.862588-6-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_endpoint_skb_copy(), a new socket buffer structure is
allocated so that some data can be copied into it.  However, after
doing this, if the endpoint has a null netdev pointer, we just drop
free the socket buffer.

Instead, check endpoint->netdev pointer first, and just return early
if it's null.  Also return early if the SKB allocation fails, to
avoid the deeper indentation in the normal path.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index eeb9f082a0e4c..fba576a7717fa 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1153,18 +1153,19 @@ static void ipa_endpoint_skb_copy(struct ipa_endpoint *endpoint,
 {
 	struct sk_buff *skb;
 
+	if (!endpoint->netdev)
+		return;
+
 	skb = __dev_alloc_skb(len, GFP_ATOMIC);
-	if (skb) {
-		skb_put(skb, len);
-		memcpy(skb->data, data, len);
-		skb->truesize += extra;
-	}
+	if (!skb)
+		return;
 
-	/* Now receive it, or drop it if there's no netdev */
-	if (endpoint->netdev)
-		ipa_modem_skb_rx(endpoint->netdev, skb);
-	else if (skb)
-		dev_kfree_skb_any(skb);
+	/* Copy the data into the socket buffer and receive it */
+	skb_put(skb, len);
+	memcpy(skb->data, data, len);
+	skb->truesize += extra;
+
+	ipa_modem_skb_rx(endpoint->netdev, skb);
 }
 
 static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
-- 
2.32.0

