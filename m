Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE2637A3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfGIOT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:19:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53258 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfGIOT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 10:19:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69EGBBa017413;
        Tue, 9 Jul 2019 07:19:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=BRDRBKH4EgR8zXqHGiDXYjdCmWKSlH825U6397ZR+b0=;
 b=mGwfvEkWRlFu2XMcEkEcKgdY6UcKlUtmF+c7PFBaj4JLpjvpy7Emw22kS8d9FjHBhvVv
 e908gkprb0pHXx7ZWSPZKNWD44wz2Iyu/1w2JNseW7+8A/HT+7SqJExxi4+WB+eRflg2
 pdhkSyk3CfjxEnmPplAR1FfY1J+KBRYRcT6b1p0Z5l1QT9+LsAMwBJYCRXM9+3mEBtTw
 SLXoW0D66VXdV2MINnHknn5M2RSQ8NKkzPuT7vQzGI88aROqYPJdlhJZrFTmRFtzhmHD
 wWnOepUrvJBGzokin8gns4S5ROhxhCmmVqO4Hht82btBEk9vcCtj1YktqrZDgOOqWVZ5 uQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tmn10hjy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 07:19:08 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 07:19:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 9 Jul 2019 07:19:06 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 9F07E3F7041;
        Tue,  9 Jul 2019 07:19:04 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and cookie helper functions
Date:   Tue, 9 Jul 2019 17:17:30 +0300
Message-ID: <20190709141735.19193-2-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190709141735.19193-1-michal.kalderon@marvell.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create some common API's for adding entries to a xa_mmap.
Searching for an entry and freeing one.

The code was copied from the efa driver almost as is, just renamed
function to be generic and not efa specific.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/infiniband/core/device.c      |   1 +
 drivers/infiniband/core/rdma_core.c   |   1 +
 drivers/infiniband/core/uverbs_cmd.c  |   1 +
 drivers/infiniband/core/uverbs_main.c | 135 ++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h               |  46 ++++++++++++
 5 files changed, 184 insertions(+)

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
index ccf4d069c25c..1ed01b02401f 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -816,6 +816,7 @@ static void ufile_destroy_ucontext(struct ib_uverbs_file *ufile,
 
 	rdma_restrack_del(&ucontext->res);
 
+	rdma_user_mmap_entries_remove_free(ucontext);
 	ib_dev->ops.dealloc_ucontext(ucontext);
 	kfree(ucontext);
 
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
index 11c13c1381cf..4b909d7b97de 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -965,6 +965,141 @@ int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL(rdma_user_mmap_io);
 
+static inline u64
+rdma_user_mmap_get_key(const struct rdma_user_mmap_entry *entry)
+{
+	return (u64)entry->mmap_page << PAGE_SHIFT;
+}
+
+/**
+ * rdma_user_mmap_entry_get() - Get an entry from the mmap_xa.
+ *
+ * @ucontext: associated user context.
+ * @key: The key received from rdma_user_mmap_entry_insert which
+ *     is provided by user as the address to map.
+ * @len: The length the user wants to map
+ *
+ * This function is called when a user tries to mmap a key it
+ * initially received from the driver. They key was created by
+ * the function rdma_user_mmap_entry_insert.
+ *
+ * Return an entry if exists or NULL if there is no match.
+ */
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
+	if (!entry || entry->length != len)
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
+/**
+ * rdma_user_mmap_entry_insert() - Allocate and insert an entry to the mmap_xa.
+ *
+ * @ucontext: associated user context.
+ * @obj: opaque driver object that will be stored in the entry.
+ * @address: The address that will be mmapped to the user
+ * @length: Length of the address that will be mmapped
+ * @mmap_flag: opaque driver flags related to the address (For
+ *           example could be used for cachability)
+ *
+ * This function should be called by drivers that use the rdma_user_mmap
+ * interface for handling user mmapped addresses. The database is handled in
+ * the core and helper functions are provided to insert entries into the
+ * database and extract entries when the user call mmap with the given key.
+ * The function returns a unique key that should be provided to user, the user
+ * will use the key to map the given address.
+ *
+ * Note this locking scheme cannot support removal of entries,
+ * except during ucontext destruction when the core code
+ * guarentees no concurrency.
+ *
+ * Return: unique key or RDMA_USER_MMAP_INVALID if entry was not added.
+ */
+u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void *obj,
+				u64 address, u64 length, u8 mmap_flag)
+{
+	struct rdma_user_mmap_entry *entry;
+	u32 next_mmap_page;
+	int err;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
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
+			ucontext->device->ops.mmap_free(entry);
+		kfree(entry);
+	}
+}
+
 void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 {
 	struct rdma_umap_priv *priv, *next_priv;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 26e9c2594913..1ba29a00f584 100644
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
@@ -2199,6 +2201,17 @@ struct iw_cm_conn_param;
 
 #define DECLARE_RDMA_OBJ_SIZE(ib_struct) size_t size_##ib_struct
 
+#define RDMA_USER_MMAP_FLAG_SHIFT 56
+#define RDMA_USER_MMAP_PAGE_MASK GENMASK(EFA_MMAP_FLAG_SHIFT - 1, 0)
+#define RDMA_USER_MMAP_INVALID U64_MAX
+struct rdma_user_mmap_entry {
+	void *obj;
+	u64 address;
+	u64 length;
+	u32 mmap_page;
+	u8 mmap_flag;
+};
+
 /**
  * struct ib_device_ops - InfiniBand device operations
  * This structure defines all the InfiniBand device operations, providers will
@@ -2311,6 +2324,19 @@ struct ib_device_ops {
 			      struct ib_udata *udata);
 	void (*dealloc_ucontext)(struct ib_ucontext *context);
 	int (*mmap)(struct ib_ucontext *context, struct vm_area_struct *vma);
+	/**
+	 * Memory that is mapped to the user can only be freed once the
+	 * ucontext of the application is destroyed. This is for
+	 * security reasons where we don't want an application to have a
+	 * mapping to phyiscal memory that is freed and allocated to
+	 * another application. For this reason, all the entries are
+	 * stored in ucontext and once ucontext is freed mmap_free is
+	 * called on each of the entries. They type of the memory that
+	 * was mapped may differ between entries and is opaque to the
+	 * rdma_user_mmap interface. Therefore needs to be implemented
+	 * by the driver in mmap_free.
+	 */
+	void (*mmap_free)(struct rdma_user_mmap_entry *entry);
 	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
 	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
 	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
@@ -2709,6 +2735,11 @@ void ib_set_device_ops(struct ib_device *device,
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
@@ -2717,6 +2748,21 @@ static inline int rdma_user_mmap_io(struct ib_ucontext *ucontext,
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

