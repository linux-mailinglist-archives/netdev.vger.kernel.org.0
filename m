Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F075169D3F
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 23:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbfGOVFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 17:05:21 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44112 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731927AbfGOVFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 17:05:21 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so36362240iob.11;
        Mon, 15 Jul 2019 14:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SwLuc4Hf2LsLvAkrQGmyQjrb5PcpUEawFEMjfRbkASU=;
        b=mmbhB7YxKElWEK3UzVJlJpND90jtwj5VhsJtnJ5gN+Jil8o1kkkNQZlASUsLVeeRYx
         xM7Y6pUMBfJHvmiw4OXxrFp4licPaOgVCLwaxhJJa3XEcTAox0/C2bBwtumR3LLIRHqB
         jPN1uZxOc/uSLhTNoJyFkBQpGQQYaqHVYKWEXKqts2P7+TfWu9/1aFnocI6Dazd8N+qA
         7npNVuWLprozGmAeu8NB79MfxHFhblQ66FTck9IuWvGNTSbgKfe55voDLnVdAPXyui5k
         bty0V3jguFmtiC/s3EVmefyzd49JqNorB7Q+gEzZukuDI9/ot3zsJlxLmDVty54WK+Yt
         IV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SwLuc4Hf2LsLvAkrQGmyQjrb5PcpUEawFEMjfRbkASU=;
        b=rkt0bza0smZ4kq4BNWFTq7xC5pKTYuqP/Nq4pKIwGyPHyvmE53PkPC2ihypkOZgLMb
         5EApEwh1oEw575RZakJf6dwq2lg2uVbtm9oQzeMD3vSJLHZ1gR0Xf5NfVnnCoRRdTTBL
         aGz4pDwh0piw9xm1dLx19/LFs3Seg0KWOahc370Xbtp/t+NNprJbxFLfbihPuY41GE+w
         aG9FrfBsuq/P9Z1ffGe47TD3SQPkGLuMjFVsMasxnUKpqnr8WvnBB7a4Iuwh7FLhkxWI
         uiyzSDBQlo1vXOe30qxL99Tf+EsL/Unxno0df/3ypLMWxNfxIzlTE2Y4fOc99VRhW7bt
         ljvw==
X-Gm-Message-State: APjAAAV0WNOiCIx6SZZSAnZBVivepkwchpeEwUBmbeoz6VGjrLWxueGC
        0MKEkXhVS7LyjqA+TttXrVc=
X-Google-Smtp-Source: APXvYqymJ4dQFo+aNKlEe5L8WXFnYuzuoXmN4/7lbwzrnradKFqTf00Q/eqVwLbpZTxr2cJChHsv2g==
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr26183439iog.77.1563224720105;
        Mon, 15 Jul 2019 14:05:20 -0700 (PDT)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id t4sm15223028iop.0.2019.07.15.14.05.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 14:05:19 -0700 (PDT)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Fugang Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1] net: fec: optionally reset PHY via a reset-controller
Date:   Mon, 15 Jul 2019 17:05:12 -0400
Message-Id: <20190715210512.15823-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current fec driver allows the PHY to be reset via a gpio,
specified in the devicetree. However, some PHYs need to be reset
in a more complex way.

To accommodate such PHYs, allow an optional reset controller
in the fec devicetree. If no reset controller is found, the
fec will fall back to the legacy reset behaviour.

Example:
&fec {
	phy-mode = "rgmii";
	resets = <&phy_reset>;
	reset-names = "phy";
	status = "okay";
};

Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
---

Will send a Documentation patch if this receives a positive review.

 drivers/net/ethernet/freescale/fec_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 38f10f7dcbc3..5a5f3ed6f16d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -61,6 +61,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/if_vlan.h>
 #include <linux/pinctrl/consumer.h>
+#include <linux/reset.h>
 #include <linux/prefetch.h>
 #include <soc/imx/cpuidle.h>
 
@@ -3335,6 +3336,7 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 static int
 fec_probe(struct platform_device *pdev)
 {
+	struct reset_control *phy_reset;
 	struct fec_enet_private *fep;
 	struct fec_platform_data *pdata;
 	struct net_device *ndev;
@@ -3490,7 +3492,9 @@ fec_probe(struct platform_device *pdev)
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = fec_reset_phy(pdev);
+	phy_reset = devm_reset_control_get_exclusive(&pdev->dev, "phy");
+	ret = IS_ERR(phy_reset) ? fec_reset_phy(pdev) :
+			reset_control_reset(phy_reset);
 	if (ret)
 		goto failed_reset;
 
-- 
2.17.1

