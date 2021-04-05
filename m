Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509FA353BA2
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhDEFYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232184AbhDEFYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 01:24:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8480761399;
        Mon,  5 Apr 2021 05:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617600269;
        bh=p/hww5IZwUmzeql1CaZSwd9MbMxjAL9Py3kRE/ZWykI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLDgHWnJZEA57dXtfbUnnMoN/P65nZ62XVceMV0PYewnSGtXpa1kEmCn/aU7YHKau
         MhUfd5vWeGLxn/LMJ/EQN9Ip3pQqBTuSZ4m4km9tfyG5RTzN1ZyYU4QixYyzJsDqzO
         XlL7M6JX3pBDqjeArPmtC8gPieGD6EFcnV3lbqgZy/pXahBL3gbinib+Mw87e/3tPi
         lUExqbfEvV9NXPic6DXti8R2W9MHIurmzIhR9VkfDoD3I7ceB2DjwrJt2aH2/L45n6
         2VPIPu5r6tPNnG0JsUIAp3gBDb6CDio6PV6WPJ8inYhOWZ/yUfGECBUUE2tCamY992
         hR0HSc24y6wsw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Avihai Horon <avihaih@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>,
        rds-devel@oss.oracle.com, Sagi Grimberg <sagi@grimberg.me>,
        samba-technical@lists.samba.org,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next 02/10] RDMA/core: Enable Relaxed Ordering in __ib_alloc_pd()
Date:   Mon,  5 Apr 2021 08:23:56 +0300
Message-Id: <20210405052404.213889-3-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405052404.213889-1-leon@kernel.org>
References: <20210405052404.213889-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

Enable Relaxed Ordering in __ib_alloc_pd() allocation of the
local_dma_lkey.

This will take effect only for devices that don't pre-allocate the lkey
but allocate it per PD allocation.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/verbs.c              | 3 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a1782f8a6ca0..9b719f7d6fd5 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -287,7 +287,8 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
 		pd->local_dma_lkey = device->local_dma_lkey;
 	else
-		mr_access_flags |= IB_ACCESS_LOCAL_WRITE;
+		mr_access_flags |=
+			IB_ACCESS_LOCAL_WRITE | IB_ACCESS_RELAXED_ORDERING;
 
 	if (flags & IB_PD_UNSAFE_GLOBAL_RKEY) {
 		pr_warn("%s: enabling unsafe global rkey\n", caller);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
index b3fa783698a0..d74827694f92 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c
@@ -66,6 +66,7 @@ struct ib_mr *pvrdma_get_dma_mr(struct ib_pd *pd, int acc)
 	int ret;
 
 	/* Support only LOCAL_WRITE flag for DMA MRs */
+	acc &= ~IB_ACCESS_RELAXED_ORDERING;
 	if (acc & ~IB_ACCESS_LOCAL_WRITE) {
 		dev_warn(&dev->pdev->dev,
 			 "unsupported dma mr access flags %#x\n", acc);
-- 
2.30.2

