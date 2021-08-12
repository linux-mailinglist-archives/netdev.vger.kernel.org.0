Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF19D3EAB58
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbhHLTvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236312AbhHLTvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:51:12 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491E1C0612E7
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:44 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id q16so7667086ioj.0
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pVDXj/c2GhrmP3JpxAGc+59S/Eh6qUoCDMrEnYN38ig=;
        b=Qu6hMONKHaomHVzVDk6h4d9M7HVT/cFdSqp48XMihTQ1wme3tBEzYfaYsLulMcH6L6
         EpNwWR5pwiQUTEC8RpgY2saOsqfd9athwfhrY6wJzsU3r/DWoMJX7KfjBq03QwPG7wGl
         u8yTVqWyj7p0WUvIdIJSQSMQhp/t5QJ/II0KGcTW386p7MNryUBVeXj75FQSxkPF0ViQ
         p2icnL69wR1soSjAmsdXZcEWsJzRdDCVDTT1N3gcgfRe8FlVGwNPX3MEsXI7YSL68hJO
         3c7n6f8b8bTkK8fSDErufEVZTIYpk1yAwIrjKlLPJc2ILQmYyFGhBnxSy/Q7P/fa6oPe
         dFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pVDXj/c2GhrmP3JpxAGc+59S/Eh6qUoCDMrEnYN38ig=;
        b=oonbllrq2yL/PFqG9u67lKWiRHNknRUZJwms+C+m+X16PVF6/D+6b4k9N0NPy94KK0
         +lVM/t2nLb5DijQco/pPvw4Ho1CKbG4/H/LNrRlLfewZySIYknDg4pni7TvSVPZID31n
         rJ6Hq16Ce16dffbxVamGg3654qcgtWgwzGjvn70OaI5ytVPEt6GSVyXJJcUdXIS+1D7e
         re8A6tyUc0Jy3/lw1sWA/wLQtyuPoIetPwcLxrVYnkezy0eC64m4S8PYeX5dINPnyT3g
         AwqcTrdNpTURjU0LjOttiF66b6gsiMZxda0rT/LNZ202wT9VkC1z8QZT/gJLYLftvpuC
         +ClQ==
X-Gm-Message-State: AOAM532HuC09046qJufM3FQ9jKUHUNqto5I8MIQKPPkB7WLSLIWnkDT1
        LbjrfcRY9aPO11gqb9KPlV/8Gw==
X-Google-Smtp-Source: ABdhPJxGLQX1l8eQk4HU3flD0jYpAd5arWtHOC2qNRKLZwPne/9jjlVO0Yrb60cf4P6Kq48sUmzSSA==
X-Received: by 2002:a5e:8f43:: with SMTP id x3mr4318023iop.206.1628797843642;
        Thu, 12 Aug 2021 12:50:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm2058821iln.5.2021.08.12.12.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 12:50:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: don't hold clock reference while netdev open
Date:   Thu, 12 Aug 2021 14:50:35 -0500
Message-Id: <20210812195035.2816276-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210812195035.2816276-1-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a clock reference is taken whenever the ->ndo_open
callback for the modem netdev is called.  That reference is dropped
when the device is closed, in ipa_stop().

We no longer need this, because ipa_start_xmit() now handles the
situation where the hardware power state is not active.

Drop the clock reference in ipa_open() when we're done, and take a
new reference in ipa_stop() before we begin closing the interface.

Finally (and unrelated, but trivial), change the return type of
ipa_start_xmit() to be netdev_tx_t instead of int.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index b176910d72868..c8724af935b85 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -65,6 +65,8 @@ static int ipa_open(struct net_device *netdev)
 
 	netif_start_queue(netdev);
 
+	(void)ipa_clock_put(ipa);
+
 	return 0;
 
 err_disable_tx:
@@ -80,12 +82,17 @@ static int ipa_stop(struct net_device *netdev)
 {
 	struct ipa_priv *priv = netdev_priv(netdev);
 	struct ipa *ipa = priv->ipa;
+	int ret;
+
+	ret = ipa_clock_get(ipa);
+	if (WARN_ON(ret < 0))
+		goto out_clock_put;
 
 	netif_stop_queue(netdev);
 
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
-
+out_clock_put:
 	(void)ipa_clock_put(ipa);
 
 	return 0;
@@ -99,7 +106,8 @@ static int ipa_stop(struct net_device *netdev)
  * NETDEV_TX_OK: Success
  * NETDEV_TX_BUSY: Error while transmitting the skb. Try again later
  */
-static int ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t
+ipa_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
 	struct net_device_stats *stats = &netdev->stats;
 	struct ipa_priv *priv = netdev_priv(netdev);
-- 
2.27.0

