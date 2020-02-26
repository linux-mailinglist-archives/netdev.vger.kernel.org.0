Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B75C16FF86
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 14:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgBZNEX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Feb 2020 08:04:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbgBZNEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 08:04:23 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-_l3oiGNAP_6JXjYcXaAfHA-1; Wed, 26 Feb 2020 08:04:18 -0500
X-MC-Unique: _l3oiGNAP_6JXjYcXaAfHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E623A108442C;
        Wed, 26 Feb 2020 13:04:15 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 145AF19C7F;
        Wed, 26 Feb 2020 13:04:12 +0000 (UTC)
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
Subject: [PATCH 07/18] bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
Date:   Wed, 26 Feb 2020 14:03:34 +0100
Message-Id: <20200226130345.209469-8-jolsa@kernel.org>
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

Moving bpf_tree add/del from bpf_prog_ksym_node_add/del,
because it will be used (and renamed) in following patches
for bpf_ksym objects. The bpf_tree is specific for bpf_prog
objects.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 26d13dec3435..cdff3e4b207c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -648,7 +648,6 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 {
 	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
 	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
-	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	latch_tree_insert(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 }
 
@@ -657,7 +656,6 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 	if (list_empty(&aux->ksym.lnode))
 		return;
 
-	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	latch_tree_erase(&aux->ksym.tnode, &bpf_ksym_tree, &bpf_ksym_tree_ops);
 	list_del_rcu(&aux->ksym.lnode);
 }
@@ -683,6 +681,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 	bpf_get_prog_name(fp);
 
 	spin_lock_bh(&bpf_lock);
+	latch_tree_insert(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	bpf_prog_ksym_node_add(fp->aux);
 	spin_unlock_bh(&bpf_lock);
 }
@@ -693,6 +692,7 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 		return;
 
 	spin_lock_bh(&bpf_lock);
+	latch_tree_erase(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	bpf_prog_ksym_node_del(fp->aux);
 	spin_unlock_bh(&bpf_lock);
 }
-- 
2.24.1

