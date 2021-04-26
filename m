Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3030F36AACA
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbhDZCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:50:55 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65A5C061574;
        Sun, 25 Apr 2021 19:50:13 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id x11so55199548qkp.11;
        Sun, 25 Apr 2021 19:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6pETDKNtrqYDuNN8d+r94G6x7BZ9WY+62HbnbQyw20g=;
        b=Rjj+MrygE3aJpWLiQ+HufxVt6CIVIviLDWL1w8Idnw2/g3zk6BuRPMCVUzzsM5ZeTm
         Sk+VkRgz0k0xMJE0UWHB/mVioQ5yx0J8Cj+kTmUOH3JEsOF68LqGmumNuJM3Rwq8K6Wx
         emUItn5JTUI95DkHSwjiQrxBsvuzaM86/IG2026NKTJWrmRD/HfcOS5pCVZuFi8VW8wW
         9GwD+iQ5HDa0Xvs98N9cHNiI3niaMBpcQzj6IMAiQYfzTo9xhHRoWR1HXFIG1gtXNIdT
         NyhkVnJdtWWt1T2RENKd2O8+iCtwS9a32Po+jL0IfZuc4Ke56TMfxWZOfRBX+TblfvjZ
         rdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6pETDKNtrqYDuNN8d+r94G6x7BZ9WY+62HbnbQyw20g=;
        b=QI9c69+DCkZEafCG1GM+j9Z7JuFRSsyG5zRI1rZ+b+O4Xn0h9zvlOOzyOERGzi7y3k
         3cFn6840EPB1MqmZjpXkorTZ8EV+KiT6YiLrpSWuHXTHRoVfjWo2hO2g3bWK2s4yZ416
         tnUzOGY4QbxvY7bpP0mcpFyhvb/Me8ukIQsyMjQn0335njaoXVzcfPTYEeOY2vht8O6s
         3OSdGggkCmBC3z0Zhn5ObSoj2MQCwqeRjRQCeEu2GZbF4U6vbclQTGDm1LFJRrfLBLJw
         deAybDF35LpyfkbEpSnPmNbJ9E3Mh8WlTKMKg7jsWOPI0IuNJTPW/Xu3FZIRXkowzhya
         nDgg==
X-Gm-Message-State: AOAM531PbeXdtja/n01JLfi/+Yb2ZBTFA9nK9hQH4bX+CCHwhyfEHsm1
        r4Rfn0Xz5Ajo527QdhA3YHa5vR8LBT0m8w==
X-Google-Smtp-Source: ABdhPJwkwNBg1MuRSAnSYL4B9SKvuoFxR6UqzAj7N1OU1WBmmZxqQJaZttLMSys9+M8nVr8KOjwK5g==
X-Received: by 2002:a37:8ec4:: with SMTP id q187mr15358397qkd.381.1619405412960;
        Sun, 25 Apr 2021 19:50:12 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:12 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v3 01/10] sock_map: relax config dependency to CONFIG_NET
Date:   Sun, 25 Apr 2021 19:49:52 -0700
Message-Id: <20210426025001.7899-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sock_map still has hard dependency on CONFIG_INET,
but there is no actual functional dependency on it after
we introduce ->psock_update_sk_prot().

We have to extend it to CONFIG_NET now as we are going to
support AF_UNIX.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h | 38 ++++++++++++++++++++------------------
 init/Kconfig        |  2 +-
 net/core/Makefile   |  2 --
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f8a45f109e96..27986021214d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1824,6 +1824,12 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
 struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr);
 void bpf_map_offload_map_free(struct bpf_map *map);
+
+int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
+int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
+void sock_map_unhash(struct sock *sk);
+void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1849,24 +1855,6 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
 static inline void bpf_map_offload_map_free(struct bpf_map *map)
 {
 }
-#endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
-
-#if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
-int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
-int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
-int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
-void sock_map_unhash(struct sock *sk);
-void sock_map_close(struct sock *sk, long timeout);
-
-void bpf_sk_reuseport_detach(struct sock *sk);
-int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
-				       void *value);
-int bpf_fd_reuseport_array_update_elem(struct bpf_map *map, void *key,
-				       void *value, u64 map_flags);
-#else
-static inline void bpf_sk_reuseport_detach(struct sock *sk)
-{
-}
 
 #ifdef CONFIG_BPF_SYSCALL
 static inline int sock_map_get_from_fd(const union bpf_attr *attr,
@@ -1886,7 +1874,21 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
 {
 	return -EOPNOTSUPP;
 }
+#endif /* CONFIG_BPF_SYSCALL */
+#endif /* CONFIG_NET && CONFIG_BPF_SYSCALL */
 
+#if defined(CONFIG_INET) && defined(CONFIG_BPF_SYSCALL)
+void bpf_sk_reuseport_detach(struct sock *sk);
+int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map, void *key,
+				       void *value);
+int bpf_fd_reuseport_array_update_elem(struct bpf_map *map, void *key,
+				       void *value, u64 map_flags);
+#else
+static inline void bpf_sk_reuseport_detach(struct sock *sk)
+{
+}
+
+#ifdef CONFIG_BPF_SYSCALL
 static inline int bpf_fd_reuseport_array_lookup_elem(struct bpf_map *map,
 						     void *key, void *value)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 5deae45b8d81..161d0f19cdd9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1708,7 +1708,7 @@ config BPF_SYSCALL
 	select BPF
 	select IRQ_WORK
 	select TASKS_TRACE_RCU
-	select NET_SOCK_MSG if INET
+	select NET_SOCK_MSG if NET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
diff --git a/net/core/Makefile b/net/core/Makefile
index 0c2233c826fd..4b5a5a22386a 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -32,8 +32,6 @@ obj-$(CONFIG_HWBM) += hwbm.o
 obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
-ifeq ($(CONFIG_INET),y)
 obj-$(CONFIG_NET_SOCK_MSG) += skmsg.o
 obj-$(CONFIG_BPF_SYSCALL) += sock_map.o
-endif
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
-- 
2.25.1

