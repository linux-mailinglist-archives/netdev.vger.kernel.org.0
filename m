Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297504FEC8B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiDMBxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiDMBxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:53:14 -0400
Received: from ha.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83CC327FE7;
        Tue, 12 Apr 2022 18:50:54 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by ha.nfschina.com (Postfix) with ESMTP id 7F4E21E80D9E;
        Wed, 13 Apr 2022 09:49:36 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
        by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id P---MdcC6w0a; Wed, 13 Apr 2022 09:49:33 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.228.255.56])
        (Authenticated sender: yuzhe@nfschina.com)
        by ha.nfschina.com (Postfix) with ESMTPA id 08A021E80D95;
        Wed, 13 Apr 2022 09:49:32 +0800 (CST)
From:   Yu Zhe <yuzhe@nfschina.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: [PATCH] bpf: remove unnecessary type castings
Date:   Tue, 12 Apr 2022 18:50:48 -0700
Message-Id: <20220413015048.12319-1-yuzhe@nfschina.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove unnecessary void* type castings.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
---
 kernel/bpf/bpf_struct_ops.c | 4 ++--
 kernel/bpf/hashtab.c        | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 21069dbe9138..de01d37c2d3b 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -263,7 +263,7 @@ int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
 	/* No lock is needed.  state and refcnt do not need
 	 * to be updated together under atomic context.
 	 */
-	uvalue = (struct bpf_struct_ops_value *)value;
+	uvalue = value;
 	memcpy(uvalue, st_map->uvalue, map->value_size);
 	uvalue->state = state;
 	refcount_set(&uvalue->refcnt, refcount_read(&kvalue->refcnt));
@@ -353,7 +353,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 	if (err)
 		return err;
 
-	uvalue = (struct bpf_struct_ops_value *)value;
+	uvalue = value;
 	err = check_zero_holes(t, uvalue->data);
 	if (err)
 		return err;
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 65877967f414..c68fbebc8c00 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -738,7 +738,7 @@ static void check_and_free_timer(struct bpf_htab *htab, struct htab_elem *elem)
  */
 static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 {
-	struct bpf_htab *htab = (struct bpf_htab *)arg;
+	struct bpf_htab *htab = arg;
 	struct htab_elem *l = NULL, *tgt_l;
 	struct hlist_nulls_head *head;
 	struct hlist_nulls_node *n;
-- 
2.25.1

