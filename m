Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD85193BC
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245501AbiEDBvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245459AbiEDBvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:51:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F6C32EE1
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:35 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x23so10860329pff.9
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5xrPLh8wlK0Awe/nxhZ3OTQkBfhB9ct4glfpE9UmuQA=;
        b=iR9L6Vqjlx1BryUCEPQzmXGsipsWNHmgM203Ex9fHJaxkwALa+U/8+AhC1W6u8Uu4S
         pdpKAydA7J6X8qY7ulBdTwd5M0XdedZwrLJ2rJGOBc8ssCMpRdfFdFzH/3OiOkWgs3nY
         iUUPR2F7rY3hlYziqOz651zfzNr5dc2NwLGx4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5xrPLh8wlK0Awe/nxhZ3OTQkBfhB9ct4glfpE9UmuQA=;
        b=mkqg6HSo9RyUaH+9G08WzoXYzOBokFOYg+bOd6HOgYPvCcPaiFdHdBqNIcxMbTe5fD
         r83q6TTCkoTIiQk1IcoBjlHtjpAmXy4bsEbM7Wr8rku+hmzDnCszemGFiOw+Ej/5kvUO
         HDI6EIcJauxSE7BsezubDSrEssd5nbyQDOkGUP3f7UCqU8ZGj8vSJIuHyC4zNpaDknyX
         Q4yYllZ9qqDTcTDNSgQnUfgXcQoguEiNIG9Loj32H3tKqj5j+XHxCrrG6PynPUpi1IYn
         7q2yuYVsIQKAuRniks0Lq0y+o2KWlOLExr0WePhA6JSdTglSqUBB4YIOVyNq6enop3to
         x6yw==
X-Gm-Message-State: AOAM532xtUKpdTp4vySnNV33SDstxvAqEHoMKFOEpAvgVIMg/UM8weHO
        GXnAZyNqaOGriDKlL6gWjW/gLg==
X-Google-Smtp-Source: ABdhPJzib/cexR9qOBRQWi0TZaQ7u+6vvahjJ6rp6GPg08J/VVUxtTMZbieOFE0yPnP+NBkPsparuA==
X-Received: by 2002:a62:a211:0:b0:50d:cdb2:87f4 with SMTP id m17-20020a62a211000000b0050dcdb287f4mr17774941pff.63.1651628855155;
        Tue, 03 May 2022 18:47:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y10-20020a170902864a00b0015e8d4eb254sm6924307plt.158.2022.05.03.18.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Keith Packard <keithp@keithp.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Daniel Axtens <dja@axtens.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Cong Wang <cong.wang@bytedance.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        keyrings@vger.kernel.org, kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 02/32] Introduce flexible array struct memcpy() helpers
Date:   Tue,  3 May 2022 18:44:11 -0700
Message-Id: <20220504014440.3697851-3-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=31712; h=from:subject; bh=5cc80Yc5OXNqRAprch5bwZGcqXUCUMStKhnm0MOB3y0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqBuKUviArqTxzH7Wyv/Nwvzm6EtfG7z8zEgd2S CFn/D26JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagQAKCRCJcvTf3G3AJpjQEA ChDXz4K07hJ0QiNbIT6owwYl55x0UIZFIMNeKxftQCbtR6Cl3MX4CkUi+/EJ8C8dPDo6mlzFTZqAxE XzATgYZNuJ523DOE/BPbCYmvKr4YAWPu6Wn7kbjIxVBMviz5nZcyJxQ+/XBUyAGJ3SxROvWBwUjV/6 F/JTDhfGISKpN7rStULVRZGpTFvhYy7KSGzeySPi7vdd0TzXBe/xWYm4+5OavNt9bEaQtWuPDsj44s DUlQOr5PRhiqMWKrzj0D2TzJNWzzHtyuSLO7/68u4AbQn8eb2UwqSoZd2dRkTgWpr3Z2V9/4cHhRDV WCmu8DVvZjtJESAMl+XTQPnpKn58oDlSpvOJbQQTA8KOSOou/Nci/P0W1rEVlYh0NojG6VCbAeBMrn rEVYhXf5v38RvldzmZdcHqvf8H1heVEsdF+y1ZbqUcAH22EtmZCnLmlHAi+20tUoXkU8VbgWEqvPJl Pah1xcPhbEcI1rbQunpPk4m/1qmImy9fuVUAyNvYMscpMdVdH4K0gKVYpQHZYsisa3jMvAsFcOOs2J iA/kdCWGFCI/JDzzU5cB8un6NJx/gQNXyzGdb41MWlUlEuoGJaqd6aYCuJPRtQbEQLLk/LJH0ABw65 j/jpppipk5fv9Ey1Hx63Ukkoh4P5ebCD0Gd8fn28BxsX/cCzBQE9z93YBRng==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The compiler is not able to automatically perform bounds checking
on structures that end in flexible arrays: __builtin_object_size()
is compile-time only. Any possible run-time checks are currently
short-circuited because there isn't an obvious common way to figure out
the bounds of such a structure. C has no way (yet[1]) to signify which
struct member holds the number of allocated flexible array elements
(like exists in other languages).

