Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A2132D335
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbhCDMd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:37600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240800AbhCDMdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:18 -0500
IronPort-SDR: pLoHiX6CDmaXLH5fkJ13FxKALL8Tn8yN1dQfvwKrUjzDK5yWybGORLELAnaqn3dvYcwU/ONdMK
 7ZIj7UMCNqZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="207113154"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="207113154"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:30 -0800
IronPort-SDR: XVAu/z16xaRzoTojTaJIhMRVbd26cQXJmBVoYdGIeUnGDbVEwHLJQozbrGfKHPB3NrADJyj398
 O29AS1TsudSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="406837329"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 04 Mar 2021 04:31:26 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 456AD236; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
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
Subject: [PATCH 02/18] thunderbolt: Do not pass timeout for tb_cfg_reset()
Date:   Thu,  4 Mar 2021 15:31:09 +0300
Message-Id: <20210304123125.43630-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is only one user for this function and it passes the default
timeout to it anyway, so remove the parameter completely. This is also
needed in the subsequent patch where we allow connection manager
implementations to use different timeout for non-raw control channel
messages.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/ctl.c    | 6 ++----
 drivers/thunderbolt/ctl.h    | 3 +--
 drivers/thunderbolt/switch.c | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 875922133782..b79be1f02d92 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -802,14 +802,12 @@ static bool tb_cfg_copy(struct tb_cfg_request *req, const struct ctl_pkg *pkg)
  * tb_cfg_reset() - send a reset packet and wait for a response
  * @ctl: Control channel pointer
  * @route: Router string for the router to send reset
- * @timeout_msec: Timeout in ms how long to wait for the response
  *
  * If the switch at route is incorrectly configured then we will not receive a
  * reply (even though the switch will reset). The caller should check for
  * -ETIMEDOUT and attempt to reconfigure the switch.
  */
-struct tb_cfg_result tb_cfg_reset(struct tb_ctl *ctl, u64 route,
-				  int timeout_msec)
+struct tb_cfg_result tb_cfg_reset(struct tb_ctl *ctl, u64 route)
 {
 	struct cfg_reset_pkg request = { .header = tb_cfg_make_header(route) };
 	struct tb_cfg_result res = { 0 };
@@ -831,7 +829,7 @@ struct tb_cfg_result tb_cfg_reset(struct tb_ctl *ctl, u64 route,
 	req->response_size = sizeof(reply);
 	req->response_type = TB_CFG_PKG_RESET;
 
-	res = tb_cfg_request_sync(ctl, req, timeout_msec);
+	res = tb_cfg_request_sync(ctl, req, TB_CFG_DEFAULT_TIMEOUT);
 
 	tb_cfg_request_put(req);
 
diff --git a/drivers/thunderbolt/ctl.h b/drivers/thunderbolt/ctl.h
index 97cb03b38953..2eafbfea5dff 100644
--- a/drivers/thunderbolt/ctl.h
+++ b/drivers/thunderbolt/ctl.h
@@ -124,8 +124,7 @@ static inline struct tb_cfg_header tb_cfg_make_header(u64 route)
 }
 
 int tb_cfg_ack_plug(struct tb_ctl *ctl, u64 route, u32 port, bool unplug);
-struct tb_cfg_result tb_cfg_reset(struct tb_ctl *ctl, u64 route,
-				  int timeout_msec);
+struct tb_cfg_result tb_cfg_reset(struct tb_ctl *ctl, u64 route);
 struct tb_cfg_result tb_cfg_read_raw(struct tb_ctl *ctl, void *buffer,
 				     u64 route, u32 port,
 				     enum tb_cfg_space space, u32 offset,
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 2a95b4ce06c0..218869c6ee21 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1331,7 +1331,7 @@ int tb_switch_reset(struct tb_switch *sw)
 			      TB_CFG_SWITCH, 2, 2);
 	if (res.err)
 		return res.err;
-	res = tb_cfg_reset(sw->tb->ctl, tb_route(sw), TB_CFG_DEFAULT_TIMEOUT);
+	res = tb_cfg_reset(sw->tb->ctl, tb_route(sw));
 	if (res.err > 0)
 		return -EIO;
 	return res.err;
-- 
2.30.1

