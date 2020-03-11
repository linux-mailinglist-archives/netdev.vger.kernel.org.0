Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF92181366
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 09:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgCKIiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 04:38:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:50106 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbgCKIiD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 04:38:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C72BBB1AE;
        Wed, 11 Mar 2020 08:38:01 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH 2/7] i40e: Use scnprintf() for avoiding potential buffer overflow
Date:   Wed, 11 Mar 2020 09:37:40 +0100
Message-Id: <20200311083745.17328-3-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200311083745.17328-1-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since snprintf() returns the would-be-output size instead of the
actual output size, the succeeding calls may go beyond the given
buffer limit.  Fix it by replacing with scnprintf().

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 24 ++++++++++++------------
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
2.16.4

