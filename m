Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DFA3BAE7F
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 21:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhGDTFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 15:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhGDTFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 15:05:44 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCC1C061574;
        Sun,  4 Jul 2021 12:03:07 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id 22so18269445oix.10;
        Sun, 04 Jul 2021 12:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktDwkxpWX1PDRrl3kwSRTRRMg4ZY2q/mmstA372ZLXU=;
        b=h0h3xp8ldliYPmAdPJvwaR+I4ALGB+xTFl+q4xi26RpB1q4MJxYC2baLQuzMIDxlCD
         dIP0Lc305WJ4cIca3QTlrQQErPQCMtH3BtMuumwn2vqjCZFEp0PIEWEtoQw4m1SbhQ4e
         cSfjnVRoYiYJ+s6eIWLog2HHyyVp+4cCn0I6pQcIa8cozK5XwgwbWyBWPQHWIc8krPr/
         s+h91/vB30NZuiNDc1No6MWnIWAGvklzJbTdG7INu7d035FviHpcS07+Axw1tOoo9xhD
         eNazQVIimiiJKdipMWy9Y7bo96TB8MKZaOgAGm+6pwjMNo5dCkSkld+9Vali7uNzSamf
         zZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktDwkxpWX1PDRrl3kwSRTRRMg4ZY2q/mmstA372ZLXU=;
        b=BEJPRj8hisS+2ReVT2/rqsAdgo7N9ySoZakwRZv+m5OVlKuOBKjPYnIuOT00g0QjF+
         nzYuF4sSDMaeltEKt+rB5kd4EzAL2rnDFJfDiyP/iAQAxX9j6QPFvXujUdylJdNnIQhi
         mSn+0ttXg+q/lqOLjoZZIa4JT18FF16MGv/CBbYzGXca8z1feRjVhVt5fZlLeDpfryTv
         62foIoQABH0PxR4CbQrHgyNr+D8tlsPgXrHOzFEOYSiRmD/9rHJeyeJPVjecDvUOcsKU
         mLOCYBXt0dLm/WGqUIsQXbetOC9gTFYx0Gn//zsye5GEjMnOwfjGwsVgzcwf8UAvRbiD
         tP2A==
X-Gm-Message-State: AOAM532uHXi+3N+oDDJ9EJbbhook7qzcbPL3EfbgVnnf3Yb4AtrV+eDR
        yNOnpVEqZMGD6B6X2VOoOZcfrMf7VIU=
X-Google-Smtp-Source: ABdhPJzW/9vIlabJgy8IzJh/UiwmfI0kLYkiz65fmnCHvzdvR8jKZjDKrUUrXAs6VWJPAjhBIUKCvw==
X-Received: by 2002:a54:4013:: with SMTP id x19mr7746419oie.136.1625425387124;
        Sun, 04 Jul 2021 12:03:07 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id 186sm1865848ooe.28.2021.07.04.12.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 12:03:06 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v5 01/11] sock_map: relax config dependency to CONFIG_NET
Date:   Sun,  4 Jul 2021 12:02:42 -0700
Message-Id: <20210704190252.11866-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sock_map still has Kconfig dependency on CONFIG_INET,
but there is no actual functional dependency on it after we
introduce ->psock_update_sk_prot().

We have to extend it to CONFIG_NET now as we are going to
support AF_UNIX.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/bpf.h | 38 ++++++++++++++++++++------------------
 kernel/bpf/Kconfig  |  2 +-
 net/core/Makefile   |  2 --
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index f309fc1509f2..401a6908ed3f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1851,6 +1851,12 @@ void bpf_map_offload_map_free(struct bpf_map *map);
 int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 			      const union bpf_attr *kattr,
 			      union bpf_attr __user *uattr);
+
+int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog);
+int sock_map_prog_detach(const union bpf_attr *attr, enum bpf_prog_type ptype);
+int sock_map_update_elem_sys(struct bpf_map *map, void *key, void *value, u64 flags);
+void sock_map_unhash(struct sock *sk);
+void sock_map_close(struct sock *sk, long timeout);
 #else
 static inline int bpf_prog_offload_init(struct bpf_prog *prog,
 					union bpf_attr *attr)
@@ -1883,24 +1889,6 @@ static inline int bpf_prog_test_run_syscall(struct bpf_prog *prog,
 {
 	return -ENOTSUPP;
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
@@ -1920,7 +1908,21 @@ static inline int sock_map_update_elem_sys(struct bpf_map *map, void *key, void
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
diff --git a/kernel/bpf/Kconfig b/kernel/bpf/Kconfig
index bd04f4a44c01..a82d6de86522 100644
--- a/kernel/bpf/Kconfig
+++ b/kernel/bpf/Kconfig
@@ -29,7 +29,7 @@ config BPF_SYSCALL
 	select IRQ_WORK
 	select TASKS_TRACE_RCU
 	select BINARY_PRINTF
-	select NET_SOCK_MSG if INET
+	select NET_SOCK_MSG if NET
 	default n
 	help
 	  Enable the bpf() system call that allows to manipulate BPF programs
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
2.27.0

