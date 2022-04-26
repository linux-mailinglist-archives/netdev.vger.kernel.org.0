Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DFC510A86
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 22:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354995AbiDZUgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 16:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354998AbiDZUgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 16:36:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C8D1A8C0E
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 13:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651005179; x=1682541179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cSSLaxBacTn3ItKqsi1igTEj40iLiILdXMEk/YygOJ4=;
  b=KWZJJOPm9Y3DA62yKF+gZ8lyXKdMsfl04+p4Bd4mQYS0cs7mgITBuZYC
   uEdtwGpuwq0gMPNHQrTuFTpPufVD5h4PgzIeIbmnFg0cVYmX5T3HkQBGQ
   HFE7GiplTH3RxVa+O1KPp1vPoXR7G3RCBYsnflPokmlz8FLaKeXDgWB+A
   Et7+ZT9QvcBvPdkKgxQKR9g3Fb/zCUR43+hod1nGk4qDSjUUByC1filmn
   RtPtEZBL0WIW5FzGjiyU2AqUdbZo0U7XUrAMpzlgl4KIGbiTyvaabeRUT
   JBnqIop36Zagu2rNowS8W0uHJ+caBFbu0PLoHB7T26SL/TqCXOGJ8tBXe
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="253090827"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="253090827"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:32:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="617174558"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 26 Apr 2022 13:32:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Petr Oros <poros@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 3/4] ice: wait 5 s for EMP reset after firmware flash
Date:   Tue, 26 Apr 2022 13:30:17 -0700
Message-Id: <20220426203018.3790378-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
References: <20220426203018.3790378-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Oros <poros@redhat.com>

We need to wait 5 s for EMP reset after firmware flash. Code was extracted
from OOT driver (ice v1.8.3 downloaded from sourceforge). Without this
wait, fw_activate let card in inconsistent state and recoverable only
by second flash/activate. Flash was tested on these fw's:
From -> To
 3.00 -> 3.10/3.20
 3.10 -> 3.00/3.20
 3.20 -> 3.00/3.10

Reproducer:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
71: ens7f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

dmesg after flash:
[   55.120788] ice: Copyright (c) 2018, Intel Corporation.
[   55.274734] ice 0000:ca:00.0: Get PHY capabilities failed status = -5, continuing anyway
[   55.569797] ice 0000:ca:00.0: The DDP package was successfully loaded: ICE OS Default Package version 1.3.28.0
[   55.603629] ice 0000:ca:00.0: Get PHY capability failed.
[   55.608951] ice 0000:ca:00.0: ice_init_nvm_phy_type failed: -5
[   55.647348] ice 0000:ca:00.0: PTP init successful
[   55.675536] ice 0000:ca:00.0: DCB is enabled in the hardware, max number of TCs supported on this port are 8
[   55.685365] ice 0000:ca:00.0: FW LLDP is disabled, DCBx/LLDP in SW mode.
[   55.692179] ice 0000:ca:00.0: Commit DCB Configuration to the hardware
[   55.701382] ice 0000:ca:00.0: 126.024 Gb/s available PCIe bandwidth, limited by 16.0 GT/s PCIe x8 link at 0000:c9:02.0 (capable of 252.048 Gb/s with 16.0 GT/s PCIe x16 link)
Reboot doesn’t help, only second flash/activate with OOT or patched
driver put card back in consistent state.

After patch:
[root@host ~]# devlink dev flash pci/0000:ca:00.0 file E810_XXVDA4_FH_O_SEC_FW_1p6p1p9_NVM_3p10_PLDMoMCTP_0.11_8000AD7B.bin
Preparing to flash
[fw.mgmt] Erasing
[fw.mgmt] Erasing done
[fw.mgmt] Flashing 100%
[fw.mgmt] Flashing done 100%
[fw.undi] Erasing
[fw.undi] Erasing done
[fw.undi] Flashing 100%
[fw.undi] Flashing done 100%
[fw.netlist] Erasing
[fw.netlist] Erasing done
[fw.netlist] Flashing 100%
[fw.netlist] Flashing done 100%
Activate new firmware by devlink reload
[root@host ~]# devlink dev reload pci/0000:ca:00.0 action fw_activate
reload_actions_performed:
    fw_activate
[root@host ~]# ip link show ens7f0
19: ens7f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether b4:96:91:dc:72:e0 brd ff:ff:ff:ff:ff:ff
    altname enp202s0f0

Fixes: 399e27dbbd9e94 ("ice: support immediate firmware activation via devlink reload")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 5b1198859da7..9a0a358a15c2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6929,12 +6929,15 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 
 	dev_dbg(dev, "rebuilding PF after reset_type=%d\n", reset_type);
 
+#define ICE_EMP_RESET_SLEEP_MS 5000
 	if (reset_type == ICE_RESET_EMPR) {
 		/* If an EMP reset has occurred, any previously pending flash
 		 * update will have completed. We no longer know whether or
 		 * not the NVM update EMP reset is restricted.
 		 */
 		pf->fw_emp_reset_disabled = false;
+
+		msleep(ICE_EMP_RESET_SLEEP_MS);
 	}
 
 	err = ice_init_all_ctrlq(hw);
-- 
2.31.1

