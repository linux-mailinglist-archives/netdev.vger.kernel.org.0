Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DCA918D8
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbfHRS00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:26:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50304 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbfHRS0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:26:18 -0400
Received: by mail-wm1-f66.google.com with SMTP id v15so1109099wml.0;
        Sun, 18 Aug 2019 11:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v1PQz0Rf6qIdBP4XpmfM9YaqjSMhtTmcGs5vz0o4lDg=;
        b=gnkXMpwneEi9NlbC64UBpwW9Bllw5hY8ivs4wggaQqEB9WRyLUoSjvOyOPGa4HC4ae
         eBGDlx0hldKVNW+CNLpe2a+FFnHt2EjEy+Pip4RyMg0HJ7BQ+F1q1ahqoKi0KqzM0yr9
         92pU15SiWzGwZKwhAlI4AJhqkCdQO2Y2qGwb7J+SvMf652FI2i0ddkVS5t/nQe4Vgn4b
         PSwe0wlCWXYeOTefE0zdGFwgmE6mML3vJs3PQoc8/AYSOIv3j3HlBYH9lOq8ONnS1UCR
         dSFt4sjZmhZct8hI6vMOMyqvFdZwv7otWeeyRF7o31LykrUn0CaKhblS05w1pzO4e9mR
         D//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v1PQz0Rf6qIdBP4XpmfM9YaqjSMhtTmcGs5vz0o4lDg=;
        b=brMPr7gjhemniHrJejku8ZCiysv197QVDfYam35ub5gPeHnA3Y2YGwO4B36KUZ5QPA
         j/2fXvbFU0uNJopSJlT8qOFf3d4rfibvE3HJr9pFAdsIJgseGK5mQl4e6F39ypV6cT0x
         SG51GA8drBAU6Egu6XAcQwfQDuBgcBLgQS5oLzpM89PDiSzdThNyp+j5xm8SljstSdaO
         EorkMr/h6w1v2lqgtC91Trg8hopomShpcMeEUMovQGh3QqMS2eiaYQNwKDBxBpNex+Fd
         ValEYlkhLNoirZ2M4KdXRUWZfByzQqhczO8+EW9fUBz7LIWZ5ou/2xKIPvwnNzjifdjk
         yAZw==
X-Gm-Message-State: APjAAAXsnoAZrpf6YsiJK0QdP6i3h9Ia5XrJnLqoaQQ3Y3pTl2RMs4FC
        CfBLCfNXQXBChGDADLgns25wxfly
X-Google-Smtp-Source: APXvYqzAkx+5tewa6+DzA9lqe2ACNEwMBNZ6mnIyIOf3kYim2kirKYv1V6QJgb38E3ubpkKTPF2vrA==
X-Received: by 2002:a1c:411:: with SMTP id 17mr12119331wme.34.1566152775131;
        Sun, 18 Aug 2019 11:26:15 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id 39sm40831107wrc.45.2019.08.18.11.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 11:26:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org, h.feurstein@gmail.com, mlichvar@redhat.com,
        richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com
Cc:     linux-spi@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH spi for-5.4 2/5] spi: Add a PTP system timestamp to the transfer structure
Date:   Sun, 18 Aug 2019 21:25:57 +0300
Message-Id: <20190818182600.3047-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190818182600.3047-1-olteanv@gmail.com>
References: <20190818182600.3047-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SPI is one of the interfaces used to access devices which have a POSIX
clock driver (real time clocks, 1588 timers etc).

Since there are lots of sources of timing jitter when retrieving the
time from such a device (queuing delays, locking contention, running in
interruptible context etc), introduce a PTP system timestamp structure
in struct spi_transfer. This is to be used by SPI device drivers when
they need to know the exact time at which the underlying device's time
was snapshotted.

Because SPI controllers may have jitter even between frames, also
introduce a field which specifies to the controller driver specifically
which byte needs to be snapshotted.

Add a default implementation of the PTP system timestamping in the SPI
core. There are 3 entry points from the core towards the SPI controller
drivers:
- transfer_one: The driver is passed individual spi_transfers to
  execute. This is the easiest to timestamp.
- transfer_one_message: The core passes the driver an entire spi_message
  (a potential batch of spi_transfers). The core puts the same pre and
  post timestamp to all transfers within a message. This is not ideal,
  but nothing better can be done by default anyway, since the core has
  no insight into how the driver batches the transfers.
