Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4DF3F8B23
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbhHZPgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 11:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbhHZPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 11:36:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5404BC061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:35:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x12so5708761wrr.11
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 08:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=TaK24+8gH53dYWBrBRg64lij3FSBe4N9yadD4P1UUuU=;
        b=nqxp7aNA2YFI86iFQqlTb8aAJarFLYJyjLq9tjqOgYQjle/y/kqUGpanPFyaG2V/ha
         rGWgMsvszI7GNJDYdYDaAv3VryGdwcWmErLTdZ778olOb9rlm54q2lu7mVJLq4ehXDrD
         DmlvDd5/ZA2t1xHZKHdjjMcnVGdy/DxI1L+PkpEzohBaUNFEXL60WhnFPulJ8bdcL2LI
         2hIry2CRH8VaOscmYwYnBV61UPPHkmKa8DZ+mjIt/9hQ3ODMmH/nBEbHmCLF/AQM5lfK
         +qNWCAdRiRCmcGDQj9LXYyJ9kIutkZE/becoZEc834dylfEO8pzrM1TKvqwg9dTC4Oqd
         MHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TaK24+8gH53dYWBrBRg64lij3FSBe4N9yadD4P1UUuU=;
        b=JoDB+BdZyAqf251Ye3riIXdSyKQqqpYdS2YNW8773EWnozhQvd8A9VAVXKpze9ilT7
         tOodKGV0YYM/uLEXnMqyaJh2EU7Kadz0bQPi+w8RAl8qUIYwmUQmb8aRr9e1ZRKpFkcH
         KkhlmTNBaANiAikFLR0u5ts6MUUULdW7q4DVrsdlLE/iO+fjCtnt3fr80wFC5hQsmZfa
         fMjitsBrHBCWW2rW42S/b7I5ZBzO+DhAjvlP3YyKAByqJDXHET8nlXLuXSACUVCIJ23F
         UjI676CIN4Zd6CZyhnWK9NH+Wxih4L234UbAW6f4R6ulAnFx5BNaYuDtMl8plYSx0mkq
         lP7g==
X-Gm-Message-State: AOAM533eyCblXuCWITGeCugedCEXJSsYkh9WqHACgBTaXH8mLhwwfwO3
        ++ckAh81vZxWhDBu+RpGXncYTg==
X-Google-Smtp-Source: ABdhPJwWtlpoyiq3Tf1o4x6ydu6b9X8evjT9i7XPAHO9VE5CQrgelXfYq0cINvAnpCy8MxPMTk5TVA==
X-Received: by 2002:a5d:4dc3:: with SMTP id f3mr4917851wru.302.1629992116860;
        Thu, 26 Aug 2021 08:35:16 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:edf4:979b:2385:1df8])
        by smtp.gmail.com with ESMTPSA id a12sm7598553wmm.42.2021.08.26.08.35.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Aug 2021 08:35:16 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Fix missing frame timestamp for beacon/probe-resp
Date:   Thu, 26 Aug 2021 17:46:08 +0200
Message-Id: <1629992768-23785-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving a beacon or probe response, we should update the
boottime_ns field which is the timestamp the frame was received at.
(cf mac80211.h)

This fixes a scanning issue with Android since it relies on this
timestamp to determine when the AP has been seen for the last time
(via the nl80211 BSS_LAST_SEEN_BOOTTIME parameter).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 1b83115..cab196b 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -287,6 +287,10 @@ int wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb)
 		status.rate_idx = 0;
 	}
 
+	if (ieee80211_is_beacon(hdr->frame_control) ||
+	    ieee80211_is_probe_resp(hdr->frame_control))
+		status.boottime_ns = ktime_get_boottime_ns();
+
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
-- 
2.7.4

