Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C12E1E3DE7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgE0Jq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:46:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58160 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729024AbgE0Jq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:46:58 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:35 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYil009430;
        Wed, 27 May 2020 12:46:35 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 4/9] RDMA/mthca: remove FMR support for memory registration
Date:   Wed, 27 May 2020 12:46:29 +0300
Message-Id: <20200527094634.24240-5-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the ancient and unsafe FMR method.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/infiniband/hw/mthca/mthca_dev.h      |  10 -
 drivers/infiniband/hw/mthca/mthca_mr.c       | 262 +--------------------------
 drivers/infiniband/hw/mthca/mthca_provider.c |  86 ---------
 3 files changed, 1 insertion(+), 357 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 599794c..7550e9d 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -478,16 +478,6 @@ int mthca_mr_alloc_phys(struct mthca_dev *dev, u32 pd,
 			u32 access, struct mthca_mr *mr);
 void mthca_free_mr(struct mthca_dev *dev,  struct mthca_mr *mr);
 
-int mthca_fmr_alloc(struct mthca_dev *dev, u32 pd,
-		    u32 access, struct mthca_fmr *fmr);
-int mthca_tavor_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-			     int list_len, u64 iova);
-void mthca_tavor_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr);
-int mthca_arbel_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-			     int list_len, u64 iova);
-void mthca_arbel_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr);
-int mthca_free_fmr(struct mthca_dev *dev,  struct mthca_fmr *fmr);
-
 int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt);
 void mthca_unmap_eq_icm(struct mthca_dev *dev);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 4250b2c..ce0e086 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -541,7 +541,7 @@ int mthca_mr_alloc_phys(struct mthca_dev *dev, u32 pd,
 	return err;
 }
 
