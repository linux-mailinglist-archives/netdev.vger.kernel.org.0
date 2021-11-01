Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A6D4417CC
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 10:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhKAJkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 05:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbhKAJiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 05:38:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5B4C0431A9;
        Mon,  1 Nov 2021 02:22:27 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k22so6793613ljk.5;
        Mon, 01 Nov 2021 02:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qWSEirly4n64mZ55Ypk7HFX/ooed9xF0zO6hXUeUyg4=;
        b=SC/QIDLuGFPfgiy3NDa5sleLCWa3tpyd6dJMzvpin43aKorTe1D32C/vlmCfqts9Ky
         fZmy4gNcQ/29WGa6Suul76Odk/aSv46cbeVi06jdef/qzNmHDlIHzH0vvMyOPdBhvcvt
         1ZpzgonYBH0q+IPhJsR0ycI9CuxVTpbclpRcRly1hc9T34WrebQFhsucl7tTsCPDaV3a
         LrAcRBBSBcM2bPqmBEML7sJ7MqEqblv3y4cRX/Ee3Hr2e63eFj2PdVhSKkZthe6qhgVs
         QWNQevuKa6XJlBqDwZJlvSp5anjU31pbSp39YMkNRwcJgD664Cy6cZ8oZ7huYA1Yncua
         AFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qWSEirly4n64mZ55Ypk7HFX/ooed9xF0zO6hXUeUyg4=;
        b=VueoV9UJm0z3xxG5zueMit7Uf5fyBmscXzbXH89K/YuFm7fioDWRs0IGceLMwwgmkd
         dXzI/dA6YqR2QuT7S8RH6w0dE8vklAJ5cKeMEE+7JNoqNfrCPe9ZiWauFQElHo1Ixs3E
         VXwE9vbSBjJcFXYwF9f/M9QxC17urE2Fy+cdagamYi0uJ+64Yd7ras+rQKTrdQOWGc/A
         t96ekxVAYtizaW47EmFjmcUdAxcO/0KwmbDER8JSzYdaVCpLprAmF2ldeT1admKME+Fe
         dd9AUbEU7cssB1jqvv4ZmixdfPNn9UKb5qosehyL578wJ7QCtGG+iadga0I5eD77gfuD
         USQw==
X-Gm-Message-State: AOAM533BiQ2Bo2BSE3xJIL4PLa73GWfe2PVotUnM3z9jnHqOCs92XxEK
        1evWtwEKgCszbFQqpeb5Clk=
X-Google-Smtp-Source: ABdhPJyn8AEyu8HmFDn8qiACtk6rC9fX9Whk3T7aVlj+l0fnlqtJFkO2HVtBT7Nx9oOU14FtOLWV8g==
X-Received: by 2002:a2e:89c6:: with SMTP id c6mr30980418ljk.25.1635758545791;
        Mon, 01 Nov 2021 02:22:25 -0700 (PDT)
Received: from localhost.localdomain (pool-95-83-120-25.ptcomm.ru. [95.83.120.25])
        by smtp.googlemail.com with ESMTPSA id d19sm1363985lfv.74.2021.11.01.02.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:22:25 -0700 (PDT)
From:   Maxim Kiselev <bigunclemax@gmail.com>
Cc:     Maxim Kiselev <bigunclemax@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Michael Walle <michael@walle.cc>, Sriram <srk@ti.com>,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: davinci_emac: Fix interrupt pacing disable
Date:   Mon,  1 Nov 2021 12:21:32 +0300
Message-Id: <20211101092134.3357661-1-bigunclemax@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to use 0 for `coal->rx_coalesce_usecs` param to
disable rx irq coalescing.

Previously we could enable rx irq coalescing via ethtool
(For ex: `ethtool -C eth0 rx-usecs 2000`) but we couldn't disable
it because this part rejects 0 value:

       if (!coal->rx_coalesce_usecs)
               return -EINVAL;

