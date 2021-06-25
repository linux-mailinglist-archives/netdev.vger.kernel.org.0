Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA333B4909
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhFYS5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:57:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:14427 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhFYS5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:57:05 -0400
IronPort-SDR: yExibea0oACaqWjHz2KaBqzN78fT0jXraEZcDjFbd8yXF1LgosquNQ5OKDe6g8wHY9nXEu7RPG
 QUibyfC4VKvQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="229326802"
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="229326802"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 11:54:44 -0700
IronPort-SDR: ui1ry0S40mTyxEIAu0Fwr2o1aiRNqxPRnOovqZ/fnchX1B9y7SOwGQi6fJJ4m7ijdv37zn31p/
 XlZ04kBcL4+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,299,1616482800"; 
   d="scan'208";a="491655936"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2021 11:54:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 5/5] ice: Fix a memory leak in an error handling path in 'ice_pf_dcb_cfg()'
Date:   Fri, 25 Jun 2021 11:57:33 -0700
Message-Id: <20210625185733.1848704-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

If this 'kzalloc()' fails we must free some resources as in all the other
error handling paths of this function.

Fixes: 348048e724a0 ("ice: Implement iidc operations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 857dc62da7a8..926cf748c5ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -316,8 +316,10 @@ int ice_pf_dcb_cfg(struct ice_pf *pf, struct ice_dcbx_cfg *new_cfg, bool locked)
 
 	/* Notify AUX drivers about impending change to TCs */
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
-	if (!event)
-		return -ENOMEM;
+	if (!event) {
+		ret = -ENOMEM;
+		goto free_cfg;
+	}
 
 	set_bit(IIDC_EVENT_BEFORE_TC_CHANGE, event->type);
 	ice_send_event_to_aux(pf, event);
-- 
2.26.2

