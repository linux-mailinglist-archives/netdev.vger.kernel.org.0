Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3644D3AC695
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhFRI41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:56:27 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:59206 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbhFRI4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:56:21 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d28 with ME
        id JYtR2500E0zjR6y03Yu8fi; Fri, 18 Jun 2021 10:54:10 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 18 Jun 2021 10:54:10 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 4/4] iplink_can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
Date:   Fri, 18 Jun 2021 17:53:22 +0900
Message-Id: <20210618085322.147462-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618085322.147462-1-mailhol.vincent@wanadoo.fr>
References: <20210618085322.147462-1-mailhol.vincent@wanadoo.fr>
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

This patch brings command line support to six TDC parameters which
were recently added to the kernel's CAN netlink interface in order to
implement TDC:
  - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
    maximum value
  - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
    maximum value
  - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
    window maximum value
  - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
  - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
  - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window

All those new parameters are nested together into the attribute
IFLA_CAN_TDC.

Zero has a special meaning for both tdcv and tdco:
  * tdcv: zero means that tdcv is automatically calculated by the
    transmitter.
  * tdco: zero means that tdc is disabled and that all parameters
    (tdcv, tdco and tdcf) should be ignored. In that case, tdc
    variables are not reported.
Please refer to the documentation of struct can_tdc for more details.

For reference, here are a few samples of how the output looks like:

$ ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on tdcv 0 tdco 7 tdcf 8

$ ip --details link show can0
1: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can <FD> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
	  bitrate 1000000 sample-point 0.750
	  tq 12 prop-seg 29 phase-seg1 30phase-seg2 20  sjw 1 brp 1
	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
	  dbitrate 8000000 dsample-point 0.700
	  dtq 12 dprop-seg 3 dphase-seg1 3 dphase-seg2 3 dsjw 1 dbrp 1
	  tdcv 0 tdco 7 tdcf 8
	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 brp_inc 1
	  tdcv_max 0 tdco_max 127 tdcf_max 127
	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

$ ip --details --json --pretty link show can0
[ {
        "ifindex": 1,
        "ifname": "can0",
        "flags": [ "NOARP","ECHO" ],
        "mtu": 72,
        "qdisc": "noop",
        "operstate": "DOWN",
        "linkmode": "DEFAULT",
        "group": "default",
        "txqlen": 10,
        "link_type": "can",
        "promiscuity": 0,
        "min_mtu": 0,
        "max_mtu": 0,
        "linkinfo": {
            "info_kind": "can",
            "info_data": {
                "ctrlmode": [ "FD" ],
                "state": "STOPPED",
                "berr_counter": {
                    "tx": 0,
                    "rx": 0
                },
                "restart_ms": 0,
                "bittiming": {
                    "bitrate": 1000000,
                    "sample_point": "0.750",
                    "tq": 12,
                    "prop_seg": 29,
                    "phase_seg1": 30,
                    "phase_seg2": 20,
                    "sjw": 1,
                    "brp": 1
                },
                "bittiming_const": {
                    "name": "ES582.1/ES584.1",
                    "tseg1": {
                        "min": 2,
                        "max": 256
                    },
                    "tseg2": {
                        "min": 2,
                        "max": 128
                    },
                    "sjw": {
                        "min": 1,
                        "max": 128
                    },
                    "brp": {
                        "min": 1,
                        "max": 512
                    },
                    "brp_inc": 1
                },
                "data_bittiming": {
                    "bitrate": 8000000,
                    "sample_point": "0.700",
                    "tq": 12,
                    "prop_seg": 3,
                    "phase_seg1": 3,
                    "phase_seg2": 3,
                    "sjw": 1,
                    "brp": 1,
                    "tdc": {
                        "tdcv": 0,
                        "tdco": 7,
                        "tdcf": 8
                    }
                },
                "data_bittiming_const": {
                    "name": "ES582.1/ES584.1",
                    "tseg1": {
                        "min": 2,
                        "max": 32
                    },
                    "tseg2": {
                        "min": 1,
                        "max": 16
                    },
                    "sjw": {
                        "min": 1,
                        "max": 8
                    },
                    "brp": {
                        "min": 1,
                        "max": 32
                    },
                    "brp_inc": 1,
                    "tdc": {
                        "tdcv_max": 0,
                        "tdco_max": 127,
                        "tdcf_max": 127
                    }
                },
                "clock": 80000000
            }
        },
        "num_tx_queues": 1,
        "num_rx_queues": 1,
        "gso_max_size": 65536,
        "gso_max_segs": 65535
    } ]

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/uapi/linux/can/netlink.h | 25 +++++++++--
 ip/iplink_can.c                  | 77 ++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 00c763df..d5cc2761 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -134,12 +134,31 @@ enum {
 	IFLA_CAN_BITRATE_CONST,
 	IFLA_CAN_DATA_BITRATE_CONST,
 	IFLA_CAN_BITRATE_MAX,
-	__IFLA_CAN_MAX
-};
+	IFLA_CAN_TDC,
 
