Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BAE5E5930
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiIVDLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbiIVDKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:10:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753417D7BF
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so807631pjk.4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=h9cusoEVOsvIBl4L0VXSFc2MJFL0mH6lft5B/P8cXkg=;
        b=EefbEI0k1Fvv0iVYJuV6w/tObk4UgFVwCXCDy/bABsI3ElERV6iytXpTF/NpFdgI1O
         d81RNyJnc5vfQA1f6BhbuzkggUhj9QwTixgkqhyctIWzBuhtrRb6AZvcdQwcRe2lnbl1
         JLox0/9IOh9NJapFOjCMAnZr4uVg2HMv5Yxdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=h9cusoEVOsvIBl4L0VXSFc2MJFL0mH6lft5B/P8cXkg=;
        b=nMUHvXXr7iwu7i2bovZT+Y+L6Zj4vOUuq8xr1syww4XvEc+KB4QkAIEpEr3WecBpR3
         UiKIXEJrSOWSbpODlrozZEUDZPdDjJkrOLJywiufIEqO+XF10WgR3IRVCD4F5WRQj0E+
         iHmNBmpcQeITHZ9VftCcQI06RvWV1MRePCP6oE9MAeO9iHjUArdNPF/k1CiVBuUujKmC
         G/c+UYx9SJ0K8AWbzNccjkQVr/DUUAil5kh3XU5jj49vDBY+5qh4JjNxR7RKT06zHV8v
         5FQpaozlFH0s8P3IeqxAOmEMbsL5Xu7ShSQ51t2s+wEzg5oiPQYp/5IbB0e0n/GHyEBe
         492A==
X-Gm-Message-State: ACrzQf0m5PWt5BsewwibeMbsJqeoI+1C8L/ZEQ/VW+sELC7FmE5LwPEQ
        OBhcaeTdDGSJdSdO7SsHqGRQXA==
X-Google-Smtp-Source: AMsMyM7erk6BHrQMxxcqPheW+HKrcqt2FcPmRVEmbz5MxMnxjV9RgJfmyvf0sA3fzWftgJsc7PNdUw==
X-Received: by 2002:a17:902:c205:b0:178:5083:f656 with SMTP id 5-20020a170902c20500b001785083f656mr1264667pll.81.1663816225447;
        Wed, 21 Sep 2022 20:10:25 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902d4c900b0016c1a1c1405sm2690393plg.222.2022.09.21.20.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:22 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH 01/12] slab: Introduce kmalloc_size_roundup()
Date:   Wed, 21 Sep 2022 20:10:02 -0700
Message-Id: <20220922031013.2150682-2-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5962; h=from:subject; bh=xZ4KvmpECLGcGEsYM/zKNprXKbXd9yWPl8ziuEK6bU0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9ISH57RDxzGZ7UZialGYuMXkkODnaIpmrO6frz1 JnTSVj+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEgAKCRCJcvTf3G3AJs0jD/ 9D8TMVp8e4DH86Ac/6txtkiLFvVFUXmWJTlIcztV3aHNeZUFgTtyJKbUyS/zmxZaIieM8uNiDl18aZ tFXG4/tQosDRpfPGTWZkPNKyVy0co9qQoJAqsQVgJijjzWaXitPIznFfMRsWJsHZkUlmSdgw7eGkue K/icTyNOfGqisB9zJ0Rt3u/9DuWH14ggoiHvu7PxwGUjRFaMvnXAAKaW1UIq9F83dyJjGUm38DADu9 4dfZCCjPjSlkFriDoF1Zl46UYapSeK6CjKINCrRxjHKe82xChD5DMqlJEXgUnMKNy0sDPpTsxq8Sda JGgN3Ry4iAbRaoNtpXRBsXwPfUk8qR3S1CYwwijhfkVjmK3DhOovAJqhsH3zX1A8DN1NawNv8K0iBn hQ6VQZGmjHr/hZoda6Rd/h98UPn+CpR5tnDV/gyX8lOcFytpbAUW/lXz0TR5Iyoto6OHwy+zO1n7AW MyqbTwIMPC7c17AKOQ8+COEl1jWv0QQyw8lCdYFsTBZ5aVwhfdqgd4NZbuYDdxUsEH81SVQQEZYqXf vGaIzaLEwq+c8FBwEDkGblzx1mqKGyz9o36hzstihC4vNVyv03Azq4elSlE2ZgKbhstadli4oCjvIt rnGXqP02zpXF4W9AgWxjdb/dO4G60VkpbWgiEbgUFW6b+Ei2xtqE09gmRfLg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the effort to help the compiler reason about buffer sizes, the
__alloc_size attribute was added to allocators. This improves the scope
of the compiler's ability to apply CONFIG_UBSAN_BOUNDS and (in the near
future) CONFIG_FORTIFY_SOURCE. For most allocations, this works well,
as the vast majority of callers are not expecting to use more memory
than what they asked for.

