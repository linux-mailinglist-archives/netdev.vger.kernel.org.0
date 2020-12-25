Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8572E2C20
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 20:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgLYTOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 14:14:23 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:32744 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgLYTOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 14:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1608923428;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=bc16E54C006Oue70M/0z3ZVRiE65QzjqvY/UruWqK5E=;
        b=mYvrUIhLxdJEd1vrko2TsHfOjbxHbHo24Jwzr+XZq7fB9i7ni1hG6aVkiLAkUJ+uOD
        EhZmABhq9noobCrcpGFO65hCOeDRkXFGmW57BoCM0NO5YLhsUOf47To4jesM3JsXLmLO
        wh3MlVoe5ZJgwhWp9UrnG7cETmWD6cY4EiJ7YjB0S59hpusfoOoJAfQ2X0oVTHb4r14t
        tN/TDEUMZYgTDKtEy2RxLsNWbLfVg8sfeKGbvI/MubB1oln1ZOGendhEb46v1XdGAbyJ
        1U4mq1rj1a8KNmgiQRo3uW9a3BwH4hxquxgyBl8+4ZSWxIVBequZ9JVkGBGddPhpx3cC
        ytmA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS0lO8DsfULo/u/TWn4+x4="
X-RZG-CLASS-ID: mo00
Received: from silver.lan
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id u00528wBPJAS3it
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 25 Dec 2020 20:10:28 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH iproute2 5.11 2/2] iplink_can: fix format output for details with statistics
Date:   Fri, 25 Dec 2020 20:10:15 +0100
Message-Id: <20201225191015.3584-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201225191015.3584-1-socketcan@hartkopp.net>
References: <20201225191015.3584-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 36e584ad8af6 ("iplink_can: fix format output of clock with
flag -details") from Antonio Borneo a single space has been added to
separate the CAN controller clock value from the numtxqueues value
which is printed in ipaddress.c directly after the CAN info output.

To maintain a common indention every line in the CAN info output now
ends with eight spaces on the next line. While commit 36e584ad8af6
fixed the '-details' option, the '-statistics' option now works too.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 ip/iplink_can.c | 60 +++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6a26f3ff..592b036e 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -272,10 +272,15 @@ static void can_print_json_timing_min_max(const char *attr, int min, int max)
 	print_int(PRINT_JSON, "min", NULL, min);
 	print_int(PRINT_JSON, "max", NULL, max);
 	close_json_object();
 }
 
+/* all our lines end with 8 spaces in the next line to align numtxqueue
+ * output which is just added in ipaddress.c after the CAN info.
+ * The indention of 8 consists of 4 spaces + link_type ("can") + 1 space
+ * as provided by print_linktype() in ipaddress.c  */
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
 		return;
 
@@ -315,10 +320,12 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			  "restart_ms",
 			  "restart-ms %d ",
 			  *restart_ms);
 	}
 
+	fprintf(f, "\n        ");
+
 	/* bittiming is irrelevant if fixed bitrate is defined */
 	if (tb[IFLA_CAN_BITTIMING] && !tb[IFLA_CAN_BITRATE_CONST]) {
 		struct can_bittiming *bt = RTA_DATA(tb[IFLA_CAN_BITTIMING]);
 
 		if (is_json_context()) {
@@ -337,14 +344,14 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_int(PRINT_ANY, "phase_seg2",
 				  NULL, bt->phase_seg2);
 			print_int(PRINT_ANY, "sjw", NULL, bt->sjw);
 			close_json_object();
 		} else {
-			fprintf(f, "\n	  bitrate %d sample-point %.3f ",
+			fprintf(f, "bitrate %d sample-point %.3f\n        ",
 				bt->bitrate, (float) bt->sample_point / 1000.);
-			fprintf(f,
-				"\n	  tq %d prop-seg %d phase-seg1 %d phase-seg2 %d sjw %d",
+			fprintf(f, "tq %d prop-seg %d phase-seg1 %d phase-seg2"
+				"%d sjw %d\n        ",
 				bt->tq, bt->prop_seg,
 				bt->phase_seg1, bt->phase_seg2,
 				bt->sjw);
 		}
 	}
@@ -368,12 +375,12 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 						      btc->brp_min,
 						      btc->brp_max);
 			print_int(PRINT_JSON, "brp_inc", NULL, btc->brp_inc);
 			close_json_object();
 		} else {
-			fprintf(f, "\n	  %s: tseg1 %d..%d tseg2 %d..%d "
-				"sjw 1..%d brp %d..%d brp-inc %d",
+			fprintf(f, "%s: tseg1 %d..%d tseg2 %d..%d "
+				"sjw 1..%d brp %d..%d brp-inc %d\n        ",
 				btc->name, btc->tseg1_min, btc->tseg1_max,
 				btc->tseg2_min, btc->tseg2_max, btc->sjw_max,
 				btc->brp_min, btc->brp_max, btc->brp_inc);
 		}
 	}
