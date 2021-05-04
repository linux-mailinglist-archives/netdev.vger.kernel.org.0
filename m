Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FFA372E36
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbhEDQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 12:47:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhEDQq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 12:46:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6042F61003;
        Tue,  4 May 2021 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620146764;
        bh=LqzpUIgpPcgeDloTgTqGkOEMwxRpi9AAugwRfmQ4hwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ENkXK3a8xSSMjMhjuQhU6wWAdM45/Lj9jkuN5tiNLG+khkJVHffd9T4OQHd8ql3lR
         yF05hyeGSTjQOKYxekteyM5fA9VjZZkWRbRo0FKZjPbA5gbK7GQSSvSdOLmqbIryeG
         Kmv3QmATN4rckTQ783g977zJnic4CBBfr4uXE8KCECAZGardmj+cFJtUEQoOoab8mp
         BL8QkTKrXJ43euzDseND6TMhXiL3yj+fSfcMQGwTuVBF89K/s0O+vyhK94cUFbhD2A
         EWqe/jcRtr1ub5u3rkydwvZBCG/EntTUaQdbbKg1nYN5qZfd5wJiEGho2MVvo57She
         992BdG6JNIzRQ==
Date:   Tue, 4 May 2021 09:46:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when
 printing stats
Message-ID: <20210504094603.0db1269c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3737927a-7352-5a07-e19a-6b09470734a5@gmail.com>
References: <20210501031059.529906-1-kuba@kernel.org>
        <20210503075739.46654252@hermes.local>
        <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <be91d0cd-6233-3c8d-e310-a1b7fc842b48@gmail.com>
        <20210503122242.6ae77bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3737927a-7352-5a07-e19a-6b09470734a5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 May 2021 20:15:27 -0600 David Ahern wrote:
> On 5/3/21 1:22 PM, Jakub Kicinski wrote:
> > On Mon, 3 May 2021 11:16:41 -0600 David Ahern wrote:  
> >> I think it can be a follow on change. This one is clearly an improvement
> >> for large numbers.  
> > 
> > Fun little discrepancy b/w JSON and plain on what's printed with -s 
> > vs -s -s: JSON output prints rx_over_errors where plain would print
> > rx_missed_errors. I will change plain to follow JSON, since presumably
> > we should worry more about breaking machine-readable format.
> 
> you mean from this commit?
> 
> commit b8663da04939dd5de223ca0de23e466ce0a372f7
> Author: Jakub Kicinski <kuba@kernel.org>
> Date:   Wed Sep 16 12:42:49 2020 -0700
> 
>     ip: promote missed packets to the -s row

Yes, with table driven printing we will lose that again.

With the implementation I have we don't save that much LoC:

 ip/ipaddress.c | 339 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 170 insertions(+), 169 deletions(-)

----->8------
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 06ca7273c531..6b3b03002a52 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -10,7 +10,6 @@
  *
  */
 
-#include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -545,27 +544,18 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 		print_vf_stats64(fp, vf[IFLA_VF_STATS]);
 }
 
-static void size_columns(unsigned int cols[], unsigned int n, ...)
+static void size_column(unsigned int *col, uint64_t val)
 {
-	unsigned int i, len;
-	uint64_t val, powi;
-	va_list args;
-
-	va_start(args, n);
-
-	for (i = 0; i < n; i++) {
-		val = va_arg(args, unsigned long long);
-
-		if (human_readable)
-			continue;
+	unsigned int len;
+	uint64_t powi;
 
-		for (len = 1, powi = 10; powi < val; len++, powi *= 10)
-			/* nothing */;
-		if (len > cols[i])
-			cols[i] = len;
-	}
+	if (human_readable)
+		return;
 
-	va_end(args);
+	for (len = 1, powi = 10; powi < val; len++, powi *= 10)
+		/* nothing */;
+	if (len > *col)
+		*col = len;
 }
 
 void print_num(FILE *fp, unsigned int width, uint64_t count)
