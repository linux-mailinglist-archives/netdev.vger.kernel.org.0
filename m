Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1251B3655E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfFEUXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfFEUXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 16:23:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 13:23:46 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga005.jf.intel.com with ESMTP; 05 Jun 2019 13:23:45 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     William Tu <u9012063@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/15] ixgbe: fix AF_XDP tx packet count
Date:   Wed,  5 Jun 2019 13:23:47 -0700
Message-Id: <20190605202358.2767-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
References: <20190605202358.2767-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>

The total_packets count at ixgbe_clean_xdp_tx_irq is
always zero when testing with xdpsock -t -N. Set the gso_segs
to 1 to make the tx packet count correct.

Signed-off-by: William Tu <u9012063@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index 90aa5825f500..6af55bb3bef3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -590,6 +590,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 		tx_bi = &xdp_ring->tx_buffer_info[xdp_ring->next_to_use];
 		tx_bi->bytecount = len;
 		tx_bi->xdpf = NULL;
+		tx_bi->gso_segs = 1;
 
 		tx_desc = IXGBE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
 		tx_desc->read.buffer_addr = cpu_to_le64(dma);
-- 
2.21.0