-/* Free mr or fmr */
+/* Free mr */
 static void mthca_free_region(struct mthca_dev *dev, u32 lkey)
 {
 	mthca_table_put(dev, dev->mr_table.mpt_table,
@@ -564,266 +564,6 @@ void mthca_free_mr(struct mthca_dev *dev, struct mthca_mr *mr)
 	mthca_free_mtt(dev, mr->mtt);
 }
 
-int mthca_fmr_alloc(struct mthca_dev *dev, u32 pd,
-		    u32 access, struct mthca_fmr *mr)
-{
-	struct mthca_mpt_entry *mpt_entry;
-	struct mthca_mailbox *mailbox;
-	u64 mtt_seg;
-	u32 key, idx;
-	int list_len = mr->attr.max_pages;
-	int err = -ENOMEM;
-	int i;
-
-	if (mr->attr.page_shift < 12 || mr->attr.page_shift >= 32)
-		return -EINVAL;
-
-	/* For Arbel, all MTTs must fit in the same page. */
-	if (mthca_is_memfree(dev) &&
-	    mr->attr.max_pages * sizeof *mr->mem.arbel.mtts > PAGE_SIZE)
-		return -EINVAL;
-
-	mr->maps = 0;
-
-	key = mthca_alloc(&dev->mr_table.mpt_alloc);
-	if (key == -1)
-		return -ENOMEM;
-	key = adjust_key(dev, key);
-
-	idx = key & (dev->limits.num_mpts - 1);
-	mr->ibmr.rkey = mr->ibmr.lkey = hw_index_to_key(dev, key);
-
-	if (mthca_is_memfree(dev)) {
-		err = mthca_table_get(dev, dev->mr_table.mpt_table, key);
-		if (err)
-			goto err_out_mpt_free;
-
-		mr->mem.arbel.mpt = mthca_table_find(dev->mr_table.mpt_table, key, NULL);
-		BUG_ON(!mr->mem.arbel.mpt);
-	} else
-		mr->mem.tavor.mpt = dev->mr_table.tavor_fmr.mpt_base +
-			sizeof *(mr->mem.tavor.mpt) * idx;
-
-	mr->mtt = __mthca_alloc_mtt(dev, list_len, dev->mr_table.fmr_mtt_buddy);
-	if (IS_ERR(mr->mtt)) {
-		err = PTR_ERR(mr->mtt);
-		goto err_out_table;
-	}
-
-	mtt_seg = mr->mtt->first_seg * dev->limits.mtt_seg_size;
-
-	if (mthca_is_memfree(dev)) {
-		mr->mem.arbel.mtts = mthca_table_find(dev->mr_table.mtt_table,
-						      mr->mtt->first_seg,
-						      &mr->mem.arbel.dma_handle);
-		BUG_ON(!mr->mem.arbel.mtts);
-	} else
-		mr->mem.tavor.mtts = dev->mr_table.tavor_fmr.mtt_base + mtt_seg;
-
-	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
-	if (IS_ERR(mailbox)) {
-		err = PTR_ERR(mailbox);
-		goto err_out_free_mtt;
-	}
-
-	mpt_entry = mailbox->buf;
-
-	mpt_entry->flags = cpu_to_be32(MTHCA_MPT_FLAG_SW_OWNS     |
-				       MTHCA_MPT_FLAG_MIO         |
-				       MTHCA_MPT_FLAG_REGION      |
-				       access);
-
-	mpt_entry->page_size = cpu_to_be32(mr->attr.page_shift - 12);
-	mpt_entry->key       = cpu_to_be32(key);
-	mpt_entry->pd        = cpu_to_be32(pd);
-	memset(&mpt_entry->start, 0,
-	       sizeof *mpt_entry - offsetof(struct mthca_mpt_entry, start));
-	mpt_entry->mtt_seg   = cpu_to_be64(dev->mr_table.mtt_base + mtt_seg);
-
-	if (0) {
-		mthca_dbg(dev, "Dumping MPT entry %08x:\n", mr->ibmr.lkey);
-		for (i = 0; i < sizeof (struct mthca_mpt_entry) / 4; ++i) {
-			if (i % 4 == 0)
-				printk("[%02x] ", i * 4);
-			printk(" %08x", be32_to_cpu(((__be32 *) mpt_entry)[i]));
-			if ((i + 1) % 4 == 0)
-				printk("\n");
-		}
-	}
-
-	err = mthca_SW2HW_MPT(dev, mailbox,
-			      key & (dev->limits.num_mpts - 1));
-	if (err) {
-		mthca_warn(dev, "SW2HW_MPT failed (%d)\n", err);
-		goto err_out_mailbox_free;
-	}
-
-	mthca_free_mailbox(dev, mailbox);
-	return 0;
-
-err_out_mailbox_free:
-	mthca_free_mailbox(dev, mailbox);
-
-err_out_free_mtt:
-	mthca_free_mtt(dev, mr->mtt);
-
-err_out_table:
-	mthca_table_put(dev, dev->mr_table.mpt_table, key);
-
-err_out_mpt_free:
-	mthca_free(&dev->mr_table.mpt_alloc, key);
-	return err;
-}
-
-int mthca_free_fmr(struct mthca_dev *dev, struct mthca_fmr *fmr)
-{
-	if (fmr->maps)
-		return -EBUSY;
-
-	mthca_free_region(dev, fmr->ibmr.lkey);
-	mthca_free_mtt(dev, fmr->mtt);
-
-	return 0;
-}
-
-static inline int mthca_check_fmr(struct mthca_fmr *fmr, u64 *page_list,
-				  int list_len, u64 iova)
-{
-	int i, page_mask;
-
-	if (list_len > fmr->attr.max_pages)
-		return -EINVAL;
-
-	page_mask = (1 << fmr->attr.page_shift) - 1;
-
-	/* We are getting page lists, so va must be page aligned. */
-	if (iova & page_mask)
-		return -EINVAL;
-
-	/* Trust the user not to pass misaligned data in page_list */
-	if (0)
-		for (i = 0; i < list_len; ++i) {
-			if (page_list[i] & ~page_mask)
-				return -EINVAL;
-		}
-
-	if (fmr->maps >= fmr->attr.max_maps)
-		return -EINVAL;
-
-	return 0;
-}
-
-
-int mthca_tavor_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-			     int list_len, u64 iova)
-{
-	struct mthca_fmr *fmr = to_mfmr(ibfmr);
-	struct mthca_dev *dev = to_mdev(ibfmr->device);
-	struct mthca_mpt_entry mpt_entry;
-	u32 key;
-	int i, err;
-
-	err = mthca_check_fmr(fmr, page_list, list_len, iova);
-	if (err)
-		return err;
-
-	++fmr->maps;
-
-	key = tavor_key_to_hw_index(fmr->ibmr.lkey);
-	key += dev->limits.num_mpts;
-	fmr->ibmr.lkey = fmr->ibmr.rkey = tavor_hw_index_to_key(key);
-
-	writeb(MTHCA_MPT_STATUS_SW, fmr->mem.tavor.mpt);
-
-	for (i = 0; i < list_len; ++i) {
-		__be64 mtt_entry = cpu_to_be64(page_list[i] |
-					       MTHCA_MTT_FLAG_PRESENT);
-		mthca_write64_raw(mtt_entry, fmr->mem.tavor.mtts + i);
-	}
-
-	mpt_entry.lkey   = cpu_to_be32(key);
-	mpt_entry.length = cpu_to_be64(list_len * (1ull << fmr->attr.page_shift));
-	mpt_entry.start  = cpu_to_be64(iova);
-
-	__raw_writel((__force u32) mpt_entry.lkey, &fmr->mem.tavor.mpt->key);
-	memcpy_toio(&fmr->mem.tavor.mpt->start, &mpt_entry.start,
-		    offsetof(struct mthca_mpt_entry, window_count) -
-		    offsetof(struct mthca_mpt_entry, start));
-
-	writeb(MTHCA_MPT_STATUS_HW, fmr->mem.tavor.mpt);
-
-	return 0;
-}
-
-int mthca_arbel_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-			     int list_len, u64 iova)
-{
-	struct mthca_fmr *fmr = to_mfmr(ibfmr);
-	struct mthca_dev *dev = to_mdev(ibfmr->device);
-	u32 key;
-	int i, err;
-
-	err = mthca_check_fmr(fmr, page_list, list_len, iova);
-	if (err)
-		return err;
-
-	++fmr->maps;
-
-	key = arbel_key_to_hw_index(fmr->ibmr.lkey);
-	if (dev->mthca_flags & MTHCA_FLAG_SINAI_OPT)
-		key += SINAI_FMR_KEY_INC;
-	else
-		key += dev->limits.num_mpts;
-	fmr->ibmr.lkey = fmr->ibmr.rkey = arbel_hw_index_to_key(key);
-
-	*(u8 *) fmr->mem.arbel.mpt = MTHCA_MPT_STATUS_SW;
-
-	wmb();
-
-	dma_sync_single_for_cpu(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
-				list_len * sizeof(u64), DMA_TO_DEVICE);
-
-	for (i = 0; i < list_len; ++i)
-		fmr->mem.arbel.mtts[i] = cpu_to_be64(page_list[i] |
-						     MTHCA_MTT_FLAG_PRESENT);
-
-	dma_sync_single_for_device(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
-				   list_len * sizeof(u64), DMA_TO_DEVICE);
-
-	fmr->mem.arbel.mpt->key    = cpu_to_be32(key);
-	fmr->mem.arbel.mpt->lkey   = cpu_to_be32(key);
-	fmr->mem.arbel.mpt->length = cpu_to_be64(list_len * (1ull << fmr->attr.page_shift));
-	fmr->mem.arbel.mpt->start  = cpu_to_be64(iova);
-
-	wmb();
-
-	*(u8 *) fmr->mem.arbel.mpt = MTHCA_MPT_STATUS_HW;
-
-	wmb();
-
-	return 0;
-}
-
-void mthca_tavor_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr)
-{
-	if (!fmr->maps)
-		return;
-
-	fmr->maps = 0;
-
-	writeb(MTHCA_MPT_STATUS_SW, fmr->mem.tavor.mpt);
-}
-
-void mthca_arbel_fmr_unmap(struct mthca_dev *dev, struct mthca_fmr *fmr)
-{
-	if (!fmr->maps)
-		return;
-
-	fmr->maps = 0;
-
-	*(u8 *) fmr->mem.arbel.mpt = MTHCA_MPT_STATUS_SW;
-}
-
 int mthca_init_mr_table(struct mthca_dev *dev)
 {
 	phys_addr_t addr;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 69a3e4f..9028df0 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -957,69 +957,6 @@ static int mthca_dereg_mr(struct ib_mr *mr, struct ib_udata *udata)
 	return 0;
 }
 
