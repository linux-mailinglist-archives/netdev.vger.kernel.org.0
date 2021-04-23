Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53E75369744
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242868AbhDWQlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:13567 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhDWQl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:28 -0400
IronPort-SDR: hz+y4AT+VcE08OLyk9v73bpb677cI8jnwRVnZksl+EWr5Vy1iF1poIZU3yhbPDzuqrEpp39HPy
 xlaaS/WXx+zQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218635"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218635"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:52 -0700
IronPort-SDR: nIekR9G//K6Bbaz6sXUeTkG3sCUzHBhiaxiTB7fODNzoqsbbIzViY8NsO64UjcWRBORPT2YTNz
 VJzGab01TSMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285962"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Coiby Xu <coxu@redhat.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 2/8] i40e: use minimal Tx and Rx pairs for kdump
Date:   Fri, 23 Apr 2021 09:42:41 -0700
Message-Id: <20210423164247.3252913-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Coiby Xu <coxu@redhat.com>

Set the number of the MSI-X vectors to 1. When MSI-X is enabled,
it's not allowed to use more TC queue pairs than MSI-X vectors
(pf->num_lan_msix) exist. Thus the number of Tx and Rx pairs
(vsi->num_queue_pairs) will be equal to the number of MSI-X vectors,
i.e., 1.

Signed-off-by: Coiby Xu <coxu@redhat.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 687ef52a8116..b51b8e25501d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -6,6 +6,7 @@
 #include <linux/pci.h>
 #include <linux/bpf.h>
 #include <generated/utsrelease.h>
+#include <linux/crash_dump.h>
 
 /* Local includes */
 #include "i40e.h"
@@ -15506,6 +15507,14 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_switch_setup;
 
+	/* Reduce Tx and Rx pairs for kdump
+	 * When MSI-X is enabled, it's not allowed to use more TC queue
+	 * pairs than MSI-X vectors (pf->num_lan_msix) exist. Thus
+	 * vsi->num_queue_pairs will be equal to pf->num_lan_msix, i.e., 1.
+	 */
+	if (is_kdump_kernel())
+		pf->num_lan_msix = 1;
+
 	pf->udp_tunnel_nic.set_port = i40e_udp_tunnel_set_port;
 	pf->udp_tunnel_nic.unset_port = i40e_udp_tunnel_unset_port;
 	pf->udp_tunnel_nic.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP;
-- 
2.26.2

