Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82A36BEDC
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 07:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhD0FWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 01:22:42 -0400
Received: from mout01.posteo.de ([185.67.36.65]:60133 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhD0FWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 01:22:37 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id A083924002A
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 07:21:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1619500913; bh=c9HwlFNkXVQClpPdN97uB7nEFbFhZBEgXsw6/gyE4Y4=;
        h=From:To:Subject:Date:From;
        b=sPGdMcPF3yZXGDUihXtW36CEMvYumSt+3EGohi5iT0bCeZtfrELCK19c1rExoFLZg
         M9qarxENQp5hFSiAyxrmLo6grjn5RVeBm58UXIRHpNhYSdiX/CelVoZ/58vgP1Radt
         3h6qbtOtgPdNB9+y7UXJhtFGPAiJK4p1mBZcVonXdME0VFH7Drr4vDsCVsiM4foftZ
         Z+0HEJ1h4XBRmfzD82G+M/ENaGaORtMhGSbOl8Oks6wHbDaYkScZcZrMI1hIwASomV
         tg+BCHwzIK1gyr247lDuy8/t0suqrGpo6JLk1vZbnB0IHFa9uFpTRuw8COEOpD4U18
         H+7y2BBKXEg0A==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FTqrK04Djz9rxF;
        Tue, 27 Apr 2021 07:21:52 +0200 (CEST)
From:   Patrick Menschel <menschel.p@posteo.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] can-isotp: Add error message if txqueuelen is too small
Date:   Tue, 27 Apr 2021 05:21:49 +0000
Message-Id: <20210427052150.2308-4-menschel.p@posteo.de>
In-Reply-To: <20210427052150.2308-1-menschel.p@posteo.de>
References: <20210427052150.2308-1-menschel.p@posteo.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an additional error message in
case that txqueuelen is set too small and
advices the user to increase txqueuelen.

This is likely to happen even with small transfers if
txqueuelen is at default value 10 frames.

Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
---
 net/can/isotp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 2075d8d9e..d08f95bfd 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -797,10 +797,12 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		can_skb_set_owner(skb, sk);
 
 		can_send_ret = can_send(skb, 1);
-		if (can_send_ret)
+		if (can_send_ret) {
 			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 				       __func__, ERR_PTR(can_send_ret));
-
+			if (can_send_ret == -ENOBUFS)
+				pr_notice_once("can-isotp: tx queue is full, increasing txqueuelen may prevent this error");
+		}
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
 			so->tx.state = ISOTP_IDLE;
-- 
2.17.1

