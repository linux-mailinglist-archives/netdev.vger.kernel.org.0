Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E740633F016
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCQMRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbhCQMRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 08:17:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60E2C06174A;
        Wed, 17 Mar 2021 05:17:21 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id bf3so1965225edb.6;
        Wed, 17 Mar 2021 05:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h6GmCRrmIsHqritiC+rTLz7nmST/9XaYUWXiJKUsWSU=;
        b=h5LUntTxBiNzJW0VCV7rxhmBdVT+JwHHpXnF6xaDp/Oox8z8lyPC4ZhgPVSpZiJ/2O
         1XH08YcqNrcCiKkCJiWglg0kZ5KsMoa8qVV613XAF4lCXwO4EseBt/NUyt93gE3QU9ms
         e7RWElqS4TsfwIbqqJURdSoq/DJrHfLO3t2th8YnVQuQFY1Wmj6gEN7g5FEMEEfLQ3s/
         JzwR+shK5cI7MCX8JywQoxRrzAfVqSk22pbRos+2FYeqTRLKoQtuJ1x4c1/CQD9SUT4I
         G+Efb1mP8ifeAKCvAFnX6/dZ+S++1I6EeoD/sUNogj4IEF1ZUAi5+gKqFMZe/hVrYEHB
         nGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h6GmCRrmIsHqritiC+rTLz7nmST/9XaYUWXiJKUsWSU=;
        b=l6V5sp8ddTcfVBFAw0pKnpDRuKeEpxddTBvOCigjh9vZVlM7gS0d1W+fIeMb9ybRTV
         qY+G6CCvzcVfweey2gyak8fq5x9SKBJRwDHDaVQ3kg21eXRy0c/JEAYdOSpBT9hmeRqN
         8bw9o7jMQNSMKkn/gIo8vYj3e7Pg4OzB6HK77++Fdlj4uptvK0m2NYHC/ub41q7vI0PH
         swu++aBr+xcMmXXDGayTcqlGR2omufvrpay/wPOmsfH4AxOJRafzw9+kpCzfjypxMCRp
         Ie/nENZ5eG4ICWfD5hSR2uQrJ5+570eQg63Icv11boV01cBukEx6CM5F/86HkMUoPt8H
         VrQg==
X-Gm-Message-State: AOAM532nU8fniFi+39GOSsUxKtJ9ChEXp+k5BKzNoyWrjmSNJpBp/QGP
        +79CwJZsozywF8XuKIp057o=
X-Google-Smtp-Source: ABdhPJzTNTDP3aycyKraS8cl5t3Pdg0t2RlrDlqGHh4KOPfb1l356CvPOBrzLRHecwPIJEODo7VcnA==
X-Received: by 2002:aa7:d792:: with SMTP id s18mr41074517edq.176.1615983440301;
        Wed, 17 Mar 2021 05:17:20 -0700 (PDT)
Received: from ubuntudesktop.lan (205.158.32.217.dyn.plus.net. [217.32.158.205])
        by smtp.gmail.com with ESMTPSA id d19sm12448223edr.45.2021.03.17.05.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 05:17:19 -0700 (PDT)
From:   Lee Gibson <leegib@gmail.com>
To:     imitsyanko@quantenna.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Gibson <leegib@gmail.com>
Subject: [PATCH] qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth
Date:   Wed, 17 Mar 2021 12:17:06 +0000
Message-Id: <20210317121706.389058-1-leegib@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function qtnf_event_handle_external_auth calls memcpy without
checking the length.
A user could control that length and trigger a buffer overflow.
Fix by checking the length is within the maximum allowed size.

Signed-off-by: Lee Gibson <leegib@gmail.com>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index c775c177933b..ce920685055a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -570,8 +570,10 @@ qtnf_event_handle_external_auth(struct qtnf_vif *vif,
 		return 0;
 
 	if (ev->ssid_len) {
-		memcpy(auth.ssid.ssid, ev->ssid, ev->ssid_len);
-		auth.ssid.ssid_len = ev->ssid_len;
+		int len = min_t(int, ev->ssid_len, IEEE80211_MAX_SSID_LEN);
+
+		memcpy(auth.ssid.ssid, ev->ssid, len);
+		auth.ssid.ssid_len = len;
 	}
 
 	auth.key_mgmt_suite = le32_to_cpu(ev->akm_suite);
-- 
2.25.1

