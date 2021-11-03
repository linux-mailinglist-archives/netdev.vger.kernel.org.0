Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2722444632
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhKCQsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:48:01 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:52248 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbhKCQsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:48:00 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id iJNLmc3ywk3HQiJO4msN4F; Wed, 03 Nov 2021 17:45:22 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Wed, 03 Nov 2021 17:45:22 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2-next 5.16 v6 4/5] iplink_can: print brp and dbrp bittiming variables
Date:   Thu,  4 Nov 2021 01:44:27 +0900
Message-Id: <20211103164428.692722-5-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
References: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
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

Noticeably, brp could be calculated by hand from the other bittiming
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
index c0165237..cf6b06b8 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -344,6 +344,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_uint(PRINT_ANY, "phase_seg2", " phase-seg2 %u",
 			   bt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " sjw %u", bt->sjw);
+		print_uint(PRINT_ANY, "brp", " brp %u", bt->brp);
 		close_json_object();
 	}
 
@@ -419,6 +420,7 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 		print_uint(PRINT_ANY, "phase_seg2", " dphase-seg2 %u",
 			   dbt->phase_seg2);
 		print_uint(PRINT_ANY, "sjw", " dsjw %u", dbt->sjw);
+		print_uint(PRINT_ANY, "brp", " dbrp %u", dbt->brp);
 		close_json_object();
 	}
 
-- 
2.32.0

