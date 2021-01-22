Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E150530104D
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbhAVWtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:49:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:1521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbhAVWrN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:47:13 -0500
IronPort-SDR: PTzu3FJhVZoktcAQhXpfPSQLxRIWgZ+Pc0l5QRRbvxocT251cY1yeGUq0ktrfQCDsRLOLFM7N+
 k/hayUXKLsxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="166619680"
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="166619680"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:21 -0800
IronPort-SDR: diCZ3bKC+I941d1S1EJaxDwWvJCisTKiaWRprxFfhMjnzGx7g3WtkC7ZdH7RCdKfLi9NzaCZeg
 ou3F9yquogtQ==
X-IronPort-AV: E=Sophos;i="5.79,367,1602572400"; 
   d="scan'208";a="355390560"
Received: from apalur-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.155.78])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 14:45:21 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v3 4/8] igc: Only dump registers if configured to dump HW information
Date:   Fri, 22 Jan 2021 14:44:49 -0800
Message-Id: <20210122224453.4161729-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122224453.4161729-1-vinicius.gomes@intel.com>
References: <20210122224453.4161729-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid polluting the users logs with register dumps, only dump the
adapter's registers if configured to do so.

If users want to enable HW status messages they can do:

$ ethtool -s IFACE msglvl hw on

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_dump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_dump.c b/drivers/net/ethernet/intel/igc/igc_dump.c
index 4b9ec7d0b727..90b754b429ff 100644
--- a/drivers/net/ethernet/intel/igc/igc_dump.c
+++ b/drivers/net/ethernet/intel/igc/igc_dump.c
@@ -308,6 +308,9 @@ void igc_regs_dump(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	struct igc_reg_info *reginfo;
 
+	if (!netif_msg_hw(adapter))
+		return;
+
 	/* Print Registers */
 	netdev_info(adapter->netdev, "Register Dump\n");
 	netdev_info(adapter->netdev, "Register Name   Value\n");
-- 
2.30.0

