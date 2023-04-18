Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5356E68A4
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 17:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjDRPtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 11:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjDRPtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 11:49:25 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9199C125B6;
        Tue, 18 Apr 2023 08:49:20 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-2f625d52275so2570156f8f.3;
        Tue, 18 Apr 2023 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681832959; x=1684424959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bb9irq9nW0pE8CSgWK7K74C7UlngMlVehaGXPHyB9ic=;
        b=ntPGEolIZioWsoNupmOxdO7kt9WWHTCzJGRt3JeOtVCC+SVzkwa/NyZv9ukI232TBR
         /SaCFFfiuP+yU+Tf4o6hIp9U3tMU7b5AGvSvrrMr/kY7AUvOlJsfmn/RQNibRrHgleWU
         Q0at44oFe6V5iGpVwBJFEZ3d5+4yn9KmVpC5vgqz7XRwVwkxwq8sWQ2UENZIsQIky+JT
         qXGN3nxRBzi/n1aZEOK/lypItYhx6fff2XHtr4sPyCmoOrbTguhoA2ytCDf6KlYdpsSq
         cW2A33nEC11LJt6wWbm/o8z0hOIUZVu16DMDL5s3z6+SJ06YGDg5S72COZQ6YFGJuGon
         x+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832959; x=1684424959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bb9irq9nW0pE8CSgWK7K74C7UlngMlVehaGXPHyB9ic=;
        b=M4VoWyL+R/1x6RQbbVnvx0oI6ezM8psqwGcMGCxsrOOxHlxqWrhtZzhI1VoOfK+QRY
         Y+fAs8HSf5g5XsFEezdy/KJZlLml1ej9ldRG4cDTNl3CDvOjS1mcxw2J+akR0eTmv/iZ
         ZHtGhX6gJmY4SO/Pz7lVRkSKsgQuaIiJSNFYEiXyCw5i8/QKgu7CrBJa47jMN9xP1+G8
         etFI9OU63ViTRTQ6qBvnr1QM8sK40J8OrSQLaBg2ym4C+UcrmoMKQWF53YQPdXDWrvN2
         0O3KgoH0Zi4akg7nFNqTJhaRFG9B6ZPk3ddhxumO8OAgfUhdjiBwXeR9FD3lMr/qaFR1
         H5vw==
X-Gm-Message-State: AAQBX9fDw2B4so5humg03vfVlhDFf+g6eYSlyBQytnYp52XRbHlPfjgz
        nnBGN1YEjYz3AlkfD1M3Vo4=
X-Google-Smtp-Source: AKy350aikpx9A03wx1BpHW1zS7E+sdV29dDZkTBMa7IL0AbouX1s8BmVCcsrkL1ZD5YHaD7cPB+wCQ==
X-Received: by 2002:a5d:5001:0:b0:2d1:e517:4992 with SMTP id e1-20020a5d5001000000b002d1e5174992mr2266976wrt.69.1681832958700;
        Tue, 18 Apr 2023 08:49:18 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id z16-20020a5d4c90000000b002c7163660a9sm13381191wrs.105.2023.04.18.08.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 08:49:18 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v4 5/6] mm/gup: remove vmas parameter from pin_user_pages()
Date:   Tue, 18 Apr 2023 16:49:14 +0100
Message-Id: <765b2fdba141b40f72d389e942286456bf5c9f7c.1681831798.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681831798.git.lstoakes@gmail.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are now in a position where no caller of pin_user_pages() requires the
vmas parameter at all, so eliminate this parameter from the function and
all callers.

This clears the way to removing the vmas parameter from GUP altogether.

Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com> (for qib)
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
---
 arch/powerpc/mm/book3s64/iommu_api.c       | 2 +-
 drivers/infiniband/hw/qib/qib_user_pages.c | 2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c   | 2 +-
 drivers/infiniband/sw/siw/siw_mem.c        | 2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c  | 2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c         | 2 +-
 drivers/vhost/vdpa.c                       | 2 +-
 include/linux/mm.h                         | 3 +--
 io_uring/rsrc.c                            | 4 +---
 mm/gup.c                                   | 9 +++------
 mm/gup_test.c                              | 9 ++++-----
 net/xdp/xdp_umem.c                         | 2 +-
 12 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
