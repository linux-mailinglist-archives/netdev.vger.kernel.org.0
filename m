Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9BB4739A9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhLNAkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:40:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:53360 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234762AbhLNAkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 19:40:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639442409; x=1670978409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5/cjF2sgrOswGzjeVmoff0QHN1CsFuA/GB4LACTxm3A=;
  b=XqE4+99tpXPB+PczoL8FcaxlPTviUeFpun+F2bduIKDkOIRCpPqb2FU9
   ac48S2vdQVIoO5zZxuP0OmmXB7ghD2xaA0YT4Z5ON9nVZdTFRDxLUZ0X0
   m2ot2CtRJXEw30hZMknWnCVq+SNzQfBLtZeNkzfdTaH712bokzC4VqQRN
   nfR30pooexJKYKlY42L9CT2ILUePcjOiycIiTKJkBN71FuAoWb1hJDgKl
   RWTmjnvXS/7d/oyRkbMA+VPDQLho8CJjowdxmOIaOPCMnE+h1HYtXecrL
   3tI9uIQ9V2b6cm7pwNNSO169YhdtzF09o1GCaZgk77Dvm53Ca4/W+tbFT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="237599602"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="237599602"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:40:09 -0800
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="604047271"
Received: from vcostago-mobl3.jf.intel.com ([10.24.14.56])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:40:09 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, roots@gmx.de, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, regressions@leemhuis.info,
        greg@kroah.com, kuba@kernel.org
Subject: [PATCH net v1] igc: Do not enable crosstimestamping for i225-V models
Date:   Mon, 13 Dec 2021 16:39:49 -0800
Message-Id: <20211214003949.666642-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <87wnk8qrt8.fsf@intel.com>
References: <87wnk8qrt8.fsf@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that when PCIe PTM is enabled, some lockups could
be observed with some integrated i225-V models.

While the issue is investigated, we can disable crosstimestamp for
those models and see no loss of functionality, because those models
don't have any support for time synchronization.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Link: https://lore.kernel.org/all/924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de/
Reported-by: Stefan Dietrich <roots@gmx.de>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 30568e3544cd..4f9245aa79a1 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -768,7 +768,20 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
  */
 static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
 {
-	return IS_ENABLED(CONFIG_X86_TSC) ? pcie_ptm_enabled(adapter->pdev) : false;
+	if (!IS_ENABLED(CONFIG_X86_TSC))
+		return false;
+
+	/* FIXME: it was noticed that enabling support for PCIe PTM in
+	 * some i225-V models could cause lockups when bringing the
+	 * interface up/down. There should be no downsides to
+	 * disabling crosstimestamping support for i225-V, as it
+	 * doesn't have any PTP support. That way we gain some time
+	 * while root causing the issue.
+	 */
+	if (adapter->pdev->device == IGC_DEV_ID_I225_V)
+		return false;
+
+	return pcie_ptm_enabled(adapter->pdev);
 }
 
 static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
-- 
2.34.1

