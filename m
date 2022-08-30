Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6191F5A5CB0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiH3HQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbiH3HQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:16:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479FC7331C;
        Tue, 30 Aug 2022 00:16:15 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y141so10496991pfb.7;
        Tue, 30 Aug 2022 00:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=oV//up81vPxxhX9sqIPOvRWHdXCHQPB4s33YAP3fJbQ=;
        b=DkURfYdM0njl6lwV7AsIMzsiUsHpKV2320LS9AfWmwUgP9+ND+tfDxVtlnwnJSiAgW
         fomwVRFWfwI0SQYZzKP1caVs9PjfiAsqzWR6vI0FQVbUbCmCsJARxwvmncNFGGz94vM7
         zLEx5rprQyOt8moZhD/5pWHI4OZ+phtrU8Wmw5M9o++y9R6XqI+EEEsc0RWDn+HvLWfZ
         J2YuGrQ/RYCstVGzcCQwBfPQfPgTuEdPsUGZ3VCjpHv3pJ0f3tGm4JQfzl1Yu2NRL2w8
         ViWSr8SbqDXBTnlHcBng2PBm3b1WVAEpaPHz83pIjpwdPZT0RKl4lXT7Mlzg3RswO80y
         +gSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=oV//up81vPxxhX9sqIPOvRWHdXCHQPB4s33YAP3fJbQ=;
        b=G2DVjE3qZpQekDR91EmMjj2Fdyip/yAE/VbUq/w0xU6wjOB8LEKwQuy+6THMZf0vTU
         8upNICSpXF56GIRt7GKF2XvgfpZ9Si1mn0dR75fJAPsSY8uwWZqdeO4cmGx9RLHEwBPV
         OxzEPNA4UXK4TpZGQJwEADwwbihgx3t2Kj7sGUkGXKCKWRi4rcJqXrZiFw+bJyTUySXO
         b8vjBrUyLgFJdtVOH69Hr4jzO2sCp5cGNpc/OtV116mLnWtpxHatvHNCqmRGuGkLbKDj
         e6rhcyA3Nua97bwRwcEvyCKXHxw9uHK3Tq6TPMzFPD0/34kcdHJkZDbLJ2QQw0Ny51vq
         9/Tg==
X-Gm-Message-State: ACgBeo3maRfDaf553KqvRMbafVVYhzOyemCa2RX8PeTXk08YGiVjuwIo
        JSHJDzxXgWj+ZfPzJ4dJOBXsPgAIQqZk4g==
X-Google-Smtp-Source: AA6agR5w1Kz8qTSPfL/3YelPPCFHbLYuEOQxreX4CK4hqNgRCjE21rEvtTBF1fT7RVEP1uEJforG5g==
X-Received: by 2002:a63:1223:0:b0:42c:11b:91d8 with SMTP id h35-20020a631223000000b0042c011b91d8mr8097812pgl.97.1661843774581;
        Tue, 30 Aug 2022 00:16:14 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id g2-20020a170902d1c200b0017300ec80b0sm8663910plb.308.2022.08.30.00.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 00:16:14 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v3] drivers/net/ethernet/e1000e: check return value of e1e_rphy()
Date:   Tue, 30 Aug 2022 00:15:49 -0700
Message-Id: <20220830071549.2137413-1-floridsleeves@gmail.com>
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

e1e_rphy() could return error value when reading PHY register, which
needs to be checked.

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