index 81d7185e2ae8..d19fb1f3007d 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -105,7 +105,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 
 		ret = pin_user_pages(ua + (entry << PAGE_SHIFT), n,
 				FOLL_WRITE | FOLL_LONGTERM,
-				mem->hpages + entry, NULL);
+				mem->hpages + entry);
 		if (ret == n) {
 			pinned += n;
 			continue;
diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
index f693bc753b6b..1bb7507325bc 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -111,7 +111,7 @@ int qib_get_user_pages(unsigned long start_page, size_t num_pages,
 		ret = pin_user_pages(start_page + got * PAGE_SIZE,
 				     num_pages - got,
 				     FOLL_LONGTERM | FOLL_WRITE,
-				     p + got, NULL);
+				     p + got);
 		if (ret < 0) {
 			mmap_read_unlock(current->mm);
 			goto bail_release;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 2a5cac2658ec..84e0f41e7dfa 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -140,7 +140,7 @@ static int usnic_uiom_get_pages(unsigned long addr, size_t size, int writable,
 		ret = pin_user_pages(cur_base,
 				     min_t(unsigned long, npages,
 				     PAGE_SIZE / sizeof(struct page *)),
-				     gup_flags, page_list, NULL);
+				     gup_flags, page_list);
 
 		if (ret < 0)
 			goto out;
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index f51ab2ccf151..e6e25f15567d 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -422,7 +422,7 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		umem->page_chunk[i].plist = plist;
 		while (nents) {
 			rv = pin_user_pages(first_page_va, nents, foll_flags,
-					    plist, NULL);
+					    plist);
 			if (rv < 0)
 				goto out_sem_up;
 
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 53001532e8e3..405b89ea1054 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -180,7 +180,7 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
 		data, size, dma->nr_pages);
 
 	err = pin_user_pages(data & PAGE_MASK, dma->nr_pages, gup_flags,
-			     dma->pages, NULL);
+			     dma->pages);
 
 	if (err != dma->nr_pages) {
 		dma->nr_pages = (err >= 0) ? err : 0;
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 0c3b48616a9f..1f80254604f0 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -995,7 +995,7 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 		goto out;
 
 	pinned = pin_user_pages(uaddr, npages, FOLL_LONGTERM | FOLL_WRITE,
-				page_list, NULL);
+				page_list);
 	if (pinned != npages) {
 		ret = pinned < 0 ? pinned : -ENOMEM;
 		goto out;
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7be9d9d8f01c..4317128c1c62 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -952,7 +952,7 @@ static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
 	while (npages) {
 		sz2pin = min_t(unsigned long, npages, list_size);
 		pinned = pin_user_pages(cur_base, sz2pin,
-					gup_flags, page_list, NULL);
+					gup_flags, page_list);
 		if (sz2pin != pinned) {
 			if (pinned < 0) {
 				ret = pinned;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c236e2f25e2..d02c42d37bfc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2410,8 +2410,7 @@ static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages,
-		    struct vm_area_struct **vmas);
+		    unsigned int gup_flags, struct page **pages);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3a927df9d913..82d90b97c17b 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1180,10 +1180,8 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 
 	ret = 0;
 	mmap_read_lock(current->mm);
-
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-			      pages, NULL);
-
+			      pages);
 	if (pret == nr_pages) {
 		ret = check_vmas_locked(ubuf, len);
 		*npages = nr_pages;
diff --git a/mm/gup.c b/mm/gup.c
index 9440aa54c741..dffbfa623aae 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3124,8 +3124,6 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  *
  * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set, and
  * FOLL_PIN is set.
@@ -3134,15 +3132,14 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * see Documentation/core-api/pin_user_pages.rst for details.
  */
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages,
-		    struct vm_area_struct **vmas)
+		    unsigned int gup_flags, struct page **pages)
 {
 	int locked = 1;
 
-	if (!is_valid_gup_args(pages, vmas, NULL, &gup_flags, FOLL_PIN))
+	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags, FOLL_PIN))
 		return 0;
 	return __gup_longterm_locked(current->mm, start, nr_pages,
-				     pages, vmas, &locked, gup_flags);
+				     pages, NULL, &locked, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages);
 
diff --git a/mm/gup_test.c b/mm/gup_test.c
index 9ba8ea23f84e..1668ce0e0783 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -146,18 +146,17 @@ static int __gup_test_ioctl(unsigned int cmd,
 						 pages + i);
 			break;
 		case PIN_BASIC_TEST:
-			nr = pin_user_pages(addr, nr, gup->gup_flags, pages + i,
-					    NULL);
+			nr = pin_user_pages(addr, nr, gup->gup_flags, pages + i);
 			break;
 		case PIN_LONGTERM_BENCHMARK:
 			nr = pin_user_pages(addr, nr,
 					    gup->gup_flags | FOLL_LONGTERM,
-					    pages + i, NULL);
+					    pages + i);
 			break;
 		case DUMP_USER_PAGES_TEST:
 			if (gup->test_flags & GUP_TEST_FLAG_DUMP_PAGES_USE_PIN)
 				nr = pin_user_pages(addr, nr, gup->gup_flags,
-						    pages + i, NULL);
+						    pages + i);
 			else
 				nr = get_user_pages(addr, nr, gup->gup_flags,
 						    pages + i);
@@ -270,7 +269,7 @@ static inline int pin_longterm_test_start(unsigned long arg)
 							gup_flags, pages);
 		else
 			cur_pages = pin_user_pages(addr, remaining_pages,
-						   gup_flags, pages, NULL);
+						   gup_flags, pages);
 		if (cur_pages < 0) {
 			pin_longterm_test_stop();
 			ret = cur_pages;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 02207e852d79..06cead2b8e34 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -103,7 +103,7 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, unsigned long address)
 
 	mmap_read_lock(current->mm);
 	npgs = pin_user_pages(address, umem->npgs,
-			      gup_flags | FOLL_LONGTERM, &umem->pgs[0], NULL);
+			      gup_flags | FOLL_LONGTERM, &umem->pgs[0]);
 	mmap_read_unlock(current->mm);
 
 	if (npgs != umem->npgs) {
-- 
2.40.0

