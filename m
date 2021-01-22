Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14E5301158
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbhAWACM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:02:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:38839 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbhAWABG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:01:06 -0500
IronPort-SDR: Ep6TT5Jvc0xo4EacEbbZcxg5SxCuy9ZBpNlx7VMlw10Xwm3DUBk43A9KlsYTATUiTzQBLyGNxy
 qsbqeJjbgH8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9872"; a="179670512"
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="179670512"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 15:57:02 -0800
IronPort-SDR: u3YvkFO6Mqi6sCQzco2VNuzvX8290c9DPCQU1XRx/2JJPxqO0kcY8dwlgfQmAC+mQzrE6U6Wfl
 eFypZ/oh2CLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,368,1602572400"; 
   d="scan'208";a="428258682"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 22 Jan 2021 15:57:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Henry Tieman <henry.w.tieman@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 1/7] ice: fix FDir IPv6 flexbyte
Date:   Fri, 22 Jan 2021 15:57:28 -0800
Message-Id: <20210122235734.447240-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
References: <20210122235734.447240-1-anthony.l.nguyen@intel.com>
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

