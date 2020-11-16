Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE02B4AC8
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbgKPQVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:21:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:42138 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731791AbgKPQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:21:23 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PruUOlPfnj8E5tSIjr63DwXZAV48I0qrDxF2pgYMOa0=;
        b=B4moO4YlQKYcBzNpk6q6UVV7iTPyKXK3a7tnD9SIXTbYZXVwu8y3yGOY2523TkYhCOdUIt
        dIg0Eym0aX6E41ia9oSwH+dVZ3Pg//jg53+faq9Dyc6F4r7huVfSYu83W5JwRVFNVAl40U
        O/cm8u8yoxyHhXKl4+QNI5+L4LrBA3wbl7NsseVNCc5MMaCp1/b04skKdB1zNvAtPBEGKi
        6VAIFtjkzUy7g/xi9IrR0b20cXxxgNHMPTOL5azx3kUdiqtPMxgRdqe5bs5W5NxkCdUcyI
        4h7wlaBxR8Pblx0Su4CjvVHmPJY18GxHNhK650dL0hG/A+XdA538omx0gDnwLQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605543681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PruUOlPfnj8E5tSIjr63DwXZAV48I0qrDxF2pgYMOa0=;
        b=vz7XVscu4zH+dtG9j33pYZcQoH8zQmM1y0ftdMKp87elrLcoD9Mp2G6XT0rPoLQtgBZY1T
        /5rjpEiFwWybZ8Aw==
To:     linux-atm-general@lists.sourceforge.net
Cc:     Chas Williams <3chas3@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/3] atm: nicstar: Unmap DMA on send error
Date:   Mon, 16 Nov 2020 17:21:14 +0100
Message-Id: <20201116162117.387191-2-bigeasy@linutronix.de>
In-Reply-To: <20201116162117.387191-1-bigeasy@linutronix.de>
References: <20201116162117.387191-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `skb' is mapped for DMA in ns_send() but does not unmap DMA in case
push_scqe() fails to submit the `skb'. The memory of the `skb' is
released so only the DMA mapping is leaking.

Unmap the DMA mapping in case push_scqe() failed.

Fixes: 864a3ff635fa7 ("atm: [nicstar] remove virt_to_bus() and support 64-b=
it platforms")
Cc: Chas Williams <3chas3@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/atm/nicstar.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 7af74fb450a0d..09ad73361879e 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1706,6 +1706,8 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buf=
f *skb)
=20
 	if (push_scqe(card, vc, scq, &scqe, skb) !=3D 0) {
 		atomic_inc(&vcc->stats->tx_err);
+		dma_unmap_single(&card->pcidev->dev, NS_PRV_DMA(skb), skb->len,
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
--=20
2.29.2

