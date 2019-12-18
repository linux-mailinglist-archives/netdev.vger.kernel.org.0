Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEAA1243C2
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfLRJxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:53:19 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:58740 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbfLRJxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:53:19 -0500
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ihW0z-0006D0-GM; Wed, 18 Dec 2019 09:53:09 +0000
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1ihW0z-00A3gg-7g; Wed, 18 Dec 2019 09:53:09 +0000
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     ben.dooks@codethink.co.uk
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: [PATCH] e1000e: fix missing cpu_to_le64 on buffer_addr
Date:   Wed, 18 Dec 2019 09:53:08 +0000
Message-Id: <20191218095308.2397408-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following warning suggests there is a missing cpu_to_le64() in
the e1000_flush_tx_ring() function (it is also the behaviour
elsewhere in the driver to do cpu_to_le64() on the buffer_addr
when setting it)

drivers/net/ethernet/intel/e1000e/netdev.c:3813:30: warning: incorrect type in assignment (different base types)
drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    expected restricted __le64 [usertype] buffer_addr
drivers/net/ethernet/intel/e1000e/netdev.c:3813:30:    got unsigned long long [usertype] dma

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fe7997c18a10..b317ac024819 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3810,7 +3810,7 @@ static void e1000_flush_tx_ring(struct e1000_adapter *adapter)
 	tdt = er32(TDT(0));
 	BUG_ON(tdt != tx_ring->next_to_use);
 	tx_desc =  E1000_TX_DESC(*tx_ring, tx_ring->next_to_use);
-	tx_desc->buffer_addr = tx_ring->dma;
+	tx_desc->buffer_addr = cpu_to_le64(tx_ring->dma);
 
 	tx_desc->lower.data = cpu_to_le32(txd_lower | size);
 	tx_desc->upper.data = 0;
-- 
2.24.0

