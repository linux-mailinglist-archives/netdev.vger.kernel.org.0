Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA09529CC38
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793735AbgJ0Wzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49870 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374977AbgJ0Wzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:31 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4e1jj7WEPocePjy6Hywu9Wq8qr5VByL3erxk5CNuaA=;
        b=3FiB4+F2Ct0QcIJOw0tfFlETx8PA8cgs958H2wTMHeIYNJ0RRxXGs6tAH11rNFnAQDRqXv
        DiV3e6ZVQjCp2kVh+2lqXgAnbKEsoByqjy4HPuMPpPBT+xCjx48lfoOPYGXyL0DGxE5kdj
        Pt8LZvzDp0EniVd+Vjb8qp4JtRGjXpvJNPJfY2HwJvxfIpKTEmy0caMxpZMx7FCNsI/+bq
        gTGW0uTlWOJqLxt/aDjI84arJJ44P90+8mLVO0Hqe1ps2OAY0MlpASYJOeMb8RZ3lPetwz
        PS86UoN0H14FK5bv+UVykEyZ+2DxHYCHpB6sea87Jg4b4sskoPBvobapEA047Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F4e1jj7WEPocePjy6Hywu9Wq8qr5VByL3erxk5CNuaA=;
        b=rv75+kugraFffbq7nLw3mAS8i1Mg3dMERU51OgwfdltVGaW1rfmkPNdjlHkVLTVjhar4Ts
        4Kor9NM6UXqalcDw==
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
Subject: [PATCH net-next 01/15] net: orinoco: Remove BUG_ON(in_interrupt/irq())
Date:   Tue, 27 Oct 2020 23:54:40 +0100
Message-Id: <20201027225454.3492351-2-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usage of in_irq()/in_interrupt() in drivers is phased out and the
BUG_ON()'s based on those are not covering all contexts in which these
functions cannot be called.

Aside of that BUG_ON() should only be used as last resort, which is clearly
not the case here.

A broad variety of checks in the invoked functions (always enabled or debug
option dependent) cover these conditions already, so the BUG_ON()'s do not
really provide additional value.

Just remove them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/=
net/wireless/intersil/orinoco/orinoco_usb.c
index b849d27bd741e..046f2453ad5d9 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -859,8 +859,6 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	int retval =3D 0;
 	enum ezusb_state state;
=20
-	BUG_ON(in_irq());
-
 	if (!upriv->udev) {
 		retval =3D -ENODEV;
 		goto exit;
@@ -1349,7 +1347,6 @@ static int ezusb_init(struct hermes *hw)
 	struct ezusb_priv *upriv =3D hw->priv;
 	int retval;
=20
-	BUG_ON(in_interrupt());
 	if (!upriv)
 		return -EINVAL;
=20
@@ -1448,7 +1445,6 @@ static inline void ezusb_delete(struct ezusb_priv *up=
riv)
 	struct list_head *tmp_item;
 	unsigned long flags;
=20
-	BUG_ON(in_interrupt());
 	BUG_ON(!upriv);
=20
 	mutex_lock(&upriv->mtx);
--=20
2.28.0

