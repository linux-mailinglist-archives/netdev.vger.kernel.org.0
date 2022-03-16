Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDDB4DB7FB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357712AbiCPShl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239413AbiCPShi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:37:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA125F4CB;
        Wed, 16 Mar 2022 11:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC8BD618D3;
        Wed, 16 Mar 2022 18:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA04BC340EC;
        Wed, 16 Mar 2022 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647455783;
        bh=5kfVOxiNs9Lfjb/f3WQydUgKBkkYnRcyc4hj7F3zqys=;
        h=From:To:Cc:Subject:Date:From;
        b=RUJz0qKmBWGiMdYQNI3NyveSUlZnvQbnK9DfdZE1KuSKzA0cuE8OOCJNiiysq8G5F
         Ph71rzGyePcrhyHuHT77TMAk6oaRa/yyskiEXsvfK2cumn9zpTfJVVgE4xqJVGh8gk
         iBNnVYYxl5elULDvrXuLkXQ8Z4FEonsPFjb9hrsZv7LccPrmqBw2srG1NQK7PiLW4I
         TKkvxGGjwZWzF1c6oV0AXmLACydvQ/P7nL8X4phF0KdhrGAyljxLFa/ss8JcTQHO6V
         xzOW7CjDcmIM1hlWVlBM4byVVHJo4mgG5QnM+kL+NAxFrPYwicuXU8oBoffGmdzsKJ
         /HMU5JA5ZbzmA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: mei: fix building iwlmei
Date:   Wed, 16 Mar 2022 19:36:03 +0100
Message-Id: <20220316183617.1470631-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Building iwlmei without CONFIG_CFG80211 causes a link-time warning:

ld.lld: error: undefined symbol: ieee80211_hdrlen
>>> referenced by net.c
>>>               net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme) in archive drivers/built-in.a

Add an explicit dependency to avoid this. In theory it should not
be needed here, but it also seems pointless to allow IWLMEI
for configurations without CFG80211.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

I see this warning on 5.17-rc8, but did not test it on linux-next,
which may already have a fix.

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
2.29.2