As a result, the kernel (and C projects generally) need to manually
check the bounds, check the element size calculations, and perform sanity
checking on all the associated variable types in between (e.g. 260
cannot be stored in a u8). This is extremely fragile.

However, even if we could do all this through a magic memcpy(), the API
itself doesn't provide meaningful feedback, which forces the kernel into
an "all or nothing" approach: either do the copy or panic the system. Any
failure conditions should be _detectable_, with API users able to
gracefully recover.

To deal with these needs, create a set of helper functions that do the
work of memcpy() but perform the needed bounds checking based on the
arguments given: flex_cpy(). The common pattern of "allocate and copy"
is also included: flex_dup(). However, one of the most common patterns
is deserialization: allocating and populating flexible array members
from a byte array: mem_to_flex_dup(). And if the elements are already
allocated: mem_to_flex().

The concept of a "flexible array structure" is introduced, which is a
struct that has both a trailing flexible array member _and_ an element
count member. If a struct lacks the element count member, it's just a
blob: there are no bounds associated with it.

The most common style of flexible array struct in the kernel is a
"normal" one, where both the flex-array and element-count are present:

    struct flex_array_struct_example {
        ...		/* arbitrary members */
        u16 part_count;	/* count of elements stored in "parts" below. */
        ...		/* arbitrary members */
        u32 parts[];	/* flexible array with elements of type u32. */
    };

Next are "encapsulating flexible array structs", which is just a struct
that contains a flexible array struct as its final member:

    struct encapsulating_example {
        ...		/* arbitrary members */
        struct flex_array_struct_example fas;
    };

There are also "split" flex array structs, which have the element-count
member in a separate struct level than the flex-array member:

    struct split_example {
        ...		/* arbitrary members */
        u16 part_count;	/* count of elements stored in "parts" below. */
        ...		/* arbitrary members */
        struct blob_example {
            ...		/* other blob members */
            u32 parts[];/* flexible array with elements of type u32. */
        } blob;
    };

To have the helpers deal with these arbitrary layouts, the names of the
flex-array and element-count members need to be specified with each use
(since C lacks the array-with-length syntax[1] so the compiler cannot
automatically determine them). However, for the "normal" (most common)
case, we can get close to "automatic" by explicitly declaring common
member aliases "__flex_array_elements", and "__flex_array_elements_count"
respectively. The regular helpers use these members, but extended helpers
exist to cover the other two code patterns.

For example, using the most complicated helper, mem_to_flex_dup():

    /* Flexible array struct with members identified. */
    struct something {
        int mode;
        DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, how_many);
        unsigned long flags;
        DECLARE_FLEX_ARRAY_ELEMENTS(u32, value);
    };
    ...
    struct something *instance = NULL;
    int rc;

    rc = mem_to_flex_dup(&instance, byte_array, count, GFP_KERNEL);
    if (rc)
        return rc;

This will:

- validate "instance" is non-NULL (no NULL dereference).
- validate "*instance" is NULL (no memory allocation resource leak).
- validate that "count" is:
  - non-negative (no arithmetic underflow).
  - has a value that can be stored in the "how_many" type (no value
    truncation).
- calculate the bytes needed to store "count"-many trailing u32 elements
  (no arithmetic overflow/underflow).
- calculate the bytes needed for a "struct something" with the above
  trailing elements (no arithmetic overflow/underflow).
- allocate the memory and check the result (no NULL dereference).
- initialize the non-flex-array portion of the struct to zero (no
  uninitialized memory usage).
- copy from "buf" into the flexible array elements.

If anything goes wrong, it returns a negative errno.

With these helpers the kernel can move away from many of the open-coded
patterns of using memcpy() with a dynamically-sized destination buffer.

[1] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1990.htm

Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Keith Packard <keithp@keithp.com>
Cc: Francis Laniel <laniel_francis@privacyrequired.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/flex_array.h  | 637 ++++++++++++++++++++++++++++++++++++
 include/linux/string.h      |   1 +
 include/uapi/linux/stddef.h |  14 +
 3 files changed, 652 insertions(+)
 create mode 100644 include/linux/flex_array.h

diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
new file mode 100644
index 000000000000..b2cf219f7b56
--- /dev/null
+++ b/include/linux/flex_array.h
@@ -0,0 +1,637 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_FLEX_ARRAY_H_
+#define _LINUX_FLEX_ARRAY_H_
+
+#include <linux/string.h>
+/*
+ * A "flexible array structure" is a struct which ends with a flexible
+ * array _and_ contains a member that represents how many array elements
+ * are present in the flexible array structure:
+ *
+ * struct flex_array_struct_example {
+ *	...		// arbitrary members
+ *	u16 part_count;	// count of elements stored in "parts" below.
+ *	..		// arbitrary members
+ *	u32 parts[];	// flexible array with elements of type u32.
+ * };
+ *
+ * Without the "count of elements" member, a structure ending with a
+ * flexible array has no way to check its own size, and should be
+ * considered just a blob of memory that is length-checked through some
+ * other means. Kernel structures with flexible arrays should strive to
+ * always be true flexible array structures so that they can be operated
+ * on with the flex*()-family of helpers defined below.
+ *
+ * An "encapsulating flexible array structure" is a structure that contains
+ * a full "flexible array structure" as its final struct member. These are
+ * used frequently when needing to pass around a copy of a flexible array
+ * structure, and track other things about the data outside of the scope of
+ * the flexible array structure itself:
+ *
+ * struct encapsulating_example {
+ *	...		// other members
+ *	struct flex_array_struct_example fas;
+ * };
+ *
+ * For bounds checking operations on a flexible array structure, member
+ * aliases must be created so the helpers can always locate the associated
+ * members. Marking up the examples above would look like this:
+ *
+ * struct flex_array_struct_example {
+ *	...		// arbitrary members
+ *	// count of elements stored in "parts" below.
+ *	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u16, part_count);
+ *	..		// arbitrary members
+ *	// flexible array with elements of type u32.
+ *	DECLARE_FLEX_ARRAY_ELEMENTS(u32, parts);
+ * };
+ *
+ * The above creates the aliases for part_count as __flex_array_elements_count
+ * and parts as __flex_array_elements.
+ *
+ * For encapsulated flexible array structs, there are alternative helpers
+ * below where the flexible array struct member name can be explicitly
+ * included as an argument. (See the @dot_fas_member arguments below.)
+ *
+ *
+ * Examples:
+ *
+ * Using mem_to_flex():
+ *
+ *        struct single {
+ *                u32 flags;
+ *                u32 count;
+ *                u8 data[];
+ *        };
+ *        struct single *ptr_single;
+ *
+ *        struct encap {
+ *                u16 info;
+ *                struct single single;
+ *        };
+ *        struct encap *ptr_encap;
+ *
+ *        struct blob {
+ *                u32 flags;
+ *                u8 data[];
+ *        };
+ *
+ *        struct split {
+ *                u32 count;
+ *                struct blob blob;
+ *        };
+ *        struct split *ptr_split;
+ *
+ *        mem_to_flex(ptr_one, src, count);
+ *        __mem_to_flex(ptr_encap, single.data, single.count, src, count);
+ *        __mem_to_flex(ptr_split, count, blob.data, src, count);
+ *
+ */
+
+/* These are wrappers around the UAPI macros. */
+#define DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(TYPE, NAME)			\
+	__DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(TYPE, NAME)
+
+#define DECLARE_FLEX_ARRAY_ELEMENTS(TYPE, NAME)				\
+	__DECLARE_FLEX_ARRAY_ELEMENTS(TYPE, NAME)
+
+/* All the helpers return negative on failure, as must be checked. */
+static inline int __must_check __must_check_errno(int err)
+{
+	return err;
+}
+
+/**
+ * __fas_elements_bytes - Calculate potential size of the flexible
+ *			  array elements of a given flexible array
+ *			  structure.
+ *
+ * @p: Pointer to flexible array structure.
+ * @flex_member: Member name of the flexible array elements.
+ * @count_member: Member name of the flexible array elements count.
+ * @elements_count: Count of proposed number of @p->__flex_array_elements
+ * @bytes: Pointer to variable to write calculation of total size in bytes.
+ *
+ * Returns: 0 on successful calculation, -ve on error.
+ *
+ * This performs the same calculation as flex_array_size(), except
+ * that the result is bounds checked and written to @bytes instead
+ * of being returned.
+ */
+#define __fas_elements_bytes(p, flex_member, count_member,		\
+			     elements_count, bytes)			\
+__must_check_errno(({							\
+	int __feb_err = -EINVAL;					\
+	size_t __feb_elements_count = (elements_count);			\
+	size_t __feb_elements_max =					\
+		type_max(typeof((p)->count_member));			\
+	if (__feb_elements_count > __feb_elements_max ||		\
+	    check_mul_overflow(sizeof(*(p)->flex_member),		\
+			       __feb_elements_count, bytes)) {		\
+		*(bytes) = 0;						\
+		__feb_err = -E2BIG;					\
+	} else {							\
+		__feb_err = 0;						\
+	}								\
+	__feb_err;							\
+}))
+
+/**
+ * fas_elements_bytes - Calculate current size of the flexible array
+ *			elements of a given flexible array structure.
+ *
+ * @p: Pointer to flexible array structure.
+ * @bytes: Pointer to variable to write calculation of total size in bytes.
+ *
+ * Returns: 0 on successful calculation, -ve on error.
+ *
+ * This performs the same calculation as flex_array_size(), except
+ * that the result is bounds checked and written to @bytes instead
+ * of being returned.
+ */
+#define fas_elements_bytes(p, bytes)					\
+	__fas_elements_bytes(p, __flex_array_elements,			\
+			     __flex_array_elements_count,		\
+			     (p)->__flex_array_elements_count, bytes)
+
+/** __fas_bytes - Calculate potential size of flexible array structure
+ *
+ * @p: Pointer to flexible array structure.
+ * @flex_member: Member name of the flexible array elements.
+ * @count_member: Member name of the flexible array elements count.
+ * @elements_count: Count of proposed number of @p->__flex_array_elements
+ * @bytes: Pointer to variable to write calculation of total size in bytes.
+ *
+ * Returns: 0 on successful calculation, -ve on error.
+ *
+ * This performs the same calculation as struct_size(), except
+ * that the result is bounds checked and written to @bytes instead
+ * of being returned.
+ */
+#define __fas_bytes(p, flex_member, count_member, elements_count, bytes)\
+__must_check_errno(({							\
+	int __fasb_err;							\
+	typeof(*bytes) __fasb_bytes;					\
+									\
+	if (__fas_elements_bytes(p, flex_member, count_member,		\
+				 elements_count, &__fasb_bytes) ||	\
+	    check_add_overflow(sizeof(*(p)), __fasb_bytes, bytes)) {	\
+		*(bytes) = 0;						\
+		__fasb_err = -E2BIG;					\
+	} else {							\
+		__fasb_err = 0;						\
+	}								\
+	__fasb_err;							\
+}))
+
+/** fas_bytes - Calculate current size of flexible array structure
+ *
+ * @p: Pointer to flexible array structure.
+ * @bytes: Pointer to variable to write calculation of total size in bytes.
+ *
+ * This performs the same calculation as struct_size(), except
+ * that the result is bounds checked and written to @bytes instead
+ * of being returned, using the current size of the flexible array
+ * structure (via @p->__flexible_array_elements_count).
+ *
+ * Returns: 0 on successful calculation, -ve on error.
+ */
+#define fas_bytes(p, bytes)						\
+	__fas_bytes(p, __flex_array_elements,				\
+		    __flex_array_elements_count,			\
+		    (p)->__flex_array_elements_count, bytes)
+
+/** flex_cpy - Copy from one flexible array struct into another with count conversion
+ *
+ * @dst: Destination pointer
+ * @src: Source pointer
+ *
+ * The full structure of @src will be copied to @dst, including all trailing
+ * flexible array elements. @dst->__flex_array_elements_count must be large
+ * enough to hold @src->__flex_array_elements_count. Any elements left over
+ * in @dst will be zero-wiped.
+ *
+ * Returns: 0 on successful calculation, -ve on error.
+ */
+#define flex_cpy(dst, src) __must_check_errno(({			\
+	int __fc_err = -EINVAL;						\
+	typeof(*(dst)) *__fc_dst = (dst);				\
+	typeof(*(src)) *__fc_src = (src);				\
+	size_t __fc_dst_bytes, __fc_src_bytes;				\
+									\
+	BUILD_BUG_ON(!__same_type(*(__fc_dst), *(__fc_src)));		\
+									\
+	do {								\
+		if (fas_bytes(__fc_dst, &__fc_dst_bytes) ||		\
+		    fas_bytes(__fc_src, &__fc_src_bytes) ||		\
+		    __fc_dst_bytes < __fc_src_bytes) {			\
+			/* do we need to wipe dst here? */		\
+			__fc_err = -E2BIG;				\
+			break;						\
+		}							\
+		__builtin_memcpy(__fc_dst, __fc_src, __fc_src_bytes);	\
+		/* __flex_array_elements_count is included in memcpy */	\
+		/* Wipe any now-unused trailing elements in @dst: */	\
+		__builtin_memset((u8 *)__fc_dst + __fc_src_bytes, 0,	\
+				 __fc_dst_bytes - __fc_src_bytes);	\
+		__fc_err = 0;						\
+	} while (0);							\
+	__fc_err;							\
+}))
+
+/** __flex_dup - Allocate and copy an arbitrarily encapsulated flexible
+ *		 array struct
+ *
+ * @alloc: Pointer to Pointer to hold to-be-allocated (optionally
+ *	   encapsulating) flexible array struct.
+ * @dot_fas_member: For encapsulating flexible arrays, the name of the
+ *		    flexible array struct member preceded with a literal
+ *		    dot (e.g. .foo.bar.flex_array_struct_name). For a
+ *		    regular flexible array struct, this macro arument is
+ *		    empty.
+ * @src: Pointer to source flexible array struct.
+ * @gfp: GFP allocation flags
+ *
+ * This copies the contents of one flexible array struct into another.
+ * The (**@alloc)@dot_fas_member and @src arguments must resolve to the
+ * same type. Everything prior to @dot_fas_member in *@alloc will be
+ * initialized to zero.
+ *
+ * Failure modes:
+ * - @alloc is NULL.
+ * - *@alloc is not NULL (something was already allocated).
+ * - Required allocation size is larger than size_t can hold.
+ * - No available memory to allocate @alloc.
+ *
+ * Returns: 0 on success, -ve on failure.
+ */
+#define __flex_dup(alloc, dot_fas_member, src, gfp)			\
+__must_check_errno(({							\
+	int __fd_err = -EINVAL;						\
+	typeof(*(src)) *__fd_src = (src);				\
+	typeof(**(alloc)) *__fd_alloc;					\
+	typeof((*__fd_alloc)dot_fas_member) *__fd_dst;			\
+	size_t __fd_alloc_bytes, __fd_copy_bytes;			\
+									\
+	BUILD_BUG_ON(!__same_type(*(__fd_dst), *(__fd_src)));		\
+									\
+	do {								\
+		if ((uintptr_t)(alloc) < 1 || *(alloc)) {		\
+			__fd_err = -EINVAL;				\
+			break;						\
+		}							\
+		if (fas_bytes(__fd_src, &__fd_copy_bytes) ||		\
+		    check_add_overflow(__fd_copy_bytes,			\
+				       sizeof(*__fd_alloc) -		\
+					sizeof(*__fd_dst),		\
+				       &__fd_alloc_bytes)) {		\
+			__fd_err = -E2BIG;				\
+			break;						\
+		}							\
+		__fd_alloc = kmalloc(__fd_alloc_bytes, gfp);		\
+		if (!__fd_alloc) {					\
+			__fd_err = -ENOMEM;				\
+			break;						\
+		}							\
+		__fd_dst = &((*__fd_alloc)dot_fas_member);		\
+		/* Optimize away any unneeded memset. */		\
+		if (sizeof(*__fd_alloc) != sizeof(*__fd_dst))		\
+			__builtin_memset(__fd_alloc, 0,			\
+					 __fd_alloc_bytes -		\
+						__fd_copy_bytes);	\
+		__builtin_memcpy(__fd_dst, src, __fd_copy_bytes);	\
+		/* __flex_array_elements_count is included in memcpy */	\
+		*(alloc) = __fd_alloc;					\
+		__fd_err = 0;						\
+	} while (0);							\
+	__fd_err;							\
+}))
+
+/** flex_dup - Allocate and copy a flexible array struct
+ *
+ * @alloc: Pointer to Pointer to hold to-be-allocated flexible array struct.
+ * @src: Pointer to source flexible array struct.
+ * @gfp: GFP allocation flags
+ *
+ * This copies the contents of one flexible array struct into another.
+ * The *@alloc and @src arguments must resolve to the same type.
+ *
+ * Failure modes:
+ * - @alloc is NULL.
+ * - *@alloc is not NULL (something was already allocated).
+ * - Required allocation size is larger than size_t can hold.
+ * - No available memory to allocate @alloc.
+ *
+ * Returns: 0 on success, -ve on failure.
+ */
+#define flex_dup(alloc, src, gfp)					\
+	__flex_dup(alloc, /* alloc itself */, src, gfp)
+
+/** __mem_to_flex - Copy from memory buffer into a flexible array structure's
+ *		    flexible array elements.
+ *
+ * @ptr: Pointer to already allocated flexible array struct.
+ * @flex_member: Member name of the flexible array elements.
+ * @count_member: Member name of the flexible array elements count.
+ * @src: Source memory pointer.
+ * @elements_count: Number of @ptr's flexible array elements to copy from
+ *		    @src into @ptr.
+ *
+ * Copies @elements_count-many elements from memory buffer at @src into
+ * @ptr->@flex_member, wipes any remaining elements, and updates
+ * @ptr->@count_member.
+ *
+ * This is essentially a simple deserializer.
+ *
+ * TODO: It would be nice to automatically discover the max bounds of @src
+ *	 besides @elements_count. There is currently no universal way to ask
+ *	 "what is the size of a given pointer's allocation?" So for
+ *	 now just use __builtin_object_size(@src, 1) to validate known
+ *	 compile-time too-large conditions. Perhaps in the future if
+ *	 __mtf_copy_bytes above is > PAGE_SIZE, perform a dynamic lookup
+ *	 using something similar to __check_heap_object().
+ *
+ * Failure conditions:
+ * - The value of @elements_count cannot fit in the @ptr's @count_member
+ *   type (e.g. 260 in a u8).
+ * - @ptr's @count_member value is smaller than @elements_count (e.g. not
+ *   enough space was previously allocated).
+ * - @elements_count yields a byte count greater than:
+ *   - INT_MAX (as a simple "too big" sanity check)
+ *   - the compile-time size of @src (when it can be determined)
+ *
+ * Returns: 0 on success, -ve on error.
+ */
+#define __mem_to_flex(ptr, flex_member, count_member, src,		\
+		      elements_count)					\
+__must_check_errno(({							\
+	int __mtf_err = -EINVAL;					\
+	typeof(*(ptr)) *__mtf_ptr = (ptr);				\
+	typeof(elements_count) __mtf_src_count = (elements_count);	\
+	size_t __mtf_copy_bytes, __mtf_dst_bytes;			\
+	u8 *__mtf_dst = (u8 *)__mtf_ptr->flex_member;			\
+									\
+	do {								\
+		if (is_negative(__mtf_src_count) ||			\
+		    __fas_elements_bytes(__mtf_ptr, flex_member,	\
+					 count_member,			\
+					 __mtf_src_count,		\
+					 &__mtf_copy_bytes) ||		\
+		    __mtf_copy_bytes > INT_MAX ||			\
+		    __mtf_copy_bytes > __builtin_object_size(src, 1) ||	\
+		    __fas_elements_bytes(__mtf_ptr, flex_member,	\
+					 count_member,			\
+					 __mtf_ptr->count_member,	\
+					 &__mtf_dst_bytes) ||		\
+		    __mtf_dst_bytes < __mtf_copy_bytes) {		\
+			__mtf_err = -E2BIG;				\
+			break;						\
+		}							\
+		__builtin_memcpy(__mtf_dst, src, __mtf_copy_bytes);	\
+		/* Wipe any now-unused trailing elements in @dst: */	\
+		__builtin_memset(__mtf_dst + __mtf_dst_bytes, 0,	\
+				 __mtf_dst_bytes - __mtf_copy_bytes);	\
+		/* Make sure in-struct count of elements is updated: */	\
+		__mtf_ptr->count_member = __mtf_src_count;		\
+		__mtf_err = 0;						\
+	} while (0);							\
+	__mtf_err;							\
+}))
+
+#define mem_to_flex(ptr, src, elements_count)				\
+	__mem_to_flex(ptr, __flex_array_elements,			\
+		      __flex_array_elements_count, src, elements_count)
+
+/** __mem_to_flex_dup - Allocate a flexible array structure and copy into
+ *			its flexible array elements from a memory buffer.
+ *
+ * @alloc: Pointer to pointer to hold allocation for flexible array struct.
+ * @dot_fas_member: For encapsulating flexible array structs, the name of
+ *		    the flexible array struct member preceded with a
+ *		    literal dot (e.g. .foo.bar.flex_array_struct_name).
+ *		    For a regular flexible array struct, this macro arument
+ *		    is empty.
+ * @src: Source memory buffer pointer.
+ * @elements_count: Number of @alloc's flexible array elements to copy from
+ *		    @src into @ptr.
+ * @gfp: GFP allocation flags
+ *
+ * This behaves like mem_to_flex(), but allocates the needed space for
+ * a new flexible array struct and its trailing elements.
+ *
+ * This is essentially a simple allocating deserializer.
+ *
+ * TODO: It would be nice to automatically discover the max bounds of @src
+ *	 besides @elements_count. There is currently no universal way to ask
+ *	 "what is the size of a given pointer's allocation?" So for now just
+ *	 use __builtin_object_size(@src, 1) to validate known compile-time
+ *	 too-large conditions. Perhaps in the future if __mtfd_copy_bytes
+ *	 above is > PAGE_SIZE, perform a dynamic lookup using something
+ *	 similar to __check_heap_object().
+ *
+ * Failure conditions:
+ * - @alloc is NULL.
+ * - *@alloc is not NULL (something was already allocated).
+ * - The value of @elements_count cannot fit in the @alloc's
+ *   __flex_array_elements_count member type (e.g. 260 in u8).
+ * - @elements_count yields a byte count greater than:
+ *   - INT_MAX (as a simple "too big" sanity check)
+ *   - the compile-time size of @src (when it can be determined)
+ * - @alloc could not be allocated.
+ *
+ * Returns: 0 on success, -ve on error.
+ */
+#define __mem_to_flex_dup(alloc, dot_fas_member, src, elements_count,	\
+			  gfp)						\
+__must_check_errno(({							\
+	int __mtfd_err = -EINVAL;					\
+	typeof(elements_count) __mtfd_src_count = (elements_count);	\
+	typeof(**(alloc)) *__mtfd_alloc;				\
+	typeof((*__mtfd_alloc)dot_fas_member) *__mtfd_fas;		\
+	u8 *__mtfd_dst;							\
+	size_t __mtfd_alloc_bytes, __mtfd_copy_bytes;			\
+									\
+	do {								\
+		if ((uintptr_t)(alloc) < 1 || *(alloc)) {		\
+			__mtfd_err = -EINVAL;				\
+			break;						\
+		}							\
+		if (is_negative(__mtfd_src_count) ||			\
+		    __fas_elements_bytes(__mtfd_fas,			\
+					 __flex_array_elements,		\
+					 __flex_array_elements_count,	\
+					 __mtfd_src_count,		\
+					 &__mtfd_copy_bytes) ||		\
+		    __mtfd_copy_bytes > INT_MAX ||			\
+		    __mtfd_copy_bytes > __builtin_object_size(src, 1) ||\
+		    check_add_overflow(sizeof(*__mtfd_alloc),		\
+				       __mtfd_copy_bytes,		\
+				       &__mtfd_alloc_bytes)) {		\
+			__mtfd_err = -E2BIG;				\
+			break;						\
+		}							\
+		__mtfd_alloc = kmalloc(__mtfd_alloc_bytes, gfp);	\
+		if (!__mtfd_alloc) {					\
+			__mtfd_err = -ENOMEM;				\
+			break;						\
+		}							\
+		__mtfd_fas = &((*__mtfd_alloc)dot_fas_member);		\
+		__mtfd_dst = (u8 *)__mtfd_fas->__flex_array_elements;	\
+		__builtin_memset(__mtfd_alloc, 0, __mtfd_alloc_bytes -	\
+						  __mtfd_copy_bytes);	\
+		__builtin_memcpy(__mtfd_dst, src, __mtfd_copy_bytes);	\
+		/* Make sure in-struct count of elements is updated: */	\
+		__mtfd_fas->__flex_array_elements_count =		\
+						    __mtfd_src_count;	\
+		*(alloc) = __mtfd_alloc;				\
+		__mtfd_err = 0;						\
+	} while (0);							\
+	__mtfd_err;							\
+}))
+
+/** mem_to_flex_dup - Allocate a flexible array structure and copy
+ *			into it from a memory buffer.
+ *
+ * @alloc: Pointer to pointer to hold allocation for flexible array struct.
+ * @src: Source memory pointer.
+ * @elements_count: Number of @alloc's flexible array elements to copy from
+ *		   @src into @alloc.
+ * @gfp: GFP allocation flags
+ *
+ * This behaves like mem_to_flex(), but allocates the needed space for
+ * a new flexible array struct and its trailing elements.
+ *
+ * This is essentially a simple allocating deserializer.
+ *
+ * TODO: It would be nice to automatically discover the max bounds of @src
+ *	 besides @elements_count. There is currently no universal way to ask
+ *	 "what is the size of a given pointer's allocation?" So for
+ *	 now just use __builtin_object_size(@src, 1) to validate known
+ *	 compile-time too-large conditions. Perhaps in the future if
+ *	 __mtf_copy_bytes above is > PAGE_SIZE, perform a dynamic lookup
+ *	 using something similar to __check_heap_object().
+ *
+ * Failure conditions:
+ * - @alloc is NULL.
+ * - *@alloc is not NULL (something was already allocated).
+ * - The value of @elements_count cannot fit in the @alloc's
+ *   __flex_array_elements_count member type (e.g. 260 in u8).
+ * - @elements_count yields a byte count greater than:
+ *   - INT_MAX (as a simple "too big" sanity check)
+ *   - the compile-time size of @src (when it can be determined)
+ * - @alloc could not be allocated.
+ *
+ * Returns: 0 on success, -ve on error.
+ */
+#define mem_to_flex_dup(alloc, src, elements_count, gfp)		\
+	__mem_to_flex_dup(alloc, /* alloc itself */, src, elements_count, gfp)
+
+/** flex_to_mem - Copy all flexible array structure elements into memory
+ *		  buffer.
+ *
+ * @dst: Destination buffer pointer.
+ * @bytes_available: How many bytes are available in @dst.
+ * @ptr: Pointer to allocated flexible array struct.
+ * @bytes_written: Pointer to variable to store how many bytes were written
+ *		   (may be NULL).
+ *
+ * Copies all of @ptr's flexible array elements into @dst.
+ *
+ * This is essentially a simple serializer.
+ *
+ * Failure conditions:
+ * - @bytes_available in @dst is any of:
+ *   - negative.
+ *   - larger than INT_MAX.
+ *   - not large enough to hold the resulting copy.
+ * - @bytes_written's type cannot hold the size of the copy (e.g. 260 in u8).
+ *
+ * Return: 0 on success, -ve on failure.
+ *
+ */
+#define flex_to_mem(dst, bytes_available, ptr, bytes_written)		\
+__must_check_errno(({							\
+	int __ftm_err = -EINVAL;					\
+	typeof(*(ptr)) *__ftm_ptr = (ptr);				\
+	u8 *__ftm_src = (u8 *)__ftm_ptr->__flex_array_elements;		\
+	typeof(*(bytes_written)) *__ftm_written = (bytes_written);	\
+	size_t __ftm_written_max = type_max(typeof(*__ftm_written));	\
+	typeof(bytes_available) __ftm_dst_bytes = (bytes_available);	\
+	size_t __ftm_copy_bytes;					\
+									\
+	do {								\
+		if (is_negative(__ftm_dst_bytes) ||			\
+		    __ftm_dst_bytes > INT_MAX ||			\
+		    fas_elements_bytes(__ftm_ptr, &__ftm_copy_bytes) ||	\
+		    __ftm_dst_bytes < __ftm_copy_bytes ||		\
+		    (!__same_type(typeof(bytes_written), NULL) &&	\
+		     __ftm_copy_bytes > __ftm_written_max)) {		\
+			__ftm_err = -E2BIG;				\
+			break;						\
+		}							\
+		__builtin_memcpy(dst, __ftm_src, __ftm_copy_bytes);	\
+		if (__ftm_written)					\
+			*__ftm_written = __ftm_copy_bytes;		\
+		__ftm_err = 0;						\
+	} while (0);							\
+	__ftm_err;							\
+}))
+
+/** flex_to_mem_dup - Copy entire flexible array structure into newly
+ *		      allocated memory buffer.
+ *
+ * @alloc: Pointer to pointer to newly allocated memory region to hold contents
+ *	   of the copy.
+ * @alloc_size: Pointer to variable to hold the size of the allocated memory.
+ * @ptr: Pointer to allocated flexible array struct.
+ * @gfp: GFP allocation flags
+ *
+ * Allocates @alloc and copies all of @ptr's flexible array elements.
+ *
+ * This is essentially a simple allocating serializer.
+ *
+ * Failure conditions:
+ * - @alloc is NULL.
+ * - *@alloc is not NULL (something was already allocated).
+ * - @alloc_size is NULL.
+ * - @alloc_size's type cannot hold the size of the copy (e.g. 260 in u8).
+ * - @alloc could not be allocated.
+ *
+ * Return: 0 on success, -ve on failure.
+ */
+#define flex_to_mem_dup(alloc, alloc_size, ptr, gfp)			\
+__must_check_errno(({							\
+	int __ftmd_err = -EINVAL;					\
+	typeof(**(alloc)) *__ftmd_alloc;				\
+	typeof(*(alloc_size)) *__ftmd_alloc_size = (alloc_size);	\
+	typeof(*(ptr)) *__ftmd_ptr = (ptr);				\
+	u8 *__ftmd_src = (u8 *)__ftmd_ptr->__flex_array_elements;	\
+	size_t __ftmd_alloc_max = type_max(typeof(*__ftmd_alloc_size));	\
+	size_t __ftmd_copy_bytes;					\
+									\
+	do {								\
+		if ((uintptr_t)(alloc) < 1 || *(alloc) ||		\
+		    (uintptr_t)(alloc_size) < 1) {			\
+			__ftmd_err = -EINVAL;				\
+			break;						\
+		}							\
+		if (fas_elements_bytes(__ftmd_ptr,			\
+				       &__ftmd_copy_bytes) ||		\
+		    __ftmd_copy_bytes > __ftmd_alloc_max) {		\
+			__ftmd_err = -E2BIG;				\
+			break;						\
+		}							\
+		__ftmd_alloc = kmemdup(__ftmd_src, __ftmd_copy_bytes,	\
+				       gfp);				\
+		if (!__ftmd_alloc) {					\
+			__ftmd_err = -ENOMEM;				\
+			break;						\
+		}							\
+		*__ftmd_alloc_size = __ftmd_copy_bytes;			\
+		*(alloc) = __ftmd_alloc;				\
+		__ftmd_err = 0;						\
+	} while (0);							\
+	__ftmd_err;							\
+}))
+
+#endif /* _LINUX_FLEX_ARRAY_H_ */
diff --git a/include/linux/string.h b/include/linux/string.h
index b6572aeca2f5..c01b76f73e99 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -252,6 +252,7 @@ static inline const char *kbasename(const char *path)
 #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) && defined(CONFIG_FORTIFY_SOURCE)
 #include <linux/fortify-string.h>
 #endif
+#include <linux/flex_array.h>
 
 void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
 		    int pad);
diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index 7837ba4fe728..04870274f33b 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -44,4 +44,18 @@
 		struct { } __empty_ ## NAME; \
 		TYPE NAME[]; \
 	}
+
+/* For use with flexible array structure helpers, in <linux/flex_array.h> */
+#define __DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(TYPE, NAME)			\
+	union {								\
+		TYPE __flex_array_elements_count;			\
+		TYPE NAME;						\
+	}
+
+#define __DECLARE_FLEX_ARRAY_ELEMENTS(TYPE, NAME)			\
+	union {								\
+		__DECLARE_FLEX_ARRAY(TYPE, __flex_array_elements);	\
+		__DECLARE_FLEX_ARRAY(TYPE, NAME);			\
+	}
+
 #endif
-- 
2.32.0

