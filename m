Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5472AE4D3
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732282AbgKKAU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:20:29 -0500
Received: from mga17.intel.com ([192.55.52.151]:17132 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732233AbgKKAU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 19:20:28 -0500
IronPort-SDR: EWLZjxsZ/c4hnFzr9aQZMfPTVZPUiWbASa5MBpF7hV10RbAemwZ8jAQkKEcRVH/Y++TSJZ83wQ
 qQ4AYoYRZ1sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9801"; a="149921010"
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="149921010"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 16:20:27 -0800
IronPort-SDR: BNoYmkG0kPt60U2f5rVvYJRcS6qm+/kZQyGPQkZ4EhG3tiaK05LBW1wo1pzZf/rbDN4+9z9MU2
 6xYUztmFeYwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,468,1596524400"; 
   d="scan'208";a="366049065"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 10 Nov 2020 16:20:26 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [net 2/4] i40e, xsk: uninitialized variable in i40e_clean_rx_irq_zc()
Date:   Tue, 10 Nov 2020 16:19:53 -0800
Message-Id: <20201111001955.533210-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
References: <20201111001955.533210-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The "failure" variable is used without being initialized.  It should be
set to false.

Fixes: 8cbf74149903 ("i40e, xsk: move buffer allocation out of the Rx processing loop")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 6acede0acdca..567fd67e900e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -281,8 +281,8 @@ int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
 	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	unsigned int xdp_res, xdp_xmit = 0;
+	bool failure = false;
 	struct sk_buff *skb;
-	bool failure;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
-- 
2.26.2

