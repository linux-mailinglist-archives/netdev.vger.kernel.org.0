Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C50818DEA6
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 09:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgCUIKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 04:10:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:33283 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbgCUIKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 04:10:33 -0400
IronPort-SDR: heSia2q92YS4Q7KibDeeqoUBUQcNR/OlSQONfhJRXVWMVrmLMDl1kA6C3pYAYUk0NgQ2zy0YqO
 pcICeR+zug0w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2020 01:10:31 -0700
IronPort-SDR: Vwgj+TQWsk/UXS0GvctELSJKKJDh/IxB2EmhTPLEWjdeC1U0iFu4nCOUUqMvdNYtAqijzuQlQH
 oOF0D5POFiWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,287,1580803200"; 
   d="scan'208";a="234737969"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 21 Mar 2020 01:10:30 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 7/9] devlink: promote "fw.bundle_id" to a generic info version
Date:   Sat, 21 Mar 2020 01:10:26 -0700
Message-Id: <20200321081028.2763550-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
References: <20200321081028.2763550-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The nfp driver uses ``fw.bundle_id`` to represent a unique identifier of the
entire firmware bundle.

A future change is going to introduce a similar notion in the ice
driver, so promote ``fw.bundle_id`` into a generic version now.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 Documentation/networking/devlink/devlink-info.rst | 5 +++++
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c  | 2 +-
 include/net/devlink.h                             | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
index 70981dd1b981..b701899b7f42 100644
--- a/Documentation/networking/devlink/devlink-info.rst
+++ b/Documentation/networking/devlink/devlink-info.rst
@@ -98,3 +98,8 @@ fw.roce
 
 RoCE firmware version which is responsible for handling roce
 management.
+
+fw.bundle_id
+------------
+
+Unique identifier of the entire firmware bundle.
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index c50fce42f473..07dbf4d72227 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -211,7 +211,7 @@ static const struct nfp_devlink_versions {
 	enum nfp_nsp_versions id;
 	const char *key;
 } nfp_devlink_versions_nsp[] = {
-	{ NFP_VERSIONS_BUNDLE,	"fw.bundle_id", },
+	{ NFP_VERSIONS_BUNDLE,	DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID, },
 	{ NFP_VERSIONS_BSP,	DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, },
 	{ NFP_VERSIONS_CPLD,	"fw.cpld", },
 	{ NFP_VERSIONS_APP,	DEVLINK_INFO_VERSION_GENERIC_FW_APP, },
diff --git a/include/net/devlink.h b/include/net/devlink.h
index c9ca86b054bc..e68781b9b7d4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -490,6 +490,8 @@ enum devlink_param_generic_id {
 #define DEVLINK_INFO_VERSION_GENERIC_FW_PSID	"fw.psid"
 /* RoCE FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE	"fw.roce"
+/* Firmware bundle identifier */
+#define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID	"fw.bundle_id"
 
 struct devlink_region;
 struct devlink_info_req;
-- 
2.25.1

