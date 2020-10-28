Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C38C29D8C5
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388347AbgJ1WgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbgJ1WgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:36:13 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4259C0613D1;
        Wed, 28 Oct 2020 15:36:12 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f21so343978plr.5;
        Wed, 28 Oct 2020 15:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wUafzXmN1fiYZSw7cbOBZF12NArhlfVl1gsXYHPJ9hM=;
        b=UYBUdFIvxBj29SgLEr+PGFX5gVUE8FB3CJJRd/bfzpIQQ5KYJtggQpbY18+Pv5Cp9U
         GETiiq9f9VgN6/0CGEKAuvp5kSsWipRguLnJ8NAhl0vX8PWSPjbxjcbxJBoCoHvFafwf
         W23JBMb9GkgESvHW/T5YT+zmhkBYllOpcFPAMyYGUWadanyIQZ3LpPrVWAW+fIzBF9lo
         0kj8lQoCHvovgnZmqayUr/fUgssea4HlPXT4VbSIgJwyvU5Fj6YscXekqqCglCv5NoiE
         JzavnYIycuqqz9tI8hlAoIZdaUKxNEH9tmqgEBH1OefZ3RvsPIECbr+xvUzf5vWy/UOP
         zyuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wUafzXmN1fiYZSw7cbOBZF12NArhlfVl1gsXYHPJ9hM=;
        b=pOGP/IATimki/PXuv+nIzwUKt0EeSalHEGzZCEo1+drjQzRZOi5yRji9ba+LCt28zJ
         ++glzABmosFkajXnd9aBUqPYQE7SeXfNEs6w2McAOwiTyQo1EKBM/AL1kXMmX6besh29
         y6ErutnKF6mlCI0pvgk4GKrWAMXJKdFC4U7RZmqu5cfOIIp9S41Xh5/xYWKgQrS8mNCh
         WWaK9Cg+TFY4G6zntBtO8zGg1qXH20L/ARG5DCbziOg96sWIG9aAB3rsOYN3+zQDSnci
         Q0eUb5YKMf7/aNkvax9d420T9IVoOu8nAV3Il/jJ/F9IYYrqqVIRwOtUBhLRXjTnoMRF
         QpAA==
X-Gm-Message-State: AOAM533TpTFNAmh+rpnBCqPsw0nsgT9UfrzNknQVPFzyBhHk4IOi2wGq
        8+N9ThxhkoY9WLbIO3mIf6jQLng9/yz0YIw7
X-Google-Smtp-Source: ABdhPJzErfbq9Axb2rnwLp5dHWjy9HVcmEllOuyy9jBLW7mTYF4ZduBV2MEQaTfs1jwmX5emGT7rtA==
X-Received: by 2002:aa7:9d03:0:b029:164:2981:2331 with SMTP id k3-20020aa79d030000b029016429812331mr7939350pfp.0.1603892150737;
        Wed, 28 Oct 2020 06:35:50 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:50 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 8/9] samples/bpf: add busy-poll support to xdpsock
Date:   Wed, 28 Oct 2020 14:34:36 +0100
Message-Id: <20201028133437.212503-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
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
index 96d0b6482ac4..7ef2c01a1094 100644
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
@@ -1132,7 +1137,7 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 		while (ret != rcvd) {
 			if (ret < 0)
 				exit_with_error(-ret);
-			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
+			if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&umem->fq)) {
 				xsk->app_stats.fill_fail_polls++;
 				ret = poll(fds, num_socks, opt_timeout);
 			}
@@ -1180,7 +1185,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1191,7 +1196,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1342,7 +1347,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
 			ret = poll(fds, num_socks, opt_timeout);
 		}
@@ -1354,7 +1359,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 		if (ret < 0)
 			exit_with_error(-ret);
 		complete_tx_l2fwd(xsk, fds);
-		if (xsk_ring_prod__needs_wakeup(&xsk->tx)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->tx)) {
 			xsk->app_stats.tx_wakeup_sendtos++;
 			kick_tx(xsk);
 		}
@@ -1461,6 +1466,24 @@ static void enter_xsks_into_map(struct bpf_object *obj)
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
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BIAS_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+
+	sock_opt = 20; // randomly picked :-P
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
@@ -1502,6 +1525,9 @@ int main(int argc, char **argv)
 	for (i = 0; i < opt_num_xsks; i++)
 		xsks[num_socks++] = xsk_configure_socket(umem, rx, tx);
 
+	for (i = 0; i < opt_num_xsks; i++)
+		apply_setsockopt(xsks[i]);
+
 	if (opt_bench == BENCH_TXONLY) {
 		gen_eth_hdr_data();
 
-- 
2.27.0

