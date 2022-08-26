Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCDF5A2144
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244359AbiHZG4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244289AbiHZG4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:56:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16DAAD21E4;
        Thu, 25 Aug 2022 23:56:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id w88-20020a17090a6be100b001fbb0f0b013so680234pjj.5;
        Thu, 25 Aug 2022 23:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=KjTu3WZ7BYoc24FpxzDgvGSEPvPIK+/85ugDuX1XsWs=;
        b=VzB0bl+iEINcPc60YjOjrVq/MGe3EZIOGIfRN3cOt1lPmr7/2CWr2btJPt7fsoTg0H
         V3AUk91Yq4C68L+7jvOaSn0ixJnibvNsheUDBe21w3J9B7yzFpryF5gKe+dnMg7Cnq8U
         As4NbkjBOZDd0qVheRpnG20stTMyRlEddZUII8bfxiZMoK0tKVhFqVlDf9ou+rpvZbJV
         KlRWHKBmKhR6gVCxhZC9Gwhec9gradkDgrsxBkRtEW1U7N+qItgNvz9oHq/HUw++EAQA
         ATNNIRV0LfJv7Bu4iuOcko0KrfkTgdnnZlZXxrJ1hmATPqQTWCnKrZwjMR7vJPheapR7
         uG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=KjTu3WZ7BYoc24FpxzDgvGSEPvPIK+/85ugDuX1XsWs=;
        b=Qj9Xrr7zrXavdNn8CiimxTACeHBEuMvsw6yvIABsXK1Bglsp0jdZhas7nZa0b2d3GK
         wYoY1afo0kvlGR+4SR3q7TrZu0pH4DCJiRIPtV9MnMRA12wRviy49IZpUjlBIW57nRiz
         nbGqIG+FwFRReFZnyL1ATHI6CrL0ApbO7FWA6g+ZyKyCXjIbU6WetWsLqC2Uz2pJcdWj
         yvcevJW33LDkaii5cfxKyOcta5noK1w7ftDkEhtx/3V950zZAeXteibC3V34n96O1/qX
         7mwUW/ILHMIggGjujtA1vgDWfPJstuqkNUyme926Q2/s5vrraVaNWHf7baWdA2wN6viK
         mqsg==
X-Gm-Message-State: ACgBeo0E5lvZTh0p0JRGguvuF3b2K6MxgehCXVqkEcf3Yy2t3TCyDTyh
        nz+hYu/sVaqzciwsMGPchFkgeCz5TFCizg==
X-Google-Smtp-Source: AA6agR4FshwGd2RWaRUIY579oO0VCN85Bh8OlckOU9Qzl9fecrI2JBRzsZ77xGYhMRL2cKU/LOKMdw==
X-Received: by 2002:a17:90b:3b50:b0:1fb:632c:f978 with SMTP id ot16-20020a17090b3b5000b001fb632cf978mr2938700pjb.231.1661496997429;
        Thu, 25 Aug 2022 23:56:37 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id mi6-20020a17090b4b4600b001f52fa1704csm11620478pjb.3.2022.08.25.23.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 23:56:36 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH net-next v2] drivers/net/ethernet: check return value of e1e_rphy()
Date:   Thu, 25 Aug 2022 23:56:27 -0700
Message-Id: <20220826065627.1615965-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e1e_rphy() could return error value, which needs to be checked and
reported for debugging and diagnose.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index fd07c3679bb1..060b263348ce 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2697,9 +2697,14 @@ static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
 void e1000_power_up_phy_copper(struct e1000_hw *hw)
 {
 	u16 mii_reg = 0;
+	int ret;
 
 	/* The PHY will retain its settings across a power down/up cycle */
-	e1e_rphy(hw, MII_BMCR, &mii_reg);
+	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
+	if (ret) {
+		e_dbg("Error reading PHY register\n");
+		return;
+	}
 	mii_reg &= ~BMCR_PDOWN;
 	e1e_wphy(hw, MII_BMCR, mii_reg);
 }
@@ -2715,9 +2720,14 @@ void e1000_power_up_phy_copper(struct e1000_hw *hw)
 void e1000_power_down_phy_copper(struct e1000_hw *hw)
 {
 	u16 mii_reg = 0;
+	int ret;
 
 	/* The PHY will retain its settings across a power down/up cycle */
-	e1e_rphy(hw, MII_BMCR, &mii_reg);
+	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
+	if (ret) {
+		e_dbg("Error reading PHY register\n");
+		return;
+	}
 	mii_reg |= BMCR_PDOWN;
 	e1e_wphy(hw, MII_BMCR, mii_reg);
 	usleep_range(1000, 2000);
@@ -3037,7 +3047,11 @@ s32 e1000_link_stall_workaround_hv(struct e1000_hw *hw)
 		return 0;
 
 	/* Do not apply workaround if in PHY loopback bit 14 set */
-	e1e_rphy(hw, MII_BMCR, &data);
+	ret_val = e1e_rphy(hw, MII_BMCR, &data);
+	if (ret_val) {
+		e_dbg("Error reading PHY register\n");
+		return ret_val;
+	}
 	if (data & BMCR_LOOPBACK)
 		return 0;
 
-- 
2.25.1

