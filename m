Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18190E515D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633092AbfJYQhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:37:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:52474 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2633053AbfJYQhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:37:21 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO2aV-0003ax-TR; Fri, 25 Oct 2019 18:37:19 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 4/5] bpf, samples: Use bpf_probe_read_user where appropriate
Date:   Fri, 25 Oct 2019 18:37:10 +0200
Message-Id: <d4ed775a802df0df6aeee84537bb9b3cad32746d.1572010897.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572010897.git.daniel@iogearbox.net>
References: <cover.1572010897.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bpf_probe_read_user() helper instead of bpf_probe_read() for samples that
attach to kprobes probing on user addresses.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 samples/bpf/map_perf_test_kern.c         | 4 ++--
 samples/bpf/test_map_in_map_kern.c       | 4 ++--
 samples/bpf/test_probe_write_user_kern.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/map_perf_test_kern.c b/samples/bpf/map_perf_test_kern.c
index 5c11aefbc489..281bcdaee58e 100644
--- a/samples/bpf/map_perf_test_kern.c
+++ b/samples/bpf/map_perf_test_kern.c
@@ -181,8 +181,8 @@ int stress_lru_hmap_alloc(struct pt_regs *ctx)
 	if (addrlen != sizeof(*in6))
 		return 0;
 
-	ret = bpf_probe_read(test_params.dst6, sizeof(test_params.dst6),
-			     &in6->sin6_addr);
+	ret = bpf_probe_read_user(test_params.dst6, sizeof(test_params.dst6),
+				  &in6->sin6_addr);
 	if (ret)
 		goto done;
 
diff --git a/samples/bpf/test_map_in_map_kern.c b/samples/bpf/test_map_in_map_kern.c
index 4f80cbe74c72..32ee752f19df 100644
--- a/samples/bpf/test_map_in_map_kern.c
+++ b/samples/bpf/test_map_in_map_kern.c
@@ -118,7 +118,7 @@ int trace_sys_connect(struct pt_regs *ctx)
 	if (addrlen != sizeof(*in6))
 		return 0;
 
-	ret = bpf_probe_read(dst6, sizeof(dst6), &in6->sin6_addr);
+	ret = bpf_probe_read_user(dst6, sizeof(dst6), &in6->sin6_addr);
 	if (ret) {
 		inline_ret = ret;
 		goto done;
@@ -129,7 +129,7 @@ int trace_sys_connect(struct pt_regs *ctx)
 
 	test_case = dst6[7];
 
-	ret = bpf_probe_read(&port, sizeof(port), &in6->sin6_port);
+	ret = bpf_probe_read_user(&port, sizeof(port), &in6->sin6_port);
 	if (ret) {
 		inline_ret = ret;
 		goto done;
diff --git a/samples/bpf/test_probe_write_user_kern.c b/samples/bpf/test_probe_write_user_kern.c
index a543358218e6..b7c48f37132c 100644
--- a/samples/bpf/test_probe_write_user_kern.c
+++ b/samples/bpf/test_probe_write_user_kern.c
@@ -37,7 +37,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	if (sockaddr_len > sizeof(orig_addr))
 		return 0;
 
-	if (bpf_probe_read(&orig_addr, sizeof(orig_addr), sockaddr_arg) != 0)
+	if (bpf_probe_read_user(&orig_addr, sizeof(orig_addr), sockaddr_arg) != 0)
 		return 0;
 
 	mapped_addr = bpf_map_lookup_elem(&dnat_map, &orig_addr);
-- 
2.21.0

