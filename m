Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE39608EEA
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 20:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiJVSIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 14:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiJVSIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 14:08:38 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B692F6E2D5
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 11:08:37 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f193so5336172pgc.0
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 11:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1a2EeARYSnWxiJw6oHJsoY33Y0se207PXHB1ow0Ga1Y=;
        b=Hzo7fVyDyFo2PJFAkfNzn9H8cbKapupAWZ5PWbxzDFu82rpQAFcp0pBFsW8R7uFijG
         4c6NctRkB0FBvA2D/ZwyDwgS67NBZmZ/NShhOqVLXgDYeK1U/eot0KlY2WnH1VrVn4U9
         5EzUbeK2TvySp/qbXSuO7krMs86UA1bsVsSZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1a2EeARYSnWxiJw6oHJsoY33Y0se207PXHB1ow0Ga1Y=;
        b=4dKzMyu+lTXiTbiMNdr/WYkNoU2H3KeXr+tDSD0LgKk2YcBpVKoX5x3w1ypmDmlffE
         1X64RRJL408W32qdeFTpWC+EW0+PznsXVa0vETyBevw847jrXwXd8esr4fKiarWIgGy5
         9J6AKqB6MYKxxkl6F740fXXMVW4KH1zmuNqvySvneheA7UJKP9fPGGHO4+aBj4JS9Jl6
         JFljz1rk6VdgBxV52BFFk4c7nWE/qov6NsKCgzsVlmhJ86KmYz6vcgr3dst/pkmsds34
         MvwO788JzdrF9o8J0ZzH92Fl53toCe2Ogs7zqrygcl89xJsLksV8a7ZIrOlYkpKHuVfu
         sGng==
X-Gm-Message-State: ACrzQf0oe96t/FfSBrcixMUXurOsYTn2I3JZvGHrc8VG1xNRN16b27UZ
        JvbjjDw+Lr/XSFAVsRkHHmQeLg==
X-Google-Smtp-Source: AMsMyM4Nue+tbOGtKU+IRmf58DnKvAfMKg6+agJyUnqspmk2WdNO1OCFohOfwRpBp0gIJxQaEwwR5w==
X-Received: by 2002:a05:6a00:2485:b0:561:c0a5:88aa with SMTP id c5-20020a056a00248500b00561c0a588aamr25296071pfv.51.1666462117133;
        Sat, 22 Oct 2022 11:08:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w9-20020a628209000000b0056276519e8fsm10507248pfd.73.2022.10.22.11.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 11:08:36 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Lameter <cl@linux.com>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        linux-mm@kvack.org, kasan-dev@googlegroups.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] mm: Make ksize() a reporting-only function
Date:   Sat, 22 Oct 2022 11:08:15 -0700
Message-Id: <20221022180455.never.023-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5852; h=from:subject:message-id; bh=HZuoaDzt6/LPxyvOVuzqy3FtD9MM88oVQvBYI2b7PvI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjVDGPT373RHlxlNzRB3FSVMPSd+3N5IOFs8nbEih6 a4JcCZSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY1QxjwAKCRCJcvTf3G3AJg0sEA CJQgeNhzT7kGutiZ6DfvUQ98sYDiSG8cy5fz0XvctLjXFa0E+0jHWMYAU49DaTSiJAPjvkJtC3eGqU 6H9Yhzx9OnK6+3Pf6CkgpLB2j2roioL0N9/uKNk3O/B2Zg1vC5X5WSChvXQKKYa/DWRZFjm1hYuSe6 eJtnb4TJbTlAswbsKtrfUiRdurXNZNeo93YLboPpjS3Oui2Zmkjs3yXUfQ0wbI1EAg7/Lt76SiyOEk xNIhZchALtO+3yxGXJbt5/E4CJQNgHyzMQ3zidIrYmZSMr0kRDJiFI7yTRmMMI0lBclAXkUM9DX4qW hRRkLsDseezDlETYXdhqTUlsufdXvAkrRPatPCnP/z66b+G0HAlR4Op/K5RMvloMen54XAbuXSCb3f szujhc7zJ0Ivi0uis3misDev9gs4NVzX6jAIfK9HQaWVf5ybskYfX13uIDyQUgrDAJ2zz9nkWvzhs2 4hTLhJWpQfeMm38oPVkvCP7IbG6I4mdB1J5OdiYiA8VeriacD3+wR/UupDY/Jj8Jg7UfZ1mOVC8sv5 om+rocuJfmZOlkrezs1scXeeSujkP68ukOUtcdRMlNVkHBcNBzjUQ0SGgx0J2ToE0V2CFsQEG4XXjz 833VvH5PsOTeK7/T5CefUcbv4z3/iq4+gl9YtUf8Rd5EvVizs2QIsOzNYy2g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With all "silently resizing" callers of ksize() refactored, remove the
logic in ksize() that would allow it to be used to effectively change
the size of an allocation (bypassing __alloc_size hints, etc). Users
wanting this feature need to either use kmalloc_size_roundup() before an
allocation, or use krealloc() directly.

