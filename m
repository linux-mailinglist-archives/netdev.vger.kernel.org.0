Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59F03AC68B
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFRIzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:55:54 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:18098 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbhFRIzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:55:53 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d28 with ME
        id JYtR2500E0zjR6y03Ythcp; Fri, 18 Jun 2021 10:53:43 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 18 Jun 2021 10:53:43 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 1/4] iplink_can: fix configuration ranges in print_usage()
Date:   Fri, 18 Jun 2021 17:53:19 +0900
Message-Id: <20210618085322.147462-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210618085322.147462-1-mailhol.vincent@wanadoo.fr>
References: <20210618085322.147462-1-mailhol.vincent@wanadoo.fr>
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

Because no maximum ranges are given, all given ranges { a..b } are
simply replaced with { NUMBER }.

The actual ranges are specific to earch device and should be confirmed
doing:

$ ip --details link show can0
1: can0: <NOARP,ECHO> mtu 16 qdisc noop state DOWN mode DEFAULT group default qlen 10
    link/can  promiscuity 0 minmtu 0 maxmtu 0
    can state STOPPED restart-ms 0
	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp-inc 1
	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp-inc 1
	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 6a26f3ff..2736f3ab 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -44,13 +44,13 @@ static void print_usage(FILE *f)
 		"\n"
 		"\t[ termination { 0..65535 } ]\n"
 		"\n"
-		"\tWhere: BITRATE	:= { 1..1000000 }\n"
+		"\tWhere: BITRATE	:= { NUMBER }\n"
 		"\t	  SAMPLE-POINT	:= { 0.000..0.999 }\n"
 		"\t	  TQ		:= { NUMBER }\n"
-		"\t	  PROP-SEG	:= { 1..8 }\n"
-		"\t	  PHASE-SEG1	:= { 1..8 }\n"
-		"\t	  PHASE-SEG2	:= { 1..8 }\n"
-		"\t	  SJW		:= { 1..4 }\n"
+		"\t	  PROP-SEG	:= { NUMBER }\n"
+		"\t	  PHASE-SEG1	:= { NUMBER }\n"
+		"\t	  PHASE-SEG2	:= { NUMBER }\n"
+		"\t	  SJW		:= { NUMBER }\n"
 		"\t	  RESTART-MS	:= { 0 | NUMBER }\n"
 		);
 }
-- 
2.31.1

