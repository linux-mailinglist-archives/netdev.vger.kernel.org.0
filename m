Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D612A57CC37
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiGUNnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiGUNmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:42:55 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3543820DB;
        Thu, 21 Jul 2022 06:42:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a11so1066472wmq.3;
        Thu, 21 Jul 2022 06:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vPhYS1Y4NQLs+aVbo1COGhb7XJDfsQhzGU7xrCDjf0s=;
        b=By0RV00LCbrDQBOb/vm0E+UyEMwApPj+2q6pJ9Rvd+0yNbZIOuHksNpqCk44rkjo17
         PMNXCVcG0Io2HsdkcjVQO3KzHM6/TI+3BxqmY0LbNkLqst8ZJhsui1SVs98gmEVPIj9W
         i+KoF6slq8ou4WDLCxKjwNzQoy3WAYwZC/E67vHmE+iOJRrQBKYO7SDa10iBg3L6rq1t
         uSNJN7AEWIFPVV+khlDTf8672t/3n1QohpQ5dsT+hS8h0vwSRu9eSqD8ZGSTtVVS5gxA
         Yxcx7KkRKtNuoSZY7AKnsiOjAYC4ubcbJ1PweWE+onARNleM9WVjFvT4fJFsT5orxjVe
         E8mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vPhYS1Y4NQLs+aVbo1COGhb7XJDfsQhzGU7xrCDjf0s=;
        b=XB7FipM+rR7F6lEcqwAaZ9VRAbGnm03VvDTrKIDJ/BA0KrvNTTSKFB6Vy02U9lQ5nm
         KZRgrHeYjEtR36BqVU3F/SElugjQ/ECeA2tQTzgts7+c8653pK59xanLcVJNHLBeAaU5
         fByjwRY03T8U50EeGbnvea5e2InFIKOxJG8qndl2FOmG2MMjyk3p0apdHmQG5mFqeZHi
         VXpda35okmyUWJXbr6Q6VAdU72RKa9M9dajLSjjTC1xKEtrmvNyvx0so+bY2TVTNhpwd
         KYM3Toy2+W5T9lLI7SM80Magg/A3CWfuSGl/K5U57l06bnZHj1gZkLzmk2TfYrr8jmMq
         62Bw==
X-Gm-Message-State: AJIora9zOt4q2RFOr6DGF2VMSk9zuUo0f8JjcfMW7yXO9EO6yFgxXRcT
        UbPFI7GRiMlVVq+ZLjM+0EHpwK5I/3YHgw==
X-Google-Smtp-Source: AGRyM1tqhUp5NOPsLnMSro4NIVI8XPRiPclosUnutn3KlbLW4PZIA1yFZzvNjAStsVzjFOebt+YOnQ==
X-Received: by 2002:a7b:ca47:0:b0:3a3:1874:648 with SMTP id m7-20020a7bca47000000b003a318740648mr8218848wml.139.1658410969575;
        Thu, 21 Jul 2022 06:42:49 -0700 (PDT)
Received: from localhost (212.191.202.62.dynamic.cgnat.res.cust.swisscom.ch. [62.202.191.212])
        by smtp.gmail.com with ESMTPSA id v13-20020a5d4a4d000000b0021dff3cf67asm1986091wrs.10.2022.07.21.06.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:42:49 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v7 01/13] bpf: Introduce 8-byte BTF set
Date:   Thu, 21 Jul 2022 15:42:33 +0200
Message-Id: <20220721134245.2450-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721134245.2450-1-memxor@gmail.com>
References: <20220721134245.2450-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4739; i=memxor@gmail.com; h=from:subject; bh=n9+ZGPpFv9+iLVWoK7KH2F+1PqOhfZirG4WGe59KSoo=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi2VfNbMO+6EE/n6IXfl0Zfn8BhP3ldTm/bqxqboTG zrlO7suJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtlXzQAKCRBM4MiGSL8Ryg7BD/ 4g2vaPFVphd+Az/dyl83SVBqozRibHdFiVOFtQ7MF8jt5gGsexNFGGeozxJL5CubAynxjjTwpUgmwE gnHlFBkB0zQuXRMYpvByTxX6WiZeGZIIRxITwyrrQ+88vImnE7cd9RzN8LyFMcIaFC+su9eRNm+gZp OSJEnfKK77bXvXEOJMSNpgoOErgjUeZkOZLjiVxin8aTicM8fbocI9yGiQBW9bONCECRqm5swyTW/3 hIpgIM/+c6ZmAzeJA0hc8DeSFZaRrvi+4uHDBz2Z5bUoFa7UA1iPNasq+uQ3tle2dAw7/KHsMkP6Ex 8OhY8nuAlM4FsX2fIOd+zjZUdrms8RCbV4wX931+S3m7lY1x2/58FAnup8SLXniiLbF3SKmJitgDG5 9jGlIJ/onio+l6kdkA7SZBi+GukRUbkYuSQOmB5O/0OXG3WOjYZbdewDB8F+Ircqg7i+0aVjVoq1OW I4a+5OiaPrzgYp5irWZLurl+RBFtC1RXhuTsdXgt4OfKlyn0+UPHWox54sA+T992lmCr92DabuYMT9 xS4e7vRLo5BNZSpOI6mJtDuxWZdhsSdOeHEzdH00KwQCvKI8jRqf87NyaQNnaaN3tgYDBWbKgc9zRD xkabezujGYKf2yyYtgbBxAmFwCvsxjjUZL8G3VztWUCdBtHj+1kbBc1Q1+gw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce support for defining flags for kfuncs using a new set of
macros, BTF_SET8_START/BTF_SET8_END, which define a set which contains
8 byte elements (each of which consists of a pair of BTF ID and flags),
using a new BTF_ID_FLAGS macro.

