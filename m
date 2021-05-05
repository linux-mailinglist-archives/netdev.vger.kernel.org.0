Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9AA37424E
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhEEQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235795AbhEEQpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 899626192D;
        Wed,  5 May 2021 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232543;
        bh=Va+wbLd0kC4M+H2jChIjeDgqnYd+JlYbiZPT6YgEt+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VubZJ3ybc3mHukTvI4AIV+XV+5SiLJwB0atBUymp3dqCD1MjO0hCJ0gXXTL55+vMl
         Bhi63+gTscgjNUUIczCDoN0CYWyhtgi3OM7V87bb/Q2EDVb8iQRV83OKweKqxDtIlk
         RkgBdzNmZwX1m0rG3pIpHHa8IWExqhHedpK4yuZei5ND3mXn+bekSo3DIZMChB/Klr
         H9XqWcPyMtOwuR22YHHb6CMDTo4EbgE4MITe9d87T9nq37wWyHeNzOpP6g1Awa/n68
         6J+DagWeLy+uHSZnaa4FvTqJhqhFjqcEQKUK8WXe7MQdQpktsRr7KZ/kdHJu2XmyAI
         30UZ6cD7GBMdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 062/104] iwlwifi: pcie: make cfg vs. trans_cfg more robust
Date:   Wed,  5 May 2021 12:33:31 -0400
Message-Id: <20210505163413.3461611-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 48a5494d6a4cb5812f0640d9515f1876ffc7a013 ]

If we (for example) have a trans_cfg entry in the PCI IDs table,
but then don't find a full cfg entry for it in the info table,
we fall through to the code that treats the PCI ID table entry
as a full cfg entry. This obviously causes crashes later, e.g.
when trying to build the firmware name string.

Avoid such crashes by using the low bit of the pointer as a tag
for trans_cfg entries (automatically using a macro that checks
the type when assigning) and then checking that before trying to
use the data as a full entry - if it's just a partial entry at
that point, fail.

Since we're adding some macro magic, also check that the type is
in fact either struct iwl_cfg_trans_params or struct iwl_cfg,
failing compilation ("initializer element is not constant") if
it isn't.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210330162204.6f69fe6e4128.I921d4ae20ef5276716baeeeda0b001cf25b9b968@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 35 +++++++++++++++----
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 018daa84ddd2..70752f0c67b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -17,10 +17,20 @@
 #include "iwl-prph.h"
 #include "internal.h"
 
+#define TRANS_CFG_MARKER BIT(0)
+#define _IS_A(cfg, _struct) __builtin_types_compatible_p(typeof(cfg),	\
+							 struct _struct)
+extern int _invalid_type;
+#define _TRANS_CFG_MARKER(cfg)						\
+	(__builtin_choose_expr(_IS_A(cfg, iwl_cfg_trans_params),	\
+			       TRANS_CFG_MARKER,			\
+	 __builtin_choose_expr(_IS_A(cfg, iwl_cfg), 0, _invalid_type)))
+#define _ASSIGN_CFG(cfg) (_TRANS_CFG_MARKER(cfg) + (kernel_ulong_t)&(cfg))
+
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
-	.driver_data = (kernel_ulong_t)&(cfg)
+	.driver_data = _ASSIGN_CFG(cfg)
 
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 static const struct pci_device_id iwl_hw_card_ids[] = {
@@ -988,19 +998,22 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 
 static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	const struct iwl_cfg_trans_params *trans =
-		(struct iwl_cfg_trans_params *)(ent->driver_data);
+	const struct iwl_cfg_trans_params *trans;
 	const struct iwl_cfg *cfg_7265d __maybe_unused = NULL;
 	struct iwl_trans *iwl_trans;
 	struct iwl_trans_pcie *trans_pcie;
 	int i, ret;
+	const struct iwl_cfg *cfg;
+
+	trans = (void *)(ent->driver_data & ~TRANS_CFG_MARKER);
+
 	/*
 	 * This is needed for backwards compatibility with the old
 	 * tables, so we don't need to change all the config structs
 	 * at the same time.  The cfg is used to compare with the old
 	 * full cfg structs.
 	 */
-	const struct iwl_cfg *cfg = (struct iwl_cfg *)(ent->driver_data);
+	cfg = (void *)(ent->driver_data & ~TRANS_CFG_MARKER);
 
 	/* make sure trans is the first element in iwl_cfg */
 	BUILD_BUG_ON(offsetof(struct iwl_cfg, trans));
@@ -1102,11 +1115,19 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 #endif
 	/*
-	 * If we didn't set the cfg yet, assume the trans is actually
-	 * a full cfg from the old tables.
+	 * If we didn't set the cfg yet, the PCI ID table entry should have
+	 * been a full config - if yes, use it, otherwise fail.
 	 */
-	if (!iwl_trans->cfg)
+	if (!iwl_trans->cfg) {
+		if (ent->driver_data & TRANS_CFG_MARKER) {
+			pr_err("No config found for PCI dev %04x/%04x, rev=0x%x, rfid=0x%x\n",
+			       pdev->device, pdev->subsystem_device,
+			       iwl_trans->hw_rev, iwl_trans->hw_rf_id);
+			ret = -EINVAL;
+			goto out_free_trans;
+		}
 		iwl_trans->cfg = cfg;
+	}
 
 	/* if we don't have a name yet, copy name from the old cfg */
 	if (!iwl_trans->name)
-- 
2.30.2

