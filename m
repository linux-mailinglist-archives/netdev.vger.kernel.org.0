Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABC13A32D6
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhFJSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:17:40 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:37608 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhFJSRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:17:39 -0400
Received: by mail-ej1-f45.google.com with SMTP id ce15so620999ejb.4
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a7vhUiTYDEG/V1oZMelDSdoMfqEJq1hJ94swJWeR58A=;
        b=hAsmwndiCHmufp2lbNk5junpdsZCk0Ev53GOeLOTDza0SsDgw5s6b5vu13VcHsDAn3
         1QyJSMhiwX5WfZr5BD9ueTMP8lmb8zrdPLi3Fu7uMnGeiLtDU6hsI8JwWTaOheG+Nth/
         r0iHMv0rBoYfOf6qsjIcSEV1iZJ9DPV1jOppfexn4orV6BiWnDDRE+rmL0yc8cFANNci
         lw8U4DXtJr+vANQOxqTMYGopNYvz0iWHpMrFwbGhILFDtyN6VF7vTg1D+P5VyniM6sLG
         Qj4WHLPMF1PO+6nQDKuXGoFLT55oHbQltYA+YNnjVBWhkP/C7ximuTC2DPEzBdGbqfpD
         gv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7vhUiTYDEG/V1oZMelDSdoMfqEJq1hJ94swJWeR58A=;
        b=C8ZcHpocL4nyF0seYPVrtkydLJhwfs9Bi74vNucVI5VTnBc6IsaXmvENLHQNhbFqr4
         PIGoGNiGYc0cMrGKDQF0aewURMH+rjRCNFDo34k7VjD57nvJgKoAvYgqNNl/CL+Qp70/
         COL5zEeD4tbLMEFiUGS1pTiKe/C/2AXmO0GQCxV4G6GG9Azk2a2uMgd9kyCPEpRuWFQp
         NHjMJxAmZzYa458lmKxc/EiphHsuhzDPI9A8wXNjy/v9p3VBBZqswwIQhErGI1iq0Gyw
         IR9wPh/UliaDpuljC9KZ9poemhxqrlmwrJ3lke5ryrboOzYVRb4MxpYrYiQe+N4vrmuS
         wv+Q==
X-Gm-Message-State: AOAM530PINdf6psiwXY8aTMKtX2IR3UOIKuIa5PfStfQyasmgnsO+3dK
        aOCR+9leiDUh2lWLjZ6gTW61BpNpgug=
X-Google-Smtp-Source: ABdhPJx9Q2VHtaKFjYhRfWGGWEkr7Zzf0tviL72m28YULFJg45SsYOnQ6IUJxlVp92mO92DvEFILvQ==
X-Received: by 2002:a17:906:520f:: with SMTP id g15mr873012ejm.126.1623348873890;
        Thu, 10 Jun 2021 11:14:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:32 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 05/13] net: pcs: xpcs: add support for sgmii with no inband AN
Date:   Thu, 10 Jun 2021 21:14:02 +0300
Message-Id: <20210610181410.1886658-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In fixed-link use cases, the XPCS can disable the clause 37 in-band
autoneg process, disable the "Automatic Speed Mode Change after CL37 AN"
setting, and force operation in a speed dictated by management.

Add support for this operating mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/pcs/pcs-xpcs.c | 41 +++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 8ca7592b02ec..743b53734eeb 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -690,7 +690,7 @@ int xpcs_config_eee(struct dw_xpcs *xpcs, int mult_fact_100ns, int enable)
 }
 EXPORT_SYMBOL_GPL(xpcs_config_eee);
 
-static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs)
+static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs, unsigned int mode)
 {
 	int ret;
 
@@ -726,7 +726,10 @@ static int xpcs_config_aneg_c37_sgmii(struct dw_xpcs *xpcs)
 	if (ret < 0)
 		return ret;
 
-	ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	if (phylink_autoneg_inband(mode))
+		ret |= DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
+	else
+		ret &= ~DW_VR_MII_DIG_CTRL1_MAC_AUTO_SW;
 
 	return xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, ret);
 }
@@ -772,7 +775,7 @@ static int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 		}
 		break;
 	case DW_AN_C37_SGMII:
-		ret = xpcs_config_aneg_c37_sgmii(xpcs);
+		ret = xpcs_config_aneg_c37_sgmii(xpcs, mode);
 		if (ret)
 			return ret;
 		break;
@@ -905,6 +908,36 @@ static void xpcs_get_state(struct phylink_pcs *pcs,
 	}
 }
 
+static void xpcs_link_up_sgmii(struct dw_xpcs *xpcs, unsigned int mode,
+			       int speed, int duplex)
+{
+	int val, ret;
+
+	if (phylink_autoneg_inband(mode))
+		return;
+
+	switch (speed) {
+	case SPEED_1000:
+		val = BMCR_SPEED1000;
+		break;
+	case SPEED_100:
+		val = BMCR_SPEED100;
+		break;
+	case SPEED_10:
+		val = BMCR_SPEED10;
+		break;
+	default:
+		return;
+	}
+
+	if (duplex == DUPLEX_FULL)
+		val |= BMCR_FULLDPLX;
+
+	ret = xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+	if (ret)
+		pr_err("%s: xpcs_write returned %pe\n", __func__, ERR_PTR(ret));
+}
+
 static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 			 phy_interface_t interface, int speed, int duplex)
 {
@@ -912,6 +945,8 @@ static void xpcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 
 	if (interface == PHY_INTERFACE_MODE_USXGMII)
 		return xpcs_config_usxgmii(xpcs, speed);
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		return xpcs_link_up_sgmii(xpcs, mode, speed, duplex);
 }
 
 static u32 xpcs_get_id(struct dw_xpcs *xpcs)
-- 
2.25.1

