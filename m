Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B342D29CC45
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 23:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832542AbgJ0Wz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 18:55:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50018 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1795116AbgJ0Wzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 18:55:53 -0400
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603839350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRUacw3Bc7beEyn3i5nkNjBTNGCFptcuD9rU8qmYaPs=;
        b=bUBIMaq+5g117Vna+uU5FsYVLRKwfXrZMdL6Dww76JU4Tp01mYahr9O9Ayv3jxTrDze8FP
        RZIS4wAem0B/yoOxJEGFqmsv7plaMurrt5k0X+tVU6TNRsgZNdCbpGqjG5lAFzzKcn91sg
        w4LpdZ9wUqLsoLjUKqvLD2tkZec/QI+TWgm/G8S3PfJHQo5pVHZziHS78c5WOd3aqj3+sx
        zxZDi+gg/l1ko9GFarBY4+1VrgfBXIIxMVxPjJM2KsqpGIJGcM1XXKQjdtiip5rvmqIbch
        iEQ6li1cikA2h9wRa0UxavXNoJCNfI8QHpX0VjZgHwX2hFZ7JfWcaiLi/iHCnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603839350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bRUacw3Bc7beEyn3i5nkNjBTNGCFptcuD9rU8qmYaPs=;
        b=Cgb/QtXNKviGBg73QZnIeZQ1gqwTyx4EwiIyoivLRnvuq3kETK3qzlLQjmbEHhXNNGLydO
        OZAkZaOYrNZBaBAg==
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
Subject: [PATCH net-next 05/15] net: tlan: Replace in_irq() usage
Date:   Tue, 27 Oct 2020 23:54:44 +0100
Message-Id: <20201027225454.3492351-6-bigeasy@linutronix.de>
In-Reply-To: <20201027225454.3492351-1-bigeasy@linutronix.de>
References: <20201027225454.3492351-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses in_irq() to determine if the tlan_priv::lock has to be
acquired in tlan_mii_read_reg() and tlan_mii_write_reg().

The interrupt handler acquires the lock outside of these functions so the
in_irq() check is meant to prevent a lock recursion deadlock. But this
check is incorrect when interrupt force threading is enabled because then
the handler runs in thread context and in_irq() correctly returns false.

The usage of in_*() in drivers is phased out and Linus clearly requested
that code which changes behaviour depending on context should either be
seperated or the context be conveyed in an argument passed by the caller,
which usually knows the context.

tlan_set_timer() has this conditional as well, but this function is only
invoked from task context or the timer callback itself. So it always has to
lock and the check can be removed.

tlan_mii_read_reg(), tlan_mii_write_reg() and tlan_phy_print() are invoked
from interrupt and other contexts.

Split out the actual function body into helper variants which are called
from interrupt context and make the original functions wrappers which
acquire tlan_priv::lock unconditionally.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Samuel Chessman <chessman@tux.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/ti/tlan.c | 98 ++++++++++++++++++++--------------
 1 file changed, 57 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 267c080ee084b..0b2ce4bdc2c3d 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -186,6 +186,7 @@ static void	tlan_reset_adapter(struct net_device *);
 static void	tlan_finish_reset(struct net_device *);
 static void	tlan_set_mac(struct net_device *, int areg, char *mac);
=20
+static void	__tlan_phy_print(struct net_device *);
 static void	tlan_phy_print(struct net_device *);
 static void	tlan_phy_detect(struct net_device *);
 static void	tlan_phy_power_down(struct net_device *);
@@ -201,9 +202,11 @@ static void	tlan_phy_finish_auto_neg(struct net_device=
 *);
   static int	tlan_phy_dp83840a_check(struct net_device *);
 */
=20
-static bool	tlan_mii_read_reg(struct net_device *, u16, u16, u16 *);
+static bool	__tlan_mii_read_reg(struct net_device *, u16, u16, u16 *);
+static void	tlan_mii_read_reg(struct net_device *, u16, u16, u16 *);
 static void	tlan_mii_send_data(u16, u32, unsigned);
 static void	tlan_mii_sync(u16);
+static void	__tlan_mii_write_reg(struct net_device *, u16, u16, u16);
 static void	tlan_mii_write_reg(struct net_device *, u16, u16, u16);
=20
 static void	tlan_ee_send_start(u16);
@@ -242,23 +245,20 @@ static u32
 	tlan_handle_rx_eoc
 };
