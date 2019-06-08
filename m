Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F053A013
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfFHNzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:55:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34868 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfFHNzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:55:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so4368666wml.0
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0yHDve2KE3ymsbRByAlQGc4D2oH0b8t0txYIJKWqjf4=;
        b=j+hE+OsmMac6h89itWxVq6k1G/mNazoU/1qMwr92j8ydytzKfwIkezIKvIHvq/N/Iw
         fy1mus+5Uu9XK95fRIxWVuIyaDWAu3PzQnrB7XljPx2tWACjI/KLs6eh+E9nAwvM1q3C
         zW1fpLiwon3m7HP2V2XnN7e5tqeAyM8iYehXAFQwZHdbQb4oKeQV/3EI8xRVwvdbBWi2
         qJ7XMkMqBroR88/X3j/s1VJO5HwZFi0d4yU/tSIMZtR4BhWqFdtUqo6sU7L93TZg0uUb
         pnfLI3foRD0ogGWBagfNiMJnGdSiDc5TnXquK2M6Hs8eP8ZEWleow0vAZy7siXZN8p4J
         rD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0yHDve2KE3ymsbRByAlQGc4D2oH0b8t0txYIJKWqjf4=;
        b=CJs7wX8aZ4i7Lf5xSr+akU4g/pJZ1LDn+YiSqsoghyfDIUOx2Pq4qZD77jQ0lkaiPG
         JfEbDgKJPbt1BagrQhdAyMkep1KQ0zddmmKUwpE6Mz8qqn/LwTgrz2RJwZBMk160ohxx
         fWX7HQx4uZyi5k6HO0mod6osH/ZQzft7h5Ja5bK7JtVQOkaiGaoaclx4LwMCLIopok4u
         vvp0Du38GE2UwXKEVUfA2S6WLANYyikxf02BYwuN5EhNwfsjpNJaMzSUe7FKmUHw5mr6
         tChdh63+W4/UY6tSTCGEazb6XxPjIGNHQxxOMJVPyVwV+r0ASGkmd0CEH+0o6mBGthcU
         4HqQ==
X-Gm-Message-State: APjAAAX/Tqy5YNnBBT6dDWAGVIwH42VT2UKnFNjPwzymadKhwCiKVUr3
        orfbsKF0sMi++AUX2qMTsmA=
X-Google-Smtp-Source: APXvYqznAIdir4e6nZlmbK+b5M5GoRrvYoh1mh07FMC83+ozWhSIChztK5daWhSBSvGSBBqbK7n6Rg==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr7295174wmj.79.1560002115013;
        Sat, 08 Jun 2019 06:55:15 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id t63sm8806395wmt.6.2019.06.08.06.55.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:55:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/1] net: phy: broadcom: Add genphy_suspend and genphy_resume for BCM5464
Date:   Sat,  8 Jun 2019 16:53:56 +0300
Message-Id: <20190608135356.29898-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This puts the quad PHY ports in power-down mode when the PHY transitions
to the PHY_HALTED state.  It is likely that all the other PHYs support
the BMCR_PDOWN bit, but I only have the BCM5464R to test.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/phy/broadcom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 67fa05d67523..937d0059e8ac 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -663,6 +663,8 @@ static struct phy_driver broadcom_drivers[] = {
 	.config_init	= bcm54xx_config_init,
 	.ack_interrupt	= bcm_phy_ack_intr,
 	.config_intr	= bcm_phy_config_intr,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_BCM5481,
 	.phy_id_mask	= 0xfffffff0,
-- 
2.17.1