@@ -679,192 +669,203 @@ static void print_vf_stats64(FILE *fp, struct rtattr *vfstats)
 	}
 }
 
+struct stats_desc {
+	const char *json_key;
+	const char *hdr;
+	unsigned int offset;
+	bool hide;
+	bool empty;
+	bool direct;
+};
+
+#define STATS_DESC(_json_key, _hdr, _memb)				\
+	{								\
+		.json_key = (_json_key),				\
+		.hdr = (_hdr),						\
+		.offset = offsetof(struct rtnl_link_stats64, _memb),	\
+	}
+#define STATS_EMPTY		{ .hdr = "", .empty = true, }
+
+#define N_STAT_COLUMNS	7
+
+static const struct stats_desc _stats_rx[N_STAT_COLUMNS] = {
+	STATS_DESC("bytes", "bytes", rx_bytes),
+	STATS_DESC("packets", "packets", rx_packets),
+	STATS_DESC("errors", "errors", rx_errors),
+	STATS_DESC("dropped", "dropped", rx_dropped),
+	STATS_DESC("over_errors", "overrun", rx_over_errors),
+	STATS_DESC("multicast", "mcast", multicast),
+	STATS_DESC("compressed", "compressed", rx_compressed),
+};
+
+static const struct stats_desc _stats_rx_err[N_STAT_COLUMNS] = {
+	STATS_EMPTY,
+	STATS_DESC("length_errors", "length", rx_length_errors),
+	STATS_DESC("crc_errors", "crc", rx_crc_errors),
+	STATS_DESC("frame_errors", "frame", rx_frame_errors),
+	STATS_DESC("fifo_errors", "fifo", rx_fifo_errors),
+	STATS_DESC("missed_errors", "missed", rx_missed_errors),
+	STATS_DESC("nohandler", "nohandler", rx_nohandler),
+};
+
+static const struct stats_desc _stats_tx[N_STAT_COLUMNS] = {
+	STATS_DESC("bytes", "bytes", tx_bytes),
+	STATS_DESC("packets", "packets", tx_packets),
+	STATS_DESC("errors", "errors", tx_errors),
+	STATS_DESC("dropped", "dropped", tx_dropped),
+	STATS_DESC("carrier_errors", "carrier", tx_carrier_errors),
+	STATS_DESC("collisions", "collsns", collisions),
+	STATS_DESC("compressed", "compressed", tx_compressed),
+};
+
+static const struct stats_desc _stats_tx_err[N_STAT_COLUMNS] = {
+	STATS_EMPTY,
+	STATS_DESC("aborted_errors", "aborted", tx_aborted_errors),
+	STATS_DESC("fifo_errors", "fifo", tx_fifo_errors),
+	STATS_DESC("window_errors", "window", tx_window_errors),
+	STATS_DESC("heartbeat_errors", "heartbt", tx_heartbeat_errors),
+	{ .json_key = "carrier_changes", .hdr = "transns", .direct = true, },
+	{ .hide = true, },
+};
+
+static void stat_table_print_json(struct rtnl_link_stats64 *s,
+				  const struct stats_desc desc[])
+{
+	unsigned int i;
+
+	for (i = 0; i < N_STAT_COLUMNS; i++) {
+		if (desc[i].hide || desc[i].empty)
+			continue;
+		print_u64(PRINT_JSON, desc[i].json_key, NULL,
+			  desc[i].direct ? desc[i].offset :
+			  ((__u64 *)s)[desc[i].offset / sizeof(__u64)]);
+	}
+}
+
+static void stat_table_size_columns(const char *pfx,
+				    struct rtnl_link_stats64 *s,
+				    unsigned int cols[],
+				    const struct stats_desc desc[])
+{
+	unsigned int i, len;
+
+	for (i = 0; i < N_STAT_COLUMNS; i++) {
+		if (desc[i].hide)
+			continue;
+		len = desc[i].empty ? 0 : strlen(desc[i].hdr);
+		if (i == 0)
+			len += strlen(pfx) + !desc[i].empty;
+		if (len > cols[i])
+			cols[i] = len;
+		if (desc[i].empty)
+			continue;
+		size_column(&cols[i], desc[i].direct ? desc[i].offset :
+			    ((__u64 *)s)[desc[i].offset / sizeof(__u64)]);
+	}
+}
+
+static void stat_table_print_fp(FILE *fp, const char *pfx,
+				struct rtnl_link_stats64 *s,
+				unsigned int cols[],
+				const struct stats_desc desc[])
+{
+	unsigned int i, col;
+
+	fprintf(fp, "    %s", pfx);
+	for (i = 0; i < N_STAT_COLUMNS; i++) {
+		if (desc[i].hide)
+			continue;
+		col = cols[i];
+		if (i == 0)
+			col -= strlen(pfx) + 1;
+		fprintf(fp, "%*s", col + 1, desc[i].hdr);
+	}
+	fprintf(fp, "%s", _SL_);
+
+	fprintf(fp, "    ");
+	for (i = 0; i < N_STAT_COLUMNS; i++) {
+		if (desc[i].hide)
+			continue;
+		if (desc[i].empty) {
+			printf("%*s", cols[i] + 1, "");
+			continue;
+		}
+
+		print_num(fp, cols[i], desc[i].direct ? desc[i].offset :
+			  ((__u64 *)s)[desc[i].offset / sizeof(__u64)]);
+	}
+}
+
 static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 {
+	struct stats_desc stats_rx[N_STAT_COLUMNS], stats_tx[N_STAT_COLUMNS];
 	const struct rtattr *carrier_changes = tb[IFLA_CARRIER_CHANGES];
+	struct stats_desc stats_rx_err[N_STAT_COLUMNS];
+	struct stats_desc stats_tx_err[N_STAT_COLUMNS];
 	struct rtnl_link_stats64 _s, *s = &_s;
-	unsigned int cols[] = {
-		strlen("*X errors:"),
-		strlen("packets"),
-		strlen("errors"),
-		strlen("dropped"),
-		strlen("heartbt"),
-		strlen("overrun"),
-		strlen("compressed"),
-	};
+	unsigned int cols[N_STAT_COLUMNS] = { };
 	int ret;
 
 	ret = get_rtnl_link_stats_rta(s, tb);
 	if (ret < 0)
 		return;
 
+	memcpy(stats_rx, _stats_rx, sizeof(stats_rx));
+	stats_rx[6].hide = !s->rx_compressed;
+	memcpy(stats_rx_err, _stats_rx_err, sizeof(stats_rx_err));
+	stats_rx_err[6].hide = !s->rx_nohandler;
+	memcpy(stats_tx, _stats_tx, sizeof(stats_tx));
+	stats_tx[6].hide = !s->tx_compressed;
+	memcpy(stats_tx_err, _stats_tx_err, sizeof(stats_tx_err));
+	stats_tx_err[5].hide = !carrier_changes;
+	if (carrier_changes)
+		stats_tx_err[5].offset = rta_getattr_u32(carrier_changes);
+
 	if (is_json_context()) {
 		open_json_object((ret == sizeof(*s)) ? "stats64" : "stats");
 
-		/* RX stats */
 		open_json_object("rx");
-		print_u64(PRINT_JSON, "bytes", NULL, s->rx_bytes);
-		print_u64(PRINT_JSON, "packets", NULL, s->rx_packets);
-		print_u64(PRINT_JSON, "errors", NULL, s->rx_errors);
-		print_u64(PRINT_JSON, "dropped", NULL, s->rx_dropped);
-		print_u64(PRINT_JSON, "over_errors", NULL, s->rx_over_errors);
-		print_u64(PRINT_JSON, "multicast", NULL, s->multicast);
-		if (s->rx_compressed)
-			print_u64(PRINT_JSON,
-				   "compressed", NULL, s->rx_compressed);
-
-		/* RX error stats */
-		if (show_stats > 1) {
-			print_u64(PRINT_JSON,
-				   "length_errors",
-				   NULL, s->rx_length_errors);
-			print_u64(PRINT_JSON,
-				   "crc_errors",
-				   NULL, s->rx_crc_errors);
-			print_u64(PRINT_JSON,
-				   "frame_errors",
-				   NULL, s->rx_frame_errors);
-			print_u64(PRINT_JSON,
-				   "fifo_errors",
-				   NULL, s->rx_fifo_errors);
-			print_u64(PRINT_JSON,
-				   "missed_errors",
-				   NULL, s->rx_missed_errors);
-			if (s->rx_nohandler)
-				print_u64(PRINT_JSON,
-					   "nohandler", NULL, s->rx_nohandler);
-		}
+		stat_table_print_json(s, stats_rx);
+		if (show_stats > 1)
+			stat_table_print_json(s, stats_rx_err);
 		close_json_object();
 
-		/* TX stats */
 		open_json_object("tx");
-		print_u64(PRINT_JSON, "bytes", NULL, s->tx_bytes);
-		print_u64(PRINT_JSON, "packets", NULL, s->tx_packets);
-		print_u64(PRINT_JSON, "errors", NULL, s->tx_errors);
-		print_u64(PRINT_JSON, "dropped", NULL, s->tx_dropped);
-		print_u64(PRINT_JSON,
-			   "carrier_errors",
-			   NULL, s->tx_carrier_errors);
-		print_u64(PRINT_JSON, "collisions", NULL, s->collisions);
-		if (s->tx_compressed)
-			print_u64(PRINT_JSON,
-				   "compressed", NULL, s->tx_compressed);
-
-		/* TX error stats */
-		if (show_stats > 1) {
-			print_u64(PRINT_JSON,
-				   "aborted_errors",
-				   NULL, s->tx_aborted_errors);
-			print_u64(PRINT_JSON,
-				   "fifo_errors",
-				   NULL, s->tx_fifo_errors);
-			print_u64(PRINT_JSON,
-				   "window_errors",
-				   NULL, s->tx_window_errors);
-			print_u64(PRINT_JSON,
-				   "heartbeat_errors",
-				   NULL, s->tx_heartbeat_errors);
-			if (carrier_changes)
-				print_u64(PRINT_JSON, "carrier_changes", NULL,
-					   rta_getattr_u32(carrier_changes));
-		}
-
+		stat_table_print_json(s, stats_tx);
+		if (show_stats > 1)
+			stat_table_print_json(s, stats_tx_err);
 		close_json_object();
+
 		close_json_object();
 	} else {
-		size_columns(cols, ARRAY_SIZE(cols),
-			     s->rx_bytes, s->rx_packets, s->rx_errors,
-			     s->rx_dropped, s->rx_missed_errors,
-			     s->multicast, s->rx_compressed);
+		stat_table_size_columns("RX:", s, cols, stats_rx);
 		if (show_stats > 1)
-			size_columns(cols, ARRAY_SIZE(cols), 0,
-				     s->rx_length_errors, s->rx_crc_errors,
-				     s->rx_frame_errors, s->rx_fifo_errors,
-				     s->rx_over_errors, s->rx_nohandler);
-		size_columns(cols, ARRAY_SIZE(cols),
-			     s->tx_bytes, s->tx_packets, s->tx_errors,
-			     s->tx_dropped, s->tx_carrier_errors,
-			     s->collisions, s->tx_compressed);
+			stat_table_size_columns("RX errors:", s, cols,
+						stats_rx_err);
+		stat_table_size_columns("TX:", s, cols, stats_tx);
 		if (show_stats > 1)
-			size_columns(cols, ARRAY_SIZE(cols), 0, 0,
-				     s->tx_aborted_errors, s->tx_fifo_errors,
-				     s->tx_window_errors,
-				     s->tx_heartbeat_errors,
-				     carrier_changes ?
-				     rta_getattr_u32(carrier_changes) : 0);
+			stat_table_size_columns("TX errors:", s, cols,
+						stats_tx_err);
 
 		/* RX stats */
-		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
-			cols[0] - 4, "bytes", cols[1], "packets",
-			cols[2], "errors", cols[3], "dropped",
-			cols[4], "missed", cols[5], "mcast",
-			cols[6], s->rx_compressed ? "compressed" : "", _SL_);
-
-		fprintf(fp, "    ");
-		print_num(fp, cols[0], s->rx_bytes);
-		print_num(fp, cols[1], s->rx_packets);
-		print_num(fp, cols[2], s->rx_errors);
-		print_num(fp, cols[3], s->rx_dropped);
-		print_num(fp, cols[4], s->rx_missed_errors);
-		print_num(fp, cols[5], s->multicast);
-		if (s->rx_compressed)
-			print_num(fp, cols[6], s->rx_compressed);
+		stat_table_print_fp(fp, "RX:", s, cols, stats_rx);
 
 		/* RX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
-				cols[0] - 10, "", cols[1], "length",
-				cols[2], "crc", cols[3], "frame",
-				cols[4], "fifo", cols[5], "overrun",
-				cols[6], s->rx_nohandler ? "nohandler" : "",
-				_SL_);
-			fprintf(fp, "%*s", cols[0] + 5, "");
-			print_num(fp, cols[1], s->rx_length_errors);
-			print_num(fp, cols[2], s->rx_crc_errors);
-			print_num(fp, cols[3], s->rx_frame_errors);
-			print_num(fp, cols[4], s->rx_fifo_errors);
-			print_num(fp, cols[5], s->rx_over_errors);
-			if (s->rx_nohandler)
-				print_num(fp, cols[6], s->rx_nohandler);
+			stat_table_print_fp(fp, "RX errors:", s, cols,
+					    stats_rx_err);
 		}
 		fprintf(fp, "%s", _SL_);
 
 		/* TX stats */
-		fprintf(fp, "    TX: %*s %*s %*s %*s %*s %*s %*s%s",
-			cols[0] - 4, "bytes", cols[1], "packets",
-			cols[2], "errors", cols[3], "dropped",
-			cols[4], "carrier", cols[5], "collsns",
-			cols[6], s->tx_compressed ? "compressed" : "", _SL_);
-
-		fprintf(fp, "    ");
-		print_num(fp, cols[0], s->tx_bytes);
-		print_num(fp, cols[1], s->tx_packets);
-		print_num(fp, cols[2], s->tx_errors);
-		print_num(fp, cols[3], s->tx_dropped);
-		print_num(fp, cols[4], s->tx_carrier_errors);
-		print_num(fp, cols[5], s->collisions);
-		if (s->tx_compressed)
-			print_num(fp, cols[6], s->tx_compressed);
+		stat_table_print_fp(fp, "TX:", s, cols, stats_tx);
 
 		/* TX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    TX errors:%*s %*s %*s %*s %*s %*s%s",
-				cols[0] - 10, "", cols[1], "aborted",
-				cols[2], "fifo", cols[3], "window",
-				cols[4], "heartbt",
-				cols[5], carrier_changes ? "transns" : "",
-				_SL_);
-
-			fprintf(fp, "%*s", cols[0] + 5, "");
-			print_num(fp, cols[1], s->tx_aborted_errors);
-			print_num(fp, cols[2], s->tx_fifo_errors);
-			print_num(fp, cols[3], s->tx_window_errors);
-			print_num(fp, cols[4], s->tx_heartbeat_errors);
-			if (carrier_changes)
-				print_num(fp, cols[5],
-					  rta_getattr_u32(carrier_changes));
+			stat_table_print_fp(fp, "TX errors:", s, cols,
+					    stats_tx_err);
 		}
 	}
 }
-- 
2.31.1

