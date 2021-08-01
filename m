Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685053DCA74
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 09:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhHAHCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 03:02:09 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35518
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhHAHCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 03:02:07 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C64A03F043;
        Sun,  1 Aug 2021 07:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627801318;
        bh=+HpTVz5U1M1CbazRL6I2mcQm73rzee+6pr/cjaG2uhM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=PVUNmQekRl8uvj2Rrj3vAWQ8Lo/c7T6jnHhSFDeMYu+ppeb5j03G4TjqWghZTxlKg
         liueEj4kSEL0PaYSrJBAd+5KAqpDEKX18ILzJAo9Mv0AwrWbsbbBHtW7BIK8igSOSO
         RyDtvoTEnqVWA+nIAPqx3ORDWRI9n4RkVM5KDMg+GwvckMibmFtrGH27LyO4l107MC
         5e6mRVZxP6pX8+TBjif9KN0O0aItIQ05QbHL/pwJJS+g+V95IsP0VnbOcIK+VUhlT4
         oU9xF0TzpmwGDFCelu5CaV3t2s6Teyr9txRrUf99SV/xgG+dfHjvEdp+jZWxRK0j3f
         P5ISisFVBjwLA==
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: mscc: make some arrays static const, makes object smaller
Date:   Sun,  1 Aug 2021 08:01:55 +0100
Message-Id: <20210801070155.139057-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays on the stack but instead them static const.
Makes the object code smaller by 280 bytes.

Before:
   text    data     bss     dec     hex filename
  24142    4368     192   28702    701e ./drivers/net/phy/mscc/mscc_ptp.o

After:
   text    data     bss     dec     hex filename
  23830    4400     192   28422    6f06 ./drivers/net/phy/mscc/mscc_ptp.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/mscc/mscc_ptp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index 924ed5b034a4..edb951695b13 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -506,7 +506,7 @@ static int vsc85xx_ptp_cmp_init(struct phy_device *phydev, enum ts_blk blk)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
 	bool base = phydev->mdio.addr == vsc8531->ts_base_addr;
-	u8 msgs[] = {
+	static const u8 msgs[] = {
 		PTP_MSGTYPE_SYNC,
 		PTP_MSGTYPE_DELAY_REQ
 	};
@@ -847,7 +847,7 @@ static int vsc85xx_ts_ptp_action_flow(struct phy_device *phydev, enum ts_blk blk
 static int vsc85xx_ptp_conf(struct phy_device *phydev, enum ts_blk blk,
 			    bool one_step, bool enable)
 {
-	u8 msgs[] = {
+	static const u8 msgs[] = {
 		PTP_MSGTYPE_SYNC,
 		PTP_MSGTYPE_DELAY_REQ
 	};
@@ -1268,8 +1268,8 @@ static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
 static int __vsc8584_init_ptp(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
-	u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
-	u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
+	static const u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
+	static const u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
 	u32 val;
 
 	if (!vsc8584_is_1588_input_clk_configured(phydev)) {
-- 
2.31.1

