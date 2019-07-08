Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D211761C43
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbfGHJRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:09 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729008AbfGHJRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689G4Dn013491;
        Mon, 8 Jul 2019 02:16:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ch8FBqmM3lr8his4yceY4JooDgc+Byo7CXlJ4bP24UU=;
 b=cP3AqlZvlqStazEvcHGs1eoCP2nLIxZEJ05LB79GkxNB81HFgozNdnpgPcDAUrwoMuro
 dZhzqsc1mVaMZUvlQsG8seLtGETMhNGY6yjLimmupEP/RJLDhwqqbe8WJP7KSR6hxJpR
 9E6RX6nuXXEDK56uSxXELN9EEMCXdPlXBga5qIfZT4nWC0B65cx1lZa1+7TcvBV24N1X
 CVQzabpWlPgYrl2wnt4+KrvoFpFbAxpjR+NN7bPf522kTvyFTNBYkXZfYXZDCRbO5tPc
 01uBRYVD2rD+TgaikSDB1CDqSVN1NM7j3dz2lzqehoHv92j4/Cg9+JfoeuZICsRaBlCI tw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:46 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:44 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:44 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 401883F703F;
        Mon,  8 Jul 2019 02:16:42 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 2/6] RDMA/efa: Use the common mmap_xa helpers
Date:   Mon, 8 Jul 2019 12:14:59 +0300
Message-ID: <20190708091503.14723-3-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190708091503.14723-1-michal.kalderon@marvell.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_02:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the functions related to managing the mmap_xa database.
This code was copied to the ib_core. Use the common API's instead.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/hw/efa/efa.h       |   3 +-
 drivers/infiniband/hw/efa/efa_main.c  |   1 +
 drivers/infiniband/hw/efa/efa_verbs.c | 183 ++++++++--------------------------
 3 files changed, 42 insertions(+), 145 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa.h b/drivers/infiniband/hw/efa/efa.h
