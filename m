Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AAC88281
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436743AbfHIScE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:32:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:55689 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436582AbfHISbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 14:31:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 11:31:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175229917"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 11:31:43 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Do not always bring up PF VSI in ice_ena_vsi()
Date:   Fri,  9 Aug 2019 11:31:33 -0700
Message-Id: <20190809183139.30871-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

During rebuild ice_ena_vsi() is called to recover the VSI state.
This function assumes the PF VSI is always to be enabled, however,
it's possible that during reset/rebuild the interface can be
brought down.  If this occurs, we can attempt to bring up the PF
VSI on a downed interface which can lead to various crashes. If
the interface is not running, do not bring up the associated VSI.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f6926cbb48a4..8407eeafbc41 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3737,8 +3737,6 @@ static int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 				err = netd->netdev_ops->ndo_open(netd);
 				rtnl_unlock();
 			}
-		} else {
-			err = ice_vsi_open(vsi);
 		}
 	}
 
-- 
2.21.0

