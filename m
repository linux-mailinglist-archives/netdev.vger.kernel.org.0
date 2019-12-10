Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FFD1197F9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbfLJVfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:35:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfLJVfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:35:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CA0C24653;
        Tue, 10 Dec 2019 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013741;
        bh=BqdLStzEJB6Zi2WSurBDBiPlZMz52nDuIolEUyiSz5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGnvnwJXz1Ao8vyTDxy8saUIS5R/vvfmsjxhDqxJxjJjR26d8i0PIOIydXGyzpqP8
         PipS6bogimWPC9L+XKejK/oDAzSJdXEswnJpOpBXRwK6KoUxAcrmp4qpBePe0SEEX1
         sd0H4WkFXsKdrVDpF9rYU9StnYzFsYn+aGThCXs4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 164/177] iwlwifi: check kasprintf() return value
Date:   Tue, 10 Dec 2019 16:32:08 -0500
Message-Id: <20191210213221.11921-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5974fbb5e10b018fdbe3c3b81cb4cc54e1105ab9 ]

kasprintf() can fail, we should check the return value.

Fixes: 5ed540aecc2a ("iwlwifi: use mac80211 throughput trigger")
Fixes: 8ca151b568b6 ("iwlwifi: add the MVM driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/led.c | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/led.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/led.c b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
index 1bbd17ada9747..20e16c4239901 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/led.c
@@ -185,6 +185,9 @@ void iwl_leds_init(struct iwl_priv *priv)
 
 	priv->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(priv->hw->wiphy));
+	if (!priv->led.name)
+		return;
+
 	priv->led.brightness_set = iwl_led_brightness_set;
 	priv->led.blink_set = iwl_led_blink_set;
 	priv->led.max_brightness = 1;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/led.c b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
index b27269504a622..072f80c90ce4a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/led.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/led.c
@@ -131,6 +131,9 @@ int iwl_mvm_leds_init(struct iwl_mvm *mvm)
 
 	mvm->led.name = kasprintf(GFP_KERNEL, "%s-led",
 				   wiphy_name(mvm->hw->wiphy));
+	if (!mvm->led.name)
+		return -ENOMEM;
+
 	mvm->led.brightness_set = iwl_led_brightness_set;
 	mvm->led.max_brightness = 1;
 
-- 
2.20.1

