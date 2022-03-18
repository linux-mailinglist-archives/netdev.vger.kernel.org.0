Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAE84DD88B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiCRK6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235031AbiCRK6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:58:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB862D63A6
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:57:23 -0700 (PDT)
Date:   Fri, 18 Mar 2022 11:57:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1647601041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzfBFv+r9Nrw67XmKkIpnDLsIj/eqZlhT35uttZlGPw=;
        b=pX3Lnzvy8q2DIBIWhPEHGpynf9x30MP5+eGirk7IgEXZhdcT5wH12Xw2DWarjTHmwQ+/pz
        pzhuRfeWvsjP8xPYMCMSD0hsJMkZ+XGpwmT5eQJZLp7JqNsRtUmQCo+2XN7pJ1zR7j29wX
        bbPFyRaqAs1+LNviftNCcR+ShMmYYTmLqvbAA+bpQZej52hxntCFsNkqFAvElVb4QnErjq
        ADhjv0iJLUpl1+wM9Gg65JnD38hrZtvhmxtTwJ7L2+Fg/5LM63ykxF/s9J2rcFV9IKjxdW
        d/yyr44cgwVle1AkcTIzNUzIQu/KISmA33iEu2WUp2nOVdcQAtcbf4GsErYaOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1647601041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzfBFv+r9Nrw67XmKkIpnDLsIj/eqZlhT35uttZlGPw=;
        b=c/ui7fFWKneRzwT7OoDKzRt/vijJ1H27xVWfQzLWhu8w/SktyNUGCWCC9V+AgNDESV5YUL
        xL1uwJ3jr3om7nAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, toke@redhat.com
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
Message-ID: <YjRlkBYBGEolfzd9@linutronix.de>
References: <YitkzkjU5zng7jAM@linutronix.de>
 <YjPlAyly8FQhPJjT@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YjPlAyly8FQhPJjT@zx2c4.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-17 19:48:51 [-0600], Jason A. Donenfeld wrote:
> Hi Sebastian,
Hi Jason,

> I stumbled upon this commit when noticing a new failure in WireGuard's
> test suite:
=E2=80=A6
> [    1.339289] WARNING: CPU: 0 PID: 11 at ../../../../../../../../net/cor=
e/dev.c:4268 __napi_schedule+0xa1/0x300
=E2=80=A6
> [    1.352417]  wg_packet_decrypt_worker+0x2ac/0x470
=E2=80=A6
> Sounds like wg_packet_decrypt_worker() might be doing something wrong? I
> vaguely recall a thread where you started looking into some things there
> that seemed non-optimal, but I didn't realize there were correctness
> issues. If your patch is correct, and wg_packet_decrypt_worker() is
> wrong, do you have a concrete idea of how we should approach fixing
> wireguard? Or do you want to send a patch for that?

In your case it is "okay" since that ptr_ring_consume_bh() will do BH
disable/enable which forces the softirq to run. It is not obvious. What
about the following:

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receiv=
e.c
index 7b8df406c7737..26ffa3afa542e 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -502,15 +502,21 @@ void wg_packet_decrypt_worker(struct work_struct *wor=
k)
 	struct crypt_queue *queue =3D container_of(work, struct multicore_worker,
 						 work)->ptr;
 	struct sk_buff *skb;
+	unsigned int packets =3D 0;
=20
-	while ((skb =3D ptr_ring_consume_bh(&queue->ring)) !=3D NULL) {
+	local_bh_disable();
+	while ((skb =3D ptr_ring_consume(&queue->ring)) !=3D NULL) {
 		enum packet_state state =3D
 			likely(decrypt_packet(skb, PACKET_CB(skb)->keypair)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_rx(skb, state);
-		if (need_resched())
+		if (!(++packets % 4)) {
+			local_bh_enable();
 			cond_resched();
+			local_bh_disable();
+		}
 	}
+	local_bh_enable();
 }
=20
 static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff *s=
kb)

It would decrypt 4 packets in a row and then after local_bh_enable() it
would invoke wg_packet_rx_poll() (assuming since it is the only napi
handler in wireguard) and after that it will attempt cond_resched() and
then continue with the next batch.

> Jason

Sebastian
