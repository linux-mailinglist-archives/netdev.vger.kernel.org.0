Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B39D11CBE9
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 12:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfLLLJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 06:09:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbfLLLJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 06:09:45 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C226A227BF;
        Thu, 12 Dec 2019 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576148985;
        bh=TzwtMqb4TA5NrCoAHwMIif22JuuxfMAOrgLgDLiN1iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dT/aYXKCojly1+IUBxWLdzu2K6Z1UPWypjGPuproAf02otIRVBEFggv3cXD6UWD7k
         yS2lI+439C3+C1TEx+Nn8NnMhnS4T7W7o0jLCHlHA0JWMcLm/+OFbzlDVdCv8w++NL
         YiV/3IzBfsoJw0vMiNxA0XaMsVDHYLdfPjnrhp8s=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Shahaf Shuler <shahafs@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 5/5] IB/mlx5: Add mmap support for VAR
Date:   Thu, 12 Dec 2019 13:09:28 +0200
Message-Id: <20191212110928.334995-6-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191212110928.334995-1-leon@kernel.org>
References: <20191212110928.334995-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Add mmap support for VAR, it uses the 'offset' command mode with
involvement of IB core APIs to find the previously allocated mmap entry.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 873480b07686..52bc86ab9490 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2253,7 +2253,10 @@ static int mlx5_ib_mmap_offset(struct mlx5_ib_dev *dev,
 
 	mentry = to_mmmap(entry);
 	pfn = (mentry->address >> PAGE_SHIFT);
-	prot = pgprot_writecombine(vma->vm_page_prot);
+	if (mentry->mmap_flag == MLX5_IB_MMAP_TYPE_VAR)
+		prot = pgprot_noncached(vma->vm_page_prot);
+	else
+		prot = pgprot_writecombine(vma->vm_page_prot);
 	ret = rdma_user_mmap_io(ucontext, vma, pfn,
 				entry->npages * PAGE_SIZE,
 				prot,
-- 
2.20.1

