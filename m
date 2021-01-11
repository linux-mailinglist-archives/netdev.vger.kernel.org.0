Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CCF2F24F3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405378AbhALAZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:41996 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403813AbhAKXK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:10:27 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kz6Jl-000Dkk-D8; Tue, 12 Jan 2021 00:09:45 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     yhs@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 2/2] bpf: extend bind v4/v6 selftests for mark/prio/bindtoifindex
Date:   Tue, 12 Jan 2021 00:09:40 +0100
Message-Id: <384fdc90e5fa83f8335a37aa90fa2f5f3661929c.1610406333.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cba44439b801e5ddc1170e5be787f4dc93a2d7f9.1610406333.git.daniel@iogearbox.net>
References: <cba44439b801e5ddc1170e5be787f4dc93a2d7f9.1610406333.git.daniel@iogearbox.net>
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
Acked-by: Yonghong Song <yhs@fb.com>
---
 v1 -> v2: - Add comment on old vs new optval (Yonghong), rest as-is

 .../testing/selftests/bpf/progs/bind4_prog.c  | 42 +++++++++++++++++--
 .../testing/selftests/bpf/progs/bind6_prog.c  | 42 +++++++++++++++++--
 2 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
index c6520f21f5f5..115a3b0ad984 100644
--- a/tools/testing/selftests/bpf/progs/bind4_prog.c
+++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
@@ -29,18 +29,48 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
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
+	/* Socket in test case has guarantee that old never equals to new. */
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
@@ -93,6 +123,10 @@ int bind_v4_prog(struct bpf_sock_addr *ctx)
 	if (bind_to_device(ctx))
 		return 0;
 
+	/* Test for misc socket options. */
+	if (misc_opts(ctx, SO_MARK) || misc_opts(ctx, SO_PRIORITY))
+		return 0;
+
 	ctx->user_ip4 = bpf_htonl(SERV4_REWRITE_IP);
 	ctx->user_port = bpf_htons(SERV4_REWRITE_PORT);
 
diff --git a/tools/testing/selftests/bpf/progs/bind6_prog.c b/tools/testing/selftests/bpf/progs/bind6_prog.c
index 4358e44dcf47..4c0d348034b9 100644
--- a/tools/testing/selftests/bpf/progs/bind6_prog.c
+++ b/tools/testing/selftests/bpf/progs/bind6_prog.c
@@ -35,18 +35,48 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
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
+	/* Socket in test case has guarantee that old never equals to new. */
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
@@ -107,6 +137,10 @@ int bind_v6_prog(struct bpf_sock_addr *ctx)
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

