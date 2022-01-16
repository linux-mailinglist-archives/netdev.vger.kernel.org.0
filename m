Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED3848FF08
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 22:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiAPVQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 16:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbiAPVQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 16:16:03 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A224C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id v123so16508068wme.2
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 13:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=mhkaL5juH4guy48KuGF+fYnZTlI1q0boY2IwcDBWEPQ=;
        b=AeFRxDPoC2zhcdlERdxoTZs/hjLPyAaR4LmBcGv+bnERRK1afCv7/Jb83hAm2MxNvF
         gUjoSiL49a55oqlWGKn+yHqb3uG3uySVzV+VOVSnptDokuyAvAKBrlVBftHHfobqOn19
         lwJ4g2GuC1VGFmfPJeYMur91L8yO1AdMJpx8GwxAVLXzZ9Hhg0COy+GlVMGW/s1Dsjc5
         jDHu17OnNA9+IRP5fNQlNabpSZy/StlcQ3BSuDqoYLR5ObxkWXnmK1JJtBMzahs00pNi
         0qk5jyVvU7EQ8DoV1VbYVh6s7FdS6lCKclPiLmUHP09NNb3M0jXBAzZ6AZ6I3OnAR27h
         HesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=mhkaL5juH4guy48KuGF+fYnZTlI1q0boY2IwcDBWEPQ=;
        b=ovIYc6pidNzHlhdTnRVgRrtP/P30M9MOBD6zSAl47ALZ8mwMqRCwnsMr/0B1NQ1SbR
         FqDIRZaFjWcBEEzUJ8pKYXQBUvPLZSLAV6no97f5h7rtUYJN0dUlIEWF2wHN0MarbsdM
         Ufy1rTA7Oz5FuG+QudhlD5lcOJq9xA2Lo2YszuXSaUhXkV9jdphqUlTyQ2ji9SkbfJU6
         UnDZqhDO8E9+hOJru7n2lz6MS/DXzIywRxfhrzbXeTYzEz7gMyaprJz0BdYxlVLwVplB
         DvMcMNhJxPHGkVKBgVdKtz5kuKGewBRVAhilmEehyV7Jt3OMaKbf0aFGDh8cvc3i5t+A
         XUCA==
X-Gm-Message-State: AOAM532GIe6kFwOEQ5ubB9vYh2xTwoGOIqGYv9xZTPAJjmXf6ax+aJ8g
        dhrhK0Tplf9m9rSOedKFCPjPNQ==
X-Google-Smtp-Source: ABdhPJyl6EaOH2pNOGinkeqLhxtw/E//xARDY73P8G8xmFz/3e3RakxjgzdvwghHMOymGyyM/lgBAg==
X-Received: by 2002:adf:eec9:: with SMTP id a9mr16478793wrp.178.1642367761748;
        Sun, 16 Jan 2022 13:16:01 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l12sm8820445wrz.15.2022.01.16.13.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:16:01 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     madalin.bucur@nxp.com, robh+dt@kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH net 4/4] net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module
Date:   Sun, 16 Jan 2022 22:15:29 +0100
Message-Id: <20220116211529.25604-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220116211529.25604-1-tobias@waldekranz.com>
References: <20220116211529.25604-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by sparse: In the remove path, the driver would attempt to
unmap its own priv pointer - instead of the io memory that it mapped
in probe.

Fixes: 9f35a7342cff ("net/fsl: introduce Freescale 10G MDIO driver")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index bf566ac3195b..266e562bd67a 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -331,9 +331,10 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 static int xgmac_mdio_remove(struct platform_device *pdev)
 {
 	struct mii_bus *bus = platform_get_drvdata(pdev);
+	struct mdio_fsl_priv *priv = bus->priv;
 
 	mdiobus_unregister(bus);
-	iounmap(bus->priv);
+	iounmap(priv->mdio_base);
 	mdiobus_free(bus);
 
 	return 0;
-- 
2.25.1

