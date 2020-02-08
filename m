Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC9215652D
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgBHPmy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Feb 2020 10:42:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727527AbgBHPmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Feb 2020 10:42:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-3GgoLTZiMqmv82Oi1nUMyA-1; Sat, 08 Feb 2020 10:42:48 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127A8801E74;
        Sat,  8 Feb 2020 15:42:46 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-79.brq.redhat.com [10.40.204.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F6885C28F;
        Sat,  8 Feb 2020 15:42:42 +0000 (UTC)
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
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: [PATCH 07/14] bpf: Move bpf_tree add/del from bpf_prog_ksym_node_add/del
Date:   Sat,  8 Feb 2020 16:42:02 +0100
Message-Id: <20200208154209.1797988-8-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
References: <20200208154209.1797988-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 3GgoLTZiMqmv82Oi1nUMyA-1
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
index 1daa72341450..f4c16b362858 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -652,7 +652,6 @@ static void bpf_prog_ksym_node_add(struct bpf_prog_aux *aux)
 {
 	WARN_ON_ONCE(!list_empty(&aux->ksym.lnode));
 	list_add_tail_rcu(&aux->ksym.lnode, &bpf_kallsyms);
-	latch_tree_insert(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	latch_tree_insert(&aux->ksym.tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
 }
 
@@ -661,7 +660,6 @@ static void bpf_prog_ksym_node_del(struct bpf_prog_aux *aux)
 	if (list_empty(&aux->ksym.lnode))
 		return;
 
-	latch_tree_erase(&aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	latch_tree_erase(&aux->ksym.tnode, &bpf_kallsyms_tree, &bpf_kallsyms_tree_ops);
 	list_del_rcu(&aux->ksym.lnode);
 }
@@ -687,6 +685,7 @@ void bpf_prog_kallsyms_add(struct bpf_prog *fp)
 	bpf_get_prog_name(fp);
 
 	spin_lock_bh(&bpf_lock);
+	latch_tree_insert(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	bpf_prog_ksym_node_add(fp->aux);
 	spin_unlock_bh(&bpf_lock);
 }
@@ -697,6 +696,7 @@ void bpf_prog_kallsyms_del(struct bpf_prog *fp)
 		return;
 
 	spin_lock_bh(&bpf_lock);
+	latch_tree_erase(&fp->aux->ksym_tnode, &bpf_tree, &bpf_tree_ops);
 	bpf_prog_ksym_node_del(fp->aux);
 	spin_unlock_bh(&bpf_lock);
 }
-- 
2.24.1