For kfree_sensitive(), move the unpoisoning logic inline. Replace the
some of the partially open-coded ksize() in __do_krealloc with ksize()
now that it doesn't perform unpoisoning.

Adjust the KUnit tests to match the new ksize() behavior.

Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: linux-mm@kvack.org
Cc: kasan-dev@googlegroups.com
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires at least this be landed first:
https://lore.kernel.org/lkml/20221021234713.you.031-kees@kernel.org/
I suspect given that is the most central ksize() user, this ksize()
fix might be best to land through the netdev tree...
---
 mm/kasan/kasan_test.c |  8 +++++---
 mm/slab_common.c      | 33 ++++++++++++++-------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
index 0d59098f0876..cb5c54adb503 100644
--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -783,7 +783,7 @@ static void kasan_global_oob_left(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
-/* Check that ksize() makes the whole object accessible. */
+/* Check that ksize() does NOT unpoison whole object. */
 static void ksize_unpoisons_memory(struct kunit *test)
 {
 	char *ptr;
@@ -791,15 +791,17 @@ static void ksize_unpoisons_memory(struct kunit *test)
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+
 	real_size = ksize(ptr);
+	KUNIT_EXPECT_GT(test, real_size, size);
 
 	OPTIMIZER_HIDE_VAR(ptr);
 
 	/* This access shouldn't trigger a KASAN report. */
-	ptr[size] = 'x';
+	ptr[size - 1] = 'x';
 
 	/* This one must. */
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
 
 	kfree(ptr);
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 33b1886b06eb..eabd66fcabd0 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1333,11 +1333,11 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	void *ret;
 	size_t ks;
 
-	/* Don't use instrumented ksize to allow precise KASAN poisoning. */
+	/* Check for double-free before calling ksize. */
 	if (likely(!ZERO_OR_NULL_PTR(p))) {
 		if (!kasan_check_byte(p))
 			return NULL;
-		ks = kfence_ksize(p) ?: __ksize(p);
+		ks = ksize(p);
 	} else
 		ks = 0;
 
@@ -1405,8 +1405,10 @@ void kfree_sensitive(const void *p)
 	void *mem = (void *)p;
 
 	ks = ksize(mem);
-	if (ks)
+	if (ks) {
+		kasan_unpoison_range(mem, ks);
 		memzero_explicit(mem, ks);
+	}
 	kfree(mem);
 }
 EXPORT_SYMBOL(kfree_sensitive);
@@ -1415,10 +1417,11 @@ EXPORT_SYMBOL(kfree_sensitive);
  * ksize - get the actual amount of memory allocated for a given object
  * @objp: Pointer to the object
  *
- * kmalloc may internally round up allocations and return more memory
+ * kmalloc() may internally round up allocations and return more memory
  * than requested. ksize() can be used to determine the actual amount of
- * memory allocated. The caller may use this additional memory, even though
- * a smaller amount of memory was initially specified with the kmalloc call.
+ * allocated memory. The caller may NOT use this additional memory, unless
+ * it calls krealloc(). To avoid an alloc/realloc cycle, callers can use
+ * kmalloc_size_roundup() to find the size of the associated kmalloc bucket.
  * The caller must guarantee that objp points to a valid object previously
  * allocated with either kmalloc() or kmem_cache_alloc(). The object
  * must not be freed during the duration of the call.
@@ -1427,13 +1430,11 @@ EXPORT_SYMBOL(kfree_sensitive);
  */
 size_t ksize(const void *objp)
 {
-	size_t size;
-
 	/*
-	 * We need to first check that the pointer to the object is valid, and
-	 * only then unpoison the memory. The report printed from ksize() is
-	 * more useful, then when it's printed later when the behaviour could
-	 * be undefined due to a potential use-after-free or double-free.
+	 * We need to first check that the pointer to the object is valid.
+	 * The KASAN report printed from ksize() is more useful, then when
+	 * it's printed later when the behaviour could be undefined due to
+	 * a potential use-after-free or double-free.
 	 *
 	 * We use kasan_check_byte(), which is supported for the hardware
 	 * tag-based KASAN mode, unlike kasan_check_read/write().
@@ -1447,13 +1448,7 @@ size_t ksize(const void *objp)
 	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !kasan_check_byte(objp))
 		return 0;
 
-	size = kfence_ksize(objp) ?: __ksize(objp);
-	/*
-	 * We assume that ksize callers could use whole allocated area,
-	 * so we need to unpoison this area.
-	 */
-	kasan_unpoison_range(objp, size);
-	return size;
+	return kfence_ksize(objp) ?: __ksize(objp);
 }
 EXPORT_SYMBOL(ksize);
 
-- 
2.34.1

