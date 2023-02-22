Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB16D69FE92
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbjBVWgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjBVWgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:36:09 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B116343463
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 14:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677105363; x=1708641363;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kZsSD2z2oG5ohf3bCceNLITp54qfXfnD7f1D0PHzPck=;
  b=d5InE5gWCZjiBkam0z1KgDlfJEwbnMJhHJp/b2o44g93aDmcB0UT5ZB6
   Z8lmNpUwsxwKTEaFnzjvRhHDZhGeJaySOF8ym2rVrHoK+mlKzGhtJzuNv
   e6gyvnmPgB7MI0u6VWFVdGefADrEDO9VmnaMymFVjOaWYv7SyL8L5b6+E
   nVpptiIAFrS115wJH7YXbPbvaYJpGTKPQWf2LSm0NoDzFImd/tWvre6YP
   D2PpADrmoG2In2po7xrMrvjKxV9JCWhnFm01fA/HjG+YCMzZVeWieXEMF
   Al0s4uWucCov7zDQWp/WzRVXZsOShFrTMKjNPfHkaaBiow5g2g6t/m786
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419281492"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="419281492"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 14:36:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="917726227"
X-IronPort-AV: E=Sophos;i="5.97,319,1669104000"; 
   d="scan'208";a="917726227"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.1])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 14:36:02 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>
Cc:     netdev@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>
Subject: [intel-net] ice: remove unnecessary CONFIG_ICE_GNSS
Date:   Wed, 22 Feb 2023 14:35:58 -0800
Message-Id: <20230222223558.2328428-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f83
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
driver is enabled when GNSS is enabled, while ensuring that ICE = y and
GNSS = m don't break.

The complaint from Olek about the original IS_REACHABLE was due to the
required IS_REACHABLE checks throughout the ice driver code and the fact
that ice_gnss.c was compiled regardless of GNSS support.

This can be fixed in the Makefile by using ice-$(CONFIG_GNSS) += ice_gnss.o

If GNSS = m, then this will add ice_gnss.o to ice-m, which will be ignored
if we're not compiling ice as a module, and thus we will skip compiling
GNSS code just as with CONFIG_ICE_GNSS.

Drop CONFIG_ICE_GNSS, and replace the IS_ENABLED checks for it with
IS_REACHABLE checks for GNSS. Update the Makefile to add the ice_gnss.o
object based on CONFIG_GNSS.

This works on my system to ensure that GNSS support is optionally included
without any need for additional config options, and it works correctly in
at least the following configurations:

1. CONFIG_ICE = m, CONFIG_GNSS = m
2. CONFIG_ICE = y, CONFIG_GNSS = m
3. CONFIG_ICE = m, CONFIG_GNSS = y

This solution should resolve the complains Olek made regarding compilation
of ice_gnss.o and additional unnecessary IS_REACHABLE checks, while also
avoiding extra config flags.

[1] https://lore.kernel.org/intel-wired-lan/20221019095603.44825-1-arkadiusz.kubalewski@intel.com/
[2] https://lore.kernel.org/intel-wired-lan/20221028165706.96849-1-alexandr.lobakin@intel.com/
[3] https://lore.kernel.org/all/CAHk-=wi_410KZqHwF-WL5U7QYxnpHHHNP-3xL=g_y89XnKc-uw@mail.gmail.com/

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Fixes: c7ef8221ca7d ("ice: use GNSS subsystem instead of TTY")
Acked-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Anthony Nguyen <anthony.l.nguyen@intel.com>
---

I'm sending to both Intel-wired-lan and netdev lists since this was
discussed publicly on the netdev list. I'm not sure how we want to queue it
up, so I currently have it tagged as intel-net to go through Tony's IWL
tree. I'm happy however it gets pulled. I believe this is the best solution
as the total number of #ifdefs is the same as with CONFIG_ICE_GNSS, as is
the Makefile line. As far as I can tell the Kbuild just does the right thing
here so there is no need for an additional flag.

I'm happy to respin with a "depends" check if we think the flag has other
value.

 drivers/net/ethernet/intel/Kconfig        | 3 ---
 drivers/net/ethernet/intel/ice/Makefile   | 2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h | 4 ++--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index a3c84bf05e44..3facb55b7161 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -337,9 +337,6 @@ config ICE_HWTS
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
index 31db0701d13f..d453987492f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -45,7 +45,7 @@ struct gnss_serial {
 	struct list_head queue;
 };
 
-#if IS_ENABLED(CONFIG_ICE_GNSS)
+#if IS_REACHABLE(CONFIG_GNSS)
 void ice_gnss_init(struct ice_pf *pf);
 void ice_gnss_exit(struct ice_pf *pf);
 bool ice_gnss_is_gps_present(struct ice_hw *hw);
@@ -56,5 +56,5 @@ static inline bool ice_gnss_is_gps_present(struct ice_hw *hw)
 {
 	return false;
 }
-#endif /* IS_ENABLED(CONFIG_ICE_GNSS) */
+#endif /* IS_REACHABLE(CONFIG_GNSS) */
 #endif /* _ICE_GNSS_H_ */

base-commit: 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2
-- 
2.39.1.405.gd4c25cc71f83

