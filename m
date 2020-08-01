Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5D23534A
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgHAQSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:19604 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgHAQSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:08 -0400
IronPort-SDR: G1u10g0xrNVjNQeXupd+bZ1JniIPLWbtwSqOmh9hJoCzp5nWKjFOVLOgYOMi4lfPhihwxXpk6E
 xXZdOBavYaPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810845"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810845"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:07 -0700
IronPort-SDR: hOYkgucXgh57OwDyGVqnlLtaGVUKlcHaSxrrzd3uy6qedo8uzsvnWZhsrVEUehVTPoBLujX3UT
 YmF8QOMgnuUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457695"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:06 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Kiran Patil <kiran.patil@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 03/14] ice: fix the vsi_id mask to be 10 bit for set_rss_lut
Date:   Sat,  1 Aug 2020 09:17:51 -0700
Message-Id: <20200801161802.867645-4-anthony.l.nguyen@intel.com>
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

set_rss_lut can fail due to incorrect vsi_id mask. vsi_id is 10 bit
but mask was 0x1FF whereas it should be 0x3FF.

For vsi_num >= 512, FW set_rss_lut can fail with return code
EACCESS (VSI ownership issue) because software was providing
incorrect vsi_num (dropping 10th bit due to incorrect mask) for
set_rss_lut admin command

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 7fec9309d379..ba9375218fef 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1581,7 +1581,7 @@ struct ice_aqc_get_set_rss_keys {
 struct ice_aqc_get_set_rss_lut {
 #define ICE_AQC_GSET_RSS_LUT_VSI_VALID	BIT(15)
 #define ICE_AQC_GSET_RSS_LUT_VSI_ID_S	0
-#define ICE_AQC_GSET_RSS_LUT_VSI_ID_M	(0x1FF << ICE_AQC_GSET_RSS_LUT_VSI_ID_S)
+#define ICE_AQC_GSET_RSS_LUT_VSI_ID_M	(0x3FF << ICE_AQC_GSET_RSS_LUT_VSI_ID_S)
 	__le16 vsi_id;
 #define ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_S	0
 #define ICE_AQC_GSET_RSS_LUT_TABLE_TYPE_M	\
-- 
2.26.2

