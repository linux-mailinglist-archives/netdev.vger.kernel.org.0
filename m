Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224884862ED
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiAFKaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:30:01 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:49295 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbiAFK36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:29:58 -0500
Received: from localhost.localdomain ([124.33.176.97])
        by smtp.orange.fr with ESMTPA
        id 5Q1hnk12SPnAJ5Q1pnsyfm; Thu, 06 Jan 2022 11:29:56 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Thu, 06 Jan 2022 11:29:56 +0100
X-ME-IP: 124.33.176.97
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v3] iplink_can: add ctrlmode_{supported,_static} to the "--details --json" output
Date:   Thu,  6 Jan 2022 19:29:37 +0900
Message-Id: <20220106102937.2824-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is the userland counterpart of [1]. Indeed, [1] allows the
can netlink interface to report the CAN controller capabilities.

Previously, only the options which were switched on were reported
(i.e. can_priv::ctrlmode). Here, we add two additional pieces of
information to the json report:

  - ctrlmode_supported: the options that can be modified by netlink

  - ctrlmode_static: option which are statically enabled by the driver
    (i.e. can not be turned off)

For your information, we borrowed the naming convention from struct
can_priv [2].

Contrary to the ctrlmode, the ctrlmode_{supported,_static} are only
reported in the json context. The reason is that this newly added
information can quickly become very verbose and we do not want to
overload the default output. You can think of the "ip --details link
show canX" output as the verbose mode and the "ip --details --json
link show canX" output as the *very* verbose mode.

*Example:*

This is how the output would look like for a dummy driver which would
have:

  - CAN_CTRLMODE_LOOPBACK, CAN_CTRLMODE_LISTENONLY,
    CAN_CTRLMODE_3_SAMPLES, CAN_CTRLMODE_FD, CAN_CTRLMODE_CC_LEN8_DLC
    and TDC-AUTO supported by the driver

  - CAN_CTRLMODE_CC_LEN8_DLC turned on by the user

  - CAN_CTRLMODE_FD_NON_ISO statically enabled by the driver

| $ ip link set can0 type can cc-len8-dlc on
| $ ip --details --json --pretty link show can0
| [ {
|         "ifindex": 1,
|         "ifname": "can0",
|         "flags": [ "NOARP","ECHO" ],
|         "mtu": 16,
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
|                 "ctrlmode": [ "FD-NON-ISO","CC-LEN8-DLC" ],
|                 "ctrlmode_supported": [ "LOOPBACK","LISTEN-ONLY","TRIPLE-SAMPLING","FD","CC-LEN8-DLC","TDC-AUTO" ],
|                 "ctrlmode_static": [ "FD-NON-ISO" ],
|                 "state": "STOPPED",
|                 "restart_ms": 0,
|                 "bittiming_const": {
|                     "name": "DUMMY_CAN_DEV",
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
|                 "data_bittiming_const": {
|                     "name": "DUMMY_CAN_DEV",
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
|         "gso_max_segs": 65535,
|         "parentbus": "usb",
|         "parentdev": "1-10:1.1"
|     } ]

As mentioned above, the default output remains unchanged:

| $ ip --details link show can0
| 1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <FD-NON-ISO,CC-LEN8-DLC> state STOPPED restart-ms 0
| 	  DUMMY_CAN_DEV: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_inc 1
| 	  DUMMY_CAN_DEV: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_inc 1
| 	  tdco 0..127 tdcf 0..127
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus usb parentdev 1-10:1.1

[1] commit 383f0993fc77 ("can: netlink: report the CAN controller mode
    supported flags")
    https://lore.kernel.org/linux-can/20220105144402.1174191-16-mkl@pengutronix.de/T/#u

[2] https://elixir.bootlin.com/linux/v5.14/source/include/linux/can/dev.h#61

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
I am sending a last RFC because I would like to gather people's
opinion on the output format. I will reply to my own message just
after with more details.

* Changelog *

v2 -> v3

  - Rebased on the latest version of iproute2-next.
  - Minor changes in the commit description.

v1 -> v2

  - The kernel uapi was modified to use a new NLA_NESTED entry instead
    of reusing struct can_ctrlmode. The second and third patch of the
    series were updated accordingly.

Vincent Mailhol (3):
  iplink_can: code refactoring of print_ctrlmode()
  iplink_can: add ctrlmode_{supported,_static} to the "--details --json"
    output
  can: netlink: add new field to struct can_ctrlmode to report
    capabilities
---
 ip/iplink_can.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index f4b37528..854ccc31 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -396,6 +396,20 @@ static void can_print_tdc_const_opt(FILE *f, struct rtattr *tdc_attr)
 	close_json_object();
 }
 
+static void can_print_ctrlmode_ext(FILE *f, struct rtattr *ctrlmode_ext_attr,
+				   __u32 cm_flags)
+{
+	struct rtattr *tb[IFLA_CAN_CTRLMODE_MAX + 1];
+
+	parse_rtattr_nested(tb, IFLA_CAN_CTRLMODE_MAX, ctrlmode_ext_attr);
+	if (tb[IFLA_CAN_CTRLMODE_SUPPORTED]) {
+		__u32 *supported = RTA_DATA(tb[IFLA_CAN_CTRLMODE_SUPPORTED]);
+
+		print_ctrlmode(PRINT_JSON, *supported, "ctrlmode_supported");
+		print_ctrlmode(PRINT_JSON, cm_flags & ~*supported, "ctrlmode_static");
+	}
+}
+
 static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 {
 	if (!tb)
@@ -405,6 +419,9 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		struct can_ctrlmode *cm = RTA_DATA(tb[IFLA_CAN_CTRLMODE]);
 
 		print_ctrlmode(PRINT_ANY, cm->flags, "ctrlmode");
+		if (tb[IFLA_CAN_CTRLMODE_EXT])
+			can_print_ctrlmode_ext(f, tb[IFLA_CAN_CTRLMODE_EXT],
+					       cm->flags);
 	}
 
 	if (tb[IFLA_CAN_STATE]) {
-- 
2.34.1

