Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4F11600
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfEBJG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:47592 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfEBJGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615351"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:23 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Paul Greenwalt <paul.greenwalt@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/15] ice: Add 52 byte RSS hash key support
Date:   Thu,  2 May 2019 02:06:12 -0700
Message-Id: <20190502090620.21281-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Greenwalt <paul.greenwalt@intel.com>

Add support to set 52 byte RSS hash key.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h |  3 +++
 drivers/net/ethernet/intel/ice/ice_lib.c        | 12 +++++-------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 583f92d4db4c..6ef083002f5b 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -1291,6 +1291,9 @@ struct ice_aqc_get_set_rss_key {
 
 #define ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE	0x28
 #define ICE_AQC_GET_SET_RSS_KEY_DATA_HASH_KEY_SIZE	0xC
+#define ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE \
+				(ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE + \
+				 ICE_AQC_GET_SET_RSS_KEY_DATA_HASH_KEY_SIZE)
 
 struct ice_aqc_get_set_rss_keys {
 	u8 standard_rss_key[ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE];
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index e75d8c4fadc6..982a3a9e9b8d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1394,7 +1394,6 @@ int ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena)
  */
 static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 {
-	u8 seed[ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE];
 	struct ice_aqc_get_set_rss_keys *key;
 	struct ice_pf *pf = vsi->back;
 	enum ice_status status;
@@ -1429,13 +1428,12 @@ static int ice_vsi_cfg_rss_lut_key(struct ice_vsi *vsi)
 	}
 
 	if (vsi->rss_hkey_user)
-		memcpy(seed, vsi->rss_hkey_user,
-		       ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE);
+		memcpy(key,
+		       (struct ice_aqc_get_set_rss_keys *)vsi->rss_hkey_user,
+		       ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
 	else
-		netdev_rss_key_fill((void *)seed,
-				    ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE);
-	memcpy(&key->standard_rss_key, seed,
-	       ICE_AQC_GET_SET_RSS_KEY_DATA_RSS_KEY_SIZE);
+		netdev_rss_key_fill((void *)key,
+				    ICE_GET_SET_RSS_KEY_EXTEND_KEY_SIZE);
 
 	status = ice_aq_set_rss_key(&pf->hw, vsi->idx, key);
 
-- 
2.20.1

