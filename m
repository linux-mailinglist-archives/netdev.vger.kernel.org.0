Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A93EC1FB
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhHNKSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 06:18:53 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:21757 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbhHNKSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 06:18:45 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d19 with ME
        id hNHf2500A0zjR6y03NJDks; Sat, 14 Aug 2021 12:18:15 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 14 Aug 2021 12:18:15 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 3/4] iplink_can: print brp and dbrp bittiming variables
Date:   Sat, 14 Aug 2021 19:17:27 +0900
Message-Id: <20210814101728.75334-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the value of the bit-rate prescaler (brp) for both the nominal
and the data bittiming.

Currently, only the constant brp values (brp_{min,max,inc}) are being
reported. Also, brp is the only member of struct can_bittiming not
being reported.

Noticeably, brp is not used as an input for bittiming calculation and
although it could be calculated by hand from the other bittiming
parameters with below formula:

        brp = clock * tq / 1000000000

with clock in hertz and tq in nano second (thus the need of a 1
billion factor to convert it back to second).

But because above formula is not so trivial to remember and is
subjected to rounding errors, it makes sense to directly output
{d,}bpr.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 ip/iplink_can.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 52ba3d12..e438e416 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -336,6 +336,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_uint(PRINT_ANY, "phase_seg2", " phase-seg2 %u",
 			   bt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " sjw %u", bt->sjw);
+		print_uint(PRINT_ANY, "brp", " brp %u", bt->brp);
 		close_json_object();
 	}
 
@@ -411,6 +412,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_uint(PRINT_ANY, "phase_seg2", " dphase-seg2 %u",
 			   dbt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " dsjw %u", dbt->sjw);
+		print_uint(PRINT_ANY, "brp", " dbrp %u", dbt->brp);
 		close_json_object();
 	}
 
-- 
2.31.1

