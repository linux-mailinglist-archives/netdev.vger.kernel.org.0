Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390FC57A09B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238616AbiGSOIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiGSOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:07:59 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A5D52FC1;
        Tue, 19 Jul 2022 06:24:37 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id va17so27229530ejb.0;
        Tue, 19 Jul 2022 06:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dIrkB9PdPO5rXJES9O2LKz6ixe3qBqHrp9BJp7qrAck=;
        b=R7NFwab1g133+G8FUzI6Z4w7t1vFl22Am/rWVwTnPQMyDjeJl0UL432P2Xp1u5pGEV
         I9FBcef9jlf7bt9/Q7CEQKljSBZ9qgd/8WYxNYvVPQYtwobNGYSwfKUFrrDUdm4+KDtX
         phtuymjyqpM6zWR7Yfw6meT5otT/HmTnRkvS7Ur7r8NUiOl+4m5mrfnqRGzSUVKW5onr
         n+GHzzVjImVYZUzCLELEzU0CiaOr0b91p+pZCA7cGYyOEDjs7ratBRiQ3jaXY7+dTWEj
         C3YhqnSBdK32pbQzEX0T/VtDhNjPxWKfVB3FU0OYIndV01SDZCqrT3m+K6CGm+9DecM/
         OlCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dIrkB9PdPO5rXJES9O2LKz6ixe3qBqHrp9BJp7qrAck=;
        b=bcXWdintFVvncZrolc14GUPEOkUSagw+qs5FsyqUGIGJyAh9MpF0HL7nsQfqIwvxXG
         bp0PUi9j0rCX22T+wrnpMXmQx0fEKmPnpKQUlRXSgQOYvDK6FcNTmFGUlLE6wq0daqqs
         WUiHE5wK47Mrpby9yeFeOg0txdjJyunJin4uCaF+l13AO0YQ7uxoXqA6xwQRFwmAfITh
         VqoCvwoSM6s5q+IkrHHXYbpLFIhw2wGRV4eGEnACjW5vsfozuWsWeJZjSDLem5jIlg/U
         hGorlxZd8ZJQ+pWSXtc+c1qiw0Sfw+iDIf16WFzlOibU6Wv8vAz7YENIIfDvGFqmFHgv
         qlrA==
X-Gm-Message-State: AJIora+Nc5SOAYI45U9jym4je1ohJFzf3EA2osDe8+VCwUOmCfCEHnaA
        7wIujjQadiPD1W1FGVHscL9lYFMaapW6Qg==
X-Google-Smtp-Source: AGRyM1s/40HfRfrIKx7iNeLNNrk7kPIQRLH5LVMKfiOw5s6365rfgGFce6WciNCZE4Y8ZWzG+EUJFQ==
X-Received: by 2002:a17:907:6e90:b0:72b:8205:9e68 with SMTP id sh16-20020a1709076e9000b0072b82059e68mr30160299ejc.767.1658237075696;
        Tue, 19 Jul 2022 06:24:35 -0700 (PDT)
Received: from localhost (icdhcp-1-189.epfl.ch. [128.178.116.189])
        by smtp.gmail.com with ESMTPSA id s26-20020aa7cb1a000000b0043574d27ddasm10416583edt.16.2022.07.19.06.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:24:35 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 01/13] bpf: Introduce BTF ID flags and 8-byte BTF set
