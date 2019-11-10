Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54594F65AF
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbfKJDIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:08:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727642AbfKJCoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CFFC215EA;
        Sun, 10 Nov 2019 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353894;
        bh=1NofNetifklNsULoKa8iBoNhHM8w7x2djmZ0FjMFPW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=weVQxyEL4SXere2AdwwwRbyiZwU4Z0pHu0/rGkARLerrAYSBXWijpCbcM28roBx8F
         E4vXazI29gYtkFHYzQnthnUF6MoPMDfsN/BdPMkNuWVPttLHtHU9e9tkv+L0L3h8Lu
         VNoGRq+6QokVvL1Qdk34iGPa6C9gB7u83UQk7GRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 164/191] iwlwifi: pcie: gen2: build A-MSDU only for GSO
Date:   Sat,  9 Nov 2019 21:39:46 -0500
Message-Id: <20191110024013.29782-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 53f474e6a8d74d5dc0c3a015d889471f9a157685 ]

If the incoming frame should be an A-MSDU, it may already be one,
for example in the case of NAN multicast being encapsulated in an
A-MSDU. Thus, use the GSO algorithm to build A-MSDU only if the
skb actually contains GSO data.

Fixes: 6ffe5de35b05 ("iwlwifi: pcie: add AMSDU to gen2")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b99f33ff91230..61ffa1d1a00d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -526,7 +526,12 @@ struct iwl_tfh_tfd *iwl_pcie_gen2_build_tfd(struct iwl_trans *trans,
 
 	hdr_len = ieee80211_hdrlen(hdr->frame_control);
 
-	if (amsdu)
+	/*
+	 * Only build A-MSDUs here if doing so by GSO, otherwise it may be
+	 * an A-MSDU for other reasons, e.g. NAN or an A-MSDU having been
+	 * built in the higher layers already.
+	 */
+	if (amsdu && skb_shinfo(skb)->gso_size)
 		return iwl_pcie_gen2_build_tx_amsdu(trans, txq, dev_cmd, skb,
 						    out_meta, hdr_len, len);
 
-- 
2.20.1

