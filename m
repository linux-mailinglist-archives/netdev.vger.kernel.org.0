Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D756B480C84
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 19:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbhL1SZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 13:25:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:29449 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237030AbhL1SZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 13:25:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640715906; x=1672251906;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b05DCDJ4y7WLj9M00yi9+3L2x6Ad3xY9Tzc0kftGRsY=;
  b=XL9GinEYfmZ0V6CV9T9XkbO+QEVXQ4qFODldOp4+N91V+XqOr8d6cb9/
   fzwalqeXzjfslyNKqNrN4O8nz11frfHYiYFwgs9eWOcQ+9LS3eZX1eq/7
   qvaBxs2LhfRcoxAHjl+CGJtlRL84xybDMclfij1OZLFW232u6XGgomjLA
   FNE0/EcoQaMEXOnhFbKFCV2lxWLytYpMKRUEuUVJz6d57DhafQD5PBs4o
   X1eE1bPUsZ8nazT0gdnynBCnEa/zmPbYRkW8E6+2mMMSakcvcUuR1owlF
   V49emGHQy6a4Wdfwce0/chxbMi5etZP/OBbRGG1oKVbFMDTTF8MY5nSuS
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="241206671"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="241206671"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 10:25:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="666075959"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Dec 2021 10:25:05 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     James McLaughlin <james.mclaughlin@qsc.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 2/2] igc: Fix TX timestamp support for non-MSI-X platforms
Date:   Tue, 28 Dec 2021 10:24:21 -0800
Message-Id: <20211228182421.340354-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
References: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James McLaughlin <james.mclaughlin@qsc.com>

Time synchronization was not properly enabled on non-MSI-X platforms.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: James McLaughlin <james.mclaughlin@qsc.com>
Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 8e448288ee26..d28a80a00953 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5467,6 +5467,9 @@ static irqreturn_t igc_intr_msi(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
@@ -5510,6 +5513,9 @@ static irqreturn_t igc_intr(int irq, void *data)
 			mod_timer(&adapter->watchdog_timer, jiffies + 1);
 	}
 
+	if (icr & IGC_ICR_TS)
+		igc_tsync_interrupt(adapter);
+
 	napi_schedule(&q_vector->napi);
 
 	return IRQ_HANDLED;
-- 
2.31.1

