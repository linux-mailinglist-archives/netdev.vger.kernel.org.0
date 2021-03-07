Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE35330131
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 14:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCGNXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 08:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCGNXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 08:23:52 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7EDC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 05:23:52 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ci14so14559953ejc.7
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 05:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1YpNq+LVoU76enp4WGBsUD6wC08LHC5HT/rt3sxj/98=;
        b=GP9lLKssjtQt7LhdapBTZtziuHHci7uB5e3eJdTU+lX8o2avAvTJSDZInMz1VpzYm+
         NchBxn5veo6zhwVN4rrRhZM7ma/mbxVSsnZSWgGm7Pi2uhrzKxaoh8mjThrVWneMdnFm
         kf3mT2oTYm50tOGrDF082QVtwV5Lv7WBWLxf2GFj5HMP7kfKFicRLrd0ktlHaB1afegB
         srqIYZ0M/poFWYP+iEBX3H/1PesnV/730XMDECruMol+TZKDfMpzW5glM1YglKdeAPRV
         Gbr/yjiEvC1to19xW/mxghOq1iBrREJEGpahyc3eZbWeXruFXCZBqEUlIwqthNDxAMEW
         gEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1YpNq+LVoU76enp4WGBsUD6wC08LHC5HT/rt3sxj/98=;
        b=sx3VgeIx7t66jK5SqYaqjY6AKr1XhrXgXLAmcBHlACCXGskklBbarr3++BZ5SZeyyd
         8EzXPoGCF27J1tJjzCqbI0C6j7kJo6/WlKLXEak6oy5K+rF3YiTzIedmzP6JwRVKc9jV
         prdhP5nlKuNfPYqeIm/dVuS2p+FaTyHPTJOyjDk+9i6mx0aWMputs49sPyQC9fYiMKds
         Lq4lepUq8KoILcfkCWwai/bMj7lrjSw++UH2mrdNPIokyOyE6oYih7oS3DPZMz+5mlck
         O9beFoUgOmsoEcBCTpW1dc7qdPo0irfhpZIVbwdfB/p3bZDlhE5OjCW678ENl0m0QO29
         YWxg==
X-Gm-Message-State: AOAM532LqRHKnMSjOPdmEVTjqr1Oe8+X4NGOt9G/QTirOEvFVmpRs0V1
        ud6DeaO2j/TQEovGc9w8JEA=
X-Google-Smtp-Source: ABdhPJw8o9ZbloRYpA8YORGu7jKCiG5XgBQ2mQZhRda2zntn40gmHSrKf4gSXzPYfZEYWVTzIF40NQ==
X-Received: by 2002:a17:906:304a:: with SMTP id d10mr10752851ejd.507.1615123431020;
        Sun, 07 Mar 2021 05:23:51 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id gj26sm4168584ejb.67.2021.03.07.05.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 05:23:50 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Jason Liu <jason.hui.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 1/2] net: enetc: set MAC RX FIFO to recommended value
Date:   Sun,  7 Mar 2021 15:23:38 +0200
Message-Id: <20210307132339.2320009-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

On LS1028A, the MAC RX FIFO defaults to the value 2, which is too high
and may lead to RX lock-up under traffic at a rate higher than 6 Gbps.
Set it to 1 instead, as recommended by the hardware design team and by
later versions of the ENETC block guide.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Reviewed-by: Jason Liu <jason.hui.liu@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h | 2 ++
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index de0d20b0f489..00938f7960a4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -234,6 +234,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_MAXFRM	0x8014
 #define ENETC_SET_TX_MTU(val)	((val) << 16)
 #define ENETC_SET_MAXFRM(val)	((val) & 0xffff)
+#define ENETC_PM0_RX_FIFO	0x801c
+#define ENETC_PM0_RX_FIFO_VAL	1
 
 #define ENETC_PM_IMDIO_BASE	0x8030
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ca02f033bea2..224fc37a6757 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -490,6 +490,12 @@ static void enetc_configure_port_mac(struct enetc_hw *hw)
 
 	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
+
+	/* On LS1028A, the MAC RX FIFO defaults to 2, which is too high
+	 * and may lead to RX lock-up under traffic. Set it to 1 instead,
+	 * as recommended by the hardware team.
+	 */
+	enetc_port_wr(hw, ENETC_PM0_RX_FIFO, ENETC_PM0_RX_FIFO_VAL);
 }
 
 static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
-- 
2.25.1

