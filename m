Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCA471DD8
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391161AbfGWRhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:37:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:49109 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391149AbfGWRhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:37:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jul 2019 10:37:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,299,1559545200"; 
   d="scan'208";a="197203642"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jul 2019 10:37:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 6/6] e1000e: disable force K1-off feature
Date:   Tue, 23 Jul 2019 10:36:50 -0700
Message-Id: <20190723173650.23276-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
References: <20190723173650.23276-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

MAC-PHY desync may occur causing miss detection of link up event.
Disabling K1-off feature can work around the problem.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204057

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h      | 1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index eff75bd8a8f0..e3c71fd093ee 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -662,6 +662,7 @@ struct e1000_dev_spec_ich8lan {
 	bool kmrn_lock_loss_workaround_enabled;
 	struct e1000_shadow_ram shadow_ram[E1000_ICH8_SHADOW_RAM_WORDS];
 	bool nvm_k1_enabled;
+	bool disable_k1_off;
 	bool eee_disable;
 	u16 eee_lp_ability;
 	enum e1000_ulp_state ulp_state;
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index a1fab77b2096..6a9a4014f4b7 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1538,6 +1538,9 @@ static s32 e1000_check_for_copper_link_ich8lan(struct e1000_hw *hw)
 				fextnvm6 &= ~E1000_FEXTNVM6_K1_OFF_ENABLE;
 		}
 
+		if (hw->dev_spec.ich8lan.disable_k1_off == true)
+			fextnvm6 &= ~E1000_FEXTNVM6_K1_OFF_ENABLE;
+
 		ew32(FEXTNVM6, fextnvm6);
 	}
 
-- 
2.21.0

