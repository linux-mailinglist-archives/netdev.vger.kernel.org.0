Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0709E37743B
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhEHWKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhEHWKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:11 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9D2C06175F;
        Sat,  8 May 2021 15:09:08 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id y12so9297230qtx.11;
        Sat, 08 May 2021 15:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LfAQAnVkXCYeUY7D3NvE6dhD/53ZEfmaqU4/OROOBA=;
        b=DAeaYUanWHH9khG+lF+SCr8mTChgI+vPHkWiNvf8T/BqWSHp3mBhDA/TBT2qBrpFlA
         Ffgs4G4HM6Zj6ow7zi2MTl2igVrqZl/CRN3UuYGyNFEI+BuQLqUNcueDfFGIJB6hwigP
         cIyIMMjYNkVXfZaqPWcdQTIanqQ7uWtyjQNHjGjWjlUCF6QZwfIQVsAGlpIHWxBm/R0v
         q96FIWr7aAgthww+TYgHgi9GtIpSEX3g+EWQlyYKDysT4f1R86vVrsv6JN433MB1sKxY
         mNQA5qw0z6VIZq9t7ttZgY96JnOIku8a4uUDjPTgcn/QDTgUPp+ICde5Tc5aJzyfgAgA
         o3QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LfAQAnVkXCYeUY7D3NvE6dhD/53ZEfmaqU4/OROOBA=;
        b=dceBUKHyiWsvTDyfAuz20WR8MCyItJ5Oevc6dtvFWb9alxdrP04GyJa9pqciHkNZYi
         jSB3+gx+PDRuaCeiNd72StOH9V3I2Dz+FX7+X6kc7HWK/izqfz0VNvx7clvv3+QxRN2T
         L53Aw5Qax3jF0tyymkcNmXH6Jg6G3FlIE3wQwtM6FSRergpqZQBXwpOxZ0KYjaKnQJdv
         iBhEdJlsI0pd/dKx1M7dtUxJ3rlHTcmlydAh41DMkmJwbjEnb0UZe4sP6t+sBe7um+L7
         XyjMGvTd7T/QNr8bNu32X/JWDzJw4s0i7soRG49JB1EdFmrOqQi+dO2LpNaqRyFZIH8p
         ivIA==
X-Gm-Message-State: AOAM530TkUwXxrWnvwI2eXKvg0IEJbrfnABChFLDOMNXH32VuANrhrz5
        VAxGA5enUmsP0BPEtrsrvi9L0IdURGPOyA==
X-Google-Smtp-Source: ABdhPJw2LGpQODRu9JYprHauDvbUFx26mNS1tmUUIrn3VKn8upmcu6pRiFyhK5zxb9PcgTSgJ6mdSA==
X-Received: by 2002:ac8:5810:: with SMTP id g16mr15091483qtg.135.1620511747813;
        Sat, 08 May 2021 15:09:07 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:07 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v4 01/12] sock_map: relax config dependency to CONFIG_NET
Date:   Sat,  8 May 2021 15:08:24 -0700
Message-Id: <20210508220835.53801-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
References: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
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
index 02b02cb29ce2..b818003739e8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1826,6 +1826,12 @@ static inline bool bpf_map_is_dev_bound(struct bpf_map *map)
 
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
@@ -1851,24 +1857,6 @@ static inline struct bpf_map *bpf_map_offload_map_alloc(union bpf_attr *attr)
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
@@ -1888,7 +1876,21 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
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
index ca559ccdaa32..a8d9b0e05da1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1723,7 +1723,7 @@ config BPF_SYSCALL
 	select IRQ_WORK
 	select TASKS_TRACE_RCU
 	select BINARY_PRINTF
-	select NET_SOCK_MSG if INET
+	select NET_SOCK_MSG if NET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate eBPF
diff --git a/net/core/Makefile b/net/core/Makefile
index f7f16650fe9e..35ced6201814 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -33,8 +33,6 @@ obj-$(CONFIG_HWBM) += hwbm.o
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

