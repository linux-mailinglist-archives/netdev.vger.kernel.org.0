Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6BD5EEE5E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiI2HFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbiI2HEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:43 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABABF5F8C;
        Thu, 29 Sep 2022 00:04:35 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mrtWExq0wBIpyOPOl96p4X+vkDCpxYHVu/CvZF0R/5Y=;
        b=uEamq2QYjtyqsfp4pDJigvVn1gC3erCNRlj4CjW3pNjI9vZb5z1o3tUeygE6FcMTKRoYhL
        nWMjh3PONjzLnHBBJrZ7jGBKC6BLEnG45CNuiFpiJDvSNj87bbo6pTkTGrcCoEsUrizPyb
        2hCX2RZanCnFocQTtgQaSdojjhpzvTk=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 4/5] bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
Date:   Thu, 29 Sep 2022 00:04:06 -0700
Message-Id: <20220929070407.965581-5-martin.lau@linux.dev>
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

When a bad bpf prog '.init' calls
bpf_setsockopt(TCP_CONGESTION, "itself"), it will trigger this loop:

.init => bpf_setsockopt(tcp_cc) => .init => bpf_setsockopt(tcp_cc) ...
... => .init => bpf_setsockopt(tcp_cc).

It was prevented by the prog->active counter before but the prog->active
detection cannot be used in struct_ops as explained in the earlier
patch of the set.

In this patch, the second bpf_setsockopt(tcp_cc) is not allowed
in order to break the loop.  This is done by using a bit of
an existing 1 byte hole in tcp_sock to check if there is
on-going bpf_setsockopt(TCP_CONGESTION) in this tcp_sock.

Note that this essentially limits only the first '.init' can
call bpf_setsockopt(TCP_CONGESTION) to pick a fallback cc (eg. peer
does not support ECN) and the second '.init' cannot fallback to
another cc.  This applies even the second
bpf_setsockopt(TCP_CONGESTION) will not cause a loop.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/linux/tcp.h      |  6 ++++++
 net/core/filter.c        | 28 +++++++++++++++++++++++++++-
 net/ipv4/tcp_minisocks.c |  1 +
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index a9fbe22732c3..3bdf687e2fb3 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -388,6 +388,12 @@ struct tcp_sock {
 	u8	bpf_sock_ops_cb_flags;  /* Control calling BPF programs
 					 * values defined in uapi/linux/tcp.h
 					 */
+	u8	bpf_chg_cc_inprogress:1; /* In the middle of
+					  * bpf_setsockopt(TCP_CONGESTION),
+					  * it is to avoid the bpf_tcp_cc->init()
+					  * to recur itself by calling
+					  * bpf_setsockopt(TCP_CONGESTION, "itself").
+					  */
 #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) (TP->bpf_sock_ops_cb_flags & ARG)
 #else
 #define BPF_SOCK_OPS_TEST_FLAG(TP, ARG) 0
diff --git a/net/core/filter.c b/net/core/filter.c
index 96f2f7a65e65..ac4c45c02da5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5105,6 +5105,9 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
 				      int *optlen, bool getopt)
 {
+	struct tcp_sock *tp;
+	int ret;
+
 	if (*optlen < 2)
 		return -EINVAL;
 
@@ -5125,8 +5128,31 @@ static int sol_tcp_sockopt_congestion(struct sock *sk, char *optval,
 	if (*optlen >= sizeof("cdg") - 1 && !strncmp("cdg", optval, *optlen))
 		return -ENOTSUPP;
 
-	return do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+	/* It stops this looping
+	 *
+	 * .init => bpf_setsockopt(tcp_cc) => .init =>
+	 * bpf_setsockopt(tcp_cc)" => .init => ....
+	 *
+	 * The second bpf_setsockopt(tcp_cc) is not allowed
+	 * in order to break the loop when both .init
+	 * are the same bpf prog.
+	 *
+	 * This applies even the second bpf_setsockopt(tcp_cc)
+	 * does not cause a loop.  This limits only the first
+	 * '.init' can call bpf_setsockopt(TCP_CONGESTION) to
+	 * pick a fallback cc (eg. peer does not support ECN)
+	 * and the second '.init' cannot fallback to
+	 * another.
+	 */
+	tp = tcp_sk(sk);
+	if (tp->bpf_chg_cc_inprogress)
+		return -EBUSY;
+
+	tp->bpf_chg_cc_inprogress = 1;
+	ret = do_tcp_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
 				KERNEL_SOCKPTR(optval), *optlen);
+	tp->bpf_chg_cc_inprogress = 0;
+	return ret;
 }
 
 static int sol_tcp_sockopt(struct sock *sk, int optname,
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cb95d88497ae..ddcdc2bc4c04 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -541,6 +541,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	newtp->fastopen_req = NULL;
 	RCU_INIT_POINTER(newtp->fastopen_rsk, NULL);
 
+	newtp->bpf_chg_cc_inprogress = 0;
 	tcp_bpf_clone(sk, newsk);
 
 	__TCP_INC_STATS(sock_net(sk), TCP_MIB_PASSIVEOPENS);
-- 
2.30.2

