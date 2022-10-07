Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CB95F7CDF
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiJGSDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 14:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJGSCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 14:02:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC92D994F;
        Fri,  7 Oct 2022 11:01:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8781C61A1B;
        Fri,  7 Oct 2022 18:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF34FC433C1;
        Fri,  7 Oct 2022 18:01:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="jtpfM9yS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665165698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SRC0yDTW0mt75wzDb9dHc03R21A1YNbYmob7gKuK8jQ=;
        b=jtpfM9yS18G/jgX1wTftysS2MdQzJ4kftUkoRuzIcJSF7xpTHi/ptOMN2OzuxkvgJkiokU
        bjV3DAdurmrMt8KDHmn+6PnqpOMrYxq2QYVwLc7+s7Ya8QCs1NUo3fDJHWHaCHW1kKCsGL
        0WIOma9V30qWeIVHH9w0Gask/kEfsCU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 417aa62e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 7 Oct 2022 18:01:38 +0000 (UTC)
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
Subject: [PATCH v4 2/6] treewide: use prandom_u32_max() when possible
Date:   Fri,  7 Oct 2022 12:01:03 -0600
Message-Id: <20221007180107.216067-3-Jason@zx2c4.com>
In-Reply-To: <20221007180107.216067-1-Jason@zx2c4.com>
References: <20221007180107.216067-1-Jason@zx2c4.com>
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
 arch/arm64/kernel/process.c          |  2 +-
 arch/loongarch/kernel/process.c      |  2 +-
 arch/loongarch/kernel/vdso.c         |  2 +-
 arch/mips/kernel/process.c           |  2 +-
 arch/mips/kernel/vdso.c              |  2 +-
 arch/parisc/kernel/vdso.c            |  2 +-
 arch/powerpc/kernel/process.c        |  2 +-
 arch/s390/kernel/process.c           |  2 +-
 drivers/block/drbd/drbd_receiver.c   |  4 ++--
 drivers/md/bcache/request.c          |  2 +-
 drivers/mtd/tests/stresstest.c       | 17 ++++-------------
 drivers/mtd/ubi/debug.h              |  6 +++---
 drivers/net/ethernet/broadcom/cnic.c |  3 +--
 fs/ext2/ialloc.c                     |  3 +--
 fs/ext4/ialloc.c                     |  5 ++---
 fs/ubifs/lpt_commit.c                |  2 +-
 fs/ubifs/tnc_commit.c                |  2 +-
 fs/xfs/libxfs/xfs_alloc.c            |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c           |  2 +-
 include/linux/nodemask.h             |  2 +-
 lib/cmdline_kunit.c                  |  4 ++--
 lib/kobject.c                        |  2 +-
 lib/reed_solomon/test_rslib.c        |  2 +-
 lib/sbitmap.c                        |  2 +-
 lib/test_hexdump.c                   |  2 +-
 lib/test_vmalloc.c                   | 17 ++++-------------
 net/core/pktgen.c                    |  4 ++--
 net/ipv4/inet_hashtables.c           |  2 +-
 net/sunrpc/cache.c                   |  2 +-
 net/sunrpc/xprtsock.c                |  2 +-
 30 files changed, 42 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 92bcc1768f0b..87203429f802 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -595,7 +595,7 @@ unsigned long __get_wchan(struct task_struct *p)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() & ~PAGE_MASK;
+		sp -= prandom_u32_max(PAGE_SIZE);
 	return sp & ~0xf;
 }
 
