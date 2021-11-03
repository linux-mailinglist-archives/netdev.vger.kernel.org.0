Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A39444635
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhKCQsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:48:07 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:54331 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbhKCQsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:48:06 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id iJNLmc3ywk3HQiJOAmsN4t; Wed, 03 Nov 2021 17:45:29 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Wed, 03 Nov 2021 17:45:29 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2-next 5.16 v6 5/5] iplink_can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
Date:   Thu,  4 Nov 2021 01:44:28 +0900
Message-Id: <20211103164428.692722-6-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At high bit rates, the propagation delay from the TX pin to the RX pin
of the transceiver causes measurement errors: the sample point on the
RX pin might occur on the previous bit.

This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
delay compensation" (TDC).

This patch brings command line support to nine TDC parameters which
were recently added to the kernel's CAN netlink interface in order to
implement TDC:
  - IFLA_CAN_TDC_TDCV_MIN: Transmitter Delay Compensation Value
    minimum value
  - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
    maximum value
  - IFLA_CAN_TDC_TDCO_MIN: Transmitter Delay Compensation Offset
    minimum value
  - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
    maximum value
  - IFLA_CAN_TDC_TDCF_MIN: Transmitter Delay Compensation Filter
    window minimum value
  - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
    window maximum value
  - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
  - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
  - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window

All those new parameters are nested together into the attribute
IFLA_CAN_TDC.

The TDC parameters extend the FD parameters. As such, the TDC
parameters must be specified together the "fd on" flag.

When "fd on" flag is provided, a tdc-mode parameter allows to specify
how to operate.  Valid options for tdc-mode are:

  * auto: the transmitter dynamically measures TDCV for each of the
    transmitted frames. As such, TDCV can not be manually provided. In
    this mode, the user must specify TDCO and may also specify TDCF if
    supported.

  * manual: use a static TDCV provided by the user. In this mode, the
    user must specify both TDCV and TDCO and may also specify TDCF if
    supported.

  * off: TDC is explicitly disabled.

  * tdc-mode parameter omitted (default mode): the kernel decides
    whether TDC should be enabled or not and if so, it calculates the
    TDC values. TDC parameters are an expert option and the average
    user is not expected to provide those, thus the presence of this
    "default mode".

If the fd flag is omitted, all the FD values (including TDC values)
remain unchanged.

If "fd off" flag is specified, all FD values (including TDC values)
are zeroed.

TDCV is always reported in manual mode. In auto mode, TDCV is reported
only if the value is available. Especially, the TDCV might not be
available if the controller has no feature to report it or if the
value in not yet available (i.e. no data sent yet and measurement did
not occur).

TDCF is reported only if tdcf_max is not zero (i.e. if supported by
the controller).

For reference, here are a few samples of how the output looks like:

| $ ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on tdco 7 tdcf 8 tdc-mode auto

| $ ip --details link show can0
| 1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <FD,TDC-AUTO> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
| 	  bitrate 1000000 sample-point 0.750
| 	  tq 12 prop-seg 29 phase-seg1 30 phase-seg2 20 sjw 1 brp 1
| 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
| 	  dbitrate 8000000 dsample-point 0.700
| 	  dtq 12 dprop-seg 3 dphase-seg1 3 dphase-seg2 3 dsjw 1 dbrp 1
| 	  tdco 7 tdcf 8
| 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_inc 1
| 	  tdco 0..127 tdcf 0..127
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

