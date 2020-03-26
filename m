Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5519372B
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 04:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgCZDwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 23:52:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:29078 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbgCZDwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 23:52:15 -0400
IronPort-SDR: Mqw/u1KDWIZ432Pw0an0iTlZfiSEdNDHBKYu55tKdNeeTbaR4UVWfWcW3kCu55iBISHCO+1nls
 BhXiWAkby8bg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 20:52:14 -0700
IronPort-SDR: twOKjs7AL5S+3nB3RAZS0zITxuUSaUu2NN5rzEBnvTFk3FsILPdtBSGnC9bxkBZlYK1TPuDiVp
 ZC0rLTIuK+rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="271028110"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga004.fm.intel.com with ESMTP; 25 Mar 2020 20:52:13 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next v2 06/11] devlink: extract snapshot id allocation to helper function
Date:   Wed, 25 Mar 2020 20:51:52 -0700
Message-Id: <20200326035157.2211090-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326035157.2211090-1-jacob.e.keller@intel.com>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
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
index 8c2c4bc009bb..457b8303ae59 100644
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

