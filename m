Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653842117E7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 03:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgGBBXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 21:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728366AbgGBBXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 21:23:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71A002085B;
        Thu,  2 Jul 2020 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593653010;
        bh=veRgKsegTkK+mGLSlUJksyux8IRzvf0/wRoMvomENGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUsvnQgMbwLbTnH40KkwLIOH82/I842ScfwaXOH18hiM+at4JF1N0vXnXxgB43pL0
         Jj09pEzEbb8JhuJfsXkt+LaaZCu1IhNLdQv32g1ARsw/21rfvh1K6Z6RAxDOuKpkB9
         QY09pH8pCVGRGi0Lnjft1tuXPT2MEY+NJeU3MYv0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dany Madden <drt@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 28/53] ibmvnic: continue to init in CRQ reset returns H_CLOSED
Date:   Wed,  1 Jul 2020 21:21:37 -0400
Message-Id: <20200702012202.2700645-28-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702012202.2700645-1-sashal@kernel.org>
References: <20200702012202.2700645-1-sashal@kernel.org>
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
index 1b4d04e4474bb..2dbcbdbb0e4ad 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1958,13 +1958,18 @@ static int do_reset(struct ibmvnic_adapter *adapter,
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

