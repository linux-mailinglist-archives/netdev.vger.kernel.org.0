Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EF554AEB8
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356022AbiFNKsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354047AbiFNKr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:47:57 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14AD24091;
        Tue, 14 Jun 2022 03:47:48 -0700 (PDT)
Received: from SPMA-01.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 769617E088F_2A86753B;
        Tue, 14 Jun 2022 10:47:47 +0000 (GMT)
Received: from mail.tu-berlin.de (postcard.tu-berlin.de [141.23.12.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-01.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 048617E3E56_2A86753F;
        Tue, 14 Jun 2022 10:47:47 +0000 (GMT)
Received: from jt.fritz.box (89.12.240.121) by ex-01.svc.tu-berlin.de
 (10.150.18.5) with Microsoft SMTP Server id 15.2.986.22; Tue, 14 Jun 2022
 12:47:46 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next v3 2/5] bpf: Require only one of cong_avoid() and cong_control() from a TCP CC
Date:   Tue, 14 Jun 2022 12:44:49 +0200
Message-ID: <20220614104452.3370148-3-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=O0GyPckc2Zo5K3iippstMLdskbDi62iHNe+sjJN7rUE=; b=RjftHwL45i2GTh42d9IV/0m/qcBck8ed565826GP5l1pUfEmUUyqXOZhjbVTrHMD/NeifhlnwSFoUzrgUwN7AcCW+8d/+0H9wx0XDFdcO0SViI3pkQxzG6J6cnqRGrZlABPTV/dfb4XixdhazcZ7nOk47UxFCvRwmJPsc08oHVQ=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 kernel/bpf/bpf_struct_ops.c |  7 +++----
 net/ipv4/bpf_tcp_ca.c       | 33 ---------------------------------
 2 files changed, 3 insertions(+), 37 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index d9a3c9207240..7e0068c3399c 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -503,10 +503,9 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		goto unlock;
 	}
 
-	/* Error during st_ops->reg().  It is very unlikely since
-	 * the above init_member() should have caught it earlier
-	 * before reg().  The only possibility is if there was a race
-	 * in registering the struct_ops (under the same name) to
+	/* Error during st_ops->reg(). Can happen if this struct_ops needs to be
+	 * verified as a whole, after all init_member() calls. Can also happen if
+	 * there was a race in registering the struct_ops (under the same name) to
 	 * a sub-system through different struct_ops's maps.
 	 */
 	set_memory_nx((long)st_map->image, 1);
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 1f5c53ede4e5..7a181631b995 100644
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
@@ -246,7 +222,6 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
 {
 	const struct tcp_congestion_ops *utcp_ca;
 	struct tcp_congestion_ops *tcp_ca;
-	int prog_fd;
 	u32 moff;
 
 	utcp_ca = (const struct tcp_congestion_ops *)udata;
@@ -268,14 +243,6 @@ static int bpf_tcp_ca_init_member(const struct btf_type *t,
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

