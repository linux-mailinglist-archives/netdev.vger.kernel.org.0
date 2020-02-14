Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4172F15EF60
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgBNP77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389029AbgBNP76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:59:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146E42086A;
        Fri, 14 Feb 2020 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695998;
        bh=NDkes1bSJFRJFlu/prlmutb8xbcZE3iXWify3FKJuXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tvij987Vw5R3WkbdckdHg5raxzvAnB2Oo9SP88owu71XveNGGXZiuOZbdKEBJhHSn
         6Zk70q3CJaRC5dImqgcvEC9UgNqjioBIyvqKgSjcTzxUwlK2AxHzivx0ssk1vqXZvK
         COp42JjLEO/sEjHh06lPRZJT6b911A7m+9C26L/4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 517/542] iwlwifi: mvm: avoid use after free for pmsr request
Date:   Fri, 14 Feb 2020 10:48:29 -0500
Message-Id: <20200214154854.6746-517-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit cc4255eff523f25187bb95561642941de0e57497 ]

When a FTM request is aborted, the driver sends the abort command to
the fw and waits for a response. When the response arrives, the driver
calls cfg80211_pmsr_complete() for that request.
However, cfg80211 frees the requested data immediately after sending
the abort command, so this may lead to use after free.

Fix it by clearing the request data in the driver when the abort
command arrives and ignoring the fw notification that will come
afterwards.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Fixes: fc36ffda3267 ("iwlwifi: mvm: support FTM initiator")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 9f4b117db9d7f..d47f76890cf9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -8,6 +8,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -30,6 +31,7 @@
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  * Copyright (C) 2018 Intel Corporation
  * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -389,6 +391,8 @@ void iwl_mvm_ftm_abort(struct iwl_mvm *mvm, struct cfg80211_pmsr_request *req)
 	if (req != mvm->ftm_initiator.req)
 		return;
 
+	iwl_mvm_ftm_reset(mvm);
+
 	if (iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_RANGE_ABORT_CMD,
 						 LOCATION_GROUP, 0),
 				 0, sizeof(cmd), &cmd))
@@ -502,7 +506,6 @@ void iwl_mvm_ftm_range_resp(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	lockdep_assert_held(&mvm->mutex);
 
 	if (!mvm->ftm_initiator.req) {
-		IWL_ERR(mvm, "Got FTM response but have no request?\n");
 		return;
 	}
 
-- 
2.20.1

