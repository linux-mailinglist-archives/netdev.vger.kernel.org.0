Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41887369748
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243158AbhDWQlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:13569 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231341AbhDWQlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:31 -0400
IronPort-SDR: Zv45ehdGcKWMRsbRkdqMXT2SUvhlE5glazUPhUBbbMQr3c0gJ7LPUOrZC4XQ1jL43La94w+SxW
 31TvIOI+mg3A==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218639"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218639"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:53 -0700
IronPort-SDR: yTdkVDXI5E6J6geH12M21Z9riRZEyxmKeWUr/3eQh8tR+FeSi61N4QPDsNzcRYjf9CFm0CSm4A
 lh6IsmFXAP2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285975"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:52 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 6/8] iavf: change the flex-byte support number to macro definition
Date:   Fri, 23 Apr 2021 09:42:45 -0700
Message-Id: <20210423164247.3252913-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

The maximum number (2) of flex-byte support is derived from ethtool
use-def data size (8 byte).

Change the magic number 2 to macro definition, and add the comment to
track the design thinking, so the code is clear and easily maintained.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_fdir.h    | 9 +++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 3d904bc6ee76..af43fbd8cb75 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -939,7 +939,7 @@ iavf_parse_rx_flow_user_data(struct ethtool_rx_flow_spec *fsp,
 	if (!(fsp->flow_type & FLOW_EXT))
 		return 0;
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < IAVF_FLEX_WORD_NUM; i++) {
 #define IAVF_USERDEF_FLEX_WORD_M	GENMASK(15, 0)
 #define IAVF_USERDEF_FLEX_OFFS_S	16
 #define IAVF_USERDEF_FLEX_OFFS_M	GENMASK(31, IAVF_USERDEF_FLEX_OFFS_S)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.h b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
index 2439c970b657..33c55c366315 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.h
@@ -35,6 +35,11 @@ enum iavf_fdir_flow_type {
 	IAVF_FDIR_FLOW_PTYPE_MAX,
 };
 
+/* Must not exceed the array element number of '__be32 data[2]' in the ethtool
+ * 'struct ethtool_rx_flow_spec.m_ext.data[2]' to express the flex-byte (word).
+ */
+#define IAVF_FLEX_WORD_NUM	2
+
 struct iavf_flex_word {
 	u16 offset;
 	u16 word;
@@ -71,7 +76,7 @@ struct iavf_fdir_ip {
 };
 
 struct iavf_fdir_extra {
-	u32 usr_def[2];
+	u32 usr_def[IAVF_FLEX_WORD_NUM];
 };
 
 /* bookkeeping of Flow Director filters */
@@ -95,7 +100,7 @@ struct iavf_fdir_fltr {
 	/* flex byte filter data */
 	u8 ip_ver; /* used to adjust the flex offset, 4 : IPv4, 6 : IPv6 */
 	u8 flex_cnt;
-	struct iavf_flex_word flex_words[2];
+	struct iavf_flex_word flex_words[IAVF_FLEX_WORD_NUM];
 
 	u32 flow_id;
 
-- 
2.26.2

