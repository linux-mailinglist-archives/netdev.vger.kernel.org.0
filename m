Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9793655D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfFEUXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:23:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:4309 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbfFEUXs (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [net-next 03/15] ixgbe: fix AF_XDP tx byte count
Date:   Wed,  5 Jun 2019 13:23:46 -0700
Message-Id: <20190605202358.2767-4-jeffrey.t.kirsher@intel.com>
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

The tx bytecount is done twice.  When running
'./xdpsock -t -N -i eth3' and 'ip -s link show dev eth3'
The avg packet size is 120 instead of 60. So remove the
extra one.

Signed-off-by: William Tu <u9012063@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index f7cc13d7eb2c..90aa5825f500 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -654,7 +654,6 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
 			xsk_frames++;
 
 		tx_bi->xdpf = NULL;
-		total_bytes += tx_bi->bytecount;
 
 		tx_bi++;
 		tx_desc++;
-- 
2.21.0

