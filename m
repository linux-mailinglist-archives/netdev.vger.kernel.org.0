Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE592320056
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 22:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBSVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 16:35:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:59577 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhBSVfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 16:35:48 -0500
IronPort-SDR: S3qVdV4czJlunmouRuzKheNtdkqbig2T0T1Jc3/NXSbrhZHJ0z2a/8HOcQtB3OdqZOg0TUcjS2
 o/ng0O2lgwSQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9900"; a="184028684"
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="184028684"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2021 13:35:07 -0800
IronPort-SDR: knytwoxVax7ZnCUqqzp76jDRje4oIyMXE0qjfidCcVQ8ESrgFGeu4Ct7/YypcHAjdwF+zLf9cG
 Emc4rKSlIZEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,191,1610438400"; 
   d="scan'208";a="428012042"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Feb 2021 13:35:06 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 7/8] i40e: Fix add TC filter for IPv6
Date:   Fri, 19 Feb 2021 13:36:05 -0800
Message-Id: <20210219213606.2567536-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
References: <20210219213606.2567536-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

Fix insufficient distinction between IPv4 and IPv6 addresses
when creating a filter.
IPv4 and IPv6 are kept in the same memory area. If IPv6 is added,
then it's caught by IPv4 check, which leads to err -95.

Fixes: 2f4b411a3d67 ("i40e: Enable cloud filters via tc-flower")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Reviewed-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2e22ab5a0f9a..3e4a4d6f0419 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7731,7 +7731,8 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 		return -EOPNOTSUPP;
 
 	/* adding filter using src_port/src_ip is not supported at this stage */
-	if (filter->src_port || filter->src_ipv4 ||
+	if (filter->src_port ||
+	    (filter->src_ipv4 && filter->n_proto != ETH_P_IPV6) ||
 	    !ipv6_addr_any(&filter->ip.v6.src_ip6))
 		return -EOPNOTSUPP;
 
@@ -7760,7 +7761,7 @@ int i40e_add_del_cloud_filter_big_buf(struct i40e_vsi *vsi,
 			cpu_to_le16(I40E_AQC_ADD_CLOUD_FILTER_MAC_VLAN_PORT);
 		}
 
-	} else if (filter->dst_ipv4 ||
+	} else if ((filter->dst_ipv4 && filter->n_proto != ETH_P_IPV6) ||
 		   !ipv6_addr_any(&filter->ip.v6.dst_ip6)) {
 		cld_filter.element.flags =
 				cpu_to_le16(I40E_AQC_ADD_CLOUD_FILTER_IP_PORT);
-- 
2.26.2

