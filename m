Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB42751946F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343825AbiEDByT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245525AbiEDBv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:51:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E93191A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so21804pjm.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=50F1hUbWFLfT5ENWUNJYEA3u7uQsl+qxaqqCeMwZnyU=;
        b=XJCNLp6T2hlq16vnGlmWmig5+GsVMxNRRvIbEOnN6HSW8yTRmnmgFn0bdfSDK1+nc+
         /lIeg89b2qTVpmYFiDm9nYt9X28PYd7TpfNNYgxckwT1LfN0EOUF0w4hbizFZn5WO8zm
         t78WDusU+YL8An+v944Dg9g9tejsxP74BYxPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=50F1hUbWFLfT5ENWUNJYEA3u7uQsl+qxaqqCeMwZnyU=;
        b=UMTse2J0H8Vsn5iMpHMHwIBJHbg786+wUGXZzrgVJ7qprmuT8QTSzKFTajlmytB+k8
         LxcvHU4ys4PYsfzIskpbNd8EJ0a9I+eA+24RLiKYcuM2Fv8v1XH+LAhpKXtDu6XeNGhq
         7tTUNmCz31CKGlLVjQjtwyJE7rYLZ7/O6nK8kjzyzpRhOltRFboEqKROwaGDBrcNKIx+
         hf6ZJpV+DEd2sGSrpZD1Q3jOMNv+auKZ26sIlEdtWXL/p6fZzn+l5vv3MRDsk56YISKD
         3+hTKtCnX1CUSTMFPbLwd6InDp30Z1s5EZ0/jwfNdqZhiIrRSLe43pRFswY6Q6nGaw3q
         fiIw==
X-Gm-Message-State: AOAM530j0OeY8yP0DcKL8iuGeiDroTmUsqdTvHtBesL8k0NmWhegEKNX
        m2VuWiNfqkfp6+Rxkf+JoAggkA==
X-Google-Smtp-Source: ABdhPJxaAI7hynD/Cs/9AHq7+rYd59XaObWpZBbgj2SNSYvwiT7TD7KGMP2kmwMed/Mr6SCnHAdnjA==
X-Received: by 2002:a17:902:a707:b0:15b:6ea2:8ea2 with SMTP id w7-20020a170902a70700b0015b6ea28ea2mr19124120plq.134.1651628857306;
        Tue, 03 May 2022 18:47:37 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o18-20020a170903301200b0015e8d4eb2ddsm6904392pla.295.2022.05.03.18.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:35 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, David Gow <davidgow@google.com>,
        kunit-dev@googlegroups.com, Alexei Starovoitov <ast@kernel.org>,
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
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
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
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
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
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
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
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 03/32] flex_array: Add Kunit tests
Date:   Tue,  3 May 2022 18:44:12 -0700
Message-Id: <20220504014440.3697851-4-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19765; h=from:subject; bh=GG9nmr532r4pl7tVh2IFzW2uuFJ/hvJpUQj5i4N5B0I=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqB7/551GkKwZcI+OcZghRu66mEP7FMOhfFmE5a 67h/Z0iJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagQAKCRCJcvTf3G3AJtfAEA CqSqFekHoLTEwm5Qyt0UbimHFpi/b/6zyOUB2KND396l+syWQ1mJIbLGjTios1NH/eIxHjGEKJ1syg U7L/zPIs4XJhvSt5mtK7HHfsD2jlgvLX3UL7IgUlEzTG1onpa1dDWN1UtoN81ahy1fct7CMGoD/1ll 3ngnIysZAbkbazroo7sUYB/JX8DX8bsjNn97JBfq+F0NovBSkT6UKeW29aHUk5FoZhWo+bijLKKQBA JrEW47fYiaZ04M3TcLGaKkKLllkiajq0N/9TLMbmHrUZphVEZCSiD9eikb/Kpr28WXz4NX00Fu4CGe kq7UO4JP9HeF1pCMUg3iVoEHddmrfhdENHsLrAQzNrTdnkG+Jt7b+DxWscqIxexQR8D0GFXA1TavBy c52biYoOXViqwEmvm12u6MNQYxMVN2/v5fbzbwkcdy4DlhOuLC0Wu4AmEcPHG6wFuSX5NdbPBBeIzQ 911ljxSY+UGfg0USsjIzhH6oqejgpYUmqqLAV0WoW7O8aSmtqBCOORogwfI680pWARJhsTuTVbZ5G4 KsZcDi9opJFLcoYlb9wuFYeQrydBbShjiVXqT/tU0kK4PWWlEc85sOiKq7Bd8cuiixIgJW5Zlc+4n+ 1sgKfTbiJo/zVmyCeEmrKxLCEoinmDvnxEdOeXRWpeTslL+4jMSgSaBMHUCw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for the new flexible array structure helpers. These can be run
with:

  make ARCH=um mrproper
  ./tools/testing/kunit/kunit.py config
  ./tools/testing/kunit/kunit.py run flex_array

