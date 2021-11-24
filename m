Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3380C45CDF5
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhKXU2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhKXU23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:29 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B79C061759
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:19 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id c3so4816145iob.6
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/tQ+LMRwDn/cQ7ovJGI35qWLjlsnDni7U8vJdBfy88=;
        b=nAczvN/1W7rpfOKy1l7TqE0s8oAMerPBgjpD0DreyUtGsmm5gw9R+j7zlGXTpgTNsV
         xbFiHjeALVKcceFPWkYR+LHpnZdi7rPvk4kZMIP5L1op8aN8oKzGimilaLFLENV1hCzG
         v2lLiNkdQPWl81CeDQxDSBP84qzctBrM996fpjXbeEW23Lq3Ye9NC09EFWpzfepn+lH6
         3tIeYpDPEHN2lcZXAm8/UvdOeoj8Z8309u9HVdn/4bB7In98DbflMeLKUd8TxijuJysq
         tUexoYNpYnoABHvTw/fLOSLJ0ihXrqx+EsKXouMoahHVV+EeS7lssxFTS420YEZNiN80
         ZPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/tQ+LMRwDn/cQ7ovJGI35qWLjlsnDni7U8vJdBfy88=;
        b=EvM0kXu/on8PxKJJ05DJzOWfP+5OWWFP3cRK8j0IeO7U9KUFYZvRduEnRq+it4IG1x
         1Dd3QBwGbEGKCnT+M0JEHBez+GPJDsV2tz+1qH43RYUTtnBH5/zZIOVt6wcudSsmtoog
         fp7s6TLp2YtwaN0bwW5LvX9qA0/DdjIDR8HCYnzBT+j6YFzIPARmwqVUVwYpayRiylCm
         nDU0UDTGMBC4awjwkPeuEwnPG9oPYc5obO6jmE2kEZwNn5H9OBp2Q9rx7LnsHBNJrXlz
         rNMZwV0g6sEezkESJ6d1j6AD9mdthooXuLpjSMUhouAezg2KizTGTmD1xg1gevji1w8Q
         WT5w==
X-Gm-Message-State: AOAM531IdJ6KutXoObG58w+izXK9bKa6XD/iqGO2mGXnb55VjWK6tTH8
        evSroWlCXZb5GiEi1koVOmAAiA==
X-Google-Smtp-Source: ABdhPJx//eLtgSULZ55971nSYne2KQfJMglNKCLSSRugpVVdQNgaVqflp4uzE+AcnM8iyS2FSO/Fqg==
X-Received: by 2002:a02:cc91:: with SMTP id s17mr20562588jap.3.1637785519287;
        Wed, 24 Nov 2021 12:25:19 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x2sm312795ile.29.2021.11.24.12.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:25:18 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: rework how HOL_BLOCK handling is specified
Date:   Wed, 24 Nov 2021 14:25:07 -0600
Message-Id: <20211124202511.862588-4-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124202511.862588-1-elder@linaro.org>
References: <20211124202511.862588-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The head-of-line block (HOLB) drop timer is only meaningful when
dropping packets due to blocking is enabled.  Given that, redefine
the interface so the timer is specified when enabling HOLB drop, and
use a different function when disabling.

To enable and disable HOLB drop, these functions will now be used:
  ipa_endpoint_init_hol_block_enable(endpoint, milliseconds)
  ipa_endpoint_init_hol_block_disable(endpoint)

The existing ipa_endpoint_init_hol_block_enable() becomes a helper
function, renamed ipa_endpoint_init_hol_block_en(), and used with
ipa_endpoint_init_hol_block_timer() to enable HOLB block on an
endpoint.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ef790fd0ab56a..405410a6222ce 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -860,7 +860,7 @@ static void ipa_endpoint_init_hol_block_timer(struct ipa_endpoint *endpoint,
 }
 
 static void
-ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
+ipa_endpoint_init_hol_block_en(struct ipa_endpoint *endpoint, bool enable)
 {
 	u32 endpoint_id = endpoint->endpoint_id;
 	u32 offset;
@@ -874,6 +874,19 @@ ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint, bool enable)
 		iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
 
+/* Assumes HOL_BLOCK is in disabled state */
+static void ipa_endpoint_init_hol_block_enable(struct ipa_endpoint *endpoint,
+					       u32 microseconds)
+{
+	ipa_endpoint_init_hol_block_timer(endpoint, microseconds);
+	ipa_endpoint_init_hol_block_en(endpoint, true);
+}
+
+static void ipa_endpoint_init_hol_block_disable(struct ipa_endpoint *endpoint)
+{
+	ipa_endpoint_init_hol_block_en(endpoint, false);
+}
+
 void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 {
 	u32 i;
@@ -884,9 +897,8 @@ void ipa_endpoint_modem_hol_block_clear_all(struct ipa *ipa)
 		if (endpoint->toward_ipa || endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
-		ipa_endpoint_init_hol_block_enable(endpoint, false);
-		ipa_endpoint_init_hol_block_timer(endpoint, 0);
-		ipa_endpoint_init_hol_block_enable(endpoint, true);
+		ipa_endpoint_init_hol_block_disable(endpoint);
+		ipa_endpoint_init_hol_block_enable(endpoint, 0);
 	}
 }
 
-- 
2.32.0

