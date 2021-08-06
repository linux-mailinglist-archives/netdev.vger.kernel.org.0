Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0772F3E2886
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 12:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbhHFKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244928AbhHFKZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 06:25:12 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A66C061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 03:24:56 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k4so10464904wrc.0
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 03:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1M+kjBe5LJfHMKPYebEvjyNaiKWDMDU0Hnt7bpr7e5A=;
        b=SyY5P3/3fn3OPSGo81KmIl2K9Y502cNWmKbU9aTw7C+3CMdbgYAMOdrU0sphIJVJaf
         A4qkFfiU+075rWAkUPF3xkwV0v2K2kvwD+XgvgHliCYW5CBMvwzm4nf0TwECQvZMVV10
         LvGbpOrinF4IpxYj6+F9M69H0Gm5I0JD81bhT+SeiEXkqUUbAZwP0alzGz/76+D1vv0/
         8QvQA7FyThN88MOFBp8GCCfY9iuTZMPRCaxyQR6Ro6b+Je1y96jRbrdn2rcKG5cXUaxx
         Iq3cSXTbP7T75vjY22yR7POqfg2iumeMN8q3svM7RijFlkg134qZKrZQ/kRs3+IWsXi9
         g2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1M+kjBe5LJfHMKPYebEvjyNaiKWDMDU0Hnt7bpr7e5A=;
        b=A8x84wlAQGYFno1sNdzuOnr9KEnxcEOgvSUV8WYV2hsyaaXfSmB1cG4JtuSJhvqvWy
         luazIH3HUYF0G9FlXXBs1di8nc2fbnoP4K13CuHBnOk/pIFoZOZvY1+PcqlaEmm81y61
         O9i59exDKDiBgWBCSUuOeaC9TZyI3io5qi+b3yaowd4rBRwAa6f9NBbYRh8YeXCRaoiq
         lyyPG1F4vkl5mw4cv7IRWZMSPuCgyj9U9N8DJeDZ+yd2CMgrHYnKA5IkX3TF5J6nqzb0
         38wFHL0qZd5qiCGJk/UA+uiMikSLQLNVAaW7JRkijswyr1/uOrO8plISM2Mjamu5228r
         geMA==
X-Gm-Message-State: AOAM533kyt7Xmh2FzvyZP9ILDU+9fcpomPAAJA9NNFs9nyDR1EJAqu1N
        6LyHnuIdRsdhDaHgY7H8a6WRkg==
X-Google-Smtp-Source: ABdhPJxSzwnrWJd6HOIHDdO0i5FgxOaiJVWQPX9HROVajB1M+Pbg6yh5sjgRNWN0X88hjVAkTPTQvQ==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr9729993wrq.273.1628245495152;
        Fri, 06 Aug 2021 03:24:55 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:69b5:b274:5cfc:ef2])
        by smtp.gmail.com with ESMTPSA id k17sm9046540wrw.53.2021.08.06.03.24.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:24:54 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ryazanov.s.a@gmail.com,
        Loic Poulain <loic.poulain@linaro.org>, stable@vger.kernel.org
Subject: [PATCH net-next] net: wwan: mhi_wwan_ctrl: Fix possible deadlock
Date:   Fri,  6 Aug 2021 12:35:09 +0200
Message-Id: <1628246109-27425-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lockdep detected possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&mhiwwan->rx_lock);
                               local_irq_disable();
                               lock(&mhi_cntrl->pm_lock);
                               lock(&mhiwwan->rx_lock);
   <Interrupt>
     lock(&mhi_cntrl->pm_lock);

  *** DEADLOCK ***

To prevent this we need to disable the soft-interrupts when taking
the rx_lock.

Cc: stable@vger.kernel.org
Fixes: fa588eba632d ("net: Add Qcom WWAN control driver")
Reported-by: Thomas Perrot <thomas.perrot@bootlin.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wwan/mhi_wwan_ctrl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wwan/mhi_wwan_ctrl.c b/drivers/net/wwan/mhi_wwan_ctrl.c
index 1e18420..d0a98f3 100644
--- a/drivers/net/wwan/mhi_wwan_ctrl.c
+++ b/drivers/net/wwan/mhi_wwan_ctrl.c
@@ -41,14 +41,14 @@ struct mhi_wwan_dev {
 /* Increment RX budget and schedule RX refill if necessary */
 static void mhi_wwan_rx_budget_inc(struct mhi_wwan_dev *mhiwwan)
 {
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 
 	mhiwwan->rx_budget++;
 
 	if (test_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags))
 		schedule_work(&mhiwwan->rx_refill);
 
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 }
 
 /* Decrement RX budget if non-zero and return true on success */
@@ -56,7 +56,7 @@ static bool mhi_wwan_rx_budget_dec(struct mhi_wwan_dev *mhiwwan)
 {
 	bool ret = false;
 
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 
 	if (mhiwwan->rx_budget) {
 		mhiwwan->rx_budget--;
@@ -64,7 +64,7 @@ static bool mhi_wwan_rx_budget_dec(struct mhi_wwan_dev *mhiwwan)
 			ret = true;
 	}
 
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 
 	return ret;
 }
@@ -130,9 +130,9 @@ static void mhi_wwan_ctrl_stop(struct wwan_port *port)
 {
 	struct mhi_wwan_dev *mhiwwan = wwan_port_get_drvdata(port);
 
-	spin_lock(&mhiwwan->rx_lock);
+	spin_lock_bh(&mhiwwan->rx_lock);
 	clear_bit(MHI_WWAN_RX_REFILL, &mhiwwan->flags);
-	spin_unlock(&mhiwwan->rx_lock);
+	spin_unlock_bh(&mhiwwan->rx_lock);
 
 	cancel_work_sync(&mhiwwan->rx_refill);
 
-- 
2.7.4

