Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F88C282A14
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 12:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgJDKCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 06:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgJDKCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 06:02:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5B6C0613CE;
        Sun,  4 Oct 2020 03:02:48 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id p15so1166648wmi.4;
        Sun, 04 Oct 2020 03:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T3FPFmmNhtSQG0HIl2KOR79xkD0BpnP+y0jXes7tggU=;
        b=UAC3akdkJpzR4/1Q5jBpbut2UdVNVKoenKR5psolzqCesNaBfvWT++3eZ8IF45FDRv
         InDpKoSO0ocWiIcEbayM+mlLEJ0Wnqqo3GtZu3LA8/mztZLLhRvR4N9zRASJzG+F7zNq
         ZUJzDjj5I+9US3CfLnozqktSmE66J8/42940EMvA4v9uckcnXHeaFBM4wewBIqPv2pKO
         3gHwj/XZ4W1lsuN9BIqOGstL0YJdiO1bt8HV6tRF9medK0ybZDAJIcVezskP7NCPU5jv
         36FkOWDW3KG3ByVLtuj28SdlHixFVJQFUfIksqpM2HckyACTNbiDON4lI5fz/7DtywI8
         Y50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T3FPFmmNhtSQG0HIl2KOR79xkD0BpnP+y0jXes7tggU=;
        b=nQZElLhhsicAgjSHRKNv7KVEcy0oBTAeSbgAUAb9yR57lTUHlHgP09uaOuveCztUHK
         gaV7mUiCAbQh0Qo4ML9bkHBxMgJKiZoLgUJFRCXIq/Yg8VE6nI56ffoM/4d3xTtpXGQu
         6rgvxrZVBWlsbLGvxsp4gaqAHhtmlKrqrTv6BGK8Det6ujCE8p+qPSNLIU1O2GXIcOz7
         F0lLeNFyTU9wZ8L4ybgvNI44S3SqFZbP73bIpKnAO75ZQ/loK6n0Hvjp8VJ8Mjp6xWpJ
         vRSkY210gtAh2JZpvB+DTgeK7wlcyaScBNz7rIuuzJh/Eo5kkT6I1VdhXnyEFCa3fWbr
         Pxjw==
X-Gm-Message-State: AOAM531vqSl7IQw2lZGF/r9TAMfCHHAz96WsGwiB4c65IlOPxMcR5DBd
        8zcbyKDZbUizHvqyzy3ivbs=
X-Google-Smtp-Source: ABdhPJwNB9Xm3iMGrJpowcN+yOueZNbV1GHeQkGkszFbt1cxFPr/MpmMaCkQ04e1c/FYSg4mlVD5Dw==
X-Received: by 2002:a1c:2186:: with SMTP id h128mr1130889wmh.113.1601805767558;
        Sun, 04 Oct 2020 03:02:47 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id a10sm8301340wmb.23.2020.10.04.03.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 03:02:46 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ath11k: Fix memory leak on error path
Date:   Sun,  4 Oct 2020 11:02:18 +0100
Message-Id: <20201004100218.311653-2-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201004100218.311653-1-alex.dewar90@gmail.com>
References: <20201004100218.311653-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath11k_mac_setup_iface_combinations(), if memory cannot be assigned
for the variable limits, then the memory assigned to combinations will
be leaked. Fix this.

Addresses-Coverity-ID: 1497534 ("Resource leaks")
Fixes: 2626c269702e ("ath11k: add interface_modes to hw_params")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 3f63a7bd6b59..7f8dd47d2333 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6041,8 +6041,10 @@ static int ath11k_mac_setup_iface_combinations(struct ath11k *ar)
 	n_limits = 2;
 
 	limits = kcalloc(n_limits, sizeof(*limits), GFP_KERNEL);
-	if (!limits)
+	if (!limits) {
+		kfree(combinations);
 		return -ENOMEM;
+	}
 
 	limits[0].max = 1;
 	limits[0].types |= BIT(NL80211_IFTYPE_STATION);
-- 
2.28.0

