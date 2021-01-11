Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B4E2F1AC0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388800AbhAKQSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:18:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:40592 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732375AbhAKQSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:18:37 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kyztC-000CTg-29; Mon, 11 Jan 2021 17:17:54 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     yhs@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next 2/2] bpf: extend bind v4/v6 selftests for mark/prio/bindtoifindex
Date:   Mon, 11 Jan 2021 17:17:42 +0100
Message-Id: <299c73acafd2c20d52624debb8a1e0019d85e6dd.1610381606.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
References: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26046/Mon Jan 11 13:34:14 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend existing cgroup bind4/bind6 tests to add coverage for setting and
retrieving SO_MARK, SO_PRIORITY and SO_BINDTOIFINDEX at the bind hook.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../testing/selftests/bpf/progs/bind4_prog.c  | 41 +++++++++++++++++--
 .../testing/selftests/bpf/progs/bind6_prog.c  | 41 +++++++++++++++++--
 2 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
index c6520f21f5f5..4479ac27b1d3 100644
--- a/tools/testing/selftests/bpf/progs/bind4_prog.c
+++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
@@ -29,18 +29,47 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
 	char veth2[IFNAMSIZ] = "test_sock_addr2";
 	char missing[IFNAMSIZ] = "nonexistent_dev";
 	char del_bind[IFNAMSIZ] = "";
+	int veth1_idx, veth2_idx;
 
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&veth1, sizeof(veth1)))
+			   &veth1, sizeof(veth1)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth1_idx, sizeof(veth1_idx)) || !veth1_idx)
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&veth2, sizeof(veth2)))
+			   &veth2, sizeof(veth2)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth2_idx, sizeof(veth2_idx)) || !veth2_idx ||
+	    veth1_idx == veth2_idx)
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&missing, sizeof(missing)) != -ENODEV)
+			   &missing, sizeof(missing)) != -ENODEV)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth1_idx, sizeof(veth1_idx)))
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&del_bind, sizeof(del_bind)))
+			   &del_bind, sizeof(del_bind)))
+		return 1;
+
+	return 0;
+}
+
+static __inline int misc_opts(struct bpf_sock_addr *ctx, int opt)
+{
+	int old, tmp, new = 0xeb9f;
+
+	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)) ||
+	    old == new)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &new, sizeof(new)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &tmp, sizeof(tmp)) ||
+	    tmp != new)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)))
 		return 1;
 
 	return 0;
@@ -93,6 +122,10 @@ int bind_v4_prog(struct bpf_sock_addr *ctx)
 	if (bind_to_device(ctx))
 		return 0;
 
+	/* Test for misc socket options. */
+	if (misc_opts(ctx, SO_MARK) || misc_opts(ctx, SO_PRIORITY))
+		return 0;
+
 	ctx->user_ip4 = bpf_htonl(SERV4_REWRITE_IP);
 	ctx->user_port = bpf_htons(SERV4_REWRITE_PORT);
 
diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
index 4358e44dcf47..1b4142fcdd4b 100644
--- a/tools/testing/selftests/bpf/progs/bind6_prog.c
+++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
@@ -35,18 +35,47 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
 	char veth2[IFNAMSIZ] = "test_sock_addr2";
 	char missing[IFNAMSIZ] = "nonexistent_dev";
 	char del_bind[IFNAMSIZ] = "";
+	int veth1_idx, veth2_idx;
 
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&veth1, sizeof(veth1)))
+			   &veth1, sizeof(veth1)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth1_idx, sizeof(veth1_idx)) || !veth1_idx)
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&veth2, sizeof(veth2)))
+			   &veth2, sizeof(veth2)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth2_idx, sizeof(veth2_idx)) || !veth2_idx ||
+	    veth1_idx == veth2_idx)
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&missing, sizeof(missing)) != -ENODEV)
+			   &missing, sizeof(missing)) != -ENODEV)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
+			   &veth1_idx, sizeof(veth1_idx)))
 		return 1;
 	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
-				&del_bind, sizeof(del_bind)))
+			   &del_bind, sizeof(del_bind)))
+		return 1;
+
+	return 0;
+}
+
+static __inline int misc_opts(struct bpf_sock_addr *ctx, int opt)
+{
+	int old, tmp, new = 0xeb9f;
+
+	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)) ||
+	    old == new)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &new, sizeof(new)))
+		return 1;
+	if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &tmp, sizeof(tmp)) ||
+	    tmp != new)
+		return 1;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)))
 		return 1;
 
 	return 0;
@@ -107,6 +136,10 @@ int bind_v6_prog(struct bpf_sock_addr *ctx)
 	if (bind_to_device(ctx))
 		return 0;
 
+	/* Test for misc socket options. */
+	if (misc_opts(ctx, SO_MARK) || misc_opts(ctx, SO_PRIORITY))
+		return 0;
+
 	ctx->user_ip6[0] = bpf_htonl(SERV6_REWRITE_IP_0);
 	ctx->user_ip6[1] = bpf_htonl(SERV6_REWRITE_IP_1);
 	ctx->user_ip6[2] = bpf_htonl(SERV6_REWRITE_IP_2);
-- 
2.21.0

