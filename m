Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93CDC53B272
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiFBELD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiFBEK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:10:58 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C220A70C;
        Wed,  1 Jun 2022 21:10:57 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id k6so2663493qtq.3;
        Wed, 01 Jun 2022 21:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywj2mZE579nhAsHQXiDar0UmyOF1olYXQQH9zGtGtXY=;
        b=HYeSe33NHMPwhWWbKtHfQvI21hHNLK06mEJuSeYNREnDelKboqDpBrHniohn98lJA5
         tUoA2MhV5bHAT3sjLVbQmFT6jg+4kg1xklcKYKT46r4IELwNzNvV0hFsiZtFKuNRwaSF
         fGPWeqdTHNg27OXHzZFgpmB0hJlxG/LaIsXRjPru6BA6IvrjC/eBnqAtXLeYXF2+LvoR
         qjWKJ18NZ+OsR6HpQlc/zZTmfUpoc3Ed1HIeLpkz427ohSz5+5WVRQRJjr8OhIloTXFY
         qWdudURAGAqi7zq8C+gDj+yPglN0T/DN2dtIYTUGvSMQsSQn8uhMng36RmEAyKLh8Bs7
         WZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywj2mZE579nhAsHQXiDar0UmyOF1olYXQQH9zGtGtXY=;
        b=qWsJfh7VphSMCTuwO1RRNTWa9VoxuCtZn0zFuafyWZah8ceW2wBxOmlFJ3RKJZcf1D
         Lb04cnMQ/NhCem0BlQ5F1POTnrqEb8nGCXHjACcvpbQfTSVwdMwloRH0IU62nCj+whB2
         b156/vSLT8QN8UNd33tsGe59ikj9DSYx72D9Z3ufPjO8PSDe2F37BDTBaGgJBVPGEC5V
         uqUKAhTApW03iMXcbW27Y39563yxvuOp/qXu2wQUoVBvMlG/x1kYeaA4bZGmsqcLTwXx
         jm0wdJ444LEhayQwZkpYIR+mcdm5qCp/6bUngNhkFPFlZM8dIQUmJ8KOtoNGWnXT/95B
         Feig==
X-Gm-Message-State: AOAM533Xb9wiExBYzVoYLuSZ7GHr0yfYgnj7i/roUn3ENXhJ3kgNzAYE
        J1qJoqBIR7jEuyMzFDdog+mauZWeys4=
X-Google-Smtp-Source: ABdhPJyDd666J1KA9dCEs/Sv82SlHs+Y61Qy5ZHQMuCYllpdfe4t1ee+ZEnp2dZscV4aKE7xKLXThQ==
X-Received: by 2002:a05:622a:18a6:b0:304:d541:b0fd with SMTP id v38-20020a05622a18a600b00304d541b0fdmr208295qtc.396.1654143056806;
        Wed, 01 Jun 2022 21:10:56 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:d7c6:fc22:5340:d891])
        by smtp.gmail.com with ESMTPSA id i187-20020a3786c4000000b0069fc13ce1fesm2396654qkd.47.2022.06.01.21.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 21:10:56 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [RFC Patch v5 2/5] bpf: move map in map declarations to bpf.h
Date:   Wed,  1 Jun 2022 21:10:25 -0700
Message-Id: <20220602041028.95124-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h     |  6 ++++++
 kernel/bpf/arraymap.c   |  2 --
 kernel/bpf/hashtab.c    |  1 -
 kernel/bpf/map_in_map.c |  2 --
 kernel/bpf/map_in_map.h | 19 -------------------
 5 files changed, 6 insertions(+), 24 deletions(-)
 delete mode 100644 kernel/bpf/map_in_map.h

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e6092d0ea95..cf04ddce2c2d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -341,6 +341,12 @@ int map_check_no_btf(const struct bpf_map *map,
 
 bool bpf_map_meta_equal(const struct bpf_map *meta0,
 			const struct bpf_map *meta1);
+struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd);
+void bpf_map_meta_free(struct bpf_map *map_meta);
+void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
+			 int ufd);
+void bpf_map_fd_put_ptr(void *ptr);
+u32 bpf_map_fd_sys_lookup_elem(void *ptr);
 
 extern const struct bpf_map_ops bpf_map_offload_ops;
 
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index fe40d3b9458f..65ba21e4b707 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -13,8 +13,6 @@
 #include <linux/rcupdate_trace.h>
 #include <linux/btf_ids.h>
 
-#include "map_in_map.h"
-
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
 	 BPF_F_PRESERVE_ELEMS | BPF_F_INNER_MAP)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 17fb69c0e0dc..f0a2464c1669 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -13,7 +13,6 @@
 #include <linux/btf_ids.h>
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
-#include "map_in_map.h"
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index 135205d0d560..8a537f6b2abd 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -5,8 +5,6 @@
 #include <linux/bpf.h>
 #include <linux/btf.h>
 
-#include "map_in_map.h"
-
 struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
 {
 	struct bpf_map *inner_map, *inner_map_meta;
diff --git a/kernel/bpf/map_in_map.h b/kernel/bpf/map_in_map.h
deleted file mode 100644
index bcb7534afb3c..000000000000
--- a/kernel/bpf/map_in_map.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (c) 2017 Facebook
- */
-#ifndef __MAP_IN_MAP_H__
-#define __MAP_IN_MAP_H__
-
-#include <linux/types.h>
-
-struct file;
-struct bpf_map;
-
-struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd);
-void bpf_map_meta_free(struct bpf_map *map_meta);
-void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
-			 int ufd);
-void bpf_map_fd_put_ptr(void *ptr);
-u32 bpf_map_fd_sys_lookup_elem(void *ptr);
-
-#endif
-- 
2.34.1

