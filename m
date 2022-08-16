Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478CA595B60
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiHPMIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbiHPMHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:07:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F184954671;
        Tue, 16 Aug 2022 04:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660651143; x=1692187143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MqS1TPWmulhFayStdCA+5pTfGSaOryIvs97Q0MvHdsY=;
  b=BKdyeZRtyJZ7iNkoj+1vAY4mbZme3WzQcrqG+w9iqxtE3Qz7/o0IYK+i
   /Tmw2uy/vo3whcxij5pS0GcaIy5PJvylhSMxewnggk21VFO+obH/3c7hh
   Pk/tjRMbx/YZOQ8kXAuOUdBpv6y1FDz8egzOCI4X0GNL/cof+JVqOfN3T
   MCcgt5xqqdW4SjDJaBzG3jMB7aRbSKSUF2t4tz4AGVFaMq3B6fdW8p0KR
   tn6BUsJ5Hxb/21D1sS4t0Ls2keYMEXKIKoEGU9NX0MLL+agR5Kyz0T1qF
   IKlbULCJ9jYF/nQRekzN1XNv6vrajl7vWTSPLJf72pspA2Cb4aSa4x/X6
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="378488900"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="378488900"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 04:59:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="667080943"
Received: from tturcu-mobl1.ger.corp.intel.com (HELO ijarvine-MOBL2.ger.corp.intel.com) ([10.252.51.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 04:58:50 -0700
From:   =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        David Lin <dtwlin@gmail.com>, Johan Hovold <johan@kernel.org>,
        Alex Elder <elder@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Oliver Neukum <oneukum@suse.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        linux-mmc@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-staging@lists.linux.dev, greybus-dev@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Cc:     =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 8/8] tty: Make ->set_termios() old ktermios const
Date:   Tue, 16 Aug 2022 14:57:39 +0300
Message-Id: <20220816115739.10928-9-ilpo.jarvinen@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220816115739.10928-1-ilpo.jarvinen@linux.intel.com>
References: <20220816115739.10928-1-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There should be no reason to adjust old ktermios which is going to get
discarded anyway.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
 drivers/char/pcmcia/synclink_cs.c   | 3 ++-
 drivers/ipack/devices/ipoctal.c     | 2 +-
 drivers/mmc/core/sdio_uart.c        | 4 ++--
 drivers/net/usb/hso.c               | 3 ++-
 drivers/s390/char/tty3270.c         | 2 +-
 drivers/staging/fwserial/fwserial.c | 3 ++-
 drivers/staging/greybus/uart.c      | 2 +-
 drivers/tty/amiserial.c             | 6 +++---
 drivers/tty/moxa.c                  | 9 +++++----
 drivers/tty/mxser.c                 | 6 ++++--
 drivers/tty/n_gsm.c                 | 3 ++-
 drivers/tty/pty.c                   | 2 +-
 drivers/tty/serial/serial_core.c    | 6 +++---
 drivers/tty/synclink_gt.c           | 3 ++-
 drivers/usb/class/cdc-acm.c         | 4 ++--
 drivers/usb/serial/usb-serial.c     | 3 ++-
 include/linux/tty_driver.h          | 4 ++--
 net/bluetooth/rfcomm/tty.c          | 3 ++-
 18 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 8fc49b038372..b2735be81ab2 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2274,7 +2274,8 @@ static int mgslpc_ioctl(struct tty_struct *tty,
  *	tty		pointer to tty structure
  *	termios		pointer to buffer to hold returned old termios
  */
-static void mgslpc_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void mgslpc_set_termios(struct tty_struct *tty,
+			       const struct ktermios *old_termios)
 {
 	MGSLPC_INFO *info = (MGSLPC_INFO *)tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 20d2b9ec1227..fc00274070b6 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -497,7 +497,7 @@ static unsigned int ipoctal_chars_in_buffer(struct tty_struct *tty)
 }
 
 static void ipoctal_set_termios(struct tty_struct *tty,
-				struct ktermios *old_termios)
+				const struct ktermios *old_termios)
 {
 	unsigned int cflag;
 	unsigned char mr1 = 0;
diff --git a/drivers/mmc/core/sdio_uart.c b/drivers/mmc/core/sdio_uart.c
index 414aa82abc39..ae7ef2e038be 100644
--- a/drivers/mmc/core/sdio_uart.c
+++ b/drivers/mmc/core/sdio_uart.c
@@ -246,7 +246,7 @@ static inline void sdio_uart_update_mctrl(struct sdio_uart_port *port,
 
 static void sdio_uart_change_speed(struct sdio_uart_port *port,
 				   struct ktermios *termios,
-				   struct ktermios *old)
+				   const struct ktermios *old)
 {
 	unsigned char cval, fcr = 0;
 	unsigned int baud, quot;
@@ -859,7 +859,7 @@ static void sdio_uart_unthrottle(struct tty_struct *tty)
 }
 
 static void sdio_uart_set_termios(struct tty_struct *tty,
-						struct ktermios *old_termios)
+				  const struct ktermios *old_termios)
 {
 	struct sdio_uart_port *port = tty->driver_data;
 	unsigned int cflag = tty->termios.c_cflag;
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index f8221a7acf62..ce1f6081d582 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1380,7 +1380,8 @@ static void hso_serial_cleanup(struct tty_struct *tty)
 }
 
 /* setup the term */
-static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
+static void hso_serial_set_termios(struct tty_struct *tty,
+				   const struct ktermios *old)
 {
 	struct hso_serial *serial = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 5c83f71c1d0e..26e3995ac062 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1760,7 +1760,7 @@ tty3270_flush_chars(struct tty_struct *tty)
  * Check for visible/invisible input switches
  */
 static void
-tty3270_set_termios(struct tty_struct *tty, struct ktermios *old)
+tty3270_set_termios(struct tty_struct *tty, const struct ktermios *old)
 {
 	struct tty3270 *tp;
 	int new;
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index e8fa7f53cd5e..81b06d88ed0d 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1267,7 +1267,8 @@ static int fwtty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	return err;
 }
 
-static void fwtty_set_termios(struct tty_struct *tty, struct ktermios *old)
+static void fwtty_set_termios(struct tty_struct *tty,
+			      const struct ktermios *old)
 {
 	struct fwtty_port *port = tty->driver_data;
 	unsigned int baud;
diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index dc4ed0ff1ae2..90ff07f2cbf7 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -480,7 +480,7 @@ static int gb_tty_break_ctl(struct tty_struct *tty, int state)
 }
 
 static void gb_tty_set_termios(struct tty_struct *tty,
-			       struct ktermios *termios_old)
+			       const struct ktermios *termios_old)
 {
 	struct gb_uart_set_line_coding_request newline;
 	struct gb_tty *gb_tty = tty->driver_data;
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 81e7f64c1739..f52266766df9 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -94,7 +94,7 @@ static struct tty_driver *serial_driver;
 static unsigned char current_ctl_bits;
 
 static void change_speed(struct tty_struct *tty, struct serial_state *info,
-		struct ktermios *old);
+			 const struct ktermios *old);
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
 
 
@@ -566,7 +566,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
  * the specified baud rate for a serial port.
  */
 static void change_speed(struct tty_struct *tty, struct serial_state *info,
-			 struct ktermios *old_termios)
+			 const struct ktermios *old_termios)
 {
 	struct tty_port *port = &info->tport;
 	int	quot = 0, baud_base, baud;
@@ -1169,7 +1169,7 @@ static int rs_ioctl(struct tty_struct *tty,
 	return 0;
 }
 
-static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void rs_set_termios(struct tty_struct *tty, const struct ktermios *old_termios)
 {
 	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index f3c72ab1476c..35b6fddf0341 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -491,7 +491,7 @@ static int moxa_write(struct tty_struct *, const unsigned char *, int);
 static unsigned int moxa_write_room(struct tty_struct *);
 static void moxa_flush_buffer(struct tty_struct *);
 static unsigned int moxa_chars_in_buffer(struct tty_struct *);
-static void moxa_set_termios(struct tty_struct *, struct ktermios *);
+static void moxa_set_termios(struct tty_struct *, const struct ktermios *);
 static void moxa_stop(struct tty_struct *);
 static void moxa_start(struct tty_struct *);
 static void moxa_hangup(struct tty_struct *);
@@ -499,7 +499,7 @@ static int moxa_tiocmget(struct tty_struct *tty);
 static int moxa_tiocmset(struct tty_struct *tty,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(struct timer_list *);
-static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
+static void moxa_set_tty_param(struct tty_struct *, const struct ktermios *);
 static void moxa_shutdown(struct tty_port *);
 static int moxa_carrier_raised(struct tty_port *);
 static void moxa_dtr_rts(struct tty_port *, int);
@@ -1602,7 +1602,7 @@ static int moxa_tiocmset(struct tty_struct *tty,
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
-		struct ktermios *old_termios)
+		             const struct ktermios *old_termios)
 {
 	struct moxa_port *ch = tty->driver_data;
 
@@ -1761,7 +1761,8 @@ static void moxa_poll(struct timer_list *unused)
 
 /******************************************************************************/
 
-static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
+static void moxa_set_tty_param(struct tty_struct *tty,
+			       const struct ktermios *old_termios)
 {
 	register struct ktermios *ts = &tty->termios;
 	struct moxa_port *ch = tty->driver_data;
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 70b982b2c6b2..3413bd77beed 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -571,7 +571,8 @@ static void mxser_handle_cts(struct tty_struct *tty, struct mxser_port *info,
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static void mxser_change_speed(struct tty_struct *tty, struct ktermios *old_termios)
+static void mxser_change_speed(struct tty_struct *tty,
+			       const struct ktermios *old_termios)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned cflag, cval;
@@ -1348,7 +1349,8 @@ static void mxser_start(struct tty_struct *tty)
 	spin_unlock_irqrestore(&info->slock, flags);
 }
 
-static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void mxser_set_termios(struct tty_struct *tty,
+			      const struct ktermios *old_termios)
 {
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index caa5c14ed57f..97cd8d67c866 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -3647,7 +3647,8 @@ static int gsmtty_ioctl(struct tty_struct *tty,
 	}
 }
 
-static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
+static void gsmtty_set_termios(struct tty_struct *tty,
+			       const struct ktermios *old)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	if (dlci->state == DLCI_CLOSED)
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 752dab3356d7..07394fdaf522 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -240,7 +240,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 }
 
 static void pty_set_termios(struct tty_struct *tty,
-					struct ktermios *old_termios)
+			    const struct ktermios *old_termios)
 {
 	/* See if packet mode change of state. */
 	if (tty->link && tty->link->ctrl.packet) {
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c8295904b331..a8202b582bcc 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -49,7 +49,7 @@ static struct lock_class_key port_lock_key;
 #define RS485_MAX_RTS_DELAY	100 /* msecs */
 
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
-					struct ktermios *old_termios);
+			      const struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state,
 			   enum uart_pm_state pm_state);
@@ -492,7 +492,7 @@ EXPORT_SYMBOL(uart_get_divisor);
 
 /* Caller holds port mutex */
 static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
-					struct ktermios *old_termios)
+			      const struct ktermios *old_termios)
 {
 	struct uart_port *uport = uart_port_check(state);
 	struct ktermios *termios;
@@ -1619,7 +1619,7 @@ static void uart_set_ldisc(struct tty_struct *tty)
 }
 
 static void uart_set_termios(struct tty_struct *tty,
-						struct ktermios *old_termios)
+			     const struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *uport;
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 9bc2a9265277..4a003e929776 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -707,7 +707,8 @@ static void hangup(struct tty_struct *tty)
 	wake_up_interruptible(&info->port.open_wait);
 }
 
