Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50251DA606
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgETAEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:15430 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbgETAEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:32 -0400
IronPort-SDR: jshl26KQfCJ1pk7NVL/4vToa39Fop4jLJOvx/hNM4o0GeVl041GDOQPCe6Ox7mvY8Dt9VzVzrs
 i0CrWwfxwjHg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:22 -0700
IronPort-SDR: pelFi1fwfMz5pez2Ec/gQqJoF3DcwAVsmyl+dbmmFtM8cpNPYmHexpZgDG8Q/aqIEDKixw4r1d
 CyXtdhn3OVnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324777"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/14] igc: Return -EOPNOTSUPP when VLAN mask doesn't match
Date:   Tue, 19 May 2020 17:04:11 -0700
Message-Id: <20200520000419.1595788-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The I225 controller supports Rx queue assignment based on VLAN priority
only. Other Tag Control Information (TCI) are valid, but not supported
by the driver. So this patch changes the returning code from igc_add_
ethtool_nfc_entry() to -EOPNOTSUPP in order to provide more meaningful
information on why the function failed.

It also adds a debug messages to give the user a hint about what went
wrong with the NFC setup.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 19da9dc8dafb..f28f7feb39a5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1446,7 +1446,8 @@ static int igc_add_ethtool_nfc_entry(struct igc_adapter *adapter,
 
 	if ((fsp->flow_type & FLOW_EXT) && fsp->m_ext.vlan_tci) {
 		if (fsp->m_ext.vlan_tci != htons(VLAN_PRIO_MASK)) {
-			err = -EINVAL;
+			netdev_dbg(netdev, "VLAN mask not supported\n");
+			err = -EOPNOTSUPP;
 			goto err_out;
 		}
 		input->filter.vlan_tci = fsp->h_ext.vlan_tci;
-- 
2.26.2

