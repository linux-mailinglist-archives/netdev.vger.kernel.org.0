Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3F25F0A3
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 23:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIFV0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 17:26:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726339AbgIFV0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 17:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599427593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=+C6m0PVka75w2yKn4NnD8dgwNKYONinv/V5y0NmFCqI=;
        b=iiw9ZTGa52+9rXHhg+r2KMcrv8QHDDzw2jHlqSiuaeUpP7ZC2OyYQsY9KhA7KpZdB+bcwC
        13ICtU2VoKW/Dz9RWqul5GVrM4SVve7DUed8xxM0M00YrMWfh+OflER96nhKFIkotO2NVE
        kULf/wHnokEhM93/CtKIp0sy0MnpGsY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-XTgwe9_uN6u6WxpHpOIASA-1; Sun, 06 Sep 2020 17:26:31 -0400
X-MC-Unique: XTgwe9_uN6u6WxpHpOIASA-1
Received: by mail-qk1-f200.google.com with SMTP id m203so6655228qke.16
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 14:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+C6m0PVka75w2yKn4NnD8dgwNKYONinv/V5y0NmFCqI=;
        b=SgL7GjG4Nfd/5BZtDcUWiKuvlikmTk2YOKf75eLD8Qa4b3C1qWUn7qZayhC208maOD
         LOwGw60X6YvIowoZsUS7yFnszVEN156r/NofxD2WOY707P/yFcCxLeYoStBa/c8iDBLk
         vsqy7HVqkWN0nn8fQI8m3Y8/oVJLzUkwqQ8Wj29EIGPe3mOEu2x/4+/qX4kZLV/ByYxJ
         ExujJsGYBaLQR08apAMNZsMWjhe9JcKE2yVgqprKjZQYs8R+rw7NOYVYvUecSOD7xRha
         BYs3xYLr+XCAE+na3GdiACaluIbCjbijWbp3pVoglLRlluCi3icQx1ekNg/TGQDVxYqZ
         lxFA==
X-Gm-Message-State: AOAM532O8pTzgXdDD6y7Kyh2V60pKDFbauoM4pLqAszw0MwM+Dpya83p
        YvsGR7d5mmsqVF5g69+AntN9XcABnawt9vS2wcHosV/ORzuCmcyWe53TDCQe8783G4W/9rfmzdz
        JBYEbtaJAY/xwDoZA
X-Received: by 2002:a05:620a:2006:: with SMTP id c6mr2372104qka.240.1599427591260;
        Sun, 06 Sep 2020 14:26:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR82s18wWVkyR16S1pfORo4d0KJZMFU6czX4ESIPjhfBt+0VVaE3uGrfuNh/vEQlB+KG5uFQ==
X-Received: by 2002:a05:620a:2006:: with SMTP id c6mr2372091qka.240.1599427590987;
        Sun, 06 Sep 2020 14:26:30 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id k6sm9888276qti.23.2020.09.06.14.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 14:26:30 -0700 (PDT)
From:   trix@redhat.com
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        mkenna@codeaurora.org, vnaralas@codeaurora.org,
        rmanohar@codeaurora.org, john@phrozen.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com, Tom Rix <trix@redhat.com>
Subject: [PATCH] ath11k: fix a double free and a memory leak
Date:   Sun,  6 Sep 2020 14:26:25 -0700
Message-Id: <20200906212625.17059-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analyzer reports this problem

mac.c:6204:2: warning: Attempt to free released memory
        kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The channels pointer is allocated in ath11k_mac_setup_channels_rates()
When it fails midway, it cleans up the memory it has already allocated.
So the error handling needs to skip freeing the memory.

There is a second problem.
ath11k_mac_setup_channels_rates(), allocates 3 channels. err_free
misses releasing ar->mac.sbands[NL80211_BAND_6GHZ].channels

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index f4a085baff38..f1a964b01a83 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -6089,7 +6089,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ret = ath11k_mac_setup_channels_rates(ar,
 					      cap->supported_bands);
 	if (ret)
-		goto err_free;
+		goto err;
 
 	ath11k_mac_setup_ht_vht_cap(ar, cap, &ht_cap);
 	ath11k_mac_setup_he_cap(ar, cap);
@@ -6203,7 +6203,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 err_free:
 	kfree(ar->mac.sbands[NL80211_BAND_2GHZ].channels);
 	kfree(ar->mac.sbands[NL80211_BAND_5GHZ].channels);
-
+	kfree(ar->mac.sbands[NL80211_BAND_6GHZ].channels);
+err:
 	SET_IEEE80211_DEV(ar->hw, NULL);
 	return ret;
 }
-- 
2.18.1