- transfer: Like transfer_one_message, but for unqueued drivers (i.e.
  the driver implements its own queue scheduling).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi.c       | 62 +++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/spi.h | 38 +++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index d96e04627982..cf5c5435edcd 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1171,6 +1171,11 @@ static int spi_transfer_one_message(struct spi_controller *ctlr,
 		spi_statistics_add_transfer_stats(statm, xfer, ctlr);
 		spi_statistics_add_transfer_stats(stats, xfer, ctlr);
 
+		if (!ctlr->ptp_sts_supported) {
+			xfer->ptp_sts_word_pre = 0;
+			ptp_read_system_prets(xfer->ptp_sts);
+		}
+
 		if (xfer->tx_buf || xfer->rx_buf) {
 			reinit_completion(&ctlr->xfer_completion);
 
@@ -1197,6 +1202,11 @@ static int spi_transfer_one_message(struct spi_controller *ctlr,
 					xfer->len);
 		}
 
+		if (!ctlr->ptp_sts_supported) {
+			ptp_read_system_postts(xfer->ptp_sts);
+			xfer->ptp_sts_word_post = xfer->len;
+		}
+
 		trace_spi_transfer_stop(msg, xfer);
 
 		if (msg->status != -EINPROGRESS)
@@ -1265,6 +1275,7 @@ EXPORT_SYMBOL_GPL(spi_finalize_current_transfer);
  */
 static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 {
+	struct spi_transfer *xfer;
 	struct spi_message *mesg;
 	bool was_busy = false;
 	unsigned long flags;
@@ -1391,6 +1402,13 @@ static void __spi_pump_messages(struct spi_controller *ctlr, bool in_kthread)
 		goto out;
 	}
 
+	if (!ctlr->ptp_sts_supported) {
+		list_for_each_entry(xfer, &mesg->transfers, transfer_list) {
+			xfer->ptp_sts_word_pre = 0;
+			ptp_read_system_prets(xfer->ptp_sts);
+		}
+	}
+
 	ret = ctlr->transfer_one_message(ctlr, mesg);
 	if (ret) {
 		dev_err(&ctlr->dev,
@@ -1418,6 +1436,34 @@ static void spi_pump_messages(struct kthread_work *work)
 	__spi_pump_messages(ctlr, true);
 }
 
+/**
+ * spi_xfer_ptp_sts_word - helper for drivers to retrieve the pointer to the
+ *			   word in the TX buffer which must be timestamped.
+ *			   The SPI slave does not provide a pointer directly
+ *			   because the TX and RX buffers may be reallocated
+ *			   (see @spi_map_msg).
+ * @xfer: Pointer to the transfer being timestamped
+ * @pre: If true, returns the pointer to @ptp_sts_word_pre, otherwise returns
+ *	the pointer to @ptp_sts_word_post.
+ */
+const void *spi_xfer_ptp_sts_word(struct spi_transfer *xfer, bool pre)
+{
+	unsigned int bytes_per_word;
+
+	if (xfer->bits_per_word <= 8)
+		bytes_per_word = 1;
+	else if (xfer->bits_per_word <= 16)
+		bytes_per_word = 2;
+	else
+		bytes_per_word = 4;
+
+	if (pre)
+		return xfer->tx_buf + xfer->ptp_sts_word_pre * bytes_per_word;
+
+	return xfer->tx_buf + xfer->ptp_sts_word_post * bytes_per_word;
+}
+EXPORT_SYMBOL_GPL(spi_xfer_ptp_sts_word);
+
 /**
  * spi_set_thread_rt - set the controller to pump at realtime priority
  * @ctlr: controller to boost priority of
@@ -1503,6 +1549,7 @@ EXPORT_SYMBOL_GPL(spi_get_next_queued_message);
  */
 void spi_finalize_current_message(struct spi_controller *ctlr)
 {
+	struct spi_transfer *xfer;
 	struct spi_message *mesg;
 	unsigned long flags;
 	int ret;
@@ -1511,6 +1558,13 @@ void spi_finalize_current_message(struct spi_controller *ctlr)
 	mesg = ctlr->cur_msg;
 	spin_unlock_irqrestore(&ctlr->queue_lock, flags);
 
+	if (!ctlr->ptp_sts_supported) {
+		list_for_each_entry(xfer, &mesg->transfers, transfer_list) {
+			ptp_read_system_postts(xfer->ptp_sts);
+			xfer->ptp_sts_word_post = xfer->len;
+		}
+	}
+
 	spi_unmap_msg(ctlr, mesg);
 
 	if (ctlr->cur_msg_prepared && ctlr->unprepare_message) {
@@ -3270,6 +3324,7 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 static int __spi_async(struct spi_device *spi, struct spi_message *message)
 {
 	struct spi_controller *ctlr = spi->controller;
+	struct spi_transfer *xfer;
 
 	/*
 	 * Some controllers do not support doing regular SPI transfers. Return
@@ -3285,6 +3340,13 @@ static int __spi_async(struct spi_device *spi, struct spi_message *message)
 
 	trace_spi_message_submit(message);
 
+	if (!ctlr->ptp_sts_supported) {
+		list_for_each_entry(xfer, &message->transfers, transfer_list) {
+			xfer->ptp_sts_word_pre = 0;
+			ptp_read_system_prets(xfer->ptp_sts);
+		}
+	}
+
 	return ctlr->transfer(spi, message);
 }
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index af4f265d0f67..bb7553c6e5d0 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -13,6 +13,7 @@
 #include <linux/completion.h>
 #include <linux/scatterlist.h>
 #include <linux/gpio/consumer.h>
+#include <linux/ptp_clock_kernel.h>
 
 struct dma_chan;
 struct property_entry;
@@ -409,6 +410,12 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
  * @fw_translate_cs: If the boot firmware uses different numbering scheme
  *	what Linux expects, this optional hook can be used to translate
  *	between the two.
+ * @ptp_sts_supported: If the driver sets this to true, it must provide a
+ *	time snapshot in @spi_transfer->ptp_sts as close as possible to the
+ *	moment in time when @spi_transfer->ptp_sts_word_pre and
+ *	@spi_transfer->ptp_sts_word_post were transmitted.
+ *	If the driver does not set this, the SPI core takes the snapshot as
+ *	close to the driver hand-over as possible.
  *
  * Each SPI controller can communicate with one or more @spi_device
  * children.  These make a small bus, sharing MOSI, MISO and SCK signals
@@ -604,6 +611,12 @@ struct spi_controller {
 	void			*dummy_tx;
 
 	int (*fw_translate_cs)(struct spi_controller *ctlr, unsigned cs);
+
+	/*
+	 * Driver sets this field to indicate it is able to snapshot SPI
+	 * transfers (needed e.g. for reading the time of POSIX clocks)
+	 */
+	bool			ptp_sts_supported;
 };
 
 static inline void *spi_controller_get_devdata(struct spi_controller *ctlr)
@@ -644,6 +657,9 @@ extern struct spi_message *spi_get_next_queued_message(struct spi_controller *ct
 extern void spi_finalize_current_message(struct spi_controller *ctlr);
 extern void spi_finalize_current_transfer(struct spi_controller *ctlr);
 
+/* Helper calls for driver to get which buffer pointer must be timestamped */
+extern const void *spi_xfer_ptp_sts_word(struct spi_transfer *xfer, bool pre);
+
 /* the spi driver core manages memory for the spi_controller classdev */
 extern struct spi_controller *__spi_alloc_controller(struct device *host,
 						unsigned int size, bool slave);
@@ -753,6 +769,24 @@ extern void spi_res_release(struct spi_controller *ctlr,
  * @transfer_list: transfers are sequenced through @spi_message.transfers
  * @tx_sg: Scatterlist for transmit, currently not for client use
  * @rx_sg: Scatterlist for receive, currently not for client use
+ * @ptp_sts_word_pre: The word (subject to bits_per_word semantics) offset
+ *	within @tx_buf for which the SPI device is requesting that the time
+ *	snapshot for this transfer begins. Upon completing the SPI transfer,
+ *	this value may have changed compared to what was requested, depending
+ *	on the available snapshotting resolution (DMA transfer,
+ *	@ptp_sts_supported is false, etc).
+ * @ptp_sts_word_post: See @ptp_sts_word_post. The two can be equal (meaning
+ *	that a single byte should be snapshotted). The core will set
+ *	@ptp_sts_word_pre to 0, and @ptp_sts_word_post to the length of the
+ *	transfer, if @ptp_sts_supported is false for this controller. This is
+ *	done purposefully (instead of setting to spi_transfer->len - 1) to
+ *	denote that a transfer-level snapshot taken from within the driver may
+ *	still be of higher quality.
+ * @ptp_sts: Pointer to a memory location held by the SPI slave device where a
+ *	PTP system timestamp structure may lie. If drivers use PIO or their
+ *	hardware has some sort of assist for retrieving exact transfer timing,
+ *	they can (and should) assert @ptp_sts_supported and populate this
+ *	structure using the ptp_read_system_*ts helper functions.
  *
  * SPI transfers always write the same number of bytes as they read.
  * Protocol drivers should always provide @rx_buf and/or @tx_buf.
@@ -842,6 +876,10 @@ struct spi_transfer {
 
 	u32		effective_speed_hz;
 
+	unsigned int	ptp_sts_word_pre;
+	unsigned int	ptp_sts_word_post;
+	struct ptp_system_timestamp *ptp_sts;
+
 	struct list_head transfer_list;
 };
 
-- 
2.17.1

