Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B974E673FD9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjASRZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASRZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:25:47 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70653B764
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:25:46 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JHDBPf2320861
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 17:13:13 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30JHD6Pj3882120
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 18:13:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674148386; bh=KEYk8Cr3sKr35aQe8ptIjLu8fGLeZ5ESUBqxBN4lhiQ=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=VZhQZD5ifHcddogIhjJI4CjhpZX1NAk1pEdCkhMaQcJBZKNEY3hdDrWhvwfvtM+ne
         h2UyXCq++T+VOHqGEw12OixKjRcdXkGVvSnAHEBItxGsZAZNBwf1nRCOpP4h29a4W5
         lksT6oCoiULOh4WNop9m3YxkgqBNhMDCPUrjK6RQ=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30JHD6oW3882115;
        Thu, 19 Jan 2023 18:13:06 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net 2/3] net: mediatek: sgmii: autonegotiation is required
Date:   Thu, 19 Jan 2023 18:12:47 +0100
Message-Id: <20230119171248.3882021-3-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119171248.3882021-1-bjorn@mork.no>
References: <20230119171248.3882021-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sgmii mode fails if autonegotiation is disabled.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 481f2f1e39f5..d1f2bcb21242 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -62,14 +62,9 @@ static int mtk_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	 * other words, 1000Mbps or 2500Mbps).
 	 */
 	if (interface == PHY_INTERFACE_MODE_SGMII) {
-		sgm_mode = SGMII_IF_MODE_SGMII;
-		if (phylink_autoneg_inband(mode)) {
-			sgm_mode |= SGMII_REMOTE_FAULT_DIS |
-				    SGMII_SPEED_DUPLEX_AN;
-			use_an = true;
-		} else {
-			use_an = false;
-		}
+		sgm_mode = SGMII_IF_MODE_SGMII | SGMII_REMOTE_FAULT_DIS |
+			   SGMII_SPEED_DUPLEX_AN;
+		use_an = true;
 	} else if (phylink_autoneg_inband(mode)) {
 		/* 1000base-X or 2500base-X autoneg */
 		sgm_mode = SGMII_REMOTE_FAULT_DIS;
-- 
2.30.2