-static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
+static void set_termios(struct tty_struct *tty,
+			const struct ktermios *old_termios)
 {
 	struct slgt_info *info = tty->driver_data;
 	unsigned long flags;
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 483bcb1213f7..46dbf907e4b5 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -51,7 +51,7 @@ static DEFINE_IDR(acm_minors);
 static DEFINE_MUTEX(acm_minors_lock);
 
 static void acm_tty_set_termios(struct tty_struct *tty,
-				struct ktermios *termios_old);
+				const struct ktermios *termios_old);
 
 /*
  * acm_minors accessors
@@ -1049,7 +1049,7 @@ static int acm_tty_ioctl(struct tty_struct *tty,
 }
 
 static void acm_tty_set_termios(struct tty_struct *tty,
-						struct ktermios *termios_old)
+				const struct ktermios *termios_old)
 {
 	struct acm *acm = tty->driver_data;
 	struct ktermios *termios = &tty->termios;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index e35bea2235c1..164521ee10c6 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -519,7 +519,8 @@ static int serial_ioctl(struct tty_struct *tty,
 	return retval;
 }
 
-static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
+static void serial_set_termios(struct tty_struct *tty,
+		               const struct ktermios *old)
 {
 	struct usb_serial_port *port = tty->driver_data;
 
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 4841d8069c07..b2456b545ba0 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -141,7 +141,7 @@ struct serial_struct;
  *
  *	Optional.
  *
- * @set_termios: ``void ()(struct tty_struct *tty, struct ktermios *old)``
+ * @set_termios: ``void ()(struct tty_struct *tty, const struct ktermios *old)``
  *
  *	This routine allows the @tty driver to be notified when device's
  *	termios settings have changed. New settings are in @tty->termios.
@@ -365,7 +365,7 @@ struct tty_operations {
 		    unsigned int cmd, unsigned long arg);
 	long (*compat_ioctl)(struct tty_struct *tty,
 			     unsigned int cmd, unsigned long arg);
-	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
+	void (*set_termios)(struct tty_struct *tty, const struct ktermios *old);
 	void (*throttle)(struct tty_struct * tty);
 	void (*unthrottle)(struct tty_struct * tty);
 	void (*stop)(struct tty_struct *tty);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index ebd78fdbd6e8..b9536641161c 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -855,7 +855,8 @@ static int rfcomm_tty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned l
 	return -ENOIOCTLCMD;
 }
 
-static void rfcomm_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
+static void rfcomm_tty_set_termios(struct tty_struct *tty,
+				   const struct ktermios *old)
 {
 	struct ktermios *new = &tty->termios;
 	int old_baud_rate = tty_termios_baud_rate(old);
-- 
2.30.2

