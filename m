Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1AA28832C
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731315AbgJIHDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729530AbgJIHDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 03:03:31 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07599C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 00:03:31 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id d28so8139480ote.1
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 00:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tehnerd-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WaEGg03TPV6YDTc64kcx7tSz7oMWaGK4zh7JzQpcZFg=;
        b=eQy1Cl1jpkN/OrRiuiKQTh00QpAjwg/X0ohbvs3p06Q/sWGhRBVf16FunEGlB3CaCE
         u9HaRHMpZF0AeF3cjuouzmRPkWnwPhUNiCxF8xO5Gfj7yLoyNwE3hUnpHbTNqJg2wYdu
         VfPkOEKXAOnmPiV58fj7CfeDAYVjF92CPTmwlNF4bAuqas3Ooyaz28B1+I1Yj5yr37nY
         bLUm8MXaK0c3ijA/LZKXvXrstbiWdy6krjhhijK8tWs/GalQ6F19pjT1aDS+Nz7cvjQj
         G9ckHam61XT8sz0lWt3h8Z3cu6gPppGTiibC+XR0CK/sov3rLGgHGGvqSY5JAb++SQxw
         FnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WaEGg03TPV6YDTc64kcx7tSz7oMWaGK4zh7JzQpcZFg=;
        b=OI2lSGGx1Js5vMh018A16mniVY6yhfBsvFiiW+Mds5L/I2k5FHQtIlp/oe1MOHm6EA
         YmExbZGmQfvnpnXIVgob8RIU8zZG6/0k3PlE9VgBeFVdDGNDDDepG5ZZkNK1l1HMQtKG
         v4eVL5Dj5+Zr7OREINgKlAhYWXCMDYeQ9qe43L9zXrMWWYa+vegcBgR0SnN+vVa40OE8
         GTHRcxH68JCrRZiGfYQkr/glIJIDUqXcTAx6VyPO5tOCHvSnF00UligSr/xrwur6f11s
         XxhPYbJsr6O/wB3aO+oeiYZL06dvUOR6y9ppvM6DyBJfUtntXqkTuaIvoxcn94gR278K
         JvlQ==
X-Gm-Message-State: AOAM5310Ovgkj+vv5IuduarqcjrRxdI+2DBjzNsH4W3qMJT8wyI2dmJa
        DUWriIsHC8nVQ3PNYYXR2TBHRQ==
X-Google-Smtp-Source: ABdhPJzCce58urZkn7XuC6VhjlE4WVo4yP9NNn+4rVKWSw2PJsNZkKgRt4VSSHtN4TTpVGOeChU2Tg==
X-Received: by 2002:a9d:3407:: with SMTP id v7mr7696551otb.117.1602227010385;
        Fri, 09 Oct 2020 00:03:30 -0700 (PDT)
Received: from nuke.localdomain (adsl-99-73-38-187.dsl.okcyok.sbcglobal.net. [99.73.38.187])
        by smtp.gmail.com with ESMTPSA id t20sm7430231oot.22.2020.10.09.00.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 00:03:29 -0700 (PDT)
From:   "Nikita V. Shirokov" <tehnerd@tehnerd.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>,
        "Nikita V. Shirokov" <tehnerd@tehnerd.com>
Subject: [PATCH bpf-next v2] bpf: add tcp_notsent_lowat bpf setsockopt
Date:   Fri,  9 Oct 2020 07:03:25 +0000
Message-Id: <20201009070325.226855-1-tehnerd@tehnerd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for TCP_NOTSENT_LOWAT sockoption
(https://lwn.net/Articles/560082/) in tcpbpf

v1->v2:
- addressing yhs@ comments. explicitly defining TCP_NOTSENT_LOWAT in
  selftests if it is not defined in the system

Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
---
 include/uapi/linux/bpf.h                      |  2 +-
 net/core/filter.c                             |  4 ++++
 .../selftests/bpf/progs/connect4_prog.c       | 19 +++++++++++++++++++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index d83561e8cd2c..42d2df799397 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1698,7 +1698,7 @@ union bpf_attr {
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
  * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
  * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
- * 		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**.
+ *		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**, **TCP_NOTSENT_LOWAT**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
diff --git a/net/core/filter.c b/net/core/filter.c
index 05df73780dd3..5da44b11e1ec 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4827,6 +4827,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				else
 					icsk->icsk_user_timeout = val;
 				break;
+			case TCP_NOTSENT_LOWAT:
+				tp->notsent_lowat = val;
+				sk->sk_write_space(sk);
+				break;
 			default:
 				ret = -EINVAL;
 			}
diff --git a/tools/testing/selftests/bpf/progs/connect4_prog.c b/tools/testing/selftests/bpf/progs/connect4_prog.c
index b1b2773c0b9d..a943d394fd3a 100644
--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -23,6 +23,10 @@
 #define TCP_CA_NAME_MAX 16
 #endif
 
+#ifndef TCP_NOTSENT_LOWAT
+#define TCP_NOTSENT_LOWAT 25
+#endif
+
 #ifndef IFNAMSIZ
 #define IFNAMSIZ 16
 #endif
@@ -128,6 +132,18 @@ static __inline int set_keepalive(struct bpf_sock_addr *ctx)
 	return 0;
 }
 
+static __inline int set_notsent_lowat(struct bpf_sock_addr *ctx)
+{
+	int lowat = 65535;
+
+	if (ctx->type == SOCK_STREAM) {
+		if (bpf_setsockopt(ctx, SOL_TCP, TCP_NOTSENT_LOWAT, &lowat, sizeof(lowat)))
+			return 1;
+	}
+
+	return 0;
+}
+
 SEC("cgroup/connect4")
 int connect_v4_prog(struct bpf_sock_addr *ctx)
 {
@@ -148,6 +164,9 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
 	if (set_keepalive(ctx))
 		return 0;
 
+	if (set_notsent_lowat(ctx))
+		return 0;
+
 	if (ctx->type != SOCK_STREAM && ctx->type != SOCK_DGRAM)
 		return 0;
 	else if (ctx->type == SOCK_STREAM)
-- 
2.25.1

