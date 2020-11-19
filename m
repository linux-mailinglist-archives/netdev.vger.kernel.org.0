Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CEA2B8D5B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKSIbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgKSIbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:52 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF4AC0613D4;
        Thu, 19 Nov 2020 00:31:51 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 10so3776506pfp.5;
        Thu, 19 Nov 2020 00:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H81TQXV5aqpX9ERL5l+zeqCXvg9bPUzTg6ItluZQr44=;
        b=ksipN2rDPr0rID8npily+buUDUpfgur627It8PtuurxtFiMEjXbMFOB6STIsTTLvI+
         Di288bq+rISAIH8Bt+Z1eg/9HnAZIZWXRvyUU5lItfiBwT+TPskHXrsgaVsNynG+4LNW
         l3RifS956gG7RBeRF8iaDg2Gbsn+OWdiaL/5lCjZVNBfrdvfW1tyiWoZ8kNLEQjEjg5g
         9IMJziIc5L3BXxcBh0w/N4BA2+Wj0CYumRiQnGi1NhR8EUj1wcDyYzdWug/BDzdmTPjC
         TH4x2g8xcE1XeQ3C4AL7yWXL6+lJyQzgNOwaDnRxVRmDsr9DXPPaax2TAnCfTUKUdB6T
         XUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H81TQXV5aqpX9ERL5l+zeqCXvg9bPUzTg6ItluZQr44=;
        b=H7uNIaxHxS4+PIEmKeREL7ixxGXGdvchqtaQnadCd68PmGgQzRxHaeyqyiV+xlrSqc
         uCvmwkHj2orqd7TlPmVyBNMeJhaQf/toC9/DIuDGViGeisM+uzSnXEBin67H9fnckIDy
         bJ7ZMCqpccK/MEW2RFn1kCXIG+zASj5ILUxZLtripLjWy3e7OW7SPerkMy+QHkVEP6e/
         csSIiJCmwYwnHBorOIxqrGC+18yy2L+pm5xcfi6Lvp0AKWOq6/GNa2ZaeQE/bDGZunvL
         GIwdqbcDOIC6EKQ7E/vUdNvm25696ergqBdVTCN17zgT6HuvuXcdLrLg7Jyr2r+g66YW
         qvCw==
X-Gm-Message-State: AOAM533ygWpYIA5phIpdLKhMa7xr5JVqkZqul4/lBNmibxSn4r2e4ydu
        uCX+z7jxS1WWsALlN5Ba1+H0LjHfqz4OMPx4
X-Google-Smtp-Source: ABdhPJxw/ZA2V0Mwr4zHaHd7Isnfmm0Ene+8ObbgMeECmjjpezn+kcagxL2WJA9NCo58/w6ZMtMr/Q==
X-Received: by 2002:a17:90a:6588:: with SMTP id k8mr1537733pjj.197.1605774710680;
        Thu, 19 Nov 2020 00:31:50 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:49 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 09/10] samples/bpf: add busy-poll support to xdpsock
Date:   Thu, 19 Nov 2020 09:30:23 +0100
Message-Id: <20201119083024.119566-10-bjorn.topel@gmail.com>
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

Add a new option to xdpsock, 'B', for busy-polling. This option will
also set the batching size, 'b' option, to the busy-poll budget.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/xdpsock_user.c | 40 +++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 24aa7511c4c8..cb1eaee8a32b 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -95,6 +95,7 @@ static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
 static u32 prog_id;
+static bool opt_busy_poll;
 
 struct xsk_ring_stats {
 	unsigned long rx_npkts;
@@ -911,6 +912,7 @@ static struct option long_options[] = {
 	{"quiet", no_argument, 0, 'Q'},
 	{"app-stats", no_argument, 0, 'a'},
 	{"irq-string", no_argument, 0, 'I'},
+	{"busy-poll", no_argument, 0, 'B'},
 	{0, 0, 0, 0}
 };
 
@@ -949,6 +951,7 @@ static void usage(const char *prog)
 		"  -Q, --quiet          Do not display any stats.\n"
 		"  -a, --app-stats	Display application (syscall) statistics.\n"
 		"  -I, --irq-string	Display driver interrupt statistics for interface associated with irq-string.\n"
+		"  -B, --busy-poll      Busy poll.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -964,7 +967,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQaI:B",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -1062,7 +1065,9 @@ static void parse_command_line(int argc, char **argv)
 				fprintf(stderr, "ERROR: Failed to get irqs for %s\n", opt_irq_str);
 				usage(basename(argv[0]));
 			}
-
+			break;
+		case 'B':
+			opt_busy_poll = 1;
 			break;
 		default:
 			usage(basename(argv[0]));
@@ -1131,7 +1136,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
+			if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				xsk->app_stats.fill_fail_polls++;
 				recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 			}
@@ -1177,7 +1182,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1188,7 +1193,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1340,7 +1345,7 @@ static void l2fwd(struct xsk_socket_info *xsk)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1353,7 +1358,7 @@ static void l2fwd(struct xsk_socket_info *xsk)
 		if (ret < 0)
 			exit_with_error(-ret);
 		complete_tx_l2fwd(xsk);
-		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
 		}
@@ -1458,6 +1463,24 @@ static void enter_xsks_into_map(struct bpf_object *obj)
 	}
 }
 
+static void apply_setsockopt(struct xsk_socket_info *xsk)
+{
+	int sock_opt;
+
+	if (!opt_busy_poll)
+		return;
+
+	sock_opt = 1;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_PREFER_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+
+	sock_opt = 20;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
@@ -1499,6 +1522,9 @@ int main(int argc, char **argv)
 	for (i = 0; i < opt_num_xsks; i++)
 		xsks[num_socks++] = xsk_configure_socket(umem, rx, tx);
 
+	for (i = 0; i < opt_num_xsks; i++)
+		apply_setsockopt(xsks[i]);
+
 	if (opt_bench == BENCH_TXONLY) {
 		gen_eth_hdr_data();
 
-- 
2.27.0

