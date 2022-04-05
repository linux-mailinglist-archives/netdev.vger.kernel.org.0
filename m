Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491144F5383
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiDFE0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577691AbiDEXMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:12:40 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AC8FD6FF
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 14:44:23 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb4f03f212so4904167b3.2
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 14:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KBjl56TVtVd7q+bYPsHoA+X4J5WyYi1pwYLGq1N+s4o=;
        b=ERO6H3mMb0t5cYLJbv98Jw3M7LEmMVB6vS1qNi3MeE78zpoxgWfFVN965G9bS/e2FU
         TU09/OndI4iQc+UddELgFpu1lij+wsREJPfwlybTPnv73IIptyzp//TAE7C6zLVZjnnD
         HSzMGQiBrS32nuMUUlXaoNpiA1QNRSuCWwpZvPbA4ByUhF2Ecbdc01XcIbcBWJLCwafB
         VKA1uEmJdXKD8dCQMNuyvqPISukoG7HiCeGb4OIj8vKqDlrBp+RzMWTS7lH/d4BEpzbN
         Zz9Jq5TYMIuO3W0PBJRvtjS8BFS7b2C7yGr0jcIjqzMPGtG3UkMtpr9TDLvPtGIW2xeb
         lYIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KBjl56TVtVd7q+bYPsHoA+X4J5WyYi1pwYLGq1N+s4o=;
        b=Glu6FPuMhKzn/5nC8tYKea1gpNzGZbjA72Ec9FUm5I6huHnD01rB0orFdR1Xx5fcZf
         +og4xRCZkMVEjeppglJQQt7tAdtOwsGXIQGJ6io2+Isu+PGBiwVh9SuSUAJNTJssnPgC
         84eo8NR3FrZGm3Of8KOoq1dxJ1jxAgn6nfOY3Q5YL/gIhThSENENgwgZcyL4p7ksFKDv
         O82GwkjaConwwyI9JrRwNt09P2gAIRxdG2KDFzE8xkADUB7STr2R3xoNxdJBf329OmWe
         mKzXWf8k+eTKaN7vse9ajDV1L/5Jp0/OBINcUuQDxEpwgKx8+lEnJbam7Jk3Cz0unc+Y
         RT0A==
X-Gm-Message-State: AOAM533UeG+fx8xDofiiVDPDlwxu/ozqJ2ew38tJA9WGySC488vM2mPQ
        fEimpNlExqBq2mpePboqXvO5x3fqAc0U2/tnmXD61DBezOWtRog5YmnTfTFd8BvKlzPg8sYQArG
        cuRxX6mW9p5FZZ8QGwabsboRCE0EeITB5EF5jjb0ceMCAQAlED1yBBA==
X-Google-Smtp-Source: ABdhPJwgLv3CzySA5O5G95jbcm/6EQ9BPEmCkHfA7L/HPrFD/TLmPVEt68gprqKaW4ODffTEtw79jeE=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:73b5:ffab:2024:2901])
 (user=sdf job=sendgmr) by 2002:a25:9b85:0:b0:63d:ad6c:aae8 with SMTP id
 v5-20020a259b85000000b0063dad6caae8mr4011205ybo.609.1649195039993; Tue, 05
 Apr 2022 14:43:59 -0700 (PDT)
Date:   Tue,  5 Apr 2022 14:43:41 -0700
In-Reply-To: <20220405214342.1968262-1-sdf@google.com>
Message-Id: <20220405214342.1968262-7-sdf@google.com>
Mime-Version: 1.0
References: <20220405214342.1968262-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH bpf-next v2 6/7] selftests/bpf: lsm_cgroup functional test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functional test that exercises the following:

1. apply default sk_priority policy
2. permit TX-only AF_PACKET socket
3. cgroup attach/detach/replace
4. reusing trampoline shim

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/lsm_cgroup.c     | 158 ++++++++++++++++++
 .../testing/selftests/bpf/progs/lsm_cgroup.c  |  94 +++++++++++
 2 files changed, 252 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
