Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E925EEE5A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiI2HE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiI2HEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:42 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C261003;
        Thu, 29 Sep 2022 00:04:33 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lv9oaVEkuaN/4tfopReITc+74lJ/gN9iWS/b7MxMp88=;
        b=qa09C+/dyrU+b9Bc9OYMG1QSvp806rPIhhOT8aP145G+JozG1cTTazgRSEeZAKki0/68wX
        BoFJPeo4dn4EaplAWHrwmJUrb0/edIu4c4x2r6l38fWObfCNaumofCVxGIZ/QrVXOtOA3z
        4f9ybsg+n5icV+eXw+s7VFSY+AHXgc8=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 3/5] bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another function
Date:   Thu, 29 Sep 2022 00:04:05 -0700
Message-Id: <20220929070407.965581-4-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-1-martin.lau@linux.dev>
References: <20220929070407.965581-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch moves the bpf_setsockopt(TCP_CONGESTION) logic into
another function.  The next patch will add extra logic to avoid
recursion and this will make the latter patch easier to follow.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/core/filter.c | 45 ++++++++++++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 17 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f4cea3ff994a..96f2f7a65e65 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5102,6 +5102,33 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 	return 0;
 }
 
+static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
+				      int *optlen, bool getopt)
+{
+	if (*optlen < 2)
+		return -EINVAL;
+
+	if (getopt) {
+		if (!inet_csk(sk)->icsk_ca_ops)
+			return -EINVAL;
+		/* BPF expects NULL-terminated tcp-cc string */
+		optval[--(*optlen)] = '\0';
+		return do_tcp_getsockopt(sk, SOL_TCP, TCP_CONGESTION,
+					 KERNEL_SOCKPTR(optval),
+					 KERNEL_SOCKPTR(optlen));
+	}
+
+	/* "cdg" is the only cc that alloc a ptr
+	 * in inet_csk_ca area.  The bpf-tcp-cc may
+	 * overwrite this ptr after switching to cdg.
+	 */
+	if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
+		return -ENOTSUPP;
+
+	return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+				KERNEL_SOCKPTR(optval), *optlen);
+}
+
 static int sol_tcp_sockopt(struct sock *sk, int optname,
 			   char *optval, int *optlen,
 			   bool getopt)
@@ -5125,16 +5152,7 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 			return -EINVAL;
 		break;
 	case TCP_CONGESTION:
-		if (*optlen < 2)
-			return -EINVAL;
-		/* "cdg" is the only cc that alloc a ptr
-		 * in inet_csk_ca area.  The bpf-tcp-cc may
-		 * overwrite this ptr after switching to cdg.
-		 */
-		if (!getopt && *optlen >= sizeof("cdg") - 1 &&
-		    !strncmp("cdg", optval, *optlen))
-			return -ENOTSUPP;
-		break;
+		return sol_tcp_sockopt_congestion(sk, optval, optlen, getopt);
 	case TCP_SAVED_SYN:
 		if (*optlen < 1)
 			return -EINVAL;
@@ -5159,13 +5177,6 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 			return 0;
 		}
 
-		if (optname == TCP_CONGESTION) {
-			if (!inet_csk(sk)->icsk_ca_ops)
-				return -EINVAL;
-			/* BPF expects NULL-terminated tcp-cc string */
-			optval[--(*optlen)] = '\0';
-		}
-
 		return do_tcp_getsockopt(sk, SOL_TCP, optname,
 					 KERNEL_SOCKPTR(optval),
 					 KERNEL_SOCKPTR(optlen));
-- 
2.30.2

