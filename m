Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3265F13636C
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729386AbgAIWqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:46:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:46855 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgAIWqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:46:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 14:46:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="421926882"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by fmsmga005.fm.intel.com with ESMTP; 09 Jan 2020 14:46:51 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH 15/17] devlink: add a devlink-resource.rst documentation file
Date:   Thu,  9 Jan 2020 14:46:23 -0800
Message-Id: <20200109224625.1470433-16-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200109224625.1470433-1-jacob.e.keller@intel.com>
References: <20200109224625.1470433-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Take the little bit of documentation for resources from various commit
messages and combine it into a new devlink-resource.rst file.

This could probably be expanded on even further by someone with more
knowledge of how the devlink resources work.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 .../networking/devlink/devlink-resource.rst   | 62 +++++++++++++++++++
 Documentation/networking/devlink/index.rst    |  1 +
 2 files changed, 63 insertions(+)
 create mode 100644 Documentation/networking/devlink/devlink-resource.rst

diff --git a/Documentation/networking/devlink/devlink-resource.rst b/Documentation/networking/devlink/devlink-resource.rst
new file mode 100644
index 000000000000..93e92d2f0752
--- /dev/null
+++ b/Documentation/networking/devlink/devlink-resource.rst
@@ -0,0 +1,62 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Devlink Resource
+================
+
+``devlink`` provides the ability for drivers to register resources, which
+can allow administrators to see the device restrictions for a given
+resource, as well as how much of the given resource is currently
+in use. Additionally, these resources can optionally have configurable size.
+This could enable the administrator to limit the number of resources that
+are used.
+
+For example, the ``netdevsim`` driver enables ``/IPv4/fib`` and
+``/IPv4/fib-rules`` as resources to limit the number of IPv4 FIB entries and
+rules for a given device.
+
+Resource Ids
+============
+
+Each resource is represented by an id, and contains information about its
+current size and related sub resources. To access a sub resource, you
+specify the path of the resource. For example ``/IPv4/fib`` is the id for
+the ``fib`` sub-resource under the ``IPv4`` resource.
+
+example usage
+-------------
+
+The resources exposed by the driver can be observed, for example:
+
+.. code:: shell
+
+    $devlink resource show pci/0000:03:00.0
+    pci/0000:03:00.0:
+      name kvd size 245760 unit entry
+        resources:
+          name linear size 98304 occ 0 unit entry size_min 0 size_max 147456 size_gran 128
+          name hash_double size 60416 unit entry size_min 32768 size_max 180224 size_gran 128
+          name hash_single size 87040 unit entry size_min 65536 size_max 212992 size_gran 128
+
+Some resource's size can be changed. Examples:
+
+.. code:: shell
+
+    $devlink resource set pci/0000:03:00.0 path /kvd/hash_single size 73088
+    $devlink resource set pci/0000:03:00.0 path /kvd/hash_double size 74368
+
+The changes do not apply immediately, this can be validated by the 'size_new'
+attribute, which represents the pending change in size. For example:
+
+.. code:: shell
+
+    $devlink resource show pci/0000:03:00.0
+    pci/0000:03:00.0:
+      name kvd size 245760 unit entry size_valid false
+      resources:
+        name linear size 98304 size_new 147456 occ 0 unit entry size_min 0 size_max 147456 size_gran 128
+        name hash_double size 60416 unit entry size_min 32768 size_max 180224 size_gran 128
+        name hash_single size 87040 unit entry size_min 65536 size_max 212992 size_gran 128
+
+Note that changes in resource size may require a device reload to properly
+take effect.
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 2417d56e27cc..10b51d863a5c 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -17,6 +17,7 @@ general.
    devlink-info
    devlink-params
    devlink-region
+   devlink-resource
    devlink-trap
 
 Driver-specific documentation
-- 
2.25.0.rc1

