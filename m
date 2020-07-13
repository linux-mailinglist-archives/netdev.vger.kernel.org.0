Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6821DF1C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgGMRrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730487AbgGMRrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:24 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85936C08C5DE
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:23 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z24so18955852ljn.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VY9p1/52hi4hbQ4htxtTIqUGt8t9p8oZD49pXCtp5Y=;
        b=NvMHrWhemqv1H3THxKkL0FkfE7vlDxFp9eNx6wpwnT4iVCODukqeasR4iBq1A6BazM
         8qCePhoreocDSFNYX3MLEPH0y13INy9qO1c60i5t06BOl9qQMeFt/O8X99B4zpeoeWrK
         o8wAOrQgp4swgnVaJjQB74pbQOFr7O3UN7R/Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VY9p1/52hi4hbQ4htxtTIqUGt8t9p8oZD49pXCtp5Y=;
        b=DTE1o41V56wnx9NM3A892BqJqljhJSbFIXHvvvReD5SIrKhrn+om7A9PH1vfUrY7DU
         RM1N+8bOh9uMleRoqHWippaAbyPfTBXNzKceoZOnd23Z2JsfeMis+6c+FCS7qIk00n12
         yrHmxNChl0tJUHLY4zlD70mS2At98bKCPPoitwDSSNLeZ4G9cTVyvbAgEXtl6WxmWu49
         jnYJNQqLqO7z9wUVGH9LRCv9rbY4yXqPalqRWjCYUHKR0VoKiTxl43lY395J+82Yaes5
         UWzYwbbZYAYtRK3MwvGLCSgd63fYI/jJPXwDiPAEtgeirV30bgeLSuirPXuiA19zVp2s
         0ZhQ==
X-Gm-Message-State: AOAM533vMFlB4QL09o61hgf02OfiUDq8TRJ6OkT4cT380wRvoaUwvIgS
        Hmx+A+xTO5iJeS9QzPojQRhu6Q==
X-Google-Smtp-Source: ABdhPJztwjuJnYnnluy9WSI8DAN4XSFT/4dRKrgoOPePYqJpuB5s3IVpwKILJ7IQNeHan3ibF8w0Fg==
X-Received: by 2002:a2e:a0cd:: with SMTP id f13mr344695ljm.343.1594662441867;
        Mon, 13 Jul 2020 10:47:21 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id o1sm4752393lfi.92.2020.07.13.10.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:20 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 14/16] selftests/bpf: Add verifier tests for bpf_sk_lookup context access
Date:   Mon, 13 Jul 2020 19:46:52 +0200
Message-Id: <20200713174654.642628-15-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
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
    v4:
    - Bring back tests for narrow loads.
    
    v3:
    - Consolidate ACCEPT tests into one.
    - Deduplicate REJECT tests and arrange them into logical groups.
    - Add tests for out-of-bounds and unaligned access.
    - Cover access to newly introduced 'sk' field.
    
    v2:
     - Adjust for fields renames in struct bpf_sk_lookup.

 .../selftests/bpf/verifier/ctx_sk_lookup.c    | 471 ++++++++++++++++++
 1 file changed, 471 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

diff --git a/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
new file mode 100644
index 000000000000..24b0852984cf
--- /dev/null
+++ b/tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c
@@ -0,0 +1,471 @@
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
+		BPF_EXIT_INSN(),
+	},
+	.errstr = "invalid bpf_context access",
+	.result = REJECT,
+	.prog_type = BPF_PROG_TYPE_SK_LOOKUP,
+	.expected_attach_type = BPF_SK_LOOKUP,
+},
-- 
2.25.4

