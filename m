Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6183763B7
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbhEGK3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:29:53 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:29428 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbhEGK3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:29:52 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d48 with ME
        id 1mUT2500A3PnFJp03mUpSB; Fri, 07 May 2021 12:28:51 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 07 May 2021 12:28:51 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v2 1/2] iplink_can: use PRINT_ANY to factorize code and fix signedness
Date:   Fri,  7 May 2021 19:28:18 +0900
Message-Id: <20210507102819.1932386-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210507102819.1932386-1-mailhol.vincent@wanadoo.fr>
References: <20210507102819.1932386-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation heavily relies on some "if (is_json_context())"
switches to decide the context and then does some print_*(PRINT_JSON,
...) when in json context and some fprintf(...) else.

Furthermore, current implementation uses either print_int() or the
conversion specifier %d to print unsigned integers.

This patch factorizes each pairs of print_*(PRINT_JSON, ...) and
fprintf into a signle print_*(PRINT_ANY, ...) call. While doing this
replacement, it uses proper unsigned function print_uint() as well as
the conversion specifier %u when the parameter is an unsigned integer.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 338 ++++++++++++++++++++----------------------------
 1 file changed, 138 insertions(+), 200 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6a26f3ff..1421f0ea 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -266,14 +266,34 @@ static const char *can_state_names[CAN_STATE_MAX] = {
 	[CAN_STATE_SLEEPING] = "SLEEPING"
 };
 
-static void can_print_json_timing_min_max(const char *attr, int min, int max)
+static void can_print_nl_indent(void)
+{
+	print_nl();
+	print_string(PRINT_FP, NULL, "%s", "\t  ");
+}
+
+static void can_print_timing_min_max(const char *attr, int min, int max)
 {
 	open_json_object(attr);
-	print_int(PRINT_JSON, "min", NULL, min);
-	print_int(PRINT_JSON, "max", NULL, max);
+	print_uint(PRINT_ANY, "min", " %u", min);
+	print_uint(PRINT_ANY, "max", "..%u", max);
 	close_json_object();
 }
 
+/* Print nominal bittiming */
+static void can_print_nom_timing_min_max(const char *attr, int min, int max)
+{
+	print_string(PRINT_FP, NULL, " %s", attr);
+	can_print_timing_min_max(attr, min, max);
+}
+
+/* Print data bittiming: use a "d" prefix when printing to the file pointer */
+static void can_print_data_timing_min_max(const char *attr, int min, int max)
+{
+	print_string(PRINT_FP, NULL, " d%s", attr);
+	can_print_timing_min_max(attr, min, max);
+}
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
@@ -297,56 +317,38 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		struct can_berr_counter *bc =
 			RTA_DATA(tb[IFLA_CAN_BERR_COUNTER]);
 
