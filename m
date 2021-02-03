Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9737930DDB9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 16:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhBCPLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 10:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbhBCPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 10:08:37 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F563C06178C
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 07:07:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 190so5887309wmz.0
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 07:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cDYU5QBZ3HSMpQm53VxMwLKdwiTSZf4S7HSLSzlvwSE=;
        b=TypBnewAiuviLdO0g5VfWBPzbML4rJtIzYuHADiWs2Hlj8ZLgkiwheXWq3OnG61S5r
         k2ymM1gKhggQ2nxTdtygu5gZF1lSsiV/lmluj9Izw0xcBPaAOnw/Ts05LgB/NXDktDMV
         M+pZOQxm2TwkPYvb7K7qc5SDuZ41jziuF4BLWv4oTMRRZtL9MOg8drRLw76lAFBzJH+x
         IQka/kkCGbphkLJ/BzSruwjQXpzghf/WczQQ09ftKIjqF8xy9bP4ESquHtmf9rvoeo+p
         SIAyhVNQPvtk4JucG7BD/TpvD+WWHfV+RiQiOSuvPgZwRnBri15C2idFrDzoHwRLp5h8
         4MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cDYU5QBZ3HSMpQm53VxMwLKdwiTSZf4S7HSLSzlvwSE=;
        b=DNY0Ugy95aoDzVbsmZZG2qE9emO/M8I3algGcgc6jJ6I4UDd5IwT376ln+ESf1Xrl4
         nASstDULtWgYBrXDWUtW3ZTCcsZ0vGXyc2AQ2f941zuRuQGdjaugSv/nBHoROM0GkzpW
         k+qgQgW/dsijqCz+P/QDdWauFdsPE8fUiE1N0b8HGgkWx6opdPIX/MYYT626QwhT6edI
         FDaAo+ta4OuJPxlfy7bhPwmcPXHhjJLrvf2HLdMLtDlETu1ijHW3LcW1nvOaj4RU3yp3
         Rdfl2AaJlTtY76C3WbfwbqffAzk8uSARwafF83qY0WuBFA3hOB+gqWFBPmKRTBBGJRYo
         LwJg==
X-Gm-Message-State: AOAM533KHLM3D3lJ2/rbJ1PxiFoANhHhjkpLWahKZCf2stQrgMhKC6cS
        sXBwMT2Se9ae34CYLOACSwo7WA==
X-Google-Smtp-Source: ABdhPJxgUtllQtB4NLEwrbAKXV5XjdsmV0bxEenf7DJaxf3JfS4k3a3BfqVne/jfkLx/IRiBtLMR7Q==
X-Received: by 2002:a1c:2501:: with SMTP id l1mr3188975wml.41.1612364875140;
        Wed, 03 Feb 2021 07:07:55 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id r1sm3947240wrl.95.2021.02.03.07.07.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:07:54 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v4 2/2] net: qualcomm: rmnet: Fix rx_handler for non-linear skbs
Date:   Wed,  3 Feb 2021 16:15:35 +0100
Message-Id: <1612365335-14117-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org>
References: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org>
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

