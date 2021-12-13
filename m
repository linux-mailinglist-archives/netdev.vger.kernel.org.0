Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A157C4738A4
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244242AbhLMXiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:38:50 -0500
Received: from mga17.intel.com ([192.55.52.151]:44420 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238160AbhLMXit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 18:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639438728; x=1670974728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTY6DSvA1Jm4bzw8eutxifcLUupDoHj1o/k8zfRq4ys=;
  b=njow61gdYbIvvJwX+NgeeuwHiYtcQSbugPCNUifx+8V2yM8AIzWw20K0
   bAuOSGU0EW/kdGvnBjWvGn4WjDILlmjhZFcXKND/JRJJ3mmPKuWaftg/O
   tN0obi5NiDqspGR783ZwsP+Gd8Ugbv3eLIJ/dqNKooJ8NAexo98v0jHEm
   753oHrG0hyhKwnFCCrw6H6fDGzLn7poaUtiFZZ7POt7qhXmB60yAiOiFU
   QS1+ziyrJdGzo32/oMuc9E32rOOcx/VfJemrBcIlRnJ1K4egAffPM7YQr
   kx0Ry35LEtm/kxxn615DNJ2OrTGPIIIoAqkklgtZ9/P2guoCKH/U3oSGI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="219539647"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="219539647"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 15:38:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="661052308"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 15:38:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/2] iavf: do not override the adapter state in the watchdog task (again)
Date:   Mon, 13 Dec 2021 15:37:50 -0800
Message-Id: <20211213233750.930233-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
References: <20211213233750.930233-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

The watchdog task incorrectly changes the state to __IAVF_RESETTING,
instead of letting the reset task take care of that. This was already
resolved by commit 22c8fd71d3a5 ("iavf: do not override the adapter
state in the watchdog task") but the problem was reintroduced by the
recent code refactoring in commit 45eebd62999d ("iavf: Refactor iavf
state machine tracking").

Fixes: 45eebd62999d ("iavf: Refactor iavf state machine tracking")
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 884a19c51543..4e7c04047f91 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2085,7 +2085,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 	/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		iavf_change_state(adapter, __IAVF_RESETTING);
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.31.1

