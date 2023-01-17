Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B032666D97C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbjAQJNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236406AbjAQJMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:12:48 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C214E98;
        Tue, 17 Jan 2023 01:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673946362; x=1705482362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fKt1uAC8e9IclcbWTmXXRzGDtBJPGajbi8oY2yBoREI=;
  b=bnJ5METUEVp5psMZv7YxKXPcbCbRYFa9CdGsGnTxbZHSqHfePZQRJM9t
   9MRTiZPMsivEOQDPOTv0CoRBk8ETrRzCtgUgZVOqJVG0qqdsOJLr82sRg
   2u3HMnB5MSYk7mWZTF7NyUfeoYRUWFJrSlwLhQXaf6q7AB4/TCF5ocSFW
   vgT8936vMtZGMoLc1/yGk0Vm3gEUDTqV20wuiLOUnCTyyg4BIL5tS0SVu
   grqk1bzkJS30DfhR2d4E2U/K+uIDR+d9iLddMu7x7sp4FVgwqzMI4UAzs
   rO2N7lhreC6d3YXlBaBqey7WvACZkO2Ycp2f7Xztu1TrIfzajouWDdcPw
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="324701018"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="324701018"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 01:05:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="783174144"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="783174144"
Received: from tronach-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.40.3])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 01:04:52 -0800
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH v4 06/12] tty: Convert ->carrier_raised() and callchains to bool
Date:   Tue, 17 Jan 2023 11:03:52 +0200
Message-Id: <20230117090358.4796-7-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230117090358.4796-1-ilpo.jarvinen@linux.intel.com>
References: <20230117090358.4796-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return boolean from ->carrier_raised() instead of 0 and 1. Make the
return type change also to tty_port_carrier_raised() that makes the
->carrier_raised() call (+ cd variable in moxa into which its return
value is stored).

Also cleans up a few unnecessary constructs related to this change:

	return xx ? 1 : 0;
	-> return xx;

	if (xx)
		return 1;
	return 0;
	-> return xx;

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/char/pcmcia/synclink_cs.c | 8 +++-----
 drivers/mmc/core/sdio_uart.c      | 7 +++----
 drivers/tty/amiserial.c           | 2 +-
 drivers/tty/moxa.c                | 4 ++--
 drivers/tty/mxser.c               | 5 +++--
 drivers/tty/n_gsm.c               | 8 ++++----
 drivers/tty/serial/serial_core.c  | 9 ++++-----
 drivers/tty/synclink_gt.c         | 7 ++++---
 drivers/tty/tty_port.c            | 4 ++--
 drivers/usb/serial/usb-serial.c   | 4 ++--
 include/linux/tty_port.h          | 6 +++---
 net/bluetooth/rfcomm/tty.c        | 2 +-
 12 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index baa46e8a094b..4391138e1b8a 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -377,7 +377,7 @@ static void async_mode(MGSLPC_INFO *info);
 
 static void tx_timeout(struct timer_list *t);
 
-static int carrier_raised(struct tty_port *port);
+static bool carrier_raised(struct tty_port *port);
 static void dtr_rts(struct tty_port *port, int onoff);
 
 #if SYNCLINK_GENERIC_HDLC
@@ -2430,7 +2430,7 @@ static void mgslpc_hangup(struct tty_struct *tty)
 	tty_port_hangup(&info->port);
 }
 
-static int carrier_raised(struct tty_port *port)
+static bool carrier_raised(struct tty_port *port)
 {
 	MGSLPC_INFO *info = container_of(port, MGSLPC_INFO, port);
 	unsigned long flags;
@@ -2439,9 +2439,7 @@ static int carrier_raised(struct tty_port *port)
 	get_signals(info);
 	spin_unlock_irqrestore(&info->lock, flags);
 
-	if (info->serial_signals & SerialSignal_DCD)
-		return 1;
-	return 0;
+	return info->serial_signals & SerialSignal_DCD;
 }
 
 static void dtr_rts(struct tty_port *port, int onoff)
diff --git a/drivers/mmc/core/sdio_uart.c b/drivers/mmc/core/sdio_uart.c
index ae7ef2e038be..47f58258d8ff 100644
--- a/drivers/mmc/core/sdio_uart.c
+++ b/drivers/mmc/core/sdio_uart.c
@@ -526,7 +526,7 @@ static void sdio_uart_irq(struct sdio_func *func)
 	port->in_sdio_uart_irq = NULL;
 }
 
