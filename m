Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBC02CD77E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437157AbgLCNek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:34:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436781AbgLCNaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:30:55 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/23] ibmvnic: skip tx timeout reset while in resetting
Date:   Thu,  3 Dec 2020 08:29:24 -0500
Message-Id: <20201203132935.931362-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132935.931362-1-sashal@kernel.org>
References: <20201203132935.931362-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit 855a631a4c11458a9cef1ab79c1530436aa95fae ]

Sometimes it takes longer than 5 seconds (watchdog timeout) to complete
failover, migration, and other resets. In stead of scheduling another
timeout reset, we wait for the current one to complete.

Suggested-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e53994ca3142c..af1d9d2150616 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2266,6 +2266,12 @@ static void ibmvnic_tx_timeout(struct net_device *dev)
 {
 	struct ibmvnic_adapter *adapter = netdev_priv(dev);
 
+	if (test_bit(0, &adapter->resetting)) {
+		netdev_err(adapter->netdev,
+			   "Adapter is resetting, skip timeout reset\n");
+		return;
+	}
+
 	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
 }
 
-- 
2.27.0

