Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02153BCEF5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhGFL1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234954AbhGFLZP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:25:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4043C61D3A;
        Tue,  6 Jul 2021 11:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570358;
        bh=gyNbe78AFY1UzqreDnREF1h2G5X1Dv9nW1W/K3xfdW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IzPO/aSbUNErM5QyuLt3cwi54nmggSbBWFidWY+tq6jZAQRFfUxVy10H6xmivJZgd
         26xheTQ+FA56scKciz8HB66ETHPR1mhmTtlF8ZMaDN2PzMOBzBIwvEUhnIC345n+zn
         pur0QvEAJcI4oJAfrE3YOP57+ZWTSG0Du7PkkPt03rwasZEgBf2Xmry72puOfxJBtj
         enJQejFfY16WyjqhziE4M71WhmZBqX4Nx9vQfJgc4YdLV+oAZYHQvkl9QqSDLQ8RET
         I5ST4DijdTCBn9/tvD/t6W2uNFdZ0JNKPat2+8jQnPkxpzQfjvUnyquKXIHrYDiCcR
         qKJSLMve391Ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 038/160] igb: fix assignment on big endian machines
Date:   Tue,  6 Jul 2021 07:16:24 -0400
Message-Id: <20210706111827.2060499-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 894b9b87dba1..434220a342df 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6277,12 +6277,12 @@ int igb_xmit_xdp_ring(struct igb_adapter *adapter,
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

