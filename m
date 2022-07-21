Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E142F57CF8B
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiGUPim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiGUPiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:38:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C97E98210F
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q1ugzeeQImQSGGFdeXfOpKhPDeYLIbJhcbUeYAyYDFI=;
        b=AWxXbQ4B9AStCqXh1dSvL38Amy1vlE6xKEaJ5UU9yGJL1dNLfuAZjaMEkJe3PTCdfreyPR
        moNVKLswW0KLcWc+QRiIa2dc6L2ohVYgeok3DbfWOCO8wbKYlBvxB+X6cpAfix/yp8PmJw
        SssEeOb4gmvKPnFWZ2QsHxk+/SGSevE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-sr70ccOfNYSgI9Vj21KGzg-1; Thu, 21 Jul 2022 11:36:57 -0400
X-MC-Unique: sr70ccOfNYSgI9Vj21KGzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACFC02804067;
        Thu, 21 Jul 2022 15:36:55 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DDA32166B26;
        Thu, 21 Jul 2022 15:36:52 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v7 07/24] bpf: prepare for more bpf syscall to be used from kernel and user space.
Date:   Thu, 21 Jul 2022 17:36:08 +0200
Message-Id: <20220721153625.1282007-8-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BPF_MAP_GET_FD_BY_ID and BPF_MAP_DELETE_PROG.

Only BPF_MAP_GET_FD_BY_ID needs to be amended to be able
to access the bpf pointer either from the userspace or the kernel.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

no changes in v7

changes in v6:
- commit description change

new in v5
---
 kernel/bpf/syscall.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136c5788..776c7a37c433 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1437,9 +1437,9 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 
 #define BPF_MAP_DELETE_ELEM_LAST_FIELD key
 
-static int map_delete_elem(union bpf_attr *attr)
+static int map_delete_elem(union bpf_attr *attr, bpfptr_t uattr)
 {
-	void __user *ukey = u64_to_user_ptr(attr->key);
+	bpfptr_t ukey = make_bpfptr(attr->key, uattr.is_kernel);
 	int ufd = attr->map_fd;
 	struct bpf_map *map;
 	struct fd f;
@@ -1459,7 +1459,7 @@ static int map_delete_elem(union bpf_attr *attr)
 		goto err_put;
 	}
 
-	key = __bpf_copy_key(ukey, map->key_size);
+	key = ___bpf_copy_key(ukey, map->key_size);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
 		goto err_put;
@@ -4942,7 +4942,7 @@ static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 		err = map_update_elem(&attr, uattr);
 		break;
 	case BPF_MAP_DELETE_ELEM:
-		err = map_delete_elem(&attr);
+		err = map_delete_elem(&attr, uattr);
 		break;
 	case BPF_MAP_GET_NEXT_KEY:
 		err = map_get_next_key(&attr);
@@ -5077,8 +5077,10 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
 
 	switch (cmd) {
 	case BPF_MAP_CREATE:
+	case BPF_MAP_DELETE_ELEM:
 	case BPF_MAP_UPDATE_ELEM:
 	case BPF_MAP_FREEZE:
+	case BPF_MAP_GET_FD_BY_ID:
 	case BPF_PROG_LOAD:
 	case BPF_BTF_LOAD:
 	case BPF_LINK_CREATE:
-- 
2.36.1