| $ ip --details --json --pretty link show can0
| [ {
|         "ifindex": 1,
|         "ifname": "can0",
|         "flags": [ "NOARP","ECHO" ],
|         "mtu": 72,
|         "qdisc": "noop",
|         "operstate": "DOWN",
|         "linkmode": "DEFAULT",
|         "group": "default",
|         "txqlen": 10,
|         "link_type": "can",
|         "promiscuity": 0,
|         "min_mtu": 0,
|         "max_mtu": 0,
|         "linkinfo": {
|             "info_kind": "can",
|             "info_data": {
|                 "ctrlmode": [ "FD","TDC-AUTO" ],
|                 "state": "STOPPED",
|                 "berr_counter": {
|                     "tx": 0,
|                     "rx": 0
|                 },
|                 "restart_ms": 0,
|                 "bittiming": {
|                     "bitrate": 1000000,
|                     "sample_point": "0.750",
|                     "tq": 12,
|                     "prop_seg": 29,
|                     "phase_seg1": 30,
|                     "phase_seg2": 20,
|                     "sjw": 1,
|                     "brp": 1
|                 },
|                 "bittiming_const": {
|                     "name": "ES582.1/ES584.1",
|                     "tseg1": {
|                         "min": 2,
|                         "max": 256
|                     },
|                     "tseg2": {
|                         "min": 2,
|                         "max": 128
|                     },
|                     "sjw": {
|                         "min": 1,
|                         "max": 128
|                     },
|                     "brp": {
|                         "min": 1,
|                         "max": 512
|                     },
|                     "brp_inc": 1
|                 },
|                 "data_bittiming": {
|                     "bitrate": 8000000,
|                     "sample_point": "0.700",
|                     "tq": 12,
|                     "prop_seg": 3,
|                     "phase_seg1": 3,
|                     "phase_seg2": 3,
|                     "sjw": 1,
|                     "brp": 1,
|                     "tdc": {
|                         "tdco": 7,
|                         "tdcf": 8
|                     }
|                 },
|                 "data_bittiming_const": {
|                     "name": "ES582.1/ES584.1",
|                     "tseg1": {
|                         "min": 2,
|                         "max": 32
|                     },
|                     "tseg2": {
|                         "min": 1,
|                         "max": 16
|                     },
|                     "sjw": {
|                         "min": 1,
|                         "max": 8
|                     },
|                     "brp": {
|                         "min": 1,
|                         "max": 32
|                     },
|                     "brp_inc": 1,
|                     "tdc": {
|                         "tdco": {
|                             "min": 0,
|                             "max": 127
|                         },
|                         "tdcf": {
|                             "min": 0,
|                             "max": 127
|                         }
|                     }
|                 },
|                 "clock": 80000000
|             }
|         },
|         "num_tx_queues": 1,
|         "num_rx_queues": 1,
|         "gso_max_size": 65536,
|         "gso_max_segs": 65535
|     } ]

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index cf6b06b8..f4b37528 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -28,6 +28,7 @@ static void print_usage(FILE *f)
 		"\n"
 		"\t[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |\n"
 		"\t[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1\n \t  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]\n"
+		"\t[ tdcv TDCV tdco TDCO tdcf TDCF ]\n"
 		"\n"
 		"\t[ loopback { on | off } ]\n"
 		"\t[ listen-only { on | off } ]\n"
@@ -38,6 +39,7 @@ static void print_usage(FILE *f)
 		"\t[ fd-non-iso { on | off } ]\n"
 		"\t[ presume-ack { on | off } ]\n"
 		"\t[ cc-len8-dlc { on | off } ]\n"
+		"\t[ tdc-mode { auto | manual | off } ]\n"
 		"\n"
 		"\t[ restart-ms TIME-MS ]\n"
 		"\t[ restart ]\n"
@@ -51,6 +53,9 @@ static void print_usage(FILE *f)
 		"\t	  PHASE-SEG1	:= { NUMBER in tq }\n"
 		"\t	  PHASE-SEG2	:= { NUMBER in tq }\n"
 		"\t	  SJW		:= { NUMBER in tq }\n"
+		"\t	  TDCV		:= { NUMBER in tc}\n"
+		"\t	  TDCO		:= { NUMBER in tc}\n"
+		"\t	  TDCF		:= { NUMBER in tc}\n"
 		"\t	  RESTART-MS	:= { 0 | NUMBER in ms }\n"
 		);
 }
