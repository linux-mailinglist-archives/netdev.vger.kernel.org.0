Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BC34919DC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352046AbiARC4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55164 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348831AbiARCqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:46:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CA1FB81250;
        Tue, 18 Jan 2022 02:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CA6C36AE3;
        Tue, 18 Jan 2022 02:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473974;
        bh=TcxqqP3k9ttYzsoT+++OolzMeJ1YguBUZ1x8o29WZxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DxwDgB1P6HDtpcUUitfZCPmSWWYxQwHs40EA6Qh5I8EsExNtYQXUceXaboVukleXu
         /9tMNmxQk7Nwl/R22dbgucanPByXldEe4KwTh4dx/7qxTt1KIaQb5i+X2y/Nb1bLJo
         DhTfth4K7dxy2pMOcgRNrAJjZysST2yAuUUhdF6K/Oety4W9sklqxb16WurlrbWJ9Z
         P5bQz9LEcTwI7hxo+3NB6ekLEOhHV0Z0n+5ZluktFwRMi7PdcGSS2rVo4gfqYBBt90
         iKqJNMDSTxAy4kxWiVY9kYTUd/o/rmvQY3b/8NNxUEJb9GWUFq9yK7MP2blcn/zVNM
         mXqToF4VM4vQQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 49/73] iwlwifi: fix leaks/bad data after failed firmware load
Date:   Mon, 17 Jan 2022 21:44:08 -0500
Message-Id: <20220118024432.1952028-49-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]

If firmware load fails after having loaded some parts of the
firmware, e.g. the IML image, then this would leak. For the
host command list we'd end up running into a WARN on the next
attempt to load another firmware image.

Fix this by calling iwl_dealloc_ucode() on failures, and make
that also clear the data so we start fresh on the next round.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e68366f248fe3..c1a2fb154fe91 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -183,6 +183,9 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
+
+	/* clear the data for the aborted load case */
+	memset(&drv->fw, 0, sizeof(drv->fw));
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -1338,6 +1341,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 	bool usniffer_images = false;
+	bool failure = true;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1604,6 +1608,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+	failure = false;
 	goto free;
 
  try_again:
@@ -1619,6 +1624,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
  free:
+	if (failure)
+		iwl_dealloc_ucode(drv);
+
 	if (pieces) {
 		for (i = 0; i < ARRAY_SIZE(pieces->img); i++)
 			kfree(pieces->img[i].sec);
-- 
2.34.1

