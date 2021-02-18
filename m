Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7131F30C
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 00:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBRX0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 18:26:18 -0500
Received: from mga12.intel.com ([192.55.52.136]:20043 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229952AbhBRXZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 18:25:58 -0500
IronPort-SDR: JddD6dnXMx7U4t2LFIjeMUmezodMzqepHh9qUOcNp/aW9aS8oA5dpbHwjgslLRW8BlNzX5GQt1
 5c34XaSfBrjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9899"; a="162823074"
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="162823074"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2021 15:24:08 -0800
IronPort-SDR: K3q5U8Kf80c++2eEHqv0v8cF2Oa9ghFrqKV9zBB8eiX55WnSCV937p8eaJHFZswFGGlrihp8GJ
 MQ/CdSfSha2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,187,1610438400"; 
   d="scan'208";a="581457649"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 18 Feb 2021 15:24:08 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 7/8] i40e: Fix add TC filter for IPv6
Date:   Thu, 18 Feb 2021 15:25:03 -0800
Message-Id: <20210218232504.2422834-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
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

Fixes: 2f4b411a3d67("i40e: Enable cloud filters via tc-flower")
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