Cc: David Gow <davidgow@google.com>
Cc: kunit-dev@googlegroups.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug      |  12 +-
 lib/Makefile           |   1 +
 lib/flex_array_kunit.c | 523 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 531 insertions(+), 5 deletions(-)
 create mode 100644 lib/flex_array_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9077bb38bc93..8bae6b169c50 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2551,11 +2551,6 @@ config OVERFLOW_KUNIT_TEST
 	  Builds unit tests for the check_*_overflow(), size_*(), allocation, and
 	  related functions.
 
-	  For more information on KUnit and unit tests in general please refer
-	  to the KUnit documentation in Documentation/dev-tools/kunit/.
-
-	  If unsure, say N.
-
 config STACKINIT_KUNIT_TEST
 	tristate "Test level of stack variable initialization" if !KUNIT_ALL_TESTS
 	depends on KUNIT
@@ -2567,6 +2562,13 @@ config STACKINIT_KUNIT_TEST
 	  CONFIG_GCC_PLUGIN_STRUCTLEAK, CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF,
 	  or CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL.
 
+config FLEX_ARRAY_KUNIT_TEST
+	tristate "Test flex_*() family of helper functions at runtime" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds unit tests for flexible array copy helper functions.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index 6b9ffc1bd1ee..9884318db330 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -366,6 +366,7 @@ obj-$(CONFIG_MEMCPY_KUNIT_TEST) += memcpy_kunit.o
 obj-$(CONFIG_OVERFLOW_KUNIT_TEST) += overflow_kunit.o
 CFLAGS_stackinit_kunit.o += $(call cc-disable-warning, switch-unreachable)
 obj-$(CONFIG_STACKINIT_KUNIT_TEST) += stackinit_kunit.o
+obj-$(CONFIG_FLEX_ARRAY_KUNIT_TEST) += flex_array_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
 