Fixes: 84da2658a619 ("TI DaVinci EMAC : Implement interrupt pacing
functionality.")

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
---
 drivers/net/ethernet/ti/davinci_emac.c | 77 ++++++++++++++------------
 1 file changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index e8291d8488391..a3a02c4e5eb68 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -417,46 +417,47 @@ static int emac_set_coalesce(struct net_device *ndev,
 			     struct netlink_ext_ack *extack)
 {
 	struct emac_priv *priv = netdev_priv(ndev);
-	u32 int_ctrl, num_interrupts = 0;
+	u32 int_ctrl = 0, num_interrupts = 0;
 	u32 prescale = 0, addnl_dvdr = 1, coal_intvl = 0;
 
-	if (!coal->rx_coalesce_usecs)
-		return -EINVAL;
-
 	coal_intvl = coal->rx_coalesce_usecs;
 
 	switch (priv->version) {
 	case EMAC_VERSION_2:
-		int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
-		prescale = priv->bus_freq_mhz * 4;
-
-		if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
-			coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
-
-		if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
-			/*
-			 * Interrupt pacer works with 4us Pulse, we can
-			 * throttle further by dilating the 4us pulse.
-			 */
-			addnl_dvdr = EMAC_DM646X_INTPRESCALE_MASK / prescale;
-
-			if (addnl_dvdr > 1) {
-				prescale *= addnl_dvdr;
-				if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
-							* addnl_dvdr))
-					coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
-							* addnl_dvdr);
-			} else {
-				addnl_dvdr = 1;
-				coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
+		if (coal->rx_coalesce_usecs) {
+			int_ctrl =  emac_ctrl_read(EMAC_DM646X_CMINTCTRL);
+			prescale = priv->bus_freq_mhz * 4;
+
+			if (coal_intvl < EMAC_DM646X_CMINTMIN_INTVL)
+				coal_intvl = EMAC_DM646X_CMINTMIN_INTVL;
+
+			if (coal_intvl > EMAC_DM646X_CMINTMAX_INTVL) {
+				/*
+				 * Interrupt pacer works with 4us Pulse, we can
+				 * throttle further by dilating the 4us pulse.
+				 */
+				addnl_dvdr =
+					EMAC_DM646X_INTPRESCALE_MASK / prescale;
+
+				if (addnl_dvdr > 1) {
+					prescale *= addnl_dvdr;
+					if (coal_intvl > (EMAC_DM646X_CMINTMAX_INTVL
+								* addnl_dvdr))
+						coal_intvl = (EMAC_DM646X_CMINTMAX_INTVL
+								* addnl_dvdr);
+				} else {
+					addnl_dvdr = 1;
+					coal_intvl = EMAC_DM646X_CMINTMAX_INTVL;
+				}
 			}
-		}
 
-		num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
+			num_interrupts = (1000 * addnl_dvdr) / coal_intvl;
+
+			int_ctrl |= EMAC_DM646X_INTPACEEN;
+			int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
+			int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
+		}
 
-		int_ctrl |= EMAC_DM646X_INTPACEEN;
-		int_ctrl &= (~EMAC_DM646X_INTPRESCALE_MASK);
-		int_ctrl |= (prescale & EMAC_DM646X_INTPRESCALE_MASK);
 		emac_ctrl_write(EMAC_DM646X_CMINTCTRL, int_ctrl);
 
 		emac_ctrl_write(EMAC_DM646X_CMRXINTMAX, num_interrupts);
@@ -466,17 +467,21 @@ static int emac_set_coalesce(struct net_device *ndev,
 	default:
 		int_ctrl = emac_ctrl_read(EMAC_CTRL_EWINTTCNT);
 		int_ctrl &= (~EMAC_DM644X_EWINTCNT_MASK);
-		prescale = coal_intvl * priv->bus_freq_mhz;
-		if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
-			prescale = EMAC_DM644X_EWINTCNT_MASK;
-			coal_intvl = prescale / priv->bus_freq_mhz;
+
+		if (coal->rx_coalesce_usecs) {
+			prescale = coal_intvl * priv->bus_freq_mhz;
+			if (prescale > EMAC_DM644X_EWINTCNT_MASK) {
+				prescale = EMAC_DM644X_EWINTCNT_MASK;
+				coal_intvl = prescale / priv->bus_freq_mhz;
+			}
 		}
+
 		emac_ctrl_write(EMAC_CTRL_EWINTTCNT, (int_ctrl | prescale));
 
 		break;
 	}
 
-	printk(KERN_INFO"Set coalesce to %d usecs.\n", coal_intvl);
+	netdev_info(ndev, "Set coalesce to %d usecs.\n", coal_intvl);
 	priv->coal_intvl = coal_intvl;
 
 	return 0;
-- 
2.30.2

