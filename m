Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B1659FB99
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbiHXNmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbiHXNlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E60E80B74
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4/9u8eD7FcgWw8gX8MJJHYFD16U3D9wVzRST8jgEjk=;
        b=HoV/BArpcqj3LQxZcQQ528JSo++YI5qvkuSDkAeDt5R9Use7DG9UtUHgAdpXsnmZeoN3/x
        2l7OzHj5F0L5cPzyif9UGcXOEdbisV7qFYfvM4/9SUS82wMseSfwEJ15nNc/vVolteubfK
        Q0DwHkHKpsVFqoOPnAIpmPnhVzuYZ5c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-BrHUujMmP3u6lYykwoDL2A-1; Wed, 24 Aug 2022 09:41:27 -0400
X-MC-Unique: BrHUujMmP3u6lYykwoDL2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0860E38025E7;
        Wed, 24 Aug 2022 13:41:23 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D614918ECC;
        Wed, 24 Aug 2022 13:41:19 +0000 (UTC)
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
Subject: [PATCH bpf-next v9 06/23] bpf: prepare for more bpf syscall to be used from kernel and user space.
Date:   Wed, 24 Aug 2022 15:40:36 +0200
Message-Id: <20220824134055.1328882-7-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

no changes in v9

no changes in v8

no changes in v7

changes in v6:
- commit description change

new in v5
---
 kernel/bpf/syscall.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index a4d40d98428a..4e9d4622aef7 100644
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
@@ -4941,7 +4941,7 @@ static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 		err = map_update_elem(&attr, uattr);
 		break;
 	case BPF_MAP_DELETE_ELEM:
-		err = map_delete_elem(&attr);
+		err = map_delete_elem(&attr, uattr);
 		break;
 	case BPF_MAP_GET_NEXT_KEY:
 		err = map_get_next_key(&attr);
@@ -5073,8 +5073,10 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, union bpf_attr *, attr, u32, attr_size)
 {
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

