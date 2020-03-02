Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 517A7176441
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgCBTtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:49:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36382 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCBTtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:49:17 -0500
Received: by mail-wm1-f66.google.com with SMTP id g83so387069wme.1
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 11:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/v3jzhMdKRSg5ahJijbYJL2JRg/6pSJrzS5jEYW61Z0=;
        b=Sh9Lv0ceSW/5CSvgPZRNHLKcI6vBv8DbKbO0MGNyUgFv5g5ilThb2Q7IOY9F3syorE
         oeNGLf03Il7LMusuTuhKaYe4vOC2dCPQBaEFjdey3CRERslkWhQR8U2MAKC8+DJRzsvb
         KC7r/l+0mey0c24muNq5HInOI5GmQUdc/B9ojVayFT8ypOzXQqgHSegtPgRKFnmOFY2o
         KpGnf27P9SI6fmE2Dzn9hcF7iJ/+Dpj0dBCl6PtnjukaJ3jJkAEfjzz1XTLMF+lPfWkZ
         uW2Mc3AxTGxjw0dzeY8u4QwioYkDkM7cvCP/7l0lKWpt3/wEN+JMo+ClDddLbwzd6G3J
         XyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/v3jzhMdKRSg5ahJijbYJL2JRg/6pSJrzS5jEYW61Z0=;
        b=qpA/1ua9IUc1XIKN+CG8UV+qaD6wriPPtSUvb4haVuZMz1MAcvoXTeq9qHzE5YH8Yy
         l27puJZVgw9i0JHc8SSg4YSaaWqj+umdGzgry2gz992LPncTozAUBJaTGIpmQivhVC5y
         58qtW749/1P94tGCTI7c2rhD1Hpm2uVhN4IMZ10S6FmfZSznCnOvZ2CXky+oTZDVM/Yl
         uEzRjGwkHdC2w6NWXZq1pI/w2zlVPSSUx8BBOBv9pBDju+wmTJ521VPmUlxMY6TljqpT
         V0YpIVH7PYtHk3dSBi2NEmyPTNs+wRiBXONR8+P8zs+CFjGylu1OAai1DtklERtEenS2
         teqA==
X-Gm-Message-State: ANhLgQ0G22RXR7B9E0KpD25bcmZ3HISOOgs4l31bqqgLJJYOhF/HLRND
        9qNXyEoFwLmI0/vspUCnPcfxJq9h
X-Google-Smtp-Source: ADFU+vvUjsIyIfTPXzHvosttvjUG56xKwsA+EEpMDwEJF8pSX+1BLNHSQdj32RrIcgdh3KWwiFZDIQ==
X-Received: by 2002:a05:600c:2951:: with SMTP id n17mr47722wmd.97.1583178553683;
        Mon, 02 Mar 2020 11:49:13 -0800 (PST)
Received: from localhost.localdomain (dslb-088-073-004-194.088.073.pools.vodafone-ip.de. [88.73.4.194])
        by smtp.gmail.com with ESMTPSA id c11sm29183735wrp.51.2020.03.02.11.49.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 11:49:13 -0800 (PST)
From:   Jonas Gorski <jonas.gorski@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: phy: bcm63xx: fix OOPS due to missing driver name
Date:   Mon,  2 Mar 2020 20:46:57 +0100
Message-Id: <20200302194657.14356-1-jonas.gorski@gmail.com>
X-Mailer: git-send-email 2.13.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

719655a14971 ("net: phy: Replace phy driver features u32 with link_mode
bitmap") was a bit over-eager and also removed the second phy driver's
name, resulting in a nasty OOPS on registration:

[    1.319854] CPU 0 Unable to handle kernel paging request at virtual address 00000000, epc == 804dd50c, ra == 804dd4f0
[    1.330859] Oops[#1]:
[    1.333138] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.4.22 #0
[    1.339217] $ 0   : 00000000 00000001 87ca7f00 805c1874
[    1.344590] $ 4   : 00000000 00000047 00585000 8701f800
[    1.349965] $ 8   : 8701f800 804f4a5c 00000003 64726976
[    1.355341] $12   : 00000001 00000000 00000000 00000114
[    1.360718] $16   : 87ca7f80 00000000 00000000 80639fe4
[    1.366093] $20   : 00000002 00000000 806441d0 80b90000
[    1.371470] $24   : 00000000 00000000
[    1.376847] $28   : 87c1e000 87c1fda0 80b90000 804dd4f0
[    1.382224] Hi    : d1c8f8da
[    1.385180] Lo    : 5518a480
[    1.388182] epc   : 804dd50c kset_find_obj+0x3c/0x114
[    1.393345] ra    : 804dd4f0 kset_find_obj+0x20/0x114
[    1.398530] Status: 10008703 KERNEL EXL IE
[    1.402833] Cause : 00800008 (ExcCode 02)
[    1.406952] BadVA : 00000000
[    1.409913] PrId  : 0002a075 (Broadcom BMIPS4350)
[    1.414745] Modules linked in:
[    1.417895] Process swapper/0 (pid: 1, threadinfo=(ptrval), task=(ptrval), tls=00000000)
[    1.426214] Stack : 87cec000 80630000 80639370 80640658 80640000 80049af4 80639fe4 8063a0d8
[    1.434816]         8063a0d8 802ef078 00000002 00000000 806441d0 80b90000 8063a0d8 802ef114
[    1.443417]         87cea0de 87c1fde0 00000000 804de488 87cea000 8063a0d8 8063a0d8 80334e48
[    1.452018]         80640000 8063984c 80639bf4 00000000 8065de48 00000001 8063a0d8 80334ed0
[    1.460620]         806441d0 80b90000 80b90000 802ef164 8065dd70 80620000 80b90000 8065de58
[    1.469222]         ...
[    1.471734] Call Trace:
[    1.474255] [<804dd50c>] kset_find_obj+0x3c/0x114
[    1.479141] [<802ef078>] driver_find+0x1c/0x44
[    1.483665] [<802ef114>] driver_register+0x74/0x148
[    1.488719] [<80334e48>] phy_driver_register+0x9c/0xd0
[    1.493968] [<80334ed0>] phy_drivers_register+0x54/0xe8
[    1.499345] [<8001061c>] do_one_initcall+0x7c/0x1f4
[    1.504374] [<80644ed8>] kernel_init_freeable+0x1d4/0x2b4
[    1.509940] [<804f4e24>] kernel_init+0x10/0xf8
[    1.514502] [<80018e68>] ret_from_kernel_thread+0x14/0x1c
[    1.520040] Code: 1060000c  02202025  90650000 <90810000> 24630001  14250004  24840001  14a0fffb  90650000
[    1.530061]
[    1.531698] ---[ end trace d52f1717cd29bdc8 ]---

Fix it by readding the name.

Fixes: 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode bitmap")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/net/phy/bcm63xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/bcm63xx.c b/drivers/net/phy/bcm63xx.c
index 23f1958ba6ad..459fb2069c7e 100644
--- a/drivers/net/phy/bcm63xx.c
+++ b/drivers/net/phy/bcm63xx.c
@@ -73,6 +73,7 @@ static struct phy_driver bcm63xx_driver[] = {
 	/* same phy as above, with just a different OUI */
 	.phy_id		= 0x002bdc00,
 	.phy_id_mask	= 0xfffffc00,
+	.name		= "Broadcom BCM63XX (2)",
 	/* PHY_BASIC_FEATURES */
 	.flags		= PHY_IS_INTERNAL,
 	.config_init	= bcm63xx_config_init,
-- 
2.13.2

