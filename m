Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417DA390C87
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhEYXBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:32838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhEYXBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8BD1613D5;
        Tue, 25 May 2021 22:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983581;
        bh=gTZAgrzB4+T/6N1sAeSXHaiO0/ElpJNF7LZZgYhlfYQ=;
        h=Date:From:To:Cc:Subject:From;
        b=PipcE7xDG+yf/31f2wV1b8p7s8c0CmOAE+z4YUwdAaSwQ5QJp5XOhxU3s18vGKm0b
         bheC0DmbiAyIshUQbGdb00isAsklfM7saJNNl+LqnF6TAtQPrRG4O7qPeU5gkqTO7o
         u9lsT3FlXOK1DrVC7takFogdo6P/s9DSWGxy1wyMdhceKXJWJsk7/lx5rMVyiLLjII
         bDPtNjvD+i3BxO4Reu5+FqHeF0KfYKFjz/qcmiNLKe6tsy1GF98LJ35s9fxdxSCKfd
         dr0C+86CkWhy2E+gA9aDXW/6WM2JkpwGrhfsQ0PiyWgZm+zd2P8sjx8PRJ8uszXIo0
         y9/M/ZOqbF7zA==
Date:   Tue, 25 May 2021 18:00:38 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Faisal Latif <faisal.latif@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] i40e: Replace one-element array with flexible-array
 member
Message-ID: <20210525230038.GA175516@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.27.0

