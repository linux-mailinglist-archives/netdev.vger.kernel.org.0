Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A1F3F3797
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhHUAVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240825AbhHUAVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6276C0617AD;
        Fri, 20 Aug 2021 17:20:38 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n18so10807557pgm.12;
        Fri, 20 Aug 2021 17:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/k59waAv7azm4aDBEdsFzVTkf14w3cd1OyHyXcQOW8=;
        b=BA/aWS3Vt8IM4MOx0RdE6bp1MWdhfnQT5/9QN52xpSSQpAAgwDg8sm2PQJk/v/kqzT
         bKPOTiX6kCtMBx0q/qz3F2UCYwwaBwen9NewPwOx5tM99niYBoKJGR0B/lHI64v0XNbp
         ZLW4I/8+KRhwughmVzKSJ8MYmZxCAvA6vhasLgB2ABWAj2YCipvL8GAp9rkG4a2TLule
         njvJOyW1S3K81stMWyj6VjhhfcEBdraF3Sip88b0c5NHdmqpzQNHEd8ISmu22q1mWJqW
         UbWUHcN9m/mNCzhGij6YLCTUPbAImcFiqsD4HN66sPrG0QLgyZPKd3CZB2F7kJhbiiVk
         QFNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/k59waAv7azm4aDBEdsFzVTkf14w3cd1OyHyXcQOW8=;
        b=e1BYGJpEaDmzmzDF6djpKcCY4PJxMNLj1/Ks+sVsM34FrrN8S9PCX9jVfslXzUtTC2
         jAD+DfKu25wDNhXuSOb02ztb8QQLYhiwJYEXIKTi/UQzgUqEj8QMM+jCpIcK2Vv6+cDZ
         9CnjQckfLGrWfiZGtGg2rolXJGyDi73Exhxg9obZuJr3YPtOwV/uCpQHVGwT5RY/KAwd
         Vs9GfNUhujk/tLNbIWh3HiEnJUJCF3eGJbWxW6SE72nd9FADcCTm24wvvUE8OWrzG84P
         zozXjr44bm4bJS6ztbdVfAA1/tVYlUgfBstjvfcmEvE9/ZIsrfZNCrcfPo91og9ezr1U
         taAg==
X-Gm-Message-State: AOAM531TS8cLbctWMdTHxmeVMfrS7p3Cxw41C/Wdonk2Fuok1HzZ9QWP
        hVXGPjxaIRXxb/aLQ0eXerUrylaQgHM=
X-Google-Smtp-Source: ABdhPJzFdBOqD5ZlgCbXjxXgMPRb7tl7p3vy4rWmNiqBF1BRup5NbDaNsGLtm7MBg3h+JqG4JTEy+Q==
X-Received: by 2002:a63:db4a:: with SMTP id x10mr7227544pgi.30.1629505238109;
        Fri, 20 Aug 2021 17:20:38 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id u11sm7758198pfk.100.2021.08.20.17.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:37 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 08/22] samples: bpf: Add BPF support for cpumap tracepoints
Date:   Sat, 21 Aug 2021 05:49:56 +0530
Message-Id: <20210821002010.845777-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are invoked in two places, when the XDP frame or SKB (for generic
XDP) enqueued to the ptr_ring (cpumap_enqueue) and when kthread processes
the frame after invoking the CPUMAP program for it (returning stats for
the batch).

We use cpumap_map_id to filter on the map_id as a way to avoid printing
incorrect stats for parallel sessions of xdp_redirect_cpu.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample.bpf.c | 58 +++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
index 53ab5a972405..f01a5529751c 100644
--- a/samples/bpf/xdp_sample.bpf.c
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -8,6 +8,8 @@
 
 array_map rx_cnt SEC(".maps");
 array_map redir_err_cnt SEC(".maps");
+array_map cpumap_enqueue_cnt SEC(".maps");
+array_map cpumap_kthread_cnt SEC(".maps");
 array_map exception_cnt SEC(".maps");
 
 const volatile int nr_cpus = 0;
@@ -19,6 +21,8 @@ const volatile int nr_cpus = 0;
 const volatile int from_match[32] = {};
 const volatile int to_match[32] = {};
 
+int cpumap_map_id = 0;
+
 /* Find if b is part of set a, but if a is empty set then evaluate to true */
 #define IN_SET(a, b)                                                 \
 	({                                                           \
@@ -112,6 +116,59 @@ int BPF_PROG(tp_xdp_redirect_map, const struct net_device *dev,
 	return xdp_redirect_collect_stat(dev->ifindex, err);
 }
 
+SEC("tp_btf/xdp_cpumap_enqueue")
+int BPF_PROG(tp_xdp_cpumap_enqueue, int map_id, unsigned int processed,
+	     unsigned int drops, int to_cpu)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 idx;
+
+	if (cpumap_map_id && cpumap_map_id != map_id)
+		return 0;
+
+	idx = to_cpu * nr_cpus + cpu;
+	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &idx);
+	if (!rec)
+		return 0;
+	NO_TEAR_ADD(rec->processed, processed);
+	NO_TEAR_ADD(rec->dropped, drops);
+	/* Record bulk events, then userspace can calc average bulk size */
+	if (processed > 0)
+		NO_TEAR_INC(rec->issue);
+	/* Inception: It's possible to detect overload situations, via
+	 * this tracepoint.  This can be used for creating a feedback
+	 * loop to XDP, which can take appropriate actions to mitigate
+	 * this overload situation.
+	 */
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_kthread")
+int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
+	     unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
+{
+	struct datarec *rec;
+	u32 cpu;
+
+	if (cpumap_map_id && cpumap_map_id != map_id)
+		return 0;
+
+	cpu = bpf_get_smp_processor_id();
+	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &cpu);
+	if (!rec)
+		return 0;
+	NO_TEAR_ADD(rec->processed, processed);
+	NO_TEAR_ADD(rec->dropped, drops);
+	NO_TEAR_ADD(rec->xdp_pass, xdp_stats->pass);
+	NO_TEAR_ADD(rec->xdp_drop, xdp_stats->drop);
+	NO_TEAR_ADD(rec->xdp_redirect, xdp_stats->redirect);
+	/* Count times kthread yielded CPU via schedule call */
+	if (sched)
+		NO_TEAR_INC(rec->issue);
+	return 0;
+}
+
 SEC("tp_btf/xdp_exception")
 int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
 	     const struct bpf_prog *xdp, u32 act)
@@ -136,4 +193,3 @@ int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
 
 	return 0;
 }
-
-- 
2.33.0