diff --git a/lib/flex_array_kunit.c b/lib/flex_array_kunit.c
new file mode 100644
index 000000000000..48bee88945b4
--- /dev/null
+++ b/lib/flex_array_kunit.c
@@ -0,0 +1,523 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test cases for flex_*() array manipulation helpers.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <kunit/test.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/flex_array.h>
+
+#define COMPARE_STRUCTS(STRUCT_A, STRUCT_B)	do {			\
+	STRUCT_A *ptr_A;						\
+	STRUCT_B *ptr_B;						\
+	int rc;								\
+	size_t size_A, size_B;						\
+									\
+	/* matching types for flex array elements and count */		\
+	KUNIT_EXPECT_EQ(test, sizeof(*ptr_A), sizeof(*ptr_B));		\
+	KUNIT_EXPECT_TRUE(test, __same_type(*ptr_A->data,		\
+		*ptr_B->__flex_array_elements));			\
+	KUNIT_EXPECT_TRUE(test, __same_type(ptr_A->datalen,		\
+		ptr_B->__flex_array_elements_count));			\
+	KUNIT_EXPECT_EQ(test, sizeof(*ptr_A->data),			\
+			      sizeof(*ptr_B->__flex_array_elements));	\
+	KUNIT_EXPECT_EQ(test, offsetof(typeof(*ptr_A), data),		\
+			      offsetof(typeof(*ptr_B),			\
+				       __flex_array_elements));		\
+	KUNIT_EXPECT_EQ(test, offsetof(typeof(*ptr_A), datalen),	\
+			      offsetof(typeof(*ptr_B),			\
+				       __flex_array_elements_count));	\
+									\
+	/* struct_size() vs __fas_bytes() */				\
+	size_A = struct_size(ptr_A, data, 13);				\
+	rc = __fas_bytes(ptr_B, __flex_array_elements,			\
+			 __flex_array_elements_count, 13, &size_B);	\
+	KUNIT_EXPECT_EQ(test, rc, 0);					\
+	KUNIT_EXPECT_EQ(test, size_A, size_B);				\
+									\
+	/* flex_array_size() vs __fas_elements_bytes() */		\
+	size_A = flex_array_size(ptr_A, data, 13);			\
+	rc = __fas_elements_bytes(ptr_B, __flex_array_elements,		\
+			 __flex_array_elements_count, 13, &size_B);	\
+	KUNIT_EXPECT_EQ(test, rc, 0);					\
+	KUNIT_EXPECT_EQ(test, size_A, size_B);				\
+									\
+	KUNIT_EXPECT_EQ(test, sizeof(*ptr_A) + size_A,			\
+			      offsetof(typeof(*ptr_A), data) +		\
+			      (sizeof(*ptr_A->data) * 13));		\
+	KUNIT_EXPECT_EQ(test, sizeof(*ptr_B) + size_B,			\
+			      offsetof(typeof(*ptr_B),			\
+				       __flex_array_elements) +		\
+			      (sizeof(*ptr_B->__flex_array_elements) *	\
+			       13));					\
+} while (0)
+
+struct normal {
+	size_t	datalen;
+	u32	data[];
+};
+
+struct decl_normal {
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(size_t, datalen);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u32, data);
+};
+
+struct aligned {
+	unsigned short	datalen;
+	char		data[] __aligned(__alignof__(u64));
+};
+
+struct decl_aligned {
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(unsigned short, datalen);
+	DECLARE_FLEX_ARRAY_ELEMENTS(char, data) __aligned(__alignof__(u64));
+};
+
+static void struct_test(struct kunit *test)
+{
+	COMPARE_STRUCTS(struct normal, struct decl_normal);
+	COMPARE_STRUCTS(struct aligned, struct decl_aligned);
+}
+
+/* Flexible array structure with internal padding. */
+struct flex_cpy_obj {
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u8, count);
+	unsigned long empty;
+	char induce_padding;
+	/* padding ends up here */
+	unsigned long after_padding;
+	DECLARE_FLEX_ARRAY_ELEMENTS(u32, flex);
+};
+
+/* Encapsulating flexible array structure. */
+struct flex_dup_obj {
+	unsigned long flags;
+	int junk;
+	struct flex_cpy_obj fas;
+};
+
+/* Flexible array struct of only bytes. */
+struct tiny_flex {
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u8, count);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, byte_array);
+};
+
+#define CHECK_COPY(ptr)		do {						\
+	typeof(*(ptr)) *_cc_dst = (ptr);					\
+	KUNIT_EXPECT_EQ(test, _cc_dst->induce_padding, 0);			\
+	memcpy(&padding, &_cc_dst->induce_padding + sizeof(_cc_dst->induce_padding), \
+	       sizeof(padding));						\
+	/* Padding should be zero too. */					\
+	KUNIT_EXPECT_EQ(test, padding, 0);					\
+	KUNIT_EXPECT_EQ(test, src->count, _cc_dst->count);			\
+	KUNIT_EXPECT_EQ(test, _cc_dst->count, TEST_TARGET);			\
+	for (i = 0; i < _cc_dst->count - 1; i++) {				\
+		/* 'A' is 0x41, and here repeated in a u32. */			\
+		KUNIT_EXPECT_EQ(test, _cc_dst->flex[i], 0x41414141);		\
+	}									\
+	/* Last item should be different. */					\
+	KUNIT_EXPECT_EQ(test, _cc_dst->flex[_cc_dst->count - 1], 0x14141414);	\
+} while (0)
+
+/* Test copying from one flexible array struct into another. */
+static void flex_cpy_test(struct kunit *test)
+{
+#define TEST_BOUNDS	13
+#define TEST_TARGET	12
+#define TEST_SMALL	10
+	struct flex_cpy_obj *src, *dst;
+	unsigned long padding;
+	int i, rc;
+
+	/* Prepare open-coded source. */
+	src = kzalloc(struct_size(src, flex, TEST_BOUNDS), GFP_KERNEL);
+	src->count = TEST_BOUNDS;
+	memset(src->flex, 'A', flex_array_size(src, flex, TEST_BOUNDS));
+	src->flex[src->count - 2] = 0x14141414;
+	src->flex[src->count - 1] = 0x24242424;
+
+	/* Prepare open-coded destination, alloc only. */
+	dst = kzalloc(struct_size(src, flex, TEST_BOUNDS), GFP_KERNEL);
+	/* Pre-fill with 0xFE marker. */
+	memset(dst, 0xFE, struct_size(src, flex, TEST_BOUNDS));
+	/* Pretend we're 1 element smaller. */
+	dst->count = TEST_TARGET;
+
+	/* Pretend to match the target destination size. */
+	src->count = TEST_TARGET;
+
+	rc = flex_cpy(dst, src);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	CHECK_COPY(dst);
+	/* Item past last copied item is unchanged from initial memset. */
+	KUNIT_EXPECT_EQ(test, dst->flex[dst->count], 0xFEFEFEFE);
+
+	/* Now trip overflow, and verify we didn't clobber beyond end. */
+	src->count = TEST_BOUNDS;
+	rc = flex_cpy(dst, src);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Item past last copied item is unchanged from initial memset. */
+	KUNIT_EXPECT_EQ(test, dst->flex[dst->count], 0xFEFEFEFE);
+
+	/* Reset destination contents. */
+	memset(dst, 0xFD, struct_size(src, flex, TEST_BOUNDS));
+	dst->count = TEST_TARGET;
+
+	/* Copy less than max. */
+	src->count = TEST_SMALL;
+	rc = flex_cpy(dst, src);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	/* Verify count was adjusted. */
+	KUNIT_EXPECT_EQ(test, dst->count, TEST_SMALL);
+	/* Verify element beyond src size was wiped. */
+	KUNIT_EXPECT_EQ(test, dst->flex[TEST_SMALL], 0);
+	/* Verify element beyond original dst size was untouched. */
+	KUNIT_EXPECT_EQ(test, dst->flex[TEST_TARGET], 0xFDFDFDFD);
+
+	kfree(dst);
+	kfree(src);
+#undef TEST_BOUNDS
+#undef TEST_TARGET
+#undef TEST_SMALL
+}
+
+static void flex_dup_test(struct kunit *test)
+{
+#define TEST_TARGET	12
+	struct flex_cpy_obj *src, *dst = NULL, **null = NULL;
+	struct flex_dup_obj *encap = NULL;
+	unsigned long padding;
+	int i, rc;
+
+	/* Prepare open-coded source. */
+	src = kzalloc(struct_size(src, flex, TEST_TARGET), GFP_KERNEL);
+	src->count = TEST_TARGET;
+	memset(src->flex, 'A', flex_array_size(src, flex, TEST_TARGET));
+	src->flex[src->count - 1] = 0x14141414;
+
+	/* Reject NULL @alloc. */
+	rc = flex_dup(null, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+
+	/* Check good copy. */
+	rc = flex_dup(&dst, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_ASSERT_TRUE(test, dst != NULL);
+	CHECK_COPY(dst);
+
+	/* Reject non-NULL *@alloc. */
+	rc = flex_dup(&dst, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+
+	kfree(dst);
+
+	/* Check good encap copy. */
+	rc = __flex_dup(&encap, .fas, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_ASSERT_TRUE(test, dst != NULL);
+	CHECK_COPY(&encap->fas);
+	/* Check that items external to "fas" are zero. */
+	KUNIT_EXPECT_EQ(test, encap->flags, 0);
+	KUNIT_EXPECT_EQ(test, encap->junk, 0);
+	kfree(encap);
+#undef MAGIC_WORD
+#undef TEST_TARGET
+}
+
+static void mem_to_flex_test(struct kunit *test)
+{
+#define TEST_TARGET	9
+#define TEST_MAX	U8_MAX
+#define MAGIC_WORD	0x03030303
+	u8 magic_byte = MAGIC_WORD & 0xff;
+	struct flex_cpy_obj *dst;
+	size_t big = (size_t)INT_MAX + 1;
+	char small[] = "Hello";
+	char *src;
+	u32 src_len;
+	int rc;
+
+	/* Open coded allocations, 1 larger than actually used. */
+	src_len = flex_array_size(dst, flex, TEST_MAX + 1);
+	src = kzalloc(src_len, GFP_KERNEL);
+	dst = kzalloc(struct_size(dst, flex, TEST_MAX + 1), GFP_KERNEL);
+	dst->count = TEST_TARGET;
+
+	/* Fill source. */
+	memset(src, magic_byte, src_len);
+
+	/* Short copy is fine. */
+	KUNIT_EXPECT_EQ(test, dst->flex[0], 0);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+	rc = mem_to_flex(dst, src, 1);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_EXPECT_EQ(test, dst->count, 1);
+	KUNIT_EXPECT_EQ(test, dst->after_padding, 0);
+	KUNIT_EXPECT_EQ(test, dst->flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+	dst->count = TEST_TARGET;
+
+	/* Reject negative elements count. */
+	rc = mem_to_flex(dst, small, -1);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure dst is unchanged. */
+	KUNIT_EXPECT_EQ(test, dst->flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+
+	/* Reject compile-time read overflow. */
+	rc = mem_to_flex(dst, small, 20);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure dst is unchanged. */
+	KUNIT_EXPECT_EQ(test, dst->flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+
+	/* Reject giant buffer source. */
+	rc = mem_to_flex(dst, small, big);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure dst is unchanged. */
+	KUNIT_EXPECT_EQ(test, dst->flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+
+	/* Copy beyond storage size is rejected. */
+	dst->count = TEST_MAX;
+	KUNIT_EXPECT_EQ(test, dst->flex[TEST_MAX - 1], 0);
+	KUNIT_EXPECT_EQ(test, dst->flex[TEST_MAX], 0);
+	rc = mem_to_flex(dst, src, TEST_MAX + 1);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure dst is unchanged. */
+	KUNIT_EXPECT_EQ(test, dst->flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, dst->flex[1], 0);
+
+	kfree(dst);
+	kfree(src);
+#undef MAGIC_WORD
+#undef TEST_MAX
+#undef TEST_TARGET
+}
+
+static void mem_to_flex_dup_test(struct kunit *test)
+{
+#define ELEMENTS_COUNT	259
+#define MAGIC_WORD	0xABABABAB
+	u8 magic_byte = MAGIC_WORD & 0xff;
+	struct flex_dup_obj *obj = NULL;
+	struct tiny_flex *tiny = NULL, **null = NULL;
+	size_t src_len, count, big = (size_t)INT_MAX + 1;
+	char small[] = "Hello";
+	u8 *src;
+	int rc;
+
+	src_len = struct_size(tiny, byte_array, ELEMENTS_COUNT);
+	src = kzalloc(src_len, GFP_KERNEL);
+	KUNIT_ASSERT_TRUE(test, src != NULL);
+	/* Fill with bytes. */
+	memset(src, magic_byte, src_len);
+	KUNIT_EXPECT_EQ(test, src[0], magic_byte);
+	KUNIT_EXPECT_EQ(test, src[src_len / 2], magic_byte);
+	KUNIT_EXPECT_EQ(test, src[src_len - 1], magic_byte);
+
+	/* Reject storage exceeding elements_count type. */
+	count = ELEMENTS_COUNT;
+	rc = mem_to_flex_dup(&tiny, src, count, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	KUNIT_EXPECT_TRUE(test, tiny == NULL);
+
+	/* Reject negative elements count. */
+	rc = mem_to_flex_dup(&tiny, src, -1, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	KUNIT_EXPECT_TRUE(test, tiny == NULL);
+
+	/* Reject compile-time read overflow. */
+	rc = mem_to_flex_dup(&tiny, small, 20, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	KUNIT_EXPECT_TRUE(test, tiny == NULL);
+
+	/* Reject giant buffer source. */
+	rc = mem_to_flex_dup(&tiny, small, big, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	KUNIT_EXPECT_TRUE(test, tiny == NULL);
+
+	/* Reject NULL @alloc. */
+	rc = mem_to_flex_dup(null, src, count, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+
+	/* Allow reasonable count.*/
+	count = ELEMENTS_COUNT / 2;
+	rc = mem_to_flex_dup(&tiny, src, count, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_ASSERT_TRUE(test, tiny != NULL);
+	/* Spot check the copy happened. */
+	KUNIT_EXPECT_EQ(test, tiny->count, count);
+	KUNIT_EXPECT_EQ(test, tiny->byte_array[0], magic_byte);
+	KUNIT_EXPECT_EQ(test, tiny->byte_array[count / 2], magic_byte);
+	KUNIT_EXPECT_EQ(test, tiny->byte_array[count - 1], magic_byte);
+
+	/* Reject non-NULL *@alloc. */
+	rc = mem_to_flex_dup(&tiny, src, count, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+	kfree(tiny);
+
+	/* Works with encapsulation too. */
+	count = ELEMENTS_COUNT / 10;
+	rc = __mem_to_flex_dup(&obj, .fas, src, count, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_ASSERT_TRUE(test, obj != NULL);
+	/* Spot check the copy happened. */
+	KUNIT_EXPECT_EQ(test, obj->fas.count, count);
+	KUNIT_EXPECT_EQ(test, obj->fas.after_padding, 0);
+	KUNIT_EXPECT_EQ(test, obj->fas.flex[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, obj->fas.flex[count / 2], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, obj->fas.flex[count - 1], MAGIC_WORD);
+	/* Check members before flexible array struct are zero. */
+	KUNIT_EXPECT_EQ(test, obj->flags, 0);
+	KUNIT_EXPECT_EQ(test, obj->junk, 0);
+	kfree(obj);
+#undef MAGIC_WORD
+#undef ELEMENTS_COUNT
+}
+
+static void flex_to_mem_test(struct kunit *test)
+{
+#define ELEMENTS_COUNT	200
+#define MAGIC_WORD	0xF1F2F3F4
+	struct flex_cpy_obj *src;
+	typeof(*src->flex) *cast;
+	size_t src_len = struct_size(src, flex, ELEMENTS_COUNT);
+	size_t copy_len = flex_array_size(src, flex, ELEMENTS_COUNT);
+	int i, rc;
+	size_t bytes = 0;
+	u8 too_small;
+	u8 *dst;
+
+	/* Create a filled flexible array struct. */
+	src = kzalloc(src_len, GFP_KERNEL);
+	KUNIT_ASSERT_TRUE(test, src != NULL);
+	src->count = ELEMENTS_COUNT;
+	src->after_padding = 13;
+	for (i = 0; i < ELEMENTS_COUNT; i++)
+		src->flex[i] = MAGIC_WORD;
+
+	/* Over-allocate space to do past-src_len checking. */
+	dst = kzalloc(src_len * 2, GFP_KERNEL);
+	KUNIT_ASSERT_TRUE(test, dst != NULL);
+	cast = (void *)dst;
+
+	/* Fail if dst is too small. */
+	rc = flex_to_mem(dst, copy_len - 1, src, &bytes);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure nothing was copied. */
+	KUNIT_EXPECT_EQ(test, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cast[0], 0);
+
+	/* Fail if type too small to hold size of copy. */
+	KUNIT_EXPECT_GT(test, copy_len, type_max(typeof(too_small)));
+	rc = flex_to_mem(dst, copy_len, src, &too_small);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	/* Make sure nothing was copied. */
+	KUNIT_EXPECT_EQ(test, bytes, 0);
+	KUNIT_EXPECT_EQ(test, cast[0], 0);
+
+	/* Check good copy. */
+	rc = flex_to_mem(dst, copy_len, src, &bytes);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_EXPECT_EQ(test, bytes, copy_len);
+	/* Spot check the copy */
+	KUNIT_EXPECT_EQ(test, cast[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, cast[ELEMENTS_COUNT / 2], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, cast[ELEMENTS_COUNT - 1], MAGIC_WORD);
+	/* Make sure nothing was written after last element. */
+	KUNIT_EXPECT_EQ(test, cast[ELEMENTS_COUNT], 0);
+
+	kfree(dst);
+	kfree(src);
+#undef MAGIC_WORD
+#undef ELEMENTS_COUNT
+}
+
+static void flex_to_mem_dup_test(struct kunit *test)
+{
+#define ELEMENTS_COUNT	210
+#define MAGIC_WORD	0xF0F1F2F3
+	struct flex_dup_obj *obj, **null = NULL;
+	struct flex_cpy_obj *src;
+	typeof(*src->flex) *cast;
+	size_t obj_len = struct_size(obj, fas.flex, ELEMENTS_COUNT);
+	size_t src_len = struct_size(src, flex, ELEMENTS_COUNT);
+	size_t copy_len = flex_array_size(src, flex, ELEMENTS_COUNT);
+	int i, rc;
+	size_t bytes = 0;
+	u8 too_small = 0;
+	u8 *dst = NULL;
+
+	/* Create a filled flexible array struct. */
+	obj = kzalloc(obj_len, GFP_KERNEL);
+	KUNIT_ASSERT_TRUE(test, obj != NULL);
+	obj->fas.count = ELEMENTS_COUNT;
+	obj->fas.after_padding = 13;
+	for (i = 0; i < ELEMENTS_COUNT; i++)
+		obj->fas.flex[i] = MAGIC_WORD;
+	src = &obj->fas;
+
+	/* Fail if type too small to hold size of copy. */
+	KUNIT_EXPECT_GT(test, src_len, type_max(typeof(too_small)));
+	rc = flex_to_mem_dup(&dst, &too_small, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -E2BIG);
+	KUNIT_EXPECT_TRUE(test, dst == NULL);
+	KUNIT_EXPECT_EQ(test, too_small, 0);
+
+	/* Fail if @alloc_size is NULL. */
+	KUNIT_EXPECT_TRUE(test, dst == NULL);
+	rc = flex_to_mem_dup(&dst, dst, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+	KUNIT_EXPECT_TRUE(test, dst == NULL);
+
+	/* Fail if @alloc is NULL. */
+	rc = flex_to_mem_dup(null, &bytes, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+	KUNIT_EXPECT_TRUE(test, dst == NULL);
+	KUNIT_EXPECT_EQ(test, bytes, 0);
+
+	/* Check good copy. */
+	rc = flex_to_mem_dup(&dst, &bytes, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, 0);
+	KUNIT_EXPECT_TRUE(test, dst != NULL);
+	KUNIT_EXPECT_EQ(test, bytes, copy_len);
+	cast = (void *)dst;
+	/* Spot check the copy */
+	KUNIT_EXPECT_EQ(test, cast[0], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, cast[ELEMENTS_COUNT / 2], MAGIC_WORD);
+	KUNIT_EXPECT_EQ(test, cast[ELEMENTS_COUNT - 1], MAGIC_WORD);
+
+	/* Fail if *@alloc is non-NULL. */
+	bytes = 0;
+	rc = flex_to_mem_dup(&dst, &bytes, src, GFP_KERNEL);
+	KUNIT_EXPECT_EQ(test, rc, -EINVAL);
+	KUNIT_EXPECT_EQ(test, bytes, 0);
+
+	kfree(dst);
+	kfree(obj);
+#undef MAGIC_WORD
+#undef ELEMENTS_COUNT
+}
+
+static struct kunit_case flex_array_test_cases[] = {
+	KUNIT_CASE(struct_test),
+	KUNIT_CASE(flex_cpy_test),
+	KUNIT_CASE(flex_dup_test),
+	KUNIT_CASE(mem_to_flex_test),
+	KUNIT_CASE(mem_to_flex_dup_test),
+	KUNIT_CASE(flex_to_mem_test),
+	KUNIT_CASE(flex_to_mem_dup_test),
+	{}
+};
+
+static struct kunit_suite flex_array_test_suite = {
+	.name = "flex_array",
+	.test_cases = flex_array_test_cases,
+};
+
+kunit_test_suite(flex_array_test_suite);
+
+MODULE_LICENSE("GPL");
-- 
2.32.0

