Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988EB2A65AC
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgKDOAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:00:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:11983 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbgKDOAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:00:34 -0500
IronPort-SDR: uaB5ytNfSlPWuaSvfolCwP77e8ztjasOb8KJzF9FpULjkFa6cRm5nPXB3u/GcaT+8qIZIogLmM
 NytIStaEaTjQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9794"; a="165711168"
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="165711168"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 06:00:33 -0800
IronPort-SDR: klcYv9+TyocmykFykqHmRCTq/8PBrMmz9IBAi/SNvI1LPRAdDvIIyUF1BI5CU8Z2ftySskbWQH
 7wwFxK/6KdwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,451,1596524400"; 
   d="scan'208";a="306424177"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2020 06:00:31 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id E6E9215E; Wed,  4 Nov 2020 16:00:30 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 02/10] thunderbolt: Find XDomain by route instead of UUID
Date:   Wed,  4 Nov 2020 17:00:22 +0300
Message-Id: <20201104140030.6853-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
References: <20201104140030.6853-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are going to represent loops back to the host also as XDomains and
they all have the same (host) UUID, so finding them needs to use route
string instead. This also requires that we check if the XDomain device
is added to the bus before its properties can be updated. Otherwise the
remote UUID might not be populated yet.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index c00ad817042e..e2866248f389 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -587,8 +587,6 @@ static void tb_xdp_handle_request(struct work_struct *work)
 		break;
 
 	case PROPERTIES_CHANGED_REQUEST: {
-		const struct tb_xdp_properties_changed *xchg =
-			(const struct tb_xdp_properties_changed *)pkg;
 		struct tb_xdomain *xd;
 
 		ret = tb_xdp_properties_changed_response(ctl, route, sequence);
@@ -598,8 +596,8 @@ static void tb_xdp_handle_request(struct work_struct *work)
 		 * the xdomain related to this connection as well in
 		 * case there is a change in services it offers.
 		 */
-		xd = tb_xdomain_find_by_uuid_locked(tb, &xchg->src_uuid);
-		if (xd) {
+		xd = tb_xdomain_find_by_route_locked(tb, route);
+		if (xd && device_is_registered(&xd->dev)) {
 			queue_delayed_work(tb->wq, &xd->get_properties_work,
 					   msecs_to_jiffies(50));
 			tb_xdomain_put(xd);
-- 
2.28.0

