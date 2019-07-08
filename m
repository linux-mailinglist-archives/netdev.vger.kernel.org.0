Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A588D61C4B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbfGHJRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729747AbfGHJRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:08 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689GO4c013898;
        Mon, 8 Jul 2019 02:16:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZY+YgJw9iCWYi1PTdXoEwEqxZK9VdAR2ULCLNE3529g=;
 b=rKeKmVq4Bqr7QP4JbKVLFxyG0+D/bXW531UgZPsZ1T1evgq9QMJQBLV4Ojpm75VbPbg0
 zwhLehMqHp+S3tC29ivZ7LRQI4WD2MA8GpToaoiOrpZ5nRCv1QyNJMZbpkfO52O6pTWb
 tnE3J+MRuLfPQbTduXtf357vMHtnGiX/02nksPoptapEzgm3lgdDAfkd/yMCmuzTfdNF
 dPW2hmjKpLBuCOsHfCK5UlRHESigdJ0S9LlpnJY9omIRaWMBCzdR8TV2jXvR+QnNmYul
 zCuyMCVOmozNV74o0FsA2sX411yKp9u4spALAZAZdkLVVOZYsE2YlPMsSjVTjwPVR8+Z 9Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f8m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:41 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:41 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 838713F703F;
        Mon,  8 Jul 2019 02:16:38 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and cookie helper functions
Date:   Mon, 8 Jul 2019 12:14:58 +0300
Message-ID: <20190708091503.14723-2-michal.kalderon@marvell.com>
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

Create some common API's for adding entries to a xa_mmap.
Searching for an entry and freeing one.

The code was copied from the efa driver almost as is, just renamed
function to be generic and not efa specific.

Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/core/device.c      |   1 +
 drivers/infiniband/core/rdma_core.c   |   1 +
 drivers/infiniband/core/uverbs_cmd.c  |   1 +
 drivers/infiniband/core/uverbs_main.c | 105 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h               |  32 +++++++++++
 5 files changed, 140 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 8a6ccb936dfe..a830c2c5d691 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2521,6 +2521,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
 	SET_DEVICE_OP(dev_ops, map_phys_fmr);
 	SET_DEVICE_OP(dev_ops, mmap);
