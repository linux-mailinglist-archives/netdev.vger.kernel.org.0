Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC599FAC2
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfH1Goe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:35206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfH1GoO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443800"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] igc: Add NVM checksum validation
Date:   Tue, 27 Aug 2019 23:43:59 -0700
Message-Id: <20190828064407.30168-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add NVM checksum validation during probe functionality.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 251552855c40..965d1c939f0f 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4133,6 +4133,15 @@ static int igc_probe(struct pci_dev *pdev,
 	 */
 	hw->mac.ops.reset_hw(hw);
 
+	if (igc_get_flash_presence_i225(hw)) {
+		if (hw->nvm.ops.validate(hw) < 0) {
+			dev_err(&pdev->dev,
+				"The NVM Checksum Is Not Valid\n");
+			err = -EIO;
+			goto err_eeprom;
+		}
+	}
+
 	if (eth_platform_get_mac_address(&pdev->dev, hw->mac.addr)) {
 		/* copy the MAC address out of the NVM */
 		if (hw->mac.ops.read_mac_addr(hw))
-- 
2.21.0

