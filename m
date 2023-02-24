Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108AE6A1469
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjBXAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBXAqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:46:38 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 153C91C591
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677199597; x=1708735597;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wjrxFydd26W+W6S34yIVvUMESUfxGjN2yVY+QSRvww8=;
  b=EunmdeD88lfoK6GGTfMdEC//dKVTwgQRw/Bz4+priExc5xvZt6lh7BMN
   kq6JAKTJq/wIi9vMhvllhlXFlI0pD2J0QeDDTFMMnn0l1iSshxBg+TiHM
   cz0bd57edXSnW04VDzdFzqRZFTKIBn/MUV0I37/FpjezF711N1MM6+U4P
   5kV1fCrswguh67Xa8rzGX1CC67CzSzpYBDeMO6NBVB2FmSNtPc+QtLO2M
   X9XW6fd9M8pP585dfbM7Z8tadpn5GCMdU4oU6SWmAu/cbp9IMBUFS0j8C
   5AxaGs/VmoXKVQcwiSEfPqhGz6kaC4phe+qQQrA8QdzuNxRbxSAOmorqy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="321559346"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="321559346"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 16:46:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="741477890"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="741477890"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.1])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 16:46:35 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH intel-net v2] ice: remove unnecessary CONFIG_ICE_GNSS
Date:   Thu, 23 Feb 2023 16:46:27 -0800
Message-Id: <20230224004627.2281371-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CONFIG_ICE_GNSS was added by commit c7ef8221ca7d ("ice: use GNSS subsystem
instead of TTY") as a way to allow the ice driver to optionally support
GNSS features without forcing a dependency on CONFIG_GNSS.

The original implementation of that commit at [1] used IS_REACHABLE. This
was rejected by Olek at [2] with the suggested implementation of
CONFIG_ICE_GNSS.

Eventually after merging, Linus reported a .config which had
CONFIG_ICE_GNSS = y when both GNSS = n and ICE = n. This confused him and
he felt that the config option was not useful, and commented about it at
[3].

CONFIG_ICE_GNSS is defined to y whenever GNSS = ICE. This results in it
being set in cases where both options are not enabled.

The goal of CONFIG_ICE_GNSS is to ensure that the GNSS support in the ice
driver is enabled when GNSS is enabled.

The complaint from Olek about the original IS_REACHABLE was due to the
required IS_REACHABLE checks throughout the ice driver code and the fact
that ice_gnss.c was compiled regardless of GNSS support.

This can be fixed in the Makefile by using ice-$(CONFIG_GNSS) += ice_gnss.o

In this case, if GNSS = m and ICE = y, we can result in some confusing
behavior where GNSS support is not enabled because its not built in. See
[4].

To disallow this, have CONFIG_ICE depend on GNSS || GNSS = n. This ensures
that we cannot enable CONFIG_ICE as builtin while GNSS is a module.

Drop CONFIG_ICE_GNSS, and replace the IS_ENABLED checks for it with
checks for GNSS. Update the Makefile to add the ice_gnss.o object based on
CONFIG_GNSS.

This works to ensure that GNSS support can optionally be enabled, doesn't
have an unnnecessary extra config option, and has Kbuild enforce the
dependency such that you can't accidentally enable GNSS as a module and ICE
as a builtin.

[1] https://lore.kernel.org/intel-wired-lan/20221019095603.44825-1-arkadiusz.kubalewski@intel.com/
[2] https://lore.kernel.org/intel-wired-lan/20221028165706.96849-1-alexandr.lobakin@intel.com/
[3] https://lore.kernel.org/all/CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com/
[4] https://lore.kernel.org/netdev/20230223161309.0e439c5f@kernel.org/

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Fixes: c7ef8221ca7d ("ice: use GNSS subsystem instead of TTY")
Cc: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Anthony Nguyen <anthony.l.nguyen@intel.com>
---
Changes since v1:
* Added "depends on GNSS || GNSS = n"
* Use IS_ENABLED instead of IS_REACHABLE in ice_gnss.h
* Dropped the Acked-by's since I've changed the approach

 drivers/net/ethernet/intel/Kconfig        | 4 +---
 drivers/net/ethernet/intel/ice/Makefile   | 2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h | 4 ++--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index a3c84bf05e44..c18c3b373846 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -296,6 +296,7 @@ config ICE
 	default n
 	depends on PCI_MSI
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on GNSS || GNSS = n
 	select AUXILIARY_BUS
 	select DIMLIB
 	select NET_DEVLINK
@@ -337,9 +338,6 @@ config ICE_HWTS
 	  the PTP clock driver precise cross-timestamp ioctl
 	  (PTP_SYS_OFFSET_PRECISE).
 
-config ICE_GNSS
-	def_bool GNSS = y || GNSS = ICE
-
 config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index f269952d207d..5d89392f969b 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -47,4 +47,4 @@ ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
 ice-$(CONFIG_RFS_ACCEL) += ice_arfs.o
 ice-$(CONFIG_XDP_SOCKETS) += ice_xsk.o
 ice-$(CONFIG_ICE_SWITCHDEV) += ice_eswitch.o
-ice-$(CONFIG_ICE_GNSS) += ice_gnss.o
+ice-$(CONFIG_GNSS) += ice_gnss.o
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index 31db0701d13f..4d49e5b0b4b8 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -45,7 +45,7 @@ struct gnss_serial {
 	struct list_head queue;
 };
 
-#if IS_ENABLED(CONFIG_ICE_GNSS)
+#if IS_ENABLED(CONFIG_GNSS)
 void ice_gnss_init(struct ice_pf *pf);
 void ice_gnss_exit(struct ice_pf *pf);
 bool ice_gnss_is_gps_present(struct ice_hw *hw);
@@ -56,5 +56,5 @@ static inline bool ice_gnss_is_gps_present(struct ice_hw *hw)
 {
 	return false;
 }
-#endif /* IS_ENABLED(CONFIG_ICE_GNSS) */
+#endif /* IS_ENABLED(CONFIG_GNSS) */
 #endif /* _ICE_GNSS_H_ */

base-commit: 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
-- 
2.39.1.405.gd4c25cc71f83

