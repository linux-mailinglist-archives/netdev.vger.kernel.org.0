Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4937393D8B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 09:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235378AbhE1HOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 03:14:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58844 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbhE1HOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 03:14:52 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210528071313epoutp0133fdc12bad012121da3bd0ebad2e603a~DKZD9COVr3145631456epoutp01l
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:13:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210528071313epoutp0133fdc12bad012121da3bd0ebad2e603a~DKZD9COVr3145631456epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622185993;
        bh=eJa+86OcRqxCiA1C3LtXZu46pnrxbtquoVaayjkhGUk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=MM6kUCHD4FWSyHb2SDJtWpRshIvCtfDOQYwK8IXvAhAJm0nk6idqrKIezp9SPwIUA
         asvahuPtZgg6nyMqRVKD7z+eW8MmL7sfvICWQP/fOtm1kbzRVOehEOMcrzok4UP3K9
         e/5rmTDYt+8457J8Wj49CUFIXuNLRRg4SskQshMU=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210528071312epcas5p333529873e7afadd6ead90c5d140759a0~DKZC0Frof3167531675epcas5p3p;
        Fri, 28 May 2021 07:13:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2B.7C.09606.80890B06; Fri, 28 May 2021 16:13:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210528070406epcas5p3807d9c8f8a68c0c4a75af9951476c1b7~DKRGNq-MF1153011530epcas5p32;
        Fri, 28 May 2021 07:04:06 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210528070406epsmtrp23ef512f910c472cc7ecaef0a01f54681~DKRGMkguS0043300433epsmtrp2r;
        Fri, 28 May 2021 07:04:06 +0000 (GMT)
X-AuditID: b6c32a49-bf1ff70000002586-1b-60b09808d953
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4D.8E.08637.5E590B06; Fri, 28 May 2021 16:04:05 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210528070404epsmtip2682ad48727f0db82da0771ac585345b2~DKRETSEFj3081430814epsmtip2d;
        Fri, 28 May 2021 07:04:03 +0000 (GMT)
From:   Sriranjani P <sriranjani.p@samsung.com>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        boon.leong.ong@intel.com, Sriranjani P <sriranjani.p@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] net: stmmac: fix kernel panic due to NULL pointer
 dereference of mdio_bus_data
