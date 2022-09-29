Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC575EEE61
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiI2HFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235072AbiI2HEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:04:42 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C128613070A;
        Thu, 29 Sep 2022 00:04:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664435068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uh+ejWrx6vnFNK0wy56yr0aj1vBg58V3Md/AW4RsBQQ=;
        b=TQWjUUP7upW2dOzPQicUtj7yvX9ICrPTkCgil0Emkcmlz3DAr0nIZy3Ws7WBvzGO2TczBk
        u0LlCR/+4msrBpT+u+QVCO6mVgQV9VmrhObPHHl+ezqbaysQIBekfJ+bz73Ud3w1jOXkr4
        vgVerwWaYCdfCvqzh54R5bKa2MTCys4=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     ' ' <bpf@vger.kernel.org>, ' ' <netdev@vger.kernel.org>
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        'David Miller ' <davem@davemloft.net>,
        'Jakub Kicinski ' <kuba@kernel.org>,
        'Eric Dumazet ' <edumazet@google.com>,
        'Paolo Abeni ' <pabeni@redhat.com>, ' ' <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 2/5] bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
Date:   Thu, 29 Sep 2022 00:04:04 -0700
Message-Id: <20220929070407.965581-3-martin.lau@linux.dev>
In-Reply-To: <20220929070407.965581-1-martin.lau@linux.dev>
References: <20220929070407.965581-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The check on the tcp-cc, "cdg", is done in the bpf_sk_setsockopt which is
used by the bpf_tcp_ca, bpf_lsm, cg_sockopt, and tcp_iter hooks.
However, it is not done for cg sock_ddr, cg sockops, and some of
the bpf_lsm_cgroup hooks.

The tcp-cc "cdg" should have very limited usage.  This patch is to
move the "cdg" check to the common sol_tcp_sockopt() so that all
hooks have a consistent behavior.   The motivation to make
this check consistent now is because the latter patch will
refactor the bpf_setsockopt(TCP_CONGESTION) into another function,
so it is better to take this chance to refactor this piece
also.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 net/core/filter.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2fd9449026aa..f4cea3ff994a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5127,6 +5127,13 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 	case TCP_CONGESTION:
 		if (*optlen < 2)
 			return -EINVAL;
+		/* "cdg" is the only cc that alloc a ptr
+		 * in inet_csk_ca area.  The bpf-tcp-cc may
+		 * overwrite this ptr after switching to cdg.
+		 */
+		if (!getopt && *optlen >= sizeof("cdg") - 1 &&
+		    !strncmp("cdg", optval, *optlen))
+			return -ENOTSUPP;
 		break;
 	case TCP_SAVED_SYN:
 		if (*optlen < 1)
@@ -5285,12 +5292,6 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 BPF_CALL_5(bpf_sk_setsockopt, struct sock *, sk, int, level,
 	   int, optname, char *, optval, int, optlen)
 {
-	if (level == SOL_TCP && optname == TCP_CONGESTION) {
-		if (optlen >= sizeof("cdg") - 1 &&
-		    !strncmp("cdg", optval, optlen))
-			return -ENOTSUPP;
-	}
-
 	return _bpf_setsockopt(sk, level, optname, optval, optlen);
 }
 
-- 
2.30.2

