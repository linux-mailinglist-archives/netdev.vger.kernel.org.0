Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3889D350A89
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhCaXHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhCaXHZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:25 -0400
IronPort-SDR: nkwTSH8mK5fG+l79vEox0snKqLLMienEtyK4Bjtic9H8k01H+hskyhxe1zd5g8hKEKey7oFyfT
 pjQZtwyx9WSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587978"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587978"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:23 -0700
IronPort-SDR: 1aB3S2p/OE6O4w6x2526Iy8fdVrb4kPbs9gWvCSDfI3QnGjxEeCkSnYzPTEyEy7Mtj5wzMCJux
 hJzqkLn6VcJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680113"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:23 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/15] ice: remove unnecessary duplicated AQ command flag setting
Date:   Wed, 31 Mar 2021 16:08:49 -0700
Message-Id: <20210331230858.782492-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Commit a012dca9f7a2 ("ice: add ethtool -m support for reading i2c eeprom
modules") unnecessarily added the ICE_AQ_FLAG_BUF flag to the descriptor
when sending the indirect Read/Write SFF EEPROM AQ command. The flag is
already added later in the code flow for all indirect AQ commands, i.e.
commands that provide an additional data buffer.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1898325e62b5..b906ca4dad36 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3186,7 +3186,7 @@ ice_aq_sff_eeprom(struct ice_hw *hw, u16 lport, u8 bus_addr,
 
 	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_sff_eeprom);
 	cmd = &desc.params.read_write_sff_param;
-	desc.flags = cpu_to_le16(ICE_AQ_FLAG_RD | ICE_AQ_FLAG_BUF);
+	desc.flags = cpu_to_le16(ICE_AQ_FLAG_RD);
 	cmd->lport_num = (u8)(lport & 0xff);
 	cmd->lport_num_valid = (u8)((lport >> 8) & 0x01);
 	cmd->i2c_bus_addr = cpu_to_le16(((bus_addr >> 1) &
-- 
2.26.2

