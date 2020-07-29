Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296AB2322A2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgG2QYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:44892 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2QYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:13 -0400
IronPort-SDR: /VyFxqMyiDGLbyWq/KM/+Q3MD6TVzGWX5edj6s7PRLhm7/pcOUKuMciPKIU1djsnCetUT9QLAz
 p8m4elauVi4Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="169570874"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="169570874"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:12 -0700
IronPort-SDR: T9yigmdQLQa1o5j9ML6WihMWrLSFiVrCKNCtGTFN3b4qU2YvUe6/eeQMrp/FWkxsu+xBNadhnf
 bTyhC1+BkoGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087549"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 02/15] ice: Fix link broken after GLOBR reset
Date:   Wed, 29 Jul 2020 09:23:52 -0700
Message-Id: <20200729162405.1596435-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

After a GLOBR, the link was broken so that a link
up situation was being seen as a link down.

The problem was that the rebuild process was updating
the port_info link status without doing any of the
other things that need to be done when link changes.

This was causing the port_info struct to have current
"UP" information so that any further UP interrupts
were skipped as redundant.

The rebuild flow should *not* be updating the port_info
struct link information, so eliminate this and leave
it to the link event handling code.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fe0982d0717d..7b70ab3703a7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5913,10 +5913,6 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
 	if (err)
 		goto err_sched_init_port;
 
-	err = ice_update_link_info(hw->port_info);
-	if (err)
-		dev_err(dev, "Get link status error %d\n", err);
-
 	/* start misc vector */
 	err = ice_req_irq_msix_misc(pf);
 	if (err) {
-- 
2.26.2

