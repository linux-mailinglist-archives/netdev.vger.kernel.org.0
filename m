Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D815228819E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 07:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbgJIFJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 01:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIFJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 01:09:23 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE20C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 22:09:21 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id i12so7937938ota.5
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 22:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tehnerd-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vjO1y5e0L8se8ZedRLXM2SIg3QSKBrPn3iirYWr5Tqc=;
        b=XOcFA2lJvqhBOl941BM2a01Kmv2JK02t1eExX9D2eqVXySKvi4DRIDf2mLHkqZCV7Y
         FZMBiyuDaP1ZCCH4de1P0PoSLgaSWAWaM2PaiMZGIpyAseWKjSwYscU0HKn3mY16L0rz
         vfQUEyn3IzTKhAT8yKutdRxnuFbaRGE1f5YdK3NKIFr2O5gO6CJYPjHhw3mgbDLlyBBy
         1/G5DfaA0u/pJD1QfVcTWaYxuDeUHtUlkAo5Mcvc5UuUQv34+V1GEoO/Agz0Ao4tUdt/
         /pCMukRxoMG6/nWqp1mhac7uYLCG9hQwJXvhBwwQL0rStip0SZDrB4QmE9Rbg5H3sccQ
         /Zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vjO1y5e0L8se8ZedRLXM2SIg3QSKBrPn3iirYWr5Tqc=;
        b=jIywpgTqXRLcFoDxcppFx9ToIzUBI/IxUOrNwgnEy6UzMlkpsos93jo9CRHVCUg+io
         66W0Jhx42QijMpTbAVXSIOlQqaA5/KujjQAjARkkFCCLzpm3SJVbG04/c7u8xE32UYG6
         ZCkLS6BfI0Z77NGPuO0u7uYMdiQBOKaJB93A4Xs2azIul18jZ3vShbjOVpe6wHi0cAF5
         f3oAJAXvHkFnOBiCHV3Xv6oaFmC6xFj7hDZHd7gUMMKRmsyIrkMAXg+u6ItFjHkM0Gxu
         ccqy5+GQUplZSM4cZJTcVw0FP6kLR64n0HePq+oct14Hs+ACmGJhi4Frr6nvveKASESh
         Gpng==
X-Gm-Message-State: AOAM530KMIe/bP8MOQGiqvB4mxJpmG/iCEbd5cUuTjy8n75GHzjVddSG
        LMjRXe5H1aUunxK7my9I+Fy3hg==
X-Google-Smtp-Source: ABdhPJzOWsR9WHavzmMqSGDcUrLOTnsw/pOuiWMICX3jGQhK6acz4bWAKMV3EjWtmA5pJNTjVlz7mQ==
X-Received: by 2002:a9d:a24:: with SMTP id 33mr6850682otg.305.1602220160802;
        Thu, 08 Oct 2020 22:09:20 -0700 (PDT)
Received: from nuke.localdomain (adsl-99-73-38-187.dsl.okcyok.sbcglobal.net. [99.73.38.187])
        by smtp.gmail.com with ESMTPSA id p8sm6350783oip.29.2020.10.08.22.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 22:09:20 -0700 (PDT)
From:   "Nikita V. Shirokov" <tehnerd@tehnerd.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        "Nikita V. Shirokov" <tehnerd@tehnerd.com>
Subject: [PATCH bpf-next] bpf: add tcp_notsent_lowat bpf setsockopt
Date:   Fri,  9 Oct 2020 05:08:39 +0000
Message-Id: <20201009050839.222847-1-tehnerd@tehnerd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support for TCP_NOTSENT_LOWAT sockoption
(https://lwn.net/Articles/560082/) in tcpbpf

Signed-off-by: Nikita V. Shirokov <tehnerd@tehnerd.com>
---
 include/uapi/linux/bpf.h                          |  2 +-
 net/core/filter.c                                 |  4 ++++
 tools/testing/selftests/bpf/progs/connect4_prog.c | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

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
index b1b2773c0b9d..b10e7fbace7b 100644
--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -128,6 +128,18 @@ static __inline int set_keepalive(struct bpf_sock_addr *ctx)
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
@@ -148,6 +160,9 @@ int connect_v4_prog(struct bpf_sock_addr *ctx)
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

