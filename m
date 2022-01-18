Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C69D949177E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245489AbiARCmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51560 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344840AbiARCiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:38:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2652B612E1;
        Tue, 18 Jan 2022 02:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8903CC36AF4;
        Tue, 18 Jan 2022 02:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473498;
        bh=eFMl/MhttaEwrV7USY7/hPWY6uI4fhVEmffTevK80BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCG5TBaH9DCWekXqbmPAM8L2hJdVoF8eBkVxWXxGRX5h6jb2QVOTSuI6Zl7IdHpWY
         XGf+djmiE+rOEg9vptQKaqqWZv1FbZhFiiHCRRNRD9ch4VQ0p9dtvHvZSrssC+2hHF
         gR/VFBBOylG6F6FLSLZPcxbnHxjeX/vcQZbo61q6aiy/WJxB0wZGaHqDXCQkVctQjM
         kio8nn53yYhelvKhtXgTQCHzh0N5FWL5+PwqnhemKDuorMH4JU9wk+m9kM7FVZkp0L
         6+LaigU8X95Yyyk4d10WKtE1RTkS3LwMgCDOsf325qWXiAAc3c4hOvss347Mp0Iunu
         Xn1aVG5HQR18g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 138/188] iwlwifi: fix leaks/bad data after failed firmware load
Date:   Mon, 17 Jan 2022 21:31:02 -0500
Message-Id: <20220118023152.1948105-138-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 94553f272d377..2206f66f69940 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -131,6 +131,9 @@ static void iwl_dealloc_ucode(struct iwl_drv *drv)
 
 	for (i = 0; i < IWL_UCODE_TYPE_MAX; i++)
 		iwl_free_fw_img(drv, drv->fw.img + i);
+
+	/* clear the data for the aborted load case */
+	memset(&drv->fw, 0, sizeof(drv->fw));
 }
 
 static int iwl_alloc_fw_desc(struct iwl_drv *drv, struct fw_desc *desc,
@@ -1333,6 +1336,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	int i;
 	bool load_module = false;
 	bool usniffer_images = false;
+	bool failure = true;
 
 	fw->ucode_capa.max_probe_length = IWL_DEFAULT_MAX_PROBE_LENGTH;
 	fw->ucode_capa.standard_phy_calibration_size =
@@ -1602,6 +1606,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 				op->name, err);
 #endif
 	}
+	failure = false;
 	goto free;
 
  try_again:
@@ -1617,6 +1622,9 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
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

