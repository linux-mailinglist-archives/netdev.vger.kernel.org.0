Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BE6C8BCD
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfJBOtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:49:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39344 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfJBOtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:49:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so7297245wml.4;
        Wed, 02 Oct 2019 07:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRX7MVzKV2NasOdGGBHZN5dKTeuEyw7WMiE2n0MgQj4=;
        b=en2MMk6iqR1ZVTx19B7QV5SSFiGdBrMrfCdmWNvgQZsf35VRZTwiIslnhd+/vgIybT
         l/dhyN7HvsyfFuvjnCFl3KTC92yK7jbh8u+BYLyOOJR8d5Jyl1g4/gyY6lsn/3AQECOJ
         rS24HXnqRGmQI6jJyWi9TfrLx25ELJfZeykeeGY3jl2e0QXGaL9X63goT51Kq0R7dTWC
         kmaCXoCAfBkL4i1SkrcNO9XHPM3aA786CjIv+hB9zqmsi9gPIz5VZwrzLUCKFyz6+MEO
         iiIqsObBjmCDeMU6WEendmJBrQwu1C8Aqd89QEVuEaeR4bW6K5FJJkCfQRk0jjdcd44w
         /mOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MRX7MVzKV2NasOdGGBHZN5dKTeuEyw7WMiE2n0MgQj4=;
        b=fSZ+qNbpG9L442jUZALQPAur4p4FgaY4bm0lmClgdJHGzTbREkewqQa4m87OZiNhQU
         ifE91zfgQtLD83Ku7vmEKsZPjVY+WYcbf/6wesC6LvqUjpUwlATJIOhs4Besr7M3TRKV
         yyj/b6cBZud4ZrEnQRv6kMAbscgvRUWVwfxjzELdWCzPgL7CaYzS7nCrlVamJFD0txEv
         xrfTmQlbhJdrSYdAJrUJh11diNSBG2847SiImF3eFb7h8FzM0QKj9MFPs8X3BhEMEwh1
         bD3w0DpwnROq7B+oh+fRhFPfbaxSy2XZ1Hj6xKLJk0Sac5yT8wWiFfIppLUwnFROtWW0
         FO6g==
X-Gm-Message-State: APjAAAXfWD/9nJCZEo8ShxAU7pUxGAQ5nikMjhIwShpODuruYbsuIhuq
        YYZwiKnKYkfGERqoJKXzggk=
X-Google-Smtp-Source: APXvYqxcrs2DsroGKSrdpkWYOirroFKSyCTTGszuiL4Cvd7AIj6WKmnnHD6tEhs6eZ4x1BFazvUPaA==
X-Received: by 2002:a7b:ce0a:: with SMTP id m10mr3397067wmc.167.1570027789092;
        Wed, 02 Oct 2019 07:49:49 -0700 (PDT)
Received: from localhost (p2E5BE2CE.dip0.t-ipconnect.de. [46.91.226.206])
        by smtp.gmail.com with ESMTPSA id l10sm27877457wrh.20.2019.10.02.07.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:49:47 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: Avoid deadlock on suspend/resume
Date:   Wed,  2 Oct 2019 16:49:46 +0200
Message-Id: <20191002144946.176976-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The stmmac driver will try to acquire its private mutex during suspend
via phylink_resolve() -> stmmac_mac_link_down() -> stmmac_eee_init().
However, the phylink configuration is updated with the private mutex
held already, which causes a deadlock during suspend.

Fix this by moving the phylink configuration updates out of the region
of code protected by the private mutex.

Fixes: 19e13cb27b99 ("net: stmmac: Hold rtnl lock in suspend/resume callbacks")
Suggested-by: Bitan Biswas <bbiswas@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 843d53e084b7..c76a1336a451 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4716,10 +4716,10 @@ int stmmac_suspend(struct device *dev)
 	if (!ndev || !netif_running(ndev))
 		return 0;
 
-	mutex_lock(&priv->lock);
-
 	phylink_mac_change(priv->phylink, false);
 
+	mutex_lock(&priv->lock);
+
 	netif_device_detach(ndev);
 	stmmac_stop_all_queues(priv);
 
@@ -4733,9 +4733,11 @@ int stmmac_suspend(struct device *dev)
 		stmmac_pmt(priv, priv->hw, priv->wolopts);
 		priv->irq_wake = 1;
 	} else {
+		mutex_unlock(&priv->lock);
 		rtnl_lock();
 		phylink_stop(priv->phylink);
 		rtnl_unlock();
+		mutex_lock(&priv->lock);
 
 		stmmac_mac_set(priv, priv->ioaddr, false);
 		pinctrl_pm_select_sleep_state(priv->device);
@@ -4827,6 +4829,8 @@ int stmmac_resume(struct device *dev)
 
 	stmmac_start_all_queues(priv);
 
+	mutex_unlock(&priv->lock);
+
 	if (!device_may_wakeup(priv->device)) {
 		rtnl_lock();
 		phylink_start(priv->phylink);
@@ -4835,8 +4839,6 @@ int stmmac_resume(struct device *dev)
 
 	phylink_mac_change(priv->phylink, true);
 
-	mutex_unlock(&priv->lock);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_resume);
-- 
2.23.0

