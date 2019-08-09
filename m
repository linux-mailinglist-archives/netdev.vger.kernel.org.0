Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 818598775A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406523AbfHIKdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 06:33:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:41830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406468AbfHIKcw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 06:32:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A39E3B048;
        Fri,  9 Aug 2019 10:32:50 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
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
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH v4 8/9] MIPS: SGI-IP27: fix readb/writeb addressing
Date:   Fri,  9 Aug 2019 12:32:30 +0200
Message-Id: <20190809103235.16338-9-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190809103235.16338-1-tbogendoerfer@suse.de>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
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
 arch/mips/include/asm/mach-ip27/mangle-port.h |   4 +-
 arch/mips/include/asm/sn/ioc3.h               | 198 +++++++++++++-------------
 arch/mips/sgi-ip27/ip27-console.c             |   5 +-
 drivers/rtc/rtc-m48t35.c                      |  11 ++
 drivers/tty/serial/8250/8250_ioc3.c           |   4 +-
 5 files changed, 115 insertions(+), 107 deletions(-)

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
index 89938fdce8ef..ac6d7e6e31e0 100644
--- a/arch/mips/include/asm/sn/ioc3.h
+++ b/arch/mips/include/asm/sn/ioc3.h
@@ -10,35 +10,35 @@
 
 /* serial port register map */
 struct ioc3_serialregs {
-	uint32_t	sscr;
-	uint32_t	stpir;
-	uint32_t	stcir;
-	uint32_t	srpir;
-	uint32_t	srcir;
-	uint32_t	srtr;
-	uint32_t	shadow;
+	u32	sscr;
+	u32	stpir;
+	u32	stcir;
+	u32	srpir;
+	u32	srcir;
+	u32	srtr;
+	u32	shadow;
 };
 
 /* SUPERIO uart register map */
 struct ioc3_uartregs {
+	u8	iu_lcr;
 	union {
-		char	rbr;	/* read only, DLAB == 0 */
-		char	thr;	/* write only, DLAB == 0 */
-		char	dll;	/* DLAB == 1 */
-	} u1;
+		u8	iir;	/* read only */
+		u8	fcr;	/* write only */
+	};
 	union {
-		char	ier;	/* DLAB == 0 */
-		char	dlm;	/* DLAB == 1 */
-	} u2;
+		u8	ier;	/* DLAB == 0 */
+		u8	dlm;	/* DLAB == 1 */
+	};
 	union {
-		char	iir;	/* read only */
-		char	fcr;	/* write only */
-	} u3;
-	char	iu_lcr;
-	char	iu_mcr;
-	char	iu_lsr;
-	char	iu_msr;
-	char	iu_scr;
+		u8	rbr;	/* read only, DLAB == 0 */
+		u8	thr;	/* write only, DLAB == 0 */
+		u8	dll;	/* DLAB == 1 */
+	} u1;
+	u8	iu_scr;
+	u8	iu_msr;
+	u8	iu_lsr;
+	u8	iu_mcr;
 };
 
 #define iu_rbr u1.rbr
