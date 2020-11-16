Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC192B4ACA
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgKPQV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731782AbgKPQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:21:23 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D5C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:21:23 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XdsPHV3mCyVzy7ZIKI8ieqE/6aF9GvT/f/X/zzyrUU=;
        b=bZxr/3gF/xqklWUwfR6uEB4uwDT4PzLnfLKKEk9/471wifaW7IQdUBQ5bUk6GaTQ1q+9zm
        3jypxJFMAXM2n9jQnfft2OiqeN71/+kykx4rltW2g9HJL6u506z6KuP7YKgMyTGRzynnr0
        CIn0zYZKy8dr0Ivy1CSCCoyj4NCgDRd4ZEQpXNgEzqAny8er0HIJwrPgE7zCk+i3VIft58
        puOSw7SZzW8cguQobBg2+KHcLg3sA7O3aG5GtF0wK49dGCRTwLHwYSgHJmZkEGTEvxowtr
        EY1G91yQvHH0Jm2+FUijtkrIiLZBVp10RZMuILQGvfW7YFFQW1L5h0/MnF4pvw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XdsPHV3mCyVzy7ZIKI8ieqE/6aF9GvT/f/X/zzyrUU=;
        b=0wC5VcswbHD8fF7TvOAyrQu/xz8cNKBsoWBs7tSwpaocz4jwRu7XKyvVtj7EmjJbp6zGRn
        pzgM70Gb95ZtrnDA==
To:     linux-atm-general@lists.sourceforge.net
Cc:     Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 2/3] atm: nicstar: Replace in_interrupt() usage
Date:   Mon, 16 Nov 2020 17:21:15 +0100
Message-Id: <20201116162117.387191-3-bigeasy@linutronix.de>
In-Reply-To: <20201116162117.387191-1-bigeasy@linutronix.de>
References: <20201116162117.387191-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

push_scqe() uses in_interrupt() to figure out if it is allowed to sleep.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by the
caller, which usually knows the context.

Aside of that in_interrupt() is not correct as it does not catch preempt
disabled regions which neither can sleep.

ns_send() (the only caller of push_scqe()) has the following callers:

- vcc_sendmsg() used as proto_ops::sendmsg is expected to be invoked in
  preemtible context.
  -> vcc->dev->ops->send() (ns_send())

- atm_vcc::send via atmdev_ops::send either directly (pointer copied by
  atm_init_aal34() or atm_init_aal5()) or via atm_send_aal0().
  This is invoked by drivers (like br2684, clip, pppoatm, ...) which are
  called from net_device_ops::ndo_start_xmit with BH disabled.

Add atmdev_ops::send_bh which is used by callers from BH context
(atm_send_aal*()) and if this callback missing then ::send is used
instead.
Implement this callback in nicstar and use it to replace in_interrupt().

Cc: netdev@vger.kernel.org
Cc: Chas Williams <3chas3@gmail.com>
CC: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/atm/nicstar.c  | 24 ++++++++++++++++++------
 include/linux/atmdev.h |  1 +
 net/atm/raw.c          | 12 ++++++++++--
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 09ad73361879e..5c7e4df159b91 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -130,8 +130,9 @@ static int ns_open(struct atm_vcc *vcc);
 static void ns_close(struct atm_vcc *vcc);
 static void fill_tst(ns_dev * card, int n, vc_map * vc);
 static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb);
+static int ns_send_bh(struct atm_vcc *vcc, struct sk_buff *skb);
 static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe *=
 tbd,
-		     struct sk_buff *skb);
+		     struct sk_buff *skb, bool may_sleep);
 static void process_tsq(ns_dev * card);
 static void drain_scq(ns_dev * card, scq_info * scq, int pos);
 static void process_rsq(ns_dev * card);
@@ -160,6 +161,7 @@ static const struct atmdev_ops atm_ops =3D {
 	.close =3D ns_close,
 	.ioctl =3D ns_ioctl,
 	.send =3D ns_send,
+	.send_bh =3D ns_send_bh,
 	.phy_put =3D ns_phy_put,
 	.phy_get =3D ns_phy_get,
 	.proc_read =3D ns_proc_read,
@@ -1620,7 +1622,7 @@ static void fill_tst(ns_dev * card, int n, vc_map * v=
c)
 	card->tst_addr =3D new_tst;
 }
