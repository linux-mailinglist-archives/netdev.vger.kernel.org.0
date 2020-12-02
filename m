Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAAA32CB41B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgLBEzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:55:01 -0500
Received: from mga04.intel.com ([192.55.52.120]:43298 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgLBEzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:55:01 -0500
IronPort-SDR: 7dnsrE+u5IHG6LF3UX4ISRDTWgXOaE3HuFr4hqvX0tH6Le7PlyNupwCB9wzfFPpSm146iRnPfX
 /59kj7U3Uk2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387535"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387535"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:49 -0800
IronPort-SDR: 1rSTdOIIXv890nNG4Q4YJsPOSGtf6FT0SovW3Ac16DuCvelHLyL1Oad0ZPOP93R4ZlwgcjTkV0
 pyDjV4XAxACQ==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888374"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:48 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 4/9] igc: Only dump registers if configured to dump HW information
Date:   Tue,  1 Dec 2020 20:53:20 -0800
Message-Id: <20201202045325.3254757-5-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
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
2.29.2

