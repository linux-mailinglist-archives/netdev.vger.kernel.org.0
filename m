Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9362B8D58
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgKSIbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgKSIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:45 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8980BC0613CF;
        Thu, 19 Nov 2020 00:31:45 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id m9so3579731pgb.4;
        Thu, 19 Nov 2020 00:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NMRhC8zh+IYTQqqgTYlOTMh6LSD+DXKN+XEFnUQTcPE=;
        b=qlaWaJSaZIRHedFKdvGot8I6ehw34/tcMw+1QlI4/j/uj9dB/fwwwSbdigzMjvUq5/
         75u2R7FcrdpQGj4kLDrCF/XOTBaOlqD/Z/U5RRqzmKfmg5g4txBGnSrkL4P0VIKzZATg
         RaAODuHMyLfV6pQ7HxO2AFaEJSf/zYQAVXbmJZWqxLDXL1dh2O4MryH1c1vpIDv/nJJY
         NnjIS6z7RmoML+M7DX5cHEFCynSGc+OXECYaJv1cUH+IzfssR6M8EHfwW2vLRejxoL5/
         p+g6PsDfkt9WQnofPbRXMQL4ys+houBstLz10VzWPd1VtaW+DE2uT2IOgoCy4PH5aSNt
         spiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NMRhC8zh+IYTQqqgTYlOTMh6LSD+DXKN+XEFnUQTcPE=;
        b=QVir7XZdPlLnrDmBX21YFt1+cLm7IVcZjZWhC8TqBX5NDn0aaY/f85h6ESgEdgCNV4
         UJiDd0f0Im8voHZCfNkCCriG7R7o1iSD6XOURr3VVdoxxAL/mAnuu3wHGvnwiXdjx93t
         OCwpkbQAk3rzCL9uLk2JN3dDc3M4S4tKy1hnwm1JcSH4rJDwYX+8Nx0tJj0me/yqlNR9
         B9963XT3N+sRV6vdJPT7hhCordW84E3UZePXMGyUP5dYVCBcg/TIBGGq4S+89+hQCknW
         BF8+wnHahFXyNS0Y4BPbrA7I4mVQ9pJoEMJ6O9xd+6U7dgX0Z9EAL8+LA2FL1t2cjynt
         efJg==
X-Gm-Message-State: AOAM532H8/joyOeHi40oMHC3zvBma0kJoJvegmfYAg6//luq4GO2+0+Z
        NbQp2ybmEDzn0Hb6+8ADq1f24ApISQgeHgmm
X-Google-Smtp-Source: ABdhPJxJ7GNl6xo+u7eCysski/VMSDBs88dMDNIUUL+lzhL6XOY1cLyYbpp3EGN9edzOAxssGercyQ==
X-Received: by 2002:a17:90b:345:: with SMTP id fh5mr3407126pjb.198.1605774704488;
        Thu, 19 Nov 2020 00:31:44 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:43 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 08/10] samples/bpf: use recvfrom() in xdpsock/l2fwd
Date:   Thu, 19 Nov 2020 09:30:22 +0100
Message-Id: <20201119083024.119566-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using recvfrom() the l2fwd scenario, instead of poll() which is
more expensive and need additional knobs for busy-polling.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index f90111b95b2e..24aa7511c4c8 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1098,8 +1098,7 @@ static void kick_tx(struct xsk_socket_info *xsk)
 	exit_with_error(errno);
 }
 
-static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
-				     struct pollfd *fds)
+static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 {
 	struct xsk_umem_info *umem = xsk->umem;
 	u32 idx_cq = 0, idx_fq = 0;
@@ -1134,7 +1133,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 				exit_with_error(-ret);
 			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				xsk->app_stats.fill_fail_polls++;
-				ret = poll(fds, num_socks, opt_timeout);
+				recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 			}
 			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
@@ -1331,19 +1330,19 @@ static void tx_only_all(void)
 		complete_tx_only_all();
 }
 
-static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
+static void l2fwd(struct xsk_socket_info *xsk)
 {
 	unsigned int rcvd, i;
 	u32 idx_rx = 0, idx_tx = 0;
 	int ret;
 
-	complete_tx_l2fwd(xsk, fds);
+	complete_tx_l2fwd(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
 		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
-			ret = poll(fds, num_socks, opt_timeout);
+			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
 		return;
 	}
@@ -1353,7 +1352,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		complete_tx_l2fwd(xsk, fds);
+		complete_tx_l2fwd(xsk);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
@@ -1388,22 +1387,20 @@ static void l2fwd_all(void)
 	struct pollfd fds[MAX_SOCKS] = {};
 	int i, ret;
 
-	for (i = 0; i < num_socks; i++) {
-		fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
-		fds[i].events = POLLOUT | POLLIN;
-	}
-
 	for (;;) {
 		if (opt_poll) {
-			for (i = 0; i < num_socks; i++)
+			for (i = 0; i < num_socks; i++) {
+				fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
+				fds[i].events = POLLOUT | POLLIN;
 				xsks[i]->app_stats.opt_polls++;
+			}
 			ret = poll(fds, num_socks, opt_timeout);
 			if (ret <= 0)
 				continue;
 		}
 
 		for (i = 0; i < num_socks; i++)
-			l2fwd(xsks[i], fds);
+			l2fwd(xsks[i]);
 
 		if (benchmark_done)
 			break;
-- 
2.27.0

