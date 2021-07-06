Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFC03BD1E2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhGFLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhGFLdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 677C061C79;
        Tue,  6 Jul 2021 11:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570568;
        bh=fyJMuxXRkS9is0Y18GpXeq6g6r1+GtWuwLtiCQyT9HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHs8ob7YqTXylYKmoZO+QjTWrk9TTQoUaIwJxt+VkrtVI/ll4m3dLmiYMoyWLDpcU
         iWvDsf0Y2wEKgS95XRrsjQaNYYs4esI4dmhi85gwc+E7Lpp+XifSfKxHukMVGZ3FkP
         VfB2slrYNmlLYV945zWu7j7jIlbCzxd7VZruoNw6/YjV9UYTGBo2B0fwz0+Sc9aCte
         xTIGC/WEUA5vj+wti+xzFlODVhR2/mfP/67dilsVbi3fYZgCjHjCJjoRjBk9ZBTK0M
         eSl6Me7jYqNmWM2YldPgsbZwDhEDVv6nMRSi2CsrF9ZUKuIEVNjD5VY0H9Hsilol3m
         MAjn/kihTpmEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 034/137] igb: fix assignment on big endian machines
Date:   Tue,  6 Jul 2021 07:20:20 -0400
Message-Id: <20210706112203.2062605-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit b514958dd1a3bd57638b0e63b8e5152b1960e6aa ]

The igb driver was trying hard to be sparse correct, but somehow
ended up converting a variable into little endian order and then
tries to OR something with it.

A much plainer way of doing things is to leave all variables and
OR operations in CPU (non-endian) mode, and then convert to
little endian only once, which is what this change does.

This probably fixes a bug that might have been seen only on
big endian systems.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 157683fbf61c..4b9b5148c916 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6289,12 +6289,12 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
 	cmd_type |= len | IGB_TXD_DCMD;
 	tx_desc->read.cmd_type_len = cpu_to_le32(cmd_type);
 
-	olinfo_status = cpu_to_le32(len << E1000_ADVTXD_PAYLEN_SHIFT);
+	olinfo_status = len << E1000_ADVTXD_PAYLEN_SHIFT;
 	/* 82575 requires a unique index per ring */
 	if (test_bit(IGB_RING_FLAG_TX_CTX_IDX, &tx_ring->flags))
 		olinfo_status |= tx_ring->reg_idx << 4;
 
-	tx_desc->read.olinfo_status = olinfo_status;
+	tx_desc->read.olinfo_status = cpu_to_le32(olinfo_status);
 
 	netdev_tx_sent_queue(txring_txq(tx_ring), tx_buffer->bytecount);
 
-- 
2.30.2

