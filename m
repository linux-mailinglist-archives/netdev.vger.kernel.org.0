Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049562FAE29
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 01:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391322AbhASAmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 19:42:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:38527 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388992AbhASAls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 19:41:48 -0500
IronPort-SDR: LESk/8L3PjtEmZuVeVfDwToiYENnrHgPc2KMnKU3lSBOeAPcL3KcXcWTeiUZAGFI9e1NFkWyAB
 SQjpXkzwLlVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="179011259"
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="179011259"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:52 -0800
IronPort-SDR: UudlCTyGtEY0Bz2KWkpQOenq5yl2XESzJJPFRKkwpeLBdt6Ip2JQOr+farwewjietcwhgfJLnC
 7c2Gx0/aDp+w==
X-IronPort-AV: E=Sophos;i="5.79,357,1602572400"; 
   d="scan'208";a="426285772"
Received: from cemillan-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.57.184])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 16:40:52 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v2 4/8] igc: Only dump registers if configured to dump HW information
Date:   Mon, 18 Jan 2021 16:40:24 -0800
Message-Id: <20210119004028.2809425-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210119004028.2809425-1-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
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

