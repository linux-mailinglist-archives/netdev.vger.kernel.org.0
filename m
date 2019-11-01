Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F4ECBD0
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbfKAXTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:19:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:50454 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKAXS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:18:59 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQgC0-0000Sj-7X; Sat, 02 Nov 2019 00:18:56 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        john.fastabend@gmail.com, Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 3/8] bpf: Make use of probe_user_write in probe write helper
Date:   Sat,  2 Nov 2019 00:17:58 +0100
Message-Id: <841c461781874c07a0ee404a454c3bc0459eed30.1572649915.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572649915.git.daniel@iogearbox.net>
References: <cover.1572649915.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25620/Fri Nov  1 10:04:15 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the bpf_probe_write_user() helper to probe_user_write() such that
writes are not attempted under KERNEL_DS anymore which is buggy as kernel
and user space pointers can have overlapping addresses. Also, given we have
the access_ok() check inside probe_user_write(), the helper doesn't need
to do it twice.

Fixes: 96ae52279594 ("bpf: Add bpf_probe_write_user BPF helper to be called in tracers")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/trace/bpf_trace.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 571c25d60710..91eb17ac4bb6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -163,7 +163,7 @@ static const struct bpf_func_proto bpf_probe_read_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
+BPF_CALL_3(bpf_probe_write_user, void __user *, unsafe_ptr, const void *, src,
 	   u32, size)
 {
 	/*
@@ -186,10 +186,8 @@ BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
-	if (!access_ok(unsafe_ptr, size))
-		return -EPERM;
 
-	return probe_kernel_write(unsafe_ptr, src, size);
+	return probe_user_write(unsafe_ptr, src, size);
 }
 
 static const struct bpf_func_proto bpf_probe_write_user_proto = {
-- 
2.21.0