Date:   Tue, 19 Jul 2022 15:24:18 +0200
Message-Id: <20220719132430.19993-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220719132430.19993-1-memxor@gmail.com>
References: <20220719132430.19993-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4481; i=memxor@gmail.com; h=from:subject; bh=RhEzZPlcRf2VffXQm8kS0BJ9Zd11RSKvez7i5AZbn+0=; b=owEBbQKS/ZANAwAKAUzgyIZIvxHKAcsmYgBi1rBlLgeVSc8rSRcr+dWR+276EznYx3H4fwUtXWTF 7S+YtvKJAjMEAAEKAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYtawZQAKCRBM4MiGSL8RygYAEA CnvPkLHJDy1TFoCzMvYXnIXT+hldnt6IUk/BXoe44YGgHz0WBzyBKt53WpPOwDAEiBBtLO2U/J1KAG Pcd9YfhNWzme9QOLpcszOOBXNqy1Q5IlI+Oo03oShjnZwuaq/e7/qiOr7p+4tm8gyXzehpxaVu6dTk zDhmMBbA2n0yaLf5DLTwadeVAIaZOt+wtv8H/UswQRfqTzSRKXuEecqXeEsO9gQnzioWRT5zroJ0Zo alY2be3cVWo+ouyqJPWIITxGaiwbBk063VDHjJRq4KXJfoubceRJkmEMtDi6r5rOFtF2nwBbqAcT4j 9sAw/D7BYb9UiwoRRTv7LXx7B7j1HKU22RGTOJsl8Xl6Fp9ngzd8niTsW+2EM87xZShBbLcfqFED1q KmLJHGkQ6OqHrEQEqw90JrKHO+tJtkO6rhkDvPqlX0za2f7UTOdiAbC6ZMxSxMnlbhuIvSpsAco/pf A3Hk0MDa/at2k0EMx8VosCYoi53eGaTIrczc/V+X35bqjQ8JwkLDFLIP/IpyhXyV6a8kgM8w8LnY5U uhgNco4CCkcUtxJNBbsT3dxf8R2ZlGZBDxfojgVKoXGzHRN6CnxxHNy5vM7qDQRXd/3G8PBmmBLYC+ t8IOwdtywZa/A77Xjqqf1ynbacaLwh3cFHV0TtWQ2WvN+HUq+3YWcC8VjKig==
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

The way flags for BTF IDs are constructed requires substituting the flag
value as a string into the symbol name, concatenating the set of flags
(currently limited to 5, but easily extendable to a higher limit), and
then consuming the list from resolve_btfids which can then store the
final flag value by ORing each individual flag into the final result.

The resolve_btfids change is split into a separate patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf_ids.h | 64 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 252a4befeab1..c8055631fb7b 100644
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
@@ -48,6 +57,16 @@ asm(							\
 #define BTF_ID(prefix, name) \
 	__BTF_ID(__ID(__BTF_ID__##prefix##__##name##__))
 
+#define ____BTF_ID_FLAGS_LIST(_0, _1, _2, _3, _4, _5, N, ...) _1##_##_2##_##_3##_##_4##_##_5##__
+#define __BTF_ID_FLAGS_LIST(...) ____BTF_ID_FLAGS_LIST(0x0, ##__VA_ARGS__, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0)
+
+#define __FLAGS(prefix, ...) \
+	__PASTE(prefix, __BTF_ID_FLAGS_LIST(__VA_ARGS__))
+
+#define BTF_ID_FLAGS(prefix, name, ...) \
+	BTF_ID(prefix, name)		\
+	__BTF_ID(__ID(__FLAGS(__BTF_ID__flags__, ##__VA_ARGS__)))
+
 /*
  * The BTF_ID_LIST macro defines pure (unsorted) list
  * of BTF IDs, with following layout:
@@ -145,10 +164,53 @@ asm(							\
 ".popsection;                                 \n");	\
 extern struct btf_id_set name;
 
+/*
+ * The BTF_SET8_START/END macros pair defines sorted list of
+ * BTF IDs and their flags plus its members count, with the
+ * following layout:
+ *
+ * BTF_SET8_START(list)
+ * BTF_ID_FLAGS(type1, name1, flags...)
+ * BTF_ID_FLAGS(type2, name2, flags...)
+ * BTF_SET8_END(list)
+ *
+ * __BTF_ID__set8__list:
+ * .zero 8
+ * list:
+ * __BTF_ID__type1__name1__3:
+ * .zero 4
+ * __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__4:
+ * .zero 4
+ * __BTF_ID__type2__name2__5:
+ * .zero 4
+ * __BTF_ID__flags__0x0_0x0_0x0_0x0_0x0__6:
+ * .zero 4
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
+#define BTF_ID_FLAGS(prefix, name, ...)
 #define BTF_ID_UNUSED
 #define BTF_ID_LIST_GLOBAL(name, n) u32 __maybe_unused name[n];
 #define BTF_ID_LIST_SINGLE(name, prefix, typename) static u32 __maybe_unused name[1];
@@ -156,6 +218,8 @@ extern struct btf_id_set name;
 #define BTF_SET_START(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_START_GLOBAL(name) static struct btf_id_set __maybe_unused name = { 0 };
 #define BTF_SET_END(name)
+#define BTF_SET8_START(name) static struct btf_id_set8 __maybe_unused name = { 0 };
+#define BTF_SET8_END(name) static struct btf_id_set8 __maybe_unused name = { 0 };
 
 #endif /* CONFIG_DEBUG_INFO_BTF */
 
-- 
2.34.1

