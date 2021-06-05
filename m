Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7778539C7CA
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 13:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhFELNK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Jun 2021 07:13:10 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:55829 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229998AbhFELNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 07:13:09 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-zc4qs-W8OZOFo4lHP1cUhA-1; Sat, 05 Jun 2021 07:11:20 -0400
X-MC-Unique: zc4qs-W8OZOFo4lHP1cUhA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10C9F1800D41;
        Sat,  5 Jun 2021 11:11:18 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5EE805272D;
        Sat,  5 Jun 2021 11:11:15 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: [PATCH 12/19] bpf: Add bpf_trampoline_alloc function
Date:   Sat,  5 Jun 2021 13:10:27 +0200
Message-Id: <20210605111034.1810858-13-jolsa@kernel.org>
In-Reply-To: <20210605111034.1810858-1-jolsa@kernel.org>
References: <20210605111034.1810858-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the bpf_trampoline_alloc function. It will
be used to allocate trampoline for multi-func programs
in following patches.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 28a3630c48ee..2755fdcf9fbf 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -58,11 +58,27 @@ void bpf_image_ksym_del(struct bpf_ksym *ksym)
 			   PAGE_SIZE, true, ksym->name);
 }
 
+static struct bpf_trampoline *bpf_trampoline_alloc(void)
+{
+	struct bpf_trampoline *tr;
+	int i;
+
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr)
+		return NULL;
+
+	INIT_HLIST_NODE(&tr->hlist);
+	refcount_set(&tr->refcnt, 1);
+	mutex_init(&tr->mutex);
+	for (i = 0; i < BPF_TRAMP_MAX; i++)
+		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
+	return tr;
+}
+
 static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 {
 	struct bpf_trampoline *tr;
 	struct hlist_head *head;
-	int i;
 
 	mutex_lock(&trampoline_mutex);
 	head = &trampoline_table[hash_64(key, TRAMPOLINE_HASH_BITS)];
@@ -72,17 +88,11 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
 			goto out;
 		}
 	}
-	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
-	if (!tr)
-		goto out;
-
-	tr->key = key;
-	INIT_HLIST_NODE(&tr->hlist);
-	hlist_add_head(&tr->hlist, head);
-	refcount_set(&tr->refcnt, 1);
-	mutex_init(&tr->mutex);
-	for (i = 0; i < BPF_TRAMP_MAX; i++)
-		INIT_HLIST_HEAD(&tr->progs_hlist[i]);
+	tr = bpf_trampoline_alloc();
+	if (tr) {
+		tr->key = key;
+		hlist_add_head(&tr->hlist, head);
+	}
 out:
 	mutex_unlock(&trampoline_mutex);
 	return tr;
-- 
2.31.1