-static int uart_carrier_raised(struct tty_port *tport)
+static bool uart_carrier_raised(struct tty_port *tport)
 {
 	struct sdio_uart_port *port =
 			container_of(tport, struct sdio_uart_port, port);
@@ -535,9 +535,8 @@ static int uart_carrier_raised(struct tty_port *tport)
 		return 1;
 	ret = sdio_uart_get_mctrl(port);
 	sdio_uart_release_func(port);
-	if (ret & TIOCM_CAR)
-		return 1;
-	return 0;
+
+	return ret & TIOCM_CAR;
 }
 
 /**
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 460d33a1e70b..01c4fd3ce7c8 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1454,7 +1454,7 @@ static const struct tty_operations serial_ops = {
 	.proc_show = rs_proc_show,
 };
 
-static int amiga_carrier_raised(struct tty_port *port)
+static bool amiga_carrier_raised(struct tty_port *port)
 {
 	return !(ciab.pra & SER_DCD);
 }
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 2d9635e14ded..6a1e78e33a2c 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -501,7 +501,7 @@ static int moxa_tiocmset(struct tty_struct *tty,
 static void moxa_poll(struct timer_list *);
 static void moxa_set_tty_param(struct tty_struct *, const struct ktermios *);
 static void moxa_shutdown(struct tty_port *);
-static int moxa_carrier_raised(struct tty_port *);
+static bool moxa_carrier_raised(struct tty_port *);
 static void moxa_dtr_rts(struct tty_port *, int);
 /*
  * moxa board interface functions:
@@ -1432,7 +1432,7 @@ static void moxa_shutdown(struct tty_port *port)
 	MoxaPortFlushData(ch, 2);
 }
 
-static int moxa_carrier_raised(struct tty_port *port)
+static bool moxa_carrier_raised(struct tty_port *port)
 {
 	struct moxa_port *ch = container_of(port, struct moxa_port, port);
 	int dcd;
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 2926a831727d..96c72e691cd7 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -458,10 +458,11 @@ static void __mxser_stop_tx(struct mxser_port *info)
 	outb(info->IER, info->ioaddr + UART_IER);
 }
 
-static int mxser_carrier_raised(struct tty_port *port)
+static bool mxser_carrier_raised(struct tty_port *port)
 {
 	struct mxser_port *mp = container_of(port, struct mxser_port, port);
-	return (inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD)?1:0;
+
+	return inb(mp->ioaddr + UART_MSR) & UART_MSR_DCD;
 }
 
 static void mxser_dtr_rts(struct tty_port *port, int on)
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 631539c17d85..81fc2ec3693f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3770,16 +3770,16 @@ static int gsm_modem_update(struct gsm_dlci *dlci, u8 brk)
 	return -EPROTONOSUPPORT;
 }
 
-static int gsm_carrier_raised(struct tty_port *port)
+static bool gsm_carrier_raised(struct tty_port *port)
 {
 	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
 	struct gsm_mux *gsm = dlci->gsm;
 
 	/* Not yet open so no carrier info */
 	if (dlci->state != DLCI_OPEN)
-		return 0;
+		return false;
 	if (debug & DBG_CD_ON)
-		return 1;
+		return true;
 
 	/*
 	 * Basic mode with control channel in ADM mode may not respond
@@ -3787,7 +3787,7 @@ static int gsm_carrier_raised(struct tty_port *port)
 	 */
 	if (gsm->encoding == GSM_BASIC_OPT &&
 	    gsm->dlci[0]->mode == DLCI_MODE_ADM && !dlci->modem_rx)
-		return 1;
+		return true;
 
 	return dlci->modem_rx & TIOCM_CD;
 }
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index f7074ac02801..20ed8a088b2d 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1861,7 +1861,7 @@ static void uart_port_shutdown(struct tty_port *port)
 	}
 }
 
-static int uart_carrier_raised(struct tty_port *port)
+static bool uart_carrier_raised(struct tty_port *port)
 {
 	struct uart_state *state = container_of(port, struct uart_state, port);
 	struct uart_port *uport;
@@ -1875,15 +1875,14 @@ static int uart_carrier_raised(struct tty_port *port)
 	 * continue and not sleep
 	 */
 	if (WARN_ON(!uport))
-		return 1;
+		return true;
 	spin_lock_irq(&uport->lock);
 	uart_enable_ms(uport);
 	mctrl = uport->ops->get_mctrl(uport);
 	spin_unlock_irq(&uport->lock);
 	uart_port_deref(uport);
-	if (mctrl & TIOCM_CAR)
-		return 1;
-	return 0;
+
+	return mctrl & TIOCM_CAR;
 }
 
 static void uart_dtr_rts(struct tty_port *port, int raise)
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 81c94906f06e..4ba71ec764f7 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3126,7 +3126,7 @@ static int tiocmset(struct tty_struct *tty,
 	return 0;
 }
 
