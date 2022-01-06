Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887DE4869F8
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbiAFSbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:31:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:21739 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242870AbiAFSbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 13:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641493868; x=1673029868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RpDg8Z4KpqmlwITSm+ZY/mZg2uykKhazflofEU84+00=;
  b=cIbPGvLe9DFZgWrH9rutCGVuQCYlVAQ/WQK4gOrBOB0sqmgpOLY/mn8e
   7qt6LCku1iUhu+i21M+cxZAggUcTDNYjbJwH6kJUVA0G0vzv066Z0swll
   +uCHSmrDyiAncA1rDOmmF4ArfIdI/1ZHNqwYv6OoJF3SA4JHvh/DrNNma
   KZAIe9mcwWgpqSrnNpQMUDRBlAdk+sCaU/vquuAI9Vj5xTD+5JhpNRl3g
   MbVyxq6v5SXBrxMpxeuYetNteoszejE0S71FIBMirEyEiTAHP7g9huzoI
   se3UN7Cxk1/XoE1QKigP6NQLfRkMXAktO7dBJtJkCLGj7CoU0+bRBL2eS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242666615"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="242666615"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 10:30:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="489024745"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 06 Jan 2022 10:30:50 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 5/5] ice: Use bitmap_free() to free bitmap
Date:   Thu,  6 Jan 2022 10:30:13 -0800
Message-Id: <20220106183013.3777622-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
References: <20220106183013.3777622-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

kfree() and bitmap_free() are the same. But using the latter is more
consistent when freeing memory allocated with bitmap_zalloc().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index d3f65e061a62..ae291d442539 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2229,7 +2229,7 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	kfree(tx->tstamps);
 	tx->tstamps = NULL;
 
-	kfree(tx->in_use);
+	bitmap_free(tx->in_use);
 	tx->in_use = NULL;
 
 	tx->len = 0;
-- 
2.31.1