@@ -113,6 +118,8 @@ static void print_ctrlmode(enum output_type t, __u32 flags, const char* key)
 	print_flag(t, &flags, CAN_CTRLMODE_FD_NON_ISO, "FD-NON-ISO");
 	print_flag(t, &flags, CAN_CTRLMODE_PRESUME_ACK, "PRESUME-ACK");
 	print_flag(t, &flags, CAN_CTRLMODE_CC_LEN8_DLC, "CC-LEN8-DLC");
+	print_flag(t, &flags, CAN_CTRLMODE_TDC_AUTO, "TDC-AUTO");
+	print_flag(t, &flags, CAN_CTRLMODE_TDC_MANUAL, "TDC-MANUAL");
 
 	if (flags)
 		print_hex(t, NULL, "%x", flags);
@@ -125,6 +132,8 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	struct can_bittiming bt = {}, dbt = {};
 	struct can_ctrlmode cm = { 0 };
+	struct rtattr *tdc;
+	__u32 tdcv = -1, tdco = -1, tdcf = -1;
 
 	while (argc > 0) {
 		if (matches(*argv, "bitrate") == 0) {
@@ -190,6 +199,18 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			if (get_u32(&dbt.sjw, *argv, 0))
 				invarg("invalid \"dsjw\" value\n", *argv);
+		} else if (matches(*argv, "tdcv") == 0) {
+			NEXT_ARG();
+			if (get_u32(&tdcv, *argv, 0))
+				invarg("invalid \"tdcv\" value\n", *argv);
+		} else if (matches(*argv, "tdco") == 0) {
+			NEXT_ARG();
+			if (get_u32(&tdco, *argv, 0))
+				invarg("invalid \"tdco\" value\n", *argv);
+		} else if (matches(*argv, "tdcf") == 0) {
+			NEXT_ARG();
+			if (get_u32(&tdcf, *argv, 0))
+				invarg("invalid \"tdcf\" value\n", *argv);
 		} else if (matches(*argv, "loopback") == 0) {
 			NEXT_ARG();
 			set_ctrlmode("loopback", *argv, &cm,
@@ -226,6 +247,23 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			set_ctrlmode("cc-len8-dlc", *argv, &cm,
 				     CAN_CTRLMODE_CC_LEN8_DLC);
+		} else if (matches(*argv, "tdc-mode") == 0) {
+			NEXT_ARG();
+			if (strcmp(*argv, "auto") == 0) {
+				cm.flags |= CAN_CTRLMODE_TDC_AUTO;
+				cm.mask |= CAN_CTRLMODE_TDC_AUTO;
+			} else if (strcmp(*argv, "manual") == 0) {
+				cm.flags |= CAN_CTRLMODE_TDC_MANUAL;
+				cm.mask |= CAN_CTRLMODE_TDC_MANUAL;
+			} else if (strcmp(*argv, "off") == 0) {
+				cm.mask |= CAN_CTRLMODE_TDC_AUTO |
+					   CAN_CTRLMODE_TDC_MANUAL;
+			} else {
+				fprintf(stderr,
+					"Error: argument of \"tdc-mode\" must be \"auto\", \"manual\" or \"off\", not \"%s\"\n",
+					*argv);
+				exit (-1);
+			}
 		} else if (matches(*argv, "restart") == 0) {
 			__u32 val = 1;
 
@@ -263,6 +301,17 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 	if (cm.mask)
 		addattr_l(n, 1024, IFLA_CAN_CTRLMODE, &cm, sizeof(cm));
 
+	if (tdcv != -1 || tdco != -1 || tdcf != -1) {
+		tdc = addattr_nest(n, 1024, IFLA_CAN_TDC | NLA_F_NESTED);
+		if (tdcv != -1)
+			addattr32(n, 1024, IFLA_CAN_TDC_TDCV, tdcv);
+		if (tdco != -1)
+			addattr32(n, 1024, IFLA_CAN_TDC_TDCO, tdco);
+		if (tdcf != -1)
+			addattr32(n, 1024, IFLA_CAN_TDC_TDCF, tdcf);
+		addattr_nest_end(n, tdc);
+	}
+
 	return 0;
 }
 
@@ -291,6 +340,62 @@ static void can_print_timing_min_max(const char *json_attr, const char *fp_attr,
 	close_json_object();
 }
 
+static void can_print_tdc_opt(FILE *f, struct rtattr *tdc_attr)
+{
+	struct rtattr *tb[IFLA_CAN_TDC_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_CAN_TDC_MAX, tdc_attr);
+	if (tb[IFLA_CAN_TDC_TDCV] || tb[IFLA_CAN_TDC_TDCO] ||
+	    tb[IFLA_CAN_TDC_TDCF]) {
+		open_json_object("tdc");
+		can_print_nl_indent();
+		if (tb[IFLA_CAN_TDC_TDCV]) {
+			__u32 *tdcv = RTA_DATA(tb[IFLA_CAN_TDC_TDCV]);
+
+			print_uint(PRINT_ANY, "tdcv", " tdcv %u", *tdcv);
+		}
+		if (tb[IFLA_CAN_TDC_TDCO]) {
+			__u32 *tdco = RTA_DATA(tb[IFLA_CAN_TDC_TDCO]);
+
+			print_uint(PRINT_ANY, "tdco", " tdco %u", *tdco);
+		}
+		if (tb[IFLA_CAN_TDC_TDCF]) {
+			__u32 *tdcf = RTA_DATA(tb[IFLA_CAN_TDC_TDCF]);
+
+			print_uint(PRINT_ANY, "tdcf", " tdcf %u", *tdcf);
+		}
+		close_json_object();
+	}
+}
+
+static void can_print_tdc_const_opt(FILE *f, struct rtattr *tdc_attr)
+{
+	struct rtattr *tb[IFLA_CAN_TDC_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_CAN_TDC_MAX, tdc_attr);
+	open_json_object("tdc");
+	can_print_nl_indent();
+	if (tb[IFLA_CAN_TDC_TDCV_MIN] && tb[IFLA_CAN_TDC_TDCV_MAX]) {
+		__u32 *tdcv_min = RTA_DATA(tb[IFLA_CAN_TDC_TDCV_MIN]);
+		__u32 *tdcv_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCV_MAX]);
+
+		can_print_timing_min_max("tdcv", " tdcv", *tdcv_min, *tdcv_max);
+	}
+	if (tb[IFLA_CAN_TDC_TDCO_MIN] && tb[IFLA_CAN_TDC_TDCO_MAX]) {
+		__u32 *tdco_min = RTA_DATA(tb[IFLA_CAN_TDC_TDCO_MIN]);
+		__u32 *tdco_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCO_MAX]);
+
+		can_print_timing_min_max("tdco", " tdco", *tdco_min, *tdco_max);
+	}
+	if (tb[IFLA_CAN_TDC_TDCF_MIN] && tb[IFLA_CAN_TDC_TDCF_MAX]) {
+		__u32 *tdcf_min = RTA_DATA(tb[IFLA_CAN_TDC_TDCF_MIN]);
+		__u32 *tdcf_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCF_MAX]);
+
+		can_print_timing_min_max("tdcf", " tdcf", *tdcf_min, *tdcf_max);
+	}
+	close_json_object();
+}
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
@@ -421,6 +526,10 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   dbt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " dsjw %u", dbt->sjw);
 		print_uint(PRINT_ANY, "brp", " dbrp %u", dbt->brp);
+
+		if (tb[IFLA_CAN_TDC])
+			can_print_tdc_opt(f, tb[IFLA_CAN_TDC]);
+
 		close_json_object();
 	}
 
@@ -441,6 +550,10 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		can_print_timing_min_max("brp", " dbrp",
 					 dbtc->brp_min, dbtc->brp_max);
 		print_uint(PRINT_ANY, "brp_inc", " dbrp_inc %u", dbtc->brp_inc);
+
+		if (tb[IFLA_CAN_TDC])
+			can_print_tdc_const_opt(f, tb[IFLA_CAN_TDC]);
+
 		close_json_object();
 	}
 
-- 
2.32.0

