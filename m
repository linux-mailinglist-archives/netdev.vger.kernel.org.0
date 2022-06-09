Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA595455E7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345197AbiFIUr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345178AbiFIUr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:47:28 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C48C83B2A8;
        Thu,  9 Jun 2022 13:47:25 -0700 (PDT)
Received: from SPMA-01.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 2D40C7E08B8_2A25C5CB;
        Thu,  9 Jun 2022 20:47:24 +0000 (GMT)
Received: from mail.tu-berlin.de (bulkmail.tu-berlin.de [141.23.12.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-01.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id CB6A7833590_2A25C5BF;
        Thu,  9 Jun 2022 20:47:23 +0000 (GMT)
Received: from jt.fritz.box (77.11.250.240) by ex-02.svc.tu-berlin.de
 (10.150.18.6) with Microsoft SMTP Server id 15.2.986.22; Thu, 9 Jun 2022
 22:47:23 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next v2 2/2] bpf: Require only one of cong_avoid() and cong_control() from a TCP CC
Date:   Thu, 9 Jun 2022 22:47:02 +0200
Message-ID: <20220609204702.2351369-3-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220609204702.2351369-1-jthinz@mailbox.tu-berlin.de>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
 <20220609204702.2351369-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=RZHvJDUsnsYb3eTPep0aSCF1yaWNmmjr4+iDzKm1+DI=; b=UjGji9WRH77gFeSDuH5aEujF0rohDVAMdA6gxCa/YJKCW50txQWI32nQlmR/xZ10BpUQqsmlpsF5t1XnqW57CdAw5RNw8dC42826tou1f4T1rdFIZz0dqzLZh3cqmOwpdeZMTDJzxYfmg3Xg0QuqbUndEQ3LFe7fliAMoLNOOS8=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the check for required and optional functions in a struct
tcp_congestion_ops from bpf_tcp_ca.c. Rely on
tcp_register_congestion_control() to reject a BPF CC that does not
implement all required functions, as it will do for a non-BPF CC.

When a CC implements tcp_congestion_ops.cong_control(), the alternate
cong_avoid() is not in use in the TCP stack. Previously, a BPF CC was
still forced to implement cong_avoid() as a no-op since it was
non-optional in bpf_tcp_ca.c.

Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
---
 net/ipv4/bpf_tcp_ca.c | 32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 1f5c53ede4e5..39b64f317499 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -14,18 +14,6 @@
 /* "extern" is to avoid sparse warning.  It is only used in bpf_struct_ops.c. */
 extern struct bpf_struct_ops bpf_tcp_congestion_ops;
 
-static u32 optional_ops[] = {
-	offsetof(struct tcp_congestion_ops, init),
-	offsetof(struct tcp_congestion_ops, release),
-	offsetof(struct tcp_congestion_ops, set_state),
-	offsetof(struct tcp_congestion_ops, cwnd_event),
-	offsetof(struct tcp_congestion_ops, in_ack_event),
-	offsetof(struct tcp_congestion_ops, pkts_acked),
-	offsetof(struct tcp_congestion_ops, min_tso_segs),
-	offsetof(struct tcp_congestion_ops, sndbuf_expand),
-	offsetof(struct tcp_congestion_ops, cong_control),
-};
-
 static u32 unsupported_ops[] = {
 	offsetof(struct tcp_congestion_ops, get_info),
 };
@@ -51,18 +39,6 @@ static int bpf_tcp_ca_init(struct btf *btf)
 	return 0;
 }
 
-static bool is_optional(u32 member_offset)
-{
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(optional_ops); i++) {
-		if (member_offset == optional_ops[i])
-			return true;
-	}
-
-	return false;
-}
-
 static bool is_unsupported(u32 member_offset)
 {
 	unsigned int i;
@@ -268,14 +244,6 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
 		return 1;
 	}
 
-	if (!btf_type_resolve_func_ptr(btf_vmlinux, member->type, NULL))
-		return 0;
-
-	/* Ensure bpf_prog is provided for compulsory func ptr */
-	prog_fd = (int)(*(unsigned long *)(udata + moff));
-	if (!prog_fd && !is_optional(moff) && !is_unsupported(moff))
-		return -EINVAL;
-
 	return 0;
 }
 
-- 
2.30.2

