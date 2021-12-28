Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EACF480D4C
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbhL1VPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237383AbhL1VPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:24 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B118CC06173E;
        Tue, 28 Dec 2021 13:15:23 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id a203-20020a1c7fd4000000b003457874263aso13402413wmd.2;
        Tue, 28 Dec 2021 13:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eir22dEvm+/a+IM/fF5TOGAC5dG+fiQ9p937xH/yeHg=;
        b=NS3iWLZMeaa2oNYWNDrgczQOtlVvMqfM6v8OWNpjesPd8FqZG4RTZfvXy6rMOmTtnw
         ugAMpE0AN/S6qkVoZ6QDCoPj4xyazYTgdhnNKgUSFYMsoVVJmit3wwACL7pcSKSU1C/p
         eSpi2dHfBXoAtdxBfeHK7rJN7SO27dBESXt6mv6BL01RfoJaw3uksgVPwd5E9loMsvt0
         BPCgCI4f92TZjV9SgDiUx6QKHnrP3Lnfz1dCzEPZoo+1YhUSZ0b0cz2bTYGJ01FxlLBD
         ICEr570LhppZKiVQbYD9/FIOSkbxVOrJE35h4Ghlwb8eHPENir3XZzKkHIo88d6PTsKk
         iyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eir22dEvm+/a+IM/fF5TOGAC5dG+fiQ9p937xH/yeHg=;
        b=Lxa6F3wG7wgNSI6quKzdJeM1PIc6GoRU8/uP9qtZfPIRnAZgMs4KZ1IF5kggNylJ/k
         eMj8HqtpSpLPX/HSMMSxp0TvMBQrVHnmR+qj7ZPjr1hoH7KgnIitp2Sv9+bSFUAy2pew
         vViXIfWh87Ln1hX94z4xOm0Z4W7UrzrBQQbTVYO3botKDwFb9cuBw6fkLglt5C17uPuY
         BgzttxZtoCY4p8OmPRLvXuf5cV4JtTYfTox88GL1cy+aFaYsWFasPv3ZkGtMD+9JgGJd
         9o9EZAaRMW3cnpAmkrWnzqCUwCulCgOVivah3OGoVSdS/KBii/MoEgBV+JTbWn8pB9a2
         Is2g==
X-Gm-Message-State: AOAM530anOM2QV2zxbYRLnqIUyjMuu+qOFxai6M+HigVXStrSLA3+iTn
        K8nG7j6YxcO71eF9sSrY4vNvjCmvWvU=
X-Google-Smtp-Source: ABdhPJyogg07htxPb2moDSF114S06c0OGcDfqC6ikew+3yPasNWSrZp6zp76Cd2nIvzsV9L6mWwcQQ==
X-Received: by 2002:a05:600c:6018:: with SMTP id az24mr18648389wmb.103.1640726122019;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:21 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 4/9] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
Date:   Tue, 28 Dec 2021 22:14:56 +0100
Message-Id: <20211228211501.468981-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
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
 drivers/net/wireless/realtek/rtw88/main.c | 2 +-
 drivers/net/wireless/realtek/rtw88/ps.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index fd02c0b0025a..b0e2ca8ddbe9 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -585,7 +585,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rcu_read_unlock();
 	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
-	rtw_iterate_vifs_atomic(rtwdev, rtw_reset_vif_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw88/ps.c b/drivers/net/wireless/realtek/rtw88/ps.c
index bfa64c038f5f..a7213ff2c224 100644
--- a/drivers/net/wireless/realtek/rtw88/ps.c
+++ b/drivers/net/wireless/realtek/rtw88/ps.c
@@ -58,7 +58,7 @@ int rtw_leave_ips(struct rtw_dev *rtwdev)
 		return ret;
 	}
 
-	rtw_iterate_vifs_atomic(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
+	rtw_iterate_vifs(rtwdev, rtw_restore_port_cfg_iter, rtwdev);
 
 	rtw_coex_ips_notify(rtwdev, COEX_IPS_LEAVE);
 
-- 
2.34.1

