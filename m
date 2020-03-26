Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEAC1946A9
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgCZShi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:43777 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbgCZShg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:36 -0400
IronPort-SDR: CFQFi5UC0CErgApOd5esx2D1SllxKzDU9+3NXBYZiYGvj8eFyN2RQZ32I7LHm4VVi/ED2tY+T5
 nt1G07jC2Z0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:23 -0700
IronPort-SDR: qZQUFpfPlwrV40WFCnWo9b1EPkTgxG35oRS8JQIIAMiyMbAJ99hMuC6+MpSheOQGqNiDmH9rpK
 oOUU3zDnOCnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241629"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:23 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next v3 06/11] devlink: extract snapshot id allocation to helper function
Date:   Thu, 26 Mar 2020 11:37:13 -0700
Message-Id: <20200326183718.2384349-7-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
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
Changes since RFC:
* Added this patch to explain reasoning why the function is kept despite
  only having one caller.

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

