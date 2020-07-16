Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179B1222F29
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgGPXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgGPXjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:39:05 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0895DC061755;
        Thu, 16 Jul 2020 16:39:05 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so8946439wrw.12;
        Thu, 16 Jul 2020 16:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XX3Vy1+ViyMfYAwN08J9FEPsETuh0ck0xBw+ZEi19d8=;
        b=m7H3YTYk8V9jXZinw8voB7Q0YIQSByZgIRTMzQlf1YC9yF6yq60yfd03ubyDZ/V1nJ
         aJiEqwC48DyboLmVg9YHey23JKnJmBmlD+0g/MHtdvOeDj2dWwBhAguHBBy033wMzuSH
         RtvMFt9ZBtoz2LHUaBybjQ0UVF1kWzSfjxl2m5s2oVhu3NtAtXDA4K3vOIku8tHf5jRv
         7dxaUA3gYvgNz79P0W/e8Xbrc8/8DZPGPKHrnWDHHT2nk8FozB2Ikb7K//kfp2sm5vHN
         YOIdMI9S8FQ92DS6gmZfgnT9lAl6IRs4Imzg3tB2rN5majqgTO7uq6IRgMAHd4Ui5stq
         h4dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XX3Vy1+ViyMfYAwN08J9FEPsETuh0ck0xBw+ZEi19d8=;
        b=BqbNQeVrd16xXPIu/z6nwAwngwG2L81XdjV8enIikIjrD85DOFSoSPaD4IHrDR4zzN
         Q/S0TKEIMvhqCM5Yh/eZqmwoeepqda6X6yMwEsdbtUSTnse6XUfvse5VpZyOTv7J1ZUE
         fzf5OqUGGY2YO0W5FjIod2fx3dE6ehf1ChgscI4XYx77opQmAKDTZJmmV+Kde10WSpfG
         lBAvYCIIsSsIqcu+EaUuEUtFE9ohok1VuUPheRSTBgemJpXWUZx3wSL5tVDlrW6++dzG
         BkGV4xykclvRHt9yhK63zaiReVCx2OChg96L78e/vMzP+YjvM3OnIxVz6G/AZ6w+Mxxu
         DK2A==
X-Gm-Message-State: AOAM532Dk4x8hmr5ZOSMWZ2aS63DQilU/YcKGmSODkEFwSOHTOA93K9a
        2vrm4azfIJE3OItEI0dK9HI=
X-Google-Smtp-Source: ABdhPJzh7dZgaGRvUkQoXIb1/amJ8mrPUmwHSrGjf/hHJwlQ8h95E7yRWKAH9IAVlu0EV9RN1ft6cw==
X-Received: by 2002:adf:eecf:: with SMTP id a15mr7407437wrp.83.1594942743787;
        Thu, 16 Jul 2020 16:39:03 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u65sm11278013wmg.5.2020.07.16.16.39.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 16:39:03 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 1/3] net: bcmgenet: test MPD_EN when resuming
Date:   Thu, 16 Jul 2020 16:38:15 -0700
Message-Id: <1594942697-37954-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
References: <1594942697-37954-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the GENET driver resumes from deep sleep the UMAC_CMD
register may not be accessible and therefore should not be
accessed from bcmgenet_wol_power_up_cfg() if the GENET has
been reset.

This commit adds a check of the MPD_EN flag when Wake on
Magic Packet is enabled. A clear flag indicates that the
GENET hardware must have been reset so the remainder of the
hardware programming is bypassed.

Fixes: 1a1d5106c1e3 ("net: bcmgenet: move clk_wol management to bcmgenet_wol")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
index 4ea6a26b04f7..def990dbf34f 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -217,11 +217,16 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 
 	priv->wol_active = 0;
 	clk_disable_unprepare(priv->clk_wol);
+	priv->crc_fwd_en = 0;
 
 	/* Disable Magic Packet Detection */
-	reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
-	reg &= ~(MPD_EN | MPD_PW_EN);
-	bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	if (priv->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE)) {
+		reg = bcmgenet_umac_readl(priv, UMAC_MPD_CTRL);
+		if (!(reg & MPD_EN))
+			return;	/* already reset so skip the rest */
+		reg &= ~(MPD_EN | MPD_PW_EN);
+		bcmgenet_umac_writel(priv, reg, UMAC_MPD_CTRL);
+	}
 
 	/* Disable WAKE_FILTER Detection */
 	reg = bcmgenet_hfb_reg_readl(priv, HFB_CTRL);
@@ -232,5 +237,4 @@ void bcmgenet_wol_power_up_cfg(struct bcmgenet_priv *priv,
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
-	priv->crc_fwd_en = 0;
 }
-- 
2.7.4

