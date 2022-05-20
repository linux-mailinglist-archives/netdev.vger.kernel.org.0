Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97F252F3E9
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353298AbiETTne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345377AbiETTn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C447197F72;
        Fri, 20 May 2022 12:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2285061BCB;
        Fri, 20 May 2022 19:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46502C3411B;
        Fri, 20 May 2022 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075805;
        bh=zGEKpWgxn6+HzxRExsmr65/JbhM8cdKYs1r7XpE7LVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAEizluf/Lvw7UjOI6blqS8JaisSYAFnkJU9OakFjV3yMwJnswPbFoC5fPbGBBBLB
         YBtoSA9zXWVGcF7jxBeV1opoyh+LV5Msiu1sddlEQ6RQeWAzjJuduKJZmwYlxeA+Lh
         cKu7h72tFdAYZ+qSrjNCSunPrq0NL4Iid95/mwxCUO37IfOGYH241xqakmIYiLzkDB
         3yuo2LsCDQQ4gyTWzbSax3f2O2CYEo0oJMDeZf02+v5zZmaLHmrOO7Gs/clI7kgphj
         7lp2QMwvirvdUXaxTCNuSzGci0oacq0N8QLKvWL2IVu9wTBtoTO8UgKl2RTQQWNjHG
         CxmOMFnRXr12Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, pkshih@realtek.com,
        keescook@chromium.org, colin.king@intel.com
Subject: [PATCH net-next 3/8] wifi: rtlwifi: remove always-true condition pointed out by GCC 12
Date:   Fri, 20 May 2022 12:43:15 -0700
Message-Id: <20220520194320.2356236-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .value is a two-dim array, not a pointer.

struct iqk_matrix_regs {
	bool iqk_done;
        long value[1][IQK_MATRIX_REG_NUM];
};

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pkshih@realtek.com
CC: kvalo@kernel.org
CC: keescook@chromium.org
CC: colin.king@intel.com
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 51fe51bb0504..15e6a6aded31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -2386,10 +2386,7 @@ void rtl92d_phy_reload_iqk_setting(struct ieee80211_hw *hw, u8 channel)
 			rtl_dbg(rtlpriv, COMP_SCAN, DBG_LOUD,
 				"Just Read IQK Matrix reg for channel:%d....\n",
 				channel);
-			if ((rtlphy->iqk_matrix[indexforchannel].
-			     value[0] != NULL)
-				/*&&(regea4 != 0) */)
-				_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
+			_rtl92d_phy_patha_fill_iqk_matrix(hw, true,
 					rtlphy->iqk_matrix[
 					indexforchannel].value,	0,
 					(rtlphy->iqk_matrix[
-- 
2.34.3

