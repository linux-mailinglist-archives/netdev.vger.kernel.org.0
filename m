Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346B335711B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242921AbhDGPya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353957AbhDGPyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:54:18 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3499C061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:54:08 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so1451020wmi.3
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 08:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aMGyAFd9YLfxjRcx8M/V4oDEl2++Et9egjLBfgDzzzQ=;
        b=aRMuSCDXgFT9oBEKC6xwl5XNGMuL9USVJJHPJLmeH+p6eHly1yHlU3c+I0AbjAvpvJ
         aWOcMHbmYw3LjUvQjGaixJfCfNq5PAt4KIhVaPbNBs1xnuLa8KI+7XGhytby12MiQg2X
         P5+zet08UrJ8Ten5KoMmUUUdMzpQpyWKGS77LPWtAYqHHZVIVD8FMyjITWcjAl5AECBb
         7EzFc+pgRi0wzhUJdP1HWvfo1RtkoG68U9qss0/seOFIkidkzNTG+nGJWWG2zsPK4p/E
         kJ9tKzTxF5XupjRItZzSbhgGmkKQ0HHo6bgrs4buy7hRh+LSsmEVZ1vOoqLmItpjBCNS
         YQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aMGyAFd9YLfxjRcx8M/V4oDEl2++Et9egjLBfgDzzzQ=;
        b=DhGLZIII27EcimKhp1zxld68Fmd80CB4oxec14Np1RZ/5ubmnNzmsJlzCyGz7/yInt
         1QbnkFjWcwcq3rXVqEjAZ3t/Cws3IRQH5hGm7zlcGEfnf3K6IW/l6TRZZv7OuvkqZGwt
         cS3s1x28GrI7L6OJI8En9kq0ccNrtKsR6adJyc4AV3jHrsG7Weoddw4PDb0RsFPWiUXR
         YHSSc8o7b4IERphqXhVtFOASdlpAcCbrkEmUvyacX0WDe/NrJ2bQOu+CkSGPNNKc0rts
         0+Jj6jAC4ywBTRLOmE66OYXTtGQbg/4IcLlY7y1lf/qkg4W7A+d9djRr6xGZa/R0lp/A
         KQXA==
X-Gm-Message-State: AOAM532BHKhdOz8T0aVwCzb1h7BdsMA9WS+iWYlRSWqSjngXevtmwzvX
        djsfPxHfTE4s0MJGji8bsYKGR/HCicQ=
X-Google-Smtp-Source: ABdhPJzWdkGCei0FS+/ZbMMlYQbiBRNr3ICGZmkL/MjheaPGlQLVLPdAEwVEwg3eKJuy94YG4R9l2A==
X-Received: by 2002:a05:600c:4d13:: with SMTP id u19mr3690879wmp.16.1617810847508;
        Wed, 07 Apr 2021 08:54:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:15f8:68c8:25bd:c1f8? (p200300ea8f38460015f868c825bdc1f8.dip0.t-ipconnect.de. [2003:ea:8f38:4600:15f8:68c8:25bd:c1f8])
        by smtp.googlemail.com with ESMTPSA id k13sm48751069wri.27.2021.04.07.08.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 08:54:07 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Message-ID: <a34e3ad6-21a8-5151-7beb-5080f4ac102a@gmail.com>
Date:   Wed, 7 Apr 2021 17:52:45 +0200
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

Use the new mac_managed_pm flag to work around an issue with KSZ8081 PHY
that becomes unstable when a soft reset is triggered during aneg.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 3db882322..70aea9c27 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2048,6 +2048,8 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
+	phy_dev->mac_managed_pm = 1;
+
 	phy_attached_info(phy_dev);
 
 	return 0;
@@ -3864,6 +3866,7 @@ static int __maybe_unused fec_resume(struct device *dev)
 		netif_device_attach(ndev);
 		netif_tx_unlock_bh(ndev);
 		napi_enable(&fep->napi);
+		phy_init_hw(ndev->phydev);
 		phy_start(ndev->phydev);
 	}
 	rtnl_unlock();
-- 
2.31.1


