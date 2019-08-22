Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61409A11C
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389436AbfHVUam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:30:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:17464 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389306AbfHVUam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:30:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 13:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="169907265"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 22 Aug 2019 13:30:40 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     huhai <huhai@kylinos.cn>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 03/13] i40e: add check on i40e_configure_tx_ring() return value
Date:   Thu, 22 Aug 2019 13:30:29 -0700
Message-Id: <20190822203039.15668-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
References: <20190822203039.15668-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huhai <huhai@kylinos.cn>

When i40e_configure_tx_ring(vsi->tx_rings[i]) returns an error, we should
exit from i40e_vsi_configure_tx and return the error, instead of continuing
to check whether xdp is enable, and configure the xdp transmit ring.

Signed-off-by: huhai <huhai@kylinos.cn>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6d456e579314..b807dd6b1417 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3364,7 +3364,7 @@ static int i40e_vsi_configure_tx(struct i40e_vsi *vsi)
 	for (i = 0; (i < vsi->num_queue_pairs) && !err; i++)
 		err = i40e_configure_tx_ring(vsi->tx_rings[i]);
 
-	if (!i40e_enabled_xdp_vsi(vsi))
+	if (err || !i40e_enabled_xdp_vsi(vsi))
 		return err;
 
 	for (i = 0; (i < vsi->num_queue_pairs) && !err; i++)
-- 
2.21.0

