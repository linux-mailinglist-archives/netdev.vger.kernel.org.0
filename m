Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82B42B4234
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729688AbgKPLFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKPLFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:05:34 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5324C0613CF;
        Mon, 16 Nov 2020 03:05:34 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id j19so6091429pgg.5;
        Mon, 16 Nov 2020 03:05:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ox+Gu8oX8q3AYdKpOHlwt3cd8ctIGiNWqRigSBry/Cc=;
        b=nugf//tFoPdtX3rHhD+mNGsjEN4FeaMhlqwp4Yy2bkwKW9gl0GhSIdvo1jhRBcpERE
         1f3I7UxqG7FfJ5Ha6UCxt21O5zEztyuzOHbMkgjRNrWfZcxIe/rfhcNME9tml/9n/8vG
         mA6bLp62YJ8JKhMJdvlf2jatX/I5hQmwSK+69mKbMPsZJa3A1Mv7gUMxV7pVBMeyClPo
         PqRl/XMj5/y15HM1nziO+sU6naBAyPgTCxJMNk1Bu2e7h/E0ANt306Gl9xVdiMo+w3Zz
         2V3TXVMsMOr1u2V0m/X8jncP2Nv5c/XL2QKvKrFvyt/vVRhL0/zmznk5ZhESQf1GXMO1
         17Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ox+Gu8oX8q3AYdKpOHlwt3cd8ctIGiNWqRigSBry/Cc=;
        b=BShxYy07eBdIlIo2q/ArRmpWQ4gmf/p5+ArsNmUfnsozArvjLiGZmjDlDaDLtjGNri
         6S0vNDyX2tJw4R/AlvhEsjRDihNEeUYOjDo/mlSM3+JbulBl3NFEOX0/z6mQOurBN7Z1
         ZJMHVvMQ1AfL3qvzQnpEkm243bbI+7zDgWZ8a9eqoG331JYAF5tKQ/RmFv79ypvqSBrc
         WkOaeaHP6S/XtmGwkGy98Fe//X/e2clWt4bZWZhYRcaXCQUeRd5TttZPhnniw1ECHqMN
         /xtm8q/Kegl9+lO6KdcF9grLOVgNNnnMT20pWebuAzQefukA0hSa3Yg3lFYIs+p7VTWX
         v3eQ==
X-Gm-Message-State: AOAM533Gicc6BWmgK2VFDHxCX4bgDJtV9E0ufWeARpw46qwIEMmFL9IB
        l6ll0QpN5ilW1jetIscG4jqLQ2eQhibN9RR/
X-Google-Smtp-Source: ABdhPJyTbqRj63A1IOkt71O75qVXlaOfcnNL6+XlBNhecD7ZEqrkMSqFMIEY7SgTLJ7ATc2/ovUy4A==
X-Received: by 2002:a17:90a:9dc6:: with SMTP id x6mr15828957pjv.100.1605524733695;
        Mon, 16 Nov 2020 03:05:33 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:05:32 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 09/10] samples/bpf: add busy-poll support to xdpsock
Date:   Mon, 16 Nov 2020 12:04:15 +0100
Message-Id: <20201116110416.10719-10-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201116110416.10719-1-bjorn.topel@gmail.com>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
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
index bc4ef3ac9dfb..09a9fc76f072 100644
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
@@ -1179,7 +1184,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 
 	rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
 	if (!rcvd) {
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.rx_empty_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1190,7 +1195,7 @@ static void rx_drop(struct xsk_socket_info *xsk)
 	while (ret != rcvd) {
 		if (ret < 0)
 			exit_with_error(-ret);
-		if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
+		if (opt_busy_poll || xsk_ring_prod__needs_wakeup(&xsk->umem->fq)) {
 			xsk->app_stats.fill_fail_polls++;
 			recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
 		}
@@ -1341,7 +1346,7 @@ static void l2fwd(struct xsk_socket_info *xsk)
 
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