+	SET_DEVICE_OP(dev_ops, mmap_free);
 	SET_DEVICE_OP(dev_ops, modify_ah);
 	SET_DEVICE_OP(dev_ops, modify_cq);
 	SET_DEVICE_OP(dev_ops, modify_device);
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index ccf4d069c25c..7166741834c8 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -817,6 +817,7 @@ static void ufile_destroy_ucontext(struct ib_uverbs_file *ufile,
 	rdma_restrack_del(&ucontext->res);
 
 	ib_dev->ops.dealloc_ucontext(ucontext);
+	rdma_user_mmap_entries_remove_free(ucontext);
 	kfree(ucontext);
 
 	ufile->ucontext = NULL;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7ddd0e5bc6b3..44c0600245e4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -254,6 +254,7 @@ static int ib_uverbs_get_context(struct uverbs_attr_bundle *attrs)
 
 	mutex_init(&ucontext->per_mm_list_lock);
 	INIT_LIST_HEAD(&ucontext->per_mm_list);
+	xa_init(&ucontext->mmap_xa);
 
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 11c13c1381cf..37507cc27e8c 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -965,6 +965,111 @@ int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL(rdma_user_mmap_io);
 
+static inline u64
+rdma_user_mmap_get_key(const struct rdma_user_mmap_entry *entry)
+{
+	return (u64)entry->mmap_page << PAGE_SHIFT;
+}
+
+struct rdma_user_mmap_entry *
+rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len)
+{
+	struct rdma_user_mmap_entry *entry;
+	u64 mmap_page;
+
+	mmap_page = key >> PAGE_SHIFT;
+	if (mmap_page > U32_MAX)
+		return NULL;
+
+	entry = xa_load(&ucontext->mmap_xa, mmap_page);
+	if (!entry || rdma_user_mmap_get_key(entry) != key ||
+	    entry->length != len)
+		return NULL;
+
+	ibdev_dbg(ucontext->device,
+		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
+		  entry->obj, key, entry->address, entry->length);
+
+	return entry;
+}
+EXPORT_SYMBOL(rdma_user_mmap_entry_get);
+
+/*
+ * Note this locking scheme cannot support removal of entries, except during
+ * ucontext destruction when the core code guarentees no concurrency.
+ */
+u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
+				u64 address, u64 length, u8 mmap_flag)
+{
+	struct rdma_user_mmap_entry *entry;
+	u32 next_mmap_page;
+	int err;
+
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return RDMA_USER_MMAP_INVALID;
+
+	entry->obj = obj;
+	entry->address = address;
+	entry->length = length;
+	entry->mmap_flag = mmap_flag;
+
+	xa_lock(&ucontext->mmap_xa);
+	if (check_add_overflow(ucontext->mmap_xa_page,
+			       (u32)(length >> PAGE_SHIFT),
+			       &next_mmap_page))
+		goto err_unlock;
+
+	entry->mmap_page = ucontext->mmap_xa_page;
+	ucontext->mmap_xa_page = next_mmap_page;
+	err = __xa_insert(&ucontext->mmap_xa, entry->mmap_page, entry,
+			  GFP_KERNEL);
+	if (err)
+		goto err_unlock;
+
+	xa_unlock(&ucontext->mmap_xa);
+
+	ibdev_dbg(ucontext->device,
+		  "mmap: obj[0x%p] addr[%#llx], len[%#llx], key[%#llx] inserted\n",
+		  entry->obj, entry->address, entry->length,
+		  rdma_user_mmap_get_key(entry));
+
+	return rdma_user_mmap_get_key(entry);
+
+err_unlock:
+	xa_unlock(&ucontext->mmap_xa);
+	kfree(entry);
+	return RDMA_USER_MMAP_INVALID;
+}
+EXPORT_SYMBOL(rdma_user_mmap_entry_insert);
+
+/*
+ * This is only called when the ucontext is destroyed and there can be no
+ * concurrent query via mmap or allocate on the xarray, thus we can be sure no
+ * other thread is using the entry pointer. We also know that all the BAR
+ * pages have either been zap'd or munmaped at this point.  Normal pages are
+ * refcounted and will be freed at the proper time.
+ */
+void rdma_user_mmap_entries_remove_free(struct ib_ucontext *ucontext)
+{
+	struct rdma_user_mmap_entry *entry;
+	unsigned long mmap_page;
+
+	xa_for_each(&ucontext->mmap_xa, mmap_page, entry) {
+		xa_erase(&ucontext->mmap_xa, mmap_page);
+
+		ibdev_dbg(ucontext->device,
+			  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
+			  entry->obj, rdma_user_mmap_get_key(entry),
+			  entry->address, entry->length);
+		if (ucontext->device->ops.mmap_free)
+			ucontext->device->ops.mmap_free(entry->address,
+							entry->length,
+							entry->mmap_flag);
+		kfree(entry);
+	}
+}
+
 void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 {
 	struct rdma_umap_priv *priv, *next_priv;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 26e9c2594913..54ce3fdae180 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1425,6 +1425,8 @@ struct ib_ucontext {
 	 * Implementation details of the RDMA core, don't use in drivers:
 	 */
 	struct rdma_restrack_entry res;
+	struct xarray mmap_xa;
+	u32 mmap_xa_page;
 };
 
 struct ib_uobject {
@@ -2311,6 +2313,7 @@ struct ib_device_ops {
 			      struct ib_udata *udata);
 	void (*dealloc_ucontext)(struct ib_ucontext *context);
 	int (*mmap)(struct ib_ucontext *context, struct vm_area_struct *vma);
+	void (*mmap_free)(u64 address, u64 length, u8 mmap_flag);
 	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
 	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
 	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
@@ -2706,9 +2709,23 @@ void  ib_set_client_data(struct ib_device *device, struct ib_client *client,
 void ib_set_device_ops(struct ib_device *device,
 		       const struct ib_device_ops *ops);
 
+#define RDMA_USER_MMAP_INVALID U64_MAX
+struct rdma_user_mmap_entry {
+	void  *obj;
+	u64 address;
+	u64 length;
+	u32 mmap_page;
+	u8 mmap_flag;
+};
+
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
 		      unsigned long pfn, unsigned long size, pgprot_t prot);
+u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
+				u64 address, u64 length, u8 mmap_flag);
+struct rdma_user_mmap_entry *
+rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len);
+void rdma_user_mmap_entries_remove_free(struct ib_ucontext *ucontext);
 #else
 static inline int rdma_user_mmap_io(struct ib_ucontext *ucontext,
 				    struct vm_area_struct *vma,
@@ -2717,6 +2734,21 @@ static inline int rdma_user_mmap_io(struct ib_ucontext *ucontext,
 {
 	return -EINVAL;
 }
+
+static u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
+				       u64 address, u64 length, u8 mmap_flag)
+{
+	return RDMA_USER_MMAP_INVALID;
+}
+
+static struct rdma_user_mmap_entry *
+rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len)
+{
+	return NULL;
+}
+
+static void rdma_user_mmap_entries_remove_free(struct ib_ucontext *ucontext) {}
+
 #endif
 
 static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t len)
-- 
2.14.5

