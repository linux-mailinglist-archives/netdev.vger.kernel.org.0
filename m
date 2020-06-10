Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D6B1F4F68
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgFJHp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbgFJHpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:45:16 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F130C03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:45:15 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d8so632006plo.12
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s8w+cXn0Jb29Ftkb7WcWynQaPBBugviXzJo6qIddcD0=;
        b=wGZiDY+tb55B4l8Q+ML50+mfazcvyKsKG65z2oB3Wry1Kbnowhf3zHM8fE9WSRq7bD
         VSmiBZN/6EJ+XhcI73O9C3+9N0g7QY8r/pjzA3Ayj3F0h8pyWY2nNCwQ3hjCfao8mocb
         p9wFDclEhe86irQJgkoZ1ZJDpH/bHdNumK6tO1AnfBydocyAVzY38PkE6DYTeflY1SNq
         ICri7PK8t4IkfaGO4LSLjZ45C6pPy9wo2jxgnRSeKYfrT0oz23KHTlWRDdPjFeB29iBb
         c6734rJUmFyfk0NIhP5a7GkHWp7zEPLRaiCt9TtkU2dI3KfNobhF8MiiFgPYFznaKzqk
         J97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s8w+cXn0Jb29Ftkb7WcWynQaPBBugviXzJo6qIddcD0=;
        b=N5J+Mgy0riE8IrscLKgam1NC6IRkS+Doq7/V6CJFRgSQOomj/wL1q3NfDtYhUUzBhx
         Ab1erN3piwbBc1KrOlUAwMxiQCEjcHnVGdvKiDwWMm5bd2B2kyT2R09nEuKqmPqAtQ7u
         mcTErvSFf3zJyPfwVE236LPwb8L2vuIqCGFplsut+88GBT+SlqbEGfoNs8rXVmHDWgLJ
         Jqo1qTTmqUxlQGCBl5EVnwfS/KubQLteYKeUJ7RH+IHTGnoeDGzs12B+NXvKPZnxgN7f
         rFsmKsW58uVQvez8+ECAmUhYQJ4EHVdClucynHC3Z9btfCeeDLBQUqlgrQixRCA0xxlg
         Fmww==
X-Gm-Message-State: AOAM532/lMoc9jbBbqSBQBtF1lRhGckzMfZLWpJv+enukX2UX92OZOYM
        /7uS+OTon0fUElqocM/8fzUk
X-Google-Smtp-Source: ABdhPJynSOtkdCUsYQqvcFbGyYEY5hfFzoCaknkI/oR38feJTSQ3zUqu8r+YT1azqlCL93H4zJTtiw==
X-Received: by 2002:a17:902:ea92:: with SMTP id x18mr1963874plb.157.1591775114518;
        Wed, 10 Jun 2020 00:45:14 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id a20sm11516795pff.147.2020.06.10.00.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:45:13 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 4/6] can: mcp25xxfd: Add CAN transmission support
Date:   Wed, 10 Jun 2020 13:14:40 +0530
Message-Id: <20200610074442.10808-5-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
References: <20200610074442.10808-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Sperl <kernel@martin.sperl.org>

Add un-optimized CAN2.0 and CAN-FD transmission support.

On a Rpi3 we can saturate the CAN bus at 1MHz transmitting CAN2.0
frames with DLC=0 for the number of configured tx-fifos.
Afterwards we need some time to recover the state before we can
fill in the fifos again.

With 7 tx fifos we can: send those 7 frames in 0.33ms and then we
wait for 0.26ms so that is a 56% duty cycle.

With 24 tx fifos this changes to: 1.19ms for 24 frames and then we
wait for 0.52ms so that is a 70% duty cycle.

Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/net/can/spi/mcp25xxfd/Makefile        |   1 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c |  10 +
 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h |   3 +-
 .../can/spi/mcp25xxfd/mcp25xxfd_can_fifo.c    |  93 ++-
 .../net/can/spi/mcp25xxfd/mcp25xxfd_can_int.c |  21 +-
 .../can/spi/mcp25xxfd/mcp25xxfd_can_priv.h    |  15 +-
 .../net/can/spi/mcp25xxfd/mcp25xxfd_can_rx.c  |   2 +-
 .../net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c  | 620 ++++++++++++++++++
 .../net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.h  |  86 +++
 9 files changed, 839 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
 create mode 100644 drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.h

diff --git a/drivers/net/can/spi/mcp25xxfd/Makefile b/drivers/net/can/spi/mcp25xxfd/Makefile
index 5787bdd57a9d..a586b2555ff9 100644
--- a/drivers/net/can/spi/mcp25xxfd/Makefile
+++ b/drivers/net/can/spi/mcp25xxfd/Makefile
@@ -4,6 +4,7 @@ mcp25xxfd-objs                  += mcp25xxfd_can.o
 mcp25xxfd-objs                  += mcp25xxfd_can_fifo.o
 mcp25xxfd-objs                  += mcp25xxfd_can_int.o
 mcp25xxfd-objs                  += mcp25xxfd_can_rx.o
+mcp25xxfd-objs                  += mcp25xxfd_can_tx.o
 mcp25xxfd-objs                  += mcp25xxfd_cmd.o
 mcp25xxfd-objs                  += mcp25xxfd_crc.o
 mcp25xxfd-objs                  += mcp25xxfd_ecc.o
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
index 2ac78024c171..1417f1a22d6e 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.c
@@ -20,6 +20,7 @@
 #include "mcp25xxfd_can_fifo.h"
 #include "mcp25xxfd_can_int.h"
 #include "mcp25xxfd_can_priv.h"
+#include "mcp25xxfd_can_tx.h"
 #include "mcp25xxfd_can.h"
 #include "mcp25xxfd_cmd.h"
 #include "mcp25xxfd_int.h"
@@ -395,6 +396,10 @@ static int mcp25xxfd_can_open(struct net_device *net)
 	if (ret)
 		goto out_int;
 
+	/* start the tx_queue */
+	mcp25xxfd_can_tx_queue_manage(cpriv,
+				      MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED);
+
 	return 0;
 
 out_int:
@@ -425,6 +430,10 @@ static int mcp25xxfd_can_stop(struct net_device *net)
 	struct mcp25xxfd_priv *priv = cpriv->priv;
 	struct spi_device *spi = priv->spi;
 
