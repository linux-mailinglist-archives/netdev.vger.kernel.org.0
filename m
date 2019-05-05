Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E148D13C86
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfEEBTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 21:19:13 -0400
Received: from mga18.intel.com ([134.134.136.126]:33075 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727366AbfEEBTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 21:19:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 18:14:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="297102568"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2019 18:14:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/12] i40e: Use struct_size() in kzalloc()
Date:   Sat,  4 May 2019 18:14:07 -0700
Message-Id: <20190505011409.6771-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
References: <20190505011409.6771-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);
instance = kzalloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)

Notice that, in this case, variable size is not necessary, hence it
is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 5f3b8b9ff511..e81530ca08d0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -578,11 +578,9 @@ static int i40e_client_setup_qvlist(struct i40e_info *ldev,
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_qv_info *qv_info;
 	u32 v_idx, i, reg_idx, reg;
-	u32 size;
 
-	size = sizeof(struct i40e_qvlist_info) +
-	       (sizeof(struct i40e_qv_info) * (qvlist_info->num_vectors - 1));
-	ldev->qvlist_info = kzalloc(size, GFP_KERNEL);
+	ldev->qvlist_info = kzalloc(struct_size(ldev->qvlist_info, qv_info,
+				    qvlist_info->num_vectors - 1), GFP_KERNEL);
 	if (!ldev->qvlist_info)
 		return -ENOMEM;
 	ldev->qvlist_info->num_vectors = qvlist_info->num_vectors;
-- 
2.20.1

