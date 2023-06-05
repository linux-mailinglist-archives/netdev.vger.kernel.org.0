Return-Path: <netdev+bounces-8211-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D8C572321D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBEBE2813D9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EAE271E5;
	Mon,  5 Jun 2023 21:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF96261FC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:20:37 +0000 (UTC)
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDE6F2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:20:35 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
	id A8A5B6992186; Mon,  5 Jun 2023 14:20:21 -0700 (PDT)
From: Stefan Roesch <shr@devkernel.io>
To: io-uring@vger.kernel.org,
	kernel-team@fb.com
Cc: shr@devkernel.io,
	axboe@kernel.dk,
	ammarfaizi2@gnuweeb.org,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	olivier@trillion01.com
Subject: [PATCH v14 1/8] net: split off __napi_busy_poll from napi_busy_poll
Date: Mon,  5 Jun 2023 14:20:02 -0700
Message-Id: <20230605212009.1992313-2-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230605212009.1992313-1-shr@devkernel.io>
References: <20230605212009.1992313-1-shr@devkernel.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
	SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This splits off the key part of the napi_busy_poll function into its own
function __napi_busy_poll. This is done in preparation for an additional
napi_busy_poll() function, that doesn't take the rcu_read_lock(). The
new function is introduced in the next patch.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 net/core/dev.c | 99 ++++++++++++++++++++++++++++----------------------
 1 file changed, 56 insertions(+), 43 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 253584777101..f4677aa20f84 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6166,66 +6166,79 @@ static void busy_poll_stop(struct napi_struct *na=
pi, void *have_poll_lock, bool
 	local_bh_enable();
 }
=20
+struct napi_busy_poll_ctx {
+	struct napi_struct *napi;
+	int (*napi_poll)(struct napi_struct *napi, int budget);
+	void *have_poll_lock;
+};
+
+static inline void __napi_busy_poll(struct napi_busy_poll_ctx *ctx,
+				    bool prefer_busy_poll, u16 budget)
+{
+	struct napi_struct *napi =3D ctx->napi;
+	int work =3D 0;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+
+	local_bh_disable();
+	if (!ctx->napi_poll) {
+		unsigned long val =3D READ_ONCE(napi->state);
+
+		/* If multiple threads are competing for this napi,
+		 * we avoid dirtying napi->state as much as we can.
+		 */
+		if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
+			   NAPIF_STATE_IN_BUSY_POLL)) {
+			if (prefer_busy_poll)
+				set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
+			goto count;
+		}
+		if (cmpxchg(&napi->state, val,
+			    val | NAPIF_STATE_IN_BUSY_POLL |
+				  NAPIF_STATE_SCHED) !=3D val) {
+			if (prefer_busy_poll)
+				set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
+			goto count;
+		}
+		ctx->have_poll_lock =3D netpoll_poll_lock(napi);
+		ctx->napi_poll =3D napi->poll;
+	}
+	work =3D ctx->napi_poll(napi, budget);
+	trace_napi_poll(napi, work, budget);
+	gro_normal_list(napi);
+
+count:
+	if (work > 0)
+		__NET_ADD_STATS(dev_net(napi->dev),
+				LINUX_MIB_BUSYPOLLRXPACKETS, work);
+	local_bh_enable();
+}
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
 {
 	unsigned long start_time =3D loop_end ? busy_loop_current_time() : 0;
-	int (*napi_poll)(struct napi_struct *napi, int budget);
-	void *have_poll_lock =3D NULL;
-	struct napi_struct *napi;
+	struct napi_busy_poll_ctx ctx =3D {};
=20
 restart:
-	napi_poll =3D NULL;
+	ctx.napi_poll =3D NULL;
=20
 	rcu_read_lock();
=20
-	napi =3D napi_by_id(napi_id);
-	if (!napi)
+	ctx.napi =3D napi_by_id(napi_id);
+	if (!ctx.napi)
 		goto out;
=20
 	preempt_disable();
 	for (;;) {
-		int work =3D 0;
-
-		local_bh_disable();
-		if (!napi_poll) {
-			unsigned long val =3D READ_ONCE(napi->state);
-
-			/* If multiple threads are competing for this napi,
-			 * we avoid dirtying napi->state as much as we can.
-			 */
-			if (val & (NAPIF_STATE_DISABLE | NAPIF_STATE_SCHED |
-				   NAPIF_STATE_IN_BUSY_POLL)) {
-				if (prefer_busy_poll)
-					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
-				goto count;
-			}
-			if (cmpxchg(&napi->state, val,
-				    val | NAPIF_STATE_IN_BUSY_POLL |
-					  NAPIF_STATE_SCHED) !=3D val) {
-				if (prefer_busy_poll)
-					set_bit(NAPI_STATE_PREFER_BUSY_POLL, &napi->state);
-				goto count;
-			}
-			have_poll_lock =3D netpoll_poll_lock(napi);
-			napi_poll =3D napi->poll;
-		}
-		work =3D napi_poll(napi, budget);
-		trace_napi_poll(napi, work, budget);
-		gro_normal_list(napi);
-count:
-		if (work > 0)
-			__NET_ADD_STATS(dev_net(napi->dev),
-					LINUX_MIB_BUSYPOLLRXPACKETS, work);
-		local_bh_enable();
+		__napi_busy_poll(&ctx, prefer_busy_poll, budget);
=20
 		if (!loop_end || loop_end(loop_end_arg, start_time))
 			break;
=20
 		if (unlikely(need_resched())) {
-			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
+			if (ctx.napi_poll)
+				busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budge=
t);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6235,8 +6248,8 @@ void napi_busy_loop(unsigned int napi_id,
 		}
 		cpu_relax();
 	}
-	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock, prefer_busy_poll, budget);
+	if (ctx.napi_poll)
+		busy_poll_stop(ctx.napi, ctx.have_poll_lock, prefer_busy_poll, budget)=
;
 	preempt_enable();
 out:
 	rcu_read_unlock();
--=20
2.39.1