@@ -399,24 +406,24 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			for (i = 0; i < bitrate_cnt; ++i)
 				print_uint(PRINT_JSON, NULL, NULL,
 					   bitrate_const[i]);
 			close_json_array(PRINT_JSON, NULL);
 		} else {
-			fprintf(f, "\n	  bitrate %u", bitrate);
-			fprintf(f, "\n	     [");
+			fprintf(f, "bitrate %u\n        ", bitrate);
+			fprintf(f, "[");
 
 			for (i = 0; i < bitrate_cnt - 1; ++i) {
 				/* This will keep lines below 80 signs */
 				if (!(i % 6) && i)
-					fprintf(f, "\n	      ");
+					fprintf(f, "\n        ");
 
 				fprintf(f, "%8u, ", bitrate_const[i]);
 			}
 
 			if (!(i % 6) && i)
-				fprintf(f, "\n	      ");
-			fprintf(f, "%8u ]", bitrate_const[i]);
+				fprintf(f, "\n        ");
+			fprintf(f, "%8u ]\n        ", bitrate_const[i]);
 		}
 	}
 
 	/* data bittiming is irrelevant if fixed bitrate is defined */
 	if (tb[IFLA_CAN_DATA_BITTIMING] && !tb[IFLA_CAN_DATA_BITRATE_CONST]) {
@@ -439,15 +446,15 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			print_int(PRINT_JSON, "phase_seg2",
 				  NULL, dbt->phase_seg2);
 			print_int(PRINT_JSON, "sjw", NULL, dbt->sjw);
 			close_json_object();
 		} else {
-			fprintf(f, "\n	  dbitrate %d dsample-point %.3f ",
+			fprintf(f, "dbitrate %d dsample-point %.3f\n        ",
 				dbt->bitrate,
 				(float) dbt->sample_point / 1000.);
-			fprintf(f, "\n	  dtq %d dprop-seg %d dphase-seg1 %d "
-				"dphase-seg2 %d dsjw %d",
+			fprintf(f, "dtq %d dprop-seg %d dphase-seg1 %d "
+				"dphase-seg2 %d dsjw %d\n        ",
 				dbt->tq, dbt->prop_seg, dbt->phase_seg1,
 				dbt->phase_seg2, dbt->sjw);
 		}
 	}
 
@@ -472,12 +479,12 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 						      dbtc->brp_max);
 
 			print_int(PRINT_JSON, "brp_inc", NULL, dbtc->brp_inc);
 			close_json_object();
 		} else {
-			fprintf(f, "\n	  %s: dtseg1 %d..%d dtseg2 %d..%d "
-				"dsjw 1..%d dbrp %d..%d dbrp-inc %d",
+			fprintf(f, "%s: dtseg1 %d..%d dtseg2 %d..%d "
+				"dsjw 1..%d dbrp %d..%d dbrp-inc %d\n        ",
 				dbtc->name, dbtc->tseg1_min, dbtc->tseg1_max,
 				dbtc->tseg2_min, dbtc->tseg2_max, dbtc->sjw_max,
 				dbtc->brp_min, dbtc->brp_max, dbtc->brp_inc);
 		}
 	}
@@ -504,24 +511,24 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			for (i = 0; i < dbitrate_cnt; ++i)
 				print_uint(PRINT_JSON, NULL, NULL,
 					   dbitrate_const[i]);
 			close_json_array(PRINT_JSON, NULL);
 		} else {
-			fprintf(f, "\n	  dbitrate %u", dbitrate);
-			fprintf(f, "\n	     [");
+			fprintf(f, "dbitrate %u\n        ", dbitrate);
+			fprintf(f, "[");
 
 			for (i = 0; i < dbitrate_cnt - 1; ++i) {
 				/* This will keep lines below 80 signs */
 				if (!(i % 6) && i)
-					fprintf(f, "\n	      ");
+					fprintf(f, "\n        ");
 
 				fprintf(f, "%8u, ", dbitrate_const[i]);
 			}
 
 			if (!(i % 6) && i)
-				fprintf(f, "\n	      ");
-			fprintf(f, "%8u ]", dbitrate_const[i]);
+				fprintf(f, "\n        ");
+			fprintf(f, "%8u ]\n        ", dbitrate_const[i]);
 		}
 	}
 
 	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
 		__u16 *trm = RTA_DATA(tb[IFLA_CAN_TERMINATION]);
@@ -535,28 +542,27 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			open_json_array(PRINT_JSON, "termination_const");
 			for (i = 0; i < trm_cnt; ++i)
 				print_hu(PRINT_JSON, NULL, NULL, trm_const[i]);
 			close_json_array(PRINT_JSON, NULL);
 		} else {
-			fprintf(f, "\n	  termination %hu [ ", *trm);
+			fprintf(f, "termination %hu [ ", *trm);
 
 			for (i = 0; i < trm_cnt - 1; ++i)
 				fprintf(f, "%hu, ", trm_const[i]);
 
-			fprintf(f, "%hu ]", trm_const[i]);
+			fprintf(f, "%hu ]\n        ", trm_const[i]);
 		}
 	}
 
 	if (tb[IFLA_CAN_CLOCK]) {
 		struct can_clock *clock = RTA_DATA(tb[IFLA_CAN_CLOCK]);
 
 		print_int(PRINT_ANY,
 			  "clock",
-			  "\n	  clock %d ",
+			  "clock %d\n        ",
 			  clock->freq);
 	}
-
 }
 
 static void can_print_xstats(struct link_util *lu,
 			     FILE *f, struct rtattr *xstats)
 {
@@ -576,13 +582,13 @@ static void can_print_xstats(struct link_util *lu,
 				  NULL, stats->error_warning);
 			print_int(PRINT_JSON, "error_passive",
 				  NULL, stats->error_passive);
 			print_int(PRINT_JSON, "bus_off", NULL, stats->bus_off);
 		} else {
-			fprintf(f, "\n	  re-started bus-errors arbit-lost "
-				"error-warn error-pass bus-off");
-			fprintf(f, "\n	  %-10d %-10d %-10d %-10d %-10d %-10d",
+			fprintf(f, "re-started bus-errors arbit-lost "
+				"error-warn error-pass bus-off\n        ");
+			fprintf(f, "%-10d %-10d %-10d %-10d %-10d %-10d\n        ",
 				stats->restarts, stats->bus_error,
 				stats->arbitration_lost, stats->error_warning,
 				stats->error_passive, stats->bus_off);
 		}
 	}
-- 
2.29.2

