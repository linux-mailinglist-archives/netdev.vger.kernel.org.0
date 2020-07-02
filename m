Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 213802118AD
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgGBBZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:25:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbgGBBZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:25:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E2120748;
        Thu,  2 Jul 2020 01:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653152;
        bh=S5y3AhmUCAUNnZse2ae1T3/X32UKywxLi6gBfv4BVxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZXa/msgMZniBmlnQfIou1LW+cJYzLUc2Vsbl1Zp+5BWQlPm7DMi8IFR1wjrXbYpSd
         G9QI68IjSFPbwIgPXfEQ989O5psfOoGjSNjGjUak/rFIJ8qtGypBfaa+RTJTTg/hkV
         xbc+pznrSJl10qWdiIWeLOp1QJThIsUhxvWXV3bA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 22/40] ibmvnic: continue to init in CRQ reset returns H_CLOSED
Date:   Wed,  1 Jul 2020 21:23:43 -0400
Message-Id: <20200702012402.2701121-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012402.2701121-1-sashal@kernel.org>
References: <20200702012402.2701121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit 8b40eb73509f5704a0e8cd25de0163876299f1a7 ]

Continue the reset path when partner adapter is not ready or H_CLOSED is
returned from reset crq. This patch allows the CRQ init to proceed to
establish a valid CRQ for traffic to flow after reset.

Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5a42ddeecfe50..143a9722ad11a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1865,13 +1865,18 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 			release_sub_crqs(adapter, 1);
 		} else {
 			rc = ibmvnic_reset_crq(adapter);
-			if (!rc)
+			if (rc == H_CLOSED || rc == H_SUCCESS) {
 				rc = vio_enable_interrupts(adapter->vdev);
+				if (rc)
+					netdev_err(adapter->netdev,
+						   "Reset failed to enable interrupts. rc=%d\n",
+						   rc);
+			}
 		}
 
 		if (rc) {
 			netdev_err(adapter->netdev,
-				   "Couldn't initialize crq. rc=%d\n", rc);
+				   "Reset couldn't initialize crq. rc=%d\n", rc);
 			goto out;
 		}
 
-- 
2.25.1

