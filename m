Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03623307749
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 14:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhA1Nkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 08:40:45 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35086 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhA1Nkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 08:40:42 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611841198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7iPku8FkrZD5w8yVHKVvQ/1p38wFfeQpiMBPoKG6ITQ=;
        b=VMx5kyMqOTKRXqih8qjW3iADG3f3jsUlebElOj+7ycUQupk8mEKAhfuCDXzeFXHYapHip/
        IHP+gf7SMbihGDuGmuOVfQDJcLrNW+PK7WMJZ6EDf6aN7zwsI54VjAZC0Wu5VaoFYnqkgT
        4GYTyO4MJUmeDTI5LTHR8iTv/inGz6FxCzvF5HyueZ1gDX9taoEJbGYQ1xYsdrPpOSDkQB
        96nyu842aJmd8mYrIgmgP3bFbfJALLmO2OaFRsiu1A0/kLDbjlw+MDOljgLK52uZUqtqlK
        TvWwMYZDC/yCyiOmIYfANm5HZoBGtnLFzBPOSJI4QpNGk9CIOTtnxjBVQzZuBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611841198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7iPku8FkrZD5w8yVHKVvQ/1p38wFfeQpiMBPoKG6ITQ=;
        b=XS3ZlY0af3v82ZKMxmg/ZslTpcgQaNAX36+r/vu6ED8DBy0iI2J8PoacrsJFIgfv+xQEMA
        Ba9bgbNaJF/SlcAA==
To:     netdev@vger.kernel.org
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] net: arcnet: Fix RESET flag handling
Date:   Thu, 28 Jan 2021 14:39:36 +0100
Message-Id: <20210128133936.430842-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

The main arcnet interrupt handler calls arcnet_close() then
arcnet_open(), if the RESET status flag is encountered.

This is invalid:

  1) In general, interrupt handlers should never call ->ndo_stop() and
     ->ndo_open() functions. They are usually full of blocking calls and
     other methods that are expected to be called only from drivers
     init and exit code paths.

  2) arcnet_close() contains a del_timer_sync(). If the irq handler
     interrupts the to-be-deleted timer, del_timer_sync() will just loop
     forever.

  3) arcnet_close() also calls tasklet_kill(), which has a warning if
     called from irq context.

  4) For device reset, the sequence "arcnet_close(); arcnet_open();" is
     not complete.  Some children arcnet drivers have special init/exit
     code sequences, which then embed a call to arcnet_open() and
     arcnet_close() accordingly. Check drivers/net/arcnet/com20020.c.

Run the device RESET sequence from a scheduled workqueue instead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---

Repost as non-RFC. No hardware around, just review.

 drivers/net/arcnet/arc-rimi.c     |  4 +-
 drivers/net/arcnet/arcdevice.h    |  6 +++
 drivers/net/arcnet/arcnet.c       | 66 +++++++++++++++++++++++++++++--
 drivers/net/arcnet/com20020-isa.c |  4 +-
 drivers/net/arcnet/com20020-pci.c |  2 +-
 drivers/net/arcnet/com20020_cs.c  |  2 +-
 drivers/net/arcnet/com90io.c      |  4 +-
 drivers/net/arcnet/com90xx.c      |  4 +-
 8 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/drivers/net/arcnet/arc-rimi.c b/drivers/net/arcnet/arc-rimi.c
index 98df38fe553ce..12d085405bd05 100644
--- a/drivers/net/arcnet/arc-rimi.c
+++ b/drivers/net/arcnet/arc-rimi.c
@@ -332,7 +332,7 @@ static int __init arc_rimi_init(void)
 		dev->irq =3D 9;
=20
 	if (arcrimi_probe(dev)) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return -EIO;
 	}
=20
@@ -349,7 +349,7 @@ static void __exit arc_rimi_exit(void)
 	iounmap(lp->mem_start);
 	release_mem_region(dev->mem_start, dev->mem_end - dev->mem_start + 1);
 	free_irq(dev->irq, dev);
-	free_netdev(dev);
+	free_arcdev(dev);
 }
=20
 #ifndef MODULE
