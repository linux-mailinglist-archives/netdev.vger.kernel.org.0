Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E52304DAA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387647AbhAZXNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:24 -0500
Received: from mga14.intel.com ([192.55.52.115]:62464 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbhAZWKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:10:53 -0500
IronPort-SDR: cbdvBp7Tj3Kj1hbOIdPlHdRwD4OoRwacHgGdxfoH63jJx5PwbUH7HwbgwBmdIhH7yGJIsR5O07
 U53nbE1vyICw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="179198673"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="179198673"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:10:00 -0800
IronPort-SDR: qf8+l82MzLQR4zaOn2sfrQeeANgcWmkonW7VBa5/5gEuZk7WRHvLbRUyUsto+x2TTR9K7VkgaL
 11miXBwg3hAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="472908304"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 26 Jan 2021 14:10:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net v2 1/7] ice: fix FDir IPv6 flexbyte
Date:   Tue, 26 Jan 2021 14:10:29 -0800
Message-Id: <20210126221035.658124-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

The packet classifier would occasionally misrecognize an IPv6 training
packet when the next protocol field was 0. The correct value for
unspecified protocol is IPPROTO_NONE.

Fixes: 165d80d6adab ("ice: Support IPv6 Flow Director filters")
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 2d27f66ac853..192729546bbf 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1576,7 +1576,13 @@ ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 		       sizeof(struct in6_addr));
 		input->ip.v6.l4_header = fsp->h_u.usr_ip6_spec.l4_4_bytes;
 		input->ip.v6.tc = fsp->h_u.usr_ip6_spec.tclass;
-		input->ip.v6.proto = fsp->h_u.usr_ip6_spec.l4_proto;
+
+		/* if no protocol requested, use IPPROTO_NONE */
+		if (!fsp->m_u.usr_ip6_spec.l4_proto)
+			input->ip.v6.proto = IPPROTO_NONE;
+		else
+			input->ip.v6.proto = fsp->h_u.usr_ip6_spec.l4_proto;
+
 		memcpy(input->mask.v6.dst_ip, fsp->m_u.usr_ip6_spec.ip6dst,
 		       sizeof(struct in6_addr));
 		memcpy(input->mask.v6.src_ip, fsp->m_u.usr_ip6_spec.ip6src,
-- 
2.26.2

