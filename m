Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F6129CC48
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832561AbgJ0W4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:56:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50078 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832543AbgJ0Wz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:58 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ecxJzZtRribDKzKIiwElpzea91WJXQDRkjrSNkyvp44=;
        b=bMHlhlluCx8UyhuU9NTXFEBFBDPzmifO9O7nsSBrqtLd+vr4IXh9AiD/7K0zGUjEiHeczw
        11cc4w8mxNiAF8ibzLraKYfn9RPhxYf4MtwYhVbwMuDsFMoxLHA/DSgHVzUj4DyGyD3vPW
        E2tipXy7jDjfZE0npmPtMrXPiWTv01kHZhkmvY8bq7w3Z8ZeikEww4mvYZCUOYPqraVy1S
        gwdqr3G3BB9h9qxhCr8fJdTDRs1LYzp2vzKChp8W4yBFl2siku3YD3x2aLGnerVg7aNO60
        y45jk/Re/uruKE8kGCYWFbVhlc7ZjQL3Dk63LQoOdWHzf+Ni6Jkp2iVd0fOseQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ecxJzZtRribDKzKIiwElpzea91WJXQDRkjrSNkyvp44=;
        b=F+okaaPlS1iKiuSjJd/s7xvfHx4naujCeq35xuq8TIJfx0CUcb4GntS5xPg3EjWk1mcjb2
        f+BuFsDmP7NUaeAg==
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
Subject: [PATCH net-next 09/15] net: hostap: Remove in_atomic() check.
Date:   Tue, 27 Oct 2020 23:54:48 +0100
Message-Id: <20201027225454.3492351-10-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hostap_get_wireless_stats() is the iw_handler_if::get_wireless_stats()
callback of this driver. This callback was not allowed to sleep until
commit a160ee69c6a46 ("wext: let get_wireless_stats() sleep") in v2.6.32.

Remove the therefore pointless in_atomic() check.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/intersil/hostap/hostap_ioctl.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/=
net/wireless/intersil/hostap/hostap_ioctl.c
index 514c7b01dbf6f..49766b285230c 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -44,19 +44,8 @@ static struct iw_statistics *hostap_get_wireless_stats(s=
truct net_device *dev)
=20
 	if (local->iw_mode !=3D IW_MODE_MASTER &&
 	    local->iw_mode !=3D IW_MODE_REPEAT) {
-		int update =3D 1;
-#ifdef in_atomic
-		/* RID reading might sleep and it must not be called in
-		 * interrupt context or while atomic. However, this
-		 * function seems to be called while atomic (at least in Linux
-		 * 2.5.59). Update signal quality values only if in suitable
-		 * context. Otherwise, previous values read from tick timer
-		 * will be used. */
-		if (in_atomic())
-			update =3D 0;
-#endif /* in_atomic */
=20
-		if (update && prism2_update_comms_qual(dev) =3D=3D 0)
+		if (prism2_update_comms_qual(dev) =3D=3D 0)
 			wstats->qual.updated =3D IW_QUAL_ALL_UPDATED |
 				IW_QUAL_DBM;
=20
--=20
2.28.0

