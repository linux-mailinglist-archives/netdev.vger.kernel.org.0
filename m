Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C201DF551
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 08:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbgEWGtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 02:49:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:52994 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387726AbgEWGtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 02:49:12 -0400
IronPort-SDR: PEofo5abPLZo5KwxjCEcZoiRgIrEkqdSSWJaPArFlaT8/TxsxG3fQiXNkWWyjitpb6kZ6fVSlo
 9PQCpwKTtqZg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 23:48:51 -0700
IronPort-SDR: BxRvET4QIWioni69HY5ocTyovg2Xj7hgXpz1wzZCc3LEv2u74OlzzO4XR0AjMd9/ZDsnCFC8Hx
 4vUTKRo682Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="374966914"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2020 23:48:51 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 14/16] ice: Fix bad register reads
Date:   Fri, 22 May 2020 23:48:45 -0700
Message-Id: <20200523064847.3972158-15-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
References: <20200523064847.3972158-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

The "ethtool -d" handler reads registers in the ice_regs_dump_list array
and returns read values back to the userspace.

The register offsets PFINT0_ITR* are not valid as per the specification
and reading these causes a "unable to handle kernel paging request" bug
in the driver. Remove these registers from ice_regs_dump_list.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 3 ---
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 72105d70cead..477ad33e0403 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -142,9 +142,6 @@ static const u32 ice_regs_dump_list[] = {
 	QINT_RQCTL(0),
 	PFINT_OICR_ENA,
 	QRX_ITR(0),
-	PF0INT_ITR_0(0),
-	PF0INT_ITR_1(0),
-	PF0INT_ITR_2(0),
 };
 
 struct ice_priv_flag {
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 1f9b427a35fa..2f1c776747a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -6,9 +6,6 @@
 #ifndef _ICE_HW_AUTOGEN_H_
 #define _ICE_HW_AUTOGEN_H_
 
-#define PF0INT_ITR_0(_i)			(0x03000004 + ((_i) * 4096))
-#define PF0INT_ITR_1(_i)			(0x03000008 + ((_i) * 4096))
-#define PF0INT_ITR_2(_i)			(0x0300000C + ((_i) * 4096))
 #define QTX_COMM_DBELL(_DBQM)			(0x002C0000 + ((_DBQM) * 4))
 #define QTX_COMM_HEAD(_DBQM)			(0x000E0000 + ((_DBQM) * 4))
 #define QTX_COMM_HEAD_HEAD_S			0
-- 
2.26.2

