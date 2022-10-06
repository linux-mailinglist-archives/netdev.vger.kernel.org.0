Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1A15F6C2A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiJFQyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiJFQyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 12:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C17FBE2CC;
        Thu,  6 Oct 2022 09:54:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C0BF61A33;
        Thu,  6 Oct 2022 16:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B049EC43141;
        Thu,  6 Oct 2022 16:54:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="UFh9tdXR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665075240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EAwzTZ93e7dzZ8CgfmI5IKyvne9Elbb5zP31owjivyY=;
        b=UFh9tdXRARKBFmTXgds61LsE4xEArPEMqouU88o0wdtJTlYQEGPEdrm9EggP06wdnnFNpj
        5ExA8yNkHGRMBTDE9W27H7FHwEKH8PBSVlSmf+KsMYsiScZ2G/qaxrF7pGwtcqQ0bOWNkk
        Tp1QofW5iBNaOWO7pOn98vMHjC7HLNU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7a794d63 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 6 Oct 2022 16:54:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, patches@lists.linux.dev
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH v3 1/5] treewide: use prandom_u32_max() when possible
Date:   Thu,  6 Oct 2022 10:53:42 -0600
Message-Id: <20221006165346.73159-2-Jason@zx2c4.com>
In-Reply-To: <20221006165346.73159-1-Jason@zx2c4.com>
References: <20221006165346.73159-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than incurring a division or requesting too many random bytes for
the given range, use the prandom_u32_max() function, which only takes
the minimum required bytes from the RNG and avoids divisions.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: KP Singh <kpsingh@kernel.org>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com> # for drbd
Reviewed-by: Jan Kara <jack@suse.cz> # for ext2, ext4, and sbitmap
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/arm/kernel/process.c                     |  2 +-
 arch/loongarch/kernel/vdso.c                  |  2 +-
 arch/mips/kernel/vdso.c                       |  2 +-
 arch/parisc/kernel/vdso.c                     |  2 +-
 arch/s390/kernel/vdso.c                       |  2 +-
 arch/um/kernel/process.c                      |  2 +-
 arch/x86/entry/vdso/vma.c                     |  2 +-
 arch/x86/kernel/module.c                      |  2 +-
 arch/x86/kernel/process.c                     |  2 +-
 arch/x86/mm/pat/cpa-test.c                    |  4 +-
 crypto/testmgr.c                              | 86 +++++++++----------
 drivers/block/drbd/drbd_receiver.c            |  4 +-
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    |  2 +-
 drivers/infiniband/core/cma.c                 |  2 +-
 drivers/infiniband/hw/cxgb4/id_table.c        |  4 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c       |  5 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  3 +-
 drivers/md/bcache/request.c                   |  2 +-
 .../test-drivers/vivid/vivid-touch-cap.c      |  2 +-
 drivers/mmc/core/core.c                       |  4 +-
 drivers/mmc/host/dw_mmc.c                     |  2 +-
 drivers/mtd/nand/raw/nandsim.c                |  4 +-
 drivers/mtd/tests/mtd_nandecctest.c           | 10 +--
 drivers/mtd/tests/stresstest.c                | 17 +---
 drivers/mtd/ubi/debug.c                       |  2 +-
 drivers/mtd/ubi/debug.h                       |  6 +-
 drivers/net/ethernet/broadcom/cnic.c          |  3 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  4 +-
 drivers/net/hamradio/baycom_epp.c             |  2 +-
 drivers/net/hamradio/hdlcdrv.c                |  2 +-
 drivers/net/hamradio/yam.c                    |  2 +-
 drivers/net/phy/at803x.c                      |  2 +-
 .../broadcom/brcm80211/brcmfmac/p2p.c         |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                 |  4 +-
 drivers/scsi/qedi/qedi_main.c                 |  2 +-
 fs/ceph/inode.c                               |  2 +-
 fs/ceph/mdsmap.c                              |  2 +-
 fs/ext2/ialloc.c                              |  3 +-
 fs/ext4/ialloc.c                              |  5 +-
 fs/ext4/super.c                               |  7 +-
 fs/f2fs/gc.c                                  |  2 +-
 fs/f2fs/segment.c                             |  8 +-
 fs/ubifs/debug.c                              |  8 +-
 fs/ubifs/lpt_commit.c                         | 14 +--
 fs/ubifs/tnc_commit.c                         |  2 +-
 fs/xfs/libxfs/xfs_alloc.c                     |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c                    |  2 +-
 fs/xfs/xfs_error.c                            |  2 +-
 include/linux/nodemask.h                      |  2 +-
 kernel/bpf/core.c                             |  4 +-
 kernel/locking/test-ww_mutex.c                |  4 +-
 kernel/time/clocksource.c                     |  2 +-
 lib/fault-inject.c                            |  2 +-
 lib/find_bit_benchmark.c                      |  4 +-
 lib/kobject.c                                 |  2 +-
 lib/reed_solomon/test_rslib.c                 |  6 +-
 lib/sbitmap.c                                 |  4 +-
 lib/test-string_helpers.c                     |  2 +-
 lib/test_hexdump.c                            | 10 +--
 lib/test_kasan.c                              |  6 +-
 lib/test_list_sort.c                          |  2 +-
 lib/test_vmalloc.c                            | 17 +---
 mm/migrate.c                                  |  2 +-
 mm/slub.c                                     |  2 +-
 net/ceph/mon_client.c                         |  2 +-
 net/ceph/osd_client.c                         |  2 +-
 net/core/neighbour.c                          |  2 +-
 net/core/pktgen.c                             | 43 +++++-----
 net/core/stream.c                             |  2 +-
 net/ipv4/igmp.c                               |  6 +-
 net/ipv4/inet_connection_sock.c               |  2 +-
 net/ipv4/inet_hashtables.c                    |  2 +-
 net/ipv6/addrconf.c                           |  8 +-
 net/ipv6/mcast.c                              | 10 +--
 net/netfilter/ipvs/ip_vs_twos.c               |  4 +-
 net/packet/af_packet.c                        |  2 +-
 net/sched/act_gact.c                          |  2 +-
 net/sched/act_sample.c                        |  2 +-
 net/sched/sch_netem.c                         |  4 +-
 net/sctp/socket.c                             |  2 +-
 net/sunrpc/cache.c                            |  2 +-
 net/sunrpc/xprtsock.c                         |  2 +-
 net/tipc/socket.c                             |  2 +-
 net/xfrm/xfrm_state.c                         |  2 +-
 85 files changed, 205 insertions(+), 230 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 3d9cace63884..35129ae36067 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -375,7 +375,7 @@ static unsigned long sigpage_addr(const struct mm_struct *mm,
 
 	slots = ((last - first) >> PAGE_SHIFT) + 1;
 
-	offset = get_random_int() % slots;
+	offset = prandom_u32_max(slots);
 
 	addr = first + (offset << PAGE_SHIFT);
 
diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
index f32c38abd791..8c9826062652 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -78,7 +78,7 @@ static unsigned long vdso_base(void)
 	unsigned long base = STACK_TOP;
 
 	if (current->flags & PF_RANDOMIZE) {
-		base += get_random_int() & (VDSO_RANDOMIZE_SIZE - 1);
+		base += prandom_u32_max(VDSO_RANDOMIZE_SIZE);
 		base = PAGE_ALIGN(base);
 	}
 
diff --git a/arch/mips/kernel/vdso.c b/arch/mips/kernel/vdso.c
index b2cc2c2dd4bf..5fd9bf1d596c 100644
--- a/arch/mips/kernel/vdso.c
+++ b/arch/mips/kernel/vdso.c
@@ -79,7 +79,7 @@ static unsigned long vdso_base(void)
 	}
 
 	if (current->flags & PF_RANDOMIZE) {
-		base += get_random_int() & (VDSO_RANDOMIZE_SIZE - 1);
+		base += prandom_u32_max(VDSO_RANDOMIZE_SIZE);
 		base = PAGE_ALIGN(base);
 	}
 
diff --git a/arch/parisc/kernel/vdso.c b/arch/parisc/kernel/vdso.c
index 63dc44c4c246..47e5960a2f96 100644
--- a/arch/parisc/kernel/vdso.c
+++ b/arch/parisc/kernel/vdso.c
@@ -75,7 +75,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 	map_base = mm->mmap_base;
 	if (current->flags & PF_RANDOMIZE)
-		map_base -= (get_random_int() & 0x1f) * PAGE_SIZE;
+		map_base -= prandom_u32_max(0x20) * PAGE_SIZE;
 
 	vdso_text_start = get_unmapped_area(NULL, map_base, vdso_text_len, 0, 0);
 
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index 5075cde77b29..a6b5db59cf40 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -226,7 +226,7 @@ static unsigned long vdso_addr(unsigned long start, unsigned long len)
 	end -= len;
 
 	if (end > start) {
-		offset = get_random_int() % (((end - start) >> PAGE_SHIFT) + 1);
+		offset = prandom_u32_max(((end - start) >> PAGE_SHIFT) + 1);
 		addr = start + (offset << PAGE_SHIFT);
 	} else {
 		addr = start;
diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index 80b90b1276a1..010bc422a09d 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -356,7 +356,7 @@ int singlestepping(void * t)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= prandom_u32_max(8192);
 	return sp & ~0xf;
 }
 #endif
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 1000d457c332..b64c58c6940f 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -327,7 +327,7 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	end -= len;
 
 	if (end > start) {
-		offset = get_random_int() % (((end - start) >> PAGE_SHIFT) + 1);
+		offset = prandom_u32_max(((end - start) >> PAGE_SHIFT) + 1);
 		addr = start + (offset << PAGE_SHIFT);
 	} else {
 		addr = start;
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b1abf663417c..c032edcd3d95 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -53,7 +53,7 @@ static unsigned long int get_module_load_offset(void)
 		 */
 		if (module_load_offset == 0)
 			module_load_offset =
-				(get_random_int() % 1024 + 1) * PAGE_SIZE;
+				(prandom_u32_max(1024) + 1) * PAGE_SIZE;
 		mutex_unlock(&module_kaslr_mutex);
 	}
 	return module_load_offset;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 58a6ea472db9..c21b7347a26d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -965,7 +965,7 @@ early_param("idle", idle_setup);
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() % 8192;
+		sp -= prandom_u32_max(8192);
 	return sp & ~0xf;
 }
 
