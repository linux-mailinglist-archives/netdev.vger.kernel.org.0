Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E96130670
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 08:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgAEHOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 02:14:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:54701 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgAEHOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 02:14:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jan 2020 23:14:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,397,1571727600"; 
   d="scan'208";a="302607383"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 04 Jan 2020 23:14:21 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/15] igc: Remove no need declaration of the igc_write_itr
Date:   Sat,  4 Jan 2020 23:14:19 -0800
Message-Id: <20200105071420.3778982-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
References: <20200105071420.3778982-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

We want to avoid forward-declarations of function if possible.
Rearrange the igc_write_itr function implementation.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 33 +++++++++++------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4fb40c6aa583..c7b9bbbef3aa 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -53,7 +53,6 @@ MODULE_DEVICE_TABLE(pci, igc_pci_tbl);
 
 /* forward declaration */
 static int igc_sw_init(struct igc_adapter *);
-static void igc_write_itr(struct igc_q_vector *q_vector);
 
 enum latency_range {
 	lowest_latency = 0,
@@ -2931,6 +2930,22 @@ static irqreturn_t igc_msix_other(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void igc_write_itr(struct igc_q_vector *q_vector)
+{
+	u32 itr_val = q_vector->itr_val & IGC_QVECTOR_MASK;
+
+	if (!q_vector->set_itr)
+		return;
+
+	if (!itr_val)
+		itr_val = IGC_ITR_VAL_MASK;
+
+	itr_val |= IGC_EITR_CNT_IGNR;
+
+	writel(itr_val, q_vector->itr_register);
+	q_vector->set_itr = 0;
+}
+
 static irqreturn_t igc_msix_ring(int irq, void *data)
 {
 	struct igc_q_vector *q_vector = data;
@@ -4044,22 +4059,6 @@ static int igc_request_irq(struct igc_adapter *adapter)
 	return err;
 }
 
-static void igc_write_itr(struct igc_q_vector *q_vector)
-{
-	u32 itr_val = q_vector->itr_val & IGC_QVECTOR_MASK;
-
-	if (!q_vector->set_itr)
-		return;
-
-	if (!itr_val)
-		itr_val = IGC_ITR_VAL_MASK;
-
-	itr_val |= IGC_EITR_CNT_IGNR;
-
-	writel(itr_val, q_vector->itr_register);
-	q_vector->set_itr = 0;
-}
-
 /**
  * __igc_open - Called when a network interface is made active
  * @netdev: network interface device structure
-- 
2.24.1

