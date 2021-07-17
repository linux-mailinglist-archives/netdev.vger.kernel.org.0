Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFBE3CC64D
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235850AbhGQUoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhGQUoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AF2C061764;
        Sat, 17 Jul 2021 13:41:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id u1so16232326wrs.1;
        Sat, 17 Jul 2021 13:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tPr7LAmpU6jyv73PvT3aqNoJ9gxeSNay3lgZkX9Owew=;
        b=oqR3B2p7Dz3pZE49V3HySWH7R69B2m6be3Y7fHHrUoKKK1ns82+VxxGcuyzN3eFi6Z
         tZ+ZJED62OWpAo/Tc3p6XtOMFc7Yf25JtDE4E7kqBLu4/HZDCJD3dwtUkRwaG4odV3pu
         53o3Gfc7kUeXov30zckdSSpWAdJ8meNFjKVH1sDaPg988qtQc9X41w427u6fNp/RDQZE
         9w3h2Pyv2huCn6kkkTREpygwfN3lrMsFEiyzeX1eRydSWqZa//njqdZlXThLl7u2Zq+A
         GJumDOyDl240Ps8J23hFyi3qN58mMLVYAN7ipOaUX5siIJ/lMDeY6xclqPm/ocl+WcwD
         rfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tPr7LAmpU6jyv73PvT3aqNoJ9gxeSNay3lgZkX9Owew=;
        b=JCvifR9yMc6r7uSP2cIQAPeSHpcDJg5Mf/wzPyB/Syh/De12k+cIHma07No4T2Wrqj
         +x0uyWHnl7FvvR5XbbkDC5HdKYis8Vbt3ycM8dBNgQXOkdJ5EhkzEOKhc5/KseInYo8p
         /F73povOq62YYZb/Dy44HgqXqyIO9NmSoA43IIKEVX0zVl1yH4Aeiz8As45RbTPbk4Us
         bpsrh44x1lDuElvMJYXvP+9VYkKDjFR+DUaN2KSJ/vxEPJkS4lioRejuEnOg4peISkw7
         4KJAuFewlFINFrbSMs+K+dyz+fcemjmB7G5iQEIFXaW/LRYWgRTMMRl17qlt+swBVWt/
         qaOg==
X-Gm-Message-State: AOAM5308D7wk323lOHCRY+1B6UWv3PDufYFIaoK7b8OFKgyT+XOQTtFA
        5uuUw0gcLavvlXX9foaGY9aunhLwIBs=
X-Google-Smtp-Source: ABdhPJxUfvevUhOuI0hyiP84rLEwP67gmLb8dOHuZtzP8MUM/lM252U2vJjrz+G8/mWB6mDjlWdFbw==
X-Received: by 2002:a5d:5987:: with SMTP id n7mr20756010wri.263.1626554472448;
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:11 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
Date:   Sat, 17 Jul 2021 22:40:52 +0200
Message-Id: <20210717204057.67495-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
all users of rtw_iterate_vifs_atomic() which are either reading or
writing a register to rtw_iterate_vifs().

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 +++---
 drivers/net/wireless/realtek/rtw88/ps.c   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index c6364837e83b..207161a8f5bd 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -229,8 +229,8 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	rtw_phy_dynamic_mechanism(rtwdev);
 
 	data.rtwdev = rtwdev;
-	/* use atomic version to avoid taking local->iflist_mtx mutex */
-	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
+
+	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
 
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
@@ -578,7 +578,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rcu_read_unlock();
 	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
-	rtw_iterate_vifs_atomic(rtwdev, rtw_reset_vif_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index 3f0ac33156d6..95f9060b083f 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -58,7 +58,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev)
 		return ret;
 	}
 
-	rtw_iterate_vifs_atomic(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_LEAVE);
 
-- 
2.32.0

