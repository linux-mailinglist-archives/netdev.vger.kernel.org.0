Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9279717F10A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJHcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:32:46 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38558 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJHcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:32:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id z5so1202574pfn.5;
        Tue, 10 Mar 2020 00:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SEH8DDPD4t4iwsEOpSlyk77FYqwoHHGvfn5pB2B75r0=;
        b=f4ty7DwUYN/eCaH9QV//IzQBNLL3Lrnfdk5Fv3ZKur/iKUWeYRWr30l6VXx8toB9CF
         Ni7jZ3QQZGiyfJoMZQZ1cMO36zNX1WD00xZni2kAqRC68VBp3gCBtIU2WgkH7m67V7C5
         gvLVBpltC3C1jIzZ8hkEplXzM28GsRIUbuZVKchkoBjGramM94pX/LZfBX3CJ/Iaptwj
         gp7JT0i6UmnLIUD2dyOxsT4l0/tFCf3brgcIkLxthJgD9pue5FO/CuAsNLlV6W9tNjaW
         XLdIQc1PyJ7cHDjRSwUGXpBtYoWlMS/YnDZelth9k87z1DKGvspG+W+fsrYL6pFC6mda
         zpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SEH8DDPD4t4iwsEOpSlyk77FYqwoHHGvfn5pB2B75r0=;
        b=FJyBBVnqnRhHiXaegsmOO23S8z72kUOST/DmHmkrEXzcLKChfayg3JPYjClSuTz9bc
         enThT5j17guEivG6XGl9DVEzgYsg3XS0A9Lu5n9sPoLAO4mSn7S6m6y6w2/wiYHZp8BM
         l+/+oVFh4+/MgGIEs7NJqI9EQe9V48kgLXZgFQ24bxGAsywU6bibUr2Ta2UdfPT+Tetb
         bwwpzLi88W0AHLym5m8Jmi66LtoiR34dSteySil4FSPEGr8rVzhJdU+jDZaSCBW6OzQi
         rS7GRabUZIHbDMXjSR+a5ZLpGAXoL4YvbL+sTkuVuBP4j1C8wdfkz3FgjwJdXhhUMllQ
         rgfw==
X-Gm-Message-State: ANhLgQ3HqdjzF35ztSdivHc4CAMVtHOfAAcU0w3sY+US88kyG+diHwEK
        8msKjPYyYGTouPLycGj0tzEbMp/vWHw=
X-Google-Smtp-Source: ADFU+vv5I9OHJrzKDv9Dli1pHXEk/4NUCPEG8Dke3T8nKNyG9Pm1txLTYARKWgY+3cAsKE/ZoSiOiQ==
X-Received: by 2002:a63:8343:: with SMTP id h64mr19156614pge.73.1583825565314;
        Tue, 10 Mar 2020 00:32:45 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id t8sm1075109pjy.11.2020.03.10.00.32.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 00:32:44 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 2/2] selftests/bpf: Add test for the packed enum member in struct/union
Date:   Tue, 10 Mar 2020 16:32:30 +0900
Message-Id: <1583825550-18606-3-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
References: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a simple test to the existing selftest program in order to make
sure that a packed enum member in struct unexceeds the struct_size.

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 tools/testing/selftests/bpf/test_btf.c | 42 ++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
index 93040ca..8da77cd 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/test_btf.c
@@ -1062,6 +1062,48 @@ struct btf_raw_test {
 	.err_str = "Member exceeds struct_size",
 },
 
+/* Test member unexceeds the size of struct
+ *
+ * enum E {
+ *     E0,
+ *     E1,
+ * };
+ *
+ * struct A {
+ *     char m;
+ *     enum E __attribute__((packed)) n;
+ * };
+ */
+{
+	.descr = "size check test #5",
+	.raw_types = {
+		/* int */			/* [1] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, sizeof(int)),
+		/* char */			/* [2] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 8, 1),
+		/* enum E { */			/* [3] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 2), 1),
+		BTF_ENUM_ENC(NAME_TBD, 0),
+		BTF_ENUM_ENC(NAME_TBD, 1),
+		/* } */
+		/* struct A { */		/* [4] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 2), 2),
+		BTF_MEMBER_ENC(NAME_TBD, 2, 0),	/* char m; */
+		BTF_MEMBER_ENC(NAME_TBD, 3, 8),/* enum E __attribute__((packed)) n; */
+		/* } */
+		BTF_END_RAW,
+	},
+	.str_sec = "\0E\0E0\0E1\0A\0m\0n",
+	.str_sec_size = sizeof("\0E\0E0\0E1\0A\0m\0n"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = "size_check5_map",
+	.key_size = sizeof(int),
+	.value_size = 2,
+	.key_type_id = 1,
+	.value_type_id = 4,
+	.max_entries = 4,
+},
+
 /* typedef const void * const_void_ptr;
  * struct A {
  *	const_void_ptr m;
-- 
1.8.3.1

