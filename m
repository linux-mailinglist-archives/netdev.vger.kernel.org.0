Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23645AD79
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 21:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbhKWUnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 15:43:22 -0500
Received: from mga05.intel.com ([192.55.52.43]:36325 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232084AbhKWUnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 15:43:21 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="321360498"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="321360498"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 12:40:11 -0800
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="497420122"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 12:40:11 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Danielle Ratson <danieller@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net v2] igb: fix netpoll exit with traffic
Date:   Tue, 23 Nov 2021 12:40:00 -0800
Message-Id: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oleksandr brought a bug report where netpoll causes trace
messages in the log on igb.

Danielle brought this back up as still occuring, so we'll try
again.

[22038.710800] ------------[ cut here ]------------
[22038.710801] igb_poll+0x0/0x1440 [igb] exceeded budget in poll
[22038.710802] WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155 netpoll_poll_dev+0x18a/0x1a0

As Alex suggested, change the driver to return work_done at the
exit of napi_poll, which should be safe to do in this driver
because it is not polling multiple queues in this single napi
context (multiple queues attached to one MSI-X vector). Several
other drivers contain the same simple sequence, so I hope
this will not create new problems.

Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and improve performance")
Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reported-by: Danielle Ratson <danieller@nvidia.com>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
COMPILE TESTED ONLY! I have no way to reproduce this even on a machine I
have with igb. It works fine to load the igb driver and netconsole with
no errors.
---
v2: simplified patch with an attempt to make it work
v1: original patch that apparently didn't work
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index e647cc89c239..5e24b7ce5a92 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done)))
 		igb_ring_irq_enable(q_vector);
 
-	return min(work_done, budget - 1);
+	return work_done;
 }
 
 /**
-- 
2.33.1

