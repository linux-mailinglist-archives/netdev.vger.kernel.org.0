Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175C82B0422
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgKLLoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgKLLmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:42:03 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35661C061A4A;
        Thu, 12 Nov 2020 03:42:03 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id r186so3980140pgr.0;
        Thu, 12 Nov 2020 03:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aL1oSym+s9OzD6DoNGueBD3Ryf10nlCktbhC6BtDoj0=;
        b=o5Ltb0EMHhKqkUY1XXqRbI2ZJasG6FMXPRHFyC9YmaIHXOXUb/PEe2Sf1b9Ku2vE4I
         HdrdnRM4Vpmb6MKJSuemB9KiH/B6227+L5qw4hcehHa3PKTKtqy7sU46HB70Wc+EC2It
         MZsT5qmMUS42wpYTLjeUr9QPUShBCqJoiv8+Mbgik5HBCO0ON+AWEb7QetfhIo6BZESP
         U0dQRsro4qekEFRJ5SIZOpsHvnrtMDsSF5W0s5MNmu7lXENBJWvBFirXQ1BUgAGqjYIV
         H2OmdfDN9j+YTuLKFoLBVXD8xbTh0HC8Xr1c5CPvLklg9oNlrX87AN0NplGwXfs5asMe
         2Haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aL1oSym+s9OzD6DoNGueBD3Ryf10nlCktbhC6BtDoj0=;
        b=YEMMW5oObwyKkDLetMPVg929saf8DN5RkbtebuNg/LduSBrQrQ/m7h5PMeG60/OKH+
         9VHbawX9wv9ax9cs7/IU5qfl8ZZYksu99CNumPWEoaFwqpRmZUvVP8eMbNmGyOn/67Vm
         rmUZQd5I716F3ujF2dom2LIhePFPTb1i9HTi4+7D4lvol5RbfIeqbg4nzDzAX7bOUX5e
         TeyFBhxLVDxAVgGIBiP/1k2ZIntZ5rgLXQqcS7e1cQd29au2nTtH6NIPI4V3psHngdsj
         BSKX+KcLW3g+oiXqn+6gO8wbeNkyg0h84aVBAYkVuZR7gV2alrLyQwDBYEsZav9cN3nZ
         Gung==
X-Gm-Message-State: AOAM531eQsXzYTGZJ8mG7miv/zqZMfSsbBC4UjbVTBMUdYxClMHgAZli
        G+FILzvCkwv1plIY9HbW1Sl9ToPqng1GljGP
X-Google-Smtp-Source: ABdhPJyOB9cZSJmC2gpSAeDnRj6RdCzyk5c/YfNP9zGNMf+NhxFCwGK4di1UzApfEA5lgIMS7VlW6w==
X-Received: by 2002:a17:90a:fa4:: with SMTP id 33mr9509902pjz.47.1605181322266;
        Thu, 12 Nov 2020 03:42:02 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:42:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 8/9] samples/bpf: add busy-poll support to xdpsock
Date:   Thu, 12 Nov 2020 12:40:40 +0100
Message-Id: <20201112114041.131998-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
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
index 96d0b6482ac4..8ecacbae7682 100644
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