This will be used to tag kfuncs registered for a certain program type
as acquire, release, sleepable, ret_null, etc. without having to create
more and more sets which was proving to be an unscalable solution.

Now, when looking up whether a kfunc is allowed for a certain program,
we can also obtain its kfunc flags in the same call and avoid further
lookups.

The resolve_btfids change is split into a separate patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf_ids.h | 68 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 252a4befeab1..3cb0741e71d7 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -8,6 +8,15 @@ struct btf_id_set {
 	u32 ids[];
 };
 
+struct btf_id_set8 {
+	u32 cnt;
+	u32 flags;
+	struct {
+		u32 id;
+		u32 flags;
+	} pairs[];
+};
+
 #ifdef CONFIG_DEBUG_INFO_BTF
 
 #include <linux/compiler.h> /* for __PASTE */
@@ -25,7 +34,7 @@ struct btf_id_set {
 
 #define BTF_IDS_SECTION ".BTF_ids"
 
-#define ____BTF_ID(symbol)				\
+#define ____BTF_ID(symbol, word)			\
 asm(							\
 ".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
 ".local " #symbol " ;                          \n"	\
@@ -33,10 +42,11 @@ asm(							\
 ".size  " #symbol ", 4;                        \n"	\
 #symbol ":                                     \n"	\
 ".zero 4                                       \n"	\
+word							\
 ".popsection;                                  \n");
 
-#define __BTF_ID(symbol) \
-	____BTF_ID(symbol)
+#define __BTF_ID(symbol, word) \
+	____BTF_ID(symbol, word)
 
 #define __ID(prefix) \
 	__PASTE(prefix, __COUNTER__)
@@ -46,7 +56,14 @@ asm(							\
  * to 4 zero bytes.
  */
 #define BTF_ID(prefix, name) \
-	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
+	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__), "")
+
+#define ____BTF_ID_FLAGS(prefix, name, flags) \
+	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__), ".long " #flags "\n")
+#define __BTF_ID_FLAGS(prefix, name, flags, ...) \
+	____BTF_ID_FLAGS(prefix, name, flags)
+#define BTF_ID_FLAGS(prefix, name, ...) \
+	__BTF_ID_FLAGS(prefix, name, ##__VA_ARGS__, 0)
 
 /*
  * The BTF_ID_LIST macro defines pure (unsorted) list
@@ -145,10 +162,51 @@ asm(							\
 ".popsection;                                 \n");	\
 extern struct btf_id_set name;
 
+/*
+ * The BTF_SET8_START/END macros pair defines sorted list of
+ * BTF IDs and their flags plus its members count, with the
+ * following layout:
+ *
+ * BTF_SET8_START(list)
+ * BTF_ID_FLAGS(type1, name1, flags)
+ * BTF_ID_FLAGS(type2, name2, flags)
+ * BTF_SET8_END(list)
+ *
+ * __BTF_ID__set8__list:
+ * .zero 8
+ * list:
+ * __BTF_ID__type1__name1__3:
+ * .zero 4
+ * .word (1 << 0) | (1 << 2)
+ * __BTF_ID__type2__name2__5:
+ * .zero 4
+ * .word (1 << 3) | (1 << 1) | (1 << 2)
+ *
+ */
+#define __BTF_SET8_START(name, scope)			\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";       \n"	\
+"." #scope " __BTF_ID__set8__" #name ";        \n"	\
+"__BTF_ID__set8__" #name ":;                   \n"	\
+".zero 8                                       \n"	\
+".popsection;                                  \n");
+
+#define BTF_SET8_START(name)				\
+__BTF_ID_LIST(name, local)				\
+__BTF_SET8_START(name, local)
+
+#define BTF_SET8_END(name)				\
+asm(							\
+".pushsection " BTF_IDS_SECTION ",\"a\";      \n"	\
+".size __BTF_ID__set8__" #name ", .-" #name "  \n"	\
+".popsection;                                 \n");	\
+extern struct btf_id_set8 name;
+
 #else
 
 #define BTF_ID_LIST(name) static u32 __maybe_unused name[5];
 #define BTF_ID(prefix, name)
+#define BTF_ID_FLAGS(prefix, name, flags)
 #define BTF_ID_UNUSED
 #define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
 #define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 __maybe_unused name[1];
@@ -156,6 +214,8 @@ extern struct btf_id_set name;
 #define BTF_SET_START(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_START_GLOBAL(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_END(name)
+#define BTF_SET8_START(name) static struct btf_id_set8 __maybe_unused name = { 0 };
+#define BTF_SET8_END(name) static struct btf_id_set8 __maybe_unused name = { 0 };
 
 #endif /* CONFIG_DEBUG_INFO_BTF */
 
-- 
2.34.1