+	/* stop transmit queue */
+	mcp25xxfd_can_tx_queue_manage(cpriv,
+				      MCP25XXFD_CAN_TX_QUEUE_STATE_STOPPED);
+
 	/* shutdown the can controller */
 	mcp25xxfd_can_shutdown(cpriv);
 
@@ -448,6 +457,7 @@ static int mcp25xxfd_can_stop(struct net_device *net)
 static const struct net_device_ops mcp25xxfd_netdev_ops = {
 	.ndo_open = mcp25xxfd_can_open,
 	.ndo_stop = mcp25xxfd_can_stop,
+	.ndo_start_xmit = mcp25xxfd_can_tx_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
 };
 
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
index 4b18b5bb3d45..8ec20827f099 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can.h
@@ -22,12 +22,13 @@ int mcp25xxfd_can_targetmode(struct mcp25xxfd_can_priv *cpriv)
 
 static inline
 void mcp25xxfd_can_queue_frame(struct mcp25xxfd_can_priv *cpriv,
-			       s32 fifo, u16 ts)
+			       s32 fifo, u16 ts, bool is_rx)
 {
 	int idx = cpriv->fifos.submit_queue_count;
 
 	cpriv->fifos.submit_queue[idx].fifo = fifo;
 	cpriv->fifos.submit_queue[idx].ts = ts;
+	cpriv->fifos.submit_queue[idx].is_rx = is_rx;
 
 	cpriv->fifos.submit_queue_count++;
 }
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_fifo.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_fifo.c
index 4bd776772d2d..4a1ad250bdaf 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_fifo.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_fifo.c
@@ -5,8 +5,6 @@
  * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
  */
 
-/* here we define and configure the fifo layout */
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/spi/spi.h>
@@ -14,6 +12,7 @@
 #include "mcp25xxfd_can.h"
 #include "mcp25xxfd_can_fifo.h"
 #include "mcp25xxfd_can_priv.h"
+#include "mcp25xxfd_can_tx.h"
 #include "mcp25xxfd_cmd.h"
 
 static int mcp25xxfd_can_fifo_get_address(struct mcp25xxfd_can_priv *cpriv)
