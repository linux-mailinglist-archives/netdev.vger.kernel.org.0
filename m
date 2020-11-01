Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3912F2A2255
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgKAXXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgKAXXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:23:19 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CB3C0617A6;
        Sun,  1 Nov 2020 15:23:19 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604272996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/WJZK8uKWFsPAVPxn77ZrbhBf+dSYgfoRUF9cAyjV0=;
        b=tASRuZ3MGjHzhgzmUYE86xmrmKORTbjxvBaGVheTzfVCddZ2YSFx0sXE3tzCXE9f/GpGHZ
        iwTNvHTJIJXArPJZXdbleWlD4f2iDN52USfMx6jL9LyGygIm/MG94CiHxVS676aXwwzkv1
        NNLOjPBFOUunOZkh0S3tO7yKZSAe7LefWFIP8W5NL+sH8/9PuljyrK6kzdBK5vSvTyPv0E
        PjlFdgB6gg/utYS3mXtmyoftLLSRdK7U8b0/3ndKRtro/QyUNO/DxMGn8KmdNzmlPJZQph
        cQn2xM1tV+B/NCE6v9PA6LnXIWnciqso4El9cs6yGHciuhjF6vhVcYcv3olX+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604272996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q/WJZK8uKWFsPAVPxn77ZrbhBf+dSYgfoRUF9cAyjV0=;
        b=j0PH+Obni9zR6FTKvDh+PFq/CQZjE4f6FqfOESrd9F2AJ8mBCGJZMfJn/93WKtNHrrJ/lM
        wAnOPnTV8SiwSmAA==
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
Subject: [PATCH v2 net-next 1/3] soc/fsl/qbman: Add an argument to signal if NAPI processing is required.
Date:   Mon,  2 Nov 2020 00:22:55 +0100
Message-Id: <20201101232257.3028508-2-bigeasy@linutronix.de>
In-Reply-To: <20201101232257.3028508-1-bigeasy@linutronix.de>
References: <20201101232257.3028508-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpaa_eth_napi_schedule() and caam_qi_napi_schedule() schedule NAPI if
invoked from:

 - Hard interrupt context
 - Any context which is not serving soft interrupts

Any context which is not serving soft interrupts includes hard interrupts
so the in_irq() check is redundant. caam_qi_napi_schedule() has a comment
about this:

        /*
         * In case of threaded ISR, for RT kernels in_irq() does not return
         * appropriate value, so use in_serving_softirq to distinguish betw=
een
         * softirq and irq contexts.
         */
         if (in_irq() || !in_serving_softirq())

This has nothing to do with RT. Even on a non RT kernel force threaded
interrupts run obviously in thread context and therefore in_irq() returns
false when invoked from the handler.

The extension of the in_irq() check with !in_serving_softirq() was there
when the drivers were added, but in the out of tree FSL BSP the original
condition was in_irq() which got extended due to failures on RT.

The usage of in_xxx() in drivers is phased out and Linus clearly requested
that code which changes behaviour depending on context should either be
separated or the context be conveyed in an argument passed by the caller,
which usually knows the context. Right he is, the above construct is
clearly showing why.

The following callchains have been analyzed to end up in
dpaa_eth_napi_schedule():

qman_p_poll_dqrr()
  __poll_portal_fast()
    fq->cb.dqrr()
       dpaa_eth_napi_schedule()

portal_isr()
  __poll_portal_fast()
    fq->cb.dqrr()
       dpaa_eth_napi_schedule()

Both need to schedule NAPI.
The crypto part has another code path leading up to this:
  kill_fq()
     empty_retired_fq()
       qman_p_poll_dqrr()
         __poll_portal_fast()
            fq->cb.dqrr()
               dpaa_eth_napi_schedule()

kill_fq() is called from task context and ends up scheduling NAPI, but
that's pointless and an unintended side effect of the !in_serving_softirq()
check.

The code path:
  caam_qi_poll() -> qman_p_poll_dqrr()

is invoked from NAPI and I *assume* from crypto's NAPI device and not
from qbman's NAPI device. I *guess* it is okay to skip scheduling NAPI
(because this is what happens now) but could be changed if it is wrong
due to `budget' handling.

Add an argument to __poll_portal_fast() which is true if NAPI needs to be
scheduled. This requires propagating the value to the caller including
`qman_cb_dqrr' typedef which is used by the dpaa and the crypto driver.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Horia Geant=C4=83" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Herbert XS <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Madalin Bucur <madalin.bucur@nxp.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Li Yang <leoyang.li@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
---
 drivers/crypto/caam/qi.c                       |  3 ++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 12 ++++++++----
 drivers/soc/fsl/qbman/qman.c                   | 12 ++++++------
 drivers/soc/fsl/qbman/qman_test_api.c          |  6 ++++--
 drivers/soc/fsl/qbman/qman_test_stash.c        |  6 ++++--
 include/soc/fsl/qman.h                         |  3 ++-
 6 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index ec53528d82058..57f6ab6bfb56a 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -564,7 +564,8 @@ static int caam_qi_napi_schedule(struct qman_portal *p,=
 struct caam_napi *np)
