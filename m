Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136AF4162AA
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 18:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242431AbhIWQGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 12:06:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35468 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242406AbhIWQGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 12:06:00 -0400
Message-ID: <20210923153339.684546907@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1632413067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=V+wcLznHEL6e40Q6X7LpkxWU7Zjc25v6soPUcFLqFBY=;
        b=dVM4Xum+mQkFstydxFuGf5BisZe/c9O6s8w6jSuLA7aFJd64a6TX3rafQ7vbCLrtT/RRA6
        gEO/cN+Q80Lw8ckbKyKPdtAyEhTVfHQNeRSRkDriW9nq5Hfgr5C8POOVqcqbu8bdu88eJO
        j5QeAHVtuCQ12n3kSEYR9S3xZvBHuvkSxHTZ6HLo8CLhymUTm8p17YJMGuxRMqbNOHcNuy
        MeMmKn7fUvaSw+XermL9Bmbx7npPdu3i4jNyhHgqxoGxDBBjTbxVeHgIqTxSd6OUpLdNAc
        gtnHXiI0kzTRVIgvk63MJvpnghAzdCg6Hqv27hl+ub2eJNg2GFZsbow5p3os4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1632413067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=V+wcLznHEL6e40Q6X7LpkxWU7Zjc25v6soPUcFLqFBY=;
        b=ntmMbnkLf5fxazFGm6OXJkBz0j1nWLwzO+vpZ3AaiKb0kCzl1acxcdGqKpK2N87Ikus9f6
        sSAAqtt7HpZ1EaBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/11] can: bcm: Use hrtimer_forward_now()
References: <20210923153311.225307347@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 23 Sep 2021 18:04:27 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hrtimer_forward_now() provides the same functionality as the open coded
hrimer_forward() invocation. Prepares for removal of hrtimer_forward() from
the public interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-can@vger.kernel.org
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 net/can/bcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -625,7 +625,7 @@ static enum hrtimer_restart bcm_rx_thr_h
 	struct bcm_op *op = container_of(hrtimer, struct bcm_op, thrtimer);
 
 	if (bcm_rx_thr_flush(op)) {
-		hrtimer_forward(hrtimer, ktime_get(), op->kt_ival2);
+		hrtimer_forward_now(hrtimer, op->kt_ival2);
 		return HRTIMER_RESTART;
 	} else {
 		/* rearm throttle handling */

