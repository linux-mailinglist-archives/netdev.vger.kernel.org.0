Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD13977EA
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 18:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhFAQ0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 12:26:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:25271 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231918AbhFAQ0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 12:26:10 -0400
IronPort-SDR: fZm5T0UVppqwr3avscqZ/gdYtkOp32bwAejCtFK4pVc/dwwefuj0lbnI8MBST9po5Z64MV8kkk
 KiHuK16XAJhw==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="183263175"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="183263175"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 09:24:22 -0700
IronPort-SDR: SY+9kS0eRCHXO4yPU8PZcRfeSdUlr16qHqcYhw7DLQuaeKTigPGnFmm3GKLJclSJ8qmGMzKXau
 XWE/273wXDcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="411292743"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 01 Jun 2021 09:24:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        anthony.l.nguyen@intel.com, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Subject: [PATCH net-next v3 1/7] i40e: Replace one-element array with flexible-array member
Date:   Tue,  1 Jun 2021 09:26:38 -0700
Message-Id: <20210601162644.1469616-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
References: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
i40e_qvlist_info instead of one-element array, and use the struct_size()
helper.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/infiniband/hw/i40iw/i40iw_main.c      | 5 ++---
 drivers/net/ethernet/intel/i40e/i40e_client.c | 2 +-
 include/linux/net/intel/i40e_client.h         | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index b496f30ce066..364f69cd620f 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1423,7 +1423,7 @@ static enum i40iw_status_code i40iw_save_msix_info(struct i40iw_device *iwdev,
 	struct i40e_qv_info *iw_qvinfo;
 	u32 ceq_idx;
 	u32 i;
-	u32 size;
+	size_t size;
 
 	if (!ldev->msix_count) {
 		i40iw_pr_err("No MSI-X vectors\n");
@@ -1433,8 +1433,7 @@ static enum i40iw_status_code i40iw_save_msix_info(struct i40iw_device *iwdev,
 	iwdev->msix_count = ldev->msix_count;
 
 	size = sizeof(struct i40iw_msix_vector) * iwdev->msix_count;
-	size += sizeof(struct i40e_qvlist_info);
-	size +=  sizeof(struct i40e_qv_info) * iwdev->msix_count - 1;
+	size += struct_size(iw_qvlist, qv_info, iwdev->msix_count);
 	iwdev->iw_msixtbl = kzalloc(size, GFP_KERNEL);
 
 	if (!iwdev->iw_msixtbl)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index 32f3facbed1a..63eab14a26df 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -579,7 +579,7 @@ static int i40e_client_setup_qvlist(struct i40e_info *ldev,
 	u32 v_idx, i, reg_idx, reg;
 
 	ldev->qvlist_info = kzalloc(struct_size(ldev->qvlist_info, qv_info,
-				    qvlist_info->num_vectors - 1), GFP_KERNEL);
+				    qvlist_info->num_vectors), GFP_KERNEL);
 	if (!ldev->qvlist_info)
 		return -ENOMEM;
 	ldev->qvlist_info->num_vectors = qvlist_info->num_vectors;
diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index f41387a8969f..fd7bc860a241 100644
--- a/include/linux/net/intel/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -48,7 +48,7 @@ struct i40e_qv_info {
 
 struct i40e_qvlist_info {
 	u32 num_vectors;
-	struct i40e_qv_info qv_info[1];
+	struct i40e_qv_info qv_info[];
 };
 
 
-- 
2.26.2

