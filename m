Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD0B35711A
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbhDGPy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353919AbhDGPyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:54:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB62C061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:54:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id a12so8744576wrq.13
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2+JHVerYYa6GG4c08d4TcVEUoR33xnyDOTHyaZRdooA=;
        b=Lco4dhkEWUPD3Eae9DRMc32aokoBJIlVgPw3sUSiFRf6114OFHxmw3yERd7ipP08Xa
         m77rWhKcTSdRChbK+scckFJIoAb55zOZ/B03R5Emtbi4nXnHJ4V4SZ18Hzp4wM5NmbMW
         S19K+bArXbgnsu8twfqQsn/prT4nd7bCz1QGnj0ktUmw0f5YuB9RNux7SaZFwiF0akPj
         2km6AOsjz1eusNawNFay0nrxq8rp1SJY+X89wXbYdioUY02msf4WntyZL4FwstFdVLQG
         jm8ED7btqP1P1loTME1uXRZ4WtnfgHHDfWnUB8QPRoopPJ3KhigD9x3XnldUquwQ9RNF
         9lEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+JHVerYYa6GG4c08d4TcVEUoR33xnyDOTHyaZRdooA=;
        b=kuTdb/nTI5fI8VbJVo5DUi3AOgY6dM0PgTo6Ury9x4eNQZZ5YzEFC6KwAFavYVKX/S
         oXh9gxg0ag1JDh/hx4YkWqES3wATJDCvW3jS3G25Yb/k8EJwQ88kNWFtzf07YH54u7aq
         +g1+DLoqprsJtpu6PXu+/+lAlCjYnqLVGMum+ArdR2uoxDaZWifHCZshcHr6y1Y/p82u
         oKa+BMN8b73uY7X8hhUEWxo9ooPRPq/xH+GjvyTH3Vv555J1J0LME4AI6emZqEByXH2N
         hIvAisZNDgjsHyW9DRry4nNWKsnXLoTx0b/wbqip0DOHmnOEgjaVqccTSJ5Vp9fEsjvo
         EN/w==
X-Gm-Message-State: AOAM5323VjaDMbx3wDLFZfOzrwt6WZF9T4FeGnq9IrakhBNzWIno4Yyg
        PLLEUUG3IgT0Qad5fw9Uimk=
X-Google-Smtp-Source: ABdhPJxiDlCmzAWtgkJabVGxWmC758KeMSZrKooxAIVOLl9c/c3YqOunmeopdErhjcIuqFtmvCnCWQ==
X-Received: by 2002:a05:6000:1204:: with SMTP id e4mr5302049wrx.266.1617810844136;
        Wed, 07 Apr 2021 08:54:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:15f8:68c8:25bd:c1f8? (p200300ea8f38460015f868c825bdc1f8.dip0.t-ipconnect.de. [2003:ea:8f38:4600:15f8:68c8:25bd:c1f8])
        by smtp.googlemail.com with ESMTPSA id l9sm7685984wmq.2.2021.04.07.08.54.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 08:54:03 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: make PHY PM ops a no-op if MAC driver
 manages PHY PM
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Message-ID: <cd2c3325-d742-29a7-9310-899bec0061ca@gmail.com>
Date:   Wed, 7 Apr 2021 17:51:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resume callback of the PHY driver is called after the one for the MAC
driver. The PHY driver resume callback calls phy_init_hw(), and this is
potentially problematic if the MAC driver calls phy_start() in its resume
callback. One issue was reported with the fec driver and a KSZ8081 PHY
which seems to become unstable if a soft reset is triggered during aneg.

The new flag allows MAC drivers to indicate that they take care of
suspending/resuming the PHY. Then the MAC PM callbacks can handle
any dependency between MAC and PHY PM.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 include/linux/phy.h          | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a009d1769..73d29fd5e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -273,6 +273,9 @@ static __maybe_unused int mdio_bus_phy_suspend(struct device *dev)
 {
 	struct phy_device *phydev = to_phy_device(dev);
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	/* We must stop the state machine manually, otherwise it stops out of
 	 * control, possibly with the phydev->lock held. Upon resume, netdev
 	 * may call phy routines that try to grab the same lock, and that may
@@ -294,6 +297,9 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 	struct phy_device *phydev = to_phy_device(dev);
 	int ret;
 
+	if (phydev->mac_managed_pm)
+		return 0;
+
 	if (!phydev->suspended_by_mdio_bus)
 		goto no_resume;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 8e2cf84b2..98fb441dd 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -493,6 +493,7 @@ struct macsec_ops;
  * @loopback_enabled: Set true if this PHY has been loopbacked successfully.
  * @downshifted_rate: Set true if link speed has been downshifted.
  * @is_on_sfp_module: Set true if PHY is located on an SFP module.
+ * @mac_managed_pm: Set true if MAC driver takes of suspending/resuming PHY
  * @state: State of the PHY for management purposes
  * @dev_flags: Device-specific flags used by the PHY driver.
  * @irq: IRQ number of the PHY's interrupt (-1 if none)
@@ -567,6 +568,7 @@ struct phy_device {
 	unsigned loopback_enabled:1;
 	unsigned downshifted_rate:1;
 	unsigned is_on_sfp_module:1;
+	unsigned mac_managed_pm:1;
 
 	unsigned autoneg:1;
 	/* The most recently read link state */
-- 
2.31.1