-		if (is_json_context()) {
-			open_json_object("berr_counter");
-			print_int(PRINT_JSON, "tx", NULL, bc->txerr);
-			print_int(PRINT_JSON, "rx", NULL, bc->rxerr);
-			close_json_object();
-		} else {
-			fprintf(f, "(berr-counter tx %d rx %d) ",
-				bc->txerr, bc->rxerr);
-		}
+		open_json_object("berr_counter");
+		print_uint(PRINT_ANY, "tx", "(berr-counter tx %u", bc->txerr);
+		print_uint(PRINT_ANY, "rx", " rx %u) ", bc->rxerr);
+		close_json_object();
 	}
 
 	if (tb[IFLA_CAN_RESTART_MS]) {
 		__u32 *restart_ms = RTA_DATA(tb[IFLA_CAN_RESTART_MS]);
 
-		print_int(PRINT_ANY,
-			  "restart_ms",
-			  "restart-ms %d ",
-			  *restart_ms);
+		print_uint(PRINT_ANY, "restart_ms", "restart-ms %u ",
+			   *restart_ms);
 	}
 
 	/* bittiming is irrelevant if fixed bitrate is defined */
 	if (tb[IFLA_CAN_BITTIMING] && !tb[IFLA_CAN_BITRATE_CONST]) {
 		struct can_bittiming *bt = RTA_DATA(tb[IFLA_CAN_BITTIMING]);
-
-		if (is_json_context()) {
-			json_writer_t *jw;
-
-			open_json_object("bittiming");
-			print_int(PRINT_ANY, "bitrate", NULL, bt->bitrate);
-			jw = get_json_writer();
-			jsonw_name(jw, "sample_point");
-			jsonw_printf(jw, "%.3f",
-				     (float) bt->sample_point / 1000);
-			print_int(PRINT_ANY, "tq", NULL, bt->tq);
-			print_int(PRINT_ANY, "prop_seg", NULL, bt->prop_seg);
-			print_int(PRINT_ANY, "phase_seg1",
-				  NULL, bt->phase_seg1);
-			print_int(PRINT_ANY, "phase_seg2",
-				  NULL, bt->phase_seg2);
-			print_int(PRINT_ANY, "sjw", NULL, bt->sjw);
-			close_json_object();
-		} else {
-			fprintf(f, "\n	  bitrate %d sample-point %.3f ",
-				bt->bitrate, (float) bt->sample_point / 1000.);
-			fprintf(f,
-				"\n	  tq %d prop-seg %d phase-seg1 %d phase-seg2 %d sjw %d",
-				bt->tq, bt->prop_seg,
-				bt->phase_seg1, bt->phase_seg2,
-				bt->sjw);
-		}
+		char sp[6];
+
+		open_json_object("bittiming");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "bitrate", "bitrate %u", bt->bitrate);
+		snprintf(sp, sizeof(sp), "%.3f", bt->sample_point / 1000.);
+		print_string(PRINT_ANY, "sample_point", " sample-point %s", sp);
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "tq", "tq %u", bt->tq);
+		print_uint(PRINT_ANY, "prop_seg", " prop-seg %u", bt->prop_seg);
+		print_uint(PRINT_ANY, "phase_seg1", " phase-seg1 %u",
+			   bt->phase_seg1);
+		print_uint(PRINT_ANY, "phase_seg2", "phase-seg2 %u ",
+			   bt->phase_seg2);
+		print_uint(PRINT_ANY, "sjw", " sjw %u", bt->sjw);
+		close_json_object();
 	}
 
 	/* bittiming const is irrelevant if fixed bitrate is defined */
@@ -354,28 +356,18 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		struct can_bittiming_const *btc =
 			RTA_DATA(tb[IFLA_CAN_BITTIMING_CONST]);
 
-		if (is_json_context()) {
-			open_json_object("bittiming_const");
-			print_string(PRINT_JSON, "name", NULL, btc->name);
-			can_print_json_timing_min_max("tseg1",
-						      btc->tseg1_min,
-						      btc->tseg1_max);
-			can_print_json_timing_min_max("tseg2",
-						      btc->tseg2_min,
-						      btc->tseg2_max);
-			can_print_json_timing_min_max("sjw", 1, btc->sjw_max);
-			can_print_json_timing_min_max("brp",
-						      btc->brp_min,
-						      btc->brp_max);
-			print_int(PRINT_JSON, "brp_inc", NULL, btc->brp_inc);
-			close_json_object();
-		} else {
-			fprintf(f, "\n	  %s: tseg1 %d..%d tseg2 %d..%d "
-				"sjw 1..%d brp %d..%d brp-inc %d",
-				btc->name, btc->tseg1_min, btc->tseg1_max,
-				btc->tseg2_min, btc->tseg2_max, btc->sjw_max,
-				btc->brp_min, btc->brp_max, btc->brp_inc);
-		}
+		open_json_object("bittiming_const");
+		can_print_nl_indent();
+		print_string(PRINT_ANY, "name", "%s:", btc->name);
+		can_print_nom_timing_min_max("tseg1",
+					     btc->tseg1_min, btc->tseg1_max);
+		can_print_nom_timing_min_max("tseg2",
+					     btc->tseg2_min, btc->tseg2_max);
+		can_print_nom_timing_min_max("sjw", 1, btc->sjw_max);
+		can_print_nom_timing_min_max("brp",
+					     btc->brp_min, btc->brp_max);
+		print_uint(PRINT_ANY, "brp_inc", " brp_inc %u", btc->brp_inc);
+		close_json_object();
 	}
 
 	if (tb[IFLA_CAN_BITRATE_CONST]) {
@@ -391,64 +383,46 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			bitrate = bt->bitrate;
 		}
 
