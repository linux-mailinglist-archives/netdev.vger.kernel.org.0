Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3A830DAC6
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhBCNOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbhBCNOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:14:17 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825DDC0613ED
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 05:13:37 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w4so4177415wmi.4
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 05:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3zTrT8DqOxrnBZIxJZfCadagMGmp4zh/P33tFZaO36k=;
        b=f8WN4J2xYD11sSQVPXigPsMYzV0Qj++lnPLev7OzidLAS5B8uamWhU+04s3I1hi29v
         9czJtKdMV06+LY5J21QCAj9fRo5x7h09wUJK/RYvXtcOOnPvUR/LQtIeyVtmtedVusn7
         813NLDYELZV5FVVe/RKGxmAj3csF2vi8UK7WkXAngNNus8Edt8vjL6cxMe0xHPRZPnRr
         RwYphnFOkwwtxc2oXAglydCXQvPhUj4pTbMMQ5lzZrP9n2dawK7ZbyfpVvm0YnDtrPb5
         U8++Ix+Iexcfjw9CqCE+iqFZaTw2B0hovUSbab9/cMRk6M4XOM1F0b8vu7usuBZlt6TB
         9hxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3zTrT8DqOxrnBZIxJZfCadagMGmp4zh/P33tFZaO36k=;
        b=LVAOuk/VXXZyAAPTyrTu9szYg6EDZsYMNLTYM15syjrvFGSwPBTm8FZi1sbl9jJcG6
         2Xge1S/Hb9xgzv3d30rUxGH1+UOCsNblMiv5P/lteWHeI43LIeA7Ps3lP27jiF0Nm6Eu
         4DDD5VJpAIaL3uDok8pc5rKw6fdQXs/BfYqYMp8JwCVKLfQHzA3piswxNmkJEQuDvoEW
         1JnVmQyKWvEhrgZLgNM0vqs2tqihb8C4K5IjwOZiGvqP7nh4jPLphFry/sTjKWtfSSaW
         SKn7J4Eun6ABc1Rof7v9DgpmvOsqTh/IaQDVHPZTr+lyKScOxvETLfNUNOjPRMyLGE1o
         mUYw==
X-Gm-Message-State: AOAM530ag4bnhbK76PhMNL+wkhlifmMJern+D+WJ+UQzxdW0QJV+HOWy
        Ky/yfyjziPrQlg7f+xtvGk0z2w==
X-Google-Smtp-Source: ABdhPJymzd3D89k5MVw3uDvVADpfWqSwnaF5ntZa1lnwfjOQviKvOBT+VJvVbfOW4lop0FDsNbBO7A==
X-Received: by 2002:a7b:c458:: with SMTP id l24mr1573793wmi.73.1612358016249;
        Wed, 03 Feb 2021 05:13:36 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id l14sm3852472wrq.87.2021.02.03.05.13.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 05:13:35 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v3 2/2] net: qualcomm: rmnet: Fix rx_handler for non-linear skbs
Date:   Wed,  3 Feb 2021 14:21:16 +0100
Message-Id: <1612358476-19556-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612358476-19556-1-git-send-email-loic.poulain@linaro.org>
References: <1612358476-19556-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no guarantee that rmnet rx_handler is only fed with linear
skbs, but current rmnet implementation does not check that, leading
to crash in case of non linear skbs processed as linear ones.

Fix that by ensuring skb linearization before processing.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 v2: Add this patch to the series to prevent crash
 v3: no change

 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 3d7d3ab..2776c32 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -180,7 +180,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 	struct rmnet_port *port;
 	struct net_device *dev;
 
-	if (!skb)
+	if (!skb || skb_linearize(skb))
 		goto done;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
-- 
2.7.4

