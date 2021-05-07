Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C03768F0
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbhEGQlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:41:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:29740 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238326AbhEGQk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:40:57 -0400
IronPort-SDR: 5UHJ6irPDfGQCmbUdezgeyKvVtLGm9jELDwe6KJs6AHu5gpgBeEoR5OM8pqIU61fsZG4XPMwTC
 t8dB3jfYCQGQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196748697"
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="196748697"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 09:39:55 -0700
IronPort-SDR: F4eK39VhAJelfeX3XyAMm+g8Gc8hupB4z1bZNrogAkohrDckXNyeZqsgoKveNuio1uHFu8jpZ4
 zaHO5OFH3jaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,281,1613462400"; 
   d="scan'208";a="620267973"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 09:39:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yunjian Wang <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com
Subject: [PATCH net 2/5] i40e: Fix use-after-free in i40e_client_subtask()
Date:   Fri,  7 May 2021 09:41:48 -0700
Message-Id: <20210507164151.2878147-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
References: <20210507164151.2878147-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

Currently the call to i40e_client_del_instance frees the object
pf->cinst, however pf->cinst->lan_info is being accessed after
the free. Fix this by adding the missing return.

Addresses-Coverity: ("Read from pointer after free")
Fixes: 7b0b1a6d0ac9 ("i40e: Disable iWARP VSI PETCP_ENA flag on netdev down events")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index a2dba32383f6..32f3facbed1a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -375,6 +375,7 @@ void i40e_client_subtask(struct i40e_pf *pf)
 				clear_bit(__I40E_CLIENT_INSTANCE_OPENED,
 					  &cdev->state);
 				i40e_client_del_instance(pf);
+				return;
 			}
 		}
 	}
-- 
2.26.2

