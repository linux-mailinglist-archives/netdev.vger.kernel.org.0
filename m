Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D65D289516
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390169AbgJITzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:55:52 -0400
Received: from mga12.intel.com ([192.55.52.136]:29384 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389355AbgJITxz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:53:55 -0400
IronPort-SDR: bDmNjnNdMRZ+ioxLx0lwsy0xCkRGcoIkF1uO7/DGxT31PMyi/yHsDFfOYXBkHjpwCB8GF2sqCK
 rdqgPQHF8a+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="144851091"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="144851091"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:54 -0700
IronPort-SDR: bZn0Zma13YkX7FJFkNsCYMjMNff2FSiB/MgoUwYT50qMOfu0yRYfZtOtUYx1uwuwPtN+tdFX+r
 hwly4wq6Ikyg==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="519847271"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:53:53 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH RFC PKS/PMEM 53/58] lib: Utilize new kmap_thread()
Date:   Fri,  9 Oct 2020 12:50:28 -0700
Message-Id: <20201009195033.3208459-54-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
In-Reply-To: <20201009195033.3208459-1-ira.weiny@intel.com>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

These kmap() calls are localized to a single thread.  To avoid the over
head of global PKRS updates use the new kmap_thread() call.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 lib/iov_iter.c | 12 ++++++------
 lib/test_bpf.c |  4 ++--
 lib/test_hmm.c |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f12..1d47f957cf95 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -208,7 +208,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 	}
 	/* Too bad - revert to non-atomic kmap */
 
-	kaddr = kmap(page);
+	kaddr = kmap_thread(page);
 	from = kaddr + offset;
 	left = copyout(buf, from, copy);
 	copy -= left;
@@ -225,7 +225,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 		from += copy;
 		bytes -= copy;
 	}
-	kunmap(page);
+	kunmap_thread(page);
 
 done:
 	if (skip == iov->iov_len) {
@@ -292,7 +292,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	}
 	/* Too bad - revert to non-atomic kmap */
 
-	kaddr = kmap(page);
+	kaddr = kmap_thread(page);
 	to = kaddr + offset;
 	left = copyin(to, buf, copy);
 	copy -= left;
@@ -309,7 +309,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 		to += copy;
 		bytes -= copy;
 	}
-	kunmap(page);
+	kunmap_thread(page);
 
 done:
 	if (skip == iov->iov_len) {
@@ -1742,10 +1742,10 @@ int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
 		return 0;
 
 	iterate_all_kinds(i, bytes, v, -EINVAL, ({
-		w.iov_base = kmap(v.bv_page) + v.bv_offset;
+		w.iov_base = kmap_thread(v.bv_page) + v.bv_offset;
 		w.iov_len = v.bv_len;
 		err = f(&w, context);
-		kunmap(v.bv_page);
+		kunmap_thread(v.bv_page);
 		err;}), ({
 		w = v;
 		err = f(&w, context);})
diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index ca7d635bccd9..441f822f56ba 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -6506,11 +6506,11 @@ static void *generate_test_data(struct bpf_test *test, int sub)
 		if (!page)
 			goto err_kfree_skb;
 
-		ptr = kmap(page);
+		ptr = kmap_thread(page);
 		if (!ptr)
 			goto err_free_page;
 		memcpy(ptr, test->frag_data, MAX_DATA);
-		kunmap(page);
+		kunmap_thread(page);
 		skb_add_rx_frag(skb, 0, page, 0, MAX_DATA, MAX_DATA);
 	}
 
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index e7dc3de355b7..e40d26f97f45 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -329,9 +329,9 @@ static int dmirror_do_read(struct dmirror *dmirror, unsigned long start,
 		if (!page)
 			return -ENOENT;
 
-		tmp = kmap(page);
+		tmp = kmap_thread(page);
 		memcpy(ptr, tmp, PAGE_SIZE);
-		kunmap(page);
+		kunmap_thread(page);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
@@ -398,9 +398,9 @@ static int dmirror_do_write(struct dmirror *dmirror, unsigned long start,
 		if (!page || xa_pointer_tag(entry) != DPT_XA_TAG_WRITE)
 			return -ENOENT;
 
-		tmp = kmap(page);
+		tmp = kmap_thread(page);
 		memcpy(tmp, ptr, PAGE_SIZE);
-		kunmap(page);
+		kunmap_thread(page);
 
 		ptr += PAGE_SIZE;
 		bounce->cpages++;
-- 
2.28.0.rc0.12.gb6a658bd00c9