=20
 static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(struct qman_portal *p,
 						    struct qman_fq *rsp_fq,
-						    const struct qm_dqrr_entry *dqrr)
+						    const struct qm_dqrr_entry *dqrr,
+						    bool sched_napi)
 {
 	struct caam_napi *caam_napi =3D raw_cpu_ptr(&pcpu_qipriv.caam_napi);
 	struct caam_drv_req *drv_req;
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index 06cc863f4dd63..98ead77c673e5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2316,7 +2316,8 @@ static inline int dpaa_eth_napi_schedule(struct dpaa_=
percpu_priv *percpu_priv,
=20
 static enum qman_cb_dqrr_result rx_error_dqrr(struct qman_portal *portal,
 					      struct qman_fq *fq,
-					      const struct qm_dqrr_entry *dq)
+					      const struct qm_dqrr_entry *dq,
+					      bool sched_napi)
 {
 	struct dpaa_fq *dpaa_fq =3D container_of(fq, struct dpaa_fq, fq_base);
 	struct dpaa_percpu_priv *percpu_priv;
@@ -2343,7 +2344,8 @@ static enum qman_cb_dqrr_result rx_error_dqrr(struct =
qman_portal *portal,
=20
 static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 						struct qman_fq *fq,
-						const struct qm_dqrr_entry *dq)
+						const struct qm_dqrr_entry *dq,
+						bool sched_napi)
 {
 	struct skb_shared_hwtstamps *shhwtstamps;
 	struct rtnl_link_stats64 *percpu_stats;
@@ -2460,7 +2462,8 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struc=
t qman_portal *portal,
=20
 static enum qman_cb_dqrr_result conf_error_dqrr(struct qman_portal *portal,
 						struct qman_fq *fq,
-						const struct qm_dqrr_entry *dq)
+						const struct qm_dqrr_entry *dq,
+						bool sched_napi)
 {
 	struct dpaa_percpu_priv *percpu_priv;
 	struct net_device *net_dev;
@@ -2481,7 +2484,8 @@ static enum qman_cb_dqrr_result conf_error_dqrr(struc=
t qman_portal *portal,
=20
 static enum qman_cb_dqrr_result conf_dflt_dqrr(struct qman_portal *portal,
 					       struct qman_fq *fq,
-					       const struct qm_dqrr_entry *dq)
+					       const struct qm_dqrr_entry *dq,
+					       bool sched_napi)
 {
 	struct dpaa_percpu_priv *percpu_priv;
 	struct net_device *net_dev;
diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index 9888a70618730..101def7dc73d4 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -1159,7 +1159,7 @@ static u32 fq_to_tag(struct qman_fq *fq)
=20
 static u32 __poll_portal_slow(struct qman_portal *p, u32 is);
 static inline unsigned int __poll_portal_fast(struct qman_portal *p,
-					unsigned int poll_limit);
+					unsigned int poll_limit, bool sched_napi);
 static void qm_congestion_task(struct work_struct *work);
 static void qm_mr_process_task(struct work_struct *work);
=20
@@ -1174,7 +1174,7 @@ static irqreturn_t portal_isr(int irq, void *ptr)
=20
 	/* DQRR-handling if it's interrupt-driven */
 	if (is & QM_PIRQ_DQRI) {
-		__poll_portal_fast(p, QMAN_POLL_LIMIT);
+		__poll_portal_fast(p, QMAN_POLL_LIMIT, true);
 		clear =3D QM_DQAVAIL_MASK | QM_PIRQ_DQRI;
 	}
 	/* Handling of anything else that's interrupt-driven */
@@ -1602,7 +1602,7 @@ static noinline void clear_vdqcr(struct qman_portal *=
p, struct qman_fq *fq)
  * user callbacks to call into any QMan API.
  */
 static inline unsigned int __poll_portal_fast(struct qman_portal *p,
-					unsigned int poll_limit)
+					unsigned int poll_limit, bool sched_napi)
 {
 	const struct qm_dqrr_entry *dq;
 	struct qman_fq *fq;
@@ -1636,7 +1636,7 @@ static inline unsigned int __poll_portal_fast(struct =
qman_portal *p,
 			 * and we don't want multiple if()s in the critical
 			 * path (SDQCR).
 			 */
-			res =3D fq->cb.dqrr(p, fq, dq);
+			res =3D fq->cb.dqrr(p, fq, dq, sched_napi);
 			if (res =3D=3D qman_cb_dqrr_stop)
 				break;
 			/* Check for VDQCR completion */
@@ -1646,7 +1646,7 @@ static inline unsigned int __poll_portal_fast(struct =
qman_portal *p,
 			/* SDQCR: context_b points to the FQ */
 			fq =3D tag_to_fq(be32_to_cpu(dq->context_b));
 			/* Now let the callback do its stuff */
-			res =3D fq->cb.dqrr(p, fq, dq);
+			res =3D fq->cb.dqrr(p, fq, dq, sched_napi);
 			/*
 			 * The callback can request that we exit without
 			 * consuming this entry nor advancing;
@@ -1753,7 +1753,7 @@ EXPORT_SYMBOL(qman_start_using_portal);
=20
 int qman_p_poll_dqrr(struct qman_portal *p, unsigned int limit)
 {
-	return __poll_portal_fast(p, limit);
+	return __poll_portal_fast(p, limit, false);
 }
 EXPORT_SYMBOL(qman_p_poll_dqrr);
=20
diff --git a/drivers/soc/fsl/qbman/qman_test_api.c b/drivers/soc/fsl/qbman/=
qman_test_api.c
index 7066b2f1467cc..28fbddc3c2048 100644
--- a/drivers/soc/fsl/qbman/qman_test_api.c
+++ b/drivers/soc/fsl/qbman/qman_test_api.c
@@ -45,7 +45,8 @@
=20
 static enum qman_cb_dqrr_result cb_dqrr(struct qman_portal *,
 					struct qman_fq *,
-					const struct qm_dqrr_entry *);
+					const struct qm_dqrr_entry *,
+					bool sched_napi);
 static void cb_ern(struct qman_portal *, struct qman_fq *,
 		   const union qm_mr_entry *);
 static void cb_fqs(struct qman_portal *, struct qman_fq *,
@@ -208,7 +209,8 @@ int qman_test_api(void)
=20
 static enum qman_cb_dqrr_result cb_dqrr(struct qman_portal *p,
 					struct qman_fq *fq,
-					const struct qm_dqrr_entry *dq)
+					const struct qm_dqrr_entry *dq,
+					bool sched_napi)
 {
 	if (WARN_ON(fd_neq(&fd_dq, &dq->fd))) {
 		pr_err("BADNESS: dequeued frame doesn't match;\n");
diff --git a/drivers/soc/fsl/qbman/qman_test_stash.c b/drivers/soc/fsl/qbma=
n/qman_test_stash.c
index e87b65403b672..b7e8e5ec884c6 100644
--- a/drivers/soc/fsl/qbman/qman_test_stash.c
+++ b/drivers/soc/fsl/qbman/qman_test_stash.c
@@ -275,7 +275,8 @@ static inline int process_frame_data(struct hp_handler =
*handler,
=20
 static enum qman_cb_dqrr_result normal_dqrr(struct qman_portal *portal,
 					    struct qman_fq *fq,
-					    const struct qm_dqrr_entry *dqrr)
+					    const struct qm_dqrr_entry *dqrr,
+					    bool sched_napi)
 {
 	struct hp_handler *handler =3D (struct hp_handler *)fq;
=20
@@ -293,7 +294,8 @@ static enum qman_cb_dqrr_result normal_dqrr(struct qman=
_portal *portal,
=20
 static enum qman_cb_dqrr_result special_dqrr(struct qman_portal *portal,
 					     struct qman_fq *fq,
-					     const struct qm_dqrr_entry *dqrr)
+					     const struct qm_dqrr_entry *dqrr,
+					     bool sched_napi)
 {
 	struct hp_handler *handler =3D (struct hp_handler *)fq;
=20
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 9f484113cfda7..59eeba31c1928 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -689,7 +689,8 @@ enum qman_cb_dqrr_result {
 };
 typedef enum qman_cb_dqrr_result (*qman_cb_dqrr)(struct qman_portal *qm,
 					struct qman_fq *fq,
-					const struct qm_dqrr_entry *dqrr);
+					const struct qm_dqrr_entry *dqrr,
+					bool sched_napi);
=20
 /*
  * This callback type is used when handling ERNs, FQRNs and FQRLs via MR. =
They
--=20
2.29.1

