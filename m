Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95EDD2F31A4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732422AbhALNZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:25:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:55856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbhALNZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 08:25:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 06C77ACB0;
        Tue, 12 Jan 2021 13:24:56 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 2/2] iwlwifi: dbg: Mark ucode tlv data as const
Date:   Tue, 12 Jan 2021 14:24:49 +0100
Message-Id: <20210112132449.22243-3-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112132449.22243-1-tiwai@suse.de>
References: <20210112132449.22243-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ucode TLV data may be read-only and should be treated as const
pointers, but currently a few code forcibly cast to the writable
pointer unnecessarily.  This gave developers a wrong impression as if
it can be modified, resulting in crashing regressions already a couple
of times.

This patch adds the const prefix to those cast pointers, so that such
attempt can be caught more easily in future.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 50 ++++++++++---------
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.h  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  2 +-
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index a80a35a7740f..12c49fe8608a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -61,7 +61,8 @@ dbg_ver_table[IWL_DBG_TLV_TYPE_NUM] = {
 	[IWL_DBG_TLV_TYPE_TRIGGER]	= {.min_ver = 1, .max_ver = 1,},
 };
 
-static int iwl_dbg_tlv_add(struct iwl_ucode_tlv *tlv, struct list_head *list)
+static int iwl_dbg_tlv_add(const struct iwl_ucode_tlv *tlv,
+			   struct list_head *list)
 {
 	u32 len = le32_to_cpu(tlv->length);
 	struct iwl_dbg_tlv_node *node;
@@ -76,9 +77,9 @@ static int iwl_dbg_tlv_add(struct iwl_ucode_tlv *tlv, struct list_head *list)
 	return 0;
 }
 
-static bool iwl_dbg_tlv_ver_support(struct iwl_ucode_tlv *tlv)
+static bool iwl_dbg_tlv_ver_support(const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_header *hdr = (void *)&tlv->data[0];
+	const struct iwl_fw_ini_header *hdr = (const void *)&tlv->data[0];
 	u32 type = le32_to_cpu(tlv->type);
 	u32 tlv_idx = type - IWL_UCODE_TLV_DEBUG_BASE;
 	u32 ver = le32_to_cpu(hdr->version);
@@ -91,9 +92,9 @@ static bool iwl_dbg_tlv_ver_support(struct iwl_ucode_tlv *tlv)
 }
 
 static int iwl_dbg_tlv_alloc_debug_info(struct iwl_trans *trans,
-					struct iwl_ucode_tlv *tlv)
+					const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_debug_info_tlv *debug_info = (void *)tlv->data;
+	const struct iwl_fw_ini_debug_info_tlv *debug_info = (const void *)tlv->data;
 
 	if (le32_to_cpu(tlv->length) != sizeof(*debug_info))
 		return -EINVAL;
@@ -105,9 +106,9 @@ static int iwl_dbg_tlv_alloc_debug_info(struct iwl_trans *trans,
 }
 
 static int iwl_dbg_tlv_alloc_buf_alloc(struct iwl_trans *trans,
-				       struct iwl_ucode_tlv *tlv)
+				       const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_allocation_tlv *alloc = (void *)tlv->data;
+	const struct iwl_fw_ini_allocation_tlv *alloc = (const void *)tlv->data;
 	u32 buf_location;
 	u32 alloc_id;
 
@@ -145,9 +146,9 @@ static int iwl_dbg_tlv_alloc_buf_alloc(struct iwl_trans *trans,
 }
 
 static int iwl_dbg_tlv_alloc_hcmd(struct iwl_trans *trans,
-				  struct iwl_ucode_tlv *tlv)
+				  const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_hcmd_tlv *hcmd = (void *)tlv->data;
+	const struct iwl_fw_ini_hcmd_tlv *hcmd = (const void *)tlv->data;
 	u32 tp = le32_to_cpu(hcmd->time_point);
 
 	if (le32_to_cpu(tlv->length) <= sizeof(*hcmd))
@@ -169,9 +170,9 @@ static int iwl_dbg_tlv_alloc_hcmd(struct iwl_trans *trans,
 }
 
 static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
-				    struct iwl_ucode_tlv *tlv)
+				    const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_region_tlv *reg = (void *)tlv->data;
+	const struct iwl_fw_ini_region_tlv *reg = (const void *)tlv->data;
 	struct iwl_ucode_tlv **active_reg;
 	u32 id = le32_to_cpu(reg->id);
 	u32 type = le32_to_cpu(reg->type);
