Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C2E4A990
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730254AbfFRSMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:12:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:46954 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbfFRSMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:12:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFC64AFEF;
        Tue, 18 Jun 2019 18:12:33 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] samples: bpf: Remove bpf_debug macro in favor of bpf_printk
Date:   Tue, 18 Jun 2019 20:13:18 +0200
Message-Id: <20190618181338.24145-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ibumad example was implementing the bpf_debug macro which is exactly the
same as the bpf_printk macro available in bpf_helpers.h. This change
makes use of bpf_printk instead of bpf_debug.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 samples/bpf/ibumad_kern.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
index 38b2b3f22049..f281df7e0089 100644
--- a/samples/bpf/ibumad_kern.c
+++ b/samples/bpf/ibumad_kern.c
@@ -31,15 +31,9 @@ struct bpf_map_def SEC("maps") write_count = {
 };
 
 #undef DEBUG
-#ifdef DEBUG
-#define bpf_debug(fmt, ...)                         \
-({                                                  \
-	char ____fmt[] = fmt;                       \
-	bpf_trace_printk(____fmt, sizeof(____fmt),  \
-			 ##__VA_ARGS__);            \
-})
-#else
-#define bpf_debug(fmt, ...)
+#ifndef DEBUG
+#undef bpf_printk
+#define bpf_printk(fmt, ...)
 #endif
 
 /* Taken from the current format defined in
@@ -86,7 +80,7 @@ int on_ib_umad_read_recv(struct ib_umad_rw_args *ctx)
 	u64 zero = 0, *val;
 	u8 class = ctx->mgmt_class;
 
-	bpf_debug("ib_umad read recv : class 0x%x\n", class);
+	bpf_printk("ib_umad read recv : class 0x%x\n", class);
 
 	val = bpf_map_lookup_elem(&read_count, &class);
 	if (!val) {
@@ -106,7 +100,7 @@ int on_ib_umad_read_send(struct ib_umad_rw_args *ctx)
 	u64 zero = 0, *val;
 	u8 class = ctx->mgmt_class;
 
-	bpf_debug("ib_umad read send : class 0x%x\n", class);
+	bpf_printk("ib_umad read send : class 0x%x\n", class);
 
 	val = bpf_map_lookup_elem(&read_count, &class);
 	if (!val) {
@@ -126,7 +120,7 @@ int on_ib_umad_write(struct ib_umad_rw_args *ctx)
 	u64 zero = 0, *val;
 	u8 class = ctx->mgmt_class;
 
-	bpf_debug("ib_umad write : class 0x%x\n", class);
+	bpf_printk("ib_umad write : class 0x%x\n", class);
 
 	val = bpf_map_lookup_elem(&write_count, &class);
 	if (!val) {
-- 
2.21.0