index 119f8efec564..4afcf3679cdb 100644
--- a/drivers/infiniband/hw/efa/efa.h
+++ b/drivers/infiniband/hw/efa/efa.h
@@ -71,8 +71,6 @@ struct efa_dev {
 
 struct efa_ucontext {
 	struct ib_ucontext ibucontext;
-	struct xarray mmap_xa;
-	u32 mmap_xa_page;
 	u16 uarn;
 };
 
@@ -147,6 +145,7 @@ int efa_alloc_ucontext(struct ib_ucontext *ibucontext, struct ib_udata *udata);
 void efa_dealloc_ucontext(struct ib_ucontext *ibucontext);
 int efa_mmap(struct ib_ucontext *ibucontext,
 	     struct vm_area_struct *vma);
+void efa_mmap_free(u64 address, u64 length, u8 mmap_flag);
 int efa_create_ah(struct ib_ah *ibah,
 		  struct rdma_ah_attr *ah_attr,
 		  u32 flags,
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index dd1c6d49466f..65508c73accd 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -215,6 +215,7 @@ static const struct ib_device_ops efa_dev_ops = {
 	.get_link_layer = efa_port_link_layer,
 	.get_port_immutable = efa_get_port_immutable,
 	.mmap = efa_mmap,
+	.mmap_free = efa_mmap_free,
 	.modify_qp = efa_modify_qp,
 	.query_device = efa_query_device,
 	.query_gid = efa_query_gid,
diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index df77bc312a25..5dff892da161 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -13,34 +13,15 @@
 
 #include "efa.h"
 
-#define EFA_MMAP_FLAG_SHIFT 56
-#define EFA_MMAP_PAGE_MASK GENMASK(EFA_MMAP_FLAG_SHIFT - 1, 0)
-#define EFA_MMAP_INVALID U64_MAX
-
 enum {
 	EFA_MMAP_DMA_PAGE = 0,
 	EFA_MMAP_IO_WC,
 	EFA_MMAP_IO_NC,
 };
-
 #define EFA_AENQ_ENABLED_GROUPS \
 	(BIT(EFA_ADMIN_FATAL_ERROR) | BIT(EFA_ADMIN_WARNING) | \
 	 BIT(EFA_ADMIN_NOTIFICATION) | BIT(EFA_ADMIN_KEEP_ALIVE))
 
-struct efa_mmap_entry {
-	void  *obj;
-	u64 address;
-	u64 length;
-	u32 mmap_page;
-	u8 mmap_flag;
-};
-
-static inline u64 get_mmap_key(const struct efa_mmap_entry *efa)
-{
-	return ((u64)efa->mmap_flag << EFA_MMAP_FLAG_SHIFT) |
-	       ((u64)efa->mmap_page << PAGE_SHIFT);
-}
-
 #define EFA_CHUNK_PAYLOAD_SHIFT       12
 #define EFA_CHUNK_PAYLOAD_SIZE        BIT(EFA_CHUNK_PAYLOAD_SHIFT)
 #define EFA_CHUNK_PAYLOAD_PTR_SIZE    8
@@ -145,105 +126,7 @@ static void *efa_zalloc_mapped(struct efa_dev *dev, dma_addr_t *dma_addr,
 	return addr;
 }
 
-/*
- * This is only called when the ucontext is destroyed and there can be no
- * concurrent query via mmap or allocate on the xarray, thus we can be sure no
- * other thread is using the entry pointer. We also know that all the BAR
- * pages have either been zap'd or munmaped at this point.  Normal pages are
- * refcounted and will be freed at the proper time.
- */
-static void mmap_entries_remove_free(struct efa_dev *dev,
-				     struct efa_ucontext *ucontext)
-{
-	struct efa_mmap_entry *entry;
-	unsigned long mmap_page;
 
-	xa_for_each(&ucontext->mmap_xa, mmap_page, entry) {
-		xa_erase(&ucontext->mmap_xa, mmap_page);
-
-		ibdev_dbg(
-			&dev->ibdev,
-			"mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
-			entry->obj, get_mmap_key(entry), entry->address,
-			entry->length);
-		if (entry->mmap_flag == EFA_MMAP_DMA_PAGE)
-			/* DMA mapping is already gone, now free the pages */
-			free_pages_exact(phys_to_virt(entry->address),
-					 entry->length);
-		kfree(entry);
-	}
-}
-
-static struct efa_mmap_entry *mmap_entry_get(struct efa_dev *dev,
-					     struct efa_ucontext *ucontext,
-					     u64 key, u64 len)
-{
-	struct efa_mmap_entry *entry;
-	u64 mmap_page;
-
-	mmap_page = (key & EFA_MMAP_PAGE_MASK) >> PAGE_SHIFT;
-	if (mmap_page > U32_MAX)
-		return NULL;
-
-	entry = xa_load(&ucontext->mmap_xa, mmap_page);
-	if (!entry || get_mmap_key(entry) != key || entry->length != len)
-		return NULL;
-
-	ibdev_dbg(&dev->ibdev,
-		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
-		  entry->obj, key, entry->address, entry->length);
-
-	return entry;
-}
-
-/*
- * Note this locking scheme cannot support removal of entries, except during
- * ucontext destruction when the core code guarentees no concurrency.
- */
-static u64 mmap_entry_insert(struct efa_dev *dev, struct efa_ucontext *ucontext,
-			     void *obj, u64 address, u64 length, u8 mmap_flag)
-{
-	struct efa_mmap_entry *entry;
-	u32 next_mmap_page;
-	int err;
-
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return EFA_MMAP_INVALID;
-
-	entry->obj = obj;
-	entry->address = address;
-	entry->length = length;
-	entry->mmap_flag = mmap_flag;
-
-	xa_lock(&ucontext->mmap_xa);
-	if (check_add_overflow(ucontext->mmap_xa_page,
-			       (u32)(length >> PAGE_SHIFT),
-			       &next_mmap_page))
-		goto err_unlock;
-
-	entry->mmap_page = ucontext->mmap_xa_page;
-	ucontext->mmap_xa_page = next_mmap_page;
-	err = __xa_insert(&ucontext->mmap_xa, entry->mmap_page, entry,
-			  GFP_KERNEL);
-	if (err)
-		goto err_unlock;
-
-	xa_unlock(&ucontext->mmap_xa);
-
-	ibdev_dbg(
-		&dev->ibdev,
-		"mmap: obj[0x%p] addr[%#llx], len[%#llx], key[%#llx] inserted\n",
-		entry->obj, entry->address, entry->length, get_mmap_key(entry));
-
-	return get_mmap_key(entry);
-
-err_unlock:
-	xa_unlock(&ucontext->mmap_xa);
-	kfree(entry);
-	return EFA_MMAP_INVALID;
-
-}
 
 int efa_query_device(struct ib_device *ibdev,
 		     struct ib_device_attr *props,
@@ -488,45 +371,52 @@ static int qp_mmap_entries_setup(struct efa_qp *qp,
 				 struct efa_com_create_qp_params *params,
 				 struct efa_ibv_create_qp_resp *resp)
 {
+	u64 address;
+	u64 length;
 	/*
 	 * Once an entry is inserted it might be mmapped, hence cannot be
 	 * cleaned up until dealloc_ucontext.
 	 */
 	resp->sq_db_mmap_key =
-		mmap_entry_insert(dev, ucontext, qp,
-				  dev->db_bar_addr + resp->sq_db_offset,
-				  PAGE_SIZE, EFA_MMAP_IO_NC);
-	if (resp->sq_db_mmap_key == EFA_MMAP_INVALID)
+		rdma_user_mmap_entry_insert(&ucontext->ibucontext, qp,
+					    dev->db_bar_addr +
+					    resp->sq_db_offset,
+					    PAGE_SIZE, EFA_MMAP_IO_NC);
+	if (resp->sq_db_mmap_key == RDMA_USER_MMAP_INVALID)
 		return -ENOMEM;
 
 	resp->sq_db_offset &= ~PAGE_MASK;
 
+	address = dev->mem_bar_addr + resp->llq_desc_offset;
+	length = PAGE_ALIGN(params->sq_ring_size_in_bytes +
+			    (resp->llq_desc_offset & ~PAGE_MASK));
 	resp->llq_desc_mmap_key =
-		mmap_entry_insert(dev, ucontext, qp,
-				  dev->mem_bar_addr + resp->llq_desc_offset,
-				  PAGE_ALIGN(params->sq_ring_size_in_bytes +
-					     (resp->llq_desc_offset & ~PAGE_MASK)),
-				  EFA_MMAP_IO_WC);
-	if (resp->llq_desc_mmap_key == EFA_MMAP_INVALID)
+		rdma_user_mmap_entry_insert(&ucontext->ibucontext, qp,
+					    address,
+					    length,
+					    EFA_MMAP_IO_WC);
+	if (resp->llq_desc_mmap_key == RDMA_USER_MMAP_INVALID)
 		return -ENOMEM;
 
 	resp->llq_desc_offset &= ~PAGE_MASK;
 
 	if (qp->rq_size) {
+		address = dev->db_bar_addr + resp->rq_db_offset;
 		resp->rq_db_mmap_key =
-			mmap_entry_insert(dev, ucontext, qp,
-					  dev->db_bar_addr + resp->rq_db_offset,
-					  PAGE_SIZE, EFA_MMAP_IO_NC);
-		if (resp->rq_db_mmap_key == EFA_MMAP_INVALID)
+			rdma_user_mmap_entry_insert(&ucontext->ibucontext, qp,
+						    address, PAGE_SIZE,
+						    EFA_MMAP_IO_NC);
+		if (resp->rq_db_mmap_key == RDMA_USER_MMAP_INVALID)
 			return -ENOMEM;
 
 		resp->rq_db_offset &= ~PAGE_MASK;
 
+		address = virt_to_phys(qp->rq_cpu_addr);
 		resp->rq_mmap_key =
-			mmap_entry_insert(dev, ucontext, qp,
-					  virt_to_phys(qp->rq_cpu_addr),
-					  qp->rq_size, EFA_MMAP_DMA_PAGE);
-		if (resp->rq_mmap_key == EFA_MMAP_INVALID)
+			rdma_user_mmap_entry_insert(&ucontext->ibucontext, qp,
+						    address, qp->rq_size,
+						    EFA_MMAP_DMA_PAGE);
+		if (resp->rq_mmap_key == RDMA_USER_MMAP_INVALID)
 			return -ENOMEM;
 
 		resp->rq_mmap_size = qp->rq_size;
@@ -875,11 +765,13 @@ void efa_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 static int cq_mmap_entries_setup(struct efa_dev *dev, struct efa_cq *cq,
 				 struct efa_ibv_create_cq_resp *resp)
 {
+	struct efa_ucontext *ucontext = cq->ucontext;
 	resp->q_mmap_size = cq->size;
-	resp->q_mmap_key = mmap_entry_insert(dev, cq->ucontext, cq,
-					     virt_to_phys(cq->cpu_addr),
-					     cq->size, EFA_MMAP_DMA_PAGE);
-	if (resp->q_mmap_key == EFA_MMAP_INVALID)
+	resp->q_mmap_key =
+		rdma_user_mmap_entry_insert(&ucontext->ibucontext, cq,
+					    virt_to_phys(cq->cpu_addr),
+					    cq->size, EFA_MMAP_DMA_PAGE);
+	if (resp->q_mmap_key == RDMA_USER_MMAP_INVALID)
 		return -ENOMEM;
 
 	return 0;
@@ -1531,7 +1423,6 @@ int efa_alloc_ucontext(struct ib_ucontext *ibucontext, struct ib_udata *udata)
 		goto err_out;
 
 	ucontext->uarn = result.uarn;
-	xa_init(&ucontext->mmap_xa);
 
 	resp.cmds_supp_udata_mask |= EFA_USER_CMDS_SUPP_UDATA_QUERY_DEVICE;
 	resp.cmds_supp_udata_mask |= EFA_USER_CMDS_SUPP_UDATA_CREATE_AH;
@@ -1560,19 +1451,25 @@ void efa_dealloc_ucontext(struct ib_ucontext *ibucontext)
 	struct efa_ucontext *ucontext = to_eucontext(ibucontext);
 	struct efa_dev *dev = to_edev(ibucontext->device);
 
-	mmap_entries_remove_free(dev, ucontext);
 	efa_dealloc_uar(dev, ucontext->uarn);
 }
 
+void efa_mmap_free(u64 address, u64 length, u8 mmap_flag)
+{
+	/* DMA mapping is already gone, now free the pages */
+	if (mmap_flag == EFA_MMAP_DMA_PAGE)
+		free_pages_exact(phys_to_virt(address), length);
+}
+
 static int __efa_mmap(struct efa_dev *dev, struct efa_ucontext *ucontext,
 		      struct vm_area_struct *vma, u64 key, u64 length)
 {
-	struct efa_mmap_entry *entry;
+	struct rdma_user_mmap_entry *entry;
 	unsigned long va;
 	u64 pfn;
 	int err;
 
-	entry = mmap_entry_get(dev, ucontext, key, length);
+	entry = rdma_user_mmap_entry_get(&ucontext->ibucontext, key, length);
 	if (!entry) {
 		ibdev_dbg(&dev->ibdev, "key[%#llx] does not have valid entry\n",
 			  key);
-- 
2.14.5

