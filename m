Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB3358B6D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhDHReV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:34:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:25282 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232281AbhDHReJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 13:34:09 -0400
IronPort-SDR: KVKTkYnUUHOuc0buMF1Ju2YsBW5xUedFGrOMdYs9ElFlvOhIKnqa4ZgZm8grgBpZWf5/soSrgi
 66qrD0nuQolQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="181132908"
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="181132908"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 10:33:57 -0700
IronPort-SDR: oVKNVuafij8Log0ycON0WHS3ymTsi1+5duEYIo+h8VcJyrAY3e69Gfx7Ftia7Tit/m5TDTlNQp
 wZCVZLhvoTGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,207,1613462400"; 
   d="scan'208";a="422343450"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 08 Apr 2021 10:33:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net 3/6] i40e: Fix sparse error: uninitialized symbol 'ring'
Date:   Thu,  8 Apr 2021 10:35:34 -0700
Message-Id: <20210408173537.3519606-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
References: <20210408173537.3519606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Init pointer with NULL in default switch case statement.

Previously the error was produced when compiling against sparse.
i40e_debugfs.c:582 i40e_dbg_dump_desc() error: uninitialized symbol 'ring'.

Fixes: 44ea803e2fa7 ("i40e: introduce new dump desc XDP command")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index d7c13ca9be7d..d627b59ad446 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -578,6 +578,9 @@ static void i40e_dbg_dump_desc(int cnt, int vsi_seid, int ring_id, int desc_n,
 	case RING_TYPE_XDP:
 		ring = kmemdup(vsi->xdp_rings[ring_id], sizeof(*ring), GFP_KERNEL);
 		break;
+	default:
+		ring = NULL;
+		break;
 	}
 	if (!ring)
 		return;
-- 
2.26.2

