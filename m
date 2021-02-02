Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FCC30C50F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236095AbhBBQLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbhBBQJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:09:11 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEA5C0613ED
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 08:08:30 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j11so2165028wmi.3
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 08:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YN/6Ava32WxBGn762wuDrCY8IUGtDZjss5W6LAtfN1M=;
        b=AYKk/ileFI7PNo79nhx+39cSceU5+W5ywf7Epw7g8EZpj3KqBUjlEYY82Wx8Is5PwM
         EtjlYHdUtJ3XF8nczNueEiJYqTTslRz4Ne6ohIltWXOckTG9SLH0BFIy7e72tn1OOue0
         D83AkIjy4jFHeC4AjO6/PO+0RCfxfcZIPNxA+IQxCX4HkwVzx1q1cNHGQUzjzQ3l/fWs
         bYS/lEATHKhcFYflrqcrcn6zRCWzgJVmWAsoobYGpQx9Mm01vCQkX13vOK7y+7boQ4g2
         48XcjgUkWwZ8jgq3uHY4leab5ezBis2nLB375CULj4FSFu/R7azJJjiQRfK/AJK1LfK2
         1mxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YN/6Ava32WxBGn762wuDrCY8IUGtDZjss5W6LAtfN1M=;
        b=sn4zrm/KwqbqTxPXs3DFXhEkdMqOqbZQ2pPK4VW9sV2kdBuNVwdZaArc3Whbpy38zi
         uOFQavTKecKxDzJSU5lvgCNqK6gmPbQvdAq3q9jaUxAHEzTq9ZXjQ5lxkdxkSoWCg0DG
         O3Y/rg/Q8XIf8tjS/OADkQHpuCo4DX+O+NKJAzzaGxVB/zbmEHnx0nbPber+3zuRr4WZ
         W1VBiWLcuN/PrI8ViaU8vu6JLB8hPaepaFT+q9PZQ+7jbhR7zSRoEnM2IfnXWPmPyL8m
         2vxMwJyLd2fALQwJIRqkTtPAZnKyurDoBcpYIeeyGjk/KNsbZuG6/YFtCccEdDCqa1e2
         ABxQ==
X-Gm-Message-State: AOAM530K+t/9CIidPpsFPBtvjgs1ZBCfDfKvikAm1ZT+pa+PwMYcasQN
        cKACz/LII8n6Cl1ofwnn1+LYJw==
X-Google-Smtp-Source: ABdhPJxewPANscoDJmWQX5rXHoQpKhW07081m9FmqMhcvpVzb+GexFOwgL5n2uUiitmQ5rVqgcLJWg==
X-Received: by 2002:a1c:2e04:: with SMTP id u4mr4391698wmu.79.1612282109043;
        Tue, 02 Feb 2021 08:08:29 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id y6sm3900491wma.19.2021.02.02.08.08.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Feb 2021 08:08:28 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH net-next v2 2/2] net: qualcomm: rmnet: Fix rx_handler for non-linear skbs
Date:   Tue,  2 Feb 2021 17:16:08 +0100
Message-Id: <1612282568-14094-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no guarantee that rmnet rx_handler is only fed with linear
skbs, but current rmnet implementation does not check that, leading
to crash in case of non linear skbs processed as linear ones.

Fix that by ensuring skb linearization before processing.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: Add this patch to the series to prevent crash

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

