Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2442D9BCC
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440094AbgLNQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439087AbgLNQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 11:05:55 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75857C0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:05:15 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id a12so16947267wrv.8
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 08:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=B1qgvoqyjJnaz03RGohqC8FsinqgcUNvzLxQt8gagPc=;
        b=qe9JnFmaPnkbj/V1y4Mi1SXYc5X/oCu1sXDXb/q2erUt6rhlHqQWdsMwwvQvZpdZLs
         dVB648QxGNAGEcfJLMwe/eT9IRRp7XMLYM4nFBZNbIx+h0ZKF5boUhnFDkqsOgrW4wNu
         +p4vBgyFJr+JTj2/PIxT+/JSAFkFtizbAHwtSXJol3N3+42eqvb2MYOAljM5qNc8GiES
         UVV+MXLrlI0xeqDZK+VvrxB2feNayUQuwK8jqEQCLu1E5B0V2JIEWZBPXNeEHhPk+Peb
         2pQu3hQ6QVQjtO90GnW6myQZs1ZnMosazeI1dAQYUApk3Tb6+6RNpOX8wJZBr0MtSgnt
         qjpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B1qgvoqyjJnaz03RGohqC8FsinqgcUNvzLxQt8gagPc=;
        b=dnZbWk2nIqRE5PtcAcoHKL2eDNZvgjv3hLbwX+ELL5ZIZIBn5pa6K9ErvpIrpINtSf
         cli+3hTqPUaWEspyRiOvA2KRjCrODryLBDkXRXVkjZXZyo7Wc55+naoOQrpoF0EFtfYD
         yENXBpXuvF9nCueXdfvCOix5pBBgElcaO924mEXt15KJuCoLnkKPmPntnIugwKFgz7C+
         vqV6l75eOT3bRmYbu3q6t+Ecu+3JSB0V3yt3RyEM+/CSUoYaYlLocnqW8H3Ug/8dUJ0A
         PEYelxZw2VygYoqz1jyiiYqwFS7ECdZ8xtFaMc2Qc6Z6ntWP9+vN1mQVP+LGwH28uY8y
         BCVg==
X-Gm-Message-State: AOAM531sML/GFwOyvf/g/TY54/im5C7CxaJJJQxtWikTNJwewQY3izO+
        ZQn4wATTSFPR2qwD1oAboDDu6dOAw1oksA==
X-Google-Smtp-Source: ABdhPJxFxrRLXQEEL81AMbYmWZWnRjYN+OxYhLLlgj9q9fzZuapU8SmFpY/B+Vm69t63gHCX5cOgnw==
X-Received: by 2002:adf:f5c5:: with SMTP id k5mr30647696wrp.286.1607961914180;
        Mon, 14 Dec 2020 08:05:14 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:f2e4:25b3:2b53:52cd])
        by smtp.gmail.com with ESMTPSA id x18sm28587026wrg.55.2020.12.14.08.05.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 08:05:13 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] net: mhi: Add raw IP mode support
Date:   Mon, 14 Dec 2020 17:12:24 +0100
Message-Id: <1607962344-26325-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI net is protocol agnostic, the payload protocol depends on the modem
configuration, which can be either RMNET (IP muxing and aggregation) or
raw IP. This patch adds support for incomming IPv4/IPv6 packets, that
was previously unconditionnaly reported as RMNET packets.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 5af6247..a1fb2b8 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -260,7 +260,18 @@ static void mhi_net_dl_callback(struct mhi_device *mhi_dev,
 		u64_stats_add(&mhi_netdev->stats.rx_bytes, skb->len);
 		u64_stats_update_end(&mhi_netdev->stats.rx_syncp);
 
-		skb->protocol = htons(ETH_P_MAP);
+		switch (skb->data[0] & 0xf0) {
+		case 0x40:
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case 0x60:
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			skb->protocol = htons(ETH_P_MAP);
+			break;
+		}
+
 		netif_rx(skb);
 	}
 
-- 
2.7.4

