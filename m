Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751B2DFE2F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 09:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387623AbfJVHWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 03:22:25 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35074 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbfJVHWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 03:22:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so10083624pfw.2;
        Tue, 22 Oct 2019 00:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3F54sVgfgf27b9oyXQ7rzYum3zLQJqZpZox15Qr7YY=;
        b=X+UEbTMAUkz/mR3/z/4d0sDEzF/eOgGOT++3spXR13uhHwWB2gOtHFrsCpgJUrixVG
         Npq/ySKyoPPovZI02HCK3//Dkqo3EOX2cR0h0CdvnxIkYolABkQJsGqRdzv6VfKmC+v1
         Mp2dX5GIcm/AEjnV29rmZc9ZEx+OU4/OZSVwJlYoq/0y1pJfl2D5yWW5nvY6Q1gt+WrH
         kXSBHvwjd1UeBM3iqraEZFUqw6zfrlb75lg3eS9O7G6li0cedc/0sGjC4veKTHpsv3M9
         F6BLUoCUVVTmxf4OAtLXgtYiDckvLCz52pqVW5xk1pnx+c4K0Arjy0h3IvioqEepEgdV
         A/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H3F54sVgfgf27b9oyXQ7rzYum3zLQJqZpZox15Qr7YY=;
        b=JmHiW/CxzDgGhskBP2nokcEf7gvcu3zckcrv1fT3mbhKQ/dundAxReHRdLfhfRgGse
         Gk5PfLSx+PxcGle2JOOZyoq+cktYxjIJDGZgga8rQP+NZgaSRb+sUrMRnCf/A9fD5ot2
         j31gAYzQzRDR7RHZrHv0sNszE3nR5iPs7MBOhAkPCjtFZq1wxFlScmv2DJwg1yFT/Xm2
         kozKqn70S+Ml2W5eR9wuz5EKcffMWVxQSGDOBdKf55DSvxJ/pJtumO9SjDfHMogyuuwN
         UTRoX6BhllJ3wLEI+olrthOi9GPC2GLz/36cTZgIGYD57dNKDPRbRsDz91F+U+RyS8LS
         /KLw==
X-Gm-Message-State: APjAAAU/29VRg/Uez/ae2wi+YXicqsBEMIUs/QbIgPnkeooPkDrGKbpP
        STaSmBgrCwbQiSwTUn0f05m+mILss4Fm8w==
X-Google-Smtp-Source: APXvYqwkpJebP8B1G9sbPXMmAUdaZZRPl0R5b2bLcHz/d5IapNIIUQU1WTNXOxl2YoNXB9iHA3KNYw==
X-Received: by 2002:a17:90a:8992:: with SMTP id v18mr2815254pjn.65.1571728944143;
        Tue, 22 Oct 2019 00:22:24 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id o60sm20310821pje.21.2019.10.22.00.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 00:22:23 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, toke@redhat.com,
        sridhar.samudrala@intel.com
Subject: [PATCH bpf-next v3] libbpf: use implicit XSKMAP lookup from AF_XDP XDP program
Date:   Tue, 22 Oct 2019 09:22:06 +0200
Message-Id: <20191022072206.6318-1-bjorn.topel@gmail.com>
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
v2->v3: Avoid masking/zero-extension by using JMP32 [3]

[1] # xdpsock -i eth0 -z -r
[2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/
[3] https://lore.kernel.org/bpf/87v9sip0i8.fsf@toke.dk/

Suggested-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 42 ++++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 78665005b6f7..9a2af445ef23 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -274,33 +274,55 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 	/* This is the C-program:
 	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
 	 * {
-	 *     int index = ctx->rx_queue_index;
+	 *     int ret, index = ctx->rx_queue_index;
 	 *
 	 *     // A set entry here means that the correspnding queue_id
 	 *     // has an active AF_XDP socket bound to it.
+	 *     ret = bpf_redirect_map(&xsks_map, index, XDP_PASS);
+	 *     if (ret > 0)
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
+		/* if w0 != 0 goto pc+13 */
+		BPF_JMP32_IMM(BPF_JSGT, BPF_REG_0, 0, 13),
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

