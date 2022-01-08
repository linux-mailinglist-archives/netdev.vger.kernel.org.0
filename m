Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1418488029
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiAHAz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiAHAz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:56 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3B9C061746;
        Fri,  7 Jan 2022 16:55:56 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id w20so14097595wra.9;
        Fri, 07 Jan 2022 16:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oj4lreG5cZ3IFWojzIgNqoaNn8hukHMIHKIyr0AoqhQ=;
        b=FAkCyaCI7M8dKvQXbzj7oupyr8/9BeYZzD3Yv59P6xI5tvjYYWecCg9aBDdNIJBqxH
         jjH+GPDoY2febVvQElAnknU/4aWhXg8KCsS6VpsVgXDE7+3bJqbBWBH/24DSLLgPfZTp
         EyCUHa/LdPYS0/PKFNmXa2HQujZwg8SH+fntqFRLUGZa08HvlggX1ZIU1quR7i2CJkUL
         dnNv4TiN8UrcSQjX5l4khg7Q0VAF29cEFTfeX5iJqWkgT5Zp/NaJ7xV10H1l/nK1CHEl
         3uvkOxLSlaFG/It4JOD9lKsqCeBtdUzpc1hupKPxoyhvKBnMnRPE8NmSTk39X/UAqvg6
         dPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oj4lreG5cZ3IFWojzIgNqoaNn8hukHMIHKIyr0AoqhQ=;
        b=x0dlAarS4NYSxIn3MIACu+pIi5xEW0ZQBgNDVAGcbP2TFQwCjBoMFKFQ5074X69+3n
         SO84npM8a0LowkVH1/84dv0VFLbUDlp+E4ikCt4jntlLAWExQkiUm6hleiBHia9ZmHlq
         gVufD3CPefyDJwcHeW4aOn/E6wLFXn1HiIsuh8rvXqTS3AoPTrE8TG3uONvHndnIpVPL
         KdfOuD04Kd1/5lh2AnuJVUr5T3kHD2VAfu/vP4moYTGbeLrYNhvBaoOoQAUFnc7IfTjW
         FnoG8utF6fNyY+Io3L/iqrXmCIs1s6ajj8WPXI/hWlb1crerJdTiSsJPcvSZOZ4V3+sg
         NpLg==
X-Gm-Message-State: AOAM530KE+pZ/+8O60hFavNFBMHsP6eN5sNqWRQ1SImSzWFrhYzHS/nl
        TV402aAXBPkDK/VaVEPmInuRv+xrgdE=
X-Google-Smtp-Source: ABdhPJz6iNPuc7qQIeeDmrpvajqPDL4Qabf1r6tGeClhMoijvVqyFWtBMvLPGl8Ii3qRDLwO3/EN0g==
X-Received: by 2002:a05:6000:2cc:: with SMTP id o12mr55248819wry.206.1641603354533;
        Fri, 07 Jan 2022 16:55:54 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:54 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 7/8] rtw88: hci: Convert rf_lock from a spinlock to a mutex
Date:   Sat,  8 Jan 2022 01:55:32 +0100
Message-Id: <20220108005533.947787-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
rf_lock from a spinlock to a mutex to allow for this behavior.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/hci.h  | 11 ++++-------
 drivers/net/wireless/realtek/rtw88/main.c |  2 +-
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 4c6fc6fb3f83..3c730b7a94f7 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -166,12 +166,11 @@ static inline u32
 rtw_read_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	    u32 addr, u32 mask)
 {
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
+	mutex_lock(&rtwdev->rf_lock);
 	val = rtwdev->chip->ops->read_rf(rtwdev, rf_path, addr, mask);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
+	mutex_unlock(&rtwdev->rf_lock);
 
 	return val;
 }
@@ -180,11 +179,9 @@ static inline void
 rtw_write_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	     u32 addr, u32 mask, u32 data)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
+	mutex_lock(&rtwdev->rf_lock);
 	rtwdev->chip->ops->write_rf(rtwdev, rf_path, addr, mask, data);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
+	mutex_unlock(&rtwdev->rf_lock);
 }
 
 static inline u32
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 3d4257e0367a..a94678effd77 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1920,12 +1920,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->rf_lock);
 	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
 
 	mutex_init(&rtwdev->mutex);
+	mutex_init(&rtwdev->rf_lock);
 	mutex_init(&rtwdev->coex.mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index dc1cd9bd4b8a..e7a60e6f8596 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1949,7 +1949,7 @@ struct rtw_dev {
 	struct mutex mutex;
 
 	/* read/write rf register */
-	spinlock_t rf_lock;
+	struct mutex rf_lock;
 
 	/* watch dog every 2 sec */
 	struct delayed_work watch_dog_work;
-- 
2.34.1

