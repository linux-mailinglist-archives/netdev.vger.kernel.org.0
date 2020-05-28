Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81EF1E6B98
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406733AbgE1TsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728695AbgE1TqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:04 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32C9C008631
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:02 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n141so107061qke.2
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+BwgOBuP6iUsEctzv6vUxvp4p35WYKqoYBTK/xbTlU=;
        b=FG+uuejO5gaCwDQG+SexOl8ffSQvf0EoVumat82XyA1jMg70XaDsk+95BmUWjRjNyl
         cn2avv0c+3OH1tnITkxrTqxu6YyqYFc4wD0aTpjUbK/eEzImS5BKqvWAWNh368iuS+Jm
         Gq7FGQrqZD4KscrcbkLD6bTGbWcL6EwBzVoSEGRonCD3q7QcnPQPk0ubnHVgNGFnhS1t
         2d9+l0w2sjcA4ouKk1TICC1nQi0lOtBNXhaNJ/OTlHNTKbeIwrZNidfw/eK/YZ7YktRj
         b1aBwU2S+S6h3sTWDr7voK2EVHVA2QEXPrMVfPEt51T7wWmDuOSsg7MG/MLWvNHKqxnX
         Qgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+BwgOBuP6iUsEctzv6vUxvp4p35WYKqoYBTK/xbTlU=;
        b=RsSHyUP2ysBSLph9AW8yVxWAGBZ2TbiJj2itI38myXgK0jq2zkOHrmRsKQ8H45tXWw
         DFqcsmCkf/iYtdc3nPh7FxAfsQWNOziO3BPYTMWTJWjoJBku7+1lZeM7DXNDqXnR1Nsj
         KGd01i1Gp/5O2C9VQCmMA6oED3QhzOsvEYlkg7HIUz3S+czMNx3937t5d7e0/GPfrD5H
         wTRptzC7Tv3AOs2ms4M7rjYwiQhEGcSQ/v0hHhNpzlivDWmIJe/q/IXch0pyHQGN9kVC
         H3mbXr5g8X5AdC9KNM2iAREHEFXn6pQ4cj5BNcfiTHHQ28j4wzgAmVMXaS6thH/JK6fi
         36JA==
X-Gm-Message-State: AOAM532Xb8UorB08Gx3vmKyA+NbkrSSm1O1HvP1M3l3CdVkCd4aoptyN
        +uo2rjtAqQfuq3oo0r62tEK6+Q==
X-Google-Smtp-Source: ABdhPJwWFHmtBMtpumUA+7hjvhVG35jTK3jT7/Bl/X4v7qlDQEwre7qvOANxHa3Ou9XN95pgWxCqRA==
X-Received: by 2002:a37:850:: with SMTP id 77mr4464088qki.498.1590695161810;
        Thu, 28 May 2020 12:46:01 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id 207sm3733320qki.134.2020.05.28.12.45.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006he-Cw; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 09/13] RDMA/mthca: Remove FMR support for memory registration
Date:   Thu, 28 May 2020 16:45:51 -0300
Message-Id: <9-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

Remove the ancient and unsafe FMR method.

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/mthca/mthca_dev.h      |  10 -
 drivers/infiniband/hw/mthca/mthca_mr.c       | 262 +------------------
 drivers/infiniband/hw/mthca/mthca_provider.c |  86 ------
 drivers/infiniband/hw/mthca/mthca_provider.h |  23 --
 4 files changed, 1 insertion(+), 380 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 599794c5a78f0f..7550e9d03decea 100644
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
index 4250b2c18c6492..ce0e0867e4883b 100644
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
index bc3e3d741ca381..de2124a8ee2be6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -958,69 +958,6 @@ static int mthca_dereg_mr(struct ib_mr *mr, struct ib_udata *udata)
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
@@ -1204,20 +1141,6 @@ static const struct ib_device_ops mthca_dev_tavor_srq_ops = {
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
@@ -1276,15 +1199,6 @@ int mthca_register_device(struct mthca_dev *dev)
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
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.h b/drivers/infiniband/hw/mthca/mthca_provider.h
index 596acc45569b9a..84c64bff0d92b2 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.h
+++ b/drivers/infiniband/hw/mthca/mthca_provider.h
@@ -76,24 +76,6 @@ struct mthca_mr {
 	struct mthca_mtt *mtt;
 };
 
-struct mthca_fmr {
-	struct ib_fmr      ibmr;
-	struct ib_fmr_attr attr;
-	struct mthca_mtt  *mtt;
-	int                maps;
-	union {
-		struct {
-			struct mthca_mpt_entry __iomem *mpt;
-			u64 __iomem *mtts;
-		} tavor;
-		struct {
-			struct mthca_mpt_entry *mpt;
-			__be64 *mtts;
-			dma_addr_t dma_handle;
-		} arbel;
-	} mem;
-};
-
 struct mthca_pd {
 	struct ib_pd    ibpd;
 	u32             pd_num;
@@ -301,11 +283,6 @@ static inline struct mthca_ucontext *to_mucontext(struct ib_ucontext *ibucontext
 	return container_of(ibucontext, struct mthca_ucontext, ibucontext);
 }
 
-static inline struct mthca_fmr *to_mfmr(struct ib_fmr *ibmr)
-{
-	return container_of(ibmr, struct mthca_fmr, ibmr);
-}
-
 static inline struct mthca_mr *to_mmr(struct ib_mr *ibmr)
 {
 	return container_of(ibmr, struct mthca_mr, ibmr);
-- 
2.26.2