new file mode 100644
index 000000000000..e786b63d81e2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <test_progs.h>
+
+#include "lsm_cgroup.skel.h"
+#include "cgroup_helpers.h"
+
+void test_lsm_cgroup(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_prog_attach_opts, attach_opts);
+	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
+	int cgroup_fd, cgroup_fd2, err, fd, prio;
+	struct lsm_cgroup *skel = NULL;
+	int post_create_prog_fd2 = -1;
+	int post_create_prog_fd = -1;
+	int bind_link_fd2 = -1;
+	int bind_prog_fd2 = -1;
+	int alloc_prog_fd = -1;
+	int bind_prog_fd = -1;
+	int bind_link_fd = -1;
+	socklen_t socklen;
+
+	cgroup_fd = test__join_cgroup("/sock_policy");
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		goto close_skel;
+
+	cgroup_fd2 = create_and_get_cgroup("/sock_policy2");
+	if (!ASSERT_GE(cgroup_fd2, 0, "create second cgroup"))
+		goto close_skel;
+
+	skel = lsm_cgroup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto close_cgroup;
+
+	post_create_prog_fd = bpf_program__fd(skel->progs.socket_post_create);
+	post_create_prog_fd2 = bpf_program__fd(skel->progs.socket_post_create2);
+	bind_prog_fd = bpf_program__fd(skel->progs.socket_bind);
+	bind_prog_fd2 = bpf_program__fd(skel->progs.socket_bind2);
+	alloc_prog_fd = bpf_program__fd(skel->progs.socket_alloc);
+
+	err = bpf_prog_attach(alloc_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
+	if (!ASSERT_OK(err, "attach alloc_prog_fd"))
+		goto detach_cgroup;
+
+	/* Make sure replacing works.
+	 */
+
+	err = bpf_prog_attach(post_create_prog_fd, cgroup_fd,
+			      BPF_LSM_CGROUP, 0);
+	if (!ASSERT_OK(err, "attach post_create_prog_fd"))
+		goto close_cgroup;
+
+	attach_opts.replace_prog_fd = post_create_prog_fd;
+	err = bpf_prog_attach_opts(post_create_prog_fd2, cgroup_fd,
+				   BPF_LSM_CGROUP, &attach_opts);
+	if (!ASSERT_OK(err, "prog replace post_create_prog_fd"))
+		goto detach_cgroup;
+
+	/* Try the same attach/replace via link API.
+	 */
+
+	bind_link_fd = bpf_link_create(bind_prog_fd, cgroup_fd,
+				       BPF_LSM_CGROUP, NULL);
+	if (!ASSERT_GE(bind_link_fd, 0, "link create bind_prog_fd"))
+		goto detach_cgroup;
+
+	update_opts.old_prog_fd = bind_prog_fd;
+	update_opts.flags = BPF_F_REPLACE;
+
+	err = bpf_link_update(bind_link_fd, bind_prog_fd2, &update_opts);
+	if (!ASSERT_OK(err, "link update bind_prog_fd"))
+		goto detach_cgroup;
+
+	/* Attach another instance of bind program to another cgroup.
+	 * This should trigger the reuse of the trampoline shim (two
+	 * programs attaching to the same btf_id).
+	 */
+
+	bind_link_fd2 = bpf_link_create(bind_prog_fd2, cgroup_fd2,
+					BPF_LSM_CGROUP, NULL);
+	if (!ASSERT_GE(bind_link_fd2, 0, "link create bind_prog_fd2"))
+		goto detach_cgroup;
+
+	/* AF_UNIX is prohibited.
+	 */
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_LT(fd, 0, "socket(AF_UNIX)");
+
+	/* AF_INET6 gets default policy (sk_priority).
+	 */
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
+		goto detach_cgroup;
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
+		  "getsockopt");
+	ASSERT_EQ(prio, 123, "sk_priority");
+
+	close(fd);
+
+	/* TX-only AF_PACKET is allowed.
+	 */
+
+	ASSERT_LT(socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)), 0,
+		  "socket(AF_PACKET, ..., ETH_P_ALL)");
+
+	fd = socket(AF_PACKET, SOCK_RAW, 0);
+	ASSERT_GE(fd, 0, "socket(AF_PACKET, ..., 0)");
+
+	/* TX-only AF_PACKET can not be rebound.
+	 */
+
+	struct sockaddr_ll sa = {
+		.sll_family = AF_PACKET,
+		.sll_protocol = htons(ETH_P_ALL),
+	};
+	ASSERT_LT(bind(fd, (struct sockaddr *)&sa, sizeof(sa)), 0,
+		  "bind(ETH_P_ALL)");
+
+	close(fd);
+
+	/* Make sure other cgroup doesn't trigger the programs.
+	 */
+
+	if (!ASSERT_OK(join_cgroup(""), "join root cgroup"))
+		goto detach_cgroup;
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
+		goto detach_cgroup;
+
+	prio = 0;
+	socklen = sizeof(prio);
+	ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
+		  "getsockopt");
+	ASSERT_EQ(prio, 0, "sk_priority");
+
+	close(fd);
+
+detach_cgroup:
+	ASSERT_GE(bpf_prog_detach2(post_create_prog_fd2, cgroup_fd,
+				   BPF_LSM_CGROUP), 0, "detach_create");
+	close(bind_link_fd);
+	/* Don't close bind_link_fd2, exercise cgroup release cleanup. */
+	ASSERT_GE(bpf_prog_detach2(alloc_prog_fd, cgroup_fd,
+				   BPF_LSM_CGROUP), 0, "detach_alloc");
+
+close_cgroup:
+	close(cgroup_fd);
+close_skel:
+	lsm_cgroup__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/lsm_cgroup.c b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
new file mode 100644
index 000000000000..fd3b2daa26aa
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/lsm_cgroup.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+#ifndef AF_PACKET
+#define AF_PACKET 17
+#endif
+
+#ifndef AF_UNIX
+#define AF_UNIX 1
+#endif
+
+#ifndef EPERM
+#define EPERM 1
+#endif
+
+static __always_inline int real_create(struct socket *sock, int family,
+				       int protocol)
+{
+	struct sock *sk;
+
+	/* Reject non-tx-only AF_PACKET.
+	 */
+	if (family == AF_PACKET && protocol != 0)
+		return 0; /* EPERM */
+
+	sk = sock->sk;
+	if (!sk)
+		return 1;
+
+	/* The rest of the sockets get default policy.
+	 */
+	sk->sk_priority = 123;
+	return 1;
+}
+
+SEC("lsm_cgroup/socket_post_create")
+int BPF_PROG(socket_post_create, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	return real_create(sock, family, protocol);
+}
+
+SEC("lsm_cgroup/socket_post_create")
+int BPF_PROG(socket_post_create2, struct socket *sock, int family,
+	     int type, int protocol, int kern)
+{
+	return real_create(sock, family, protocol);
+}
+
+static __always_inline int real_bind(struct socket *sock,
+				     struct sockaddr *address,
+				     int addrlen)
+{
+	struct sockaddr_ll sa = {};
+
+	if (sock->sk->__sk_common.skc_family != AF_PACKET)
+		return 1;
+
+	if (sock->sk->sk_kern_sock)
+		return 1;
+
+	bpf_probe_read_kernel(&sa, sizeof(sa), address);
+	if (sa.sll_protocol)
+		return 0; /* EPERM */
+
+	return 1;
+}
+
+SEC("lsm_cgroup/socket_bind")
+int BPF_PROG(socket_bind, struct socket *sock, struct sockaddr *address,
+	     int addrlen)
+{
+	return real_bind(sock, address, addrlen);
+}
+
+SEC("lsm_cgroup/socket_bind")
+int BPF_PROG(socket_bind2, struct socket *sock, struct sockaddr *address,
+	     int addrlen)
+{
+	return real_bind(sock, address, addrlen);
+}
+
+SEC("lsm_cgroup/sk_alloc_security")
+int BPF_PROG(socket_alloc, struct sock *sk, int family, gfp_t priority)
+{
+	if (family == AF_UNIX)
+		return 0; /* EPERM */
+	return 1;
+}
-- 
2.35.1.1094.g7c7d902a7c-goog