-static struct ib_fmr *mthca_alloc_fmr(struct ib_pd *pd, int mr_access_flags,
-				      struct ib_fmr_attr *fmr_attr)
-{
-	struct mthca_fmr *fmr;
-	int err;
-
-	fmr = kmalloc(sizeof *fmr, GFP_KERNEL);
-	if (!fmr)
-		return ERR_PTR(-ENOMEM);
-
-	memcpy(&fmr->attr, fmr_attr, sizeof *fmr_attr);
-	err = mthca_fmr_alloc(to_mdev(pd->device), to_mpd(pd)->pd_num,
-			     convert_access(mr_access_flags), fmr);
-
-	if (err) {
-		kfree(fmr);
-		return ERR_PTR(err);
-	}
-
-	return &fmr->ibmr;
-}
-
-static int mthca_dealloc_fmr(struct ib_fmr *fmr)
-{
-	struct mthca_fmr *mfmr = to_mfmr(fmr);
-	int err;
-
-	err = mthca_free_fmr(to_mdev(fmr->device), mfmr);
-	if (err)
-		return err;
-
-	kfree(mfmr);
-	return 0;
-}
-
-static int mthca_unmap_fmr(struct list_head *fmr_list)
-{
-	struct ib_fmr *fmr;
-	int err;
-	struct mthca_dev *mdev = NULL;
-
-	list_for_each_entry(fmr, fmr_list, list) {
-		if (mdev && to_mdev(fmr->device) != mdev)
-			return -EINVAL;
-		mdev = to_mdev(fmr->device);
-	}
-
-	if (!mdev)
-		return 0;
-
-	if (mthca_is_memfree(mdev)) {
-		list_for_each_entry(fmr, fmr_list, list)
-			mthca_arbel_fmr_unmap(mdev, to_mfmr(fmr));
-
-		wmb();
-	} else
-		list_for_each_entry(fmr, fmr_list, list)
-			mthca_tavor_fmr_unmap(mdev, to_mfmr(fmr));
-
-	err = mthca_SYNC_TPT(mdev);
-	return err;
-}
-
 static ssize_t hw_rev_show(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
@@ -1203,20 +1140,6 @@ static void get_dev_fw_str(struct ib_device *device, char *str)
 	INIT_RDMA_OBJ_SIZE(ib_srq, mthca_srq, ibsrq),
 };
 
