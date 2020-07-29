Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97D823229C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgG2QYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:24:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:42163 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgG2QYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:18 -0400
IronPort-SDR: j/LWCZvCglpLs7Y/KiiXzOwli7V9z1HT53PbnevFB0x2Hw1vB946EWPYw4e032wddqsAIv5EoD
 ALDDxbMk8IdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9697"; a="212982349"
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="212982349"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2020 09:24:17 -0700
IronPort-SDR: KSQ3JM76ij23DaSfoi8ukp3zNSaCHP3962NgdiegI5EqeIZhSPY+hjQIc1sxHe9IpICYsfte0n
 pwcoks5IkpTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="313087607"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 29 Jul 2020 09:24:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 13/15] ice: reduce scope of variable
Date:   Wed, 29 Jul 2020 09:24:03 -0700
Message-Id: <20200729162405.1596435-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
References: <20200729162405.1596435-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The scope of the macro local variable 'i' can be reduced.  Do so to avoid
static analysis tools from complaining.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 1e18021aa073..1f46a7828be8 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -312,9 +312,10 @@ ice_cfg_rq_regs(struct ice_hw *hw, struct ice_ctl_q_info *cq)
 
 #define ICE_FREE_CQ_BUFS(hw, qi, ring)					\
 do {									\
-	int i;								\
 	/* free descriptors */						\
-	if ((qi)->ring.r.ring##_bi)					\
+	if ((qi)->ring.r.ring##_bi) {					\
+		int i;							\
+									\
 		for (i = 0; i < (qi)->num_##ring##_entries; i++)	\
 			if ((qi)->ring.r.ring##_bi[i].pa) {		\
 				dmam_free_coherent(ice_hw_to_dev(hw),	\
@@ -325,6 +326,7 @@ do {									\
 					(qi)->ring.r.ring##_bi[i].pa = 0;\
 					(qi)->ring.r.ring##_bi[i].size = 0;\
 		}							\
+	}								\
 	/* free the buffer info list */					\
 	if ((qi)->ring.cmd_buf)						\
 		devm_kfree(ice_hw_to_dev(hw), (qi)->ring.cmd_buf);	\
-- 
2.26.2

