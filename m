Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501A113E243
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732581AbgAPQzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbgAPQzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7523B2467A;
        Thu, 16 Jan 2020 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193708;
        bh=Dslocvm6ODpusPCVvet1wWvSZrEl0x0UXS983L8p52U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqPgYqASOvF6IIgaCAHfqQrhQ39plW94jdAYRPgAzesgXzJB/n1sW2N6V1FJA2r3X
         92Yy2tLfcO0mwNVZ73Xh+5DHjBzu4fjsVcKdVrjZ2oT+0OqaRa+a9a4OHhCUHJt8oW
         M6xfq5gnpL3aq4km1LrvQw5dqPgsSnNZSvSdpU40=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <shannon.nelson@oracle.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 004/671] ixgbe: don't clear IPsec sa counters on HW clearing
Date:   Thu, 16 Jan 2020 11:43:55 -0500
Message-Id: <20200116165502.8838-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <shannon.nelson@oracle.com>

[ Upstream commit 9e3f2f5ecee69b0f70003fb3e07639151e91de73 ]

The software SA record counters should not be cleared when clearing
the hardware tables.  This causes the counters to be out of sync
after a driver reset.

Fixes: 63a67fe229ea ("ixgbe: add ipsec offload add and remove SA")
Signed-off-by: Shannon Nelson <shannon.nelson@oracle.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index b27f7a968820..49e6d66ccf80 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -114,7 +114,6 @@ static void ixgbe_ipsec_set_rx_ip(struct ixgbe_hw *hw, u16 idx, __be32 addr[])
  **/
 static void ixgbe_ipsec_clear_hw_tables(struct ixgbe_adapter *adapter)
 {
-	struct ixgbe_ipsec *ipsec = adapter->ipsec;
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 buf[4] = {0, 0, 0, 0};
 	u16 idx;
@@ -133,9 +132,6 @@ static void ixgbe_ipsec_clear_hw_tables(struct ixgbe_adapter *adapter)
 		ixgbe_ipsec_set_tx_sa(hw, idx, buf, 0);
 		ixgbe_ipsec_set_rx_sa(hw, idx, 0, buf, 0, 0, 0);
 	}
-
-	ipsec->num_rx_sa = 0;
-	ipsec->num_tx_sa = 0;
 }
 
 /**
-- 
2.20.1

