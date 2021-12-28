Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A8480C83
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 19:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhL1SZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 13:25:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:29449 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237027AbhL1SZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 13:25:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640715905; x=1672251905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jCbSOb7D3ACGo8X1FFMKpIcfwzs0tg6Z20Q5aWCAVgY=;
  b=cev7WlJovRP4Wv7Ru0HWkyE4/MbgFksIscwg1+fWK1Kh8ulfejOVQZCT
   e6HPO3kyoPf+ECtBStSRcDFU7aXsEKLag//e0DCL08cRJiwTTrC25H6zm
   LTv4tEzipE6LeBlBNoHRGHux8LziZFPfYMJp0yZb6Hx5MjqbCYd9JEeK4
   lBDg5Q2sk9H/eaG2zfZHunD4IlCBTBOpik/53vAZFRlzcVHpD252wnAMY
   hMkpuobirczkMNoRk1/Hk7r/eqI07a2JGv66XxHRnwHc7FuL7Pu5DqDiz
   huTVE7fl3twiDys5I19Y/9h4wadWxl3Dfhxf6xtoJ0c+zrVw8VOhVfeIE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="241206670"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="241206670"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 10:25:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="666075955"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 28 Dec 2021 10:25:04 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Stefan Dietrich <roots@gmx.de>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net 1/2] igc: Do not enable crosstimestamping for i225-V models
Date:   Tue, 28 Dec 2021 10:24:20 -0800
Message-Id: <20211228182421.340354-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
References: <20211228182421.340354-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

It was reported that when PCIe PTM is enabled, some lockups could
be observed with some integrated i225-V models.

While the issue is investigated, we can disable crosstimestamp for
those models and see no loss of functionality, because those models
don't have any support for time synchronization.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Link: https://lore.kernel.org/all/924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de/
Reported-by: Stefan Dietrich <roots@gmx.de>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.31.1