@@ -55,6 +54,15 @@ static int mcp25xxfd_can_fifo_setup_config(struct mcp25xxfd_can_priv *cpriv,
 	     c > 0; i++, f++, p--, c--) {
 		val = (c > 1) ? flags : flags_last;
 
+		/* are we in tx mode? */
+		if (flags & MCP25XXFD_CAN_FIFOCON_TXEN) {
+			cpriv->fifos.info[f].is_rx = false;
+			cpriv->fifos.info[f].priority = p;
+			val |= (p << MCP25XXFD_CAN_FIFOCON_TXPRI_SHIFT);
+		} else {
+			cpriv->fifos.info[f].is_rx = true;
+		}
+
 		/* write the config to the controller in one go */
 		ret = mcp25xxfd_cmd_write(cpriv->priv->spi,
 					  MCP25XXFD_CAN_FIFOCON(f), val);
@@ -65,6 +73,27 @@ static int mcp25xxfd_can_fifo_setup_config(struct mcp25xxfd_can_priv *cpriv,
 	return 0;
 }
 
+static int mcp25xxfd_can_fifo_setup_tx(struct mcp25xxfd_can_priv *cpriv)
+{
+	u32 tx_flags = MCP25XXFD_CAN_FIFOCON_FRESET |     /* reset FIFO */
+		MCP25XXFD_CAN_FIFOCON_TXEN |              /* a tx FIFO */
+		MCP25XXFD_CAN_FIFOCON_TXATIE |            /* state in txatif */
+		(cpriv->fifos.payload_mode <<
+		 MCP25XXFD_CAN_FIFOCON_PLSIZE_SHIFT) |    /* paylod size */
+		(0 << MCP25XXFD_CAN_FIFOCON_FSIZE_SHIFT); /* 1 FIFO deep */
+
+	/* handle oneshot/three-shot */
+	if (cpriv->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
+		tx_flags |= MCP25XXFD_CAN_FIFOCON_TXAT_ONE_SHOT <<
+			    MCP25XXFD_CAN_FIFOCON_TXAT_SHIFT;
+	else
+		tx_flags |= MCP25XXFD_CAN_FIFOCON_TXAT_UNLIMITED <<
+			    MCP25XXFD_CAN_FIFOCON_TXAT_SHIFT;
+
+	return mcp25xxfd_can_fifo_setup_config(cpriv, &cpriv->fifos.tx,
+					       tx_flags, tx_flags);
+}
+
 static int mcp25xxfd_can_fifo_setup_rx(struct mcp25xxfd_can_priv *cpriv)
 {
 	u32 rx_flags = MCP25XXFD_CAN_FIFOCON_FRESET |     /* reset FIFO */
@@ -106,7 +135,7 @@ static int mcp25xxfd_can_fifo_setup_rxfilter(struct mcp25xxfd_can_priv *cpriv)
 
 static int mcp25xxfd_can_fifo_compute(struct mcp25xxfd_can_priv *cpriv)
 {
-	int rx_memory_available;
+	int tef_memory_used, tx_memory_used, rx_memory_available;
 
 	switch (cpriv->can.dev->mtu) {
 	case CAN_MTU:
@@ -114,23 +143,48 @@ static int mcp25xxfd_can_fifo_compute(struct mcp25xxfd_can_priv *cpriv)
 		cpriv->fifos.payload_size = 8;
 		cpriv->fifos.payload_mode = MCP25XXFD_CAN_TXQCON_PLSIZE_8;
 
+		/* 7 tx fifos */
+		cpriv->fifos.tx.count = 7;
+
 		break;
 	case CANFD_MTU:
 		/* MTU is 64 */
 		cpriv->fifos.payload_size = 64;
 		cpriv->fifos.payload_mode = MCP25XXFD_CAN_TXQCON_PLSIZE_64;
 
+		/* 7 tx fifos */
+		cpriv->fifos.tx.count = 7;
+
 		break;
 	default:
 		return -EINVAL;
 	}
 
 	/* compute effective sizes */
+	cpriv->fifos.tef.size = sizeof(struct mcp25xxfd_can_obj_tef);
+	cpriv->fifos.tx.size = sizeof(struct mcp25xxfd_can_obj_tx) +
+		cpriv->fifos.payload_size;
 	cpriv->fifos.rx.size = sizeof(struct mcp25xxfd_can_obj_rx) +
 		cpriv->fifos.payload_size;
 
+	/* set tef fifos to the number of tx fifos */
+	cpriv->fifos.tef.count = cpriv->fifos.tx.count;
+
+	/* compute size of the tx fifos and TEF */
+	tx_memory_used = cpriv->fifos.tx.count * cpriv->fifos.tx.size;
+	tef_memory_used = cpriv->fifos.tef.count * cpriv->fifos.tef.size;
+
 	/* calculate evailable memory for RX_fifos */
-	rx_memory_available = MCP25XXFD_SRAM_SIZE;
+	rx_memory_available = MCP25XXFD_SRAM_SIZE - tx_memory_used -
+		tef_memory_used;
+
+	/* we need at least one RX Frame */
+	if (rx_memory_available < cpriv->fifos.rx.size) {
+		netdev_err(cpriv->can.dev,
+			   "Configured %i tx-fifos exceeds available memory already\n",
+			   cpriv->fifos.tx.count);
+		return -EINVAL;
+	}
 
 	/* calculate possible amount of RX fifos */
 	cpriv->fifos.rx.count = rx_memory_available / cpriv->fifos.rx.size;
@@ -138,10 +192,11 @@ static int mcp25xxfd_can_fifo_compute(struct mcp25xxfd_can_priv *cpriv)
 	/* now calculate effective number of rx-fifos. There are only 31 fifos
 	 * available in total, so we need to limit ourselves
 	 */
-	if (cpriv->fifos.rx.count > 31)
-		cpriv->fifos.rx.count = 31;
+	if (cpriv->fifos.rx.count + cpriv->fifos.tx.count > 31)
+		cpriv->fifos.rx.count = 31 - cpriv->fifos.tx.count;
 
-	cpriv->fifos.rx.start = 1;
+	cpriv->fifos.tx.start = 1;
+	cpriv->fifos.rx.start = cpriv->fifos.tx.start + cpriv->fifos.tx.count;
 
 	return 0;
 }
@@ -170,6 +225,7 @@ static int mcp25xxfd_can_fifo_clear(struct mcp25xxfd_can_priv *cpriv)
 	int ret;
 
 	memset(&cpriv->fifos.info, 0, sizeof(cpriv->fifos.info));
+	memset(&cpriv->fifos.tx, 0, sizeof(cpriv->fifos.tx));
 	memset(&cpriv->fifos.rx, 0, sizeof(cpriv->fifos.rx));
 
 	/* clear FIFO config */
@@ -196,16 +252,31 @@ int mcp25xxfd_can_fifo_setup(struct mcp25xxfd_can_priv *cpriv)
 	if (ret)
 		return ret;
 
-	cpriv->regs.tefcon = 0;
+	/* configure TEF */
+	if (cpriv->fifos.tef.count)
+		cpriv->regs.tefcon =
+			MCP25XXFD_CAN_TEFCON_FRESET |
+			MCP25XXFD_CAN_TEFCON_TEFNEIE |
+			MCP25XXFD_CAN_TEFCON_TEFTSEN |
+			((cpriv->fifos.tef.count - 1) <<
+			 MCP25XXFD_CAN_TEFCON_FSIZE_SHIFT);
+	else
+		cpriv->regs.tefcon = 0;
 	ret = mcp25xxfd_cmd_write(cpriv->priv->spi, MCP25XXFD_CAN_TEFCON,
 				  cpriv->regs.tefcon);
 	if (ret)
 		return ret;
 
+	/* TXQueue disabled */
 	ret = mcp25xxfd_cmd_write(cpriv->priv->spi, MCP25XXFD_CAN_TXQCON, 0);
 	if (ret)
 		return ret;
 
+	/* configure FIFOS themselves */
+	ret = mcp25xxfd_can_fifo_setup_tx(cpriv);
+	if (ret)
+		return ret;
+
 	ret = mcp25xxfd_can_fifo_setup_rx(cpriv);
 	if (ret)
 		return ret;
@@ -219,10 +290,16 @@ int mcp25xxfd_can_fifo_setup(struct mcp25xxfd_can_priv *cpriv)
 	if (ret)
 		return ret;
 
+	/* setup tx_fifo_queue */
+	ret = mcp25xxfd_can_tx_queue_alloc(cpriv);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
 void mcp25xxfd_can_fifo_release(struct mcp25xxfd_can_priv *cpriv)
 {
+	mcp25xxfd_can_tx_queue_free(cpriv);
 	mcp25xxfd_can_fifo_clear(cpriv);
 }
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_int.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_int.c
index 83656b2604df..b3cf3e77c299 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_int.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_int.c
@@ -23,6 +23,7 @@
 #include "mcp25xxfd_can_int.h"
 #include "mcp25xxfd_can_priv.h"
 #include "mcp25xxfd_can_rx.h"
+#include "mcp25xxfd_can_tx.h"
 #include "mcp25xxfd_cmd.h"
 #include "mcp25xxfd_ecc.h"
 
@@ -80,7 +81,9 @@ static int mcp25xxfd_can_int_submit_frames(struct mcp25xxfd_can_priv *cpriv)
 	/* now submit the fifos  */
 	for (i = 0; i < count; i++) {
 		fifo = queue[i].fifo;
-		ret = mcp25xxfd_can_rx_submit_frame(cpriv, fifo);
+		ret = (queue[i].is_rx) ?
+			mcp25xxfd_can_rx_submit_frame(cpriv, fifo) :
+			mcp25xxfd_can_tx_submit_frame(cpriv, fifo);
 		if (ret)
 			return ret;
 	}
@@ -100,6 +103,9 @@ static int mcp25xxfd_can_int_submit_frames(struct mcp25xxfd_can_priv *cpriv)
 	}
 
 out:
+	/* enable tx_queue if necessary */
+	mcp25xxfd_can_tx_queue_restart(cpriv);
+
 	return 0;
 }
 
@@ -496,6 +502,9 @@ static int mcp25xxfd_can_int_error_handling(struct mcp25xxfd_can_priv *cpriv)
 			cpriv->can.can_stats.bus_off++;
 			can_bus_off(cpriv->can.dev);
 		}
+	} else {
+		/* restart the tx queue if needed */
+		mcp25xxfd_can_tx_queue_restart(cpriv);
 	}
 
 	return 0;