Date:   Fri, 28 May 2021 12:40:56 +0530
Message-Id: <20210528071056.35252-1-sriranjani.p@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSWUwTURiFvbO0Q01xLFqvLC64EIyCGNBJ1KpxyShRfFDTEJQ2MoJCoZmK
        Cw+KsSbSRKpRqtZKsHWBYgUqIIsNUAW34JISEESwSGNU3KigyCbt1Pj2nf+ce8+fm0ugovN4
        ILE//SDDpsvTQnkCrPJBeNgS4lKpbOlQB04NfdQBqrfEyKMML9QY1WX8ilMvK3Nxyvq+Facc
        NQYeZc+zASp/1IJTTQViyljxk0+Nf64A1Ju+O/haIe1ofYXS5UXtCO3SVvDpav1bPm26/xGh
        reYcHn33+nE6t9wMaNdv20Sszg1ot3XW9snxglVJTNr+QwwbKZEJUr435+JKLXmk4p6Llw20
        /hrgR0AyGrY0OngaICBEZC2ABUM/cU70A+gqOgE4MQjgxUqPwx0ZceWinGED0OYy8DmhRuCP
        /DLEk+KRS+CpVreXp5EyeLpnFPGEUFKPwGJ7o9cIIOVwuOwRz8MYuQB+a/rjrRCSq+HvF/UY
        VzcbFpfWe+sgmUPAh6YvfM7YAIvc73wcAD89KvdxIHR/tU1cSkxwBnzpSOXGR2Bzv9oXWQPr
        WwyYJ4KS4bCkJpIbh8C8p3e8q6GkPzwz3ItwcyGsyv/HC6GpJ8fHwdDS0+97FRresIyhHhaR
        u2FndRV2FoTo/zcUAGAGMxmlSpHMqGKUUenM4QiVXKHKTE+O2JuhsALvv1m0uQq8ffc9wg4Q
        AtgBJNDQacKGkxaZSJgkP5rFsBmJbGYao7KDIAILnSEsdJ6Xichk+UEmlWGUDPvPRQi/wGxk
        fax6d1Ng+Dpj28CB94tfr3o+LhX0Va90Fmviy2KTIDVgmiPt/tUbg0n35Bn84sTmkAOpK9BX
        7Mj4Fn1JgyJYp0afK0LqdKPzTJI1BWz2qcQpZknw9L211Vn5hf1nx04HjSv0fRLngk7Trn0b
        /QdBB8q2Hps/NamzpXFy4rVBxZcnUTu3Fn+Qjj1p0XRr50Y4N82PC0vY/nR5Xe2GjsxwcePq
        rLbuM86gdr+AWUwz31JzNfJyzOxtw5UgcgBMquoGjq5oS6xUP1LKT+kavC1R3pQWao/durBM
        J9bUzA16bH9wOM64Y5NjpS76nPrK5RH2zzPr1qaGuLABs/hcwrNQTJUij1qEsir5X3ZrQyim
        AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWy7bCSvO6zqRsSDCY6WPx8OY3R4sn6RWwW
        c863sFjcW/SO1eLCtj5Wi02Pr7FaXN41h83i0NS9jBbz/q5ltTi2QMxi0dYv7Bb/X29ltLj9
        Zh2rA6/H5WsXmT22rLzJ5PG0fyu7x85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXo8/bEXqGz/
        Z0aPz5vkArijuGxSUnMyy1KL9O0SuDI+nO1jLegXqNi6/SlbA2M/XxcjJ4eEgInEn6d9zF2M
        XBxCArsZJe6tuc8OkZCROPlgCTOELSyx8t9zdoiiJiaJOWvvMIIk2AR0JVqvfWbqYuTgEBFI
        kji3vgykhllgCZPElvuXwAYJC8RL/Hy3gRXEZhFQlXh/7BeYzStgK/Hj/AEWiAXyEqs3HGCe
        wMizgJFhFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcOBqae5g3L7qg94hRiYOxkOM
        EhzMSiK8B5vXJgjxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TB
        KdXAtHldesBrnaL3WvKHGfyb2Wd+KI9+/FtWdsGZnPUPw48o6mcdlynPutGud+jU8Rcvz8nP
        DVXhlKlkEIwKvMX4f+9E+Tv/xVdUcgUveK5i5GU6M7lj65qZvFvW5Vyc8nBX8P4IL4cDb1u+
        vdjzvbHM37BQQGXW/Heyjf+21Z9keOXtZlD6yuzSY68K1pS9nQbB/2TWV8e/4l8zcct8thNr
        d4dZxLDPzS1fPWXlb7/lZnHis22tFl69uWSe8qEda2KdOyqN169pMnzC4PJCrXvajrRfc4V3
        3Fq4RyV90Tl+5v1rPM3+9zksXho7MfulzpXrCU4La93u7d07TfOkSr5SkwD/5qfaVl4NaX/u
        q4veKVNiKc5INNRiLipOBACQhUq6ywIAAA==
X-CMS-MailID: 20210528070406epcas5p3807d9c8f8a68c0c4a75af9951476c1b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CMS-RootMailID: 20210528070406epcas5p3807d9c8f8a68c0c4a75af9951476c1b7
References: <CGME20210528070406epcas5p3807d9c8f8a68c0c4a75af9951476c1b7@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed link does not need mdio bus and in that case mdio_bus_data will
not be allocated. Before using mdio_bus_data we should check for NULL.

This patch fix the kernel panic due to NULL pointer dereference of
mdio_bus_data when it is not allocated.

Without this patch we do see following kernel crash caused due to kernel
NULL pointer dereference.

Call trace:
stmmac_dvr_probe+0x3c/0x10b0
dwc_eth_dwmac_probe+0x224/0x378
platform_probe+0x68/0xe0
really_probe+0x130/0x3d8
driver_probe_device+0x68/0xd0
device_driver_attach+0x74/0x80
__driver_attach+0x58/0xf8
bus_for_each_dev+0x7c/0xd8
driver_attach+0x24/0x30
bus_add_driver+0x148/0x1f0
driver_register+0x64/0x120
__platform_driver_register+0x28/0x38
dwc_eth_dwmac_driver_init+0x1c/0x28
do_one_initcall+0x78/0x158
kernel_init_freeable+0x1f0/0x244
kernel_init+0x14/0x118
ret_from_fork+0x10/0x30
Code: f9002bfb 9113e2d9 910e6273 aa0003f7 (f9405c78)
---[ end trace 32d9d41562ddc081 ]---

Fixes: e5e5b771f684 ("net: stmmac: make in-band AN mode parsing is supported for non-DT")
Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5d956a553434..5d7688d02255 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1240,8 +1240,10 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 	priv->phylink_config.pcs_poll = true;
-	priv->phylink_config.ovr_an_inband =
-		priv->plat->mdio_bus_data->xpcs_an_inband;
+	if (priv->plat->mdio_bus_data) {
+		priv->phylink_config.ovr_an_inband =
+			priv->plat->mdio_bus_data->xpcs_an_inband;
+	}
 
 	if (!fwnode)
 		fwnode = dev_fwnode(priv->device);
-- 
2.17.1

