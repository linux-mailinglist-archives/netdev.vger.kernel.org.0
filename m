Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BE85D407
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGBQOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:14:18 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47307 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfGBQOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:14:17 -0400
Received: by mail-pf1-f201.google.com with SMTP id f25so11101562pfk.14
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fx7oqRWcTVImmRr+27+RVPds6kkpL0s9ZczahtxtKQE=;
        b=hVMX4lsD1KrLKnsjgvwG+Dg8hsacRYNrn5d8zIbYvrO6YQBby8NJD0ZawAYYdg5LDm
         sIHDSvhG01Tgx9ZOGwwhlqT+o3UPmFclsa5u4+x/vcRyPMrcUpLzEAT3zHRKOr7F1DJr
         895ZMnx9KTZDErsZZzacKAAYmj1gT7ifo1dB/1CmWXFsYQu0qXfQZqJ3oyn/pomNKOcY
         cmmnPPPMOKwwewR3QQtCNMyfZcn7IZpzFlEBe/QLJA6MldJ21GVI/2T58XPgmuSsBe8Y
         gbljacppGBi3XgJm+Z6yBupDEolUJ58pDkQamjy/0fWsGS7NmvTYs8n51urdW2F2NbNP
         OSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fx7oqRWcTVImmRr+27+RVPds6kkpL0s9ZczahtxtKQE=;
        b=VZUqfaox12xe0cw7FC9EOQx7+EryxB0uL1XOdSrusrxJ4g33aNIVpQh4TKgeHcwFY3
         k8Y+9+Mn2hMis+KvJK+b3qV2dDclZP19Gg4gAhNZCzN+4L4sAv0gK0wR0WoQ5uxntDFg
         SxofSWYb3y/BnjHZTJ5fTrOciqgm8vUKeN2LYmCgQfatGX+hhCbXKocAFFCzAL2St7pJ
         9a7hWfP9rU+0TXIUVODSkO443XyWZn+FJN2ssnMkandk9lecCDbG4sIxF8YmfhK2EL8g
         ofHeSOrRfnGDFNL+kL436Ms1SYhRuR2KSmHDkw7Ys3gqJa9T4EHWbOBy/kiz8GqOwSCQ
         LkZQ==
X-Gm-Message-State: APjAAAXNOYIsAsZ5tiQ36cNQrUAE8tjIQPmwssIsTsyEAQvB//LM1CAY
        vYth1QL//EF0swjEZAm5BzrGeYBZ9xBtMpzVsNCw2+POgnqmSMI5W1sULnUvNXEiwkih5KTQFMZ
        Td4n9k6GX3OcyzdH5RwwBLILu4MKEUktmLCpkhEvchPRMiV2i38SnFg==
X-Google-Smtp-Source: APXvYqzdq1ASB4tj88cMD8V1Vx93S0qw2hKfjDuMcK/89MROE5YgTzY7FAP1hBEaqx57izdQd/bJPC0=
X-Received: by 2002:a63:6c4a:: with SMTP id h71mr31014251pgc.331.1562084056403;
 Tue, 02 Jul 2019 09:14:16 -0700 (PDT)
Date:   Tue,  2 Jul 2019 09:13:59 -0700
In-Reply-To: <20190702161403.191066-1-sdf@google.com>
Message-Id: <20190702161403.191066-5-sdf@google.com>
Mime-Version: 1.0
References: <20190702161403.191066-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v2 4/8] bpf: add icsk_retransmits to bpf_tcp_sock
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some inet_connection_sock fields to bpf_tcp_sock that might be useful
for debugging congestion control issues.

Cc: Eric Dumazet <edumazet@google.com>
Cc: Priyaranjan Jha <priyarjha@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/uapi/linux/bpf.h |  1 +
 net/core/filter.c        | 20 +++++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bfb0b1a76684..ead27aebf491 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3078,6 +3078,7 @@ struct bpf_tcp_sock {
 				 */
 	__u32 delivered;	/* Total data packets delivered incl. rexmits */
 	__u32 delivered_ce;	/* Like the above but only ECE marked packets */
+	__u32 icsk_retransmits;	/* Number of unrecovered [RTO] timeouts */
 };
 
 struct bpf_sock_tuple {
diff --git a/net/core/filter.c b/net/core/filter.c
index 3da4b6c38b46..089aaea0ccc6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5544,7 +5544,8 @@ static const struct bpf_func_proto bpf_sock_addr_sk_lookup_udp_proto = {
 bool bpf_tcp_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 				  struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock, delivered_ce))
+	if (off < 0 || off >= offsetofend(struct bpf_tcp_sock,
+					  icsk_retransmits))
 		return false;
 
 	if (off % size != 0)
@@ -5575,6 +5576,20 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 				      offsetof(struct tcp_sock, FIELD)); \
 	} while (0)
 
+#define BPF_INET_SOCK_GET_COMMON(FIELD)					\
+	do {								\
+		BUILD_BUG_ON(FIELD_SIZEOF(struct inet_connection_sock,	\
+					  FIELD) >			\
+			     FIELD_SIZEOF(struct bpf_tcp_sock, FIELD));	\
+		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			\
+					struct inet_connection_sock,	\
+					FIELD),				\
+				      si->dst_reg, si->src_reg,		\
+				      offsetof(				\
+					struct inet_connection_sock,	\
+					FIELD));			\
+	} while (0)
+
 	if (insn > insn_buf)
 		return insn - insn_buf;
 
@@ -5661,6 +5676,9 @@ u32 bpf_tcp_sock_convert_ctx_access(enum bpf_access_type type,
 	case offsetof(struct bpf_tcp_sock, delivered_ce):
 		BPF_TCP_SOCK_GET_COMMON(delivered_ce);
 		break;
+	case offsetof(struct bpf_tcp_sock, icsk_retransmits):
+		BPF_INET_SOCK_GET_COMMON(icsk_retransmits);
+		break;
 	}
 
 	return insn - insn_buf;
-- 
2.22.0.410.gd8fdbe21b5-goog

