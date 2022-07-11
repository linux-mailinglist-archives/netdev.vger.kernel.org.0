Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C76156D812
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiGKIcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiGKIc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5808C1F2EE
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657528345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M0PhMaVhgVmMUL6iKuE1xZ83zlO0I8KTf8X7DkJEHvo=;
        b=ZhMq6Rst1KsZoQ9tQKDkhobaZgN9f/xluz5h/gd5MuPEZRZH3fSBIgztvcofY4o271lCDY
        B6SPPYhJXMYmWvowvds6oBZoi4nApSlnCAnBQEPAf6iS+PMGKpB6j0QtD4kHzek3bs85/v
        5XlZ3sEKJp6g+0xA605uWOwIrYv1yjg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-8gpMUgCwOzeGFlvL8H0TJw-1; Mon, 11 Jul 2022 04:32:23 -0400
X-MC-Unique: 8gpMUgCwOzeGFlvL8H0TJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F86880418F;
        Mon, 11 Jul 2022 08:32:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09AFF141511A;
        Mon, 11 Jul 2022 08:32:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E7A1D1C0151; Mon, 11 Jul 2022 10:32:21 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [RFC PATCH bpf-next 1/4] bpf: add a sysctl to enable destructive bpf helpers
Date:   Mon, 11 Jul 2022 10:32:17 +0200
Message-Id: <20220711083220.2175036-2-asavkov@redhat.com>
In-Reply-To: <20220711083220.2175036-1-asavkov@redhat.com>
References: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a kernel.destructive_bpf_enabled sysctl knob to allow enabling bpf
helpers that can be destructive to the system. One such helper,
bpf_panic(), is added later in the series.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/bpf.h  |  6 ++++++
 kernel/bpf/syscall.c | 29 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0edd7d2c0064..77972724bed7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1641,6 +1641,7 @@ bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 #endif
 
 extern int sysctl_unprivileged_bpf_disabled;
+extern int sysctl_destructive_bpf_enabled;
 
 static inline bool bpf_allow_ptr_leaks(void)
 {
@@ -1926,6 +1927,11 @@ static inline bool unprivileged_ebpf_enabled(void)
 	return !sysctl_unprivileged_bpf_disabled;
 }
 
+static inline bool destructive_ebpf_enabled(void)
+{
+	return sysctl_destructive_bpf_enabled;
+}
+
 #else /* !CONFIG_BPF_SYSCALL */
 static inline struct bpf_prog *bpf_prog_get(u32 ufd)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7d5af5b99f0d..1ce6541d90e1 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -57,6 +57,8 @@ static DEFINE_SPINLOCK(link_idr_lock);
 int sysctl_unprivileged_bpf_disabled __read_mostly =
 	IS_BUILTIN(CONFIG_BPF_UNPRIV_DEFAULT_OFF) ? 2 : 0;
 
+int sysctl_destructive_bpf_enabled __read_mostly = 0;
+
 static const struct bpf_map_ops * const bpf_map_types[] = {
 #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type)
 #define BPF_MAP_TYPE(_id, _ops) \
@@ -5226,6 +5228,24 @@ static int bpf_unpriv_handler(struct ctl_table *table, int write,
 	return ret;
 }
 
+static int bpf_destructive_handler(struct ctl_table *table, int write,
+				   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, destructive_enable = *(int *)table->data;
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	tmp.data = &destructive_enable;
+	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (write && !ret) {
+		*(int *)table->data = destructive_enable;
+	}
+
+	return ret;
+}
+
 static struct ctl_table bpf_syscall_table[] = {
 	{
 		.procname	= "unprivileged_bpf_disabled",
@@ -5236,6 +5256,15 @@ static struct ctl_table bpf_syscall_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
 	},
+	{
+		.procname	= "destructive_bpf_enabled",
+		.data		= &sysctl_destructive_bpf_enabled,
+		.maxlen		= sizeof(sysctl_destructive_bpf_enabled),
+		.mode		= 0644,
+		.proc_handler	= bpf_destructive_handler,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 	{
 		.procname	= "bpf_stats_enabled",
 		.data		= &bpf_stats_enabled_key.key,
-- 
2.35.3

