Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14CD71E5891
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 09:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgE1H0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 03:26:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:14688 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgE1HZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 03:25:43 -0400
IronPort-SDR: rShPbcCzwNNeSWwiVErAzntTJRbh7QDk4q1LA6NQeLMLGWDF7mKw1sn1vaTreX4qyrP9c/81AD
 0SmkHe9C/Lcw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 00:25:41 -0700
IronPort-SDR: KR+agwGUFfHLpMEDupRLvFfva1FAg41vKV71X9dJLNOt1CYj5JW59b3yQR42ogh5ulVLFIrTYf
 NbmwPHBybY+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,443,1583222400"; 
   d="scan'208";a="310831104"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2020 00:25:41 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: set VF default LAN address
Date:   Thu, 28 May 2020 00:25:26 -0700
Message-Id: <20200528072538.1621790-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
References: <20200528072538.1621790-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Remove is_zero_ether_add() check when setting the VF default LAN address.
This check assumed that the address had been delete and zeroed before
calling ice_vc_add_mac_addr(). Now the default LAN address will be set
to the last unicast MAC address added by the VF.

The default LAN address is reported by the PF via ndo_get_vf_config.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 9b09a111321c..efd54299a220 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2862,9 +2862,11 @@ ice_vc_add_mac_addr(struct ice_vf *vf, struct ice_vsi *vsi, u8 *mac_addr)
 		return -EIO;
 	}
 
-	/* only set dflt_lan_addr once */
-	if (is_zero_ether_addr(vf->dflt_lan_addr.addr) &&
-	    is_unicast_ether_addr(mac_addr))
+	/* Set the default LAN address to the latest unicast MAC address added
+	 * by the VF. The default LAN address is reported by the PF via
+	 * ndo_get_vf_config.
+	 */
+	if (is_unicast_ether_addr(mac_addr))
 		ether_addr_copy(vf->dflt_lan_addr.addr, mac_addr);
 
 	vf->num_mac++;
-- 
2.26.2

