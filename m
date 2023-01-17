Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0C266D5D9
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 07:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbjAQGDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 01:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbjAQGDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 01:03:09 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4FDC678;
        Mon, 16 Jan 2023 22:03:06 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id p185so4025756oif.2;
        Mon, 16 Jan 2023 22:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qDaQH+I/s8e8gB2wmqyyam1QN+b7v3kB4ZwgnggcBLs=;
        b=p8oXWZdK7bbSSPbXerwwNsRBQFthwA5ePjchqlmZzTOYv/RehY0mJYEmp/WaFDfwYy
         ECoO5mvAuDSxbj72cOpxyy4wOiC5r+pdUYC1pJAu8l4+IP3dppQzCmq18kAow6gzcEHc
         1re6icWLeEYcW3mK+t4i4P96HwPjnuVCXUPlMwSDoc5TLz4e7ioyHAh129X3OSjavV5T
         c2kHNP4WwYq58bDCwL6i7yjynWa/2aB47qaYMQWyOLKD4k+ByRycWsmk+sUlIYvVzxS/
         G7EOK/UHSgzMl0dLa+yv6gu1zzBt9lg2Q/vqWgHg9nXicDqQ0h5nAN3hxhBOKlJQviMe
         mzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qDaQH+I/s8e8gB2wmqyyam1QN+b7v3kB4ZwgnggcBLs=;
        b=bFhASJk3yiAc+yFUH38hWcjc1/gCbbVz8rIkkNxGAUOPGQuax/37VwORNA6IEUSB0Z
         tagXcxW8BOS8Y2aBCM6s2708HSdANO47DwFSsumaRPiHUDSVcp3IsCPr6rKmzis1PsG2
         9LU38iN0HAia11+NgK11K60dlcKFH54bo6TNWdsJEhW7DRKf+DWn91dvR9qiia6MMSHj
         I7NgQV11eczoWgm6bIvaq/xeNR8W0HXeEcUxiQcqi+v/pNCc+Dn/ZH54xZruuotrwXwU
         hTWkL5pqZ5WVEWSYW7nzu5FeZ5Kbqn4GkqweoksSldaPlqymE11ceK558FYkdbWVNzkb
         DOvw==
X-Gm-Message-State: AFqh2kpreZisxxuu0x0nBImgQaZxKGxa5duwYnh7KQzKdG2niY64H0o0
        kV6//6tKKSeNkgxofUGY53m6j0VYUA0=
X-Google-Smtp-Source: AMrXdXs6nq/medtdznt4//m3DTL7OWSRsFHEzeAcSrkzXQEy4U6wzBGkklzFglvwS8qUSvM5Vd2Pfg==
X-Received: by 2002:a05:6808:1a16:b0:361:8d6:944d with SMTP id bk22-20020a0568081a1600b0036108d6944dmr1225407oib.47.1673935385848;
        Mon, 16 Jan 2023 22:03:05 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2f2a:7825:8a78:b891])
        by smtp.gmail.com with ESMTPSA id g21-20020a0568080dd500b00360f68d509csm14060974oic.49.2023.01.16.22.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 22:03:05 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next 1/2] bpf: remove a redundant parameter of bpf_map_free_id()
Date:   Mon, 16 Jan 2023 22:02:48 -0800
Message-Id: <20230117060249.912679-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
References: <20230117060249.912679-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
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

From: Cong Wang <cong.wang@bytedance.com>

The second parameter of bpf_map_free_id() is always true,
hence can be just eliminated.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h  |  2 +-
 kernel/bpf/offload.c |  2 +-
 kernel/bpf/syscall.c | 23 +++++------------------
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ae7771c7d750..3558c192871c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1833,7 +1833,7 @@ struct bpf_prog * __must_check bpf_prog_inc_not_zero(struct bpf_prog *prog);
 void bpf_prog_put(struct bpf_prog *prog);
 
 void bpf_prog_free_id(struct bpf_prog *prog, bool do_idr_lock);
-void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock);
+void bpf_map_free_id(struct bpf_map *map);
 
 struct btf_field *btf_record_find(const struct btf_record *rec,
 				  u32 offset, enum btf_field_type type);
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 13e4efc971e6..ae6d5a5c0798 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -412,7 +412,7 @@ static void __bpf_map_offload_destroy(struct bpf_offloaded_map *offmap)
 {
 	WARN_ON(bpf_map_offload_ndo(offmap, BPF_OFFLOAD_MAP_FREE));
 	/* Make sure BPF_MAP_GET_NEXT_ID can't find this dead map */
-	bpf_map_free_id(&offmap->map, true);
+	bpf_map_free_id(&offmap->map);
 	list_del_init(&offmap->offloads);
 	offmap->netdev = NULL;
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 35ffd808f281..1eaa1a18aef7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -390,7 +390,7 @@ static int bpf_map_alloc_id(struct bpf_map *map)
 	return id > 0 ? 0 : id;
 }
 
-void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
+void bpf_map_free_id(struct bpf_map *map)
 {
 	unsigned long flags;
 
@@ -402,18 +402,10 @@ void bpf_map_free_id(struct bpf_map *map, bool do_idr_lock)
 	if (!map->id)
 		return;
 
-	if (do_idr_lock)
-		spin_lock_irqsave(&map_idr_lock, flags);
-	else
-		__acquire(&map_idr_lock);
-
+	spin_lock_irqsave(&map_idr_lock, flags);
 	idr_remove(&map_idr, map->id);
 	map->id = 0;
-
-	if (do_idr_lock)
-		spin_unlock_irqrestore(&map_idr_lock, flags);
-	else
-		__release(&map_idr_lock);
+	spin_unlock_irqrestore(&map_idr_lock, flags);
 }
 
 #ifdef CONFIG_MEMCG_KMEM
@@ -708,11 +700,11 @@ static void bpf_map_put_uref(struct bpf_map *map)
 /* decrement map refcnt and schedule it for freeing via workqueue
  * (unrelying map implementation ops->map_free() might sleep)
  */
-static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
+void bpf_map_put(struct bpf_map *map)
 {
 	if (atomic64_dec_and_test(&map->refcnt)) {
 		/* bpf_map_free_id() must be called first */
-		bpf_map_free_id(map, do_idr_lock);
+		bpf_map_free_id(map);
 		btf_put(map->btf);
 		INIT_WORK(&map->work, bpf_map_free_deferred);
 		/* Avoid spawning kworkers, since they all might contend
@@ -721,11 +713,6 @@ static void __bpf_map_put(struct bpf_map *map, bool do_idr_lock)
 		queue_work(system_unbound_wq, &map->work);
 	}
 }
-
-void bpf_map_put(struct bpf_map *map)
-{
-	__bpf_map_put(map, true);
-}
 EXPORT_SYMBOL_GPL(bpf_map_put);
 
 void bpf_map_put_with_uref(struct bpf_map *map)
-- 
2.34.1

