Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2483B0207
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729435AbfIKQuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:50:21 -0400
Received: from mga14.intel.com ([192.55.52.115]:31968 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfIKQuS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:50:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 09:50:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="385759083"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 11 Sep 2019 09:50:17 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 13/13] i40e: fix potential RX buffer starvation for AF_XDP
Date:   Wed, 11 Sep 2019 09:50:14 -0700
Message-Id: <20190911165014.10742-14-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
References: <20190911165014.10742-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

When the RX rings are created they are also populated with buffers
so that packets can be received. Usually these are kernel buffers,
but for AF_XDP in zero-copy mode, these are user-space buffers and
in this case the application might not have sent down any buffers
to the driver at this point. And if no buffers are allocated at ring
creation time, no packets can be received and no interrupts will be
generated so the NAPI poll function that allocates buffers to the
rings will never get executed.

To rectify this, we kick the NAPI context of any queue with an
attached AF_XDP zero-copy socket in two places in the code. Once
after an XDP program has loaded and once after the umem is registered.
This take care of both cases: XDP program gets loaded first then AF_XDP
socket is created, and the reverse, AF_XDP socket is created first,
then XDP program is loaded.

Fixes: 0a714186d3c0 ("i40e: add AF_XDP zero-copy Rx support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 0373bc6c7e61..feb5bd54d840 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -157,6 +157,11 @@ static int i40e_xsk_umem_disable(struct i40e_vsi *vsi, u16 qid)
 		err = i40e_queue_pair_enable(vsi, qid);
 		if (err)
 			return err;
+
+		/* Kick start the NAPI context so that receiving will start */
+		err = i40e_xsk_wakeup(vsi->netdev, qid, XDP_WAKEUP_RX);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
2.21.0

