Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2FD2A2258
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKAXXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:23:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55398 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgKAXXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:23:22 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604272999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JCFBfexZTaTxNTJc/bdU0DkFV3ialzSAY95hXbQ9KA=;
        b=iUViDm8NvlIWcJSV36zfgPtmec6C8UofAUybKpXMq0+4u1mAdzCAp0Wt64uviukSsd5VOb
        zPfRieYKxNwIni3RPTGF+hT6wZYqTrAFFXJmiaFm0gNsNnZoXC+VCIRZ9SIiLN1NTEu/Qf
        LCrqn77SiTmUnx+ehl2EQjnbgDxHCa8MSxA1sYBVB+E8T/OslzjeuFdh0W46rv8fTJjUKB
        GJAZ12Gb+o/5DK6N2dp4/4itmTXhaHZDIBOBR9E/hOr+UMAIaqAb+T29xJ+G5SWaNwEiZI
        INLgqeAaMH9VcrHjoC/GmGzmDlkJMrdoOAReRH6dqYG68JsP8ER3GCwIDnjAVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604272999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1JCFBfexZTaTxNTJc/bdU0DkFV3ialzSAY95hXbQ9KA=;
        b=24m4nSr5As29K9Az1qCoaLo2NV+Umtfhb0UjgQX17Y8Dl3GP0N35SLzhCUHME7cTXqQKnj
        IE/zY44MlDEqtdDA==
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 net-next 3/3] crypto: caam: Replace in_irq() usage.
Date:   Mon,  2 Nov 2020 00:22:57 +0100
Message-Id: <20201101232257.3028508-4-bigeasy@linutronix.de>
In-Reply-To: <20201101232257.3028508-1-bigeasy@linutronix.de>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
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
separated or the context be conveyed in an argument passed by the caller,
which usually knows the context.

Use the `sched_napi' argument passed by the callback. It is set true if
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
 drivers/crypto/caam/qi.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 57f6ab6bfb56a..8163f5df8ebf7 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -545,14 +545,10 @@ static void cgr_cb(struct qman_portal *qm, struct qma=
n_cgr *cgr, int congested)
 	}
 }
=20
-static int caam_qi_napi_schedule(struct qman_portal *p, struct caam_napi *=
np)
+static int caam_qi_napi_schedule(struct qman_portal *p, struct caam_napi *=
np,
+				 bool sched_napi)
 {
-	/*
-	 * In case of threaded ISR, for RT kernels in_irq() does not return
-	 * appropriate value, so use in_serving_softirq to distinguish between
-	 * softirq and irq contexts.
-	 */
-	if (unlikely(in_irq() || !in_serving_softirq())) {
+	if (sched_napi) {
 		/* Disable QMan IRQ source and invoke NAPI */
 		qman_p_irqsource_remove(p, QM_PIRQ_DQRI);
 		np->p =3D p;
@@ -574,7 +570,7 @@ static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(str=
uct qman_portal *p,
 	struct caam_drv_private *priv =3D dev_get_drvdata(qidev);
 	u32 status;
=20
-	if (caam_qi_napi_schedule(p, caam_napi))
+	if (caam_qi_napi_schedule(p, caam_napi, sched_napi))
 		return qman_cb_dqrr_stop;
=20
 	fd =3D &dqrr->fd;
--=20
2.29.1

