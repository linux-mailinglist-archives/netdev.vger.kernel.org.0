Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7902F94A18
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbfHSQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:32:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:55518 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728017AbfHSQcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 12:32:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 654B8B62F;
        Mon, 19 Aug 2019 16:32:07 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH v5 16/17] MIPS: SGI-IP27: fix readb/writeb addressing
Date:   Mon, 19 Aug 2019 18:31:39 +0200
Message-Id: <20190819163144.3478-17-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190819163144.3478-1-tbogendoerfer@suse.de>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our chosen byte swapping, which is what firmware already uses, is to
do readl/writel by normal lw/sw intructions (data invariance). This
also means we need to mangle addresses for u8 and u16 accesses. The
mangling for 16bit has been done aready, but 8bit one was missing.
Correcting this causes different addresses for accesses to the
SuperIO and local bus of the IOC3 chip. This is fixed by changing
byte order in ioc3 and m48rtc_rtc structs.

Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/include/asm/mach-ip27/mangle-port.h |  4 +--
 arch/mips/include/asm/sn/ioc3.h               | 42 ++++++++++++---------------
 drivers/rtc/rtc-m48t35.c                      | 11 +++++++
 drivers/tty/serial/8250/8250_ioc3.c           |  4 +--
 4 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/arch/mips/include/asm/mach-ip27/mangle-port.h b/arch/mips/include/asm/mach-ip27/mangle-port.h
index f6e4912ea062..27c56efa519f 100644
--- a/arch/mips/include/asm/mach-ip27/mangle-port.h
+++ b/arch/mips/include/asm/mach-ip27/mangle-port.h
@@ -8,7 +8,7 @@
 #ifndef __ASM_MACH_IP27_MANGLE_PORT_H
 #define __ASM_MACH_IP27_MANGLE_PORT_H
 
-#define __swizzle_addr_b(port)	(port)
+#define __swizzle_addr_b(port)	((port) ^ 3)
 #define __swizzle_addr_w(port)	((port) ^ 2)
 #define __swizzle_addr_l(port)	(port)
 #define __swizzle_addr_q(port)	(port)
@@ -20,6 +20,6 @@
 # define ioswabl(a, x)		(x)
 # define __mem_ioswabl(a, x)	cpu_to_le32(x)
 # define ioswabq(a, x)		(x)
-# define __mem_ioswabq(a, x)	cpu_to_le32(x)
+# define __mem_ioswabq(a, x)	cpu_to_le64(x)
 
 #endif /* __ASM_MACH_IP27_MANGLE_PORT_H */
diff --git a/arch/mips/include/asm/sn/ioc3.h b/arch/mips/include/asm/sn/ioc3.h
index 8ed952d93252..3865d3225780 100644
--- a/arch/mips/include/asm/sn/ioc3.h
+++ b/arch/mips/include/asm/sn/ioc3.h
@@ -21,50 +21,50 @@ struct ioc3_serialregs {
 
 /* SUPERIO uart register map */
 struct ioc3_uartregs {
+	u8	iu_lcr;
 	union {
-		u8	iu_rbr;	/* read only, DLAB == 0 */
-		u8	iu_thr;	/* write only, DLAB == 0 */
-		u8	iu_dll;	/* DLAB == 1 */
+		u8	iu_iir;	/* read only */
+		u8	iu_fcr;	/* write only */
 	};
 	union {
 		u8	iu_ier;	/* DLAB == 0 */
 		u8	iu_dlm;	/* DLAB == 1 */
 	};
 	union {
-		u8	iu_iir;	/* read only */
-		u8	iu_fcr;	/* write only */
+		u8	iu_rbr;	/* read only, DLAB == 0 */
+		u8	iu_thr;	/* write only, DLAB == 0 */
+		u8	iu_dll;	/* DLAB == 1 */
 	};
-	u8	iu_lcr;
-	u8	iu_mcr;
-	u8	iu_lsr;
-	u8	iu_msr;
 	u8	iu_scr;
+	u8	iu_msr;
+	u8	iu_lsr;
+	u8	iu_mcr;
 };
 
 struct ioc3_sioregs {
 	u8	fill[0x141];	/* starts at 0x141 */
 
-	u8	uartc;
 	u8	kbdcg;
+	u8	uartc;
 
-	u8	fill0[0x150 - 0x142 - 1];
+	u8	fill0[0x151 - 0x142 - 1];
 
-	u8	pp_data;
-	u8	pp_dsr;
 	u8	pp_dcr;
+	u8	pp_dsr;
+	u8	pp_data;
 
-	u8	fill1[0x158 - 0x152 - 1];
+	u8	fill1[0x159 - 0x153 - 1];
 
-	u8	pp_fifa;
-	u8	pp_cfgb;
 	u8	pp_ecr;
+	u8	pp_cfgb;
+	u8	pp_fifa;
 
-	u8	fill2[0x168 - 0x15a - 1];
+	u8	fill2[0x16a - 0x15b - 1];
 
-	u8	rtcad;
 	u8	rtcdat;
+	u8	rtcad;
 
-	u8	fill3[0x170 - 0x169 - 1];
+	u8	fill3[0x170 - 0x16b - 1];
 
 	struct ioc3_uartregs	uartb;	/* 0x20170  */
 	struct ioc3_uartregs	uarta;	/* 0x20178  */
@@ -590,10 +590,6 @@ struct ioc3_etxd {
 
 #define MIDR_DATA_MASK		0x0000ffff
 
-#if defined(CONFIG_SGI_IP27) || defined(CONFIG_SGI_IP30)
-extern int bridge_alloc_irq(struct pci_dev *dev);
-#endif
-
 /* subsystem IDs supplied by card detection in pci-xtalk-bridge */
 #define	IOC3_SUBSYS_IP27_BASEIO6G	0xc300
 #define	IOC3_SUBSYS_IP27_MIO		0xc301
diff --git a/drivers/rtc/rtc-m48t35.c b/drivers/rtc/rtc-m48t35.c
index d3a75d447fce..e8194f1f01a8 100644
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -20,6 +20,16 @@
 
 struct m48t35_rtc {
 	u8	pad[0x7ff8];    /* starts at 0x7ff8 */
+#ifdef CONFIG_SGI_IP27
+	u8	hour;
+	u8	min;
+	u8	sec;
+	u8	control;
+	u8	year;
+	u8	month;
+	u8	date;
+	u8	day;
+#else
 	u8	control;
 	u8	sec;
 	u8	min;
@@ -28,6 +38,7 @@ struct m48t35_rtc {
 	u8	date;
 	u8	month;
 	u8	year;
+#endif
 };
 
 #define M48T35_RTC_SET		0x80
diff --git a/drivers/tty/serial/8250/8250_ioc3.c b/drivers/tty/serial/8250/8250_ioc3.c
index 2be6ed2967e0..4c405f1b9c67 100644
--- a/drivers/tty/serial/8250/8250_ioc3.c
+++ b/drivers/tty/serial/8250/8250_ioc3.c
@@ -23,12 +23,12 @@ struct ioc3_8250_data {
 
 static unsigned int ioc3_serial_in(struct uart_port *p, int offset)
 {
-	return readb(p->membase + offset);
+	return readb(p->membase + (offset ^ 3));
 }
 
 static void ioc3_serial_out(struct uart_port *p, int offset, int value)
 {
-	writeb(value, p->membase + offset);
+	writeb(value, p->membase + (offset ^ 3));
 }
 
 static int serial8250_ioc3_probe(struct platform_device *pdev)
-- 
2.13.7