-		if (is_json_context()) {
-			print_uint(PRINT_JSON,
-				   "bittiming_bitrate",
-				   NULL, bitrate);
-			open_json_array(PRINT_JSON, "bitrate_const");
-			for (i = 0; i < bitrate_cnt; ++i)
-				print_uint(PRINT_JSON, NULL, NULL,
-					   bitrate_const[i]);
-			close_json_array(PRINT_JSON, NULL);
-		} else {
-			fprintf(f, "\n	  bitrate %u", bitrate);
-			fprintf(f, "\n	     [");
-
-			for (i = 0; i < bitrate_cnt - 1; ++i) {
-				/* This will keep lines below 80 signs */
-				if (!(i % 6) && i)
-					fprintf(f, "\n	      ");
-
-				fprintf(f, "%8u, ", bitrate_const[i]);
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "bittiming_bitrate", "bitrate %u",
+			   bitrate);
+		can_print_nl_indent();
+		open_json_array(PRINT_ANY, is_json_context() ?
+				"bitrate_const" : "   [");
+		for (i = 0; i < bitrate_cnt - 1; ++i) {
+			/* This will keep lines below 80 signs */
+			if (!(i % 6) && i) {
+				can_print_nl_indent();
+				print_string(PRINT_FP, NULL, "%s", "    ");
 			}
-
-			if (!(i % 6) && i)
-				fprintf(f, "\n	      ");
-			fprintf(f, "%8u ]", bitrate_const[i]);
+			print_uint(PRINT_ANY, NULL, "%8u, ", bitrate_const[i]);
 		}
+		print_uint(PRINT_ANY, NULL, "%8u", bitrate_const[i]);
+		close_json_array(PRINT_JSON, " ]");
 	}
 
 	/* data bittiming is irrelevant if fixed bitrate is defined */
 	if (tb[IFLA_CAN_DATA_BITTIMING] && !tb[IFLA_CAN_DATA_BITRATE_CONST]) {
 		struct can_bittiming *dbt =
 			RTA_DATA(tb[IFLA_CAN_DATA_BITTIMING]);
-
-		if (is_json_context()) {
-			json_writer_t *jw;
-
-			open_json_object("data_bittiming");
-			print_int(PRINT_JSON, "bitrate", NULL, dbt->bitrate);
-			jw = get_json_writer();
-			jsonw_name(jw, "sample_point");
-			jsonw_printf(jw, "%.3f",
-				     (float) dbt->sample_point / 1000.);
-			print_int(PRINT_JSON, "tq", NULL, dbt->tq);
-			print_int(PRINT_JSON, "prop_seg", NULL, dbt->prop_seg);
-			print_int(PRINT_JSON, "phase_seg1",
-				  NULL, dbt->phase_seg1);
-			print_int(PRINT_JSON, "phase_seg2",
-				  NULL, dbt->phase_seg2);
-			print_int(PRINT_JSON, "sjw", NULL, dbt->sjw);
-			close_json_object();
-		} else {
-			fprintf(f, "\n	  dbitrate %d dsample-point %.3f ",
-				dbt->bitrate,
-				(float) dbt->sample_point / 1000.);
-			fprintf(f, "\n	  dtq %d dprop-seg %d dphase-seg1 %d "
-				"dphase-seg2 %d dsjw %d",
-				dbt->tq, dbt->prop_seg, dbt->phase_seg1,
-				dbt->phase_seg2, dbt->sjw);
-		}
+		char dsp[6];
+
+		open_json_object("data_bittiming");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "bitrate", "dbitrate %u", dbt->bitrate);
+		snprintf(dsp, sizeof(dsp), "%.3f", dbt->sample_point / 1000.);
+		print_string(PRINT_ANY, "sample_point", " dsample-point %s",
+			     dsp);
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "tq", "dtq %u", dbt->tq);
+		print_uint(PRINT_ANY, "prop_seg", " dprop-seg %u",
+			   dbt->prop_seg);
+		print_uint(PRINT_ANY, "phase_seg1", " dphase-seg1 %u",
+			   dbt->phase_seg1);
+		print_uint(PRINT_ANY, "phase_seg2", " dphase-seg2 %u",
+			   dbt->phase_seg2);
+		print_uint(PRINT_ANY, "sjw", " dsjw %u", dbt->sjw);
+		close_json_object();
 	}
 
 	/* data bittiming const is irrelevant if fixed bitrate is defined */
