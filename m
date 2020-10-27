Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615DB29CC54
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832584AbgJ0W4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:56:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50362 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832562AbgJ0W4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:56:05 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdH9fbe/FwP3XeKGJ3l0Cm+b4e3o/aTEE/5T4JYIZFo=;
        b=HCswUXFnBU+7krIAiJOvKpJSk3khqzvmKXrOz1gM0erhfW+xw/741cfqlWqCbrRKLGLiBt
        2ZUaoSP5ox8MMXp4zr4zTdeIQdrQbLDd0lfErEBFbuXJjY3Sl3TG4/ouW5bIhvmTNIXpU2
        BTxYIVC5S4gOd9AbXC9lwhtY+aEdK+XsyZo+dmWM4PBHrMzxjgQL0BRejFLweIG6Bz/IjH
        nC8PmUrMrQF9GbZZGnV1R5kFKPY2Fs+ZajwTg/K7K2jZYCeoeZvjAFEvEq0xdkMubwsmn/
        UsR1mqQZqTsrHdN5Gr4QV7uqdaWF2X7OF6/NuBkY5fZeD4jNj5by8GNXbkDe4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdH9fbe/FwP3XeKGJ3l0Cm+b4e3o/aTEE/5T4JYIZFo=;
        b=oAEOw6n2K77vQLRBPQlNlkEg06bqlyVo2TatzLpimvX8utPK3aWhDMLaJa4tCTD6u/57ST
        kccvLXygOL73iBBg==
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
Subject: [PATCH net-next 14/15] net: dpaa: Replace in_irq() usage.
Date:   Tue, 27 Oct 2020 23:54:53 +0100
Message-Id: <20201027225454.3492351-15-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses in_irq() + in_serving_softirq() magic to decide if NAPI
scheduling is required or packet processing.

The usage of in_*() in drivers is phased out and Linus clearly requested
that code which changes behaviour depending on context should either be
seperated or the context be conveyed in an argument passed by the caller,
which usually knows the context.

Use the `napi' argument passed by the callback. It is set true if
called from the interrupt handler and NAPI should be scheduled.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Horia Geant=C4=83" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Madalin Bucur <madalin.bucur@nxp.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Li Yang <leoyang.li@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index 27835310b718e..2c949acd74c67 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2300,9 +2300,9 @@ static void dpaa_tx_conf(struct net_device *net_dev,
 }
=20
 static inline int dpaa_eth_napi_schedule(struct dpaa_percpu_priv *percpu_p=
riv,
-					 struct qman_portal *portal)
+					 struct qman_portal *portal, bool napi)
 {
-	if (unlikely(in_irq() || !in_serving_softirq())) {
+	if (napi) {
 		/* Disable QMan IRQ and invoke NAPI */
 		qman_p_irqsource_remove(portal, QM_PIRQ_DQRI);
=20
@@ -2333,7 +2333,7 @@ static enum qman_cb_dqrr_result rx_error_dqrr(struct =
qman_portal *portal,
=20
 	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
=20
-	if (dpaa_eth_napi_schedule(percpu_priv, portal))
+	if (dpaa_eth_napi_schedule(percpu_priv, portal, napi))
 		return qman_cb_dqrr_stop;
=20
 	dpaa_eth_refill_bpools(priv);
@@ -2377,7 +2377,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struc=
t qman_portal *portal,
 	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
 	percpu_stats =3D &percpu_priv->stats;
=20
-	if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal)))
+	if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal, napi)))
 		return qman_cb_dqrr_stop;
=20
 	/* Make sure we didn't run out of buffers */
@@ -2474,7 +2474,7 @@ static enum qman_cb_dqrr_result conf_error_dqrr(struc=
t qman_portal *portal,
=20
 	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
=20
-	if (dpaa_eth_napi_schedule(percpu_priv, portal))
+	if (dpaa_eth_napi_schedule(percpu_priv, portal, napi))
 		return qman_cb_dqrr_stop;
=20
 	dpaa_tx_error(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
@@ -2499,7 +2499,7 @@ static enum qman_cb_dqrr_result conf_dflt_dqrr(struct=
 qman_portal *portal,
=20
 	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
=20
-	if (dpaa_eth_napi_schedule(percpu_priv, portal))
+	if (dpaa_eth_napi_schedule(percpu_priv, portal, napi))
 		return qman_cb_dqrr_stop;
=20
 	dpaa_tx_conf(net_dev, priv, percpu_priv, &dq->fd, fq->fqid);
--=20
2.28.0

