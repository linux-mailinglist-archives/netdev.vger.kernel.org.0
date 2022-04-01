Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A98B4EF0B0
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347826AbiDAOgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348409AbiDAOeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:34:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CA2BC7;
        Fri,  1 Apr 2022 07:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E23F261C1A;
        Fri,  1 Apr 2022 14:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3B9C34111;
        Fri,  1 Apr 2022 14:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823551;
        bh=fp7jiniWyo2eC0F5ZPLfhtbsZIvtute4v9PstEC8ezg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mx3qMwlusCkBbNyipx5xOXvk/4iBNicQztlTLO52CU2ApIEYZdzMeElllc6/gRcvu
         Bmeb4nc4AXy64TWBSl8UwWk01ZORn2hXx6+Ez/myRpTmi9L2zHGV/bj1ejs7HxelEp
         KaOjpls3ACVptO8mx4RTR7hHEM7/knpasWy7KLObIgQAL/bc68XAIYsxnYJw5pRLVe
         Gc1Uar/vD9rU3+o6nDtgvsD27gG0mY1OPsUri8NhoVhvMB1TPe5DbaIemnz9QZW7IK
         IVLVY7HAof1USNL9SQgwukhXy8cYVeDx0crJgfJBBu/WwCH0+G4eE8RGrE+eYhixJU
         2tVXAex3TAICQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <Emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 140/149] iwlwifi: mei: fix building iwlmei
Date:   Fri,  1 Apr 2022 10:25:27 -0400
Message-Id: <20220401142536.1948161-140-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 066291bec0c55315e568ead501bebdefcb8453d2 ]

Building iwlmei without CONFIG_CFG80211 causes a link-time warning:

ld.lld: error: undefined symbol: ieee80211_hdrlen
>>> referenced by net.c
>>>               net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme) in archive drivers/built-in.a

Add an explicit dependency to avoid this. In theory it should not
be needed here, but it also seems pointless to allow IWLMEI
for configurations without CFG80211.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Emmanuel Grumbach <Emmanuel.grumbach@intel.com>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220316183617.1470631-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 85e704283755..a647a406b87b 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -139,6 +139,7 @@ config IWLMEI
 	tristate "Intel Management Engine communication over WLAN"
 	depends on INTEL_MEI
 	depends on PM
+	depends on CFG80211
 	help
 	  Enables the iwlmei kernel module.
 
-- 
2.34.1

