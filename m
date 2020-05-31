Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC2D1E98A0
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgEaPnH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 31 May 2020 11:43:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26407 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725912AbgEaPnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 11:43:07 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-IWvaN8SJPfK3fXoaof0uiw-1; Sun, 31 May 2020 11:43:01 -0400
X-MC-Unique: IWvaN8SJPfK3fXoaof0uiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A879107ACCA;
        Sun, 31 May 2020 15:42:59 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65A465D9C5;
        Sun, 31 May 2020 15:42:56 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     KP Singh <kpsingh@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf: Use tracing helpers for lsm programs
Date:   Sun, 31 May 2020 17:42:55 +0200
Message-Id: <20200531154255.896551-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currenty lsm uses bpf_tracing_func_proto helpers which do
not include stack trace or perf event output. It's useful
to have those for bpftrace lsm support [1].

Using tracing_prog_func_proto helpers for lsm programs.

[1] https://github.com/iovisor/bpftrace/pull/1347

Cc: KP Singh <kpsingh@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/bpf.h      | 3 +++
 kernel/bpf/bpf_lsm.c     | 2 +-
 kernel/trace/bpf_trace.c | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e5884f7f801c..caa26ab471e8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1628,6 +1628,9 @@ extern const struct bpf_func_proto bpf_ringbuf_query_proto;
 const struct bpf_func_proto *bpf_tracing_func_proto(
 	enum bpf_func_id func_id, const struct bpf_prog *prog);
 
+const struct bpf_func_proto *tracing_prog_func_proto(
+  enum bpf_func_id func_id, const struct bpf_prog *prog);
+
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
 u64 bpf_user_rnd_u32(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 19636703b24e..fb278144e9fd 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -49,6 +49,6 @@ const struct bpf_prog_ops lsm_prog_ops = {
 };
 
 const struct bpf_verifier_ops lsm_verifier_ops = {
-	.get_func_proto = bpf_tracing_func_proto,
+	.get_func_proto = tracing_prog_func_proto,
 	.is_valid_access = btf_ctx_access,
 };
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 3767d34114c0..794d665bebdd 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1467,7 +1467,7 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
-static const struct bpf_func_proto *
+const struct bpf_func_proto *
 tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
-- 
2.25.4

