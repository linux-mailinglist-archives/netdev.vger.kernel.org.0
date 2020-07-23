Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842D022BA54
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgGWXrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:47:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:43322 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgGWXr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:47:27 -0400
IronPort-SDR: fltXfuLFxE3KrqOYeNDQpKi1Jhbxd8SvRmwKvnEVwx78qDAM75DE29sGQVDEDOCGxpSy35L6ZY
 +lzUuBm3S/Zw==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="235515430"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="235515430"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:47:25 -0700
IronPort-SDR: eXmAPWXlB41folzTeqd3usgrj+JrBhnDmo7WvJOumG3193nQa+L+2VeRE6ckkXdRlOgO6Ib1Ia
 uQ2BBhychwBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="328742286"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 23 Jul 2020 16:47:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 01/15] ice: refactor ice_discover_caps to avoid need to retry
Date:   Thu, 23 Jul 2020 16:47:06 -0700
Message-Id: <20200723234720.1547308-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
References: <20200723234720.1547308-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_discover_caps function is used to read the device and function
capabilities, updating the hardware capabilities structures with
relevant data.

The exact number of capabilities returned by the hardware is unknown
ahead of time. The AdminQ command will report the total number of
capabilities in the return buffer.

The current implementation involves requesting capabilities once,
reading this returned size, and then re-requested with that size.

This isn't really necessary. The firmware interface has a maximum size
of ICE_AQ_MAX_BUF_LEN. Firmware can never return more than
ICE_AQ_MAX_BUF_LEN / sizeof(struct ice_aqc_list_caps_elem) capabilities.

Avoid the retry loop by simply allocating a buffer of size
ICE_AQ_MAX_BUF_LEN. This is significantly simpler than retrying. The
extra allocation isn't a big deal, as it will be released after we
finish parsing the capabilities.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 43 ++++++---------------
 1 file changed, 12 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 57fd815c41bc..37ea042ece13 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1901,40 +1901,21 @@ ice_discover_caps(struct ice_hw *hw, enum ice_adminq_opc opc)
 {
 	enum ice_status status;
 	u32 cap_count;
-	u16 cbuf_len;
-	u8 retries;
-
-	/* The driver doesn't know how many capabilities the device will return
-	 * so the buffer size required isn't known ahead of time. The driver
-	 * starts with cbuf_len and if this turns out to be insufficient, the
-	 * device returns ICE_AQ_RC_ENOMEM and also the cap_count it needs.
-	 * The driver then allocates the buffer based on the count and retries
-	 * the operation. So it follows that the retry count is 2.
-	 */
-#define ICE_GET_CAP_BUF_COUNT	40
-#define ICE_GET_CAP_RETRY_COUNT	2
-
-	cap_count = ICE_GET_CAP_BUF_COUNT;
-	retries = ICE_GET_CAP_RETRY_COUNT;
-
-	do {
-		void *cbuf;
-
-		cbuf_len = (u16)(cap_count *
-				 sizeof(struct ice_aqc_list_caps_elem));
-		cbuf = devm_kzalloc(ice_hw_to_dev(hw), cbuf_len, GFP_KERNEL);
-		if (!cbuf)
-			return ICE_ERR_NO_MEMORY;
+	void *cbuf;
 
-		status = ice_aq_discover_caps(hw, cbuf, cbuf_len, &cap_count,
-					      opc, NULL);
-		devm_kfree(ice_hw_to_dev(hw), cbuf);
+	cbuf = kzalloc(ICE_AQ_MAX_BUF_LEN, GFP_KERNEL);
+	if (!cbuf)
+		return ICE_ERR_NO_MEMORY;
 
-		if (!status || hw->adminq.sq_last_status != ICE_AQ_RC_ENOMEM)
-			break;
+	/* Although the driver doesn't know the number of capabilities the
+	 * device will return, we can simply send a 4KB buffer, the maximum
+	 * possible size that firmware can return.
+	 */
+	cap_count = ICE_AQ_MAX_BUF_LEN / sizeof(struct ice_aqc_list_caps_elem);
 
-		/* If ENOMEM is returned, try again with bigger buffer */
-	} while (--retries);
+	status = ice_aq_discover_caps(hw, cbuf, ICE_AQ_MAX_BUF_LEN, &cap_count,
+				      opc, NULL);
+	kfree(cbuf);
 
 	return status;
 }
-- 
2.26.2

