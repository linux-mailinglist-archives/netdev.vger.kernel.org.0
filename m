Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9980532B3C7
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1835350AbhCCEGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:06:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:51440 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349042AbhCBUER (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 15:04:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A79D8AC24;
        Tue,  2 Mar 2021 19:48:02 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     netdev@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ibmvnic: Fix possibly uninitialized old_num_tx_queues variable warning.
Date:   Tue,  2 Mar 2021 20:47:47 +0100
Message-Id: <20210302194747.21704-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 7.5 reports:
../drivers/net/ethernet/ibm/ibmvnic.c: In function 'ibmvnic_reset_init':
../drivers/net/ethernet/ibm/ibmvnic.c:5373:51: warning: 'old_num_tx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]
../drivers/net/ethernet/ibm/ibmvnic.c:5373:6: warning: 'old_num_rx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]

The variable is initialized only if(reset) and used only if(reset &&
something) so this is a false positive. However, there is no reason to
not initialize the variables unconditionally avoiding the warning.

Fixes: 635e442f4a48 ("ibmvnic: merge ibmvnic_reset_init and ibmvnic_init")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 118a4bd3f877..3bad762083c5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5219,16 +5219,14 @@ static int ibmvnic_reset_init(struct ibmvnic_adapter *adapter, bool reset)
 {
 	struct device *dev = &adapter->vdev->dev;
 	unsigned long timeout = msecs_to_jiffies(20000);
-	u64 old_num_rx_queues, old_num_tx_queues;
+	u64 old_num_rx_queues = adapter->req_rx_queues;
+	u64 old_num_tx_queues = adapter->req_tx_queues;
 	int rc;
 
 	adapter->from_passive_init = false;
 
-	if (reset) {
-		old_num_rx_queues = adapter->req_rx_queues;
-		old_num_tx_queues = adapter->req_tx_queues;
+	if (reset)
 		reinit_completion(&adapter->init_done);
-	}
 
 	adapter->init_done_rc = 0;
 	rc = ibmvnic_send_crq_init(adapter);
-- 
2.26.2

