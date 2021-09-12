Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BCB407D1E
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhILMGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 08:06:09 -0400
Received: from mx3.wp.pl ([212.77.101.10]:44037 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229635AbhILMGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Sep 2021 08:06:09 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 08:06:08 EDT
Received: (wp-smtpd smtp.wp.pl 19140 invoked from network); 12 Sep 2021 13:58:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631447893; bh=7F7yiuXb4Mfw396VqkwQlPLO+weG31WPT7mJCgXFBng=;
          h=From:To:Cc:Subject;
          b=JEEKwu8XOBXu7p8MiwieqOVrX2wIST4PXjewBwCv10j9FeeIz4zM+mVuGHS8T1Zyb
           ElmKi9Rg2rGmXS5woyGbCghZ65+2EuXr1CFz4++SbDolAUA7xe64pbamdQkE/n2Oku
           nHDDJIMDRVGhbtT/3HET2G84hNwllwRts5cH87gk=
Received: from ip-5-172-255-225.free.aero2.net.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[5.172.255.225])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 12 Sep 2021 13:58:13 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, olek2@wp.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [net,v2] net: dsa: lantiq_gswip: Add 200ms assert delay
Date:   Sun, 12 Sep 2021 13:58:07 +0200
Message-Id: <20210912115807.3903-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 77c5ffc809657b33a309166f532d7d64
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [UYNE]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The delay is especially needed by the xRX300 and xRX330 SoCs. Without
this patch, some phys are sometimes not properly detected.

The patch was tested on BT Home Hub 5A and D-Link DWR-966.

Fixes: a09d042b0862 ("net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 64d6dfa83122..267324889dd6 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1885,6 +1885,12 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
 
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