=20
-static inline void
+static void
 tlan_set_timer(struct net_device *dev, u32 ticks, u32 type)
 {
 	struct tlan_priv *priv =3D netdev_priv(dev);
 	unsigned long flags =3D 0;
=20
-	if (!in_irq())
-		spin_lock_irqsave(&priv->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->timer.function !=3D NULL &&
 	    priv->timer_type !=3D TLAN_TIMER_ACTIVITY) {
-		if (!in_irq())
-			spin_unlock_irqrestore(&priv->lock, flags);
+		spin_unlock_irqrestore(&priv->lock, flags);
 		return;
 	}
 	priv->timer.function =3D tlan_timer;
-	if (!in_irq())
-		spin_unlock_irqrestore(&priv->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
=20
 	priv->timer_set_at =3D jiffies;
 	priv->timer_type =3D type;
@@ -1703,22 +1703,22 @@ static u32 tlan_handle_status_check(struct net_devi=
ce *dev, u16 host_int)
 				 dev->name, (unsigned) net_sts);
 		}
 		if ((net_sts & TLAN_NET_STS_MIRQ) &&  (priv->phy_num =3D=3D 0)) {
-			tlan_mii_read_reg(dev, phy, TLAN_TLPHY_STS, &tlphy_sts);
-			tlan_mii_read_reg(dev, phy, TLAN_TLPHY_CTL, &tlphy_ctl);
+			__tlan_mii_read_reg(dev, phy, TLAN_TLPHY_STS, &tlphy_sts);
+			__tlan_mii_read_reg(dev, phy, TLAN_TLPHY_CTL, &tlphy_ctl);
 			if (!(tlphy_sts & TLAN_TS_POLOK) &&
 			    !(tlphy_ctl & TLAN_TC_SWAPOL)) {
 				tlphy_ctl |=3D TLAN_TC_SWAPOL;
-				tlan_mii_write_reg(dev, phy, TLAN_TLPHY_CTL,
-						   tlphy_ctl);
+				__tlan_mii_write_reg(dev, phy, TLAN_TLPHY_CTL,
+						     tlphy_ctl);
 			} else if ((tlphy_sts & TLAN_TS_POLOK) &&
 				   (tlphy_ctl & TLAN_TC_SWAPOL)) {
 				tlphy_ctl &=3D ~TLAN_TC_SWAPOL;
-				tlan_mii_write_reg(dev, phy, TLAN_TLPHY_CTL,
-						   tlphy_ctl);
+				__tlan_mii_write_reg(dev, phy, TLAN_TLPHY_CTL,
+						     tlphy_ctl);
 			}
=20
 			if (debug)
-				tlan_phy_print(dev);
+				__tlan_phy_print(dev);
 		}
 	}
=20
@@ -2379,7 +2379,7 @@ ThunderLAN driver PHY layer routines
=20
=20
 /*********************************************************************
- *	tlan_phy_print
+ *	__tlan_phy_print
  *
  *	Returns:
  *		Nothing
@@ -2391,11 +2391,13 @@ ThunderLAN driver PHY layer routines
  *
  ********************************************************************/
