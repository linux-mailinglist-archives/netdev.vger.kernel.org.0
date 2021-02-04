Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6655530EE86
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 09:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhBDIdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 03:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbhBDIdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 03:33:03 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894C1C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 00:32:23 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b3so2443144wrj.5
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 00:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=899GESZRsKNDKJUPjgkSTANdjTR6H3fnpcwp6mKfLQw=;
        b=T6IKQbl6kmygVHF5F8vTj/ve6Rdy/+J0NJKDQUaaKKQh1pU/CRF9Ff+xjb+2OiP7OO
         m5ZfDwSlPA8meqvZcG+x3R26u6iK/n14T5S7fvV6YOSlIf9GpWBpPOfPAZ/u+1NTo7lJ
         1bWdyhCpyEri3HIfxKtSTqIcU6j6vxPDg90zTe2GjEPNXHy2rAwpxxZpfq5Y0/kyZQy5
         xYy59Dg2QAA4+OTNlOe2SLObn08DVTmTYTvHGhVPEnGdTsGZZuNZR+9YtAZorboNMkax
         d92/fFXbk73M+sTAxJl53l/Tf+legFXCsNcWlX2Ez7C+Nob0OuPjEpjU8ank9jmZjDac
         Gk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=899GESZRsKNDKJUPjgkSTANdjTR6H3fnpcwp6mKfLQw=;
        b=Qf7rDrS02eddb3c1Vam4slxIzGS+TNnBSa60PzrWA37z25vBX+OSJ4aDhT9TpH98El
         B3Q3OIzRdvM9ZVYqcC+8jS4UyiDLN3jybu/1jy/n/5sTpNyhW6DfvPuYr56jqdw9EeLQ
         qT41KKLnD+F7gowRrcZ0ITAiGUN02QtXcP5DkBj/pkZcZzIyw4AY3OJY30j/Mvs+Clvc
         pliWbvQ3DmDp87IbXN2K5UgfzF5iEZK0kmQdAb5nXFuRo0agM0Z3NEkeUBmVo+iQmhwv
         Rf1WSrASKHNpC3z0jRkOj8Vyv8ax37wBvxhl6fuNGPu8VJDTdMmV7mP08jSLJpMWBRG8
         Qa/g==
X-Gm-Message-State: AOAM5309e5wm2c7SbqfBPE3uzRiTIMulN1EEK5LkoHlTsqzcRp57spkP
        oLx/4+clzFCCd5V0EGHMoKYmveWZdm5hlg==
X-Google-Smtp-Source: ABdhPJzBrfnCugKk9uBqawxXykpT03dSRpAWSXxl9sqD7EpZC39HTjKk1fNjSbKQANZWQuJZcRxzUg==
X-Received: by 2002:adf:e80f:: with SMTP id o15mr7889152wrm.366.1612427542250;
        Thu, 04 Feb 2021 00:32:22 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id x9sm5657238wmb.14.2021.02.04.00.32.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Feb 2021 00:32:21 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v5 2/2] net: qualcomm: rmnet: Fix rx_handler for non-linear skbs
Date:   Thu,  4 Feb 2021 09:40:01 +0100
Message-Id: <1612428002-12333-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
References: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
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
 v4: Fix skb leak in case of skb_linearize failure
 v5: no change

 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 3d7d3ab..3d00b32 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -183,6 +183,11 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 	if (!skb)
 		goto done;
 
+	if (skb_linearize(skb)) {
+		kfree_skb(skb);
+		goto done;
+	}
+
 	if (skb->pkt_type == PACKET_LOOPBACK)
 		return RX_HANDLER_PASS;
 
-- 
2.7.4

