Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807575A0F63
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbiHYLhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240538AbiHYLgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:36:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3CA2CDC5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:36:52 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661427410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n8xzD/4u1H6XLUUMs6D38LTD+KsnylSlHJWwXIAMov4=;
        b=O/fu8LRCN8ywhU0tosT19GaDEiOXmXXBcYI/zHdGUr89Re7g8TyD1emCVuaRfDZmsccxfW
        RvGC5Pr/xfkkcWmrrqvi2p53C2j4CRLrtBjVMc4LL9E5GUPPhKXMdUQxHMIdMl1ebdt9D/
        AAwmHnep3HiA+JPHlQq7sKFiFeZi4h0DrYVcdRWk9+i4iwI6DmOI23AN8aYxPhiG92fmM9
        +9xQXJ+beQfl+qb/CKc2QzbpetLF2jVSrrMHF2yXFx9zmxKeF08TNfOWSUX+BT4G38HKzl
        +Fa98uQcHhbXHQLW27ttEsAYFumpvLG0rq7/6LFG9FnuXUyIEiS154IruLMMfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661427410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n8xzD/4u1H6XLUUMs6D38LTD+KsnylSlHJWwXIAMov4=;
        b=PQbwpf7UadLoBhApCMn33rIOy2PPtouo7UE7hRxVHL2urwK/tKlQ7M4Y3QttY1V0cxH1DZ
        jIGOwna67H0u0bDA==
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/2] net: dsa: xrs700x: Use irqsave variant for u64 stats update
Date:   Thu, 25 Aug 2022 13:36:44 +0200
Message-Id: <20220825113645.212996-2-bigeasy@linutronix.de>
In-Reply-To: <20220825113645.212996-1-bigeasy@linutronix.de>
References: <20220825113645.212996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xrs700x_read_port_counters() updates the stats from a worker using the
u64_stats_update_begin() version. This is okay on 32-UP since on the
reader side preemption is disabled.
On 32bit-SMP the writer can be preempted by the reader at which point
the reader will spin on the seqcount until writer continues and
completes the update.

Assigning the mib_mutex mutex to the underlying seqcount would ensure
proper synchronisation. The API for that on the u64_stats_init() side
isn't available. Since it is the only user, just use disable interrupts
during the update.

Use u64_stats_update_begin_irqsave() on the writer side to ensure an
uninterrupted update.

Fixes: ee00b24f32eb8 ("net: dsa: add Arrow SpeedChips XRS700x driver")
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: George McCollister <george.mccollister@gmail.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xr=
s700x.c
index 3887ed33c5fe2..fa622639d6401 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -109,6 +109,7 @@ static void xrs700x_read_port_counters(struct xrs700x *=
priv, int port)
 {
 	struct xrs700x_port *p =3D &priv->ports[port];
 	struct rtnl_link_stats64 stats;
+	unsigned long flags;
 	int i;
=20
 	memset(&stats, 0, sizeof(stats));
@@ -138,9 +139,9 @@ static void xrs700x_read_port_counters(struct xrs700x *=
priv, int port)
 	 */
 	stats.rx_packets +=3D stats.multicast;
=20
-	u64_stats_update_begin(&p->syncp);
+	flags =3D u64_stats_update_begin_irqsave(&p->syncp);
 	p->stats64 =3D stats;
-	u64_stats_update_end(&p->syncp);
+	u64_stats_update_end_irqrestore(&p->syncp, flags);
=20
 	mutex_unlock(&p->mib_mutex);
 }
--=20
2.37.2