-#define IFLA_CAN_MAX	(__IFLA_CAN_MAX - 1)
+	/* add new constants above here */
+	__IFLA_CAN_MAX,
+	IFLA_CAN_MAX = __IFLA_CAN_MAX - 1
+};
 
 /* u16 termination range: 1..65535 Ohms */
 #define CAN_TERMINATION_DISABLED 0
 
+/*
+ * CAN FD Transmitter Delay Compensation (TDC)
+ */
+enum {
+	IFLA_CAN_TDC_UNSPEC,
+	IFLA_CAN_TDC_TDCV_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCO_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCF_MAX,	/* u32 */
+	IFLA_CAN_TDC_TDCV,	/* u32 */
+	IFLA_CAN_TDC_TDCO,	/* u32 */
+	IFLA_CAN_TDC_TDCF,	/* u32 */
+
+	/* add new constants above here */
+	__IFLA_CAN_TDC,
+	IFLA_CAN_TDC_MAX = __IFLA_CAN_TDC - 1
+};
+
 #endif /* !_UAPI_CAN_NETLINK_H */
diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 311c097d..ea049999 100644
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
@@ -51,6 +52,9 @@ static void print_usage(FILE *f)
 		"\t	  PHASE-SEG1	:= { NUMBER }\n"
 		"\t	  PHASE-SEG2	:= { NUMBER }\n"
 		"\t	  SJW		:= { NUMBER }\n"
+		"\t	  TDCV		:= { 0 | NUMBER }\n"
+		"\t	  TDCO		:= { 0 | NUMBER }\n"
+		"\t	  TDCF		:= { NUMBER }\n"
 		"\t	  RESTART-MS	:= { 0 | NUMBER }\n"
 		);
 }
@@ -116,6 +120,8 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	struct can_bittiming bt = {}, dbt = {};
 	struct can_ctrlmode cm = {0, 0};
+	struct rtattr *tdc;
+	__u32 tdcv = -1, tdco = -1, tdcf = -1;
 
 	while (argc > 0) {
 		if (matches(*argv, "bitrate") == 0) {
@@ -181,6 +187,18 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
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
@@ -254,6 +272,17 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
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
 
@@ -294,6 +323,46 @@ static void can_print_data_timing_min_max(const char *attr, int min, int max)
 	can_print_timing_min_max(attr, min, max);
 }
 
+static void can_print_tdc_opt(FILE *f, struct rtattr *tdc_attr)
+{
+	struct rtattr *tb[IFLA_CAN_TDC_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_CAN_TDC_MAX, tdc_attr);
+	if (tb[IFLA_CAN_TDC_TDCV] && tb[IFLA_CAN_TDC_TDCO] &&
+	    tb[IFLA_CAN_TDC_TDCF]) {
+		__u32 *tdcv = RTA_DATA(tb[IFLA_CAN_TDC_TDCV]);
+		__u32 *tdco = RTA_DATA(tb[IFLA_CAN_TDC_TDCO]);
+		__u32 *tdcf = RTA_DATA(tb[IFLA_CAN_TDC_TDCF]);
+
+		open_json_object("tdc");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "tdcv", " tdcv %u", *tdcv);
+		print_uint(PRINT_ANY, "tdco", " tdco %u", *tdco);
+		print_uint(PRINT_ANY, "tdcf", " tdcf %u", *tdcf);
+		close_json_object();
+	}
+}
+
+static void can_print_tdc_const_opt(FILE *f, struct rtattr *tdc_attr)
+{
+	struct rtattr *tb[IFLA_CAN_TDC_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_CAN_TDC_MAX, tdc_attr);
+	if (tb[IFLA_CAN_TDC_TDCV_MAX] && tb[IFLA_CAN_TDC_TDCO_MAX] &&
+	    tb[IFLA_CAN_TDC_TDCF_MAX]) {
+		__u32 *tdcv_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCV_MAX]);
+		__u32 *tdco_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCO_MAX]);
+		__u32 *tdcf_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCF_MAX]);
+
+		open_json_object("tdc");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "tdcv_max", " tdcv_max %u", *tdcv_max);
+		print_uint(PRINT_ANY, "tdco_max", " tdco_max %u", *tdco_max);
+		print_uint(PRINT_ANY, "tdcf_max", " tdcf_max %u", *tdcf_max);
+		close_json_object();
+	}
+}
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
@@ -425,6 +494,10 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 			   dbt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " dsjw %u", dbt->sjw);
 		print_uint(PRINT_ANY, "brp", " dbrp %u", dbt->brp);
+
+		if (tb[IFLA_CAN_TDC])
+			can_print_tdc_opt(f, tb[IFLA_CAN_TDC]);
+
 		close_json_object();
 	}
 
@@ -445,6 +518,10 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		can_print_data_timing_min_max("brp",
 					      dbtc->brp_min, dbtc->brp_max);
 		print_uint(PRINT_ANY, "brp_inc", " brp_inc %u", dbtc->brp_inc);
+
+		if (tb[IFLA_CAN_TDC])
+			can_print_tdc_const_opt(f, tb[IFLA_CAN_TDC]);
+
 		close_json_object();
 	}
 
-- 
2.31.1

