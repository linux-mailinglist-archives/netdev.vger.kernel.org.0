Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0853EC1F3
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbhHNKSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 06:18:32 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:23673 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbhHNKSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 06:18:31 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d19 with ME
        id hNHf2500A0zjR6y03NJ0jr; Sat, 14 Aug 2021 12:18:02 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 14 Aug 2021 12:18:02 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 1/4] iplink_can: fix configuration ranges in print_usage() and add unit
Date:   Sat, 14 Aug 2021 19:17:25 +0900
Message-Id: <20210814101728.75334-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The configuration ranges in print_usage() are taken from "Table 8 -
Time segments' minimum configuration ranges" in section 11.3.1.2
"Configuration of the bit time parameters" of ISO 11898-1.

The standard clearly specifies that "implementations may allow time
segments that exceed the minimum required configuration ranges
specified in Table 8".

Because no maximum ranges are given in the standard, all given ranges
{ a..b } are simply replaced with { NUMBER }.

The actual ranges are specific to each device and can be confirmed
doing:

$ ip --details link show can0
1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state STOPPED restart-ms 0
	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

Finally, the unit (bps, tq, ns or ms) are given. The rationale to add
the units is that the TDC parameters (that will be introduced in the
upcoming patches) are measured in a different unit than the other
bittiming parameters: clock period (a.k.a. minimum time quantum)
instead of time quantum. Adding the units disambiguates things.

For reference, before the change:
$ ip link set can0 type can help
Usage: ip link set DEVICE type can
	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
 	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]

	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
 	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]

	[ loopback { on | off } ]
	[ listen-only { on | off } ]
	[ triple-sampling { on | off } ]
	[ one-shot { on | off } ]
	[ berr-reporting { on | off } ]
	[ fd { on | off } ]
	[ fd-non-iso { on | off } ]
	[ presume-ack { on | off } ]

	[ restart-ms TIME-MS ]
	[ restart ]

	[ termination { 0..65535 } ]

	Where: BITRATE	:= { 1..1000000 }
		  SAMPLE-POINT	:= { 0.000..0.999 }
		  TQ		:= { NUMBER }
		  PROP-SEG	:= { 1..8 }
		  PHASE-SEG1	:= { 1..8 }
		  PHASE-SEG2	:= { 1..8 }
		  SJW		:= { 1..4 }
		  RESTART-MS	:= { 0 | NUMBER }

...and after it:
$ ip link set can0 type can help
Usage: ip link set DEVICE type can
	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
 	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]

	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
 	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]

	[ loopback { on | off } ]
	[ listen-only { on | off } ]
	[ triple-sampling { on | off } ]
	[ one-shot { on | off } ]
	[ berr-reporting { on | off } ]
	[ fd { on | off } ]
	[ fd-non-iso { on | off } ]
	[ presume-ack { on | off } ]
	[ cc-len8-dlc { on | off } ]

	[ restart-ms TIME-MS ]
	[ restart ]

	[ termination { 0..65535 } ]

	Where: BITRATE	:= { NUMBER in bps }
		  SAMPLE-POINT	:= { 0.000..0.999 }
		  TQ		:= { NUMBER in ns }
		  PROP-SEG	:= { NUMBER in tq }
		  PHASE-SEG1	:= { NUMBER in tq }
		  PHASE-SEG2	:= { NUMBER in tq }
		  SJW		:= { NUMBER in tq }
		  RESTART-MS	:= { 0 | NUMBER in ms }

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6a26f3ff..0b2ff8a3 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -44,14 +44,14 @@ static void print_usage(FILE *f)
 		"\n"
 		"\t[ termination { 0..65535 } ]\n"
 		"\n"
-		"\tWhere: BITRATE	:= { 1..1000000 }\n"
+		"\tWhere: BITRATE	:= { NUMBER in bps }\n"
 		"\t	  SAMPLE-POINT	:= { 0.000..0.999 }\n"
-		"\t	  TQ		:= { NUMBER }\n"
-		"\t	  PROP-SEG	:= { 1..8 }\n"
-		"\t	  PHASE-SEG1	:= { 1..8 }\n"
-		"\t	  PHASE-SEG2	:= { 1..8 }\n"
-		"\t	  SJW		:= { 1..4 }\n"
-		"\t	  RESTART-MS	:= { 0 | NUMBER }\n"
+		"\t	  TQ		:= { NUMBER in ns }\n"
+		"\t	  PROP-SEG	:= { NUMBER in tq }\n"
+		"\t	  PHASE-SEG1	:= { NUMBER in tq }\n"
+		"\t	  PHASE-SEG2	:= { NUMBER in tq }\n"
+		"\t	  SJW		:= { NUMBER in tq }\n"
+		"\t	  RESTART-MS	:= { 0 | NUMBER in ms }\n"
 		);
 }
 
-- 
2.31.1

