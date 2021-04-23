Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3603369749
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbhDWQlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:41:37 -0400
Received: from mga17.intel.com ([192.55.52.151]:13573 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242366AbhDWQlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:41:31 -0400
IronPort-SDR: gqHPwKpH+sZFBiE6F+iXG7wM+TqQGeLF6LS/JkSkMIwZuAAjGj6sbeWVJ/K+rAdEVZYqJDzSyS
 klSJbxVOYE2Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="176218640"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="176218640"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 09:40:53 -0700
IronPort-SDR: NIQdGqd5Ym5u4OfXCzDJiwcb6mj2ZHpwp48PNcTWSSuDt0CBg3LRZbTYShfOFqqsoMwsmxBQQq
 h1okwiGlzZOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="456285978"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2021 09:40:53 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next 7/8] iavf: enhance the duplicated FDIR list scan handling
Date:   Fri, 23 Apr 2021 09:42:46 -0700
Message-Id: <20210423164247.3252913-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
References: <20210423164247.3252913-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

When the FDIR entry is found, just return the result directly to break
the loop.

Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_fdir.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_fdir.c b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
index 3e687189d737..af872ea3163f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_fdir.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_fdir.c
@@ -713,7 +713,6 @@ void iavf_print_fdir_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *f
 bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *fltr)
 {
 	struct iavf_fdir_fltr *tmp;
-	bool ret = false;
 
 	list_for_each_entry(tmp, &adapter->fdir_list_head, list) {
 		if (tmp->flow_type != fltr->flow_type)
@@ -724,13 +723,11 @@ bool iavf_fdir_is_dup_fltr(struct iavf_adapter *adapter, struct iavf_fdir_fltr *
 		    !memcmp(&tmp->ip_data, &fltr->ip_data,
 			    sizeof(fltr->ip_data)) &&
 		    !memcmp(&tmp->ext_data, &fltr->ext_data,
-			    sizeof(fltr->ext_data))) {
-			ret = true;
-			break;
-		}
+			    sizeof(fltr->ext_data)))
+			return true;
 	}
 
-	return ret;
+	return false;
 }
 
 /**
-- 
2.26.2

