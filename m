Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B4A41E33B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349434AbhI3VW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:22:58 -0400
Received: from mga12.intel.com ([192.55.52.136]:19005 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348770AbhI3VW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:22:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="204774791"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="204774791"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:21:14 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="438187085"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.1])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:21:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [net-next] devlink: report maximum number of snapshots with regions
Date:   Thu, 30 Sep 2021 14:21:04 -0700
Message-Id: <20210930212104.1674017-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Each region has an independently configurable number of maximum
snapshots. This information is not reported to userspace, making it not
very discoverable. Fix this by adding a new
DEVLINK_ATTR_REGION_MAX_SNAPSHOST attribute which is used to report this
maximum.

Ex:

  $devlink region
  pci/0000:af:00.0/nvm-flash: size 10485760 snapshot [] max 1
  pci/0000:af:00.0/device-caps: size 4096 snapshot [] max 10
  pci/0000:af:00.1/nvm-flash: size 10485760 snapshot [] max 1
  pci/0000:af:00.1/device-caps: size 4096 snapshot [] max 10

This information enables users to understand why a new region command
may fail due to having too many existing snapshots.

Reported-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
I realized while explaining a new devlink region that there is no mechanism
to view the maximum snapshot count for a given region without analyzing the
code for a driver. This change fixes that.

 Documentation/networking/devlink/devlink-region.rst | 4 ++--
 Documentation/networking/devlink/ice.rst            | 4 ++++
 include/uapi/linux/devlink.h                        | 2 ++
 net/core/devlink.c                                  | 5 +++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
index 58fe95e9a49d..f06dca9a1eb6 100644
--- a/Documentation/networking/devlink/devlink-region.rst
+++ b/Documentation/networking/devlink/devlink-region.rst
@@ -44,8 +44,8 @@ example usage
 
     # Show all of the exposed regions with region sizes:
     $ devlink region show
-    pci/0000:00:05.0/cr-space: size 1048576 snapshot [1 2]
-    pci/0000:00:05.0/fw-health: size 64 snapshot [1 2]
+    pci/0000:00:05.0/cr-space: size 1048576 snapshot [1 2] max 8
+    pci/0000:00:05.0/fw-health: size 64 snapshot [1 2] max 8
 
     # Delete a snapshot using:
     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
index a432dc419fa4..32aea1f7d7f7 100644
--- a/Documentation/networking/devlink/ice.rst
+++ b/Documentation/networking/devlink/ice.rst
@@ -141,6 +141,10 @@ Users can request an immediate capture of a snapshot via the
 
 .. code:: shell
 
+    $ devlink region show
+    pci/0000:01:00.0/nvm-flash: size 10485760 snapshot [] max 1
+    pci/0000:01:00.0/device-caps: size 4096 snapshot [] max 10
+
     $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
     $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 32f53a0069d6..b897b80770f6 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -551,6 +551,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RATE_NODE_NAME,		/* string */
 	DEVLINK_ATTR_RATE_PARENT_NODE_NAME,	/* string */
 
+	DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,	/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index b64303085d0e..4917112406a0 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5078,6 +5078,11 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
+	err = nla_put_u32(msg, DEVLINK_ATTR_REGION_MAX_SNAPSHOTS,
+			  region->max_snapshots);
+	if (err)
+		goto nla_put_failure;
+
 	err = devlink_nl_region_snapshots_id_put(msg, devlink, region);
 	if (err)
 		goto nla_put_failure;

base-commit: b05173028cc52384be42dcf81abdb4133caccfa5
-- 
2.31.1.331.gb0c09ab8796f