There is, however, one common exception to this: anticipatory resizing
of kmalloc allocations. These cases all use ksize() to determine the
actual bucket size of a given allocation (e.g. 128 when 126 was asked
for). This comes in two styles in the kernel:

1) An allocation has been determined to be too small, and needs to be
   resized. Instead of the caller choosing its own next best size, it
   wants to minimize the number of calls to krealloc(), so it just uses
   ksize() plus some additional bytes, forcing the realloc into the next
   bucket size, from which it can learn how large it is now. For example:

	data = krealloc(data, ksize(data) + 1, gfp);
	data_len = ksize(data);

2) The minimum size of an allocation is calculated, but since it may
   grow in the future, just use all the space available in the chosen
   bucket immediately, to avoid needing to reallocate later. A good
   example of this is skbuff's allocators:

	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
	...
	/* kmalloc(size) might give us more room than requested.
	 * Put skb_shared_info exactly at the end of allocated zone,
	 * to allow max possible filling before reallocation.
	 */
	osize = ksize(data);
        size = SKB_WITH_OVERHEAD(osize);

In both cases, the "how large is the allocation?" question is answered
_after_ the allocation, where the compiler hinting is not in an easy place
to make the association any more. This mismatch between the compiler's
view of the buffer length and the code's intention about how much it is
going to actually use has already caused problems[1]. It is possible to
fix this by reordering the use of the "actual size" information.

We can serve the needs of users of ksize() and still have accurate buffer
length hinting for the compiler by doing the bucket size calculation
_before_ the allocation. Code can instead ask "how large an allocation
would I get for a given size?".

Introduce kmalloc_size_roundup(), to serve this function so we can start
replacing the "anticipatory resizing" uses of ksize().

[1] https://github.com/ClangBuiltLinux/linux/issues/1599
    https://github.com/KSPP/linux/issues/183

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/slab.h | 31 +++++++++++++++++++++++++++++++
 mm/slab_common.c     | 17 +++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0fefdf528e0d..4fc41e4ed4a2 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -188,7 +188,21 @@ void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __a
 void kfree(const void *objp);
 void kfree_sensitive(const void *objp);
 size_t __ksize(const void *objp);
+
+/**
+ * ksize - Report actual allocation size of associated object
+ *
+ * @objp: Pointer returned from a prior kmalloc()-family allocation.
+ *
+ * This should not be used for writing beyond the originally requested
+ * allocation size. Either use krealloc() or round up the allocation size
+ * with kmalloc_size_roundup() prior to allocation. If this is used to
+ * access beyond the originally requested allocation size, UBSAN_BOUNDS
+ * and/or FORTIFY_SOURCE may trip, since they only know about the
+ * originally allocated size via the __alloc_size attribute.
+ */
 size_t ksize(const void *objp);
+
 #ifdef CONFIG_PRINTK
 bool kmem_valid_obj(void *object);
 void kmem_dump_obj(void *object);
@@ -779,6 +793,23 @@ extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
 unsigned int kmem_cache_size(struct kmem_cache *s);
+
+/**
+ * kmalloc_size_roundup - Report allocation bucket size for the given size
+ *
+ * @size: Number of bytes to round up from.
+ *
+ * This returns the number of bytes that would be available in a kmalloc()
+ * allocation of @size bytes. For example, a 126 byte request would be
+ * rounded up to the next sized kmalloc bucket, 128 bytes. (This is strictly
+ * for the general-purpose kmalloc()-based allocations, and is not for the
+ * pre-sized kmem_cache_alloc()-based allocations.)
+ *
+ * Use this to kmalloc() the full bucket size ahead of time instead of using
+ * ksize() to query the size after an allocation.
+ */
+unsigned int kmalloc_size_roundup(size_t size);
+
 void __init kmem_cache_init_late(void);
 
 #if defined(CONFIG_SMP) && defined(CONFIG_SLAB)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 17996649cfe3..132d91a0f8c7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -721,6 +721,23 @@ struct kmem_cache *kmalloc_slab(size_t size, gfp_t flags)
 	return kmalloc_caches[kmalloc_type(flags)][index];
 }
 
+unsigned int kmalloc_size_roundup(size_t size)
+{
+	struct kmem_cache *c;
+
+	/* Short-circuit the 0 size case. */
+	if (size == 0)
+		return 0;
+	/* Above the smaller buckets, size is a multiple of page size. */
+	if (size > KMALLOC_MAX_CACHE_SIZE)
+		return PAGE_SIZE << get_order(size);
+
+	/* The flags don't matter since size_index is common to all. */
+	c = kmalloc_slab(size, GFP_KERNEL);
+	return c ? c->object_size : 0;
+}
+EXPORT_SYMBOL(kmalloc_size_roundup);
+
 #ifdef CONFIG_ZONE_DMA
 #define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
 #else
-- 
2.34.1

