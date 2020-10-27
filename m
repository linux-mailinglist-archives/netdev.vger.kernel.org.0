Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9096D29CC5D
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832615AbgJ0W4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:56:31 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50198 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1832548AbgJ0W4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:56:00 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjmStdTYpXx0Q5cgHBNYgoGt1xQMDGvpBhIAE5x62bo=;
        b=IrVDFjU5wiUh3/1b+EWqAdpLz9jEaa0feaxAB0seewu3KP62xQWrIDIDRFVfJR88akb5V8
        pixqewfSpPphy6wjIpk84kuwnoRmYibI+WPGXbSjRtkxqKuGHv479c5O+07RtRHzWP9EyO
        /XS2O6gq02ndIa9jvIju3YeZBwPe7jdNPpcZYA5f5c/yCRKzmmvrHi/lomT6/LJwNTuzDq
        79tALLYTDN3HvBlJ21WplNePz/PcB96jD/urLc/mb0VXNxgXdrKoOYIKtApY4oS3NuMRJx
        udPmRn5otfroi+DJXX7goaPxUdhrmyFNBJYKUfaap+PqN/QIS+Vy6OoaWTLFrw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjmStdTYpXx0Q5cgHBNYgoGt1xQMDGvpBhIAE5x62bo=;
        b=1hcOJSQqWKvZ0z3m9yg8HSR6q16whMj9tbVFBVxwm9sIAnvgysjdR0EPOnpijehHN6jTXv
        eMzOMmrlvWnhypDQ==
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
Subject: [PATCH net-next 10/15] net: zd1211rw: Remove in_atomic() usage.
Date:   Tue, 27 Oct 2020 23:54:49 +0100
Message-Id: <20201027225454.3492351-11-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage of in_atomic() in driver code is deprecated as it can not
always detect all states where it is not allowed to sleep.

All callers are in premptible thread context and all functions invoke core
functions which have checks for invalid calling contexts already.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wir=
eless/zydas/zd1211rw/zd_usb.c
index 66367ab7e4c1e..5c4cd0e1adebb 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1711,11 +1711,6 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 			 count, USB_MAX_IOREAD16_COUNT);
 		return -EINVAL;
 	}
-	if (in_atomic()) {
-		dev_dbg_f(zd_usb_dev(usb),
-			 "error: io in atomic context not supported\n");
-		return -EWOULDBLOCK;
-	}
 	if (!usb_int_enabled(usb)) {
 		dev_dbg_f(zd_usb_dev(usb),
 			  "error: usb interrupt not enabled\n");
@@ -1882,11 +1877,6 @@ int zd_usb_iowrite16v_async(struct zd_usb *usb, cons=
t struct zd_ioreq16 *ioreqs,
 			count, USB_MAX_IOWRITE16_COUNT);
 		return -EINVAL;
 	}
-	if (in_atomic()) {
-		dev_dbg_f(zd_usb_dev(usb),
-			"error: io in atomic context not supported\n");
-		return -EWOULDBLOCK;
-	}
=20
 	udev =3D zd_usb_to_usbdev(usb);
=20
@@ -1966,11 +1956,6 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8=
 bits)
 	int i, req_len, actual_req_len;
 	u16 bit_value_template;
=20
-	if (in_atomic()) {
-		dev_dbg_f(zd_usb_dev(usb),
-			"error: io in atomic context not supported\n");
-		return -EWOULDBLOCK;
-	}
 	if (bits < USB_MIN_RFWRITE_BIT_COUNT) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"error: bits %d are smaller than"
--=20
2.28.0