-static int carrier_raised(struct tty_port *port)
+static bool carrier_raised(struct tty_port *port)
 {
 	unsigned long flags;
 	struct slgt_info *info = container_of(port, struct slgt_info, port);
@@ -3134,7 +3134,8 @@ static int carrier_raised(struct tty_port *port)
 	spin_lock_irqsave(&info->lock,flags);
 	get_gtsignals(info);
 	spin_unlock_irqrestore(&info->lock,flags);
-	return (info->signals & SerialSignal_DCD) ? 1 : 0;
+
+	return info->signals & SerialSignal_DCD;
 }
 
 static void dtr_rts(struct tty_port *port, int on)
@@ -3162,7 +3163,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	int		retval;
 	bool		do_clocal = false;
 	unsigned long	flags;
-	int		cd;
+	bool		cd;
 	struct tty_port *port = &info->port;
 
 	DBGINFO(("%s block_til_ready\n", tty->driver->name));
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 469de3c010b8..a573c500f95b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -444,10 +444,10 @@ EXPORT_SYMBOL_GPL(tty_port_tty_wakeup);
  * to hide some internal details. This will eventually become entirely
  * internal to the tty port.
  */
-int tty_port_carrier_raised(struct tty_port *port)
+bool tty_port_carrier_raised(struct tty_port *port)
 {
 	if (port->ops->carrier_raised == NULL)
-		return 1;
+		return true;
 	return port->ops->carrier_raised(port);
 }
 EXPORT_SYMBOL(tty_port_carrier_raised);
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 164521ee10c6..019720a63fac 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -754,7 +754,7 @@ static struct usb_serial_driver *search_serial_device(
 	return NULL;
 }
 
-static int serial_port_carrier_raised(struct tty_port *port)
+static bool serial_port_carrier_raised(struct tty_port *port)
 {
 	struct usb_serial_port *p = container_of(port, struct usb_serial_port, port);
 	struct usb_serial_driver *drv = p->serial->type;
@@ -762,7 +762,7 @@ static int serial_port_carrier_raised(struct tty_port *port)
 	if (drv->carrier_raised)
 		return drv->carrier_raised(p);
 	/* No carrier control - don't block */
-	return 1;
+	return true;
 }
 
 static void serial_port_dtr_rts(struct tty_port *port, int on)
diff --git a/include/linux/tty_port.h b/include/linux/tty_port.h
index fa3c3bdaa234..cf098459cb01 100644
--- a/include/linux/tty_port.h
+++ b/include/linux/tty_port.h
@@ -15,7 +15,7 @@ struct tty_struct;
 
 /**
  * struct tty_port_operations -- operations on tty_port
- * @carrier_raised: return 1 if the carrier is raised on @port
+ * @carrier_raised: return true if the carrier is raised on @port
  * @dtr_rts: raise the DTR line if @raise is nonzero, otherwise lower DTR
  * @shutdown: called when the last close completes or a hangup finishes IFF the
  *	port was initialized. Do not use to free resources. Turn off the device
@@ -31,7 +31,7 @@ struct tty_struct;
  *	the port itself.
  */
 struct tty_port_operations {
-	int (*carrier_raised)(struct tty_port *port);
+	bool (*carrier_raised)(struct tty_port *port);
 	void (*dtr_rts)(struct tty_port *port, int raise);
 	void (*shutdown)(struct tty_port *port);
 	int (*activate)(struct tty_port *port, struct tty_struct *tty);
@@ -230,7 +230,7 @@ static inline void tty_port_set_kopened(struct tty_port *port, bool val)
 
 struct tty_struct *tty_port_tty_get(struct tty_port *port);
 void tty_port_tty_set(struct tty_port *port, struct tty_struct *tty);
-int tty_port_carrier_raised(struct tty_port *port);
+bool tty_port_carrier_raised(struct tty_port *port);
 void tty_port_raise_dtr_rts(struct tty_port *port);
 void tty_port_lower_dtr_rts(struct tty_port *port);
 void tty_port_hangup(struct tty_port *port);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 8009e0e93216..5697df9d4394 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -119,7 +119,7 @@ static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
 }
 
 /* we block the open until the dlc->state becomes BT_CONNECTED */
-static int rfcomm_dev_carrier_raised(struct tty_port *port)
+static bool rfcomm_dev_carrier_raised(struct tty_port *port)
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
 
-- 
2.30.2

