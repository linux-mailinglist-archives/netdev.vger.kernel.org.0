Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B259523533E
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgHAQSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:19610 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgHAQSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:10 -0400
IronPort-SDR: gVfHDpT42vvGSJbDiyBUe+bKdsqykKprJ0De7ELuZG2p46MRrHF+4MfmJR3Fu1ayTqrle/gykv
 dVWblAcFQnjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810853"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810853"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: 3c95CahDaGCaE0BuENCn1R4vKORX/9RcrfFEfHRBoKKrXUW/d4FHwUvvNhaT/EoIxip/dSAwUB
 zDqpCNa3XynA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457708"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vignesh Sridhar <vignesh.sridhar@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 07/14] ice: Clear and free XLT entries on reset
Date:   Sat,  1 Aug 2020 09:17:55 -0700
Message-Id: <20200801161802.867645-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Sridhar <vignesh.sridhar@intel.com>

This fix has been added to address memory leak issues resulting from
triggering a sudden driver reset which does not allow us to follow our
normal removal flows for SW XLT entries for advanced features.

- Adding call to destroy flow profile locks when clearing SW XLT tables.

- Extraction sequence entries were not correctly cleared previously
which could cause ownership conflicts for repeated reset-replay calls.

Fixes: 31ad4e4ee1e4 ("ice: Allocate flow profile")
Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 3c217e51b27e..d59869b2c65e 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2921,6 +2921,8 @@ static void ice_free_flow_profs(struct ice_hw *hw, u8 blk_idx)
 					   ICE_FLOW_ENTRY_HNDL(e));
 
 		list_del(&p->l_entry);
+
+		mutex_destroy(&p->entries_lock);
 		devm_kfree(ice_hw_to_dev(hw), p);
 	}
 	mutex_unlock(&hw->fl_profs_locks[blk_idx]);
@@ -3038,7 +3040,7 @@ void ice_clear_hw_tbls(struct ice_hw *hw)
 		memset(prof_redir->t, 0,
 		       prof_redir->count * sizeof(*prof_redir->t));
 
-		memset(es->t, 0, es->count * sizeof(*es->t));
+		memset(es->t, 0, es->count * sizeof(*es->t) * es->fvw);
 		memset(es->ref_count, 0, es->count * sizeof(*es->ref_count));
 		memset(es->written, 0, es->count * sizeof(*es->written));
 	}
-- 
2.26.2

