Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992663D3E23
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhGWQZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:25:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:34405 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231166AbhGWQZZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:25:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="191508237"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="191508237"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:05:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="663350260"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jul 2021 10:05:58 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 3/3] e100: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Fri, 23 Jul 2021 10:09:10 -0700
Message-Id: <20210723170910.296843-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
References: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields.

The memcpy() is copying the entire structure, not just the first array.
Adjust the source argument so the compiler can do appropriate bounds
checking.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 1b0958bd24f6..1ec924c556c5 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2715,10 +2715,10 @@ static void e100_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	switch (stringset) {
 	case ETH_SS_TEST:
-		memcpy(data, *e100_gstrings_test, sizeof(e100_gstrings_test));
+		memcpy(data, e100_gstrings_test, sizeof(e100_gstrings_test));
 		break;
 	case ETH_SS_STATS:
-		memcpy(data, *e100_gstrings_stats, sizeof(e100_gstrings_stats));
+		memcpy(data, e100_gstrings_stats, sizeof(e100_gstrings_stats));
 		break;
 	}
 }
-- 
2.26.2

