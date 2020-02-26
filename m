Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4864416FF9D
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgBZNFJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:05:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30413 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727350AbgBZNFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:05:09 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-LVWOt1y9Pluzec83kuDYVg-1; Wed, 26 Feb 2020 08:05:03 -0500
X-MC-Unique: LVWOt1y9Pluzec83kuDYVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53161DB33;
        Wed, 26 Feb 2020 13:05:01 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F88419C7F;
        Wed, 26 Feb 2020 13:04:56 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/18] bpf: Sort bpf kallsyms symbols
Date:   Wed, 26 Feb 2020 14:03:42 +0100
Message-Id: <20200226130345.209469-16-jolsa@kernel.org>
In-Reply-To: <20200226130345.209469-1-jolsa@kernel.org>
References: <20200226130345.209469-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we don't sort bpf_kallsyms and display symbols
in proc/kallsyms as they come in via __bpf_ksym_add.

Using the latch tree to get the next bpf_ksym object
and insert the new symbol ahead of it.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9879fb02ee8e..3319019735f0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -647,9 +647,28 @@ static struct latch_tree_root bpf_progs_tree __cacheline_aligned;
 
 static void __bpf_ksym_add(struct bpf_ksym *ksym)
 {
+	struct list_head *head = &bpf_kallsyms;
+	struct rb_node *next;
+
 	WARN_ON_ONCE(!list_empty(&ksym->lnode));
-	list_add_tail_rcu(&ksym->lnode, &bpf_kallsyms);
 	latch_tree_insert(&ksym->tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
+
+	/*
+	 * Add ksym into bpf_kallsyms in ordered position,
+	 * which is prepared for us by latch tree addition.
+	 *
+	 * Find out the next symbol and insert ksym right
+	 * ahead of it. If ksym is the last one, just tail
+	 * add to the bpf_kallsyms.
+	 */
+	next = rb_next(&ksym->tnode.node[0]);
+	if (next) {
+		struct bpf_ksym *ptr;
+
+		ptr = container_of(next, struct bpf_ksym, tnode.node[0]);
+		head = &ptr->lnode;
+	}
+	list_add_tail_rcu(&ksym->lnode, head);
 }
 
 void bpf_ksym_add(struct bpf_ksym *ksym)
-- 
2.24.1