diff --git a/drivers/net/arcnet/arcdevice.h b/drivers/net/arcnet/arcdevice.h
index 22a49c6d7ae6e..5d4a4c7efbbff 100644
--- a/drivers/net/arcnet/arcdevice.h
+++ b/drivers/net/arcnet/arcdevice.h
@@ -298,6 +298,10 @@ struct arcnet_local {
=20
 	int excnak_pending;    /* We just got an excesive nak interrupt */
=20
+	/* RESET flag handling */
+	int reset_in_progress;
+	struct work_struct reset_work;
+
 	struct {
 		uint16_t sequence;	/* sequence number (incs with each packet) */
 		__be16 aborted_seq;
@@ -350,7 +354,9 @@ void arcnet_dump_skb(struct net_device *dev, struct sk_=
buff *skb, char *desc)
=20
 void arcnet_unregister_proto(struct ArcProto *proto);
 irqreturn_t arcnet_interrupt(int irq, void *dev_id);
+
 struct net_device *alloc_arcdev(const char *name);
+void free_arcdev(struct net_device *dev);
=20
 int arcnet_open(struct net_device *dev);
 int arcnet_close(struct net_device *dev);
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index e04efc0a5c977..d76dd7d14299e 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -387,10 +387,44 @@ static void arcnet_timer(struct timer_list *t)
 	struct arcnet_local *lp =3D from_timer(lp, t, timer);
 	struct net_device *dev =3D lp->dev;
=20
-	if (!netif_carrier_ok(dev)) {
+	spin_lock_irq(&lp->lock);
+
+	if (!lp->reset_in_progress && !netif_carrier_ok(dev)) {
 		netif_carrier_on(dev);
 		netdev_info(dev, "link up\n");
 	}
+
+	spin_unlock_irq(&lp->lock);
+}
+
+static void reset_device_work(struct work_struct *work)
+{
+	struct arcnet_local *lp;
+	struct net_device *dev;
+
+	lp =3D container_of(work, struct arcnet_local, reset_work);
+	dev =3D lp->dev;
+
+	/* Do not bring the network interface back up if an ifdown
+	 * was already done.
+	 */
+	if (!netif_running(dev) || !lp->reset_in_progress)
+		return;
+
+	rtnl_lock();
+
+	/* Do another check, in case of an ifdown that was triggered in
+	 * the small race window between the exit condition above and
+	 * acquiring RTNL.
+	 */
+	if (!netif_running(dev) || !lp->reset_in_progress)
+		goto out;
+
+	dev_close(dev);
+	dev_open(dev, NULL);
+
+out:
+	rtnl_unlock();
 }
=20
 static void arcnet_reply_tasklet(unsigned long data)
@@ -452,12 +486,25 @@ struct net_device *alloc_arcdev(const char *name)
 		lp->dev =3D dev;
 		spin_lock_init(&lp->lock);
 		timer_setup(&lp->timer, arcnet_timer, 0);
+		INIT_WORK(&lp->reset_work, reset_device_work);
 	}
=20
 	return dev;
 }
 EXPORT_SYMBOL(alloc_arcdev);
=20
+void free_arcdev(struct net_device *dev)
+{
+	struct arcnet_local *lp =3D netdev_priv(dev);
+
+	/* Do not cancel this at ->ndo_close(), as the workqueue itself
+	 * indirectly calls the ifdown path through dev_close().
+	 */
+	cancel_work_sync(&lp->reset_work);
+	free_netdev(dev);
+}
+EXPORT_SYMBOL(free_arcdev);
+
 /* Open/initialize the board.  This is called sometime after booting when
  * the 'ifconfig' program is run.
  *
@@ -587,6 +634,10 @@ int arcnet_close(struct net_device *dev)
=20
 	/* shut down the card */
 	lp->hw.close(dev);
+
+	/* reset counters */
+	lp->reset_in_progress =3D 0;
+
 	module_put(lp->hw.owner);
 	return 0;
 }
@@ -820,6 +871,9 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
=20
 	spin_lock_irqsave(&lp->lock, flags);
=20
+	if (lp->reset_in_progress)
+		goto out;
+
 	/* RESET flag was enabled - if device is not running, we must
 	 * clear it right away (but nothing else).
 	 */
