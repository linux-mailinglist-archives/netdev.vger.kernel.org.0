Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA8749B832
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377292AbiAYQHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:4817 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378584AbiAYQFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126741; x=1674662741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dZMU8fhhUXQXHlPri6aW73rCA4uTdvZLa8E3kEyRedY=;
  b=b65qsIKDNOZDVXvprU3xsU0x2TT09QyqPFfQ+J9JPvybFI6Etmhd4J7J
   Vt8ow9vJeimD3n0DbbhOWtfr4gKYeB8B85ChRZlTchHkccQirXvdozZ+D
   AvJxBTj2d0vdsjJp2T8nQnkz0Xg4MKIuT0aiS6hIObbFKhN+7CsqhzRuV
   H3eB/2BqZZAtJ7FgXNleqgg6lJbDcl2ViYDkplPU+irOjTvsxQgF4dV/Z
   cSUU/QBmLIsj11MjObbUNyGI5Ff5qS05svScXccTjuI7HI1iSjFBo4BZj
   IoEhaWmdPJUdK0KUJrJln0zmbWLMi0ff5WggkyF7aUeFnz25CAbOJJ3+4
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911568"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911568"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:04:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789207"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:04:50 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next v5 1/8] ice: remove likely for napi_complete_done
Date:   Tue, 25 Jan 2022 17:04:39 +0100
Message-Id: <20220125160446.78976-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the likely before napi_complete_done as this is the unlikely case
when busy-poll is used. Removing this has a positive performance impact
for busy-poll and no negative impact to the regular case.

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
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

