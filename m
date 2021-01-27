Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E004130628A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344156AbhA0Rs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344197AbhA0Rr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:47:57 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36821C0613D6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:47:17 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id d1so1656088qtp.11
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 09:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=/9BJiDKQimB7u2fI0qYNm7nXNMZSvHM17U5K5K4mu/4=;
        b=VpbSLoVFdd9zqO05uHMrLz9n+MOi8NAQR+x5X3LfrMSvXOPSeSFoZur30KcKTY1c05
         uhrwTMLuPGXxr4EkQCdi6zxVIi+LKfsoV71lZNoRD1p2RykNhZ2FPZQbGs2Hv3W3YTv0
         LBmdsxrpEYzSKHx8t+M9oug0eidN5nqM1vo+L8IrrotjWlBtqgLcwD+R7HJMxwot0TsM
         beb0xarNNYrh3p4vmkD8PwWLaUAUioVHbC9J9h48FnG4Kr3ho6d2tXaU3DuWpveTTVfA
         FcCKAvSnaUHcDW+UXvTmkmr5gk2ll2TKe4tK1YTDkkQK0uFKdbGkZirqKntcvWSnAPp4
         cECw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=/9BJiDKQimB7u2fI0qYNm7nXNMZSvHM17U5K5K4mu/4=;
        b=Uk0ljYpslkfobS0V8PAS65TtQCQs2qJVowm/MMnWOFmAEcNdItMtMsdSVCJGfWd6oI
         Bh564leb7UjZNfDOqI39pjtpcm4xYEvoxxFT/CSw9DGUqSTfxzq/g0CcRc68vCASAMm2
         SY5mqFjMYhaQUX2W539G4Gi+JO9BqWumIDJwcXJ/CuPOHNTay+VpyzzpkjzPY7ycQ4lQ
         UI0zd3ebt8LLgic1lbUDO9CJnXGTzgoX0a/4ahjTJKJXOGm1teU1uOO3cY2jhnQK5nIY
         djsmpCORS3ZVgpBjHPui0/L972d1Y88YnHwXjxsSCCgHYQfXZ3JNQ8WJB6M/Ltpxr5ju
         kVxQ==
X-Gm-Message-State: AOAM532HI5CNfyl/4eREOS/81C4ucWMqpP8FzvzQIOM9MHGcI64X8v4a
        kZvgAMyJ+zwuLy0yTfVO+04uv1uin0+h47wAFEuoTvOxQCLSUPLXzcHn8BrHzQTT7y4bFtbXuJf
        JYmzTW2EqF6UaxSnLX0oCcPzxCV1f/LkbrQ+XhFpDncIXXsp6nKUocA==
X-Google-Smtp-Source: ABdhPJy8yd44Lehs+FonFE4Rkj9dC2gy7LvvGhbzo9Hia4SvMJZ5nqESIVYCb1V/xRRKRqP+QwEUtgg=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:43ca:: with SMTP id o10mr11579834qvs.25.1611769636244;
 Wed, 27 Jan 2021 09:47:16 -0800 (PST)
Date:   Wed, 27 Jan 2021 09:47:14 -0800
Message-Id: <20210127174714.2240395-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_UDP{4,6}_SENDMSG
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Can be used to query/modify socket state for unconnected UDP sendmsg.
Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
a locked socket.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/core/filter.c                                 | 4 ++++
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c | 7 +++++++
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c | 7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 9ab94e90d660..3d7f78a19565 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
+		case BPF_CGROUP_UDP4_SENDMSG:
+		case BPF_CGROUP_UDP6_SENDMSG:
 			return &bpf_sock_addr_setsockopt_proto;
 		default:
 			return NULL;
@@ -7033,6 +7035,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_INET6_BIND:
 		case BPF_CGROUP_INET4_CONNECT:
 		case BPF_CGROUP_INET6_CONNECT:
+		case BPF_CGROUP_UDP4_SENDMSG:
+		case BPF_CGROUP_UDP6_SENDMSG:
 			return &bpf_sock_addr_getsockopt_proto;
 		default:
 			return NULL;
diff --git a/tools/testing/selftests/bpf/progs/sendmsg4_prog.c b/tools/testing/selftests/bpf/progs/sendmsg4_prog.c
index 092d9da536f3..fcac40a05c3d 100644
--- a/tools/testing/selftests/bpf/progs/sendmsg4_prog.c
+++ b/tools/testing/selftests/bpf/progs/sendmsg4_prog.c
@@ -21,9 +21,16 @@ int _version SEC("version") = 1;
 SEC("cgroup/sendmsg4")
 int sendmsg_v4_prog(struct bpf_sock_addr *ctx)
 {
+	int prio;
+
 	if (ctx->type != SOCK_DGRAM)
 		return 0;
 
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_PRIORITY, &prio, sizeof(prio)))
+		return 0;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_PRIORITY, &prio, sizeof(prio)))
+		return 0;
+
 	/* Rewrite source. */
 	if (ctx->msg_src_ip4 == bpf_htonl(SRC1_IP4) ||
 	    ctx->msg_src_ip4 == bpf_htonl(SRC2_IP4)) {
diff --git a/tools/testing/selftests/bpf/progs/sendmsg6_prog.c b/tools/testing/selftests/bpf/progs/sendmsg6_prog.c
index 255a432bc163..50b46961d08a 100644
--- a/tools/testing/selftests/bpf/progs/sendmsg6_prog.c
+++ b/tools/testing/selftests/bpf/progs/sendmsg6_prog.c
@@ -25,9 +25,16 @@ int _version SEC("version") = 1;
 SEC("cgroup/sendmsg6")
 int sendmsg_v6_prog(struct bpf_sock_addr *ctx)
 {
+	int prio;
+
 	if (ctx->type != SOCK_DGRAM)
 		return 0;
 
+	if (bpf_getsockopt(ctx, SOL_SOCKET, SO_PRIORITY, &prio, sizeof(prio)))
+		return 0;
+	if (bpf_setsockopt(ctx, SOL_SOCKET, SO_PRIORITY, &prio, sizeof(prio)))
+		return 0;
+
 	/* Rewrite source. */
 	if (ctx->msg_src_ip6[3] == bpf_htonl(1) ||
 	    ctx->msg_src_ip6[3] == bpf_htonl(0)) {
-- 
2.30.0.280.ga3ce27912f-goog