diff --git a/arch/loongarch/kernel/process.c b/arch/loongarch/kernel/process.c
index 660492f064e7..1256e3582475 100644
--- a/arch/loongarch/kernel/process.c
+++ b/arch/loongarch/kernel/process.c
@@ -293,7 +293,7 @@ unsigned long stack_top(void)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() & ~PAGE_MASK;
+		sp -= prandom_u32_max(PAGE_SIZE);
 
 	return sp & STACK_ALIGN;
 }
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
 
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 35b912bce429..bbe9ce471791 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -711,7 +711,7 @@ unsigned long mips_stack_top(void)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() & ~PAGE_MASK;
+		sp -= prandom_u32_max(PAGE_SIZE);
 
 	return sp & ALMASK;
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
 
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 0fbda89cd1bb..ff920f4d4317 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -2308,6 +2308,6 @@ void notrace __ppc64_runlatch_off(void)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() & ~PAGE_MASK;
+		sp -= prandom_u32_max(PAGE_SIZE);
 	return sp & ~0xf;
 }
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index d5119e039d85..5ec78555dd2e 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -224,7 +224,7 @@ unsigned long __get_wchan(struct task_struct *p)
 unsigned long arch_align_stack(unsigned long sp)
 {
 	if (!(current->personality & ADDR_NO_RANDOMIZE) && randomize_va_space)
-		sp -= get_random_int() & ~PAGE_MASK;
+		sp -= prandom_u32_max(PAGE_SIZE);
 	return sp & ~0xf;
 }
 
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
diff --git a/fs/ubifs/lpt_commit.c b/fs/ubifs/lpt_commit.c
index cd4d5726a78d..cfbc31f709f4 100644
--- a/fs/ubifs/lpt_commit.c
+++ b/fs/ubifs/lpt_commit.c
@@ -1970,7 +1970,7 @@ static int dbg_populate_lsave(struct ubifs_info *c)
 
 	if (!dbg_is_chk_gen(c))
 		return 0;
-	if (prandom_u32() & 3)
+	if (prandom_u32_max(4))
 		return 0;
 
 	for (i = 0; i < c->lsave_cnt; i++)
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
diff --git a/lib/cmdline_kunit.c b/lib/cmdline_kunit.c
index e6a31c927b06..a72a2c16066e 100644
--- a/lib/cmdline_kunit.c
+++ b/lib/cmdline_kunit.c
@@ -76,7 +76,7 @@ static void cmdline_test_lead_int(struct kunit *test)
 		int rc = cmdline_test_values[i];
 		int offset;
 
-		sprintf(in, "%u%s", prandom_u32_max(256), str);
+		sprintf(in, "%u%s", get_random_int() % 256, str);
 		/* Only first '-' after the number will advance the pointer */
 		offset = strlen(in) - strlen(str) + !!(rc == 2);
 		cmdline_do_one_test(test, in, rc, offset);
@@ -94,7 +94,7 @@ static void cmdline_test_tail_int(struct kunit *test)
 		int rc = strcmp(str, "") ? (strcmp(str, "-") ? 0 : 1) : 1;
 		int offset;
 
-		sprintf(in, "%s%u", str, prandom_u32_max(256));
+		sprintf(in, "%s%u", str, get_random_int() % 256);
 		/*
 		 * Only first and leading '-' not followed by integer
 		 * will advance the pointer.
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
index 6faf9c9a6215..4d241bdc88aa 100644
--- a/lib/reed_solomon/test_rslib.c
+++ b/lib/reed_solomon/test_rslib.c
@@ -199,7 +199,7 @@ static int get_rcw_we(struct rs_control *rs, struct wspace *ws,
 
 		derrlocs[i] = errloc;
 
-		if (ewsc && (prandom_u32() & 1)) {
+		if (ewsc && prandom_u32_max(2)) {
 			/* Erasure with the symbol intact */
 			errlocs[errloc] = 2;
 		} else {
diff --git a/lib/sbitmap.c b/lib/sbitmap.c
index c4f04edf3ee9..ef0661504561 100644
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
diff --git a/lib/test_hexdump.c b/lib/test_hexdump.c
index 0927f44cd478..41a0321f641a 100644
--- a/lib/test_hexdump.c
+++ b/lib/test_hexdump.c
@@ -208,7 +208,7 @@ static void __init test_hexdump_overflow(size_t buflen, size_t len,
 static void __init test_hexdump_overflow_set(size_t buflen, bool ascii)
 {
 	unsigned int i = 0;
-	int rs = (prandom_u32_max(2) + 1) * 16;
+	int rs = prandom_u32_max(2) + 1 * 16;
 
 	do {
 		int gs = 1 << i;
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
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index a13ee452429e..5ca4f953034c 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2469,11 +2469,11 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
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
 
-- 
2.37.3

