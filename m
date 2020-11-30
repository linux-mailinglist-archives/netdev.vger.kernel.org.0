Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9782C8D67
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388253AbgK3SyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388189AbgK3SyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:54:09 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5385C0613D3;
        Mon, 30 Nov 2020 10:53:28 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id g18so463162pgk.1;
        Mon, 30 Nov 2020 10:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ifPzIxfVrGp0MkZKK1c0SVJ6+sKps1Wx5g+mcmrszg4=;
        b=Ev+I42/WDjgKUzgGtnANClHQ9gR9WDUZnmBy9KkrbcSt3QcylXsfL0V6ER4k8QAj3A
         uptoYE24Uzb9huFBiktrYfn1lLSv+IsAklDvvwnmX5Gx4y4Rq+Uyfk04FBYD+O+SK0id
         ZCY0ULZLuv+N7sT3O4VnQBuT2VIC5kSSX/hvtsg9sArb3CU3CtDLzY7JB44LPfXPGYBv
         LEC6Aao5FtJWrCitLIJ1etzWF/teGntq76Si/t+O6xlr5hZAcgSkoSND/HvpJ+zypPBm
         soPac9db49ZBZT/FVpfYmlLXQzawoRrEALTq9Z4uAi/hmXuYo34rjW/kBerWgMkzoe0p
         tAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifPzIxfVrGp0MkZKK1c0SVJ6+sKps1Wx5g+mcmrszg4=;
        b=qlahen5rjN939KYTISzvaC5YxAhxKT9btwQg65R6oDjAVzkA+QhUgsb2cj9zlucswm
         2F1psE6LH2T0IO+uDlyN6pj1muExzXE4raGflgrw0G9f0lJ3lzLVtzwWzz0xabz07EqS
         u0ALr02IRx1Ods8edoTznWOp/P+PoppA5AQKEbEtpMOvzaPqMjD2cznh3yIt+VeaIkt4
         qcL2iAeE0Y07xiNtIZVMCsuCYEKsciz7IyAQF7dwxca7mrTsHGnqz1nuTm8lIGHbQtfT
         dXTaVtCnHv337VgkV0pMKn4Ce0JNOez4pEij6HH0q7y9qO360QRp3oxicZRYuUE+SAeX
         Y/Ng==
X-Gm-Message-State: AOAM531ywvOkqLV+C5XHo9cSwY8FejnDqf51DHuWGgZPowzIhO5ybu3o
        bH6Pu/N2MMfK/0yH2Q/EAqTTgKgDCYv3SQhvCL4=
X-Google-Smtp-Source: ABdhPJzFJI8III8i86/rrPJj8GhR259X/PPDwsEFS+WdKScE+bnODdG5zyDLCbnEbObXNm51WPJ6Ew==
X-Received: by 2002:a63:3d8c:: with SMTP id k134mr19043360pga.53.1606762407800;
        Mon, 30 Nov 2020 10:53:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:53:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 08/10] samples/bpf: use recvfrom() in xdpsock/l2fwd
Date:   Mon, 30 Nov 2020 19:52:03 +0100
Message-Id: <20201130185205.196029-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130185205.196029-1-bjorn.topel@gmail.com>
References: <20201130185205.196029-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Start using recvfrom() the l2fwd scenario, instead of poll() which is
more expensive and need additional knobs for busy-polling.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index f90111b95b2e..a1a3d6f02ba9 100644
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
@@ -1134,7 +1133,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 				exit_with_error(-ret);
 			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				xsk->app_stats.fill_fail_polls++;
-				ret = poll(fds, num_socks, opt_timeout);
+				recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL,
+					 NULL);
 			}
 			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 		}
@@ -1331,19 +1331,19 @@ static void tx_only_all(void)
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
@@ -1353,7 +1353,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		complete_tx_l2fwd(xsk, fds);
+		complete_tx_l2fwd(xsk);
 		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
@@ -1388,22 +1388,20 @@ static void l2fwd_all(void)
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