=20
-static void tlan_phy_print(struct net_device *dev)
+static void __tlan_phy_print(struct net_device *dev)
 {
 	struct tlan_priv *priv =3D netdev_priv(dev);
 	u16 i, data0, data1, data2, data3, phy;
=20
+	lockdep_assert_held(&priv->lock);
+
 	phy =3D priv->phy[priv->phy_num];
=20
 	if (priv->adapter->flags & TLAN_ADAPTER_UNMANAGED_PHY) {
@@ -2404,10 +2406,10 @@ static void tlan_phy_print(struct net_device *dev)
 		netdev_info(dev, "PHY 0x%02x\n", phy);
 		pr_info("   Off.  +0     +1     +2     +3\n");
 		for (i =3D 0; i < 0x20; i +=3D 4) {
-			tlan_mii_read_reg(dev, phy, i, &data0);
-			tlan_mii_read_reg(dev, phy, i + 1, &data1);
-			tlan_mii_read_reg(dev, phy, i + 2, &data2);
-			tlan_mii_read_reg(dev, phy, i + 3, &data3);
+			__tlan_mii_read_reg(dev, phy, i, &data0);
+			__tlan_mii_read_reg(dev, phy, i + 1, &data1);
+			__tlan_mii_read_reg(dev, phy, i + 2, &data2);
+			__tlan_mii_read_reg(dev, phy, i + 3, &data3);
 			pr_info("   0x%02x 0x%04hx 0x%04hx 0x%04hx 0x%04hx\n",
 				i, data0, data1, data2, data3);
 		}
@@ -2417,7 +2419,15 @@ static void tlan_phy_print(struct net_device *dev)
=20
 }
=20
+static void tlan_phy_print(struct net_device *dev)
+{
+	struct tlan_priv *priv =3D netdev_priv(dev);
+	unsigned long flags;
=20
+	spin_lock_irqsave(&priv->lock, flags);
+	__tlan_phy_print(dev);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
=20
=20
 /*********************************************************************
@@ -2795,7 +2805,7 @@ these routines are based on the information in chap. =
2 of the
=20
=20
 /***************************************************************
- *	tlan_mii_read_reg
+ *	__tlan_mii_read_reg
  *
  *	Returns:
  *		false	if ack received ok
@@ -2819,7 +2829,7 @@ these routines are based on the information in chap. =
2 of the
  **************************************************************/
=20
 static bool
-tlan_mii_read_reg(struct net_device *dev, u16 phy, u16 reg, u16 *val)
+__tlan_mii_read_reg(struct net_device *dev, u16 phy, u16 reg, u16 *val)
 {
 	u8	nack;
 	u16	sio, tmp;
@@ -2827,15 +2837,13 @@ tlan_mii_read_reg(struct net_device *dev, u16 phy, =
u16 reg, u16 *val)
 	bool	err;
 	int	minten;
 	struct tlan_priv *priv =3D netdev_priv(dev);
-	unsigned long flags =3D 0;
+
+	lockdep_assert_held(&priv->lock);
=20
 	err =3D false;
 	outw(TLAN_NET_SIO, dev->base_addr + TLAN_DIO_ADR);
 	sio =3D dev->base_addr + TLAN_DIO_DATA + TLAN_NET_SIO;
=20
-	if (!in_irq())
-		spin_lock_irqsave(&priv->lock, flags);
-
 	tlan_mii_sync(dev->base_addr);
=20
 	minten =3D tlan_get_bit(TLAN_NET_SIO_MINTEN, sio);
@@ -2881,15 +2889,19 @@ tlan_mii_read_reg(struct net_device *dev, u16 phy, =
u16 reg, u16 *val)
=20
 	*val =3D tmp;
=20
-	if (!in_irq())
-		spin_unlock_irqrestore(&priv->lock, flags);
-
 	return err;
-
 }
=20
+static void tlan_mii_read_reg(struct net_device *dev, u16 phy, u16 reg,
+			      u16 *val)
+{
+	struct tlan_priv *priv =3D netdev_priv(dev);
+	unsigned long flags;
=20
-
+	spin_lock_irqsave(&priv->lock, flags);
+	__tlan_mii_read_reg(dev, phy, reg, val);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
=20
 /***************************************************************
  *	tlan_mii_send_data
@@ -2971,7 +2983,7 @@ static void tlan_mii_sync(u16 base_port)
=20
=20
 /***************************************************************
- *	tlan_mii_write_reg
+ *	__tlan_mii_write_reg
  *
  *	Returns:
  *		Nothing
@@ -2991,19 +3003,17 @@ static void tlan_mii_sync(u16 base_port)
  **************************************************************/
=20
 static void
-tlan_mii_write_reg(struct net_device *dev, u16 phy, u16 reg, u16 val)
+__tlan_mii_write_reg(struct net_device *dev, u16 phy, u16 reg, u16 val)
 {
 	u16	sio;
 	int	minten;
-	unsigned long flags =3D 0;
 	struct tlan_priv *priv =3D netdev_priv(dev);
=20
+	lockdep_assert_held(&priv->lock);
+
 	outw(TLAN_NET_SIO, dev->base_addr + TLAN_DIO_ADR);
 	sio =3D dev->base_addr + TLAN_DIO_DATA + TLAN_NET_SIO;
=20
-	if (!in_irq())
-		spin_lock_irqsave(&priv->lock, flags);
-
 	tlan_mii_sync(dev->base_addr);
=20
 	minten =3D tlan_get_bit(TLAN_NET_SIO_MINTEN, sio);
@@ -3024,12 +3034,18 @@ tlan_mii_write_reg(struct net_device *dev, u16 phy,=
 u16 reg, u16 val)
 	if (minten)
 		tlan_set_bit(TLAN_NET_SIO_MINTEN, sio);
=20
-	if (!in_irq())
-		spin_unlock_irqrestore(&priv->lock, flags);
-
 }
=20
+static void
+tlan_mii_write_reg(struct net_device *dev, u16 phy, u16 reg, u16 val)
+{
+	struct tlan_priv *priv =3D netdev_priv(dev);
+	unsigned long flags;
=20
+	spin_lock_irqsave(&priv->lock, flags);
+	__tlan_mii_write_reg(dev, phy, reg, val);
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
=20
=20
 /*************************************************************************=
****
--=20
2.28.0

