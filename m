Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8643A25F1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbfH2Sde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:55424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbfH2SNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B7692189D;
        Thu, 29 Aug 2019 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102423;
        bh=UpQsW1BGMX/sSqWtk8tg+B0ZE33BOytp6YJxphMj69k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZ3xDZIvGgO4sAvxAnaGbMvljZTMUmb1eRSY/PvoWcwDiiBeRs/9XzblNq2QBeDl9
         ac17zDL4W14TvIWmOqK9G66UshU3w9QLy4paxlTstwfEBPGN3HOnp05qdLzfl4CroU
         g+JK7uqT2ozFpralsP0FGfWAKjNGvzMR9wO0hcQ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 15/76] ixgbe: fix possible deadlock in ixgbe_service_task()
Date:   Thu, 29 Aug 2019 14:12:10 -0400
Message-Id: <20190829181311.7562-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 8b6381600d59871fbe44d36522272f961ab42410 ]

ixgbe_service_task() calls unregister_netdev() under rtnl_lock().
But unregister_netdev() internally calls rtnl_lock().
So deadlock would occur.

Fixes: 59dd45d550c5 ("ixgbe: firmware recovery mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 57fd9ee6de665..f7c049559c1a5 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7893,11 +7893,8 @@ static void ixgbe_service_task(struct work_struct *work)
 		return;
 	}
 	if (ixgbe_check_fw_error(adapter)) {
-		if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
-			rtnl_lock();
+		if (!test_bit(__IXGBE_DOWN, &adapter->state))
 			unregister_netdev(adapter->netdev);
-			rtnl_unlock();
-		}
 		ixgbe_service_event_complete(adapter);
 		return;
 	}
-- 
2.20.1

