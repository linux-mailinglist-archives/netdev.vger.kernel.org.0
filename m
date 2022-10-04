Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C145F4C86
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJDXMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJDXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:12:12 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAC4564FB;
        Tue,  4 Oct 2022 16:12:11 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofr58-000AJh-5T; Wed, 05 Oct 2022 01:12:10 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     razor@blackwall.org, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 07/10] libbpf: Add extended attach/detach opts
Date:   Wed,  5 Oct 2022 01:11:40 +0200
Message-Id: <20221004231143.19190-8-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221004231143.19190-1-daniel@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26679/Tue Oct  4 09:56:50 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend libbpf attach opts and add a new detach opts API so this can be used
to add/remove fd-based tc BPF programs. For concrete usage examples, see the
extensive selftests that have been developed as part of this series.

Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/bpf.c      | 21 +++++++++++++++++++++
 tools/lib/bpf/bpf.h      | 17 +++++++++++++++--
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 18b1e91cc469..d1e338ac9a62 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -670,6 +670,27 @@ int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
 	return libbpf_err_errno(ret);
 }
 
+int bpf_prog_detach_opts(int prog_fd, int target_fd,
+			 enum bpf_attach_type type,
+			 const struct bpf_prog_detach_opts *opts)
+{
+	const size_t attr_sz = offsetofend(union bpf_attr, replace_bpf_fd);
+	union bpf_attr attr;
+	int ret;
+
+	if (!OPTS_VALID(opts, bpf_prog_detach_opts))
+		return libbpf_err(-EINVAL);
+
+	memset(&attr, 0, attr_sz);
+	attr.target_fd	   = target_fd;
+	attr.attach_bpf_fd = prog_fd;
+	attr.attach_type   = type;
+	attr.attach_priority = OPTS_GET(opts, attach_priority, 0);
+
+	ret = sys_bpf(BPF_PROG_DETACH, &attr, attr_sz);
+	return libbpf_err_errno(ret);
+}
+
 int bpf_link_create(int prog_fd, int target_fd,
 		    enum bpf_attach_type attach_type,
 		    const struct bpf_link_create_opts *opts)
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index bef7a5282188..96de58fecdbc 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -286,8 +286,11 @@ LIBBPF_API int bpf_obj_get_opts(const char *pathname,
 
 struct bpf_prog_attach_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
-	unsigned int flags;
-	int replace_prog_fd;
+	__u32 flags;
+	union {
+		int replace_prog_fd;
+		__u32 attach_priority;
+	};
 };
 #define bpf_prog_attach_opts__last_field replace_prog_fd
 
@@ -296,9 +299,19 @@ LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
 LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int attachable_fd,
 				     enum bpf_attach_type type,
 				     const struct bpf_prog_attach_opts *opts);
+
+struct bpf_prog_detach_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 attach_priority;
+};
+#define bpf_prog_detach_opts__last_field attach_priority
+
 LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
+LIBBPF_API int bpf_prog_detach_opts(int prog_fd, int target_fd,
+				    enum bpf_attach_type type,
+				    const struct bpf_prog_detach_opts *opts);
 
 union bpf_iter_link_info; /* defined in up-to-date linux/bpf.h */
 struct bpf_link_create_opts {
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index c1d6aa7c82b6..0c94b4862ebb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -377,4 +377,5 @@ LIBBPF_1.1.0 {
 		user_ring_buffer__reserve;
 		user_ring_buffer__reserve_blocking;
 		user_ring_buffer__submit;
+		bpf_prog_detach_opts;
 } LIBBPF_1.0.0;
-- 
2.34.1

