Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0312DA19E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503391AbgLNUcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503218AbgLNU3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:29:31 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22568C061793;
        Mon, 14 Dec 2020 12:28:51 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c133so2942861wme.4;
        Mon, 14 Dec 2020 12:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s5TtkV0mS7KbqGw57DfwKnjpwEFdzRpL0gmVdX7TJ30=;
        b=Qkc0FjavRKeSXquLJv6g+2FJd3WvU4dWMqLwgO75VcBr0Cq+uL0fPq/TNxHdgDiuA3
         bydVVuTZbagQlioir8uiQ7JIBNIhYuiuUSzTzkbFdMGb/R2ZqgPblfcFhX7vZNcWkpUg
         mO14cQ3OKrAwCFEg1Sc72Pl5Ldq8owh+yExy0bP6Qkx6teLxels7QSGtaQRURK0HbCCA
         WbwLoZuqK1DhbRsOB4PVUThGbO98TBYEjOtO7tP+95/mIlbKn7efgApJEr4WCFV+DFqu
         nGZ9wrEWpfdQzRUFrlDdJGvdMdtEyREp/lVE1Ck6NITJQL5LjY5H1OLAx/I7x2+6TLiN
         yk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s5TtkV0mS7KbqGw57DfwKnjpwEFdzRpL0gmVdX7TJ30=;
        b=nV6p8T5JXTZ0BH3RQbi21l7iIAWRbiSGwbn6NRWuv03I3/tCIaX/gc7QX9pdpjpLRK
         JjTcs/5JjdLMmhnLqR5Ct5Rir7RMRo6ZDKbAmUiZ4BHhvzz/FD4hUxGd1t8dMM9fYAyW
         yth5v601jzRDWNCMUMusFjDaD9ImvvKsTN5ME5PtTiuHHnnV8NxnwKuz7Cdt7OCyamuO
         +aSjAu0nCKqxgbsdkxfAcRY4IQ/bUXQQkRksc8zIfF/lrfhAbsCU09nQh4+PfNc9dhze
         H5iYtt23SYXY6H9Cxc2C1sGKYp3cfUJo77SYPO6FxkOfPHeozCgNQP5JhZHRpwmGd2WD
         goZA==
X-Gm-Message-State: AOAM532mvlS4NDag14w/mFNKViTLyrdJl+uL3CYdlYTkRMrcu8sGmY7y
        sktxcr7d9JKQi4OGRuEa7xI=
X-Google-Smtp-Source: ABdhPJwUO+/8ikoRNeV4RbZdgMFr3qh+MrXS89fdfRR7gqbL9UM9bL1UTjulcKMZc9JYq5TGthmR9A==
X-Received: by 2002:a7b:c5c6:: with SMTP id n6mr28757700wmk.131.1607977729880;
        Mon, 14 Dec 2020 12:28:49 -0800 (PST)
Received: from localhost.localdomain ([77.137.145.246])
        by smtp.gmail.com with ESMTPSA id r13sm32706175wrs.6.2020.12.14.12.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:28:49 -0800 (PST)
From:   Yonatan Linik <yonatanlinik@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, willemb@google.com,
        john.ogness@linutronix.de, arnd@arndb.de, maowenan@huawei.com,
        colin.king@canonical.com, orcohen@paloaltonetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Yonatan Linik <yonatanlinik@gmail.com>
Subject: [PATCH v2 1/1] net: Fix use of proc_fs
Date:   Mon, 14 Dec 2020 22:25:50 +0200
Message-Id: <20201214202550.3693-2-yonatanlinik@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214202550.3693-1-yonatanlinik@gmail.com>
References: <20201214202550.3693-1-yonatanlinik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_fs was used, in af_packet, without a surrounding #ifdef,
although there is no hard dependency on proc_fs.
That caused the initialization of the af_packet module to fail
when CONFIG_PROC_FS=n.

Specifically, proc_create_net() was used in af_packet.c,
and when it fails, packet_net_init() returns -ENOMEM.
It will always fail when the kernel is compiled without proc_fs,
because, proc_create_net() for example always returns NULL.

The calling order that starts in af_packet.c is as follows:
packet_init()
register_pernet_subsys()
register_pernet_operations()
__register_pernet_operations()
ops_init()
ops->init() (packet_net_ops.init=packet_net_init())
proc_create_net()

It worked in the past because register_pernet_subsys()'s return value
wasn't checked before this Commit 36096f2f4fa0 ("packet: Fix error path in
packet_init.").
It always returned an error, but was not checked before, so everything
was working even when CONFIG_PROC_FS=n.

The fix here is simply to add the necessary #ifdef.

This also fixes a similar error in tls_proc.c, that was found by Jakub
Kicinski.

Signed-off-by: Yonatan Linik <yonatanlinik@gmail.com>
---
 net/packet/af_packet.c | 2 ++
 net/tls/tls_proc.c     | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2b33e977a905..031f2b593720 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4612,9 +4612,11 @@ static int __net_init packet_net_init(struct net *net)
 	mutex_init(&net->packet.sklist_lock);
 	INIT_HLIST_HEAD(&net->packet.sklist);
 
+#ifdef CONFIG_PROC_FS
 	if (!proc_create_net("packet", 0, net->proc_net, &packet_seq_ops,
 			sizeof(struct seq_net_private)))
 		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
 
 	return 0;
 }
diff --git a/net/tls/tls_proc.c b/net/tls/tls_proc.c
index 3a5dd1e07233..feeceb0e4cb4 100644
--- a/net/tls/tls_proc.c
+++ b/net/tls/tls_proc.c
@@ -37,9 +37,12 @@ static int tls_statistics_seq_show(struct seq_file *seq, void *v)
 
 int __net_init tls_proc_init(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	if (!proc_create_net_single("tls_stat", 0444, net->proc_net,
 				    tls_statistics_seq_show, NULL))
 		return -ENOMEM;
+#endif /* CONFIG_PROC_FS */
+
 	return 0;
 }
 
-- 
2.25.1

