Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2317527A135
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgI0NZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 09:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgI0NZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 09:25:01 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF11EC0613CE;
        Sun, 27 Sep 2020 06:25:00 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so3707123wmi.1;
        Sun, 27 Sep 2020 06:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gjZCE0XqY7rbUZL+6nXYXyS7+2kMhKjGYovALar1slE=;
        b=Ig54dndO0DD4tn0Lc7STi8pT6mmiysfMihT+7qOMFljK2vUdXlmpGi72VYmTsqtmL2
         s9jv0wc5NGDBKXANlbI8j1ML63p8WC4mv77pUpwBbk2ZHzZpCFQWJVq5JuGrN3m8zo58
         iibsgBde/1M4GQMnznr53G3OSBQYYWOACEzZvdxSxLSJS5cwQwV/V4HaX8w6lxEZLWaD
         aibZzj9qZ1F8D6a+E41BIsSYlysIiLbyb0wYCr3Cd6ERJDmNj/PtwjrL7DJ8RuNNiRnX
         1fU9Xp9DuHP46Wz0Aby6DqkNk490dp7gpUCVn4zefnFQV6aanuHNc4o5rrKC1tXM2JY7
         WiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gjZCE0XqY7rbUZL+6nXYXyS7+2kMhKjGYovALar1slE=;
        b=CbH1rV+iRruXQ4J/236HrzX4QxhlvvELOYEqAm5XAjwbTRH+tpQkN5VGzBkoXI978H
         xlSkaJqyGz+CCL9CXmeq2RxwTWCdlfsQXgVTmL8GNEjPa1T6j1O8ZVD+Yyc9p855o+nf
         6Rk0bQTC648pk9T9JL+w3eYxFU6vnuQ5+0L33BZ0TGx74a5+VvUJeftgbaiR+szc+nYa
         zWosiJoBrh/wCAbpj0bmtLpOpZoon+w6apf9YpQOyKIIs/HdQPN0hz1G51ER2IOtIyYs
         yLPewdcKzBUQfzwKNs5mOqbtpDw2aEZUxFaPkiaaIFlWVHWavfdHc9EEo7VdAJAhwMVk
         4MyQ==
X-Gm-Message-State: AOAM531MJ8y5bidERpQWjfb990xQ4zjNpAZb1E9awa2dOSsbaX5MXtfF
        shAEs0hsgFALNaxs/R6awsg=
X-Google-Smtp-Source: ABdhPJzRVJomtYWglBoQhLN8GY+q62azTqZF5LiQHuP3GmOPSGPsVlzVnzNpFmcKz5MXpGvy0AdWxg==
X-Received: by 2002:a1c:32c6:: with SMTP id y189mr7257004wmy.51.1601213099373;
        Sun, 27 Sep 2020 06:24:59 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id l4sm9833967wrc.14.2020.09.27.06.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 06:24:58 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath11k: Correctly check errors for calls to debugfs_create_dir()
Date:   Sun, 27 Sep 2020 14:24:50 +0100
Message-Id: <20200927132451.585473-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

debugfs_create_dir() returns an ERR_PTR in case of error, but never a
null pointer. There are a number of places where error-checking code can
accordingly be simplified.

Addresses-Coverity: CID 1497150: Memory - illegal accesses (USE_AFTER_FREE)
Addresses-Coverity: CID 1497158: Memory - illegal accesses (USE_AFTER_FREE)
Addresses-Coverity: CID 1497160: Memory - illegal accesses (USE_AFTER_FREE)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 25 +++++------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 5193b308a992..826dc8ba188f 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -837,12 +837,8 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 		return 0;
 
 	ab->debugfs_soc = debugfs_create_dir(ab->hw_params.name, ab->debugfs_ath11k);
-
-	if (IS_ERR_OR_NULL(ab->debugfs_soc)) {
-		if (IS_ERR(ab->debugfs_soc))
-			return PTR_ERR(ab->debugfs_soc);
-		return -ENOMEM;
-	}
+	if (IS_ERR(ab->debugfs_soc))
+		return PTR_ERR(ab->debugfs_soc);
 
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
@@ -863,13 +859,7 @@ int ath11k_debugfs_soc_create(struct ath11k_base *ab)
 {
 	ab->debugfs_ath11k = debugfs_create_dir("ath11k", NULL);
 
-	if (IS_ERR_OR_NULL(ab->debugfs_ath11k)) {
-		if (IS_ERR(ab->debugfs_ath11k))
-			return PTR_ERR(ab->debugfs_ath11k);
-		return -ENOMEM;
-	}
-
-	return 0;
+	return PTR_ERR_OR_ZERO(ab->debugfs_ath11k);
 }
 
 void ath11k_debugfs_soc_destroy(struct ath11k_base *ab)
@@ -1069,13 +1059,8 @@ int ath11k_debugfs_register(struct ath11k *ar)
 	snprintf(pdev_name, sizeof(pdev_name), "%s%d", "mac", ar->pdev_idx);
 
 	ar->debug.debugfs_pdev = debugfs_create_dir(pdev_name, ab->debugfs_soc);
-
-	if (IS_ERR_OR_NULL(ar->debug.debugfs_pdev)) {
-		if (IS_ERR(ar->debug.debugfs_pdev))
-			return PTR_ERR(ar->debug.debugfs_pdev);
-
-		return -ENOMEM;
-	}
+	if (IS_ERR(ar->debug.debugfs_pdev))
+		return PTR_ERR(ar->debug.debugfs_pdev);
 
 	/* Create a symlink under ieee80211/phy* */
 	snprintf(buf, 100, "../../ath11k/%pd2", ar->debug.debugfs_pdev);
-- 
2.28.0

