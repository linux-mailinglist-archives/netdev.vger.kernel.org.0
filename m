Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5136632D347
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbhCDMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:34:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:37596 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240964AbhCDMef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:35 -0500
IronPort-SDR: LI6dklMOIzTACjdv/k0/OfC2un8CMOcs2aCW9hM9yN5I0UJxXq4jMe9le+kWPjrkBEqqkkBc3w
 fovT2VzKm2ug==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="207113164"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="207113164"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:34 -0800
IronPort-SDR: 93TnYZct3/Ao/8+aX6fbc7HzzS1395Lkkl+Rr1HtyarOnlss+CNFw1sM/LA4ij+6FIU9W8YZJM
 nBL6hOpL4rpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="374534704"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2021 04:31:32 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id DF4B4670; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 17/18] thunderbolt: Check quirks in tb_switch_add()
Date:   Thu,  4 Mar 2021 15:31:24 +0300
Message-Id: <20210304123125.43630-18-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes it more visible on the main path of adding router.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/eeprom.c | 1 -
 drivers/thunderbolt/switch.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index dd03d3096653..aecb0b9f0c75 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -610,7 +610,6 @@ int tb_drom_read(struct tb_switch *sw)
 		sw->uid = header->uid;
 	sw->vendor = header->vendor_id;
 	sw->device = header->model_id;
-	tb_check_quirks(sw);
 
 	crc = tb_crc32(sw->drom + TB_DROM_DATA_START, header->data_len);
 	if (crc != header->data_crc32) {
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 7ac37a1f95e1..72b43c7c0651 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2520,6 +2520,8 @@ int tb_switch_add(struct tb_switch *sw)
 		}
 		tb_sw_dbg(sw, "uid: %#llx\n", sw->uid);
 
+		tb_check_quirks(sw);
+
 		ret = tb_switch_set_uuid(sw);
 		if (ret) {
 			dev_err(&sw->dev, "failed to set UUID\n");
-- 
2.30.1

