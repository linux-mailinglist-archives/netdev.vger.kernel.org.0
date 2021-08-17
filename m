Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41DF3EF2BB
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhHQTkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:40:32 -0400
Received: from mx4.wp.pl ([212.77.101.11]:36167 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230424AbhHQTka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 15:40:30 -0400
Received: (wp-smtpd smtp.wp.pl 5063 invoked from network); 17 Aug 2021 21:33:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1629228794; bh=99YXkVPU4cave1Ach6qPRuVfMrqj6edfILB3QOdCh6I=;
          h=From:To:Cc:Subject;
          b=mZKgSkhYx4wjBI3BV/yImHPtiSM2sWjFkhvuZm7L4uNvqiuDCyFKNNnQ4ba/W0Bfk
           K/gmSMrk+CGlpMJukgdNU/mqcNs1EhHcobXiIcgIpGMPq0R9NTYHHIg8HYzGkH/nGB
           vxrGNtti3mdkqOMo7p+fG4WeMf3ikOs2qIqH5PkM=
Received: from ip-5-172-255-149.free.aero2.net.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[5.172.255.149])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 17 Aug 2021 21:33:14 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, olek2@wp.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] net: dsa: lantiq_gswip: Add 200ms assert delay
Date:   Tue, 17 Aug 2021 21:32:07 +0200
Message-Id: <20210817193207.1038598-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 1588ed9fddcbfbe21994916a11f143bc
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [AfMU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The delay is especially needed by the xRX300 and xRX330 SoCs. Without
this patch, some phys are sometimes not properly detected.

Fixes: a09d042b086202735c4ed64 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: Aleksander Jan Bajkowski <olek2@wp.pl> # tested on DWR966, HH5A
---
 drivers/net/dsa/lantiq_gswip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e78026ef6d8c..9eaf013b82a3 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1884,6 +1884,12 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
 
 	reset_control_assert(gphy_fw->reset);
 
+	/* The vendor BSP uses a 200ms delay after asserting the reset line.
+	 * Without this some users are observing that the PHY is not coming up
+	 * on the MDIO bus.
+	 */
+	msleep(200);
+
 	ret = request_firmware(&fw, gphy_fw->fw_name, dev);
 	if (ret) {
 		dev_err(dev, "failed to load firmware: %s, error: %i\n",
-- 
2.30.2

