Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C714525FF87
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgIGQd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbgIGQdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:33:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A197121941;
        Mon,  7 Sep 2020 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496424;
        bh=VBDolsQa9bah2f35ikQNeh3bGYSd5ANyLGcQxwSCoX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bipxg5EvnC8hQy5NauJaafk7Ed/G1z9HlXnee8PLGFIgzon2N8yz/PXAobN71xJIB
         d5/3TY+hRTZ6fjWk2y32qn8D/MuFhtU5Hxz8eRXlqTMcVFtBKwYShdFFZrcGpSNwhY
         3nNGaSMByW1KI7s+t+U4uK+rOcvH1I5MVpDHaTQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mingming Cao <mmc@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 11/43] ibmvnic fix NULL tx_pools and rx_tools issue at do_reset
Date:   Mon,  7 Sep 2020 12:32:57 -0400
Message-Id: <20200907163329.1280888-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163329.1280888-1-sashal@kernel.org>
References: <20200907163329.1280888-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingming Cao <mmc@linux.vnet.ibm.com>

[ Upstream commit 9f13457377907fa253aef560e1a37e1ca4197f9b ]

At the time of do_rest, ibmvnic tries to re-initalize the tx_pools
and rx_pools to avoid re-allocating the long term buffer. However
there is a window inside do_reset that the tx_pools and
rx_pools were freed before re-initialized making it possible to deference
null pointers.

This patch fix this issue by always check the tx_pool
and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
the pools. This will avoid getting into calling reset_tx/rx_pools with
NULL adapter tx_pools/rx_pools pointer. Also add null pointer check in
reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.

Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 2d20a48f0ba0a..de45b3709c14e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -416,6 +416,9 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 	int i, j, rc;
 	u64 *size_array;
 
+	if (!adapter->rx_pool)
+		return -1;
+
 	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
 		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
 
@@ -586,6 +589,9 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
 	int tx_scrqs;
 	int i, rc;
 
+	if (!adapter->tx_pool)
+		return -1;
+
 	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
 	for (i = 0; i < tx_scrqs; i++) {
 		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
@@ -1918,7 +1924,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		    adapter->req_rx_add_entries_per_subcrq !=
 		    old_num_rx_slots ||
 		    adapter->req_tx_entries_per_subcrq !=
-		    old_num_tx_slots) {
+		    old_num_tx_slots ||
+		    !adapter->rx_pool ||
+		    !adapter->tso_pool ||
+		    !adapter->tx_pool) {
 			release_rx_pools(adapter);
 			release_tx_pools(adapter);
 			release_napi(adapter);
@@ -1931,10 +1940,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 		} else {
 			rc = reset_tx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
+						rc);
 				goto out;
 
 			rc = reset_rx_pools(adapter);
 			if (rc)
+				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
+						rc);
 				goto out;
 		}
 		ibmvnic_disable_irqs(adapter);
-- 
2.25.1

