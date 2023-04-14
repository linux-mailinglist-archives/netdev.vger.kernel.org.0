Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5496E2CDF
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 01:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjDNX2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 19:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDNX23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 19:28:29 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDD19ED5;
        Fri, 14 Apr 2023 16:27:56 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l10-20020a05600c1d0a00b003f04bd3691eso21448782wms.5;
        Fri, 14 Apr 2023 16:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681514873; x=1684106873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ftq6TTcnXmE4j3aIu+06i4fKocrqUKSD4QQo68fNkt8=;
        b=ohd1+UCbWmxvM4MzYWo9I9cjeFbuOl76YkSJ4H1bBFMabAoAOh9PP3Xn3F4/WBuFLE
         44aN9PSGmSuG7eqNDfNvN1tuP6TlgtU1eO6O4TQ3ntS2xwnbSqXZuzvWyKhZK6MbRP+6
         rSYx1oJ6hL09OWI1C8flq0T9yyN+BfcDW5h8OYenbAi9oU9AE2yE+xQpgMPr10v3G8Aw
         /wdUnEwSsTFYCQstfHfX6RgCpSbJiS/mcHorC1MFCP0huO0EtgtALhIqad5Blxade8UR
         ugQfPqV5ZS3RS5cYDhvRxP2urKRR9NIkiFqJFqyXuoEcF+72M4833WQ7ukV49X69L8WH
         5oMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681514873; x=1684106873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ftq6TTcnXmE4j3aIu+06i4fKocrqUKSD4QQo68fNkt8=;
        b=kWBXSgRspAtcJ8D34+8aE1NjcOJ99gmuzeBjpwoOAvPHlGLAhFaJzc585gsqXHlDZr
         k5ZinMFqz8QjSF4nSaS7MIDpgnZp1hzzvulNHNGrq8jbanYVq+mKb2pKn10lKUdFRl4u
         RdMnlLYWgUIqu+6wTKpm+MRTF7UuVMe5/KtCqhim93t6OmiJ26ApLzEt7CDoSbOdSDoc
         5JB0d4+JAx/oQ78/ULExVfCz2/dxTClbAB4dU/kz8x/ltogQVopKwK+FXFn9DK5FVjf5
         wznv/fnY1agulrfZo6KGP4DS0p5Buk54dGwvBA3VSroEU6tirvr9jc45YQKDpPpiqDc0
         on4Q==
X-Gm-Message-State: AAQBX9e4zqGf9c5fQFs4g4o9UUErhyYk413bv+GtHVTSdlb/L9UmhC6l
        CglIww91J2AnKYcsrI58SzpQapw11El6lA==
X-Google-Smtp-Source: AKy350aM7HhgsRREzBUJkpVKcr6aG9xKg7anitOKYJkUq3hDdkna1nbr7oIWFGuzU7Puz99fUyJcFw==
X-Received: by 2002:a05:600c:21cd:b0:3f1:662a:93d0 with SMTP id x13-20020a05600c21cd00b003f1662a93d0mr454115wmj.15.1681514872738;
        Fri, 14 Apr 2023 16:27:52 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id n19-20020a1c7213000000b003ee58e8c971sm5303734wmc.14.2023.04.14.16.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 16:27:51 -0700 (PDT)
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
Subject: [PATCH 6/7] mm/gup: remove vmas parameter from pin_user_pages()
Date:   Sat, 15 Apr 2023 00:27:49 +0100
Message-Id: <8333df218248b7bb08d5fe391c1b8e9e3f309588.1681508038.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681508038.git.lstoakes@gmail.com>
References: <cover.1681508038.git.lstoakes@gmail.com>
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

After the introduction of FOLL_SAME_FILE we no longer require vmas for any
invocation of pin_user_pages(), so eliminate this parameter from the
function and all callers.

This clears the way to removing the vmas parameter from GUP altogether.

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
 io_uring/rsrc.c                            | 2 +-
 mm/gup.c                                   | 9 +++------
 mm/gup_test.c                              | 9 ++++-----
 net/xdp/xdp_umem.c                         | 2 +-
 12 files changed, 17 insertions(+), 22 deletions(-)

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
index 8dfa236cfb58..3f7d36ad7de7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2382,8 +2382,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
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
index adc860bcbd4f..92d0d47e322c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1157,7 +1157,7 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 
 	pret = pin_user_pages(ubuf, nr_pages,
 			      FOLL_WRITE | FOLL_LONGTERM | FOLL_SAME_FILE,
-			      pages, NULL);
+			      pages);
 	if (pret == nr_pages) {
 		/*
 		 * lookup the first VMA, we require that all VMAs in range
diff --git a/mm/gup.c b/mm/gup.c
index 3954ce499a4a..714970ef3b30 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3132,8 +3132,6 @@ EXPORT_SYMBOL(pin_user_pages_remote);
  * @gup_flags:	flags modifying lookup behaviour
  * @pages:	array that receives pointers to the pages pinned.
  *		Should be at least nr_pages long.
- * @vmas:	array of pointers to vmas corresponding to each page.
- *		Or NULL if the caller does not require them.
  *
  * Nearly the same as get_user_pages(), except that FOLL_TOUCH is not set, and
  * FOLL_PIN is set.
@@ -3142,15 +3140,14 @@ EXPORT_SYMBOL(pin_user_pages_remote);
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

