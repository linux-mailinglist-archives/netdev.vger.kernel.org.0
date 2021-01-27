Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C943067EE
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhA0XbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbhA0XaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 18:30:12 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7745BC06178A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:28:59 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id h16so2259893qta.12
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 15:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=qSwmxdg3a9pT/PW0olMN9Ba8UoPge1k1RGd+0B1erdg=;
        b=NHiMdDTltQdqd06KHgKOmR9ONnERLHNDNYV+qTbVZWx8Iq+z6evoghqDT/L1COZjOi
         KSEW7KaukiiqNyqKM0wwAAhkeAXCeC4PQnlVeLM1aqUsFWXMR+oJQoI+D+WxNZapTJpW
         723bhfCqBsfnpTcQXRH2h4TbRl5RmQ7v8DaAdLj1027bipSKpwZRRVusVbSZIeBmbJVe
         wE4Mv7lgn5FUN7Cg08FUWHyZ2O1JiWToBhg2oeIUi49VwzPLF9CyQ3STmd2wW14aMpDU
         MI+vWWdDQSmaj9BWV6+OBgOcNQEfeJCYcgswF/JdoldRRJa2FW3e+GYuyQmirbxiJbBK
         9pUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qSwmxdg3a9pT/PW0olMN9Ba8UoPge1k1RGd+0B1erdg=;
        b=FgUk1Qg+4SHo65nTjHNTl9pq21cvxjLMwMHlF1ppDutq/selHVjUGvYkgS5iFxf88F
         AhxSqYCQgH/+MFlbRwkmu4+7lXCxzMYoU/CJTS7OuYLMQ6zOMsRdJK6MJb9FtW40AxEQ
         5oriTp93QY6ymPbq9zKbt3kGDnLargP7DKO60XdP7wK36mgvzR9RZ3oCg1b+EFyzSDRY
         J6IphgMF0PSE7cIkMYzJA7Q4ReOzhfr2VIfAE2WH7NKDjnreFgrJHFcPwHPzOCyXjBrC
         iaK4PsB9f72a302+YcvTJuZdPD4zNCDbhV3QGAFRR3I8M3cygIn7IF9rbhhHGQ7z2dmK
         0zZQ==
X-Gm-Message-State: AOAM532BeEmOMqBuYA+KbwkzAOI8SGSQL2WFARrHlOW4CALC64TOTESD
        sOcMY4BQWM9g7eAmm/h5AgXp3kOu+IMJDlddtsEuEDfKVmVze6Hlb8TQ33NPeqlSriyjeR7vdeg
        RqIOjL4OeqjYK4LNrGbCGYIdTbOVGU1M1ANsEP+CDXtLLgMZwPEzcGw==
X-Google-Smtp-Source: ABdhPJzpQz/EmRBmodHiEn57QMBjd4e9VRPMEglVEQquynKyuHfV3p3xhZRfWFelZdWt10qCt6YvDBE=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:48f:: with SMTP id
 ay15mr12724612qvb.58.1611790138644; Wed, 27 Jan 2021 15:28:58 -0800 (PST)
Date:   Wed, 27 Jan 2021 15:28:51 -0800
In-Reply-To: <20210127232853.3753823-1-sdf@google.com>
Message-Id: <20210127232853.3753823-3-sdf@google.com>
Mime-Version: 1.0
References: <20210127232853.3753823-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v2 2/4] bpf: enable bpf_{g,s}etsockopt in BPF_CGROUP_INET{4,6}_GET{PEER,SOCK}NAME
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
a locked socket.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/core/filter.c                                       | 8 ++++++++
 tools/testing/selftests/bpf/progs/connect_force_port4.c | 8 ++++++++
 tools/testing/selftests/bpf/progs/connect_force_port6.c | 8 ++++++++
 3 files changed, 24 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 3d7f78a19565..ba436b1d70c2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7025,6 +7025,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_INET4_GETPEERNAME:
+		case BPF_CGROUP_INET6_GETPEERNAME:
+		case BPF_CGROUP_INET4_GETSOCKNAME:
+		case BPF_CGROUP_INET6_GETSOCKNAME:
 			return &bpf_sock_addr_setsockopt_proto;
 		default:
 			return NULL;
@@ -7037,6 +7041,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		case BPF_CGROUP_INET6_CONNECT:
 		case BPF_CGROUP_UDP4_SENDMSG:
 		case BPF_CGROUP_UDP6_SENDMSG:
+		case BPF_CGROUP_INET4_GETPEERNAME:
+		case BPF_CGROUP_INET6_GETPEERNAME:
+		case BPF_CGROUP_INET4_GETSOCKNAME:
+		case BPF_CGROUP_INET6_GETSOCKNAME:
 			return &bpf_sock_addr_getsockopt_proto;
 		default:
 			return NULL;
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port4.c b/tools/testing/selftests/bpf/progs/connect_force_port4.c
index 7396308677a3..a979aaef2a76 100644
--- a/tools/testing/selftests/bpf/progs/connect_force_port4.c
+++ b/tools/testing/selftests/bpf/progs/connect_force_port4.c
@@ -10,6 +10,8 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
+#include <bpf_sockopt_helpers.h>
+
 char _license[] SEC("license") = "GPL";
 int _version SEC("version") = 1;
 
@@ -58,6 +60,9 @@ int connect4(struct bpf_sock_addr *ctx)
 SEC("cgroup/getsockname4")
 int getsockname4(struct bpf_sock_addr *ctx)
 {
+	if (!get_set_sk_priority(ctx))
+		return 1;
+
 	/* Expose local server as 1.2.3.4:60000 to client. */
 	if (ctx->user_port == bpf_htons(60123)) {
 		ctx->user_ip4 = bpf_htonl(0x01020304);
@@ -71,6 +76,9 @@ int getpeername4(struct bpf_sock_addr *ctx)
 {
 	struct svc_addr *orig;
 
+	if (!get_set_sk_priority(ctx))
+		return 1;
+
 	/* Expose service 1.2.3.4:60000 as peer instead of backend. */
 	if (ctx->user_port == bpf_htons(60123)) {
 		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0, 0);
diff --git a/tools/testing/selftests/bpf/progs/connect_force_port6.c b/tools/testing/selftests/bpf/progs/connect_force_port6.c
index c1a2b555e9ad..afc8f1c5a9d6 100644
--- a/tools/testing/selftests/bpf/progs/connect_force_port6.c
+++ b/tools/testing/selftests/bpf/progs/connect_force_port6.c
@@ -9,6 +9,8 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
+#include <bpf_sockopt_helpers.h>
+
 char _license[] SEC("license") = "GPL";
 int _version SEC("version") = 1;
 
@@ -63,6 +65,9 @@ int connect6(struct bpf_sock_addr *ctx)
 SEC("cgroup/getsockname6")
 int getsockname6(struct bpf_sock_addr *ctx)
 {
+	if (!get_set_sk_priority(ctx))
+		return 1;
+
 	/* Expose local server as [fc00::1]:60000 to client. */
 	if (ctx->user_port == bpf_htons(60124)) {
 		ctx->user_ip6[0] = bpf_htonl(0xfc000000);
@@ -79,6 +84,9 @@ int getpeername6(struct bpf_sock_addr *ctx)
 {
 	struct svc_addr *orig;
 
+	if (!get_set_sk_priority(ctx))
+		return 1;
+
 	/* Expose service [fc00::1]:60000 as peer instead of backend. */
 	if (ctx->user_port == bpf_htons(60124)) {
 		orig = bpf_sk_storage_get(&service_mapping, ctx->sk, 0, 0);
-- 
2.30.0.280.ga3ce27912f-goog

