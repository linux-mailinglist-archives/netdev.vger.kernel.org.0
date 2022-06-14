Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4511254B6D5
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344718AbiFNQvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354694AbiFNQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:51:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8903D4477B
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 09:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655225476; x=1686761476;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Itn7XarFi2VRIWgWyhOJJ4H2sMzDG9dTpUOmYEFs3fA=;
  b=Ze2iQJ6iakyKIbMmiP9mir3GICfC3qfPFyttZcAI0wLkkDaOicta0K90
   1OGnpYgHpF+dkkUeHIKLZoZWv2QKFRYHCG/xItU0lp2n6awL4RJgnIWdy
   ELc56MgZPP2efUljdFpmEee76PBAstRM8KJfqPl2HhvGED0RKt3oMLbrq
   pLy0ucnVXdSlZYjvISLpc0W8oqzNnHkx6F0qRBlmgRjv0/kZJzTsKL13I
   lrKkgBgJT51qDI3VhZuMzMTXUhwjNs1ijkBJSqBw68hePAv/sVmCFkaaR
   C60DdDjCz8FwAc19IrgYfJcgXWOENqgoxyhD63dQelwiWbrqHVC3zBcmC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="278715014"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="278715014"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 09:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="582775184"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Jun 2022 09:51:11 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 1/4] ice: Fix PTP TX timestamp offset calculation
Date:   Tue, 14 Jun 2022 09:48:03 -0700
Message-Id: <20220614164806.1184030-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
References: <20220614164806.1184030-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Michalik <michal.michalik@intel.com>

The offset was being incorrectly calculated for E822 - that led to
collisions in choosing TX timestamp register location when more than
one port was trying to use timestamping mechanism.

In E822 one quad is being logically split between ports, so quad 0 is
having trackers for ports 0-3, quad 1 ports 4-7 etc. Each port should
have separate memory location for tracking timestamps. Due to error for
example ports 1 and 2 had been assigned to quad 0 with same offset (0),
while port 1 should have offset 0 and 1 offset 16.

Fix it by correctly calculating quad offset.

Fixes: 3a7496234d17 ("ice: implement basic E822 PTP support")
Signed-off-by: Michal Michalik <michal.michalik@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h | 31 ++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 662947c882e8..ef9344ef0d8e 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -2271,7 +2271,7 @@ static int
 ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 {
 	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = tx->quad * INDEX_PER_PORT;
+	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
 	tx->len = INDEX_PER_PORT;
 
 	return ice_ptp_alloc_tx_tracker(tx);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index afd048d69959..10e396abf130 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -49,6 +49,37 @@ struct ice_perout_channel {
  * To allow multiple ports to access the shared register block independently,
  * the blocks are split up so that indexes are assigned to each port based on
  * hardware logical port number.
+ *
+ * The timestamp blocks are handled differently for E810- and E822-based
+ * devices. In E810 devices, each port has its own block of timestamps, while in
+ * E822 there is a need to logically break the block of registers into smaller
+ * chunks based on the port number to avoid collisions.
+ *
+ * Example for port 5 in E810:
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *  |register|register|register|register|register|register|register|register|
+ *  | block  | block  | block  | block  | block  | block  | block  | block  |
+ *  |  for   |  for   |  for   |  for   |  for   |  for   |  for   |  for   |
+ *  | port 0 | port 1 | port 2 | port 3 | port 4 | port 5 | port 6 | port 7 |
+ *  +--------+--------+--------+--------+--------+--------+--------+--------+
+ *                                               ^^
+ *                                               ||
+ *                                               |---  quad offset is always 0
+ *                                               ---- quad number
+ *
+ * Example for port 5 in E822:
+ * +-----------------------------+-----------------------------+
+ * |  register block for quad 0  |  register block for quad 1  |
+ * |+------+------+------+------+|+------+------+------+------+|
+ * ||port 0|port 1|port 2|port 3|||port 0|port 1|port 2|port 3||
+ * |+------+------+------+------+|+------+------+------+------+|
+ * +-----------------------------+-------^---------------------+
+ *                                ^      |
+ *                                |      --- quad offset*
+ *                                ---- quad number
+ *
+ *   * PHY port 5 is port 1 in quad 1
+ *
  */
 
 /**
-- 
2.35.1

