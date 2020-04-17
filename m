Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDFF1AE502
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgDQSm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:42:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:31349 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728801AbgDQSmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:54 -0400
IronPort-SDR: YofeqQtOCF0/nJOPKK9IjrGwnlpWZyXCig+gqXwAmcqTlAiaStWbZ6D7lppbjHu6Roj5Bwe3Bc
 ookmo0Q1r/Pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: HV1rqK2ApHcis30xsarIxygtVwRb3gPn3tOKaxxw+DCjRqK1f4h+hQ0kd96nlE2UuCqmwf6rdf
 W/CHrrCX878w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294380"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/14] igc: Fix overwrites when dumping registers
Date:   Fri, 17 Apr 2020 11:42:45 -0700
Message-Id: <20200417184251.1962762-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

This patch fixes some register overwriting when dumping registers via
ethtool.

We have a total of 16 RAL registers, starting at offset 139. So RAH
offset should be 139 + 16 = 155, not 145. As result some RAL registers
are overwritten. Likewise, RAH registers are also overwritten by TDBAL,
TDBAH, TDLEN, and TDH registers.

To fix this bug while preserving the ABI, this patch re-writes RAL and
RAH registers at the end of 'regs_buff' and bumps regs->version. It also
removes some pointless comments in the middle of igc_set_regs().

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index f530fc29b074..ff2a40496e4e 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -153,7 +153,7 @@ static void igc_get_regs(struct net_device *netdev,
 
 	memset(p, 0, IGC_REGS_LEN * sizeof(u32));
 
-	regs->version = (1u << 24) | (hw->revision_id << 16) | hw->device_id;
+	regs->version = (2u << 24) | (hw->revision_id << 16) | hw->device_id;
 
 	/* General Registers */
 	regs_buff[0] = rd32(IGC_CTRL);
@@ -306,6 +306,15 @@ static void igc_get_regs(struct net_device *netdev,
 		regs_buff[164 + i] = rd32(IGC_TDT(i));
 	for (i = 0; i < 4; i++)
 		regs_buff[168 + i] = rd32(IGC_TXDCTL(i));
+
+	/* XXX: Due to a bug few lines above, RAL and RAH registers are
+	 * overwritten. To preserve the ABI, we write these registers again in
+	 * regs_buff.
+	 */
+	for (i = 0; i < 16; i++)
+		regs_buff[172 + i] = rd32(IGC_RAL(i));
+	for (i = 0; i < 16; i++)
+		regs_buff[188 + i] = rd32(IGC_RAH(i));
 }
 
 static void igc_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
-- 
2.25.2