@@ -214,9 +215,10 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 }
 
 static int iwl_dbg_tlv_alloc_trigger(struct iwl_trans *trans,
-				     struct iwl_ucode_tlv *tlv)
+				     const struct iwl_ucode_tlv *tlv)
 {
-	struct iwl_fw_ini_trigger_tlv *trig = (void *)tlv->data;
+	const struct iwl_fw_ini_trigger_tlv *trig = (const void *)tlv->data;
+	struct iwl_fw_ini_trigger_tlv *dup_trig;
 	u32 tp = le32_to_cpu(trig->time_point);
 	struct iwl_ucode_tlv *dup = NULL;
 	int ret;
@@ -237,8 +239,8 @@ static int iwl_dbg_tlv_alloc_trigger(struct iwl_trans *trans,
 				GFP_KERNEL);
 		if (!dup)
 			return -ENOMEM;
-		trig = (void *)dup->data;
-		trig->occurrences = cpu_to_le32(-1);
+		dup_trig = (void *)dup->data;
+		dup_trig->occurrences = cpu_to_le32(-1);
 		tlv = dup;
 	}
 
@@ -249,7 +251,7 @@ static int iwl_dbg_tlv_alloc_trigger(struct iwl_trans *trans,
 }
 
 static int (*dbg_tlv_alloc[])(struct iwl_trans *trans,
-			      struct iwl_ucode_tlv *tlv) = {
+			      const struct iwl_ucode_tlv *tlv) = {
 	[IWL_DBG_TLV_TYPE_DEBUG_INFO]	= iwl_dbg_tlv_alloc_debug_info,
 	[IWL_DBG_TLV_TYPE_BUF_ALLOC]	= iwl_dbg_tlv_alloc_buf_alloc,
 	[IWL_DBG_TLV_TYPE_HCMD]		= iwl_dbg_tlv_alloc_hcmd,
@@ -257,10 +259,10 @@ static int (*dbg_tlv_alloc[])(struct iwl_trans *trans,
 	[IWL_DBG_TLV_TYPE_TRIGGER]	= iwl_dbg_tlv_alloc_trigger,
 };
 
-void iwl_dbg_tlv_alloc(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
+void iwl_dbg_tlv_alloc(struct iwl_trans *trans, const struct iwl_ucode_tlv *tlv,
 		       bool ext)
 {
-	struct iwl_fw_ini_header *hdr = (void *)&tlv->data[0];
+	const struct iwl_fw_ini_header *hdr = (const void *)&tlv->data[0];
 	u32 type = le32_to_cpu(tlv->type);
 	u32 tlv_idx = type - IWL_UCODE_TLV_DEBUG_BASE;
 	u32 domain = le32_to_cpu(hdr->domain);
@@ -396,7 +398,7 @@ void iwl_dbg_tlv_free(struct iwl_trans *trans)
 static int iwl_dbg_tlv_parse_bin(struct iwl_trans *trans, const u8 *data,
 				 size_t len)
 {
-	struct iwl_ucode_tlv *tlv;
+	const struct iwl_ucode_tlv *tlv;
 	u32 tlv_len;
 
 	while (len >= sizeof(*tlv)) {
@@ -737,12 +739,12 @@ static void iwl_dbg_tlv_set_periodic_trigs(struct iwl_fw_runtime *fwrt)
 	}
 }
 
-static bool is_trig_data_contained(struct iwl_ucode_tlv *new,
-				   struct iwl_ucode_tlv *old)
+static bool is_trig_data_contained(const struct iwl_ucode_tlv *new,
+				   const struct iwl_ucode_tlv *old)
 {
-	struct iwl_fw_ini_trigger_tlv *new_trig = (void *)new->data;
-	struct iwl_fw_ini_trigger_tlv *old_trig = (void *)old->data;
-	__le32 *new_data = new_trig->data, *old_data = old_trig->data;
+	const struct iwl_fw_ini_trigger_tlv *new_trig = (const void *)new->data;
+	const struct iwl_fw_ini_trigger_tlv *old_trig = (const void *)old->data;
+	const __le32 *new_data = new_trig->data, *old_data = old_trig->data;
 	u32 new_dwords_num = iwl_tlv_array_len(new, new_trig, data);
 	u32 old_dwords_num = iwl_tlv_array_len(old, old_trig, data);
 	int i, j;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
index 246823878281..e9f19ecbc4ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h
@@ -43,7 +43,7 @@ struct iwl_fw_runtime;
 
 void iwl_dbg_tlv_load_bin(struct device *dev, struct iwl_trans *trans);
 void iwl_dbg_tlv_free(struct iwl_trans *trans);
-void iwl_dbg_tlv_alloc(struct iwl_trans *trans, struct iwl_ucode_tlv *tlv,
+void iwl_dbg_tlv_alloc(struct iwl_trans *trans, const struct iwl_ucode_tlv *tlv,
 		       bool ext);
 void iwl_dbg_tlv_init(struct iwl_trans *trans);
 void iwl_dbg_tlv_time_point(struct iwl_fw_runtime *fwrt,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index d44bc61c34f5..5dcc490729b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -558,7 +558,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 				bool *usniffer_images)
 {
 	struct iwl_tlv_ucode_header *ucode = (void *)ucode_raw->data;
-	struct iwl_ucode_tlv *tlv;
+	const struct iwl_ucode_tlv *tlv;
 	size_t len = ucode_raw->size;
 	const u8 *data;
 	u32 tlv_len;
-- 
2.26.2