@@ -50,122 +50,122 @@ struct ioc3_uartregs {
 #define iu_fcr u3.fcr
 
 struct ioc3_sioregs {
-	char	fill[0x141];	/* starts at 0x141 */
+	u8	fill[0x141];	/* starts at 0x141 */
 
-	char	uartc;
-	char	kbdcg;
+	u8	kbdcg;
+	u8	uartc;
 
-	char	fill0[0x150 - 0x142 - 1];
+	u8	fill0[0x151 - 0x142 - 1];
 
-	char	pp_data;
-	char	pp_dsr;
-	char	pp_dcr;
+	u8	pp_dcr;
+	u8	pp_dsr;
+	u8	pp_data;
 
-	char	fill1[0x158 - 0x152 - 1];
+	u8	fill1[0x159 - 0x153 - 1];
 
-	char	pp_fifa;
-	char	pp_cfgb;
-	char	pp_ecr;
+	u8	pp_ecr;
+	u8	pp_cfgb;
+	u8	pp_fifa;
 
-	char	fill2[0x168 - 0x15a - 1];
+	u8	fill2[0x16a - 0x15b - 1];
 
-	char	rtcad;
-	char	rtcdat;
+	u8	rtcdat;
+	u8	rtcad;
 
-	char	fill3[0x170 - 0x169 - 1];
+	u8	fill3[0x170 - 0x16b - 1];
 
 	struct ioc3_uartregs	uartb;	/* 0x20170  */
 	struct ioc3_uartregs	uarta;	/* 0x20178  */
 };
 
 struct ioc3_ethregs {
-	uint32_t	emcr;		/* 0x000f0  */
-	uint32_t	eisr;		/* 0x000f4  */
-	uint32_t	eier;		/* 0x000f8  */
-	uint32_t	ercsr;		/* 0x000fc  */
-	uint32_t	erbr_h;		/* 0x00100  */
-	uint32_t	erbr_l;		/* 0x00104  */
-	uint32_t	erbar;		/* 0x00108  */
-	uint32_t	ercir;		/* 0x0010c  */
-	uint32_t	erpir;		/* 0x00110  */
-	uint32_t	ertr;		/* 0x00114  */
-	uint32_t	etcsr;		/* 0x00118  */
-	uint32_t	ersr;		/* 0x0011c  */
-	uint32_t	etcdc;		/* 0x00120  */
-	uint32_t	ebir;		/* 0x00124  */
-	uint32_t	etbr_h;		/* 0x00128  */
-	uint32_t	etbr_l;		/* 0x0012c  */
-	uint32_t	etcir;		/* 0x00130  */
-	uint32_t	etpir;		/* 0x00134  */
-	uint32_t	emar_h;		/* 0x00138  */
-	uint32_t	emar_l;		/* 0x0013c  */
-	uint32_t	ehar_h;		/* 0x00140  */
-	uint32_t	ehar_l;		/* 0x00144  */
-	uint32_t	micr;		/* 0x00148  */
-	uint32_t	midr_r;		/* 0x0014c  */
-	uint32_t	midr_w;		/* 0x00150  */
+	u32	emcr;		/* 0x000f0  */
+	u32	eisr;		/* 0x000f4  */
+	u32	eier;		/* 0x000f8  */
+	u32	ercsr;		/* 0x000fc  */
+	u32	erbr_h;		/* 0x00100  */
+	u32	erbr_l;		/* 0x00104  */
+	u32	erbar;		/* 0x00108  */
+	u32	ercir;		/* 0x0010c  */
+	u32	erpir;		/* 0x00110  */
+	u32	ertr;		/* 0x00114  */
+	u32	etcsr;		/* 0x00118  */
+	u32	ersr;		/* 0x0011c  */
+	u32	etcdc;		/* 0x00120  */
+	u32	ebir;		/* 0x00124  */
+	u32	etbr_h;		/* 0x00128  */
+	u32	etbr_l;		/* 0x0012c  */
+	u32	etcir;		/* 0x00130  */
+	u32	etpir;		/* 0x00134  */
+	u32	emar_h;		/* 0x00138  */
+	u32	emar_l;		/* 0x0013c  */
+	u32	ehar_h;		/* 0x00140  */
+	u32	ehar_l;		/* 0x00144  */
+	u32	micr;		/* 0x00148  */
+	u32	midr_r;		/* 0x0014c  */
+	u32	midr_w;		/* 0x00150  */
 };
 
 struct ioc3_serioregs {
-	uint32_t	km_csr;		/* 0x0009c  */
-	uint32_t	k_rd;		/* 0x000a0  */
-	uint32_t	m_rd;		/* 0x000a4  */
-	uint32_t	k_wd;		/* 0x000a8  */
-	uint32_t	m_wd;		/* 0x000ac  */
+	u32	km_csr;		/* 0x0009c  */
+	u32	k_rd;		/* 0x000a0  */
+	u32	m_rd;		/* 0x000a4  */
+	u32	k_wd;		/* 0x000a8  */
+	u32	m_wd;		/* 0x000ac  */
 };
 
 /* Register layout of IOC3 in configuration space.  */
 struct ioc3 {
 	/* PCI Config Space registers  */
-	uint32_t	pci_id;		/* 0x00000  */
-	uint32_t	pci_scr;	/* 0x00004  */
-	uint32_t	pci_rev;	/* 0x00008  */
-	uint32_t	pci_lat;	/* 0x0000c  */
-	uint32_t	pci_addr;	/* 0x00010  */
-	uint32_t	pci_err_addr_l;	/* 0x00014  */
-	uint32_t	pci_err_addr_h;	/* 0x00018  */
-
-	uint32_t	sio_ir;		/* 0x0001c  */
-	uint32_t	sio_ies;	/* 0x00020  */
-	uint32_t	sio_iec;	/* 0x00024  */
-	uint32_t	sio_cr;		/* 0x00028  */
-	uint32_t	int_out;	/* 0x0002c  */
-	uint32_t	mcr;		/* 0x00030  */
+	u32	pci_id;		/* 0x00000  */
+	u32	pci_scr;	/* 0x00004  */
+	u32	pci_rev;	/* 0x00008  */
+	u32	pci_lat;	/* 0x0000c  */
+	u32	pci_addr;	/* 0x00010  */
+	u32	pci_err_addr_l;	/* 0x00014  */
+	u32	pci_err_addr_h;	/* 0x00018  */
+
+	u32	sio_ir;		/* 0x0001c  */
+	u32	sio_ies;	/* 0x00020  */
+	u32	sio_iec;	/* 0x00024  */
+	u32	sio_cr;		/* 0x00028  */
+	u32	int_out;	/* 0x0002c  */
+	u32	mcr;		/* 0x00030  */
 
 	/* General Purpose I/O registers  */
-	uint32_t	gpcr_s;		/* 0x00034  */
-	uint32_t	gpcr_c;		/* 0x00038  */
-	uint32_t	gpdr;		/* 0x0003c  */
-	uint32_t	gppr[16];	/* 0x00040  */
+	u32	gpcr_s;		/* 0x00034  */
+	u32	gpcr_c;		/* 0x00038  */
+	u32	gpdr;		/* 0x0003c  */
+	u32	gppr[16];	/* 0x00040  */
 
 	/* Parallel Port Registers  */
-	uint32_t	ppbr_h_a;	/* 0x00080  */
-	uint32_t	ppbr_l_a;	/* 0x00084  */
-	uint32_t	ppcr_a;		/* 0x00088  */
-	uint32_t	ppcr;		/* 0x0008c  */
-	uint32_t	ppbr_h_b;	/* 0x00090  */
-	uint32_t	ppbr_l_b;	/* 0x00094  */
-	uint32_t	ppcr_b;		/* 0x00098  */
+	u32	ppbr_h_a;	/* 0x00080  */
+	u32	ppbr_l_a;	/* 0x00084  */
+	u32	ppcr_a;		/* 0x00088  */
+	u32	ppcr;		/* 0x0008c  */
+	u32	ppbr_h_b;	/* 0x00090  */
+	u32	ppbr_l_b;	/* 0x00094  */
+	u32	ppcr_b;		/* 0x00098  */
 
 	/* Keyboard and Mouse Registers	 */
 	struct ioc3_serioregs	serio;
 
 	/* Serial Port Registers  */
-	uint32_t	sbbr_h;		/* 0x000b0  */
-	uint32_t	sbbr_l;		/* 0x000b4  */
+	u32	sbbr_h;		/* 0x000b0  */
+	u32	sbbr_l;		/* 0x000b4  */
 	struct ioc3_serialregs	port_a;
 	struct ioc3_serialregs	port_b;
 
 	/* Ethernet Registers */
 	struct ioc3_ethregs	eth;
-	uint32_t	pad1[(0x20000 - 0x00154) / 4];
+	u32	pad1[(0x20000 - 0x00154) / 4];
 
 	/* SuperIO Registers  XXX */
 	struct ioc3_sioregs	sregs;	/* 0x20000 */
-	uint32_t	pad2[(0x40000 - 0x20180) / 4];
+	u32	pad2[(0x40000 - 0x20180) / 4];
 
 	/* SSRAM Diagnostic Access */
-	uint32_t	ssram[(0x80000 - 0x40000) / 4];
+	u32	ssram[(0x80000 - 0x40000) / 4];
 
 	/* Bytebus device offsets
 	   0x80000 -   Access to the generic devices selected with   DEV0
@@ -598,10 +598,6 @@ struct ioc3_etxd {
 
 #define MIDR_DATA_MASK		0x0000ffff
 
-#if defined(CONFIG_SGI_IP27) || defined(CONFIG_SGI_IP30)
-extern int bridge_alloc_irq(struct pci_dev *dev);
-#endif
-
 /* subsystem IDs supplied by card detection in pci-xtalk-bridge */
 #define	IOC3_SUBSYS_IP27_BASEIO6G	0xc300
 #define	IOC3_SUBSYS_IP27_MIO		0xc301
diff --git a/arch/mips/sgi-ip27/ip27-console.c b/arch/mips/sgi-ip27/ip27-console.c
index 6bdb48d41276..5886bee89d06 100644
--- a/arch/mips/sgi-ip27/ip27-console.c
+++ b/arch/mips/sgi-ip27/ip27-console.c
@@ -35,6 +35,7 @@ void prom_putchar(char c)
 {
 	struct ioc3_uartregs *uart = console_uart();
 
-	while ((uart->iu_lsr & 0x20) == 0);
-	uart->iu_thr = c;
+	while ((readb(&uart->iu_lsr) & 0x20) == 0)
+		;
+	writeb(c, &uart->iu_thr);
 }
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