@@ -457,29 +431,18 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		struct can_bittiming_const *dbtc =
 			RTA_DATA(tb[IFLA_CAN_DATA_BITTIMING_CONST]);
 
-		if (is_json_context()) {
-			open_json_object("data_bittiming_const");
-			print_string(PRINT_JSON, "name", NULL, dbtc->name);
-			can_print_json_timing_min_max("tseg1",
-						      dbtc->tseg1_min,
-						      dbtc->tseg1_max);
-			can_print_json_timing_min_max("tseg2",
-						      dbtc->tseg2_min,
-						      dbtc->tseg2_max);
-			can_print_json_timing_min_max("sjw", 1, dbtc->sjw_max);
-			can_print_json_timing_min_max("brp",
-						      dbtc->brp_min,
-						      dbtc->brp_max);
-
-			print_int(PRINT_JSON, "brp_inc", NULL, dbtc->brp_inc);
-			close_json_object();
-		} else {
-			fprintf(f, "\n	  %s: dtseg1 %d..%d dtseg2 %d..%d "
-				"dsjw 1..%d dbrp %d..%d dbrp-inc %d",
-				dbtc->name, dbtc->tseg1_min, dbtc->tseg1_max,
-				dbtc->tseg2_min, dbtc->tseg2_max, dbtc->sjw_max,
-				dbtc->brp_min, dbtc->brp_max, dbtc->brp_inc);
-		}
+		open_json_object("data_bittiming_const");
+		can_print_nl_indent();
+		print_string(PRINT_ANY, "name", "%s:", dbtc->name);
+		can_print_data_timing_min_max("tseg1",
+					      dbtc->tseg1_min, dbtc->tseg1_max);
+		can_print_data_timing_min_max("tseg2",
+					      dbtc->tseg2_min, dbtc->tseg2_max);
+		can_print_data_timing_min_max("sjw", 1, dbtc->sjw_max);
+		can_print_data_timing_min_max("brp",
+					      dbtc->brp_min, dbtc->brp_max);
+		print_uint(PRINT_ANY, "brp_inc", " brp_inc %u", dbtc->brp_inc);
+		close_json_object();
 	}
 
 	if (tb[IFLA_CAN_DATA_BITRATE_CONST]) {
@@ -497,30 +460,22 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			dbitrate = dbt->bitrate;
 		}
 
-		if (is_json_context()) {
-			print_uint(PRINT_JSON, "data_bittiming_bitrate",
-				   NULL, dbitrate);
-			open_json_array(PRINT_JSON, "data_bitrate_const");
-			for (i = 0; i < dbitrate_cnt; ++i)
-				print_uint(PRINT_JSON, NULL, NULL,
-					   dbitrate_const[i]);
-			close_json_array(PRINT_JSON, NULL);
-		} else {
-			fprintf(f, "\n	  dbitrate %u", dbitrate);
-			fprintf(f, "\n	     [");
-
-			for (i = 0; i < dbitrate_cnt - 1; ++i) {
-				/* This will keep lines below 80 signs */
-				if (!(i % 6) && i)
-					fprintf(f, "\n	      ");
-
-				fprintf(f, "%8u, ", dbitrate_const[i]);
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "data_bittiming_bitrate", "dbitrate %u",
+			   dbitrate);
+		can_print_nl_indent();
+		open_json_array(PRINT_ANY, is_json_context() ?
+				"data_bitrate_const" : "   [");
+		for (i = 0; i < dbitrate_cnt - 1; ++i) {
+			/* This will keep lines below 80 signs */
+			if (!(i % 6) && i) {
+				can_print_nl_indent();
+				print_string(PRINT_FP, NULL, "%s", "    ");
 			}
-
-			if (!(i % 6) && i)
-				fprintf(f, "\n	      ");
-			fprintf(f, "%8u ]", dbitrate_const[i]);
+			print_uint(PRINT_ANY, NULL, "%8u, ", dbitrate_const[i]);
 		}
+		print_uint(PRINT_ANY, NULL, "%8u", dbitrate_const[i]);
+		close_json_array(PRINT_JSON, " ]");
 	}
 
 	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
