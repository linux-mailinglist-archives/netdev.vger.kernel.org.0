Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C08235346
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHAQSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgHAQSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:11 -0400
IronPort-SDR: OoRIv8L5+J9pWdluBqQRryBOCQ0tqkBdYAXp78ODFr+qVfEtMXSUzR3hwQQwl6+5pjiDUKISmT
 3OYGJqBrLOEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810855"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810855"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: pn4HxTEEpIBg5bQk44SarrNAzktMmg5OQYEFPEHP2Ty6j6vTHo2yggBDLGpFcyG+S5uiP1Ekez
 3FxsjgQrKaSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457717"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Kiran Patil <kiran.patil@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 09/14] ice: port fix for chk_linearlize
Date:   Sat,  1 Aug 2020 09:17:57 -0700
Message-Id: <20200801161802.867645-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Patil <kiran.patil@intel.com>

This is a port of commit 248de22e638f ("i40e/i40evf: Account for frags
split over multiple descriptors in check linearize")

As part of testing workloads (read/write) using larger IO size (128K)
tx_timeout is observed and whenever it happens, it was due to
tx_linearize.

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 26 ++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 53c67eeec2fa..77de8869e7ca 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2292,10 +2292,30 @@ static bool __ice_chk_linearize(struct sk_buff *skb)
 	/* Walk through fragments adding latest fragment, testing it, and
 	 * then removing stale fragments from the sum.
 	 */
-	stale = &skb_shinfo(skb)->frags[0];
-	for (;;) {
+	for (stale = &skb_shinfo(skb)->frags[0];; stale++) {
+		int stale_size = skb_frag_size(stale);
+
 		sum += skb_frag_size(frag++);
 
+		/* The stale fragment may present us with a smaller
+		 * descriptor than the actual fragment size. To account
+		 * for that we need to remove all the data on the front and
+		 * figure out what the remainder would be in the last
+		 * descriptor associated with the fragment.
+		 */
+		if (stale_size > ICE_MAX_DATA_PER_TXD) {
+			int align_pad = -(skb_frag_off(stale)) &
+					(ICE_MAX_READ_REQ_SIZE - 1);
+
+			sum -= align_pad;
+			stale_size -= align_pad;
+
+			do {
+				sum -= ICE_MAX_DATA_PER_TXD_ALIGNED;
+				stale_size -= ICE_MAX_DATA_PER_TXD_ALIGNED;
+			} while (stale_size > ICE_MAX_DATA_PER_TXD);
+		}
+
 		/* if sum is negative we failed to make sufficient progress */
 		if (sum < 0)
 			return true;
@@ -2303,7 +2323,7 @@ static bool __ice_chk_linearize(struct sk_buff *skb)
 		if (!nr_frags--)
 			break;
 
-		sum -= skb_frag_size(stale++);
+		sum -= stale_size;
 	}
 
 	return false;
-- 
2.26.2

