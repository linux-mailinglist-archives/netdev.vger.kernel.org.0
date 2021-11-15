Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2155451BFB
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353283AbhKPAJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:09:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:18656 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351732AbhKPAHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 19:07:35 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="220768892"
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="220768892"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 16:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,237,1631602800"; 
   d="scan'208";a="506163127"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 15 Nov 2021 16:00:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net 06/10] iavf: prevent accidental free of filter structure
Date:   Mon, 15 Nov 2021 15:59:30 -0800
Message-Id: <20211115235934.880882-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
References: <20211115235934.880882-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

In iavf_config_clsflower, the filter structure could be accidentally
released at the end, if iavf_parse_cls_flower or iavf_handle_tclass ever
return a non-zero but positive value.

In this case, the function continues through to the end, and will call
kfree() on the filter structure even though it has been added to the
linked list.

This can actually happen because iavf_parse_cls_flower will return
a positive IAVF_ERR_CONFIG value instead of the traditional negative
error codes.

Fix this by ensuring that the kfree() check and error checks are
similar. Use the more idiomatic "if (err)" to catch all non-zero error
codes.

Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 76c4ca0f055e..9c68c8628512 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3108,11 +3108,11 @@ static int iavf_configure_clsflower(struct iavf_adapter *adapter,
 	/* start out with flow type and eth type IPv4 to begin with */
 	filter->f.flow_type = VIRTCHNL_TCP_V4_FLOW;
 	err = iavf_parse_cls_flower(adapter, cls_flower, filter);
-	if (err < 0)
+	if (err)
 		goto err;
 
 	err = iavf_handle_tclass(adapter, tc, filter);
-	if (err < 0)
+	if (err)
 		goto err;
 
 	/* add filter to the list */
-- 
2.31.1