@@ -530,29 +485,20 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			sizeof(*trm_const);
 		int i;
 
-		if (is_json_context()) {
-			print_hu(PRINT_JSON, "termination", NULL, *trm);
-			open_json_array(PRINT_JSON, "termination_const");
-			for (i = 0; i < trm_cnt; ++i)
-				print_hu(PRINT_JSON, NULL, NULL, trm_const[i]);
-			close_json_array(PRINT_JSON, NULL);
-		} else {
-			fprintf(f, "\n	  termination %hu [ ", *trm);
-
-			for (i = 0; i < trm_cnt - 1; ++i)
-				fprintf(f, "%hu, ", trm_const[i]);
-
-			fprintf(f, "%hu ]", trm_const[i]);
-		}
+		can_print_nl_indent();
+		print_hu(PRINT_ANY, "termination", "termination %hu [ ", *trm);
+		open_json_array(PRINT_JSON, "termination_const");
+		for (i = 0; i < trm_cnt - 1; ++i)
+			print_hu(PRINT_ANY, NULL, "%hu, ", trm_const[i]);
+		print_hu(PRINT_ANY, NULL, "%hu", trm_const[i]);
+		close_json_array(PRINT_JSON, " ]");
 	}
 
 	if (tb[IFLA_CAN_CLOCK]) {
 		struct can_clock *clock = RTA_DATA(tb[IFLA_CAN_CLOCK]);
 
-		print_int(PRINT_ANY,
-			  "clock",
-			  "\n	  clock %d ",
-			  clock->freq);
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "clock", "clock %u ", clock->freq);
 	}
 
 }
@@ -565,31 +511,23 @@ static void can_print_xstats(struct link_util *lu,
 	if (xstats && RTA_PAYLOAD(xstats) == sizeof(*stats)) {
 		stats = RTA_DATA(xstats);
 
-		if (is_json_context()) {
-			print_int(PRINT_JSON, "restarts",
-				  NULL, stats->restarts);
-			print_int(PRINT_JSON, "bus_error",
-				  NULL, stats->bus_error);
-			print_int(PRINT_JSON, "arbitration_lost",
-				  NULL, stats->arbitration_lost);
-			print_int(PRINT_JSON, "error_warning",
-				  NULL, stats->error_warning);
-			print_int(PRINT_JSON, "error_passive",
-				  NULL, stats->error_passive);
-			print_int(PRINT_JSON, "bus_off", NULL, stats->bus_off);
-		} else {
-			fprintf(f, "\n	  re-started bus-errors arbit-lost "
-				"error-warn error-pass bus-off");
-			fprintf(f, "\n	  %-10d %-10d %-10d %-10d %-10d %-10d",
-				stats->restarts, stats->bus_error,
-				stats->arbitration_lost, stats->error_warning,
-				stats->error_passive, stats->bus_off);
-		}
+		can_print_nl_indent();
+		print_string(PRINT_FP, NULL, "%s",
+			     "re-started bus-errors arbit-lost error-warn error-pass bus-off");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "restarts", "%-10u", stats->restarts);
+		print_uint(PRINT_ANY, "bus_error", " %-10u", stats->bus_error);
+		print_uint(PRINT_ANY, "arbitration_lost", " %-10u",
+			   stats->arbitration_lost);
+		print_uint(PRINT_ANY, "error_warning", " %-10u",
+			   stats->error_warning);
+		print_uint(PRINT_ANY, "error_passive", " %-10u",
+			   stats->error_passive);
+		print_uint(PRINT_ANY, "bus_off", " %-10u", stats->bus_off);
 	}
 }
 
-static void can_print_help(struct link_util *lu, int argc, char **argv,
-			   FILE *f)
+static void can_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
 	print_usage(f);
 }
-- 
2.26.3

