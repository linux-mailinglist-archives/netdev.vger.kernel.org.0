Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44553F76AD
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 15:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbhHYN7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 09:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbhHYN73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 09:59:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FB2C0613CF
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 06:58:43 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629899921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmAigCY/2C2mbmbfA09witnGDE+mfM3JgDAyON82MKY=;
        b=tQCmKA/86gH8Nfq6z4MpxN5D7CBlEopmIOQQd2Qtv0a5TByyRhjBVEZXlfPqXjkUMhakzt
        HL6g/T9whWoghZ2aCBUxu/lmczCDHTzH7mAppjOPO3xqCjdJslxpgB1ATHK1hMF/3eN4bQ
        asPmvZ5DfxLa+TeY9H5qPHnkZ69es003lxnGFhAJ0ggdYQsSlvSxRluAIO5JAGRXldsIEr
        yS7sTA6PcAMCdr0UqKsXD+jbc1K1l+tOM0bFaGXdkhA3iRf2NZsHwuIXCQgas2N+yKHrO9
        8OTqgWU8fqsRIXGCK/9Z+QDIqFGBXYJ5N7OHjZq9kZQi7Qr0aRNzhsXxLu1mQg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629899921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmAigCY/2C2mbmbfA09witnGDE+mfM3JgDAyON82MKY=;
        b=xnMv/q2KHTBsozwulRNXiF/u5MEzxC7SXlxsBuowy6RdzLFhBzIHMe9SHuoqCkajUrbgeq
        jxTnni0puKnkbeDw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net 1/2] net: dsa: hellcreek: Fix incorrect setting of GCL
Date:   Wed, 25 Aug 2021 15:58:12 +0200
Message-Id: <20210825135813.73436-2-kurt@linutronix.de>
In-Reply-To: <20210825135813.73436-1-kurt@linutronix.de>
References: <20210825135813.73436-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the gate control list which is programmed into the hardware is
incorrect resulting in wrong traffic schedules. The problem is the loop
variables are incremented before they are referenced. Therefore, move the
increment to the end of the loop.

Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 5c54ae1be62c..b57aea92684b 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1472,9 +1472,6 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 		u16 data;
 		u8 gates;
 
-		cur++;
-		next++;
-
 		if (i == schedule->num_entries)
 			gates = initial->gate_mask ^
 				cur->gate_mask;
@@ -1503,6 +1500,9 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 			(initial->gate_mask <<
 			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
 		hellcreek_write(hellcreek, data, TR_GCLCMD);
+
+		cur++;
+		next++;
 	}
 }
 
-- 
2.30.2

