Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B032D334
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240871AbhCDMd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:26 -0500
Received: from mga12.intel.com ([192.55.52.136]:64927 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240808AbhCDMdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:18 -0500
IronPort-SDR: Tj9kfYEfnWIZm6+7CBpaBMRwz71MZuzU11XnKrDgUXva/FFuYEKgLdW8gqAhnUQBuFIJPDLyFC
 PaBFVmx25gsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="166662653"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="166662653"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:33 -0800
IronPort-SDR: ly8Jdcv0Hl/ZhnrKFx+Y22W2mFysooOQBuqy8GrXrdZWmsK2wzcFZHy0BPzow5HmsrInS6MrBE
 +HnedhSBd/Vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="518641969"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 04 Mar 2021 04:31:30 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id BCE6650E; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
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
Subject: [PATCH 14/18] net: thunderbolt: Align the driver to the USB4 networking spec
Date:   Thu,  4 Mar 2021 15:31:21 +0300
Message-Id: <20210304123125.43630-15-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The USB4 networking spec (USB4NET) recommends different timeouts, and
also suggest that the driver sets the 64k frame support flag in the
properties block. Make the networking driver to honor this.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 5c9ec91b6e78..9a6a8353e192 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -25,12 +25,13 @@
 /* Protocol timeouts in ms */
 #define TBNET_LOGIN_DELAY	4500
 #define TBNET_LOGIN_TIMEOUT	500
-#define TBNET_LOGOUT_TIMEOUT	100
+#define TBNET_LOGOUT_TIMEOUT	1000
 
 #define TBNET_RING_SIZE		256
 #define TBNET_LOGIN_RETRIES	60
-#define TBNET_LOGOUT_RETRIES	5
+#define TBNET_LOGOUT_RETRIES	10
 #define TBNET_MATCH_FRAGS_ID	BIT(1)
+#define TBNET_64K_FRAMES	BIT(2)
 #define TBNET_MAX_MTU		SZ_64K
 #define TBNET_FRAME_SIZE	SZ_4K
 #define TBNET_MAX_PAYLOAD_SIZE	\
@@ -1367,7 +1368,7 @@ static int __init tbnet_init(void)
 	 * the moment.
 	 */
 	tb_property_add_immediate(tbnet_dir, "prtcstns",
-				  TBNET_MATCH_FRAGS_ID);
+				  TBNET_MATCH_FRAGS_ID | TBNET_64K_FRAMES);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
 	if (ret) {
-- 
2.30.1