@@ -533,6 +542,16 @@ static int mcp25xxfd_can_int_handle_status(struct mcp25xxfd_can_priv *cpriv)
 	if (ret)
 		return ret;
 
+	/* handle aborted TX FIFOs */
+	ret = mcp25xxfd_can_tx_handle_int_txatif(cpriv);
+	if (ret)
+		return ret;
+
+	/* handle the TEF */
+	ret = mcp25xxfd_can_tx_handle_int_tefif(cpriv);
+	if (ret)
+		return ret;
+
 	/* handle error interrupt flags */
 	ret = mcp25xxfd_can_rx_handle_int_rxovif(cpriv);
 	if (ret)
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_priv.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_priv.h
index e043b262a868..99c3ef6d08e0 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_priv.h
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_priv.h
@@ -26,10 +26,12 @@ struct mcp25xxfd_fifo {
 struct mcp25xxfd_obj_ts {
 	s32 ts; /* using signed to handle rollover correctly when sorting */
 	u16 fifo;
+	s16 is_rx;
 };
 
 /* general info on each fifo */
 struct mcp25xxfd_fifo_info {
+	u32 is_rx;
 	u32 offset;
 	u32 priority;
 };
@@ -95,10 +97,18 @@ struct mcp25xxfd_can_priv {
 
 		/* infos on fifo layout */
 
+		/* TEF */
+		struct {
+			u32 count;
+			u32 size;
+			u32 index;
+		} tef;
+
 		/* info on each fifo */
 		struct mcp25xxfd_fifo_info info[32];
 
-		/* extra info on rx fifo groups */
+		/* extra info on rx/tx fifo groups */
+		struct mcp25xxfd_fifo tx;
 		struct mcp25xxfd_fifo rx;
 
 		/* queue of can frames that need to get submitted
@@ -109,6 +119,9 @@ struct mcp25xxfd_can_priv {
 		 */
 		struct mcp25xxfd_obj_ts submit_queue[32];
 		int  submit_queue_count;
+
+		/* the tx queue of spi messages */
+		struct mcp25xxfd_tx_spi_message_queue *tx_queue;
 	} fifos;
 
 	/* bus state */
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_rx.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_rx.c
index 5e3f706e7a3f..da99145e0c94 100644
--- a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_rx.c
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_rx.c
@@ -163,7 +163,7 @@ static int mcp25xxfd_can_rx_read_frame(struct mcp25xxfd_can_priv *cpriv,
 	memset(rx->data + len, 0, ((net->mtu == CANFD_MTU) ? 64 : 8) - len);
 
 	/* add the fifo to the process queues */
-	mcp25xxfd_can_queue_frame(cpriv, fifo, rx->ts);
+	mcp25xxfd_can_queue_frame(cpriv, fifo, rx->ts, true);
 
 	/* and clear the interrupt flag for that fifo */
 	return mcp25xxfd_cmd_write_mask(spi, MCP25XXFD_CAN_FIFOCON(fifo),
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
new file mode 100644
index 000000000000..5ea1e525e776
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.c
@@ -0,0 +1,620 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ *
+ * Based on Microchip MCP251x CAN controller driver written by
+ * David Vrabel, Copyright 2006 Arcom Control Systems Ltd.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/can/core.h>
+#include <linux/can/dev.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_can.h"
+#include "mcp25xxfd_can_id.h"
+#include "mcp25xxfd_can_tx.h"
+#include "mcp25xxfd_cmd.h"
+#include "mcp25xxfd_regs.h"
+
+static struct mcp25xxfd_tx_spi_message *
+mcp25xxfd_can_tx_queue_first_spi_message(struct mcp25xxfd_tx_spi_message_queue *
+					 queue, u32 *bitmap)
+{
+	u32 first = ffs(*bitmap);
+
+	if (!first)
+		return NULL;
+
+	return queue->fifo2message[first - 1];
+}
+
+static void mcp25xxfd_can_tx_queue_remove_spi_message(u32 *bitmap, int fifo)
+{
+	*bitmap &= ~BIT(fifo);
+}
+
+static void mcp25xxfd_can_tx_queue_add_spi_message(u32 *bitmap, int fifo)
+{
+	*bitmap |= BIT(fifo);
+}
+
+static void mcp25xxfd_can_tx_queue_move_spi_message(u32 *src, u32 *dest,
+						    int fifo)
+{
+	mcp25xxfd_can_tx_queue_remove_spi_message(src, fifo);
+	mcp25xxfd_can_tx_queue_add_spi_message(dest, fifo);
+}
+
+static void mcp25xxfd_can_tx_spi_message_fill_fifo_complete(void *context)
+{
+	struct mcp25xxfd_tx_spi_message *msg = context;
+	struct mcp25xxfd_can_priv *cpriv = msg->cpriv;
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	unsigned long flags;
+
+	/* reset transfer length to without data (DLC = 0) */
+	msg->fill_fifo.xfer.len = sizeof(msg->fill_fifo.data.cmd) +
+		sizeof(msg->fill_fifo.data.header);
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* move to in_trigger_fifo_transfer */
+	mcp25xxfd_can_tx_queue_move_spi_message(&q->in_fill_fifo_transfer,
+						&q->in_trigger_fifo_transfer,
+						msg->fifo);
+
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+}
+
+static void mcp25xxfd_can_tx_spi_message_trigger_fifo_complete(void *context)
+{
+	struct mcp25xxfd_tx_spi_message *msg = context;
+	struct mcp25xxfd_can_priv *cpriv = msg->cpriv;
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* move to can_transfer */
+	mcp25xxfd_can_tx_queue_move_spi_message(&q->in_trigger_fifo_transfer,
+						&q->in_can_transfer,
+						msg->fifo);
+
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+}
+
+static
+void mcp25xxfd_can_tx_message_init(struct mcp25xxfd_can_priv *cpriv,
+				   struct mcp25xxfd_tx_spi_message *msg,
+				   int fifo)
+{
+	const u32 trigger = MCP25XXFD_CAN_FIFOCON_TXREQ |
+		MCP25XXFD_CAN_FIFOCON_UINC;
+	const int first_byte = mcp25xxfd_cmd_first_byte(trigger);
+	u32 addr;
+
+	msg->cpriv = cpriv;
+	msg->fifo = fifo;
+
+	/* init fill_fifo */
+	spi_message_init(&msg->fill_fifo.msg);
+	msg->fill_fifo.msg.complete =
+		mcp25xxfd_can_tx_spi_message_fill_fifo_complete;
+	msg->fill_fifo.msg.context = msg;
+
+	msg->fill_fifo.xfer.tx_buf = msg->fill_fifo.data.cmd;
+	msg->fill_fifo.xfer.len = sizeof(msg->fill_fifo.data.cmd) +
+		sizeof(msg->fill_fifo.data.header);
+	spi_message_add_tail(&msg->fill_fifo.xfer, &msg->fill_fifo.msg);
+
+	addr = MCP25XXFD_SRAM_ADDR(cpriv->fifos.info[fifo].offset);
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_WRITE, addr,
+			   msg->fill_fifo.data.cmd);
+
+	/* init trigger_fifo */
+	spi_message_init(&msg->trigger_fifo.msg);
+	msg->trigger_fifo.msg.complete =
+		mcp25xxfd_can_tx_spi_message_trigger_fifo_complete;
+	msg->trigger_fifo.msg.context = msg;
+
+	msg->trigger_fifo.xfer.tx_buf = msg->trigger_fifo.data.cmd;
+	msg->trigger_fifo.xfer.len = sizeof(msg->trigger_fifo.data.cmd) +
+		sizeof(msg->trigger_fifo.data.data);
+	spi_message_add_tail(&msg->trigger_fifo.xfer, &msg->trigger_fifo.msg);
+
+	mcp25xxfd_cmd_calc(MCP25XXFD_INSTRUCTION_WRITE,
+			   MCP25XXFD_CAN_FIFOCON(fifo) + first_byte,
+			   msg->trigger_fifo.data.cmd);
+	msg->trigger_fifo.data.data = trigger >> (8 * first_byte);
+
+	/* add to idle tx transfers */
+	mcp25xxfd_can_tx_queue_add_spi_message(&cpriv->fifos.tx_queue->idle,
+					       fifo);
+}
+
+static
+void mcp25xxfd_can_tx_queue_manage_nolock(struct mcp25xxfd_can_priv *cpriv,
+					  int state)
+{
+	struct net_device *net = cpriv->can.dev;
+
+	if (state == cpriv->fifos.tx_queue->state)
+		return;
+
+	/* start/stop netif_queue if necessary */
+	switch (cpriv->fifos.tx_queue->state) {
+	case MCP25XXFD_CAN_TX_QUEUE_STATE_RUNABLE:
+		switch (state) {
+		case MCP25XXFD_CAN_TX_QUEUE_STATE_RESTART:
+		case MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED:
+			netif_wake_queue(net);
+			cpriv->fifos.tx_queue->state =
+				MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED;
+			break;
+		}
+		break;
+	case MCP25XXFD_CAN_TX_QUEUE_STATE_STOPPED:
+		switch (state) {
+		case MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED:
+			netif_wake_queue(net);
+			cpriv->fifos.tx_queue->state = state;
+			break;
+		}
+		break;
+	case MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED:
+		switch (state) {
+		case MCP25XXFD_CAN_TX_QUEUE_STATE_RUNABLE:
+		case MCP25XXFD_CAN_TX_QUEUE_STATE_STOPPED:
+			netif_stop_queue(net);
+			cpriv->fifos.tx_queue->state = state;
+			break;
+		}
+		break;
+	default:
+		netdev_err(cpriv->can.dev, "Unsupported tx_queue state: %i\n",
+			   cpriv->fifos.tx_queue->state);
+		break;
+	}
+}
+
+void mcp25xxfd_can_tx_queue_manage(struct mcp25xxfd_can_priv *cpriv, int state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	mcp25xxfd_can_tx_queue_manage_nolock(cpriv, state);
+
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+}
+
+void mcp25xxfd_can_tx_queue_restart(struct mcp25xxfd_can_priv *cpriv)
+{
+	u32 state = MCP25XXFD_CAN_TX_QUEUE_STATE_RESTART;
+	unsigned long flags;
+	u32 mask;
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* only move if there is nothing pending or idle */
+	mask = cpriv->fifos.tx_queue->idle |
+		cpriv->fifos.tx_queue->in_fill_fifo_transfer |
+		cpriv->fifos.tx_queue->in_trigger_fifo_transfer |
+		cpriv->fifos.tx_queue->in_can_transfer;
+	if (mask)
+		goto out;
+
+	/* move all items from transferred to idle */
+	cpriv->fifos.tx_queue->idle |= cpriv->fifos.tx_queue->transferred;
+	cpriv->fifos.tx_queue->transferred = 0;
+
+	/* and enable queue */
+	mcp25xxfd_can_tx_queue_manage_nolock(cpriv, state);
+out:
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+}
+
+static
+int mcp25xxfd_can_tx_handle_int_tefif_fifo(struct mcp25xxfd_can_priv *cpriv)
+{
+	u32 tef_offset = cpriv->fifos.tef.index * cpriv->fifos.tef.size;
+	struct mcp25xxfd_can_obj_tef *tef =
+		(struct mcp25xxfd_can_obj_tef *)(cpriv->sram + tef_offset);
+	int fifo, ret;
+	unsigned long flags;
+
+	/* read the next TEF entry to get the transmit timestamp and fifo */
+	ret = mcp25xxfd_cmd_read_regs(cpriv->priv->spi,
+				      MCP25XXFD_SRAM_ADDR(tef_offset),
+				      &tef->id, sizeof(*tef));
+	if (ret)
+		return ret;
+
+	/* get the fifo from tef */
+	fifo = FIELD_GET(MCP25XXFD_CAN_OBJ_FLAGS_SEQ_MASK, tef->flags);
+
+	/* check that the fifo is valid */
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+	if ((cpriv->fifos.tx_queue->in_can_transfer & BIT(fifo)) == 0)
+		netdev_err(cpriv->can.dev,
+			   "tefif: fifo %i not pending - tef data: id: %08x flags: %08x, ts: %08x - this may be a problem with spi signal quality- try reducing spi-clock speed if this can get reproduced",
+			   fifo, tef->id, tef->flags, tef->ts);
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* now we can schedule the fifo for echo submission */
+	mcp25xxfd_can_queue_frame(cpriv, fifo, tef->ts, false);
+
+	/* increment the tef index with wraparound */
+	cpriv->fifos.tef.index++;
+	if (cpriv->fifos.tef.index >= cpriv->fifos.tef.count)
+		cpriv->fifos.tef.index = 0;
+
+	/* finally just increment the TEF pointer */
+	return mcp25xxfd_cmd_write_mask(cpriv->priv->spi, MCP25XXFD_CAN_TEFCON,
+					MCP25XXFD_CAN_TEFCON_UINC,
+					MCP25XXFD_CAN_TEFCON_UINC);
+}
+
+static int
+mcp25xxfd_can_tx_handle_int_tefif_conservative(struct mcp25xxfd_can_priv *cpriv)
+{
+	u32 tefsta;
+	int ret;
+
+	/* read the TEF status */
+	ret = mcp25xxfd_cmd_read_mask(cpriv->priv->spi, MCP25XXFD_CAN_TEFSTA,
+				      &tefsta, MCP25XXFD_CAN_TEFSTA_TEFNEIF);
+	if (ret)
+		return ret;
+
+	/* read the tef in an inefficient loop */
+	while (tefsta & MCP25XXFD_CAN_TEFSTA_TEFNEIF) {
+		/* read one tef */
+		ret = mcp25xxfd_can_tx_handle_int_tefif_fifo(cpriv);
+		if (ret)
+			return ret;
+
+		/* read the TEF status */
+		ret = mcp25xxfd_cmd_read_mask(cpriv->priv->spi,
+					      MCP25XXFD_CAN_TEFSTA, &tefsta,
+					      MCP25XXFD_CAN_TEFSTA_TEFNEIF);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int mcp25xxfd_can_tx_handle_int_tefif(struct mcp25xxfd_can_priv *cpriv)
+{
+	unsigned long flags;
+	u32 finished;
+
+	if (!(cpriv->status.intf & MCP25XXFD_CAN_INT_TEFIF))
+		return 0;
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* compute finished fifos and clear them immediately */
+	finished = (cpriv->fifos.tx_queue->in_can_transfer ^
+		    cpriv->status.txreq) &
+		    cpriv->fifos.tx_queue->in_can_transfer;
+
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+
+	return mcp25xxfd_can_tx_handle_int_tefif_conservative(cpriv);
+}
+
+static
+void mcp25xxfd_can_tx_fill_fifo_common(struct mcp25xxfd_can_priv *cpriv,
+				       struct mcp25xxfd_tx_spi_message *smsg,
+				       struct mcp25xxfd_can_obj_tx *tx,
+				       int dlc, u8 *data)
+{
+	int len = can_dlc2len(dlc);
+
+	/* add fifo number as seq */
+	tx->flags |= smsg->fifo << MCP25XXFD_CAN_OBJ_FLAGS_SEQ_SHIFT;
+
+	/* copy data to tx->data for future reference */
+	memcpy(tx->data, data, len);
+
+	/* transform header to controller format */
+	mcp25xxfd_cmd_convert_from_cpu(&tx->id, sizeof(*tx) / sizeof(u32));
+
+	/* copy header + data to final location - we are not aligned */
+	memcpy(smsg->fill_fifo.data.header, &tx->id, sizeof(*tx) + len);
+
+	/* transfers to sram should be a multiple of 4 and be zero padded */
+	for (; len & 3; len++)
+		*(smsg->fill_fifo.data.header + sizeof(*tx) + len) = 0;
+
+	/* convert it back to CPU format */
+	mcp25xxfd_cmd_convert_to_cpu(&tx->id, sizeof(*tx) / sizeof(u32));
+
+	/* set up size of transfer */
+	smsg->fill_fifo.xfer.len = sizeof(smsg->fill_fifo.data.cmd) +
+		sizeof(smsg->fill_fifo.data.header) + len;
+}
+
+static
+void mcp25xxfd_can_tx_fill_fifo_fd(struct mcp25xxfd_can_priv *cpriv,
+				   struct canfd_frame *frame,
+				   struct mcp25xxfd_tx_spi_message *smsg,
+				   struct mcp25xxfd_can_obj_tx *tx)
+{
+	int dlc = can_len2dlc(frame->len);
+
+	/* compute can id */
+	mcp25xxfd_can_id_to_mcp25xxfd(frame->can_id, &tx->id, &tx->flags);
+
+	/* setup flags */
+	tx->flags |= dlc << MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT;
+	tx->flags |= (frame->can_id & CAN_EFF_FLAG) ?
+		MCP25XXFD_CAN_OBJ_FLAGS_IDE : 0;
+	tx->flags |= (frame->can_id & CAN_RTR_FLAG) ?
+		MCP25XXFD_CAN_OBJ_FLAGS_RTR : 0;
+	if (frame->flags & CANFD_BRS)
+		tx->flags |= MCP25XXFD_CAN_OBJ_FLAGS_BRS;
+
+	tx->flags |= (frame->flags & CANFD_ESI) ?
+		MCP25XXFD_CAN_OBJ_FLAGS_ESI : 0;
+	tx->flags |= MCP25XXFD_CAN_OBJ_FLAGS_FDF;
+
+	/* and do common processing */
+	mcp25xxfd_can_tx_fill_fifo_common(cpriv, smsg, tx, dlc, frame->data);
+}
+
+static
+void mcp25xxfd_can_tx_fill_fifo(struct mcp25xxfd_can_priv *cpriv,
+				struct can_frame *frame,
+				struct mcp25xxfd_tx_spi_message *smsg,
+				struct mcp25xxfd_can_obj_tx *tx)
+{
+	/* set frame to valid dlc */
+	if (frame->can_dlc > 8)
+		frame->can_dlc = 8;
+
+	/* compute can id */
+	mcp25xxfd_can_id_to_mcp25xxfd(frame->can_id, &tx->id, &tx->flags);
+
+	/* setup flags */
+	tx->flags |= frame->can_dlc << MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT;
+	tx->flags |= (frame->can_id & CAN_EFF_FLAG) ?
+		MCP25XXFD_CAN_OBJ_FLAGS_IDE : 0;
+	tx->flags |= (frame->can_id & CAN_RTR_FLAG) ?
+		MCP25XXFD_CAN_OBJ_FLAGS_RTR : 0;
+
+	/* and do common processing */
+	mcp25xxfd_can_tx_fill_fifo_common(cpriv, smsg, tx, frame->can_dlc,
+					  frame->data);
+}
+
+static struct mcp25xxfd_tx_spi_message *
+mcp25xxfd_can_tx_queue_get_next_fifo(struct mcp25xxfd_can_priv *cpriv)
+{
+	u32 state = MCP25XXFD_CAN_TX_QUEUE_STATE_RUNABLE;
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	struct mcp25xxfd_tx_spi_message *smsg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	/* get the first entry from idle */
+	smsg = mcp25xxfd_can_tx_queue_first_spi_message(q, &q->idle);
+	if (!smsg)
+		goto out_busy;
+
+	/* and move the fifo to next stage */
+	mcp25xxfd_can_tx_queue_move_spi_message(&q->idle,
+						&q->in_fill_fifo_transfer,
+						smsg->fifo);
+
+	/* if queue is empty then stop the network queue immediately */
+	if (!q->idle)
+		mcp25xxfd_can_tx_queue_manage_nolock(cpriv, state);
+out_busy:
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return smsg;
+}
+
+/* submit the can message to the can-bus */
+netdev_tx_t mcp25xxfd_can_tx_start_xmit(struct sk_buff *skb,
+					struct net_device *net)
+{
+	u32 state = MCP25XXFD_CAN_TX_QUEUE_STATE_STOPPED;
+	struct mcp25xxfd_can_priv *cpriv = netdev_priv(net);
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	struct mcp25xxfd_priv *priv = cpriv->priv;
+	struct spi_device *spi = priv->spi;
+	struct mcp25xxfd_tx_spi_message *smsg;
+	struct mcp25xxfd_can_obj_tx *tx;
+	unsigned long flags;
+	int ret;
+
+	/* invalid skb we can ignore */
+	if (can_dropped_invalid_skb(net, skb))
+		return NETDEV_TX_OK;
+
+	spin_lock_irqsave(&q->spi_lock, flags);
+
+	/* get the fifo message structure to process now */
+	smsg = mcp25xxfd_can_tx_queue_get_next_fifo(cpriv);
+	if (!smsg)
+		goto out_busy;
+
+	/* compute the fifo in sram */
+	tx = (struct mcp25xxfd_can_obj_tx *)
+		(cpriv->sram + cpriv->fifos.info[smsg->fifo].offset);
+
+	/* fill in message from skb->data depending on can2.0 or canfd */
+	if (can_is_canfd_skb(skb))
+		mcp25xxfd_can_tx_fill_fifo_fd(cpriv,
+					      (struct canfd_frame *)skb->data,
+					      smsg, tx);
+	else
+		mcp25xxfd_can_tx_fill_fifo(cpriv,
+					   (struct can_frame *)skb->data,
+					   smsg, tx);
+
+	/* submit the two messages asyncronously
+	 * the reason why we separate transfers into two spi_messages is:
+	 *  * because the spi framework (currently) does add a 10us delay
+	 *    between 2 spi_transfers in a single spi_message when
+	 *    change_cs is set - 2 consecutive spi messages show a shorter
+	 *    cs disable phase increasing bus utilization
+	 *    (code reduction with a fix in spi core would be aprox.50 lines)
+	 *  * this allows the interrupt handler to start spi messages earlier
+	 *    so reducing latencies a bit and to allow for better concurrency
+	 *  * this separation - in the future - may get used to fill fifos
+	 *    early and reduce the delay on "rollover"
+	 */
+	ret = spi_async(spi, &smsg->fill_fifo.msg);
+	if (ret)
+		goto out_async_failed;
+
+	ret = spi_async(spi, &smsg->trigger_fifo.msg);
+	if (ret)
+		goto out_async_failed;
+
+	spin_unlock_irqrestore(&q->spi_lock, flags);
+
+	can_put_echo_skb(skb, net, smsg->fifo);
+
+	return NETDEV_TX_OK;
+
+out_async_failed:
+	netdev_err(net, "spi_async submission of fifo %i failed - %i\n",
+		   smsg->fifo, ret);
+
+out_busy:
+	mcp25xxfd_can_tx_queue_manage_nolock(cpriv, state);
+	spin_unlock_irqrestore(&q->spi_lock, flags);
+
+	return NETDEV_TX_BUSY;
+}
+
+/* submit the fifo back to the network stack */
+int mcp25xxfd_can_tx_submit_frame(struct mcp25xxfd_can_priv *cpriv, int fifo)
+{
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	struct mcp25xxfd_can_obj_tx *tx = (struct mcp25xxfd_can_obj_tx *)
+		(cpriv->sram + cpriv->fifos.info[fifo].offset);
+	int dlc = (tx->flags & MCP25XXFD_CAN_OBJ_FLAGS_DLC_MASK) >>
+		MCP25XXFD_CAN_OBJ_FLAGS_DLC_SHIFT;
+	unsigned long flags;
+
+	/* update counters */
+	cpriv->can.dev->stats.tx_packets++;
+	cpriv->can.dev->stats.tx_bytes += can_dlc2len(dlc);
+
+	spin_lock_irqsave(&cpriv->fifos.tx_queue->lock, flags);
+
+	/* release the echo buffer */
+	can_get_echo_skb(cpriv->can.dev, fifo);
+
+	/* move from in_can_transfer to transferred */
+	mcp25xxfd_can_tx_queue_move_spi_message(&q->in_can_transfer,
+						&q->transferred, fifo);
+
+	spin_unlock_irqrestore(&cpriv->fifos.tx_queue->lock, flags);
+
+	return 0;
+}
+
+static int
+mcp25xxfd_can_tx_handle_int_txatif_fifo(struct mcp25xxfd_can_priv *cpriv,
+					int fifo)
+{
+	struct mcp25xxfd_tx_spi_message_queue *q = cpriv->fifos.tx_queue;
+	unsigned long flags;
+	u32 val;
+	int ret;
+
+	ret = mcp25xxfd_cmd_read(cpriv->priv->spi,
+				 MCP25XXFD_CAN_FIFOSTA(fifo), &val);
+	if (ret)
+		return ret;
+
+	ret = mcp25xxfd_cmd_write_mask(cpriv->priv->spi,
+				       MCP25XXFD_CAN_FIFOSTA(fifo), 0,
+				       MCP25XXFD_CAN_FIFOSTA_TXABT |
+				       MCP25XXFD_CAN_FIFOSTA_TXLARB |
+				       MCP25XXFD_CAN_FIFOSTA_TXERR |
+				       MCP25XXFD_CAN_FIFOSTA_TXATIF);
+	if (ret)
+		return ret;
+
+	spin_lock_irqsave(&q->lock, flags);
+
+	can_get_echo_skb(cpriv->can.dev, fifo);
+	mcp25xxfd_can_tx_queue_move_spi_message(&q->in_can_transfer,
+						&q->transferred, fifo);
+
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	cpriv->status.txif &= ~BIT(fifo);
+	cpriv->can.dev->stats.tx_aborted_errors++;
+
+	return 0;
+}
+
+int mcp25xxfd_can_tx_handle_int_txatif(struct mcp25xxfd_can_priv *cpriv)
+{
+	int i, f, ret;
+
+	if (!cpriv->status.txatif)
+		return 0;
+
+	/* process all the fifos with txatif flag set */
+	for (i = 0, f = cpriv->fifos.tx.start; i < cpriv->fifos.tx.count;
+	     i++, f++) {
+		if (cpriv->status.txatif & BIT(f)) {
+			ret = mcp25xxfd_can_tx_handle_int_txatif_fifo(cpriv, f);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+int mcp25xxfd_can_tx_queue_alloc(struct mcp25xxfd_can_priv *cpriv)
+{
+	struct mcp25xxfd_tx_spi_message *msg;
+	size_t size = sizeof(struct mcp25xxfd_tx_spi_message_queue) +
+		cpriv->fifos.tx.count * sizeof(*msg);
+	int i, f;
+
+	cpriv->fifos.tx_queue = kzalloc(size, GFP_KERNEL);
+	if (!cpriv->fifos.tx_queue)
+		return -ENOMEM;
+
+	spin_lock_init(&cpriv->fifos.tx_queue->lock);
+	spin_lock_init(&cpriv->fifos.tx_queue->spi_lock);
+
+	/* initialize the individual spi_message structures */
+	for (i = 0, f = cpriv->fifos.tx.start; i < cpriv->fifos.tx.count;
+	     i++, f++) {
+		msg = &cpriv->fifos.tx_queue->message[i];
+		cpriv->fifos.tx_queue->fifo2message[f] = msg;
+		mcp25xxfd_can_tx_message_init(cpriv, msg, f);
+	}
+
+	return 0;
+}
+
+void mcp25xxfd_can_tx_queue_free(struct mcp25xxfd_can_priv *cpriv)
+{
+	kfree(cpriv->fifos.tx_queue);
+	cpriv->fifos.tx_queue = NULL;
+}
diff --git a/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.h b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.h
new file mode 100644
index 000000000000..1947b3420d58
--- /dev/null
+++ b/drivers/net/can/spi/mcp25xxfd/mcp25xxfd_can_tx.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* CAN bus driver for Microchip 25XXFD CAN Controller with SPI Interface
+ *
+ * Copyright 2019 Martin Sperl <kernel@martin.sperl.org>
+ */
+
+#ifndef __MCP25XXFD_CAN_TX_H
+#define __MCP25XXFD_CAN_TX_H
+
+#include <linux/spinlock.h>
+#include <linux/spi/spi.h>
+
+#include "mcp25xxfd_can_priv.h"
+
+/* structure of a spi message that is prepared and can get submitted quickly */
+struct mcp25xxfd_tx_spi_message {
+	/* the network device this is related to */
+	struct mcp25xxfd_can_priv *cpriv;
+	/* the fifo this fills */
+	u32 fifo;
+	/* the xfer to fill in the fifo data */
+	struct {
+		struct spi_message msg;
+		struct spi_transfer xfer;
+		struct {
+			u8 cmd[2];
+			u8 header[sizeof(struct mcp25xxfd_can_obj_tx)];
+			u8 data[64];
+		} data;
+	} fill_fifo;
+	/* the xfer to enable transmission on the can bus */
+	struct {
+		struct spi_message msg;
+		struct spi_transfer xfer;
+		struct {
+			u8 cmd[2];
+			u8 data;
+		} data;
+	} trigger_fifo;
+};
+
+struct mcp25xxfd_tx_spi_message_queue {
+	/* spinlock protecting the bitmaps
+	 * as well as state and the skb_echo_* functions
+	 */
+	spinlock_t lock;
+	/* bitmap of which fifo is in which stage */
+	u32 idle;
+	u32 in_fill_fifo_transfer;
+	u32 in_trigger_fifo_transfer;
+	u32 in_can_transfer;
+	u32 transferred;
+
+	/* the queue state as seen per controller */
+	int state;
+#define MCP25XXFD_CAN_TX_QUEUE_STATE_STOPPED 0
+#define MCP25XXFD_CAN_TX_QUEUE_STATE_STARTED 1
+#define MCP25XXFD_CAN_TX_QUEUE_STATE_RUNABLE 2
+#define MCP25XXFD_CAN_TX_QUEUE_STATE_RESTART 3
+
+	/* spinlock protecting spi submission order */
+	spinlock_t spi_lock;
+
+	/* map each fifo to a mcp25xxfd_tx_spi_message */
+	struct mcp25xxfd_tx_spi_message *fifo2message[32];
+
+	/* the individual messages */
+	struct mcp25xxfd_tx_spi_message message[];
+};
+
+int mcp25xxfd_can_tx_submit_frame(struct mcp25xxfd_can_priv *cpriv, int fifo);
+void mcp25xxfd_can_tx_queue_restart(struct mcp25xxfd_can_priv *cpriv);
+
+int mcp25xxfd_can_tx_handle_int_txatif(struct mcp25xxfd_can_priv *cpriv);
+int mcp25xxfd_can_tx_handle_int_tefif(struct mcp25xxfd_can_priv *cpriv);
+
+netdev_tx_t mcp25xxfd_can_tx_start_xmit(struct sk_buff *skb,
+					struct net_device *net);
+
+void mcp25xxfd_can_tx_queue_manage(struct mcp25xxfd_can_priv *cpriv, int state);
+
+int mcp25xxfd_can_tx_queue_alloc(struct mcp25xxfd_can_priv *cpriv);
+void mcp25xxfd_can_tx_queue_free(struct mcp25xxfd_can_priv *cpriv);
+
+#endif /* __MCP25XXFD_CAN_TX_H */
-- 
2.17.1

