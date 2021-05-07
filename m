Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4123B3763BA
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 12:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhEGKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 06:30:03 -0400
Received: from smtp01.smtpout.orange.fr ([80.12.242.123]:38221 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236872AbhEGKaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 06:30:01 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d48 with ME
        id 1mUT2500A3PnFJp03mUyTA; Fri, 07 May 2021 12:29:00 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 07 May 2021 12:29:00 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v2 2/2] iplink_can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
Date:   Fri,  7 May 2021 19:28:19 +0900
Message-Id: <20210507102819.1932386-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210507102819.1932386-1-mailhol.vincent@wanadoo.fr>
References: <20210507102819.1932386-1-mailhol.vincent@wanadoo.fr>
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

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 include/uapi/linux/can/netlink.h | 25 +++++++++++--
 ip/iplink_can.c                  | 64 ++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 3 deletions(-)

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
index 1421f0ea..8c2f6beb 100644
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
@@ -52,6 +53,9 @@ static void print_usage(FILE *f)
 		"\t	  PHASE-SEG2	:= { 1..8 }\n"
 		"\t	  SJW		:= { 1..4 }\n"
 		"\t	  RESTART-MS	:= { 0 | NUMBER }\n"
+		"\t	  TDCV		:= { NUMBER }\n"
+		"\t	  TDCO		:= { NUMBER }\n"
+		"\t	  TDCF		:= { NUMBER }\n"
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
@@ -254,6 +272,15 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 	if (cm.mask)
 		addattr_l(n, 1024, IFLA_CAN_CTRLMODE, &cm, sizeof(cm));
 
+	tdc = addattr_nest(n, 1024, IFLA_CAN_TDC | NLA_F_NESTED);
+	if (tdcv != -1)
+		addattr32(n, 1024, IFLA_CAN_TDC_TDCV, tdcv);
+	if (tdco != -1)
+		addattr32(n, 1024, IFLA_CAN_TDC_TDCO, tdco);
+	if (tdcf != -1)
+		addattr32(n, 1024, IFLA_CAN_TDC_TDCF, tdcf);
+	addattr_nest_end(n, tdc);
+
 	return 0;
 }
 
@@ -294,6 +321,40 @@ static void can_print_data_timing_min_max(const char *attr, int min, int max)
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
+		print_uint(PRINT_ANY, "tdcv", "tdcv %u", *tdcv);
+		print_uint(PRINT_ANY, "tdco", " tdco %u", *tdco);
+		print_uint(PRINT_ANY, "tdcf", " tdcf %u", *tdcf);
+		close_json_object();
+	}
+
+	if (tb[IFLA_CAN_TDC_TDCV_MAX] && tb[IFLA_CAN_TDC_TDCO_MAX] &&
+	    tb[IFLA_CAN_TDC_TDCF_MAX]) {
+		__u32 *tdcv_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCV_MAX]);
+		__u32 *tdco_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCO_MAX]);
+		__u32 *tdcf_max = RTA_DATA(tb[IFLA_CAN_TDC_TDCF_MAX]);
+
+		open_json_object("tdc_const");
+		can_print_nl_indent();
+		print_uint(PRINT_ANY, "tdcv_max", "tdcv_max %u", *tdcv_max);
+		print_uint(PRINT_ANY, "tdco_max", " tdco_max %u", *tdco_max);
+		print_uint(PRINT_ANY, "tdcf_max", " tdcf_max %u", *tdcf_max);
+		close_json_object();
+	}
+}
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
@@ -478,6 +539,9 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		close_json_array(PRINT_JSON, " ]");
 	}
 
+	if (tb[IFLA_CAN_TDC])
+		can_print_tdc_opt(f, tb[IFLA_CAN_TDC]);
+
 	if (tb[IFLA_CAN_TERMINATION_CONST] && tb[IFLA_CAN_TERMINATION]) {
 		__u16 *trm = RTA_DATA(tb[IFLA_CAN_TERMINATION]);
 		__u16 *trm_const = RTA_DATA(tb[IFLA_CAN_TERMINATION_CONST]);
-- 
2.26.3

