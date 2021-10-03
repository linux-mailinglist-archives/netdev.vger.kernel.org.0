Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409FD42001F
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 07:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhJCFEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 01:04:54 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:56460 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJCFEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 01:04:53 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id WtdMmhDZXsoWhWteSm9QcI; Sun, 03 Oct 2021 07:03:05 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 03 Oct 2021 07:03:05 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 2/3] iplink_can: add ctrlmode_{supported,_static} to the "--details --json" output
Date:   Sun,  3 Oct 2021 14:01:46 +0900
Message-Id: <20211003050147.569044-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
References: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is the userland counterpart of [1].  Indeed, [1] allows the
can netlink interface to report the CAN controller capabilities.

Previously, only the options which were switched on were reported
(i.e. can_priv::ctrlmode). Here, we add two additional pieces of
information to the json report:

  - ctrlmode_supported: the options that can be modified by netlink

  - ctrlmode_static: option which are statically enabled by the driver
    (i.e. can not be turned off)

For your information, we borrowed the naming convention from struct
can_priv[2].

Contrary to the ctrlmode, the ctrlmode_{supported,_static} are only
reported in the json context. The reason is that this newly added
information can quickly become very verbose and we do not want to
overload the default output. You can think of the --details output as
the verbose mode and the --details --json output as the *very* verbose
mode.

*Example:*

This is how the output would look like for a dummy driver which would
have:
  - FCAN_CTRLMODE_FD_NON_ISO statically enabled by the driver
  - CAN_CTRLMODE_CC_LEN8_DLC turned on by the user
  - CAN_CTRLMODE_LOOPBACK, CAN_CTRLMODE_LISTENONLY,
    CAN_CTRLMODE_3_SAMPLES, CAN_CTRLMODE_FD, CAN_CTRLMODE_CC_LEN8_DLC
    supported by the driver

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
|                 "ctrlmode_supported": [ "LOOPBACK","LISTEN-ONLY","TRIPLE-SAMPLING","FD","CC-LEN8-DLC" ],
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
|                     "brp_inc": 1
|                 },
|                 "clock": 80000000
|             }
|         },
|         "num_tx_queues": 1,
|         "num_rx_queues": 1,
|         "gso_max_size": 65536,
|         "gso_max_segs": 65535,
|         "parentbus": "usb",
|         "parentdev": "1-9:1.1"
|     } ]

As mentioned above, the default output remains unchanged:

| $ ./ip --details link show can0
| 1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
|     link/can  promiscuity 0 minmtu 0 maxmtu 0
|     can <FD-NON-ISO, CC-LEN8-DLC> state STOPPED restart-ms 0
| 	  DUMMY_CAN_DEV: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
| 	  DUMMY_CAN_DEV: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
| 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 parentbus usb parentdev 1-9:1.1

[1] https://lore.kernel.org/linux-can/20211003044049.568441-1-mailhol.vincent@wanadoo.fr/T/#u
[2] https://elixir.bootlin.com/linux/v5.14/source/include/linux/can/dev.h#61

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
I tried to think a lot of what would be the best way to report the
ctrlmode_{supported,_static} in the default (non-json) context and
just concluded that this was too much info.

That said, I warmly welcome any ideas of how to add
ctrlmode_{supported,_static} to the default output while keeping
things sexy.
---
 ip/iplink_can.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index c70c420d..516dfd23 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -124,7 +124,7 @@ static int can_parse_opt(struct link_util *lu, int argc, char **argv,
 			 struct nlmsghdr *n)
 {
 	struct can_bittiming bt = {}, dbt = {};
-	struct can_ctrlmode cm = {0, 0};
+	struct can_ctrlmode cm = { 0 };
 
 	while (argc > 0) {
 		if (matches(*argv, "bitrate") == 0) {
@@ -292,6 +292,8 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		struct can_ctrlmode *cm = RTA_DATA(tb[IFLA_CAN_CTRLMODE]);
 
 		print_ctrlmode(PRINT_ANY, cm->flags, "ctrlmode");
+		print_ctrlmode(PRINT_JSON, cm->supported, "ctrlmode_supported");
+		print_ctrlmode(PRINT_JSON, cm->flags & ~cm->supported, "ctrlmode_static");
 	}
 
 	if (tb[IFLA_CAN_STATE]) {
-- 
2.32.0

