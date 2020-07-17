Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF0A22396E
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgGQKgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGQKgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:36:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E88C061755
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:36:02 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id x9so12026492ljc.5
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YSrKV3F/+kj7mAVdK64Rr/OQq7GDyKmHxXrNmHW8dUQ=;
        b=Eb619zQSEBk1O8WrtwwH+SvMLKfCmLSSS1NXNdLlaSA/n7k2nVIVhdyZaEQ7LbvdYF
         WawPvgGwkXja9PL/ebKE0sJYcsTSefavkO3G8HzpBHOvq8hqegOOHP/TQxgBmpIVOtQG
         FFSLhCyANBBLNzdM1743+RITzp8xkUPeGTaQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YSrKV3F/+kj7mAVdK64Rr/OQq7GDyKmHxXrNmHW8dUQ=;
        b=chC4UPjdW+zf5ym993lLjQYcZ6SCXi/nBL5zNuWKpGdZEGL2buVZ/Vfz9mEwL3rGxu
         YcefBnAG8t5ZNLsisKwryFWJa4iGipgma5/mleHxueZdC9OcP6YL1198XlDjL4hvemj5
         1Qlqq3R5WTy1TSQ3m+h8QeB/OTz+IF/ciKmLRxiTpbfYDvXTavurqwySBJb1yo1XtTxi
         MqTxw45IfJyNRtXchCpSuuLBDrWH6UAEf2F+gYC9X8bUN3V+IQQwlb6m0GUF/1HSohWR
         w1OiSc/eiJ+2PYps8VAK5mphvhuAM7xaYt15aC00deaAMnN13BOstz9KBWv8nvflEBbZ
         ytFA==
X-Gm-Message-State: AOAM531fYQ2K5/hCeSYcKYi28hfTcnUsNIpUHTrZPenI3MaNVQLAsJRw
        hYZdDuJwSu8XinVfHV5Rdz6yDw==
X-Google-Smtp-Source: ABdhPJyTKdQzM9XIo6uXGiZ8YdzMaHJTefywUhvX/ZpnK/fa4xPw80O9qprDf04zAGBkx9o0nKUzVQ==
X-Received: by 2002:a05:651c:217:: with SMTP id y23mr4444515ljn.447.1594982160439;
        Fri, 17 Jul 2020 03:36:00 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a17sm1589818lji.5.2020.07.17.03.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:59 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v5 14/15] selftests/bpf: Add verifier tests for bpf_sk_lookup context access
Date:   Fri, 17 Jul 2020 12:35:35 +0200
Message-Id: <20200717103536.397595-15-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exercise verifier access checks for bpf_sk_lookup context fields.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v5:
    - Return an allowed value (SK_DROP) in all tests.
    
    v4:
    - Bring back tests for narrow loads.
    
    v3:
    - Consolidate ACCEPT tests into one.
    - Deduplicate REJECT tests and arrange them into logical groups.
    - Add tests for out-of-bounds and unaligned access.
    - Cover access to newly introduced 'sk' field.
    
    v2:
     - Adjust for fields renames in struct bpf_sk_lookup.

 .../selftests/bpf/verifier/ctx_sk_lookup.c    | 492 ++++++++++++++++++
 1 file changed, 492 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
new file mode 100644
index 000000000000..2ad5f974451c
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -0,0 +1,492 @@
+{
+	"valid 1,2,4,8-byte reads from bpf_sk_lookup",
+	.insns = {
+		/* 1-byte read from family field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family) + 3),
+		/* 2-byte read from family field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family) + 2),
+		/* 4-byte read from family field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+
+		/* 1-byte read from protocol field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol) + 3),
+		/* 2-byte read from protocol field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol) + 2),
+		/* 4-byte read from protocol field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol)),
+
+		/* 1-byte read from remote_ip4 field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4) + 3),
+		/* 2-byte read from remote_ip4 field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4) + 2),
+		/* 4-byte read from remote_ip4 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4)),
+
+		/* 1-byte read from remote_ip6 field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 3),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 4),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 5),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 6),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 7),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 8),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 9),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 10),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 11),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 12),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 13),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 14),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 15),
+		/* 2-byte read from remote_ip6 field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 2),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 4),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 6),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 8),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 10),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 12),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 14),
+		/* 4-byte read from remote_ip6 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6)),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 4),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 8),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6) + 12),
+
+		/* 1-byte read from remote_port field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port) + 3),
+		/* 2-byte read from remote_port field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port) + 2),
+		/* 4-byte read from remote_port field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port)),
+
+		/* 1-byte read from local_ip4 field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4) + 3),
+		/* 2-byte read from local_ip4 field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4) + 2),
+		/* 4-byte read from local_ip4 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4)),
+
+		/* 1-byte read from local_ip6 field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 3),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 4),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 5),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 6),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 7),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 8),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 9),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 10),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 11),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 12),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 13),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 14),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 15),
+		/* 2-byte read from local_ip6 field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 2),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 4),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 6),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 8),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 10),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 12),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 14),
+		/* 4-byte read from local_ip6 field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6)),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 4),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 8),
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6) + 12),
+
+		/* 1-byte read from local_port field */
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port)),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port) + 1),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port) + 2),
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port) + 3),
+		/* 2-byte read from local_port field */
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port)),
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port) + 2),
+		/* 4-byte read from local_port field */
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port)),
+
+		/* 8-byte read from sk field */
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* invalid 8-byte reads from a 4-byte fields in bpf_sk_lookup */
+{
+	"invalid 8-byte read from bpf_sk_lookup family field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, family)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup protocol field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, protocol)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup remote_ip4 field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip4)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup remote_ip6 field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_ip6)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup remote_port field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, remote_port)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup local_ip4 field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip4)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup local_ip6 field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_ip6)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 8-byte read from bpf_sk_lookup local_port field",
+	.insns = {
+		BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, local_port)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* invalid 1,2,4-byte reads from 8-byte fields in bpf_sk_lookup */
+{
+	"invalid 4-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 2-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_H, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 1-byte read from bpf_sk_lookup sk field",
+	.insns = {
+		BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1,
+			    offsetof(struct bpf_sk_lookup, sk)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* out of bounds and unaligned reads from bpf_sk_lookup */
+{
+	"invalid 4-byte read past end of bpf_sk_lookup",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1,
+			    sizeof(struct bpf_sk_lookup)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte unaligned read from bpf_sk_lookup at odd offset",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 1),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte unaligned read from bpf_sk_lookup at even offset",
+	.insns = {
+		BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_1, 2),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+/* in-bound and out-of-bound writes to bpf_sk_lookup */
+{
+	"invalid 8-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 2-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_H, BPF_REG_1, BPF_REG_0, 0),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 1-byte write to bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
+{
+	"invalid 4-byte write past end of bpf_sk_lookup",
+	.insns = {
+		BPF_MOV64_IMM(BPF_REG_0, 0xcafe4a11U),
+		BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_0,
+			    sizeof(struct bpf_sk_lookup)),
+		BPF_MOV32_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
-- 
2.25.4

