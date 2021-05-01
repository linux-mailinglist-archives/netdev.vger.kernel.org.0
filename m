Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A848370515
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 05:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhEADLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 23:11:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230298AbhEADLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 23:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8925B613FA;
        Sat,  1 May 2021 03:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619838660;
        bh=d3nOrjeJ3SilP2+Sg05M2vIvCGmHnlFGucTZF0fQPmE=;
        h=From:To:Cc:Subject:Date:From;
        b=QskVPv+RjSqTHMIunuKpEkG42U60S2KMskCkxh0G3QyNoBA9ZaDeGOSvjb6jPPT60
         yTdF6fc51vWVdSprroVpaWSujtXFz/upsYkcgFtnYj5Q5wWrAGh0BbgPcQb9T14u2n
         MSdJE5WCCC7i16Oa5zXpBjPwwxOoX7baQBY5t41uzoqanS8TiRlDnPv+RAtSWX3IQE
         Dhb5iPQBCJGDKjT+IFQO67IxcGGeRHOHtluLE3yFi8wyFpKeW1qVZ9l08jdKQX8C7n
         icKH2mOVwGQGSS4qSy11OirZ5EgqudURWeodkrAK5cMcO6GIuZk2T7C04VtPi0m5TJ
         zH01mp/mpb9sw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH iproute2-next] ip: dynamically size columns when printing stats
Date:   Fri, 30 Apr 2021 20:10:59 -0700
Message-Id: <20210501031059.529906-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change makes ip -s -s output size the columns
automatically. I often find myself using json
output because the normal output is unreadable.
Even on a laptop after 2 days of uptime byte
and packet counters almost overflow their columns,
let alone a busy server.

For max readability switch to right align.

Before:

    RX: bytes  packets  errors  dropped missed  mcast
    8227918473 8617683  0       0       0       0
    RX errors: length   crc     frame   fifo    overrun
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    691937917  4727223  0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       10

After:

    RX:  bytes packets errors dropped  missed   mcast
    8228633710 8618408      0       0       0       0
    RX errors:  length    crc   frame    fifo overrun
                     0      0       0       0       0
    TX:  bytes packets errors dropped carrier collsns
     692006303 4727740      0       0       0       0
    TX errors: aborted   fifo  window heartbt transns
                     0      0       0       0      10

More importantly, with large values before:

    RX: bytes  packets  errors  dropped overrun mcast
    126570234447969 15016149200 0       0       0       0
    RX errors: length   crc     frame   fifo    missed
               0        0       0       0       0
    TX: bytes  packets  errors  dropped carrier collsns
    126570234447969 15016149200 0       0       0       0
    TX errors: aborted  fifo   window heartbeat transns
               0        0       0       0       10

Note that in this case we have full shift by a column,
e.g. the value under "dropped" is actually for "errors" etc.

After:

    RX:       bytes     packets errors dropped  missed   mcast
    126570234447969 15016149200      0       0       0       0
    RX errors:           length    crc   frame    fifo overrun
                              0      0       0       0       0
    TX:       bytes     packets errors dropped carrier collsns
    126570234447969 15016149200      0       0       0       0
    TX errors:          aborted   fifo  window heartbt transns
                              0      0       0       0      10

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Note - this patch does depend on the trivial nohandler print fix.

 ip/ipaddress.c | 146 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 106 insertions(+), 40 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 8783b70d81e2..06ca7273c531 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <stdarg.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -544,6 +545,29 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
 		print_vf_stats64(fp, vf[IFLA_VF_STATS]);
 }
 
