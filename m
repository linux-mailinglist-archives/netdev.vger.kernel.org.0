Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FDDDEA45
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 12:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfJUK7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 06:59:53 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38919 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfJUK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 06:59:53 -0400
Received: by mail-pf1-f195.google.com with SMTP id v4so8206820pff.6;
        Mon, 21 Oct 2019 03:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYJmFIAnwmpDh6n3dceHfPEBPW6vUu2fNHKsRa+36qM=;
        b=vF9kAuAiLRmZ3+vqcWOGftu3pQvftFtrimwiZbJfbrOKnDFTCZDi4Zu5J861kic5pl
         Ak63Daov7n3DhJOHISNt07xKou1Q0riKV24SrKN4wZxqRgjH2gBx7b5EInLPAAHNRCB0
         zEW0MCAy2MMMyg08t4gXrij0w8/Ie9f8JkU8V/UtvGPr8ZNLyUiBN2AUfB9LWUM60J7n
         60AGprz8VMeoDM3WMB/wFYzMpCTB0Z9q81W6Ty6mv3Js6Eg6TY9akfix2C1YJXS5HvNW
         I9Z7FZQxMKrsD62LZFCI/06bWkf2aqIqPn7VwNBKfsGKQg3UtEHxVirujKT64c1arTuo
         XcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYJmFIAnwmpDh6n3dceHfPEBPW6vUu2fNHKsRa+36qM=;
        b=UdJpjZ26CyhLdyfyBtHmvBn32XeLy/yyv7RhxbhK2ILS/yL8ljDBZD3Ta5uBZCK/HE
         dGYG4T6HyrZiaRqD9USIGIJwkkOJMdH56qTL3tjwFk+nzVD6WXxDFnt9r0N6x9a21qLt
         g/Lq4WFQgF4bSPLbr/J1QwfJmJ9ccK1Is0wFgVHJ/AUz7OJKxGb3B7k0cDXT2L3lghvU
         QeEgDyWrtmQ6Twq6bO4OaGzzRORhbZgvUO11hwPV1IKvTqLMdLmBfGsIIe9JgIOBp4a0
         QIe4SuATrIU/BOyvaRGLxH09TVx52BasjnRYfh84aaLRbIDhRIBBWX4L22zZtJ+3IPOL
         OdTg==
X-Gm-Message-State: APjAAAWHtbYnLY6neruvRMiKVwy3Al7QhueTZdyQYiJIfdMGCfSQHbhL
        UY/XUjVaeALcI2FK9MaXGxdb9lNbTWjhjQ==
X-Google-Smtp-Source: APXvYqxwu8G3WHGBdmF1YseCXgYAELA6ZT0xAWBEs1V5eHheu0aPkLE8dfxp09/wwdeYgLyzhBS6fQ==
X-Received: by 2002:aa7:955a:: with SMTP id w26mr23066097pfq.193.1571655592396;
        Mon, 21 Oct 2019 03:59:52 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id 6sm13870040pgl.40.2019.10.21.03.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 03:59:51 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, toke@redhat.com,
        sridhar.samudrala@intel.com
Subject: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from AF_XDP XDP program
Date:   Mon, 21 Oct 2019 12:59:38 +0200
Message-Id: <20191021105938.11820-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
which means that the explicit lookup in the XDP program for AF_XDP is
not needed for post-5.3 kernels.

This commit adds the implicit map lookup with default action, which
improves the performance for the "rx_drop" [1] scenario with ~4%.

For pre-5.3 kernels, the bpf_redirect_map() returns XDP_ABORTED, and a
fallback path for backward compatibility is entered, where explicit
lookup is still performed. This means a slight regression for older
kernels (an additional bpf_redirect_map() call), but I consider that a
fair punishment for users not upgrading their kernels. ;-)

v1->v2: Backward compatibility (Toke) [2]

[1] # xdpsock -i eth0 -z -r
[2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/

Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index b0f532544c91..391a126b3fd8 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -274,33 +274,58 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	/* This is the C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
-	 *     int index = ctx->rx_queue_index;
+	 *     int ret, index = ctx->rx_queue_index;
 	 *
 	 *     // A set entry here means that the correspnding queue_id
 	 *     // has an active AF_XDP socket bound to it.
+	 *     ret = bpf_redirect_map(&xsks_map, index, XDP_PASS);
+	 *     ret &= XDP_PASS | XDP_REDIRECT;
+	 *     if (ret)
+	 *         return ret;
+	 *
+	 *     // Fallback for pre-5.3 kernels, not supporting default
+	 *     // action in the flags parameter.
 	 *     if (bpf_map_lookup_elem(&xsks_map, &index))
 	 *         return bpf_redirect_map(&xsks_map, index, 0);
-	 *
 	 *     return XDP_PASS;
 	 * }
 	 */
 	struct bpf_insn prog[] = {
-		/* r1 = *(u32 *)(r1 + 16) */
-		BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 16),
-		/* *(u32 *)(r10 - 4) = r1 */
-		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_1, -4),
+		/* r2 = *(u32 *)(r1 + 16) */
+		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 16),
+		/* *(u32 *)(r10 - 4) = r2 */
+		BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_2, -4),
+		/* r1 = xskmap[] */
+		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		/* r3 = XDP_PASS */
+		BPF_MOV64_IMM(BPF_REG_3, 2),
+		/* call bpf_redirect_map */
+		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
+		/* r0 &= XDP_PASS | XDP_REDIRECT */
+		BPF_ALU64_IMM(BPF_AND, BPF_REG_0, XDP_PASS | XDP_REDIRECT),
+		/* if r0 != 0 goto pc+13 */
+		BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 13),
+		/* r2 = r10 */
 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		/* r2 += -4 */
 		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -4),
+		/* r1 = xskmap[] */
 		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		/* call bpf_map_lookup_elem */
 		BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
+		/* r1 = r0 */
 		BPF_MOV64_REG(BPF_REG_1, BPF_REG_0),
-		BPF_MOV32_IMM(BPF_REG_0, 2),
-		/* if r1 == 0 goto +5 */
+		/* r0 = XDP_PASS */
+		BPF_MOV64_IMM(BPF_REG_0, 2),
+		/* if r1 == 0 goto pc+5 */
 		BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 5),
 		/* r2 = *(u32 *)(r10 - 4) */
-		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
 		BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_10, -4),
-		BPF_MOV32_IMM(BPF_REG_3, 0),
+		/* r1 = xskmap[] */
+		BPF_LD_MAP_FD(BPF_REG_1, xsk->xsks_map_fd),
+		/* r3 = 0 */
+		BPF_MOV64_IMM(BPF_REG_3, 0),
+		/* call bpf_redirect_map */
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		/* The jumps are to this instruction */
 		BPF_EXIT_INSN(),
-- 
2.20.1

