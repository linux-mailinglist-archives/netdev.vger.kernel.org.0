Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD41C468AE
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfFNUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:15:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:59939 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfFNUPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:15:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jun 2019 13:15:54 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jun 2019 13:15:54 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 04/12] i40e: Use signed variable
Date:   Fri, 14 Jun 2019 13:16:02 -0700
Message-Id: <20190614201610.13566-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
References: <20190614201610.13566-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

The counter variable in i40e_clean_tx_irq starts out negative and climbs
to 0. So it should not be defined as a u16. This was working by accident
due to the fact the u16 overflows and underflows predictably.

Replace the u16 with int, which is signed and can handle the negativity.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 20a283702c9f..2a2fe3ec7926 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -774,7 +774,7 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
 static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 			      struct i40e_ring *tx_ring, int napi_budget)
 {
-	u16 i = tx_ring->next_to_clean;
+	int i = tx_ring->next_to_clean;
 	struct i40e_tx_buffer *tx_buf;
 	struct i40e_tx_desc *tx_head;
 	struct i40e_tx_desc *tx_desc;
-- 
2.21.0

