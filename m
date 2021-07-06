Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF833BCE6F
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhGFL0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232134AbhGFLRz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:17:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B33DD61C2C;
        Tue,  6 Jul 2021 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570116;
        bh=A544I4oJm6Rauy6+cq/Rn4Cfmeu+DFrH6kgZSY4qboI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pUljQrHoODrFBnUFDvePJJqsDzivhL1ALqwPTdol9pJt5CzMZy4n2xoICVi5xGwoM
         MrmJltgafyFocflamzWCrWZjgi5bxQjakDpZ330/7F1/yc6zqftBYhW87OMz+iMIJS
         ySlXgmeBz0jNKv6OF22iqndAFZryGnfKsFrmj0MGEMFI980xVLwpx4D6kUbhCeWKo/
         IlaFlzmAE/MjdRvOWtR5E9IUte5g+mMCYrSALjOQra8U5wsdEMHeyVmSbKk8w2cDq7
         xRdODlJcaEAmx1BuqXV/rVDBljG5szpFwFVqdg/4X3Cu839MLy6FRQ49AoRXCABYWV
         g56tevStMnoow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 047/189] igb: fix assignment on big endian machines
Date:   Tue,  6 Jul 2021 07:11:47 -0400
Message-Id: <20210706111409.2058071-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index b0232a8de343..7b1885f9ce03 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6276,12 +6276,12 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
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

