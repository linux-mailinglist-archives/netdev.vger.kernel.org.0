Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3655789B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfF0Abd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbfF0Abc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:32 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27472083B;
        Thu, 27 Jun 2019 00:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595491;
        bh=A/CiTEaKaFg9geB0AFMGKZY8viea7aMND4JaS85g9tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYMKFgaeoUKfBFaYLk5vkZOfatTqcDLTRsmtsXFQ+u4cdga0udz7dPQEXkq23k1NE
         s2groKKIAmwLuePEYKuNQ+64L3VLLDd/Jc5RYQdpZj7d1dibIFeKkTgxbUbNLr+ju6
         phUrcwK4OXbnRvuNUTPKtFs3O9J5OU0/Dt5j6vz4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 23/95] mwifiex: Abort at too short BSS descriptor element
Date:   Wed, 26 Jun 2019 20:29:08 -0400
Message-Id: <20190627003021.19867-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 685c9b7750bfacd6fc1db50d86579980593b7869 ]

Currently mwifiex_update_bss_desc_with_ie() implicitly assumes that
the source descriptor entries contain the enough size for each type
and performs copying without checking the source size.  This may lead
to read over boundary.

Fix this by putting the source size check in appropriate places.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 64ab6fe78c0d..c269a0de9413 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1269,6 +1269,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_FH_PARAMS:
+			if (element_len + 2 < sizeof(*fh_param_set))
+				return -EINVAL;
 			fh_param_set =
 				(struct ieee_types_fh_param_set *) current_ptr;
 			memcpy(&bss_entry->phy_param_set.fh_param_set,
@@ -1277,6 +1279,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_DS_PARAMS:
+			if (element_len + 2 < sizeof(*ds_param_set))
+				return -EINVAL;
 			ds_param_set =
 				(struct ieee_types_ds_param_set *) current_ptr;
 
@@ -1288,6 +1292,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_CF_PARAMS:
+			if (element_len + 2 < sizeof(*cf_param_set))
+				return -EINVAL;
 			cf_param_set =
 				(struct ieee_types_cf_param_set *) current_ptr;
 			memcpy(&bss_entry->ss_param_set.cf_param_set,
@@ -1296,6 +1302,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_IBSS_PARAMS:
+			if (element_len + 2 < sizeof(*ibss_param_set))
+				return -EINVAL;
 			ibss_param_set =
 				(struct ieee_types_ibss_param_set *)
 				current_ptr;
@@ -1305,10 +1313,14 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_ERP_INFO:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->erp_flags = *(current_ptr + 2);
 			break;
 
 		case WLAN_EID_PWR_CONSTRAINT:
+			if (!element_len)
+				return -EINVAL;
 			bss_entry->local_constraint = *(current_ptr + 2);
 			bss_entry->sensed_11h = true;
 			break;
@@ -1349,6 +1361,9 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_VENDOR_SPECIFIC:
+			if (element_len + 2 < sizeof(vendor_ie->vend_hdr))
+				return -EINVAL;
+
 			vendor_ie = (struct ieee_types_vendor_specific *)
 					current_ptr;
 
-- 
2.20.1

