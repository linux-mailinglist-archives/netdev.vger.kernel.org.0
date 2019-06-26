Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E08E571C2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfFZTaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:30:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:41403 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfFZTaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:30:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:30:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,420,1557212400"; 
   d="scan'208";a="188762463"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2019 12:30:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/10] i40e: fix 'Unknown bps' in dmesg for 2.5Gb/5Gb speeds
Date:   Wed, 26 Jun 2019 12:30:56 -0700
Message-Id: <20190626193103.2169-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
References: <20190626193103.2169-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

This patch fixes 'NIC Link is Up, Unknown bps' message in dmesg
for 2.5Gb/5Gb speeds. This problem is fixed by adding constants
for VIRTCHNL_LINK_SPEED_2_5GB and VIRTCHNL_LINK_SPEED_5GB cases
in the i40e_virtchnl_link_speed() function.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_prototype.h | 4 ++++
 include/linux/avf/virtchnl.h                     | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index 882627073dce..eac88bcc6c06 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -350,6 +350,10 @@ i40e_virtchnl_link_speed(enum i40e_aq_link_speed link_speed)
 		return VIRTCHNL_LINK_SPEED_100MB;
 	case I40E_LINK_SPEED_1GB:
 		return VIRTCHNL_LINK_SPEED_1GB;
+	case I40E_LINK_SPEED_2_5GB:
+		return VIRTCHNL_LINK_SPEED_2_5GB;
+	case I40E_LINK_SPEED_5GB:
+		return VIRTCHNL_LINK_SPEED_5GB;
 	case I40E_LINK_SPEED_10GB:
 		return VIRTCHNL_LINK_SPEED_10GB;
 	case I40E_LINK_SPEED_40GB:
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 191621ff7594..ca956b672ac0 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -61,12 +61,14 @@ enum virtchnl_status_code {
 #define VIRTCHNL_ERR_PARAM VIRTCHNL_STATUS_ERR_PARAM
 #define VIRTCHNL_STATUS_NOT_SUPPORTED VIRTCHNL_STATUS_ERR_NOT_SUPPORTED
 
+#define VIRTCHNL_LINK_SPEED_2_5GB_SHIFT		0x0
 #define VIRTCHNL_LINK_SPEED_100MB_SHIFT		0x1
 #define VIRTCHNL_LINK_SPEED_1000MB_SHIFT	0x2
 #define VIRTCHNL_LINK_SPEED_10GB_SHIFT		0x3
 #define VIRTCHNL_LINK_SPEED_40GB_SHIFT		0x4
 #define VIRTCHNL_LINK_SPEED_20GB_SHIFT		0x5
 #define VIRTCHNL_LINK_SPEED_25GB_SHIFT		0x6
+#define VIRTCHNL_LINK_SPEED_5GB_SHIFT		0x7
 
 enum virtchnl_link_speed {
 	VIRTCHNL_LINK_SPEED_UNKNOWN	= 0,
@@ -76,6 +78,8 @@ enum virtchnl_link_speed {
 	VIRTCHNL_LINK_SPEED_40GB	= BIT(VIRTCHNL_LINK_SPEED_40GB_SHIFT),
 	VIRTCHNL_LINK_SPEED_20GB	= BIT(VIRTCHNL_LINK_SPEED_20GB_SHIFT),
 	VIRTCHNL_LINK_SPEED_25GB	= BIT(VIRTCHNL_LINK_SPEED_25GB_SHIFT),
+	VIRTCHNL_LINK_SPEED_2_5GB	= BIT(VIRTCHNL_LINK_SPEED_2_5GB_SHIFT),
+	VIRTCHNL_LINK_SPEED_5GB		= BIT(VIRTCHNL_LINK_SPEED_5GB_SHIFT),
 };
 
 /* for hsplit_0 field of Rx HMC context */
-- 
2.21.0

