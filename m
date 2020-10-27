Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B82929CC42
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832528AbgJ0Wzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49954 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1795169AbgJ0Wzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:49 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCh5w9ecP7hR6Lh6yrwLcXDxY3S9AS4A8O59ClkmQuc=;
        b=ras1ZN9p/0s71wAw6BiBK7tQahnylR+TBxJ5FU+RyyAUd654I45XroAagmXNcOhZGwycQU
        JuB4srVEeq8JEdNYcazZGYxW43kHEWBW5olkexuNTx+ROG4rW4+lIg6oh7RjFfnmiYIMSa
        wja8WVkTfnwqG5yCdjniR3JYvVzyFeZ5xY4gUgFa/48uACynrZzW+jFjl7+Gm1Ak37HK8p
        i/LKjYW8uioJWsvMjaEFv0DOxsaAb1xs+tCGlkELjceM3XFKR9pZVfCoL3oL63qwaBCct1
        uDLBmNS2D4JG5AgIEUYeAmWi2edcivpTlNAp8bjFhFJaHoQh3tvbl3SKJ1tFdA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NCh5w9ecP7hR6Lh6yrwLcXDxY3S9AS4A8O59ClkmQuc=;
        b=v4kTPiwVtn0BHjC1H1qdUC0DOW5ocQSNsfxbnR+jglqhT5b2wBt7em4IRx8CX07gIiVoDE
        zxqH636veSWAMICg==
To:     netdev@vger.kernel.org
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Daniel Drake <dsd@gentoo.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        Jouni Malinen <j@w1.fi>, Kalle Valo <kvalo@codeaurora.org>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        linux-wireless@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Samuel Chessman <chessman@tux.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 03/15] net: forcedeth: Replace context and lock check with a lockdep_assert()
Date:   Tue, 27 Oct 2020 23:54:42 +0100
Message-Id: <20201027225454.3492351-4-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nv_update_stats() triggers a WARN_ON() when invoked from hard interrupt
context because the locks in use are not hard interrupt safe. It also has
an assert_spin_locked() which was the lock check before the lockdep era.

Lockdep has way broader locking correctness checks and covers both issues,
so replace the warning and the lock assert with lockdep_assert_held().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Rain River <rain.1986.08.12@gmail.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/nvidia/forcedeth.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet=
/nvidia/forcedeth.c
index 2fc10a36afa4a..7e85cf943be11 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1666,11 +1666,7 @@ static void nv_update_stats(struct net_device *dev)
 	struct fe_priv *np =3D netdev_priv(dev);
 	u8 __iomem *base =3D get_hwbase(dev);
=20
-	/* If it happens that this is run in top-half context, then
-	 * replace the spin_lock of hwstats_lock with
-	 * spin_lock_irqsave() in calling functions. */
-	WARN_ONCE(in_irq(), "forcedeth: estats spin_lock(_bh) from top-half");
-	assert_spin_locked(&np->hwstats_lock);
+	lockdep_assert_held(&np->hwstats_lock);
=20
 	/* query hardware */
 	np->estats.tx_bytes +=3D readl(base + NvRegTxCnt);
--=20
2.28.0

