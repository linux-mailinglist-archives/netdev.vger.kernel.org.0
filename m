Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433EB495EBC
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350257AbiAUMAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:00:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:36375 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349917AbiAUMAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:00:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642766440; x=1674302440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NghxkmY3f87twgZB5ZuXp/dUUlTQG84K+mbarO6dMS4=;
  b=lR+q3WnLCSecpPGRXlas8h0W1biPu+Z3b7ig8n6fiUvIAf2LGy2F6W8L
   vKaNCBiLfXxTaVdP8lMc4BFPYDolGXwdN/0pYd+90yFp7LK6vlGbKAFj6
   2NBcLsqY4LLO1JXtQ6u3lWe9QHAyIyfKJuoqI3Z4sB7ia+v6VACTgPD4g
   nfYTowm3LEo0j6PjZ+c4ilgdjyHKyOKOhLTxHT0lUH/ZcK1PltjfAEadi
   Qy0kP8gUJAFTHDpmCOIkhTKJ+4zyyDE9BClt/GEvr9Y1HdSWtm6FSClOJ
   86ogmPBHqS3pwqcDRWjrFfeekhHhut87p+EG23zTvA1yk12LkJNuVW0zr
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="270058949"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="270058949"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 04:00:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="475924944"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2022 04:00:29 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v3 1/7] ice: remove likely for napi_complete_done
Date:   Fri, 21 Jan 2022 13:00:05 +0100
Message-Id: <20220121120011.49316-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
References: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the likely before napi_complete_done as this is the unlikely case
when busy-poll is used. Removing this has a positive performance impact
for busy-poll and no negative impact to the regular case.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3e38695f1c9d..e661d0e45b9b 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1513,7 +1513,7 @@ int ice_napi_poll(struct napi_struct *napi, int budget)
 	/* Exit the polling mode, but don't re-enable interrupts if stack might
 	 * poll us due to busy-polling
 	 */
-	if (likely(napi_complete_done(napi, work_done))) {
+	if (napi_complete_done(napi, work_done)) {
 		ice_net_dim(q_vector);
 		ice_enable_interrupt(q_vector);
 	} else {
-- 
2.33.1

