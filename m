Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A3191CEC
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 23:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgCXWfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 18:35:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:54988 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728539AbgCXWfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 18:35:13 -0400
IronPort-SDR: B9wSQwI1/W0Fy8T1xBbwhBocTRQBAQBS5d7Vcc+aR4a69cil2T2EsK6BN429ShmSs9R7SLYdhY
 Br3AQGTuaWIg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 15:35:13 -0700
IronPort-SDR: 4RSXbNG8mxEwucGuWGaxNKoPX6Y7yoX4LG6UvuX/wgxpHn71hN4CebvuRqky/WYf379dGv+zf1
 RDFw0IK0FNuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="238363187"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga007.fm.intel.com with ESMTP; 24 Mar 2020 15:35:12 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 05/10] devlink: extract snapshot id allocation to helper function
Date:   Tue, 24 Mar 2020 15:34:40 -0700
Message-Id: <20200324223445.2077900-6-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324223445.2077900-1-jacob.e.keller@intel.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A future change is going to implement a new devlink command to request
a snapshot on demand. As part of this, the logic for handling the
snapshot ids will be refactored. To simplify the snapshot id allocation
function, move it to a separate function prefixed by `__`. This helper
function will assume the lock is held.

While no other callers will exist, it simplifies refactoring the logic
because there is no need to complicate the function with gotos to handle
unlocking on failure.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/core/devlink.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 620e9d07ac85..6dc14eb2a5f7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3768,6 +3768,19 @@ static void devlink_nl_region_notify(struct devlink_region *region,
 	nlmsg_free(msg);
 }
 
+/**
+ *	__devlink_region_snapshot_id_get - get snapshot ID
+ *	@devlink: devlink instance
+ *
+ *	Returns a new snapshot id. Must be called while holding the
+ *	devlink instance lock.
+ */
+static u32 __devlink_region_snapshot_id_get(struct devlink *devlink)
+{
+	lockdep_assert_held(&devlink->lock);
+	return ++devlink->snapshot_id;
+}
+
 /**
  *	__devlink_region_snapshot_create - create a new snapshot
  *	This will add a new snapshot of a region. The snapshot
@@ -7775,7 +7788,7 @@ u32 devlink_region_snapshot_id_get(struct devlink *devlink)
 	u32 id;
 
 	mutex_lock(&devlink->lock);
-	id = ++devlink->snapshot_id;
+	id = __devlink_region_snapshot_id_get(devlink);
 	mutex_unlock(&devlink->lock);
 
 	return id;
-- 
2.24.1