+static void size_columns(unsigned int cols[], unsigned int n, ...)
+{
+	unsigned int i, len;
+	uint64_t val, powi;
+	va_list args;
+
+	va_start(args, n);
+
+	for (i = 0; i < n; i++) {
+		val = va_arg(args, unsigned long long);
+
+		if (human_readable)
+			continue;
+
+		for (len = 1, powi = 10; powi < val; len++, powi *= 10)
+			/* nothing */;
+		if (len > cols[i])
+			cols[i] = len;
+	}
+
+	va_end(args);
+}
+
 void print_num(FILE *fp, unsigned int width, uint64_t count)
 {
 	const char *prefix = "kMGTPE";
@@ -554,7 +578,7 @@ void print_num(FILE *fp, unsigned int width, uint64_t count)
 	char buf[64];
 
 	if (!human_readable || count < base) {
-		fprintf(fp, "%-*"PRIu64" ", width, count);
+		fprintf(fp, "%*"PRIu64" ", width, count);
 		return;
 	}
 
@@ -581,7 +605,7 @@ void print_num(FILE *fp, unsigned int width, uint64_t count)
 	snprintf(buf, sizeof(buf), "%.*f%c%s", precision,
 		 (double) count / powi, *prefix, use_iec ? "i" : "");
 
-	fprintf(fp, "%-*s ", width, buf);
+	fprintf(fp, "%*s ", width, buf);
 }
 
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats)
@@ -659,6 +683,15 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 {
 	const struct rtattr *carrier_changes = tb[IFLA_CARRIER_CHANGES];
 	struct rtnl_link_stats64 _s, *s = &_s;
+	unsigned int cols[] = {
+		strlen("*X errors:"),
+		strlen("packets"),
+		strlen("errors"),
+		strlen("dropped"),
+		strlen("heartbt"),
+		strlen("overrun"),
+		strlen("compressed"),
+	};
 	int ret;
 
 	ret = get_rtnl_link_stats_rta(s, tb);
@@ -739,65 +772,98 @@ static void __print_link_stats(FILE *fp, struct rtattr *tb[])
 		close_json_object();
 		close_json_object();
 	} else {
+		size_columns(cols, ARRAY_SIZE(cols),
+			     s->rx_bytes, s->rx_packets, s->rx_errors,
+			     s->rx_dropped, s->rx_missed_errors,
+			     s->multicast, s->rx_compressed);
+		if (show_stats > 1)
+			size_columns(cols, ARRAY_SIZE(cols), 0,
+				     s->rx_length_errors, s->rx_crc_errors,
+				     s->rx_frame_errors, s->rx_fifo_errors,
+				     s->rx_over_errors, s->rx_nohandler);
+		size_columns(cols, ARRAY_SIZE(cols),
+			     s->tx_bytes, s->tx_packets, s->tx_errors,
+			     s->tx_dropped, s->tx_carrier_errors,
+			     s->collisions, s->tx_compressed);
+		if (show_stats > 1)
+			size_columns(cols, ARRAY_SIZE(cols), 0, 0,
+				     s->tx_aborted_errors, s->tx_fifo_errors,
+				     s->tx_window_errors,
+				     s->tx_heartbeat_errors,
+				     carrier_changes ?
+				     rta_getattr_u32(carrier_changes) : 0);
+
 		/* RX stats */
-		fprintf(fp, "    RX: bytes  packets  errors  dropped missed  mcast   %s%s",
-			s->rx_compressed ? "compressed" : "", _SL_);
+		fprintf(fp, "    RX: %*s %*s %*s %*s %*s %*s %*s%s",
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped",
+			cols[4], "missed", cols[5], "mcast",
+			cols[6], s->rx_compressed ? "compressed" : "", _SL_);
 
 		fprintf(fp, "    ");
-		print_num(fp, 10, s->rx_bytes);
-		print_num(fp, 8, s->rx_packets);
-		print_num(fp, 7, s->rx_errors);
-		print_num(fp, 7, s->rx_dropped);
-		print_num(fp, 7, s->rx_missed_errors);
-		print_num(fp, 7, s->multicast);
+		print_num(fp, cols[0], s->rx_bytes);
+		print_num(fp, cols[1], s->rx_packets);
+		print_num(fp, cols[2], s->rx_errors);
+		print_num(fp, cols[3], s->rx_dropped);
+		print_num(fp, cols[4], s->rx_missed_errors);
+		print_num(fp, cols[5], s->multicast);
 		if (s->rx_compressed)
-			print_num(fp, 7, s->rx_compressed);
+			print_num(fp, cols[6], s->rx_compressed);
 
 		/* RX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    RX errors: length   crc     frame   fifo    overrun%s%s",
-				s->rx_nohandler ? " nohandler" : "", _SL_);
-			fprintf(fp, "               ");
-			print_num(fp, 8, s->rx_length_errors);
-			print_num(fp, 7, s->rx_crc_errors);
-			print_num(fp, 7, s->rx_frame_errors);
-			print_num(fp, 7, s->rx_fifo_errors);
-			print_num(fp, 7, s->rx_over_errors);
+			fprintf(fp, "    RX errors:%*s %*s %*s %*s %*s %*s %*s%s",
+				cols[0] - 10, "", cols[1], "length",
+				cols[2], "crc", cols[3], "frame",
+				cols[4], "fifo", cols[5], "overrun",
+				cols[6], s->rx_nohandler ? "nohandler" : "",
+				_SL_);
+			fprintf(fp, "%*s", cols[0] + 5, "");
+			print_num(fp, cols[1], s->rx_length_errors);
+			print_num(fp, cols[2], s->rx_crc_errors);
+			print_num(fp, cols[3], s->rx_frame_errors);
+			print_num(fp, cols[4], s->rx_fifo_errors);
+			print_num(fp, cols[5], s->rx_over_errors);
 			if (s->rx_nohandler)
-				print_num(fp, 7, s->rx_nohandler);
+				print_num(fp, cols[6], s->rx_nohandler);
 		}
 		fprintf(fp, "%s", _SL_);
 
 		/* TX stats */
-		fprintf(fp, "    TX: bytes  packets  errors  dropped carrier collsns %s%s",
-			s->tx_compressed ? "compressed" : "", _SL_);
+		fprintf(fp, "    TX: %*s %*s %*s %*s %*s %*s %*s%s",
+			cols[0] - 4, "bytes", cols[1], "packets",
+			cols[2], "errors", cols[3], "dropped",
+			cols[4], "carrier", cols[5], "collsns",
+			cols[6], s->tx_compressed ? "compressed" : "", _SL_);
 
 		fprintf(fp, "    ");
-		print_num(fp, 10, s->tx_bytes);
-		print_num(fp, 8, s->tx_packets);
-		print_num(fp, 7, s->tx_errors);
-		print_num(fp, 7, s->tx_dropped);
-		print_num(fp, 7, s->tx_carrier_errors);
-		print_num(fp, 7, s->collisions);
+		print_num(fp, cols[0], s->tx_bytes);
+		print_num(fp, cols[1], s->tx_packets);
+		print_num(fp, cols[2], s->tx_errors);
+		print_num(fp, cols[3], s->tx_dropped);
+		print_num(fp, cols[4], s->tx_carrier_errors);
+		print_num(fp, cols[5], s->collisions);
 		if (s->tx_compressed)
-			print_num(fp, 7, s->tx_compressed);
+			print_num(fp, cols[6], s->tx_compressed);
 
 		/* TX error stats */
 		if (show_stats > 1) {
 			fprintf(fp, "%s", _SL_);
-			fprintf(fp, "    TX errors: aborted  fifo   window heartbeat");
-			if (carrier_changes)
-				fprintf(fp, " transns");
-			fprintf(fp, "%s", _SL_);
-
-			fprintf(fp, "               ");
-			print_num(fp, 8, s->tx_aborted_errors);
-			print_num(fp, 7, s->tx_fifo_errors);
-			print_num(fp, 7, s->tx_window_errors);
-			print_num(fp, 7, s->tx_heartbeat_errors);
+			fprintf(fp, "    TX errors:%*s %*s %*s %*s %*s %*s%s",
+				cols[0] - 10, "", cols[1], "aborted",
+				cols[2], "fifo", cols[3], "window",
+				cols[4], "heartbt",
+				cols[5], carrier_changes ? "transns" : "",
+				_SL_);
+
+			fprintf(fp, "%*s", cols[0] + 5, "");
+			print_num(fp, cols[1], s->tx_aborted_errors);
+			print_num(fp, cols[2], s->tx_fifo_errors);
+			print_num(fp, cols[3], s->tx_window_errors);
+			print_num(fp, cols[4], s->tx_heartbeat_errors);
 			if (carrier_changes)
-				print_num(fp, 7,
+				print_num(fp, cols[5],
 					  rta_getattr_u32(carrier_changes));
 		}
 	}
-- 
2.31.1

