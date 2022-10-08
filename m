Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335FC5F8371
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 07:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJHF5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 01:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJHF4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 01:56:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A4B923D4;
        Fri,  7 Oct 2022 22:55:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 992076130E;
        Sat,  8 Oct 2022 05:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A48C43470;
        Sat,  8 Oct 2022 05:55:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="SPv34xoV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1665208524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HWsAhbEWo1B1ihEWGdt8Ri0s25HJf7SbB73HqwgSl1I=;
        b=SPv34xoVCvhCgtizq6FLVqOmH2kIXUewwccgNfsHfSyjluppTub7nrj+JvDzTkV0hAqM3h
        fcyQVVGMo3cV5SoVoGtBUIXv43v+z2V9xK0K85PHL3cTFCZgfBZ+kGdFCeMZgZgSr9W2S6
        yRmjKkh9IOp9dFV5Q8tfe3pUMG0yq2E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8b3beed3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 8 Oct 2022 05:55:24 +0000 (UTC)
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
Subject: [PATCH v5 2/7] treewide: use prandom_u32_max() when possible, part 2
Date:   Fri,  7 Oct 2022 23:53:54 -0600
Message-Id: <20221008055359.286426-3-Jason@zx2c4.com>
In-Reply-To: <20221008055359.286426-1-Jason@zx2c4.com>
References: <20221008055359.286426-1-Jason@zx2c4.com>
MIME-Version: 1.0
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
the minimum required bytes from the RNG and avoids divisions. This was
done by hand, covering things that coccinelle could not do on its own.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz> # for ext2, ext4, and sbitmap
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/ext2/ialloc.c   |  3 +--
 fs/ext4/ialloc.c   |  5 ++---
 lib/sbitmap.c      |  2 +-
 lib/test_vmalloc.c | 17 ++++-------------
 4 files changed, 8 insertions(+), 19 deletions(-)

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
diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 4f2f2d1bac56..a26bbbf20e62 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -151,9 +151,7 @@ static int random_size_alloc_test(void)
 	int i;
 
 	for (i = 0; i < test_loop_count; i++) {
-		n = prandom_u32();
-		n = (n % 100) + 1;
-
+		n = prandom_u32_max(100) + 1;
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
-- 
2.37.3