=20
-static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
+static int _ns_send(struct atm_vcc *vcc, struct sk_buff *skb, bool may_sle=
ep)
 {
 	ns_dev *card;
 	vc_map *vc;
@@ -1704,7 +1706,7 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buf=
f *skb)
 		scq =3D card->scq0;
 	}
=20
-	if (push_scqe(card, vc, scq, &scqe, skb) !=3D 0) {
+	if (push_scqe(card, vc, scq, &scqe, skb, may_sleep) !=3D 0) {
 		atomic_inc(&vcc->stats->tx_err);
 		dma_unmap_single(&card->pcidev->dev, NS_PRV_DMA(skb), skb->len,
 				 DMA_TO_DEVICE);
@@ -1716,8 +1718,18 @@ static int ns_send(struct atm_vcc *vcc, struct sk_bu=
ff *skb)
 	return 0;
 }
=20
+static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
+{
+	return _ns_send(vcc, skb, true);
+}
+
+static int ns_send_bh(struct atm_vcc *vcc, struct sk_buff *skb)
+{
+	return _ns_send(vcc, skb, false);
+}
+
 static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe *=
 tbd,
-		     struct sk_buff *skb)
+		     struct sk_buff *skb, bool may_sleep)
 {
 	unsigned long flags;
 	ns_scqe tsr;
@@ -1728,7 +1740,7 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_=
info * scq, ns_scqe * tbd,
=20
 	spin_lock_irqsave(&scq->lock, flags);
 	while (scq->tail =3D=3D scq->next) {
-		if (in_interrupt()) {
+		if (!may_sleep) {
 			spin_unlock_irqrestore(&scq->lock, flags);
 			printk("nicstar%d: Error pushing TBD.\n", card->index);
 			return 1;
@@ -1773,7 +1785,7 @@ static int push_scqe(ns_dev * card, vc_map * vc, scq_=
info * scq, ns_scqe * tbd,
 		int has_run =3D 0;
=20
 		while (scq->tail =3D=3D scq->next) {
-			if (in_interrupt()) {
+			if (!may_sleep) {
 				data =3D scq_virt_to_bus(scq, scq->next);
 				ns_write_sram(card, scq->scd, &data, 1);
 				spin_unlock_irqrestore(&scq->lock, flags);
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index 5d5ff2203fa22..d7493016cd466 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -186,6 +186,7 @@ struct atmdev_ops { /* only send is required */
 			    void __user *arg);
 #endif
 	int (*send)(struct atm_vcc *vcc,struct sk_buff *skb);
+	int (*send_bh)(struct atm_vcc *vcc, struct sk_buff *skb);
 	int (*send_oam)(struct atm_vcc *vcc,void *cell,int flags);
 	void (*phy_put)(struct atm_dev *dev,unsigned char value,
 	    unsigned long addr);
diff --git a/net/atm/raw.c b/net/atm/raw.c
index b3ba44aab0ee6..2b5f78a7ec3e4 100644
--- a/net/atm/raw.c
+++ b/net/atm/raw.c
@@ -54,6 +54,8 @@ static int atm_send_aal0(struct atm_vcc *vcc, struct sk_b=
uff *skb)
 		kfree_skb(skb);
 		return -EADDRNOTAVAIL;
 	}
+	if (vcc->dev->ops->send_bh)
+		return vcc->dev->ops->send_bh(vcc, skb);
 	return vcc->dev->ops->send(vcc, skb);
 }
=20
@@ -71,7 +73,10 @@ int atm_init_aal34(struct atm_vcc *vcc)
 	vcc->push =3D atm_push_raw;
 	vcc->pop =3D atm_pop_raw;
 	vcc->push_oam =3D NULL;
-	vcc->send =3D vcc->dev->ops->send;
+	if (vcc->dev->ops->send_bh)
+		vcc->send =3D vcc->dev->ops->send_bh;
+	else
+		vcc->send =3D vcc->dev->ops->send;
 	return 0;
 }
=20
@@ -80,7 +85,10 @@ int atm_init_aal5(struct atm_vcc *vcc)
 	vcc->push =3D atm_push_raw;
 	vcc->pop =3D atm_pop_raw;
 	vcc->push_oam =3D NULL;
-	vcc->send =3D vcc->dev->ops->send;
+	if (vcc->dev->ops->send_bh)
+		vcc->send =3D vcc->dev->ops->send_bh;
+	else
+		vcc->send =3D vcc->dev->ops->send;
 	return 0;
 }
 EXPORT_SYMBOL(atm_init_aal5);
--=20
2.29.2