-static const struct ib_device_ops mthca_dev_arbel_fmr_ops = {
-	.alloc_fmr = mthca_alloc_fmr,
-	.dealloc_fmr = mthca_dealloc_fmr,
-	.map_phys_fmr = mthca_arbel_map_phys_fmr,
-	.unmap_fmr = mthca_unmap_fmr,
-};
-
-static const struct ib_device_ops mthca_dev_tavor_fmr_ops = {
-	.alloc_fmr = mthca_alloc_fmr,
-	.dealloc_fmr = mthca_dealloc_fmr,
-	.map_phys_fmr = mthca_tavor_map_phys_fmr,
-	.unmap_fmr = mthca_unmap_fmr,
-};
-
 static const struct ib_device_ops mthca_dev_arbel_ops = {
 	.post_recv = mthca_arbel_post_receive,
 	.post_send = mthca_arbel_post_send,
@@ -1275,15 +1198,6 @@ int mthca_register_device(struct mthca_dev *dev)
 					  &mthca_dev_tavor_srq_ops);
 	}
 
-	if (dev->mthca_flags & MTHCA_FLAG_FMR) {
-		if (mthca_is_memfree(dev))
-			ib_set_device_ops(&dev->ib_dev,
-					  &mthca_dev_arbel_fmr_ops);
-		else
-			ib_set_device_ops(&dev->ib_dev,
-					  &mthca_dev_tavor_fmr_ops);
-	}
-
 	ib_set_device_ops(&dev->ib_dev, &mthca_dev_ops);
 
 	if (mthca_is_memfree(dev))
-- 
1.8.3.1