@@ -852,11 +906,14 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 		if (status & RESETflag) {
 			arc_printk(D_NORMAL, dev, "spurious reset (status=3D%Xh)\n",
 				   status);
-			arcnet_close(dev);
-			arcnet_open(dev);
+
+			lp->reset_in_progress =3D 1;
+			netif_stop_queue(dev);
+			netif_carrier_off(dev);
+			schedule_work(&lp->reset_work);
=20
 			/* get out of the interrupt handler! */
-			break;
+			goto out;
 		}
 		/* RX is inhibited - we must have received something.
 		 * Prepare to receive into the next buffer.
@@ -1052,6 +1109,7 @@ irqreturn_t arcnet_interrupt(int irq, void *dev_id)
 	udelay(1);
 	lp->hw.intmask(dev, lp->intmask);
=20
+out:
 	spin_unlock_irqrestore(&lp->lock, flags);
 	return retval;
 }
diff --git a/drivers/net/arcnet/com20020-isa.c b/drivers/net/arcnet/com2002=
0-isa.c
index f983c4ce6b07f..b50d4c33d2a46 100644
--- a/drivers/net/arcnet/com20020-isa.c
+++ b/drivers/net/arcnet/com20020-isa.c
@@ -169,7 +169,7 @@ static int __init com20020_init(void)
 		dev->irq =3D 9;
=20
 	if (com20020isa_probe(dev)) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return -EIO;
 	}
=20
@@ -182,7 +182,7 @@ static void __exit com20020_exit(void)
 	unregister_netdev(my_dev);
 	free_irq(my_dev->irq, my_dev);
 	release_region(my_dev->base_addr, ARCNET_TOTAL_SIZE);
-	free_netdev(my_dev);
+	free_ardev(my_dev);
 }
=20
 #ifndef MODULE
diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com2002=
0-pci.c
index eb7f76753c9c0..8bdc44b7e09a1 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -291,7 +291,7 @@ static void com20020pci_remove(struct pci_dev *pdev)
=20
 		unregister_netdev(dev);
 		free_irq(dev->irq, dev);
-		free_netdev(dev);
+		free_arcdev(dev);
 	}
 }
=20
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020=
_cs.c
index 81223f6bebcc1..b88a109b3b150 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -177,7 +177,7 @@ static void com20020_detach(struct pcmcia_device *link)
 		dev =3D info->dev;
 		if (dev) {
 			dev_dbg(&link->dev, "kfree...\n");
-			free_netdev(dev);
+			free_arcdev(dev);
 		}
 		dev_dbg(&link->dev, "kfree2...\n");
 		kfree(info);
diff --git a/drivers/net/arcnet/com90io.c b/drivers/net/arcnet/com90io.c
index cf214b7306715..3856b447d38ed 100644
--- a/drivers/net/arcnet/com90io.c
+++ b/drivers/net/arcnet/com90io.c
@@ -396,7 +396,7 @@ static int __init com90io_init(void)
 	err =3D com90io_probe(dev);
=20
 	if (err) {
-		free_netdev(dev);
+		free_arcdev(dev);
 		return err;
 	}
=20
@@ -419,7 +419,7 @@ static void __exit com90io_exit(void)
=20
 	free_irq(dev->irq, dev);
 	release_region(dev->base_addr, ARCNET_TOTAL_SIZE);
-	free_netdev(dev);
+	free_arcdev(dev);
 }
=20
 module_init(com90io_init)
diff --git a/drivers/net/arcnet/com90xx.c b/drivers/net/arcnet/com90xx.c
index 3dc3d533cb19a..d8dfb9ea0de89 100644
--- a/drivers/net/arcnet/com90xx.c
+++ b/drivers/net/arcnet/com90xx.c
@@ -554,7 +554,7 @@ static int __init com90xx_found(int ioaddr, int airq, u=
_long shmem,
 err_release_mem:
 	release_mem_region(dev->mem_start, dev->mem_end - dev->mem_start + 1);
 err_free_dev:
-	free_netdev(dev);
+	free_arcdev(dev);
 	return -EIO;
 }
=20
@@ -672,7 +672,7 @@ static void __exit com90xx_exit(void)
 		release_region(dev->base_addr, ARCNET_TOTAL_SIZE);
 		release_mem_region(dev->mem_start,
 				   dev->mem_end - dev->mem_start + 1);
-		free_netdev(dev);
+		free_arcdev(dev);
 	}
 }
=20
--=20
2.30.0

