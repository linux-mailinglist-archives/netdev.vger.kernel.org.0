Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA8D491CC9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbiARDSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353413AbiARDIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:08:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D3BC061574;
        Mon, 17 Jan 2022 18:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05112B81250;
        Tue, 18 Jan 2022 02:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C22C36AF4;
        Tue, 18 Jan 2022 02:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474244;
        bh=Ev5tX5NfFR/j1wYm53oMVJTmjKW5T16TtnSYsQF+7uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dy4TzDh7Ti/9DqlqdwRfOnwSQdFvBm2Dh7Aun4iVvt2UvDPixs14iObKTB5Q1myLU
         a5wrWYjrcTeO3RNfaiQ/F5Uv1XVvTB6v7q0/US+jWuCKD/3Y0eWyhBeaYfLcfdMuRt
         ii0Vs9KfCfct7wslo/fWkW0d/kNxbTRJw1IYLiJo33I6RLvQXmeg8DuPOu7266xLNr
         PhHFYIT6w6A//PClvUTodzu6iabfy3xZ9lUnUbmvxxfiz9/TNDkM7ipvYRTDoNED2Q
         UjAIJ2cQhY/OvoE8KTJ/jPdcl1JdU1k7XD5kgAuegfNYiYFk720fMON9L4rLFp1+Bg
         ISjDENoGufniw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 39/56] iwlwifi: fix leaks/bad data after failed firmware load
Date:   Mon, 17 Jan 2022 21:48:51 -0500
Message-Id: <20220118024908.1953673-39-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
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
index 6c10b8c4ddbe5..95101f66a886e 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -182,6 +182,9 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
+
+	/* clear the data for the aborted load case */
+	memset(&drv->fw, 0, sizeof(drv->fw));
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -1271,6 +1274,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 	bool usniffer_images = false;
+	bool failure = true;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1499,6 +1503,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+	failure = false;
 	goto free;
 
  try_again:
@@ -1514,6 +1519,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
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

