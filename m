Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E561B1B5B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDUBtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:49:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:47086 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgDUBtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 21:49:35 -0400
IronPort-SDR: skJveERaMGJqkDMuFBLK1+McM5Uja4lVuQ/R4PSSXwT27CgjyLRSStACHD1cAYKOAbvxAZVf1s
 TwHdcM8dIuYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 18:49:35 -0700
IronPort-SDR: wFEkgGAdtpOWcAKeP5SEjk2w4jXnZa8DVtDCtWNlMDMJzhGImbXtQEo6/7FMw9uXe+TF60ZSGl
 0NP+7vhb53bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="291449657"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2020 18:49:35 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Takashi Iwai <tiwai@suse.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 1/4] i40e: Use scnprintf() for avoiding potential buffer overflow
Date:   Mon, 20 Apr 2020 18:49:29 -0700
Message-Id: <20200421014932.2743607-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
References: <20200421014932.2743607-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 24 ++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8c3e753bfb9d..ff431c13f858 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14478,29 +14478,29 @@ static void i40e_print_features(struct i40e_pf *pf)
 
 	i = snprintf(buf, INFO_STRING_LEN, "Features: PF-id[%d]", hw->pf_id);
 #ifdef CONFIG_PCI_IOV
-	i += snprintf(&buf[i], REMAIN(i), " VFs: %d", pf->num_req_vfs);
+	i += scnprintf(&buf[i], REMAIN(i), " VFs: %d", pf->num_req_vfs);
 #endif
-	i += snprintf(&buf[i], REMAIN(i), " VSIs: %d QP: %d",
+	i += scnprintf(&buf[i], REMAIN(i), " VSIs: %d QP: %d",
 		      pf->hw.func_caps.num_vsis,
 		      pf->vsi[pf->lan_vsi]->num_queue_pairs);
 	if (pf->flags & I40E_FLAG_RSS_ENABLED)
-		i += snprintf(&buf[i], REMAIN(i), " RSS");
+		i += scnprintf(&buf[i], REMAIN(i), " RSS");
 	if (pf->flags & I40E_FLAG_FD_ATR_ENABLED)
-		i += snprintf(&buf[i], REMAIN(i), " FD_ATR");
+		i += scnprintf(&buf[i], REMAIN(i), " FD_ATR");
 	if (pf->flags & I40E_FLAG_FD_SB_ENABLED) {
-		i += snprintf(&buf[i], REMAIN(i), " FD_SB");
-		i += snprintf(&buf[i], REMAIN(i), " NTUPLE");
+		i += scnprintf(&buf[i], REMAIN(i), " FD_SB");
+		i += scnprintf(&buf[i], REMAIN(i), " NTUPLE");
 	}
 	if (pf->flags & I40E_FLAG_DCB_CAPABLE)
-		i += snprintf(&buf[i], REMAIN(i), " DCB");
-	i += snprintf(&buf[i], REMAIN(i), " VxLAN");
-	i += snprintf(&buf[i], REMAIN(i), " Geneve");
+		i += scnprintf(&buf[i], REMAIN(i), " DCB");
+	i += scnprintf(&buf[i], REMAIN(i), " VxLAN");
+	i += scnprintf(&buf[i], REMAIN(i), " Geneve");
 	if (pf->flags & I40E_FLAG_PTP)
-		i += snprintf(&buf[i], REMAIN(i), " PTP");
+		i += scnprintf(&buf[i], REMAIN(i), " PTP");
 	if (pf->flags & I40E_FLAG_VEB_MODE_ENABLED)
-		i += snprintf(&buf[i], REMAIN(i), " VEB");
+		i += scnprintf(&buf[i], REMAIN(i), " VEB");
 	else
-		i += snprintf(&buf[i], REMAIN(i), " VEPA");
+		i += scnprintf(&buf[i], REMAIN(i), " VEPA");
 
 	dev_info(&pf->pdev->dev, "%s\n", buf);
 	kfree(buf);
-- 
2.25.3

