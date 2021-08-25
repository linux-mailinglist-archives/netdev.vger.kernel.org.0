Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393483F76AB
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 15:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239399AbhHYN7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 09:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbhHYN73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 09:59:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D040EC0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 06:58:43 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629899922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnKxVxMcrbxTMNFgtEeld5ECw0NHcwpheIy5KClTOx0=;
        b=YhhPb0blXrA96ti8J0/p4PUzNY1TmfAC4mRAUYhomm26RNiEN8HNRSUmI1bHnrh4kRUZQM
        2cKV+IzPH1wliA8MurBYKXWUaEvPats1gDzF9uC7mG5B4fBR8SAH0S4oOeeU0Mg/ZdgJ5i
        gFllVIhQpVKqSxKqCeOgJc9yYDCwsRymFoTESvdohuVBoDR7URS4l9tYKgzD/FqAAtjuhI
        T90oj5TLp+sazqSlk1T5x48jxGgkuiOtGNF8nI8YyN14JSN8d1NlDa42NGQbf5nM+7k1R9
        jaMsh2pqxum7mG9y04NjDg37sffLSo94rG1QxsENgfVa8ZTO9VqZ/qU6yyMgFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629899922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnKxVxMcrbxTMNFgtEeld5ECw0NHcwpheIy5KClTOx0=;
        b=Je6I1Eft2BeQlNvhJIQVHBMkfANJM+/ym0QIhr2SQ7u5h3i+SR9L11wq/tcq3Xp9PqFfSn
        RZr9rW7DEB76+nBw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net 2/2] net: dsa: hellcreek: Adjust schedule look ahead window
Date:   Wed, 25 Aug 2021 15:58:13 +0200
Message-Id: <20210825135813.73436-3-kurt@linutronix.de>
In-Reply-To: <20210825135813.73436-1-kurt@linutronix.de>
References: <20210825135813.73436-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Traffic schedules can only be started up to eight seconds within the
future. Therefore, the driver periodically checks every two seconds whether the
admin base time provided by the user is inside that window. If so the schedule
is started. Otherwise the check is deferred.

However, according to the programming manual the look ahead window size should
be four - not eight - seconds. By using the proposed value of four seconds
starting a schedule at a specified admin base time actually works as expected.

Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index b57aea92684b..7062db6a083c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1550,7 +1550,7 @@ static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
 	/* Calculate difference to admin base time */
 	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
 
-	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;
+	return base_time_ns - current_ns < (s64)4 * NSEC_PER_SEC;
 }
 
 static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
-- 
2.30.2