diff --git a/arch/x86/mm/pat/cpa-test.c b/arch/x86/mm/pat/cpa-test.c
index 0612a73638a8..423b21e80929 100644
--- a/arch/x86/mm/pat/cpa-test.c
+++ b/arch/x86/mm/pat/cpa-test.c
@@ -136,10 +136,10 @@ static int pageattr_test(void)
 	failed += print_split(&sa);
 
 	for (i = 0; i < NTEST; i++) {
-		unsigned long pfn = prandom_u32() % max_pfn_mapped;
+		unsigned long pfn = prandom_u32_max(max_pfn_mapped);
 
 		addr[i] = (unsigned long)__va(pfn << PAGE_SHIFT);
-		len[i] = prandom_u32() % NPAGES;
+		len[i] = prandom_u32_max(NPAGES);
 		len[i] = min_t(unsigned long, len[i], max_pfn_mapped - pfn - 1);
 
 		if (len[i] == 0)
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5349ffee6bbd..be45217acde4 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -855,9 +855,9 @@ static int prepare_keybuf(const u8 *key, unsigned int ksize,
 /* Generate a random length in range [0, max_len], but prefer smaller values */
 static unsigned int generate_random_length(unsigned int max_len)
 {
-	unsigned int len = prandom_u32() % (max_len + 1);
+	unsigned int len = prandom_u32_max(max_len + 1);
 
-	switch (prandom_u32() % 4) {
+	switch (prandom_u32_max(4)) {
 	case 0:
 		return len % 64;
 	case 1:
@@ -874,14 +874,14 @@ static void flip_random_bit(u8 *buf, size_t size)
 {
 	size_t bitpos;
 
-	bitpos = prandom_u32() % (size * 8);
+	bitpos = prandom_u32_max(size * 8);
 	buf[bitpos / 8] ^= 1 << (bitpos % 8);
 }
 
 /* Flip a random byte in the given nonempty data buffer */
 static void flip_random_byte(u8 *buf, size_t size)
 {
-	buf[prandom_u32() % size] ^= 0xff;
+	buf[prandom_u32_max(size)] ^= 0xff;
 }
 
 /* Sometimes make some random changes to the given nonempty data buffer */
@@ -891,15 +891,15 @@ static void mutate_buffer(u8 *buf, size_t size)
 	size_t i;
 
 	/* Sometimes flip some bits */
-	if (prandom_u32() % 4 == 0) {
-		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), size * 8);
+	if (prandom_u32_max(4) == 0) {
+		num_flips = min_t(size_t, 1 << prandom_u32_max(8), size * 8);
 		for (i = 0; i < num_flips; i++)
 			flip_random_bit(buf, size);
 	}
 
 	/* Sometimes flip some bytes */
-	if (prandom_u32() % 4 == 0) {
-		num_flips = min_t(size_t, 1 << (prandom_u32() % 8), size);
+	if (prandom_u32_max(4) == 0) {
+		num_flips = min_t(size_t, 1 << prandom_u32_max(8), size);
 		for (i = 0; i < num_flips; i++)
 			flip_random_byte(buf, size);
 	}
@@ -915,11 +915,11 @@ static void generate_random_bytes(u8 *buf, size_t count)
 	if (count == 0)
 		return;
 
-	switch (prandom_u32() % 8) { /* Choose a generation strategy */
+	switch (prandom_u32_max(8)) { /* Choose a generation strategy */
 	case 0:
 	case 1:
 		/* All the same byte, plus optional mutations */
-		switch (prandom_u32() % 4) {
+		switch (prandom_u32_max(4)) {
 		case 0:
 			b = 0x00;
 			break;
@@ -959,24 +959,24 @@ static char *generate_random_sgl_divisions(struct test_sg_division *divs,
 		unsigned int this_len;
 		const char *flushtype_str;
 
-		if (div == &divs[max_divs - 1] || prandom_u32() % 2 == 0)
+		if (div == &divs[max_divs - 1] || prandom_u32_max(2) == 0)
 			this_len = remaining;
 		else
-			this_len = 1 + (prandom_u32() % remaining);
+			this_len = 1 + prandom_u32_max(remaining);
 		div->proportion_of_total = this_len;
 
-		if (prandom_u32() % 4 == 0)
-			div->offset = (PAGE_SIZE - 128) + (prandom_u32() % 128);
-		else if (prandom_u32() % 2 == 0)
-			div->offset = prandom_u32() % 32;
+		if (prandom_u32_max(4) == 0)
+			div->offset = (PAGE_SIZE - 128) + prandom_u32_max(128);
+		else if (prandom_u32_max(2) == 0)
+			div->offset = prandom_u32_max(32);
 		else
-			div->offset = prandom_u32() % PAGE_SIZE;
-		if (prandom_u32() % 8 == 0)
+			div->offset = prandom_u32_max(PAGE_SIZE);
+		if (prandom_u32_max(8) == 0)
 			div->offset_relative_to_alignmask = true;
 
 		div->flush_type = FLUSH_TYPE_NONE;
 		if (gen_flushes) {
-			switch (prandom_u32() % 4) {
+			switch (prandom_u32_max(4)) {
 			case 0:
 				div->flush_type = FLUSH_TYPE_REIMPORT;
 				break;
@@ -988,7 +988,7 @@ static char *generate_random_sgl_divisions(struct test_sg_division *divs,
 
 		if (div->flush_type != FLUSH_TYPE_NONE &&
 		    !(req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
-		    prandom_u32() % 2 == 0)
+		    prandom_u32_max(2) == 0)
 			div->nosimd = true;
 
 		switch (div->flush_type) {
@@ -1035,7 +1035,7 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 
 	p += scnprintf(p, end - p, "random:");
 
-	switch (prandom_u32() % 4) {
+	switch (prandom_u32_max(4)) {
 	case 0:
 	case 1:
 		cfg->inplace_mode = OUT_OF_PLACE;
@@ -1050,12 +1050,12 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 		break;
 	}
 
-	if (prandom_u32() % 2 == 0) {
+	if (prandom_u32_max(2) == 0) {
 		cfg->req_flags |= CRYPTO_TFM_REQ_MAY_SLEEP;
 		p += scnprintf(p, end - p, " may_sleep");
 	}
 
-	switch (prandom_u32() % 4) {
+	switch (prandom_u32_max(4)) {
 	case 0:
 		cfg->finalization_type = FINALIZATION_TYPE_FINAL;
 		p += scnprintf(p, end - p, " use_final");
@@ -1071,7 +1071,7 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 	}
 
 	if (!(cfg->req_flags & CRYPTO_TFM_REQ_MAY_SLEEP) &&
-	    prandom_u32() % 2 == 0) {
+	    prandom_u32_max(2) == 0) {
 		cfg->nosimd = true;
 		p += scnprintf(p, end - p, " nosimd");
 	}
@@ -1084,7 +1084,7 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 					  cfg->req_flags);
 	p += scnprintf(p, end - p, "]");
 
-	if (cfg->inplace_mode == OUT_OF_PLACE && prandom_u32() % 2 == 0) {
+	if (cfg->inplace_mode == OUT_OF_PLACE && prandom_u32_max(2) == 0) {
 		p += scnprintf(p, end - p, " dst_divs=[");
 		p = generate_random_sgl_divisions(cfg->dst_divs,
 						  ARRAY_SIZE(cfg->dst_divs),
@@ -1093,13 +1093,13 @@ static void generate_random_testvec_config(struct testvec_config *cfg,
 		p += scnprintf(p, end - p, "]");
 	}
 
-	if (prandom_u32() % 2 == 0) {
-		cfg->iv_offset = 1 + (prandom_u32() % MAX_ALGAPI_ALIGNMASK);
+	if (prandom_u32_max(2) == 0) {
+		cfg->iv_offset = 1 + prandom_u32_max(MAX_ALGAPI_ALIGNMASK);
 		p += scnprintf(p, end - p, " iv_offset=%u", cfg->iv_offset);
 	}
 
-	if (prandom_u32() % 2 == 0) {
-		cfg->key_offset = 1 + (prandom_u32() % MAX_ALGAPI_ALIGNMASK);
+	if (prandom_u32_max(2) == 0) {
+		cfg->key_offset = 1 + prandom_u32_max(MAX_ALGAPI_ALIGNMASK);
 		p += scnprintf(p, end - p, " key_offset=%u", cfg->key_offset);
 	}
 
@@ -1652,8 +1652,8 @@ static void generate_random_hash_testvec(struct shash_desc *desc,
 	vec->ksize = 0;
 	if (maxkeysize) {
 		vec->ksize = maxkeysize;
-		if (prandom_u32() % 4 == 0)
-			vec->ksize = 1 + (prandom_u32() % maxkeysize);
+		if (prandom_u32_max(4) == 0)
+			vec->ksize = 1 + prandom_u32_max(maxkeysize);
 		generate_random_bytes((u8 *)vec->key, vec->ksize);
 
 		vec->setkey_error = crypto_shash_setkey(desc->tfm, vec->key,
@@ -2218,13 +2218,13 @@ static void mutate_aead_message(struct aead_testvec *vec, bool aad_iv,
 	const unsigned int aad_tail_size = aad_iv ? ivsize : 0;
 	const unsigned int authsize = vec->clen - vec->plen;
 
-	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
+	if (prandom_u32_max(2) == 0 && vec->alen > aad_tail_size) {
 		 /* Mutate the AAD */
 		flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
-		if (prandom_u32() % 2 == 0)
+		if (prandom_u32_max(2) == 0)
 			return;
 	}
-	if (prandom_u32() % 2 == 0) {
+	if (prandom_u32_max(2) == 0) {
 		/* Mutate auth tag (assuming it's at the end of ciphertext) */
 		flip_random_bit((u8 *)vec->ctext + vec->plen, authsize);
 	} else {
@@ -2249,7 +2249,7 @@ static void generate_aead_message(struct aead_request *req,
 	const unsigned int ivsize = crypto_aead_ivsize(tfm);
 	const unsigned int authsize = vec->clen - vec->plen;
 	const bool inauthentic = (authsize >= MIN_COLLISION_FREE_AUTHSIZE) &&
-				 (prefer_inauthentic || prandom_u32() % 4 == 0);
+				 (prefer_inauthentic || prandom_u32_max(4) == 0);
 
 	/* Generate the AAD. */
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
@@ -2257,7 +2257,7 @@ static void generate_aead_message(struct aead_request *req,
 		/* Avoid implementation-defined behavior. */
 		memcpy((u8 *)vec->assoc + vec->alen - ivsize, vec->iv, ivsize);
 
-	if (inauthentic && prandom_u32() % 2 == 0) {
+	if (inauthentic && prandom_u32_max(2) == 0) {
 		/* Generate a random ciphertext. */
 		generate_random_bytes((u8 *)vec->ctext, vec->clen);
 	} else {
@@ -2321,8 +2321,8 @@ static void generate_random_aead_testvec(struct aead_request *req,
 
 	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
 	vec->klen = maxkeysize;
-	if (prandom_u32() % 4 == 0)
-		vec->klen = prandom_u32() % (maxkeysize + 1);
+	if (prandom_u32_max(4) == 0)
+		vec->klen = prandom_u32_max(maxkeysize + 1);
 	generate_random_bytes((u8 *)vec->key, vec->klen);
 	vec->setkey_error = crypto_aead_setkey(tfm, vec->key, vec->klen);
 
@@ -2331,8 +2331,8 @@ static void generate_random_aead_testvec(struct aead_request *req,
 
 	/* Tag length: in [0, maxauthsize], but usually choose maxauthsize */
 	authsize = maxauthsize;
-	if (prandom_u32() % 4 == 0)
-		authsize = prandom_u32() % (maxauthsize + 1);
+	if (prandom_u32_max(4) == 0)
+		authsize = prandom_u32_max(maxauthsize + 1);
 	if (prefer_inauthentic && authsize < MIN_COLLISION_FREE_AUTHSIZE)
 		authsize = MIN_COLLISION_FREE_AUTHSIZE;
 	if (WARN_ON(authsize > maxdatasize))
@@ -2342,7 +2342,7 @@ static void generate_random_aead_testvec(struct aead_request *req,
 
 	/* AAD, plaintext, and ciphertext lengths */
 	total_len = generate_random_length(maxdatasize);
-	if (prandom_u32() % 4 == 0)
+	if (prandom_u32_max(4) == 0)
 		vec->alen = 0;
 	else
 		vec->alen = generate_random_length(total_len);
@@ -2958,8 +2958,8 @@ static void generate_random_cipher_testvec(struct skcipher_request *req,
 
 	/* Key: length in [0, maxkeysize], but usually choose maxkeysize */
 	vec->klen = maxkeysize;
-	if (prandom_u32() % 4 == 0)
-		vec->klen = prandom_u32() % (maxkeysize + 1);
+	if (prandom_u32_max(4) == 0)
+		vec->klen = prandom_u32_max(maxkeysize + 1);
 	generate_random_bytes((u8 *)vec->key, vec->klen);
 	vec->setkey_error = crypto_skcipher_setkey(tfm, vec->key, vec->klen);
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index af4c7d65490b..d8b1417dc503 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -781,7 +781,7 @@ static struct socket *drbd_wait_for_connect(struct drbd_connection *connection,
 
 	timeo = connect_int * HZ;
 	/* 28.5% random jitter */
-	timeo += (prandom_u32() & 1) ? timeo / 7 : -timeo / 7;
+	timeo += prandom_u32_max(2) ? timeo / 7 : -timeo / 7;
 
 	err = wait_for_completion_interruptible_timeout(&ad->door_bell, timeo);
 	if (err <= 0)
@@ -1004,7 +1004,7 @@ static int conn_connect(struct drbd_connection *connection)
 				drbd_warn(connection, "Error receiving initial packet\n");
 				sock_release(s);
 randomize:
-				if (prandom_u32() & 1)
+				if (prandom_u32_max(2))
 					goto retry;
 			}
 		}
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index cd75b0ca2555..845023c14eb3 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2424,7 +2424,7 @@ gen8_dispatch_bsd_engine(struct drm_i915_private *dev_priv,
 	/* Check whether the file_priv has already selected one ring. */
 	if ((int)file_priv->bsd_engine < 0)
 		file_priv->bsd_engine =
-			get_random_int() % num_vcs_engines(dev_priv);
+			prandom_u32_max(num_vcs_engines(dev_priv));
 
 	return file_priv->bsd_engine;
 }
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index be317f2665a9..d460935e89eb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3759,7 +3759,7 @@ static int cma_alloc_any_port(enum rdma_ucm_port_space ps,
 
 	inet_get_local_port_range(net, &low, &high);
 	remaining = (high - low) + 1;
-	rover = prandom_u32() % remaining + low;
+	rover = prandom_u32_max(remaining) + low;
 retry:
 	if (last_used_port != rover) {
 		struct rdma_bind_list *bind_list;
diff --git a/drivers/infiniband/hw/cxgb4/id_table.c b/drivers/infiniband/hw/cxgb4/id_table.c
index f64e7e02b129..280d61466855 100644
--- a/drivers/infiniband/hw/cxgb4/id_table.c
+++ b/drivers/infiniband/hw/cxgb4/id_table.c
@@ -54,7 +54,7 @@ u32 c4iw_id_alloc(struct c4iw_id_table *alloc)
 
 	if (obj < alloc->max) {
 		if (alloc->flags & C4IW_ID_TABLE_F_RANDOM)
-			alloc->last += prandom_u32() % RANDOM_SKIP;
+			alloc->last += prandom_u32_max(RANDOM_SKIP);
 		else
 			alloc->last = obj + 1;
 		if (alloc->last >= alloc->max)
@@ -85,7 +85,7 @@ int c4iw_id_table_alloc(struct c4iw_id_table *alloc, u32 start, u32 num,
 	alloc->start = start;
 	alloc->flags = flags;
 	if (flags & C4IW_ID_TABLE_F_RANDOM)
-		alloc->last = prandom_u32() % RANDOM_SKIP;
+		alloc->last = prandom_u32_max(RANDOM_SKIP);
 	else
 		alloc->last = 0;
 	alloc->max = num;
diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 492b122d0521..480c062dd04f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -41,9 +41,8 @@ static inline u16 get_ah_udp_sport(const struct rdma_ah_attr *ah_attr)
 	u16 sport;
 
 	if (!fl)
-		sport = get_random_u32() %
-			(IB_ROCE_UDP_ENCAP_VALID_PORT_MAX + 1 -
-			 IB_ROCE_UDP_ENCAP_VALID_PORT_MIN) +
+		sport = prandom_u32_max(IB_ROCE_UDP_ENCAP_VALID_PORT_MAX + 1 -
+					IB_ROCE_UDP_ENCAP_VALID_PORT_MIN) +
 			IB_ROCE_UDP_ENCAP_VALID_PORT_MIN;
 	else
 		sport = rdma_flow_label_to_udp_sport(fl);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 449904dac0a9..e2a89d7f52df 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1511,8 +1511,7 @@ static void rtrs_clt_err_recovery_work(struct work_struct *work)
 	rtrs_clt_stop_and_destroy_conns(clt_path);
 	queue_delayed_work(rtrs_wq, &clt_path->reconnect_dwork,
 			   msecs_to_jiffies(delay_ms +
-					    prandom_u32() %
-					    RTRS_RECONNECT_SEED));
+					    prandom_u32_max(RTRS_RECONNECT_SEED)));
 }
 
 static struct rtrs_clt_path *alloc_path(struct rtrs_clt_sess *clt,
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f2c5a7e06fa9..3427555b0cca 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -401,7 +401,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	}
 
 	if (bypass_torture_test(dc)) {
-		if ((get_random_int() & 3) == 3)
+		if (prandom_u32_max(4) == 3)
 			goto skip;
 		else
 			goto rescale;
diff --git a/drivers/media/test-drivers/vivid/vivid-touch-cap.c b/drivers/media/test-drivers/vivid/vivid-touch-cap.c
index 64e3e4cb30c2..792660a85bc1 100644
--- a/drivers/media/test-drivers/vivid/vivid-touch-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-touch-cap.c
@@ -221,7 +221,7 @@ static void vivid_fill_buff_noise(__s16 *tch_buf, int size)
 
 static inline int get_random_pressure(void)
 {
-	return get_random_int() % VIVID_PRESSURE_LIMIT;
+	return prandom_u32_max(VIVID_PRESSURE_LIMIT);
 }
 
 static void vivid_tch_buf_set(struct v4l2_pix_format *f,
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index ef53a2578824..95fa8fb1d45f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -97,8 +97,8 @@ static void mmc_should_fail_request(struct mmc_host *host,
 	    !should_fail(&host->fail_mmc_request, data->blksz * data->blocks))
 		return;
 
-	data->error = data_errors[prandom_u32() % ARRAY_SIZE(data_errors)];
-	data->bytes_xfered = (prandom_u32() % (data->bytes_xfered >> 9)) << 9;
+	data->error = data_errors[prandom_u32_max(ARRAY_SIZE(data_errors))];
+	data->bytes_xfered = prandom_u32_max(data->bytes_xfered >> 9) << 9;
 }
 
 #else /* CONFIG_FAIL_MMC_REQUEST */
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 581614196a84..c78bbc22e0d1 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1858,7 +1858,7 @@ static void dw_mci_start_fault_timer(struct dw_mci *host)
 	 * Try to inject the error at random points during the data transfer.
 	 */
 	hrtimer_start(&host->fault_timer,
-		      ms_to_ktime(prandom_u32() % 25),
+		      ms_to_ktime(prandom_u32_max(25)),
 		      HRTIMER_MODE_REL);
 }
 
diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
index 24beade95c7f..50bcf745e816 100644
--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -1405,9 +1405,9 @@ static void ns_do_bit_flips(struct nandsim *ns, int num)
 	if (bitflips && prandom_u32() < (1 << 22)) {
 		int flips = 1;
 		if (bitflips > 1)
-			flips = (prandom_u32() % (int) bitflips) + 1;
+			flips = prandom_u32_max(bitflips) + 1;
 		while (flips--) {
-			int pos = prandom_u32() % (num * 8);
+			int pos = prandom_u32_max(num * 8);
 			ns->buf.byte[pos / 8] ^= (1 << (pos % 8));
 			NS_WARN("read_page: flipping bit %d in page %d "
 				"reading from %d ecc: corrected=%u failed=%u\n",
diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index c4f271314f52..1c7201b0f372 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -47,7 +47,7 @@ struct nand_ecc_test {
 static void single_bit_error_data(void *error_data, void *correct_data,
 				size_t size)
 {
-	unsigned int offset = prandom_u32() % (size * BITS_PER_BYTE);
+	unsigned int offset = prandom_u32_max(size * BITS_PER_BYTE);
 
 	memcpy(error_data, correct_data, size);
 	__change_bit_le(offset, error_data);
@@ -58,9 +58,9 @@ static void double_bit_error_data(void *error_data, void *correct_data,
 {
 	unsigned int offset[2];
 
-	offset[0] = prandom_u32() % (size * BITS_PER_BYTE);
+	offset[0] = prandom_u32_max(size * BITS_PER_BYTE);
 	do {
-		offset[1] = prandom_u32() % (size * BITS_PER_BYTE);
+		offset[1] = prandom_u32_max(size * BITS_PER_BYTE);
 	} while (offset[0] == offset[1]);
 
 	memcpy(error_data, correct_data, size);
@@ -71,7 +71,7 @@ static void double_bit_error_data(void *error_data, void *correct_data,
 
 static unsigned int random_ecc_bit(size_t size)
 {
-	unsigned int offset = prandom_u32() % (3 * BITS_PER_BYTE);
+	unsigned int offset = prandom_u32_max(3 * BITS_PER_BYTE);
 
 	if (size == 256) {
 		/*
@@ -79,7 +79,7 @@ static unsigned int random_ecc_bit(size_t size)
 		 * and 17th bit) in ECC code for 256 byte data block
 		 */
 		while (offset == 16 || offset == 17)
-			offset = prandom_u32() % (3 * BITS_PER_BYTE);
+			offset = prandom_u32_max(3 * BITS_PER_BYTE);
 	}
 
 	return offset;
diff --git a/drivers/mtd/tests/stresstest.c b/drivers/mtd/tests/stresstest.c
index cb29c8c1b370..d2faaca7f19d 100644
--- a/drivers/mtd/tests/stresstest.c
+++ b/drivers/mtd/tests/stresstest.c
@@ -45,9 +45,8 @@ static int rand_eb(void)
 	unsigned int eb;
 
 again:
-	eb = prandom_u32();
 	/* Read or write up 2 eraseblocks at a time - hence 'ebcnt - 1' */
-	eb %= (ebcnt - 1);
+	eb = prandom_u32_max(ebcnt - 1);
 	if (bbt[eb])
 		goto again;
 	return eb;
@@ -55,20 +54,12 @@ static int rand_eb(void)
 
 static int rand_offs(void)
 {
-	unsigned int offs;
-
-	offs = prandom_u32();
-	offs %= bufsize;
-	return offs;
+	return prandom_u32_max(bufsize);
 }
 
 static int rand_len(int offs)
 {
-	unsigned int len;
-
-	len = prandom_u32();
-	len %= (bufsize - offs);
-	return len;
+	return prandom_u32_max(bufsize - offs);
 }
 
 static int do_read(void)
@@ -127,7 +118,7 @@ static int do_write(void)
 
 static int do_operation(void)
 {
-	if (prandom_u32() & 1)
+	if (prandom_u32_max(2))
 		return do_read();
 	else
 		return do_write();
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 31d427ee191a..908d0e088557 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -590,7 +590,7 @@ int ubi_dbg_power_cut(struct ubi_device *ubi, int caller)
 
 		if (ubi->dbg.power_cut_max > ubi->dbg.power_cut_min) {
 			range = ubi->dbg.power_cut_max - ubi->dbg.power_cut_min;
-			ubi->dbg.power_cut_counter += prandom_u32() % range;
+			ubi->dbg.power_cut_counter += prandom_u32_max(range);
 		}
 		return 0;
 	}
diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
index 118248a5d7d4..dc8d8f83657a 100644
--- a/drivers/mtd/ubi/debug.h
+++ b/drivers/mtd/ubi/debug.h
@@ -73,7 +73,7 @@ static inline int ubi_dbg_is_bgt_disabled(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_bitflip(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_bitflips)
-		return !(prandom_u32() % 200);
+		return !prandom_u32_max(200);
 	return 0;
 }
 
@@ -87,7 +87,7 @@ static inline int ubi_dbg_is_bitflip(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_write_failure(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_io_failures)
-		return !(prandom_u32() % 500);
+		return !prandom_u32_max(500);
 	return 0;
 }
 
@@ -101,7 +101,7 @@ static inline int ubi_dbg_is_write_failure(const struct ubi_device *ubi)
 static inline int ubi_dbg_is_erase_failure(const struct ubi_device *ubi)
 {
 	if (ubi->dbg.emulate_io_failures)
-		return !(prandom_u32() % 400);
+		return !prandom_u32_max(400);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index e86503d97f32..f597b313acaa 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -4105,8 +4105,7 @@ static int cnic_cm_alloc_mem(struct cnic_dev *dev)
 	for (i = 0; i < MAX_CM_SK_TBL_SZ; i++)
 		atomic_set(&cp->csk_tbl[i].ref_count, 0);
 
-	port_id = prandom_u32();
-	port_id %= CNIC_LOCAL_PORT_RANGE;
+	port_id = prandom_u32_max(CNIC_LOCAL_PORT_RANGE);
 	if (cnic_init_id_tbl(&cp->csk_port_tbl, CNIC_LOCAL_PORT_RANGE,
 			     CNIC_LOCAL_PORT_MIN, port_id)) {
 		cnic_cm_free_mem(dev);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index 539992dad8ba..a4256087ac82 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -919,8 +919,8 @@ static int csk_wait_memory(struct chtls_dev *cdev,
 	current_timeo = *timeo_p;
 	noblock = (*timeo_p ? false : true);
 	if (csk_mem_free(cdev, sk)) {
-		current_timeo = (prandom_u32() % (HZ / 5)) + 2;
-		vm_wait = (prandom_u32() % (HZ / 5)) + 2;
+		current_timeo = prandom_u32_max(HZ / 5) + 2;
+		vm_wait = prandom_u32_max(HZ / 5) + 2;
 	}
 
 	add_wait_queue(sk_sleep(sk), &wait);
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 3e69079ed694..7df78a721b04 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -438,7 +438,7 @@ static int transmit(struct baycom_state *bc, int cnt, unsigned char stat)
 			if ((--bc->hdlctx.slotcnt) > 0)
 				return 0;
 			bc->hdlctx.slotcnt = bc->ch_params.slottime;
-			if ((prandom_u32() % 256) > bc->ch_params.ppersist)
+			if (prandom_u32_max(256) > bc->ch_params.ppersist)
 				return 0;
 		}
 	}
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 8297411e87ea..360d041a62c4 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -377,7 +377,7 @@ void hdlcdrv_arbitrate(struct net_device *dev, struct hdlcdrv_state *s)
 	if ((--s->hdlctx.slotcnt) > 0)
 		return;
 	s->hdlctx.slotcnt = s->ch_params.slottime;
-	if ((prandom_u32() % 256) > s->ch_params.ppersist)
+	if (prandom_u32_max(256) > s->ch_params.ppersist)
 		return;
 	start_tx(dev, s);
 }
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 980f2be32f05..97a6cc5c7ae8 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -626,7 +626,7 @@ static void yam_arbitrate(struct net_device *dev)
 	yp->slotcnt = yp->slot / 10;
 
 	/* is random > persist ? */
-	if ((prandom_u32() % 256) > yp->pers)
+	if (prandom_u32_max(256) > yp->pers)
 		return;
 
 	yam_start_tx(dev, yp);
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 59fe356942b5..2a7108361246 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -1732,7 +1732,7 @@ static int qca808x_phy_fast_retrain_config(struct phy_device *phydev)
 
 static int qca808x_phy_ms_random_seed_set(struct phy_device *phydev)
 {
-	u16 seed_value = (prandom_u32() % QCA808X_MASTER_SLAVE_SEED_RANGE);
+	u16 seed_value = prandom_u32_max(QCA808X_MASTER_SLAVE_SEED_RANGE);
 
 	return at803x_debug_reg_mask(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
 			QCA808X_MASTER_SLAVE_SEED_CFG,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 479041f070f9..10d9d9c63b28 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1128,7 +1128,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
 		/* 100ms ~ 300ms */
 		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
-						100 * (1 + prandom_u32() % 3));
+						100 * (1 + prandom_u32_max(3)));
 	else
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index ed586e6d7d64..de0c545d50fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1099,7 +1099,7 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 			iwl_mvm_mac_ap_iterator, &data);
 
 		if (data.beacon_device_ts) {
-			u32 rand = (prandom_u32() % (64 - 36)) + 36;
+			u32 rand = prandom_u32_max(64 - 36) + 36;
 			mvmvif->ap_beacon_time = data.beacon_device_ts +
 				ieee80211_tu_to_usec(data.beacon_int * rand /
 						     100);
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 39e16eab47aa..ddc048069af2 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2233,7 +2233,7 @@ static void fcoe_ctlr_vn_restart(struct fcoe_ctlr *fip)
 
 	if (fip->probe_tries < FIP_VN_RLIM_COUNT) {
 		fip->probe_tries++;
-		wait = prandom_u32() % FIP_VN_PROBE_WAIT;
+		wait = prandom_u32_max(FIP_VN_PROBE_WAIT);
 	} else
 		wait = FIP_VN_RLIM_INT;
 	mod_timer(&fip->timer, jiffies + msecs_to_jiffies(wait));
@@ -3125,7 +3125,7 @@ static void fcoe_ctlr_vn_timeout(struct fcoe_ctlr *fip)
 					  fcoe_all_vn2vn, 0);
 			fip->port_ka_time = jiffies +
 				 msecs_to_jiffies(FIP_VN_BEACON_INT +
-					(prandom_u32() % FIP_VN_BEACON_FUZZ));
+					prandom_u32_max(FIP_VN_BEACON_FUZZ));
 		}
 		if (time_before(fip->port_ka_time, next_time))
 			next_time = fip->port_ka_time;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cecfb2cb4c7b..df2fe7bd26d1 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -618,7 +618,7 @@ static int qedi_cm_alloc_mem(struct qedi_ctx *qedi)
 				sizeof(struct qedi_endpoint *)), GFP_KERNEL);
 	if (!qedi->ep_tbl)
 		return -ENOMEM;
-	port_id = prandom_u32() % QEDI_LOCAL_PORT_RANGE;
+	port_id = prandom_u32_max(QEDI_LOCAL_PORT_RANGE);
 	if (qedi_init_id_tbl(&qedi->lcl_port_tbl, QEDI_LOCAL_PORT_RANGE,
 			     QEDI_LOCAL_PORT_MIN, port_id)) {
 		qedi_cm_free_mem(qedi);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 42351d7a0dd6..f0c6e7e7b92b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -362,7 +362,7 @@ static int ceph_fill_fragtree(struct inode *inode,
 	if (nsplits != ci->i_fragtree_nsplits) {
 		update = true;
 	} else if (nsplits) {
-		i = prandom_u32() % nsplits;
+		i = prandom_u32_max(nsplits);
 		id = le32_to_cpu(fragtree->splits[i].frag);
 		if (!__ceph_find_frag(ci, id))
 			update = true;
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8d0a6d2c2da4..3fbabc98e1f7 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -29,7 +29,7 @@ static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
 		return -1;
 
 	/* pick */
-	n = prandom_u32() % n;
+	n = prandom_u32_max(n);
 	for (j = 0, i = 0; i < m->possible_max_rank; i++) {
 		if (CEPH_MDS_IS_READY(i, ignore_laggy))
 			j++;
diff --git a/fs/ext2/ialloc.c b/fs/ext2/ialloc.c
index 998dd2ac8008..f4944c4dee60 100644
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -277,8 +277,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 		int best_ndir = inodes_per_group;
 		int best_group = -1;
 
-		group = prandom_u32();
-		parent_group = (unsigned)group % ngroups;
+		parent_group = prandom_u32_max(ngroups);
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
 			desc = ext2_get_group_desc (sb, group, NULL);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index f73e5eb43eae..36d5bc595cc2 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -463,10 +463,9 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 			hinfo.hash_version = DX_HASH_HALF_MD4;
 			hinfo.seed = sbi->s_hash_seed;
 			ext4fs_dirhash(parent, qstr->name, qstr->len, &hinfo);
-			grp = hinfo.hash;
+			parent_group = hinfo.hash % ngroups;
 		} else
-			grp = prandom_u32();
-		parent_group = (unsigned)grp % ngroups;
+			parent_group = prandom_u32_max(ngroups);
 		for (i = 0; i < ngroups; i++) {
 			g = (parent_group + i) % ngroups;
 			get_orlov_stats(sb, g, flex_size, &stats);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9a66abcca1a8..4af351320075 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3811,8 +3811,7 @@ static int ext4_lazyinit_thread(void *arg)
 			}
 			if (!progress) {
 				elr->lr_next_sched = jiffies +
-					(prandom_u32()
-					 % (EXT4_DEF_LI_MAX_START_DELAY * HZ));
+					prandom_u32_max(EXT4_DEF_LI_MAX_START_DELAY * HZ);
 			}
 			if (time_before(elr->lr_next_sched, next_wakeup))
 				next_wakeup = elr->lr_next_sched;
@@ -3959,8 +3958,8 @@ static struct ext4_li_request *ext4_li_request_new(struct super_block *sb,
 	 * spread the inode table initialization requests
 	 * better.
 	 */
-	elr->lr_next_sched = jiffies + (prandom_u32() %
-				(EXT4_DEF_LI_MAX_START_DELAY * HZ));
+	elr->lr_next_sched = jiffies + prandom_u32_max(
+				EXT4_DEF_LI_MAX_START_DELAY * HZ);
 	return elr;
 }
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 6da21d405ce1..2c5fd1db3a3e 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -285,7 +285,7 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 
 	/* let's select beginning hot/small space first in no_heap mode*/
 	if (f2fs_need_rand_seg(sbi))
-		p->offset = prandom_u32() % (MAIN_SECS(sbi) * sbi->segs_per_sec);
+		p->offset = prandom_u32_max(MAIN_SECS(sbi) * sbi->segs_per_sec);
 	else if (test_opt(sbi, NOHEAP) &&
 		(type == CURSEG_HOT_DATA || IS_NODESEG(type)))
 		p->offset = 0;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0de21f82d7bc..507f77f839f3 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2535,7 +2535,7 @@ static unsigned int __get_next_segno(struct f2fs_sb_info *sbi, int type)
 
 	sanity_check_seg_type(sbi, seg_type);
 	if (f2fs_need_rand_seg(sbi))
-		return prandom_u32() % (MAIN_SECS(sbi) * sbi->segs_per_sec);
+		return prandom_u32_max(MAIN_SECS(sbi) * sbi->segs_per_sec);
 
 	/* if segs_per_sec is large than 1, we need to keep original policy. */
 	if (__is_large_section(sbi))
@@ -2589,7 +2589,7 @@ static void new_curseg(struct f2fs_sb_info *sbi, int type, bool new_sec)
 	curseg->alloc_type = LFS;
 	if (F2FS_OPTION(sbi).fs_mode == FS_MODE_FRAGMENT_BLK)
 		curseg->fragment_remained_chunk =
-				prandom_u32() % sbi->max_fragment_chunk + 1;
+				prandom_u32_max(sbi->max_fragment_chunk) + 1;
 }
 
 static int __next_free_blkoff(struct f2fs_sb_info *sbi,
@@ -2626,9 +2626,9 @@ static void __refresh_next_blkoff(struct f2fs_sb_info *sbi,
 			/* To allocate block chunks in different sizes, use random number */
 			if (--seg->fragment_remained_chunk <= 0) {
 				seg->fragment_remained_chunk =
-				   prandom_u32() % sbi->max_fragment_chunk + 1;
+				   prandom_u32_max(sbi->max_fragment_chunk) + 1;
 				seg->next_blkoff +=
-				   prandom_u32() % sbi->max_fragment_hole + 1;
+				   prandom_u32_max(sbi->max_fragment_hole) + 1;
 			}
 		}
 	}
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index fc718f6178f2..f4d3b568aa64 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2467,7 +2467,7 @@ int dbg_check_nondata_nodes_order(struct ubifs_info *c, struct list_head *head)
 
 static inline int chance(unsigned int n, unsigned int out_of)
 {
-	return !!((prandom_u32() % out_of) + 1 <= n);
+	return !!(prandom_u32_max(out_of) + 1 <= n);
 
 }
 
@@ -2485,13 +2485,13 @@ static int power_cut_emulated(struct ubifs_info *c, int lnum, int write)
 			if (chance(1, 2)) {
 				d->pc_delay = 1;
 				/* Fail within 1 minute */
-				delay = prandom_u32() % 60000;
+				delay = prandom_u32_max(60000);
 				d->pc_timeout = jiffies;
 				d->pc_timeout += msecs_to_jiffies(delay);
 				ubifs_warn(c, "failing after %lums", delay);
 			} else {
 				d->pc_delay = 2;
-				delay = prandom_u32() % 10000;
+				delay = prandom_u32_max(10000);
 				/* Fail within 10000 operations */
 				d->pc_cnt_max = delay;
 				ubifs_warn(c, "failing after %lu calls", delay);
@@ -2571,7 +2571,7 @@ static int corrupt_data(const struct ubifs_info *c, const void *buf,
 	unsigned int from, to, ffs = chance(1, 2);
 	unsigned char *p = (void *)buf;
 
-	from = prandom_u32() % len;
+	from = prandom_u32_max(len);
 	/* Corruption span max to end of write unit */
 	to = min(len, ALIGN(from + 1, c->max_write_size));
 
diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index d76a19e460cd..cfbc31f709f4 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -1970,28 +1970,28 @@ static int dbg_populate_lsave(struct ubifs_info *c)
 
 	if (!dbg_is_chk_gen(c))
 		return 0;
-	if (prandom_u32() & 3)
+	if (prandom_u32_max(4))
 		return 0;
 
 	for (i = 0; i < c->lsave_cnt; i++)
 		c->lsave[i] = c->main_first;
 
 	list_for_each_entry(lprops, &c->empty_list, list)
-		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = lprops->lnum;
 	list_for_each_entry(lprops, &c->freeable_list, list)
-		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = lprops->lnum;
 	list_for_each_entry(lprops, &c->frdi_idx_list, list)
-		c->lsave[prandom_u32() % c->lsave_cnt] = lprops->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = lprops->lnum;
 
 	heap = &c->lpt_heap[LPROPS_DIRTY_IDX - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = heap->arr[i]->lnum;
 	heap = &c->lpt_heap[LPROPS_DIRTY - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = heap->arr[i]->lnum;
 	heap = &c->lpt_heap[LPROPS_FREE - 1];
 	for (i = 0; i < heap->cnt; i++)
-		c->lsave[prandom_u32() % c->lsave_cnt] = heap->arr[i]->lnum;
+		c->lsave[prandom_u32_max(c->lsave_cnt)] = heap->arr[i]->lnum;
 
 	return 1;
 }
diff --git a/fs/ubifs/tnc_commit.c b/fs/ubifs/tnc_commit.c
index 58c92c96ecef..01362ad5f804 100644
--- a/fs/ubifs/tnc_commit.c
+++ b/fs/ubifs/tnc_commit.c
@@ -700,7 +700,7 @@ static int alloc_idx_lebs(struct ubifs_info *c, int cnt)
 		c->ilebs[c->ileb_cnt++] = lnum;
 		dbg_cmt("LEB %d", lnum);
 	}
-	if (dbg_is_chk_index(c) && !(prandom_u32() & 7))
+	if (dbg_is_chk_index(c) && !prandom_u32_max(8))
 		return -ENOSPC;
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e2bdf089c0a3..6261599bb389 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1520,7 +1520,7 @@ xfs_alloc_ag_vextent_lastblock(
 
 #ifdef DEBUG
 	/* Randomly don't execute the first algorithm. */
-	if (prandom_u32() & 1)
+	if (prandom_u32_max(2))
 		return 0;
 #endif
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6cdfd64bc56b..7838b31126e2 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -636,7 +636,7 @@ xfs_ialloc_ag_alloc(
 	/* randomly do sparse inode allocations */
 	if (xfs_has_sparseinodes(tp->t_mountp) &&
 	    igeo->ialloc_min_blks < igeo->ialloc_blks)
-		do_sparse = prandom_u32() & 1;
+		do_sparse = prandom_u32_max(2);
 #endif
 
 	/*
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 296faa41d81d..7db588ed0be5 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -274,7 +274,7 @@ xfs_errortag_test(
 
 	ASSERT(error_tag < XFS_ERRTAG_MAX);
 	randfactor = mp->m_errortag[error_tag];
-	if (!randfactor || prandom_u32() % randfactor)
+	if (!randfactor || prandom_u32_max(randfactor))
 		return false;
 
 	xfs_warn_ratelimited(mp,
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 4b71a96190a8..66ee9b4b7925 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -509,7 +509,7 @@ static inline int node_random(const nodemask_t *maskp)
 	w = nodes_weight(*maskp);
 	if (w)
 		bit = bitmap_ord_to_pos(maskp->bits,
-			get_random_int() % w, MAX_NUMNODES);
+			prandom_u32_max(w), MAX_NUMNODES);
 	return bit;
 #else
 	return 0;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3d9eb3ae334c..ade6b03b1d9b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1027,7 +1027,7 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 	hdr->size = size;
 	hole = min_t(unsigned int, size - (proglen + sizeof(*hdr)),
 		     PAGE_SIZE - sizeof(*hdr));
-	start = (get_random_int() % hole) & ~(alignment - 1);
+	start = prandom_u32_max(hole) & ~(alignment - 1);
 
 	/* Leave a random number of instructions before BPF code. */
 	*image_ptr = &hdr->image[start];
@@ -1089,7 +1089,7 @@ bpf_jit_binary_pack_alloc(unsigned int proglen, u8 **image_ptr,
 
 	hole = min_t(unsigned int, size - (proglen + sizeof(*ro_header)),
 		     BPF_PROG_CHUNK_SIZE - sizeof(*ro_header));
-	start = (get_random_int() % hole) & ~(alignment - 1);
+	start = prandom_u32_max(hole) & ~(alignment - 1);
 
 	*image_ptr = &ro_header->image[start];
 	*rw_image = &(*rw_header)->image[start];
diff --git a/kernel/locking/test-ww_mutex.c b/kernel/locking/test-ww_mutex.c
index 353004155d65..43efb2a04160 100644
--- a/kernel/locking/test-ww_mutex.c
+++ b/kernel/locking/test-ww_mutex.c
@@ -399,7 +399,7 @@ static int *get_random_order(int count)
 		order[n] = n;
 
 	for (n = count - 1; n > 1; n--) {
-		r = get_random_int() % (n + 1);
+		r = prandom_u32_max(n + 1);
 		if (r != n) {
 			tmp = order[n];
 			order[n] = order[r];
@@ -538,7 +538,7 @@ static void stress_one_work(struct work_struct *work)
 {
 	struct stress *stress = container_of(work, typeof(*stress), work);
 	const int nlocks = stress->nlocks;
-	struct ww_mutex *lock = stress->locks + (get_random_int() % nlocks);
+	struct ww_mutex *lock = stress->locks + prandom_u32_max(nlocks);
 	int err;
 
 	do {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index cee5da1e54c4..8058bec87ace 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -310,7 +310,7 @@ static void clocksource_verify_choose_cpus(void)
 	 * CPUs that are currently online.
 	 */
 	for (i = 1; i < n; i++) {
-		cpu = prandom_u32() % nr_cpu_ids;
+		cpu = prandom_u32_max(nr_cpu_ids);
 		cpu = cpumask_next(cpu - 1, cpu_online_mask);
 		if (cpu >= nr_cpu_ids)
 			cpu = cpumask_first(cpu_online_mask);
diff --git a/lib/fault-inject.c b/lib/fault-inject.c
index 423784d9c058..96e092de5b72 100644
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -139,7 +139,7 @@ bool should_fail(struct fault_attr *attr, ssize_t size)
 			return false;
 	}
 
-	if (attr->probability <= prandom_u32() % 100)
+	if (attr->probability <= prandom_u32_max(100))
 		return false;
 
 	if (!fail_stacktrace(attr))
diff --git a/lib/find_bit_benchmark.c b/lib/find_bit_benchmark.c
index db904b57d4b8..1a6466c64bb6 100644
--- a/lib/find_bit_benchmark.c
+++ b/lib/find_bit_benchmark.c
@@ -157,8 +157,8 @@ static int __init find_bit_test(void)
 	bitmap_zero(bitmap2, BITMAP_LEN);
 
 	while (nbits--) {
-		__set_bit(prandom_u32() % BITMAP_LEN, bitmap);
-		__set_bit(prandom_u32() % BITMAP_LEN, bitmap2);
+		__set_bit(prandom_u32_max(BITMAP_LEN), bitmap);
+		__set_bit(prandom_u32_max(BITMAP_LEN), bitmap2);
 	}
 
 	test_find_next_bit(bitmap, BITMAP_LEN);
diff --git a/lib/kobject.c b/lib/kobject.c
index 5f0e71ab292c..a0b2dbfcfa23 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -694,7 +694,7 @@ static void kobject_release(struct kref *kref)
 {
 	struct kobject *kobj = container_of(kref, struct kobject, kref);
 #ifdef CONFIG_DEBUG_KOBJECT_RELEASE
-	unsigned long delay = HZ + HZ * (get_random_int() & 0x3);
+	unsigned long delay = HZ + HZ * prandom_u32_max(4);
 	pr_info("kobject: '%s' (%p): %s, parent %p (delayed %ld)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent, delay);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
diff --git a/lib/reed_solomon/test_rslib.c b/lib/reed_solomon/test_rslib.c
index d9d1c33aebda..4d241bdc88aa 100644
--- a/lib/reed_solomon/test_rslib.c
+++ b/lib/reed_solomon/test_rslib.c
@@ -183,7 +183,7 @@ static int get_rcw_we(struct rs_control *rs, struct wspace *ws,
 
 		do {
 			/* Must not choose the same location twice */
-			errloc = prandom_u32() % len;
+			errloc = prandom_u32_max(len);
 		} while (errlocs[errloc] != 0);
 
 		errlocs[errloc] = 1;
@@ -194,12 +194,12 @@ static int get_rcw_we(struct rs_control *rs, struct wspace *ws,
 	for (i = 0; i < eras; i++) {
 		do {
 			/* Must not choose the same location twice */
-			errloc = prandom_u32() % len;
+			errloc = prandom_u32_max(len);
 		} while (errlocs[errloc] != 0);
 
 		derrlocs[i] = errloc;
 
-		if (ewsc && (prandom_u32() & 1)) {
+		if (ewsc && prandom_u32_max(2)) {
 			/* Erasure with the symbol intact */
 			errlocs[errloc] = 2;
 		} else {
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index 29eb0484215a..ef0661504561 100644
--- a/lib/sbitmap.c
+++ b/lib/sbitmap.c
@@ -21,7 +21,7 @@ static int init_alloc_hint(struct sbitmap *sb, gfp_t flags)
 		int i;
 
 		for_each_possible_cpu(i)
-			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32() % depth;
+			*per_cpu_ptr(sb->alloc_hint, i) = prandom_u32_max(depth);
 	}
 	return 0;
 }
@@ -33,7 +33,7 @@ static inline unsigned update_alloc_hint_before_get(struct sbitmap *sb,
 
 	hint = this_cpu_read(*sb->alloc_hint);
 	if (unlikely(hint >= depth)) {
-		hint = depth ? prandom_u32() % depth : 0;
+		hint = depth ? prandom_u32_max(depth) : 0;
 		this_cpu_write(*sb->alloc_hint, hint);
 	}
 
diff --git a/lib/test-string_helpers.c b/lib/test-string_helpers.c
index 437d8e6b7cb1..86fadd3ba08c 100644
--- a/lib/test-string_helpers.c
+++ b/lib/test-string_helpers.c
@@ -587,7 +587,7 @@ static int __init test_string_helpers_init(void)
 	for (i = 0; i < UNESCAPE_ALL_MASK + 1; i++)
 		test_string_unescape("unescape", i, false);
 	test_string_unescape("unescape inplace",
-			     get_random_int() % (UNESCAPE_ANY + 1), true);
+			     prandom_u32_max(UNESCAPE_ANY + 1), true);
 
 	/* Without dictionary */
 	for (i = 0; i < ESCAPE_ALL_MASK + 1; i++)
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 5144899d3c6b..41a0321f641a 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -149,7 +149,7 @@ static void __init test_hexdump(size_t len, int rowsize, int groupsize,
 static void __init test_hexdump_set(int rowsize, bool ascii)
 {
 	size_t d = min_t(size_t, sizeof(data_b), rowsize);
-	size_t len = get_random_int() % d + 1;
+	size_t len = prandom_u32_max(d) + 1;
 
 	test_hexdump(len, rowsize, 4, ascii);
 	test_hexdump(len, rowsize, 2, ascii);
@@ -208,11 +208,11 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
 {
 	unsigned int i = 0;
-	int rs = (get_random_int() % 2 + 1) * 16;
+	int rs = prandom_u32_max(2) + 1 * 16;
 
 	do {
 		int gs = 1 << i;
-		size_t len = get_random_int() % rs + gs;
+		size_t len = prandom_u32_max(rs) + gs;
 
 		test_hexdump_overflow(buflen, rounddown(len, gs), rs, gs, ascii);
 	} while (i++ < 3);
@@ -223,11 +223,11 @@ static int __init test_hexdump_init(void)
 	unsigned int i;
 	int rowsize;
 
-	rowsize = (get_random_int() % 2 + 1) * 16;
+	rowsize = (prandom_u32_max(2) + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, false);
 
-	rowsize = (get_random_int() % 2 + 1) * 16;
+	rowsize = (prandom_u32_max(2) + 1) * 16;
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, true);
 
diff --git a/lib/test_kasan.c b/lib/test_kasan.c
index 58c1b01ccfe2..7b4026623ace 100644
--- a/lib/test_kasan.c
+++ b/lib/test_kasan.c
@@ -1269,7 +1269,7 @@ static void match_all_not_assigned(struct kunit *test)
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
 
 	for (i = 0; i < 256; i++) {
-		size = (get_random_int() % 1024) + 1;
+		size = prandom_u32_max(1024) + 1;
 		ptr = kmalloc(size, GFP_KERNEL);
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
@@ -1278,7 +1278,7 @@ static void match_all_not_assigned(struct kunit *test)
 	}
 
 	for (i = 0; i < 256; i++) {
-		order = (get_random_int() % 4) + 1;
+		order = prandom_u32_max(4) + 1;
 		pages = alloc_pages(GFP_KERNEL, order);
 		ptr = page_address(pages);
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
@@ -1291,7 +1291,7 @@ static void match_all_not_assigned(struct kunit *test)
 		return;
 
 	for (i = 0; i < 256; i++) {
-		size = (get_random_int() % 1024) + 1;
+		size = prandom_u32_max(1024) + 1;
 		ptr = vmalloc(size);
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
 		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
diff --git a/lib/test_list_sort.c b/lib/test_list_sort.c
index ade7a1ea0c8e..19ff229b9c3a 100644
--- a/lib/test_list_sort.c
+++ b/lib/test_list_sort.c
@@ -71,7 +71,7 @@ static void list_sort_test(struct kunit *test)
 		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, el);
 
 		 /* force some equivalencies */
-		el->value = prandom_u32() % (TEST_LIST_LEN / 3);
+		el->value = prandom_u32_max(TEST_LIST_LEN / 3);
 		el->serial = i;
 		el->poison1 = TEST_POISON1;
 		el->poison2 = TEST_POISON2;
diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 4f2f2d1bac56..56ffaa8dd3f6 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -151,9 +151,7 @@ static int random_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		n = prandom_u32();
-		n = (n % 100) + 1;
-
+		n = prandom_u32_max(n % 100) + 1;
 		p = vmalloc(n * PAGE_SIZE);
 
 		if (!p)
@@ -293,16 +291,12 @@ pcpu_alloc_test(void)
 		return -1;
 
 	for (i = 0; i < 35000; i++) {
-		unsigned int r;
-
-		r = prandom_u32();
-		size = (r % (PAGE_SIZE / 4)) + 1;
+		size = prandom_u32_max(PAGE_SIZE / 4) + 1;
 
 		/*
 		 * Maximum PAGE_SIZE
 		 */
-		r = prandom_u32();
-		align = 1 << ((r % 11) + 1);
+		align = 1 << (prandom_u32_max(11) + 1);
 
 		pcpu[i] = __alloc_percpu(size, align);
 		if (!pcpu[i])
@@ -393,14 +387,11 @@ static struct test_driver {
 
 static void shuffle_array(int *arr, int n)
 {
-	unsigned int rnd;
 	int i, j;
 
 	for (i = n - 1; i > 0; i--)  {
-		rnd = prandom_u32();
-
 		/* Cut the range. */
-		j = rnd % i;
+		j = prandom_u32_max(i);
 
 		/* Swap indexes. */
 		swap(arr[i], arr[j]);
diff --git a/mm/migrate.c b/mm/migrate.c
index 6a1597c92261..db04f95fe050 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2292,7 +2292,7 @@ int next_demotion_node(int node)
 		 * caching issue, which seems more complicated. So selecting
 		 * target node randomly seems better until now.
 		 */
-		index = get_random_int() % target_nr;
+		index = prandom_u32_max(target_nr);
 		break;
 	}
 
diff --git a/mm/slub.c b/mm/slub.c
index 862dbd9af4f5..46ee52efeeef 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1911,7 +1911,7 @@ static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab)
 		return false;
 
 	freelist_count = oo_objects(s->oo);
-	pos = get_random_int() % freelist_count;
+	pos = prandom_u32_max(freelist_count);
 
 	page_limit = slab->objects * s->size;
 	start = fixup_red_left(s, slab_address(slab));
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 6a6898ee4049..db60217f911b 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -222,7 +222,7 @@ static void pick_new_mon(struct ceph_mon_client *monc)
 				max--;
 		}
 
-		n = prandom_u32() % max;
+		n = prandom_u32_max(max);
 		if (o >= 0 && n >= o)
 			n++;
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 87b883c7bfd6..4e4f1e4bc265 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1479,7 +1479,7 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
 
 static int pick_random_replica(const struct ceph_osds *acting)
 {
-	int i = prandom_u32() % acting->size;
+	int i = prandom_u32_max(acting->size);
 
 	dout("%s picked osd%d, primary osd%d\n", __func__,
 	     acting->osds[i], acting->primary);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 78cc8fb68814..85d497cb58d8 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -111,7 +111,7 @@ static void neigh_cleanup_and_release(struct neighbour *neigh)
 
 unsigned long neigh_rand_reach_time(unsigned long base)
 {
-	return base ? (prandom_u32() % base) + (base >> 1) : 0;
+	return base ? prandom_u32_max(base) + (base >> 1) : 0;
 }
 EXPORT_SYMBOL(neigh_rand_reach_time);
 
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 88906ba6d9a7..5ca4f953034c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2324,7 +2324,7 @@ static inline int f_pick(struct pktgen_dev *pkt_dev)
 				pkt_dev->curfl = 0; /*reset */
 		}
 	} else {
-		flow = prandom_u32() % pkt_dev->cflows;
+		flow = prandom_u32_max(pkt_dev->cflows);
 		pkt_dev->curfl = flow;
 
 		if (pkt_dev->flows[flow].count > pkt_dev->lflow) {
@@ -2380,10 +2380,9 @@ static void set_cur_queue_map(struct pktgen_dev *pkt_dev)
 	else if (pkt_dev->queue_map_min <= pkt_dev->queue_map_max) {
 		__u16 t;
 		if (pkt_dev->flags & F_QUEUE_MAP_RND) {
-			t = prandom_u32() %
-				(pkt_dev->queue_map_max -
-				 pkt_dev->queue_map_min + 1)
-				+ pkt_dev->queue_map_min;
+			t = prandom_u32_max(pkt_dev->queue_map_max -
+					    pkt_dev->queue_map_min + 1) +
+			    pkt_dev->queue_map_min;
 		} else {
 			t = pkt_dev->cur_queue_map + 1;
 			if (t > pkt_dev->queue_map_max)
@@ -2412,7 +2411,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		__u32 tmp;
 
 		if (pkt_dev->flags & F_MACSRC_RND)
-			mc = prandom_u32() % pkt_dev->src_mac_count;
+			mc = prandom_u32_max(pkt_dev->src_mac_count);
 		else {
 			mc = pkt_dev->cur_src_mac_offset++;
 			if (pkt_dev->cur_src_mac_offset >=
@@ -2438,7 +2437,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		__u32 tmp;
 
 		if (pkt_dev->flags & F_MACDST_RND)
-			mc = prandom_u32() % pkt_dev->dst_mac_count;
+			mc = prandom_u32_max(pkt_dev->dst_mac_count);
 
 		else {
 			mc = pkt_dev->cur_dst_mac_offset++;
@@ -2470,18 +2469,18 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 	}
 
 	if ((pkt_dev->flags & F_VID_RND) && (pkt_dev->vlan_id != 0xffff)) {
-		pkt_dev->vlan_id = prandom_u32() & (4096 - 1);
+		pkt_dev->vlan_id = prandom_u32_max(4096);
 	}
 
 	if ((pkt_dev->flags & F_SVID_RND) && (pkt_dev->svlan_id != 0xffff)) {
-		pkt_dev->svlan_id = prandom_u32() & (4096 - 1);
+		pkt_dev->svlan_id = prandom_u32_max(4096);
 	}
 
 	if (pkt_dev->udp_src_min < pkt_dev->udp_src_max) {
 		if (pkt_dev->flags & F_UDPSRC_RND)
-			pkt_dev->cur_udp_src = prandom_u32() %
-				(pkt_dev->udp_src_max - pkt_dev->udp_src_min)
-				+ pkt_dev->udp_src_min;
+			pkt_dev->cur_udp_src = prandom_u32_max(
+				pkt_dev->udp_src_max - pkt_dev->udp_src_min) +
+				pkt_dev->udp_src_min;
 
 		else {
 			pkt_dev->cur_udp_src++;
@@ -2492,9 +2491,9 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 
 	if (pkt_dev->udp_dst_min < pkt_dev->udp_dst_max) {
 		if (pkt_dev->flags & F_UDPDST_RND) {
-			pkt_dev->cur_udp_dst = prandom_u32() %
-				(pkt_dev->udp_dst_max - pkt_dev->udp_dst_min)
-				+ pkt_dev->udp_dst_min;
+			pkt_dev->cur_udp_dst = prandom_u32_max(
+				pkt_dev->udp_dst_max - pkt_dev->udp_dst_min) +
+				pkt_dev->udp_dst_min;
 		} else {
 			pkt_dev->cur_udp_dst++;
 			if (pkt_dev->cur_udp_dst >= pkt_dev->udp_dst_max)
@@ -2509,7 +2508,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		if (imn < imx) {
 			__u32 t;
 			if (pkt_dev->flags & F_IPSRC_RND)
-				t = prandom_u32() % (imx - imn) + imn;
+				t = prandom_u32_max(imx - imn) + imn;
 			else {
 				t = ntohl(pkt_dev->cur_saddr);
 				t++;
@@ -2531,8 +2530,8 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 				if (pkt_dev->flags & F_IPDST_RND) {
 
 					do {
-						t = prandom_u32() %
-							(imx - imn) + imn;
+						t = prandom_u32_max(imx - imn) +
+						    imn;
 						s = htonl(t);
 					} while (ipv4_is_loopback(s) ||
 						ipv4_is_multicast(s) ||
@@ -2579,9 +2578,9 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 	if (pkt_dev->min_pkt_size < pkt_dev->max_pkt_size) {
 		__u32 t;
 		if (pkt_dev->flags & F_TXSIZE_RND) {
-			t = prandom_u32() %
-				(pkt_dev->max_pkt_size - pkt_dev->min_pkt_size)
-				+ pkt_dev->min_pkt_size;
+			t = prandom_u32_max(pkt_dev->max_pkt_size -
+					    pkt_dev->min_pkt_size) +
+			    pkt_dev->min_pkt_size;
 		} else {
 			t = pkt_dev->cur_pkt_size + 1;
 			if (t > pkt_dev->max_pkt_size)
@@ -2590,7 +2589,7 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 		pkt_dev->cur_pkt_size = t;
 	} else if (pkt_dev->n_imix_entries > 0) {
 		struct imix_pkt *entry;
-		__u32 t = prandom_u32() % IMIX_PRECISION;
+		__u32 t = prandom_u32_max(IMIX_PRECISION);
 		__u8 entry_index = pkt_dev->imix_distribution[t];
 
 		entry = &pkt_dev->imix_entries[entry_index];
diff --git a/net/core/stream.c b/net/core/stream.c
index ccc083cdef23..4780558ea314 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -123,7 +123,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	if (sk_stream_memory_free(sk))
-		current_timeo = vm_wait = (prandom_u32() % (HZ / 5)) + 2;
+		current_timeo = vm_wait = prandom_u32_max(HZ / 5) + 2;
 
 	add_wait_queue(sk_sleep(sk), &wait);
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index e3ab0cb61624..9149e78beea5 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -213,7 +213,7 @@ static void igmp_stop_timer(struct ip_mc_list *im)
 /* It must be called with locked im->lock */
 static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 {
-	int tv = prandom_u32() % max_delay;
+	int tv = prandom_u32_max(max_delay);
 
 	im->tm_running = 1;
 	if (!mod_timer(&im->timer, jiffies+tv+2))
@@ -222,7 +222,7 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 
 static void igmp_gq_start_timer(struct in_device *in_dev)
 {
-	int tv = prandom_u32() % in_dev->mr_maxdelay;
+	int tv = prandom_u32_max(in_dev->mr_maxdelay);
 	unsigned long exp = jiffies + tv + 2;
 
 	if (in_dev->mr_gq_running &&
@@ -236,7 +236,7 @@ static void igmp_gq_start_timer(struct in_device *in_dev)
 
 static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 {
-	int tv = prandom_u32() % delay;
+	int tv = prandom_u32_max(delay);
 
 	if (!mod_timer(&in_dev->mr_ifc_timer, jiffies+tv+2))
 		in_dev_hold(in_dev);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index eb31c7158b39..0c3eab1347cd 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -223,7 +223,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	offset = prandom_u32() % remaining;
+	offset = prandom_u32_max(remaining);
 	/* __inet_hash_connect() favors ports having @low parity
 	 * We do the opposite to not pollute connect() users.
 	 */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index b9d995b5ce24..9dc070f2018e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -794,7 +794,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	 * on low contention the randomness is maximal and on high contention
 	 * it may be inexistent.
 	 */
-	i = max_t(int, i, (prandom_u32() & 7) * 2);
+	i = max_t(int, i, prandom_u32_max(8) * 2);
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 10ce86bf228e..417834b7169d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -104,7 +104,7 @@ static inline u32 cstamp_delta(unsigned long cstamp)
 static inline s32 rfc3315_s14_backoff_init(s32 irt)
 {
 	/* multiply 'initial retransmission time' by 0.9 .. 1.1 */
-	u64 tmp = (900000 + prandom_u32() % 200001) * (u64)irt;
+	u64 tmp = (900000 + prandom_u32_max(200001)) * (u64)irt;
 	do_div(tmp, 1000000);
 	return (s32)tmp;
 }
@@ -112,11 +112,11 @@ static inline s32 rfc3315_s14_backoff_init(s32 irt)
 static inline s32 rfc3315_s14_backoff_update(s32 rt, s32 mrt)
 {
 	/* multiply 'retransmission timeout' by 1.9 .. 2.1 */
-	u64 tmp = (1900000 + prandom_u32() % 200001) * (u64)rt;
+	u64 tmp = (1900000 + prandom_u32_max(200001)) * (u64)rt;
 	do_div(tmp, 1000000);
 	if ((s32)tmp > mrt) {
 		/* multiply 'maximum retransmission time' by 0.9 .. 1.1 */
-		tmp = (900000 + prandom_u32() % 200001) * (u64)mrt;
+		tmp = (900000 + prandom_u32_max(200001)) * (u64)mrt;
 		do_div(tmp, 1000000);
 	}
 	return (s32)tmp;
@@ -3967,7 +3967,7 @@ static void addrconf_dad_kick(struct inet6_ifaddr *ifp)
 	if (ifp->flags & IFA_F_OPTIMISTIC)
 		rand_num = 0;
 	else
-		rand_num = prandom_u32() % (idev->cnf.rtr_solicit_delay ? : 1);
+		rand_num = prandom_u32_max(idev->cnf.rtr_solicit_delay ?: 1);
 
 	nonce = 0;
 	if (idev->cnf.enhanced_dad ||
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 87c699d57b36..bf4f5edb3c3e 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1050,7 +1050,7 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, const struct in6_addr *group,
 /* called with mc_lock */
 static void mld_gq_start_work(struct inet6_dev *idev)
 {
-	unsigned long tv = prandom_u32() % idev->mc_maxdelay;
+	unsigned long tv = prandom_u32_max(idev->mc_maxdelay);
 
 	idev->mc_gq_running = 1;
 	if (!mod_delayed_work(mld_wq, &idev->mc_gq_work, tv + 2))
@@ -1068,7 +1068,7 @@ static void mld_gq_stop_work(struct inet6_dev *idev)
 /* called with mc_lock */
 static void mld_ifc_start_work(struct inet6_dev *idev, unsigned long delay)
 {
-	unsigned long tv = prandom_u32() % delay;
+	unsigned long tv = prandom_u32_max(delay);
 
 	if (!mod_delayed_work(mld_wq, &idev->mc_ifc_work, tv + 2))
 		in6_dev_hold(idev);
@@ -1085,7 +1085,7 @@ static void mld_ifc_stop_work(struct inet6_dev *idev)
 /* called with mc_lock */
 static void mld_dad_start_work(struct inet6_dev *idev, unsigned long delay)
 {
-	unsigned long tv = prandom_u32() % delay;
+	unsigned long tv = prandom_u32_max(delay);
 
 	if (!mod_delayed_work(mld_wq, &idev->mc_dad_work, tv + 2))
 		in6_dev_hold(idev);
@@ -1130,7 +1130,7 @@ static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 	}
 
 	if (delay >= resptime)
-		delay = prandom_u32() % resptime;
+		delay = prandom_u32_max(resptime);
 
 	if (!mod_delayed_work(mld_wq, &ma->mca_work, delay))
 		refcount_inc(&ma->mca_refcnt);
@@ -2574,7 +2574,7 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 
 	igmp6_send(&ma->mca_addr, ma->idev->dev, ICMPV6_MGM_REPORT);
 
-	delay = prandom_u32() % unsolicited_report_interval(ma->idev);
+	delay = prandom_u32_max(unsolicited_report_interval(ma->idev));
 
 	if (cancel_delayed_work(&ma->mca_work)) {
 		refcount_dec(&ma->mca_refcnt);
diff --git a/net/netfilter/ipvs/ip_vs_twos.c b/net/netfilter/ipvs/ip_vs_twos.c
index acb55d8393ef..f2579fc9c75b 100644
--- a/net/netfilter/ipvs/ip_vs_twos.c
+++ b/net/netfilter/ipvs/ip_vs_twos.c
@@ -71,8 +71,8 @@ static struct ip_vs_dest *ip_vs_twos_schedule(struct ip_vs_service *svc,
 	 * from 0 to total_weight
 	 */
 	total_weight += 1;
-	rweight1 = prandom_u32() % total_weight;
-	rweight2 = prandom_u32() % total_weight;
+	rweight1 = prandom_u32_max(total_weight);
+	rweight2 = prandom_u32_max(total_weight);
 
 	/* Pick two weighted servers */
 	list_for_each_entry_rcu(dest, &svc->destinations, n_list) {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5cbe07116e04..331f80e12779 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1350,7 +1350,7 @@ static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *skb)
 		if (READ_ONCE(history[i]) == rxhash)
 			count++;
 
-	victim = prandom_u32() % ROLLOVER_HLEN;
+	victim = prandom_u32_max(ROLLOVER_HLEN);
 
 	/* Avoid dirtying the cache line if possible */
 	if (READ_ONCE(history[victim]) != rxhash)
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index ac29d1065232..1accaedef54f 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -26,7 +26,7 @@ static struct tc_action_ops act_gact_ops;
 static int gact_net_rand(struct tcf_gact *gact)
 {
 	smp_rmb(); /* coupled with smp_wmb() in tcf_gact_init() */
-	if (prandom_u32() % gact->tcfg_pval)
+	if (prandom_u32_max(gact->tcfg_pval))
 		return gact->tcf_action;
 	return gact->tcfg_paction;
 }
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 2f7f5e44d28c..55c9f961fb0f 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -169,7 +169,7 @@ static int tcf_sample_act(struct sk_buff *skb, const struct tc_action *a,
 	psample_group = rcu_dereference_bh(s->psample_group);
 
 	/* randomly sample packets according to rate */
-	if (psample_group && (prandom_u32() % s->rate == 0)) {
+	if (psample_group && (prandom_u32_max(s->rate) == 0)) {
 		if (!skb_at_tc_ingress(skb)) {
 			md.in_ifindex = skb->skb_iif;
 			md.out_ifindex = skb->dev->ifindex;
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 5449ed114e40..3ca320f1a031 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -513,8 +513,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto finish_segs;
 		}
 
-		skb->data[prandom_u32() % skb_headlen(skb)] ^=
-			1<<(prandom_u32() % 8);
+		skb->data[prandom_u32_max(skb_headlen(skb))] ^=
+			1<<prandom_u32_max(8);
 	}
 
 	if (unlikely(sch->q.qlen >= sch->limit)) {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 171f1a35d205..1e354ba44960 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -8319,7 +8319,7 @@ static int sctp_get_port_local(struct sock *sk, union sctp_addr *addr)
 
 		inet_get_local_port_range(net, &low, &high);
 		remaining = (high - low) + 1;
-		rover = prandom_u32() % remaining + low;
+		rover = prandom_u32_max(remaining) + low;
 
 		do {
 			rover++;
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index c3c693b51c94..f075a9fb5ccc 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -677,7 +677,7 @@ static void cache_limit_defers(void)
 
 	/* Consider removing either the first or the last */
 	if (cache_defer_cnt > DFR_MAX) {
-		if (prandom_u32() & 1)
+		if (prandom_u32_max(2))
 			discard = list_entry(cache_defer_list.next,
 					     struct cache_deferred_req, recent);
 		else
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index e976007f4fd0..c2caee703d2c 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1619,7 +1619,7 @@ static int xs_get_random_port(void)
 	if (max < min)
 		return -EADDRINUSE;
 	range = max - min + 1;
-	rand = (unsigned short) prandom_u32() % range;
+	rand = (unsigned short) prandom_u32_max(range);
 	return rand + min;
 }
 
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index f1c3b8eb4b3d..e902b01ea3cb 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3010,7 +3010,7 @@ static int tipc_sk_insert(struct tipc_sock *tsk)
 	struct net *net = sock_net(sk);
 	struct tipc_net *tn = net_generic(net, tipc_net_id);
 	u32 remaining = (TIPC_MAX_PORT - TIPC_MIN_PORT) + 1;
-	u32 portid = prandom_u32() % remaining + TIPC_MIN_PORT;
+	u32 portid = prandom_u32_max(remaining) + TIPC_MIN_PORT;
 
 	while (remaining--) {
 		portid++;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 91c32a3b6924..b213c89cfb8a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2072,7 +2072,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	} else {
 		u32 spi = 0;
 		for (h = 0; h < high-low+1; h++) {
-			spi = low + prandom_u32()%(high-low+1);
+			spi = low + prandom_u32_max(high - low + 1);
 			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
 			if (x0 == NULL) {
 				newspi = htonl(spi);
-- 
2.37.3

