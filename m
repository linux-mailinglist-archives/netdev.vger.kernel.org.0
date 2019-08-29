Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8047DA1FE4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfH2Puh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 11:50:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:60838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727244AbfH2Puf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 11:50:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5653AFCC;
        Thu, 29 Aug 2019 15:50:33 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 net-next 02/15] MIPS: SGI-IP27: restructure ioc3 register access
Date:   Thu, 29 Aug 2019 17:50:00 +0200
Message-Id: <20190829155014.9229-3-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190829155014.9229-1-tbogendoerfer@suse.de>
References: <20190829155014.9229-1-tbogendoerfer@suse.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Break up the big ioc3 register struct into functional pieces to
make use in sub-function drivers more straightforward. And while
doing that get rid of all volatile access by using readX/writeX.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 arch/mips/include/asm/sn/ioc3.h     | 357 ++++++++++++------------------
 arch/mips/sgi-ip27/ip27-console.c   |   5 +-
 drivers/net/ethernet/sgi/ioc3-eth.c | 418 ++++++++++++++++--------------------
 3 files changed, 331 insertions(+), 449 deletions(-)

diff --git a/arch/mips/include/asm/sn/ioc3.h b/arch/mips/include/asm/sn/ioc3.h
index 25c8dccab51f..a947eed48fee 100644
--- a/arch/mips/include/asm/sn/ioc3.h
+++ b/arch/mips/include/asm/sn/ioc3.h
@@ -3,169 +3,161 @@
  * Copyright (C) 1999, 2000 Ralf Baechle
  * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
  */
-#ifndef _IOC3_H
-#define _IOC3_H
+#ifndef MIPS_SN_IOC3_H
+#define MIPS_SN_IOC3_H
 
 #include <linux/types.h>
 
+/* serial port register map */
+struct ioc3_serialregs {
+	u32	sscr;
+	u32	stpir;
+	u32	stcir;
+	u32	srpir;
+	u32	srcir;
+	u32	srtr;
+	u32	shadow;
+};
+
 /* SUPERIO uart register map */
-typedef volatile struct ioc3_uartregs {
+struct ioc3_uartregs {
 	union {
-		volatile u8	rbr;	/* read only, DLAB == 0 */
-		volatile u8	thr;	/* write only, DLAB == 0 */
-		volatile u8	dll;	/* DLAB == 1 */
-	} u1;
+		u8	iu_rbr;	/* read only, DLAB == 0 */
+		u8	iu_thr;	/* write only, DLAB == 0 */
+		u8	iu_dll;	/* DLAB == 1 */
+	};
 	union {
-		volatile u8	ier;	/* DLAB == 0 */
-		volatile u8	dlm;	/* DLAB == 1 */
-	} u2;
+		u8	iu_ier;	/* DLAB == 0 */
+		u8	iu_dlm;	/* DLAB == 1 */
+	};
 	union {
-		volatile u8	iir;	/* read only */
-		volatile u8	fcr;	/* write only */
-	} u3;
-	volatile u8	    iu_lcr;
-	volatile u8	    iu_mcr;
-	volatile u8	    iu_lsr;
-	volatile u8	    iu_msr;
-	volatile u8	    iu_scr;
-} ioc3_uregs_t;
-
-#define iu_rbr u1.rbr
-#define iu_thr u1.thr
-#define iu_dll u1.dll
-#define iu_ier u2.ier
-#define iu_dlm u2.dlm
-#define iu_iir u3.iir
-#define iu_fcr u3.fcr
+		u8	iu_iir;	/* read only */
+		u8	iu_fcr;	/* write only */
+	};
+	u8	iu_lcr;
+	u8	iu_mcr;
+	u8	iu_lsr;
+	u8	iu_msr;
+	u8	iu_scr;
+};
 
 struct ioc3_sioregs {
-	volatile u8		fill[0x141];	/* starts at 0x141 */
+	u8	fill[0x141];	/* starts at 0x141 */
 
-	volatile u8		uartc;
-	volatile u8		kbdcg;
+	u8	uartc;
+	u8	kbdcg;
 
-	volatile u8		fill0[0x150 - 0x142 - 1];
+	u8	fill0[0x150 - 0x142 - 1];
 
-	volatile u8		pp_data;
-	volatile u8		pp_dsr;
-	volatile u8		pp_dcr;
+	u8	pp_data;
+	u8	pp_dsr;
+	u8	pp_dcr;
 
-	volatile u8		fill1[0x158 - 0x152 - 1];
+	u8	fill1[0x158 - 0x152 - 1];
 
-	volatile u8		pp_fifa;
-	volatile u8		pp_cfgb;
-	volatile u8		pp_ecr;
+	u8	pp_fifa;
+	u8	pp_cfgb;
+	u8	pp_ecr;
 
-	volatile u8		fill2[0x168 - 0x15a - 1];
+	u8	fill2[0x168 - 0x15a - 1];
 
-	volatile u8		rtcad;
-	volatile u8		rtcdat;
+	u8	rtcad;
+	u8	rtcdat;
 
-	volatile u8		fill3[0x170 - 0x169 - 1];
+	u8	fill3[0x170 - 0x169 - 1];
 
 	struct ioc3_uartregs	uartb;	/* 0x20170  */
 	struct ioc3_uartregs	uarta;	/* 0x20178  */
 };
 
+struct ioc3_ethregs {
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
+};
+
+struct ioc3_serioregs {
+	u32	km_csr;		/* 0x0009c  */
+	u32	k_rd;		/* 0x000a0  */
+	u32	m_rd;		/* 0x000a4  */
+	u32	k_wd;		/* 0x000a8  */
+	u32	m_wd;		/* 0x000ac  */
+};
+
 /* Register layout of IOC3 in configuration space.  */
 struct ioc3 {
-	volatile u32	pad0[7];	/* 0x00000  */
-	volatile u32	sio_ir;		/* 0x0001c  */
-	volatile u32	sio_ies;	/* 0x00020  */
-	volatile u32	sio_iec;	/* 0x00024  */
-	volatile u32	sio_cr;		/* 0x00028  */
-	volatile u32	int_out;	/* 0x0002c  */
-	volatile u32	mcr;		/* 0x00030  */
+	/* PCI Config Space registers  */
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
-	volatile u32	gpcr_s;		/* 0x00034  */
-	volatile u32	gpcr_c;		/* 0x00038  */
-	volatile u32	gpdr;		/* 0x0003c  */
-	volatile u32	gppr_0;		/* 0x00040  */
-	volatile u32	gppr_1;		/* 0x00044  */
-	volatile u32	gppr_2;		/* 0x00048  */
-	volatile u32	gppr_3;		/* 0x0004c  */
-	volatile u32	gppr_4;		/* 0x00050  */
-	volatile u32	gppr_5;		/* 0x00054  */
-	volatile u32	gppr_6;		/* 0x00058  */
-	volatile u32	gppr_7;		/* 0x0005c  */
-	volatile u32	gppr_8;		/* 0x00060  */
-	volatile u32	gppr_9;		/* 0x00064  */
-	volatile u32	gppr_10;	/* 0x00068  */
-	volatile u32	gppr_11;	/* 0x0006c  */
-	volatile u32	gppr_12;	/* 0x00070  */
-	volatile u32	gppr_13;	/* 0x00074  */
-	volatile u32	gppr_14;	/* 0x00078  */
-	volatile u32	gppr_15;	/* 0x0007c  */
+	u32	gpcr_s;		/* 0x00034  */
+	u32	gpcr_c;		/* 0x00038  */
+	u32	gpdr;		/* 0x0003c  */
+	u32	gppr[16];	/* 0x00040  */
 
 	/* Parallel Port Registers  */
-	volatile u32	ppbr_h_a;	/* 0x00080  */
-	volatile u32	ppbr_l_a;	/* 0x00084  */
-	volatile u32	ppcr_a;		/* 0x00088  */
-	volatile u32	ppcr;		/* 0x0008c  */
-	volatile u32	ppbr_h_b;	/* 0x00090  */
-	volatile u32	ppbr_l_b;	/* 0x00094  */
-	volatile u32	ppcr_b;		/* 0x00098  */
+	u32	ppbr_h_a;	/* 0x00080  */
+	u32	ppbr_l_a;	/* 0x00084  */
+	u32	ppcr_a;		/* 0x00088  */
+	u32	ppcr;		/* 0x0008c  */
+	u32	ppbr_h_b;	/* 0x00090  */
+	u32	ppbr_l_b;	/* 0x00094  */
+	u32	ppcr_b;		/* 0x00098  */
 
 	/* Keyboard and Mouse Registers	 */
-	volatile u32	km_csr;		/* 0x0009c  */
-	volatile u32	k_rd;		/* 0x000a0  */
-	volatile u32	m_rd;		/* 0x000a4  */
-	volatile u32	k_wd;		/* 0x000a8  */
-	volatile u32	m_wd;		/* 0x000ac  */
+	struct ioc3_serioregs	serio;
 
 	/* Serial Port Registers  */
-	volatile u32	sbbr_h;		/* 0x000b0  */
-	volatile u32	sbbr_l;		/* 0x000b4  */
-	volatile u32	sscr_a;		/* 0x000b8  */
-	volatile u32	stpir_a;	/* 0x000bc  */
-	volatile u32	stcir_a;	/* 0x000c0  */
-	volatile u32	srpir_a;	/* 0x000c4  */
-	volatile u32	srcir_a;	/* 0x000c8  */
-	volatile u32	srtr_a;		/* 0x000cc  */
-	volatile u32	shadow_a;	/* 0x000d0  */
-	volatile u32	sscr_b;		/* 0x000d4  */
-	volatile u32	stpir_b;	/* 0x000d8  */
-	volatile u32	stcir_b;	/* 0x000dc  */
-	volatile u32	srpir_b;	/* 0x000e0  */
-	volatile u32	srcir_b;	/* 0x000e4  */
-	volatile u32	srtr_b;		/* 0x000e8  */
-	volatile u32	shadow_b;	/* 0x000ec  */
-
-	/* Ethernet Registers  */
-	volatile u32	emcr;		/* 0x000f0  */
-	volatile u32	eisr;		/* 0x000f4  */
-	volatile u32	eier;		/* 0x000f8  */
-	volatile u32	ercsr;		/* 0x000fc  */
-	volatile u32	erbr_h;		/* 0x00100  */
-	volatile u32	erbr_l;		/* 0x00104  */
-	volatile u32	erbar;		/* 0x00108  */
-	volatile u32	ercir;		/* 0x0010c  */
-	volatile u32	erpir;		/* 0x00110  */
-	volatile u32	ertr;		/* 0x00114  */
-	volatile u32	etcsr;		/* 0x00118  */
-	volatile u32	ersr;		/* 0x0011c  */
-	volatile u32	etcdc;		/* 0x00120  */
-	volatile u32	ebir;		/* 0x00124  */
-	volatile u32	etbr_h;		/* 0x00128  */
-	volatile u32	etbr_l;		/* 0x0012c  */
-	volatile u32	etcir;		/* 0x00130  */
-	volatile u32	etpir;		/* 0x00134  */
-	volatile u32	emar_h;		/* 0x00138  */
-	volatile u32	emar_l;		/* 0x0013c  */
-	volatile u32	ehar_h;		/* 0x00140  */
-	volatile u32	ehar_l;		/* 0x00144  */
-	volatile u32	micr;		/* 0x00148  */
-	volatile u32	midr_r;		/* 0x0014c  */
-	volatile u32	midr_w;		/* 0x00150  */
-	volatile u32	pad1[(0x20000 - 0x00154) / 4];
+	u32	sbbr_h;		/* 0x000b0  */
+	u32	sbbr_l;		/* 0x000b4  */
+	struct ioc3_serialregs	port_a;
+	struct ioc3_serialregs	port_b;
+
+	/* Ethernet Registers */
+	struct ioc3_ethregs	eth;
+	u32	pad1[(0x20000 - 0x00154) / 4];
 
 	/* SuperIO Registers  XXX */
 	struct ioc3_sioregs	sregs;	/* 0x20000 */
-	volatile u32	pad2[(0x40000 - 0x20180) / 4];
+	u32	pad2[(0x40000 - 0x20180) / 4];
 
 	/* SSRAM Diagnostic Access */
-	volatile u32	ssram[(0x80000 - 0x40000) / 4];
+	u32	ssram[(0x80000 - 0x40000) / 4];
 
 	/* Bytebus device offsets
 	   0x80000 -   Access to the generic devices selected with   DEV0
@@ -178,6 +170,20 @@ struct ioc3 {
 	   0xFFFFF     bytebus DEV_SEL_3  */
 };
 
+
+#define PCI_LAT			0xc		/* Latency Timer */
+#define PCI_SCR_DROP_MODE_EN	0x00008000	/* drop pios on parity err */
+#define UARTA_BASE		0x178
+#define UARTB_BASE		0x170
+
+/*
+ * Bytebus device space
+ */
+#define IOC3_BYTEBUS_DEV0	0x80000L
+#define IOC3_BYTEBUS_DEV1	0xa0000L
+#define IOC3_BYTEBUS_DEV2	0xc0000L
+#define IOC3_BYTEBUS_DEV3	0xe0000L
+
 /*
  * Ethernet RX Buffer
  */
@@ -233,28 +239,20 @@ struct ioc3_etxd {
 #define ETXD_B2CNT_MASK		0x7ff00000
 #define ETXD_B2CNT_SHIFT	20
 
-/*
- * Bytebus device space
- */
-#define IOC3_BYTEBUS_DEV0	0x80000L
-#define IOC3_BYTEBUS_DEV1	0xa0000L
-#define IOC3_BYTEBUS_DEV2	0xc0000L
-#define IOC3_BYTEBUS_DEV3	0xe0000L
-
 /* ------------------------------------------------------------------------- */
 
 /* Superio Registers (PIO Access) */
 #define IOC3_SIO_BASE		0x20000
 #define IOC3_SIO_UARTC		(IOC3_SIO_BASE+0x141)	/* UART Config */
 #define IOC3_SIO_KBDCG		(IOC3_SIO_BASE+0x142)	/* KBD Config */
-#define IOC3_SIO_PP_BASE	(IOC3_SIO_BASE+PP_BASE)		/* Parallel Port */
+#define IOC3_SIO_PP_BASE	(IOC3_SIO_BASE+PP_BASE)	/* Parallel Port */
 #define IOC3_SIO_RTC_BASE	(IOC3_SIO_BASE+0x168)	/* Real Time Clock */
 #define IOC3_SIO_UB_BASE	(IOC3_SIO_BASE+UARTB_BASE)	/* UART B */
 #define IOC3_SIO_UA_BASE	(IOC3_SIO_BASE+UARTA_BASE)	/* UART A */
 
 /* SSRAM Diagnostic Access */
 #define IOC3_SSRAM	IOC3_RAM_OFF	/* base of SSRAM diagnostic access */
-#define IOC3_SSRAM_LEN	0x40000 /* 256kb (address space size, may not be fully populated) */
+#define IOC3_SSRAM_LEN	0x40000	/* 256kb (addrspc sz, may not be populated) */
 #define IOC3_SSRAM_DM	0x0000ffff	/* data mask */
 #define IOC3_SSRAM_PM	0x00010000	/* parity mask */
 
@@ -294,10 +292,10 @@ struct ioc3_etxd {
 					   SIO_IR to assert */
 #define KM_CSR_M_TO_EN	  0x00080000	/* KM_CSR_M_TO + KM_CSR_M_TO_EN = cause
 					   SIO_IR to assert */
-#define KM_CSR_K_CLAMP_ONE	0x00100000	/* Pull K_CLK low after rec. one char */
-#define KM_CSR_M_CLAMP_ONE	0x00200000	/* Pull M_CLK low after rec. one char */
-#define KM_CSR_K_CLAMP_THREE	0x00400000	/* Pull K_CLK low after rec. three chars */
-#define KM_CSR_M_CLAMP_THREE	0x00800000	/* Pull M_CLK low after rec. three char */
+#define KM_CSR_K_CLAMP_1  0x00100000	/* Pull K_CLK low aft recv 1 char */
+#define KM_CSR_M_CLAMP_1  0x00200000	/* Pull M_CLK low aft recv 1 char */
+#define KM_CSR_K_CLAMP_3  0x00400000	/* Pull K_CLK low aft recv 3 chars */
+#define KM_CSR_M_CLAMP_3  0x00800000	/* Pull M_CLK low aft recv 3 chars */
 
 /* bitmasks for IOC3_K_RD and IOC3_M_RD */
 #define KM_RD_DATA_2	0x000000ff	/* 3rd char recvd since last read */
@@ -440,10 +438,6 @@ struct ioc3_etxd {
 				 SIO_IR_PP_INTB | SIO_IR_PP_MEMERR)
 #define SIO_IR_RT		(SIO_IR_RT_INT | SIO_IR_GEN_INT1)
 
-/* macro to load pending interrupts */
-#define IOC3_PENDING_INTRS(mem) (PCI_INW(&((mem)->sio_ir)) & \
-				 PCI_INW(&((mem)->sio_ies_ro)))
-
 /* bitmasks for SIO_CR */
 #define SIO_CR_SIO_RESET	0x00000001	/* reset the SIO */
 #define SIO_CR_SER_A_BASE	0x000000fe	/* DMA poll addr port A */
@@ -500,10 +494,11 @@ struct ioc3_etxd {
 #define GPCR_UARTB_MODESEL	0x40	/* pin is output to port B mode sel */
 #define GPCR_UARTA_MODESEL	0x80	/* pin is output to port A mode sel */
 
-#define GPPR_PHY_RESET_PIN	5	/* GIO pin controlling phy reset */
-#define GPPR_UARTB_MODESEL_PIN	6	/* GIO pin controlling uart b mode select */
-#define GPPR_UARTA_MODESEL_PIN	7	/* GIO pin controlling uart a mode select */
+#define GPPR_PHY_RESET_PIN	5	/* GIO pin cntrlling phy reset */
+#define GPPR_UARTB_MODESEL_PIN	6	/* GIO pin cntrlling uart b mode sel */
+#define GPPR_UARTA_MODESEL_PIN	7	/* GIO pin cntrlling uart a mode sel */
 
+/* ethernet */
 #define EMCR_DUPLEX		0x00000001
 #define EMCR_PROMISC		0x00000002
 #define EMCR_PADEN		0x00000004
@@ -595,70 +590,4 @@ struct ioc3_etxd {
 
 #define MIDR_DATA_MASK		0x0000ffff
 
-#define ERXBUF_IPCKSUM_MASK	0x0000ffff
-#define ERXBUF_BYTECNT_MASK	0x07ff0000
-#define ERXBUF_BYTECNT_SHIFT	16
-#define ERXBUF_V		0x80000000
-
-#define ERXBUF_CRCERR		0x00000001	/* aka RSV15 */
-#define ERXBUF_FRAMERR		0x00000002	/* aka RSV14 */
-#define ERXBUF_CODERR		0x00000004	/* aka RSV13 */
-#define ERXBUF_INVPREAMB	0x00000008	/* aka RSV18 */
-#define ERXBUF_LOLEN		0x00007000	/* aka RSV2_0 */
-#define ERXBUF_HILEN		0x03ff0000	/* aka RSV12_3 */
-#define ERXBUF_MULTICAST	0x04000000	/* aka RSV16 */
-#define ERXBUF_BROADCAST	0x08000000	/* aka RSV17 */
-#define ERXBUF_LONGEVENT	0x10000000	/* aka RSV19 */
-#define ERXBUF_BADPKT		0x20000000	/* aka RSV20 */
-#define ERXBUF_GOODPKT		0x40000000	/* aka RSV21 */
-#define ERXBUF_CARRIER		0x80000000	/* aka RSV22 */
-
-#define ETXD_BYTECNT_MASK	0x000007ff	/* total byte count */
-#define ETXD_INTWHENDONE	0x00001000	/* intr when done */
-#define ETXD_D0V		0x00010000	/* data 0 valid */
-#define ETXD_B1V		0x00020000	/* buf 1 valid */
-#define ETXD_B2V		0x00040000	/* buf 2 valid */
-#define ETXD_DOCHECKSUM		0x00080000	/* insert ip cksum */
-#define ETXD_CHKOFF_MASK	0x07f00000	/* cksum byte offset */
-#define ETXD_CHKOFF_SHIFT	20
-
-#define ETXD_D0CNT_MASK		0x0000007f
-#define ETXD_B1CNT_MASK		0x0007ff00
-#define ETXD_B1CNT_SHIFT	8
-#define ETXD_B2CNT_MASK		0x7ff00000
-#define ETXD_B2CNT_SHIFT	20
-
-typedef enum ioc3_subdevs_e {
-    ioc3_subdev_ether,
-    ioc3_subdev_generic,
-    ioc3_subdev_nic,
-    ioc3_subdev_kbms,
-    ioc3_subdev_ttya,
-    ioc3_subdev_ttyb,
-    ioc3_subdev_ecpp,
-    ioc3_subdev_rt,
-    ioc3_nsubdevs
-} ioc3_subdev_t;
-
-/* subdevice disable bits,
- * from the standard INFO_LBL_SUBDEVS
- */
-#define IOC3_SDB_ETHER		(1<<ioc3_subdev_ether)
-#define IOC3_SDB_GENERIC	(1<<ioc3_subdev_generic)
-#define IOC3_SDB_NIC		(1<<ioc3_subdev_nic)
-#define IOC3_SDB_KBMS		(1<<ioc3_subdev_kbms)
-#define IOC3_SDB_TTYA		(1<<ioc3_subdev_ttya)
-#define IOC3_SDB_TTYB		(1<<ioc3_subdev_ttyb)
-#define IOC3_SDB_ECPP		(1<<ioc3_subdev_ecpp)
-#define IOC3_SDB_RT		(1<<ioc3_subdev_rt)
-
-#define IOC3_ALL_SUBDEVS	((1<<ioc3_nsubdevs)-1)
-
-#define IOC3_SDB_SERIAL		(IOC3_SDB_TTYA|IOC3_SDB_TTYB)
-
-#define IOC3_STD_SUBDEVS	IOC3_ALL_SUBDEVS
-
-#define IOC3_INTA_SUBDEVS	IOC3_SDB_ETHER
-#define IOC3_INTB_SUBDEVS	(IOC3_SDB_GENERIC|IOC3_SDB_KBMS|IOC3_SDB_SERIAL|IOC3_SDB_ECPP|IOC3_SDB_RT)
-
-#endif /* _IOC3_H */
+#endif /* MIPS_SN_IOC3_H */
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
diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index 358e66b81926..713d2472cb97 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -76,7 +76,9 @@
 
 /* Private per NIC data of the driver.  */
 struct ioc3_private {
-	struct ioc3 *regs;
+	struct ioc3_ethregs *regs;
+	struct ioc3 *all_regs;
+	u32 *ssram;
 	unsigned long *rxr;		/* pointer to receiver ring */
 	struct ioc3_etxd *txr;
 	struct sk_buff *rx_skbs[512];
@@ -156,128 +158,67 @@ static inline unsigned long ioc3_map(void *ptr, unsigned long vdev)
 
 #define IOC3_SIZE 0x100000
 
-/*
- * IOC3 is a big endian device
- *
- * Unorthodox but makes the users of these macros more readable - the pointer
- * to the IOC3's memory mapped registers is expected as struct ioc3 * ioc3
- * in the environment.
- */
-#define ioc3_r_mcr()		be32_to_cpu(ioc3->mcr)
-#define ioc3_w_mcr(v)		do { ioc3->mcr = cpu_to_be32(v); } while (0)
-#define ioc3_w_gpcr_s(v)	do { ioc3->gpcr_s = cpu_to_be32(v); } while (0)
-#define ioc3_r_emcr()		be32_to_cpu(ioc3->emcr)
-#define ioc3_w_emcr(v)		do { ioc3->emcr = cpu_to_be32(v); } while (0)
-#define ioc3_r_eisr()		be32_to_cpu(ioc3->eisr)
-#define ioc3_w_eisr(v)		do { ioc3->eisr = cpu_to_be32(v); } while (0)
-#define ioc3_r_eier()		be32_to_cpu(ioc3->eier)
-#define ioc3_w_eier(v)		do { ioc3->eier = cpu_to_be32(v); } while (0)
-#define ioc3_r_ercsr()		be32_to_cpu(ioc3->ercsr)
-#define ioc3_w_ercsr(v)		do { ioc3->ercsr = cpu_to_be32(v); } while (0)
-#define ioc3_r_erbr_h()		be32_to_cpu(ioc3->erbr_h)
-#define ioc3_w_erbr_h(v)	do { ioc3->erbr_h = cpu_to_be32(v); } while (0)
-#define ioc3_r_erbr_l()		be32_to_cpu(ioc3->erbr_l)
-#define ioc3_w_erbr_l(v)	do { ioc3->erbr_l = cpu_to_be32(v); } while (0)
-#define ioc3_r_erbar()		be32_to_cpu(ioc3->erbar)
-#define ioc3_w_erbar(v)		do { ioc3->erbar = cpu_to_be32(v); } while (0)
-#define ioc3_r_ercir()		be32_to_cpu(ioc3->ercir)
-#define ioc3_w_ercir(v)		do { ioc3->ercir = cpu_to_be32(v); } while (0)
-#define ioc3_r_erpir()		be32_to_cpu(ioc3->erpir)
-#define ioc3_w_erpir(v)		do { ioc3->erpir = cpu_to_be32(v); } while (0)
-#define ioc3_r_ertr()		be32_to_cpu(ioc3->ertr)
-#define ioc3_w_ertr(v)		do { ioc3->ertr = cpu_to_be32(v); } while (0)
-#define ioc3_r_etcsr()		be32_to_cpu(ioc3->etcsr)
-#define ioc3_w_etcsr(v)		do { ioc3->etcsr = cpu_to_be32(v); } while (0)
-#define ioc3_r_ersr()		be32_to_cpu(ioc3->ersr)
-#define ioc3_w_ersr(v)		do { ioc3->ersr = cpu_to_be32(v); } while (0)
-#define ioc3_r_etcdc()		be32_to_cpu(ioc3->etcdc)
-#define ioc3_w_etcdc(v)		do { ioc3->etcdc = cpu_to_be32(v); } while (0)
-#define ioc3_r_ebir()		be32_to_cpu(ioc3->ebir)
-#define ioc3_w_ebir(v)		do { ioc3->ebir = cpu_to_be32(v); } while (0)
-#define ioc3_r_etbr_h()		be32_to_cpu(ioc3->etbr_h)
-#define ioc3_w_etbr_h(v)	do { ioc3->etbr_h = cpu_to_be32(v); } while (0)
-#define ioc3_r_etbr_l()		be32_to_cpu(ioc3->etbr_l)
-#define ioc3_w_etbr_l(v)	do { ioc3->etbr_l = cpu_to_be32(v); } while (0)
-#define ioc3_r_etcir()		be32_to_cpu(ioc3->etcir)
-#define ioc3_w_etcir(v)		do { ioc3->etcir = cpu_to_be32(v); } while (0)
-#define ioc3_r_etpir()		be32_to_cpu(ioc3->etpir)
-#define ioc3_w_etpir(v)		do { ioc3->etpir = cpu_to_be32(v); } while (0)
-#define ioc3_r_emar_h()		be32_to_cpu(ioc3->emar_h)
-#define ioc3_w_emar_h(v)	do { ioc3->emar_h = cpu_to_be32(v); } while (0)
-#define ioc3_r_emar_l()		be32_to_cpu(ioc3->emar_l)
-#define ioc3_w_emar_l(v)	do { ioc3->emar_l = cpu_to_be32(v); } while (0)
-#define ioc3_r_ehar_h()		be32_to_cpu(ioc3->ehar_h)
-#define ioc3_w_ehar_h(v)	do { ioc3->ehar_h = cpu_to_be32(v); } while (0)
-#define ioc3_r_ehar_l()		be32_to_cpu(ioc3->ehar_l)
-#define ioc3_w_ehar_l(v)	do { ioc3->ehar_l = cpu_to_be32(v); } while (0)
-#define ioc3_r_micr()		be32_to_cpu(ioc3->micr)
-#define ioc3_w_micr(v)		do { ioc3->micr = cpu_to_be32(v); } while (0)
-#define ioc3_r_midr_r()		be32_to_cpu(ioc3->midr_r)
-#define ioc3_w_midr_r(v)	do { ioc3->midr_r = cpu_to_be32(v); } while (0)
-#define ioc3_r_midr_w()		be32_to_cpu(ioc3->midr_w)
-#define ioc3_w_midr_w(v)	do { ioc3->midr_w = cpu_to_be32(v); } while (0)
-
 static inline u32 mcr_pack(u32 pulse, u32 sample)
 {
 	return (pulse << 10) | (sample << 2);
 }
 
-static int nic_wait(struct ioc3 *ioc3)
+static int nic_wait(u32 __iomem *mcr)
 {
-	u32 mcr;
+	u32 m;
 
-        do {
-                mcr = ioc3_r_mcr();
-        } while (!(mcr & 2));
+	do {
+		m = readl(mcr);
+	} while (!(m & 2));
 
-        return mcr & 1;
+	return m & 1;
 }
 
-static int nic_reset(struct ioc3 *ioc3)
+static int nic_reset(u32 __iomem *mcr)
 {
         int presence;
 
-	ioc3_w_mcr(mcr_pack(500, 65));
-	presence = nic_wait(ioc3);
+	writel(mcr_pack(500, 65), mcr);
+	presence = nic_wait(mcr);
 
-	ioc3_w_mcr(mcr_pack(0, 500));
-	nic_wait(ioc3);
+	writel(mcr_pack(0, 500), mcr);
+	nic_wait(mcr);
 
         return presence;
 }
 
-static inline int nic_read_bit(struct ioc3 *ioc3)
+static inline int nic_read_bit(u32 __iomem *mcr)
 {
 	int result;
 
-	ioc3_w_mcr(mcr_pack(6, 13));
-	result = nic_wait(ioc3);
-	ioc3_w_mcr(mcr_pack(0, 100));
-	nic_wait(ioc3);
+	writel(mcr_pack(6, 13), mcr);
+	result = nic_wait(mcr);
+	writel(mcr_pack(0, 100), mcr);
+	nic_wait(mcr);
 
 	return result;
 }
 
-static inline void nic_write_bit(struct ioc3 *ioc3, int bit)
+static inline void nic_write_bit(u32 __iomem *mcr, int bit)
 {
 	if (bit)
-		ioc3_w_mcr(mcr_pack(6, 110));
+		writel(mcr_pack(6, 110), mcr);
 	else
-		ioc3_w_mcr(mcr_pack(80, 30));
+		writel(mcr_pack(80, 30), mcr);
 
-	nic_wait(ioc3);
+	nic_wait(mcr);
 }
 
 /*
  * Read a byte from an iButton device
  */
-static u32 nic_read_byte(struct ioc3 *ioc3)
+static u32 nic_read_byte(u32 __iomem *mcr)
 {
 	u32 result = 0;
 	int i;
 
 	for (i = 0; i < 8; i++)
-		result = (result >> 1) | (nic_read_bit(ioc3) << 7);
+		result = (result >> 1) | (nic_read_bit(mcr) << 7);
 
 	return result;
 }
@@ -285,7 +226,7 @@ static u32 nic_read_byte(struct ioc3 *ioc3)
 /*
  * Write a byte to an iButton device
  */
-static void nic_write_byte(struct ioc3 *ioc3, int byte)
+static void nic_write_byte(u32 __iomem *mcr, int byte)
 {
 	int i, bit;
 
@@ -293,23 +234,23 @@ static void nic_write_byte(struct ioc3 *ioc3, int byte)
 		bit = byte & 1;
 		byte >>= 1;
 
-		nic_write_bit(ioc3, bit);
+		nic_write_bit(mcr, bit);
 	}
 }
 
-static u64 nic_find(struct ioc3 *ioc3, int *last)
+static u64 nic_find(u32 __iomem *mcr, int *last)
 {
 	int a, b, index, disc;
 	u64 address = 0;
 
-	nic_reset(ioc3);
+	nic_reset(mcr);
 	/* Search ROM.  */
-	nic_write_byte(ioc3, 0xf0);
+	nic_write_byte(mcr, 0xf0);
 
 	/* Algorithm from ``Book of iButton Standards''.  */
 	for (index = 0, disc = 0; index < 64; index++) {
-		a = nic_read_bit(ioc3);
-		b = nic_read_bit(ioc3);
+		a = nic_read_bit(mcr);
+		b = nic_read_bit(mcr);
 
 		if (a && b) {
 			printk("NIC search failed (not fatal).\n");
@@ -325,14 +266,14 @@ static u64 nic_find(struct ioc3 *ioc3, int *last)
 				disc = index;
 			} else if ((address & (1UL << index)) == 0)
 				disc = index;
-			nic_write_bit(ioc3, address & (1UL << index));
+			nic_write_bit(mcr, address & (1UL << index));
 			continue;
 		} else {
 			if (a)
 				address |= 1UL << index;
 			else
 				address &= ~(1UL << index);
-			nic_write_bit(ioc3, a);
+			nic_write_bit(mcr, a);
 			continue;
 		}
 	}
@@ -342,7 +283,7 @@ static u64 nic_find(struct ioc3 *ioc3, int *last)
 	return address;
 }
 
-static int nic_init(struct ioc3 *ioc3)
+static int nic_init(u32 __iomem *mcr)
 {
 	const char *unknown = "unknown";
 	const char *type = unknown;
@@ -352,7 +293,7 @@ static int nic_init(struct ioc3 *ioc3)
 
 	while (1) {
 		u64 reg;
-		reg = nic_find(ioc3, &save);
+		reg = nic_find(mcr, &save);
 
 		switch (reg & 0xff) {
 		case 0x91:
@@ -366,12 +307,12 @@ static int nic_init(struct ioc3 *ioc3)
 			continue;
 		}
 
-		nic_reset(ioc3);
+		nic_reset(mcr);
 
 		/* Match ROM.  */
-		nic_write_byte(ioc3, 0x55);
+		nic_write_byte(mcr, 0x55);
 		for (i = 0; i < 8; i++)
-			nic_write_byte(ioc3, (reg >> (i << 3)) & 0xff);
+			nic_write_byte(mcr, (reg >> (i << 3)) & 0xff);
 
 		reg >>= 8; /* Shift out type.  */
 		for (i = 0; i < 6; i++) {
@@ -396,15 +337,15 @@ static int nic_init(struct ioc3 *ioc3)
  */
 static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
 {
-	struct ioc3 *ioc3 = ip->regs;
-	u8 nic[14];
+	u32 __iomem *mcr = &ip->all_regs->mcr;
 	int tries = 2; /* There may be some problem with the battery?  */
+	u8 nic[14];
 	int i;
 
-	ioc3_w_gpcr_s(1 << 21);
+	writel(1 << 21, &ip->all_regs->gpcr_s);
 
 	while (tries--) {
-		if (!nic_init(ioc3))
+		if (!nic_init(mcr))
 			break;
 		udelay(500);
 	}
@@ -415,12 +356,12 @@ static void ioc3_get_eaddr_nic(struct ioc3_private *ip)
 	}
 
 	/* Read Memory.  */
-	nic_write_byte(ioc3, 0xf0);
-	nic_write_byte(ioc3, 0x00);
-	nic_write_byte(ioc3, 0x00);
+	nic_write_byte(mcr, 0xf0);
+	nic_write_byte(mcr, 0x00);
+	nic_write_byte(mcr, 0x00);
 
 	for (i = 13; i >= 0; i--)
-		nic[i] = nic_read_byte(ioc3);
+		nic[i] = nic_read_byte(mcr);
 
 	for (i = 2; i < 8; i++)
 		ip->dev->dev_addr[i - 2] = nic[i];
@@ -441,11 +382,15 @@ static void ioc3_get_eaddr(struct ioc3_private *ip)
 static void __ioc3_set_mac_address(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
 
-	ioc3_w_emar_h((dev->dev_addr[5] <<  8) | dev->dev_addr[4]);
-	ioc3_w_emar_l((dev->dev_addr[3] << 24) | (dev->dev_addr[2] << 16) |
-	              (dev->dev_addr[1] <<  8) | dev->dev_addr[0]);
+	writel((dev->dev_addr[5] <<  8) |
+	       dev->dev_addr[4],
+	       &ip->regs->emar_h);
+	writel((dev->dev_addr[3] << 24) |
+	       (dev->dev_addr[2] << 16) |
+	       (dev->dev_addr[1] <<  8) |
+	       dev->dev_addr[0],
+	       &ip->regs->emar_l);
 }
 
 static int ioc3_set_mac_address(struct net_device *dev, void *addr)
@@ -469,24 +414,29 @@ static int ioc3_set_mac_address(struct net_device *dev, void *addr)
 static int ioc3_mdio_read(struct net_device *dev, int phy, int reg)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 
-	while (ioc3_r_micr() & MICR_BUSY);
-	ioc3_w_micr((phy << MICR_PHYADDR_SHIFT) | reg | MICR_READTRIG);
-	while (ioc3_r_micr() & MICR_BUSY);
+	while (readl(&regs->micr) & MICR_BUSY)
+		;
+	writel((phy << MICR_PHYADDR_SHIFT) | reg | MICR_READTRIG,
+	       &regs->micr);
+	while (readl(&regs->micr) & MICR_BUSY)
+		;
 
-	return ioc3_r_midr_r() & MIDR_DATA_MASK;
+	return readl(&regs->midr_r) & MIDR_DATA_MASK;
 }
 
 static void ioc3_mdio_write(struct net_device *dev, int phy, int reg, int data)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
-
-	while (ioc3_r_micr() & MICR_BUSY);
-	ioc3_w_midr_w(data);
-	ioc3_w_micr((phy << MICR_PHYADDR_SHIFT) | reg);
-	while (ioc3_r_micr() & MICR_BUSY);
+	struct ioc3_ethregs *regs = ip->regs;
+
+	while (readl(&regs->micr) & MICR_BUSY)
+		;
+	writel(data, &regs->midr_w);
+	writel((phy << MICR_PHYADDR_SHIFT) | reg, &regs->micr);
+	while (readl(&regs->micr) & MICR_BUSY)
+		;
 }
 
 static int ioc3_mii_init(struct ioc3_private *ip);
@@ -494,9 +444,9 @@ static int ioc3_mii_init(struct ioc3_private *ip);
 static struct net_device_stats *ioc3_get_stats(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 
-	dev->stats.collisions += (ioc3_r_etcdc() & ETCDC_COLLCNT_MASK);
+	dev->stats.collisions += readl(&regs->etcdc) & ETCDC_COLLCNT_MASK;
 	return &dev->stats;
 }
 
@@ -572,7 +522,6 @@ static inline void ioc3_rx(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
 	struct sk_buff *skb, *new_skb;
-	struct ioc3 *ioc3 = ip->regs;
 	int rx_entry, n_entry, len;
 	struct ioc3_erxbuf *rxb;
 	unsigned long *rxr;
@@ -640,7 +589,7 @@ static inline void ioc3_rx(struct net_device *dev)
 		rxb = (struct ioc3_erxbuf *) (skb->data - RX_OFFSET);
 		w0 = be32_to_cpu(rxb->w0);
 	}
-	ioc3_w_erpir((n_entry << 3) | ERPIR_ARM);
+	writel((n_entry << 3) | ERPIR_ARM, &ip->regs->erpir);
 	ip->rx_pi = n_entry;
 	ip->rx_ci = rx_entry;
 }
@@ -648,14 +597,14 @@ static inline void ioc3_rx(struct net_device *dev)
 static inline void ioc3_tx(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
+	struct ioc3_ethregs *regs = ip->regs;
 	unsigned long packets, bytes;
-	struct ioc3 *ioc3 = ip->regs;
 	int tx_entry, o_entry;
 	struct sk_buff *skb;
 	u32 etcir;
 
 	spin_lock(&ip->ioc3_lock);
-	etcir = ioc3_r_etcir();
+	etcir = readl(&regs->etcir);
 
 	tx_entry = (etcir >> 7) & 127;
 	o_entry = ip->tx_ci;
@@ -671,7 +620,7 @@ static inline void ioc3_tx(struct net_device *dev)
 
 		o_entry = (o_entry + 1) & 127;		/* Next */
 
-		etcir = ioc3_r_etcir();			/* More pkts sent?  */
+		etcir = readl(&regs->etcir);		/* More pkts sent?  */
 		tx_entry = (etcir >> 7) & 127;
 	}
 
@@ -724,44 +673,39 @@ static void ioc3_error(struct net_device *dev, u32 eisr)
 
 /* The interrupt handler does all of the Rx thread work and cleans up
    after the Tx thread.  */
-static irqreturn_t ioc3_interrupt(int irq, void *_dev)
+static irqreturn_t ioc3_interrupt(int irq, void *dev_id)
 {
-	struct net_device *dev = (struct net_device *)_dev;
-	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
-	const u32 enabled = EISR_RXTIMERINT | EISR_RXOFLO | EISR_RXBUFOFLO |
-	                    EISR_RXMEMERR | EISR_RXPARERR | EISR_TXBUFUFLO |
-	                    EISR_TXEXPLICIT | EISR_TXMEMERR;
+	struct ioc3_private *ip = netdev_priv(dev_id);
+	struct ioc3_ethregs *regs = ip->regs;
 	u32 eisr;
 
-	eisr = ioc3_r_eisr() & enabled;
-
-	ioc3_w_eisr(eisr);
-	(void) ioc3_r_eisr();				/* Flush */
+	eisr = readl(&regs->eisr);
+	writel(eisr, &regs->eisr);
+	readl(&regs->eisr);				/* Flush */
 
 	if (eisr & (EISR_RXOFLO | EISR_RXBUFOFLO | EISR_RXMEMERR |
 	            EISR_RXPARERR | EISR_TXBUFUFLO | EISR_TXMEMERR))
-		ioc3_error(dev, eisr);
+		ioc3_error(dev_id, eisr);
 	if (eisr & EISR_RXTIMERINT)
-		ioc3_rx(dev);
+		ioc3_rx(dev_id);
 	if (eisr & EISR_TXEXPLICIT)
-		ioc3_tx(dev);
+		ioc3_tx(dev_id);
 
 	return IRQ_HANDLED;
 }
 
 static inline void ioc3_setup_duplex(struct ioc3_private *ip)
 {
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 
 	if (ip->mii.full_duplex) {
-		ioc3_w_etcsr(ETCSR_FD);
+		writel(ETCSR_FD, &regs->etcsr);
 		ip->emcr |= EMCR_DUPLEX;
 	} else {
-		ioc3_w_etcsr(ETCSR_HD);
+		writel(ETCSR_HD, &regs->etcsr);
 		ip->emcr &= ~EMCR_DUPLEX;
 	}
-	ioc3_w_emcr(ip->emcr);
+	writel(ip->emcr, &regs->emcr);
 }
 
 static void ioc3_timer(struct timer_list *t)
@@ -936,7 +880,7 @@ static void ioc3_alloc_rings(struct net_device *dev)
 static void ioc3_init_rings(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 	unsigned long ring;
 
 	ioc3_free_rings(ip);
@@ -947,90 +891,94 @@ static void ioc3_init_rings(struct net_device *dev)
 
 	/* Now the rx ring base, consume & produce registers.  */
 	ring = ioc3_map(ip->rxr, 0);
-	ioc3_w_erbr_h(ring >> 32);
-	ioc3_w_erbr_l(ring & 0xffffffff);
-	ioc3_w_ercir(ip->rx_ci << 3);
-	ioc3_w_erpir((ip->rx_pi << 3) | ERPIR_ARM);
+	writel(ring >> 32, &regs->erbr_h);
+	writel(ring & 0xffffffff, &regs->erbr_l);
+	writel(ip->rx_ci << 3, &regs->ercir);
+	writel((ip->rx_pi << 3) | ERPIR_ARM, &regs->erpir);
 
 	ring = ioc3_map(ip->txr, 0);
 
 	ip->txqlen = 0;					/* nothing queued  */
 
 	/* Now the tx ring base, consume & produce registers.  */
-	ioc3_w_etbr_h(ring >> 32);
-	ioc3_w_etbr_l(ring & 0xffffffff);
-	ioc3_w_etpir(ip->tx_pi << 7);
-	ioc3_w_etcir(ip->tx_ci << 7);
-	(void) ioc3_r_etcir();				/* Flush */
+	writel(ring >> 32, &regs->etbr_h);
+	writel(ring & 0xffffffff, &regs->etbr_l);
+	writel(ip->tx_pi << 7, &regs->etpir);
+	writel(ip->tx_ci << 7, &regs->etcir);
+	readl(&regs->etcir);				/* Flush */
 }
 
 static inline void ioc3_ssram_disc(struct ioc3_private *ip)
 {
-	struct ioc3 *ioc3 = ip->regs;
-	volatile u32 *ssram0 = &ioc3->ssram[0x0000];
-	volatile u32 *ssram1 = &ioc3->ssram[0x4000];
-	unsigned int pattern = 0x5555;
+	struct ioc3_ethregs *regs = ip->regs;
+	u32 *ssram0 = &ip->ssram[0x0000];
+	u32 *ssram1 = &ip->ssram[0x4000];
+	u32 pattern = 0x5555;
 
 	/* Assume the larger size SSRAM and enable parity checking */
-	ioc3_w_emcr(ioc3_r_emcr() | (EMCR_BUFSIZ | EMCR_RAMPAR));
+	writel(readl(&regs->emcr) | (EMCR_BUFSIZ | EMCR_RAMPAR), &regs->emcr);
+	readl(&regs->emcr); /* Flush */
 
-	*ssram0 = pattern;
-	*ssram1 = ~pattern & IOC3_SSRAM_DM;
+	writel(pattern, ssram0);
+	writel(~pattern & IOC3_SSRAM_DM, ssram1);
 
-	if ((*ssram0 & IOC3_SSRAM_DM) != pattern ||
-	    (*ssram1 & IOC3_SSRAM_DM) != (~pattern & IOC3_SSRAM_DM)) {
+	if ((readl(ssram0) & IOC3_SSRAM_DM) != pattern ||
+	    (readl(ssram1) & IOC3_SSRAM_DM) != (~pattern & IOC3_SSRAM_DM)) {
 		/* set ssram size to 64 KB */
-		ip->emcr = EMCR_RAMPAR;
-		ioc3_w_emcr(ioc3_r_emcr() & ~EMCR_BUFSIZ);
-	} else
-		ip->emcr = EMCR_BUFSIZ | EMCR_RAMPAR;
+		ip->emcr |= EMCR_RAMPAR;
+		writel(readl(&regs->emcr) & ~EMCR_BUFSIZ, &regs->emcr);
+	} else {
+		ip->emcr |= EMCR_BUFSIZ | EMCR_RAMPAR;
+	}
 }
 
 static void ioc3_init(struct net_device *dev)
 {
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 
 	del_timer_sync(&ip->ioc3_timer);	/* Kill if running	*/
 
-	ioc3_w_emcr(EMCR_RST);			/* Reset		*/
-	(void) ioc3_r_emcr();			/* Flush WB		*/
+	writel(EMCR_RST, &regs->emcr);		/* Reset		*/
+	readl(&regs->emcr);			/* Flush WB		*/
 	udelay(4);				/* Give it time ...	*/
-	ioc3_w_emcr(0);
-	(void) ioc3_r_emcr();
+	writel(0, &regs->emcr);
+	readl(&regs->emcr);
 
 	/* Misc registers  */
 #ifdef CONFIG_SGI_IP27
-	ioc3_w_erbar(PCI64_ATTR_BAR >> 32);	/* Barrier on last store */
+	/* Barrier on last store */
+	writel(PCI64_ATTR_BAR >> 32, &regs->erbar);
 #else
-	ioc3_w_erbar(0);			/* Let PCI API get it right */
+	/* Let PCI API get it right */
+	writel(0, &regs->erbar);
 #endif
-	(void) ioc3_r_etcdc();			/* Clear on read */
-	ioc3_w_ercsr(15);			/* RX low watermark  */
-	ioc3_w_ertr(0);				/* Interrupt immediately */
+	readl(&regs->etcdc);			/* Clear on read */
+	writel(15, &regs->ercsr);		/* RX low watermark  */
+	writel(0, &regs->ertr);			/* Interrupt immediately */
 	__ioc3_set_mac_address(dev);
-	ioc3_w_ehar_h(ip->ehar_h);
-	ioc3_w_ehar_l(ip->ehar_l);
-	ioc3_w_ersr(42);			/* XXX should be random */
+	writel(ip->ehar_h, &regs->ehar_h);
+	writel(ip->ehar_l, &regs->ehar_l);
+	writel(42, &regs->ersr);		/* XXX should be random */
 
 	ioc3_init_rings(dev);
 
 	ip->emcr |= ((RX_OFFSET / 2) << EMCR_RXOFF_SHIFT) | EMCR_TXDMAEN |
 	             EMCR_TXEN | EMCR_RXDMAEN | EMCR_RXEN | EMCR_PADEN;
-	ioc3_w_emcr(ip->emcr);
-	ioc3_w_eier(EISR_RXTIMERINT | EISR_RXOFLO | EISR_RXBUFOFLO |
-	            EISR_RXMEMERR | EISR_RXPARERR | EISR_TXBUFUFLO |
-	            EISR_TXEXPLICIT | EISR_TXMEMERR);
-	(void) ioc3_r_eier();
+	writel(ip->emcr, &regs->emcr);
+	writel(EISR_RXTIMERINT | EISR_RXOFLO | EISR_RXBUFOFLO |
+	       EISR_RXMEMERR | EISR_RXPARERR | EISR_TXBUFUFLO |
+	       EISR_TXEXPLICIT | EISR_TXMEMERR, &regs->eier);
+	readl(&regs->eier);
 }
 
 static inline void ioc3_stop(struct ioc3_private *ip)
 {
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
 
-	ioc3_w_emcr(0);				/* Shutup */
-	ioc3_w_eier(0);				/* Disable interrupts */
-	(void) ioc3_r_eier();			/* Flush */
+	writel(0, &regs->emcr);			/* Shutup */
+	writel(0, &regs->eier);			/* Disable interrupts */
+	readl(&regs->eier);			/* Flush */
 }
 
 static int ioc3_open(struct net_device *dev)
@@ -1153,16 +1101,18 @@ static void ioc3_8250_register(struct ioc3_uartregs __iomem *uart)
 	};
 	unsigned char lcr;
 
-	lcr = uart->iu_lcr;
-	uart->iu_lcr = lcr | UART_LCR_DLAB;
-	uart->iu_scr = COSMISC_CONSTANT,
-	uart->iu_lcr = lcr;
-	uart->iu_lcr;
+	lcr = readb(&uart->iu_lcr);
+	writeb(lcr | UART_LCR_DLAB, &uart->iu_lcr);
+	writeb(COSMISC_CONSTANT, &uart->iu_scr);
+	writeb(lcr, &uart->iu_lcr);
+	readb(&uart->iu_lcr);
 	serial8250_register_8250_port(&port);
 }
 
 static void ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
 {
+	u32 sio_iec;
+
 	/*
 	 * We need to recognice and treat the fourth MENET serial as it
 	 * does not have an SuperIO chip attached to it, therefore attempting
@@ -1179,29 +1129,31 @@ static void ioc3_serial_probe(struct pci_dev *pdev, struct ioc3 *ioc3)
 	 * Switch IOC3 to PIO mode.  It probably already was but let's be
 	 * paranoid
 	 */
-	ioc3->gpcr_s = GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL;
-	ioc3->gpcr_s;
-	ioc3->gppr_6 = 0;
-	ioc3->gppr_6;
-	ioc3->gppr_7 = 0;
-	ioc3->gppr_7;
-	ioc3->sscr_a = ioc3->sscr_a & ~SSCR_DMA_EN;
-	ioc3->sscr_a;
-	ioc3->sscr_b = ioc3->sscr_b & ~SSCR_DMA_EN;
-	ioc3->sscr_b;
+	writel(GPCR_UARTA_MODESEL | GPCR_UARTB_MODESEL, &ioc3->gpcr_s);
+	readl(&ioc3->gpcr_s);
+	writel(0, &ioc3->gppr[6]);
+	readl(&ioc3->gppr[6]);
+	writel(0, &ioc3->gppr[7]);
+	readl(&ioc3->gppr[7]);
+	writel(readl(&ioc3->port_a.sscr) & ~SSCR_DMA_EN, &ioc3->port_a.sscr);
+	readl(&ioc3->port_a.sscr);
+	writel(readl(&ioc3->port_b.sscr) & ~SSCR_DMA_EN, &ioc3->port_b.sscr);
+	readl(&ioc3->port_b.sscr);
 	/* Disable all SA/B interrupts except for SA/B_INT in SIO_IEC. */
-	ioc3->sio_iec &= ~ (SIO_IR_SA_TX_MT | SIO_IR_SA_RX_FULL |
-			    SIO_IR_SA_RX_HIGH | SIO_IR_SA_RX_TIMER |
-			    SIO_IR_SA_DELTA_DCD | SIO_IR_SA_DELTA_CTS |
-			    SIO_IR_SA_TX_EXPLICIT | SIO_IR_SA_MEMERR);
-	ioc3->sio_iec |= SIO_IR_SA_INT;
-	ioc3->sscr_a = 0;
-	ioc3->sio_iec &= ~ (SIO_IR_SB_TX_MT | SIO_IR_SB_RX_FULL |
-			    SIO_IR_SB_RX_HIGH | SIO_IR_SB_RX_TIMER |
-			    SIO_IR_SB_DELTA_DCD | SIO_IR_SB_DELTA_CTS |
-			    SIO_IR_SB_TX_EXPLICIT | SIO_IR_SB_MEMERR);
-	ioc3->sio_iec |= SIO_IR_SB_INT;
-	ioc3->sscr_b = 0;
+	sio_iec = readl(&ioc3->sio_iec);
+	sio_iec &= ~(SIO_IR_SA_TX_MT | SIO_IR_SA_RX_FULL |
+		     SIO_IR_SA_RX_HIGH | SIO_IR_SA_RX_TIMER |
+		     SIO_IR_SA_DELTA_DCD | SIO_IR_SA_DELTA_CTS |
+		     SIO_IR_SA_TX_EXPLICIT | SIO_IR_SA_MEMERR);
+	sio_iec |= SIO_IR_SA_INT;
+	sio_iec &= ~(SIO_IR_SB_TX_MT | SIO_IR_SB_RX_FULL |
+		     SIO_IR_SB_RX_HIGH | SIO_IR_SB_RX_TIMER |
+		     SIO_IR_SB_DELTA_DCD | SIO_IR_SB_DELTA_CTS |
+		     SIO_IR_SB_TX_EXPLICIT | SIO_IR_SB_MEMERR);
+	sio_iec |= SIO_IR_SB_INT;
+	writel(sio_iec, &ioc3->sio_iec);
+	writel(0, &ioc3->port_a.sscr);
+	writel(0, &ioc3->port_b.sscr);
 
 	ioc3_8250_register(&ioc3->sregs.uarta);
 	ioc3_8250_register(&ioc3->sregs.uartb);
@@ -1282,7 +1234,9 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = -ENOMEM;
 		goto out_res;
 	}
-	ip->regs = ioc3;
+	ip->regs = &ioc3->eth;
+	ip->ssram = ioc3->ssram;
+	ip->all_regs = ioc3;
 
 #ifdef CONFIG_SERIAL_8250
 	ioc3_serial_probe(pdev, ioc3);
@@ -1363,12 +1317,11 @@ static void ioc3_remove_one(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
 
 	unregister_netdev(dev);
 	del_timer_sync(&ip->ioc3_timer);
 
-	iounmap(ioc3);
+	iounmap(ip->all_regs);
 	pci_release_regions(pdev);
 	free_netdev(dev);
 	/*
@@ -1392,11 +1345,10 @@ static struct pci_driver ioc3_driver = {
 
 static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	unsigned long data;
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
-	unsigned int len;
 	struct ioc3_etxd *desc;
+	unsigned long data;
+	unsigned int len;
 	uint32_t w0 = 0;
 	int produce;
 
@@ -1489,7 +1441,7 @@ static netdev_tx_t ioc3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	ip->tx_skbs[produce] = skb;			/* Remember skb */
 	produce = (produce + 1) & 127;
 	ip->tx_pi = produce;
-	ioc3_w_etpir(produce << 7);			/* Fire ... */
+	writel(produce << 7, &ip->regs->etpir);		/* Fire ... */
 
 	ip->txqlen++;
 
@@ -1623,21 +1575,21 @@ static int ioc3_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 static void ioc3_set_multicast_list(struct net_device *dev)
 {
-	struct netdev_hw_addr *ha;
 	struct ioc3_private *ip = netdev_priv(dev);
-	struct ioc3 *ioc3 = ip->regs;
+	struct ioc3_ethregs *regs = ip->regs;
+	struct netdev_hw_addr *ha;
 	u64 ehar = 0;
 
 	netif_stop_queue(dev);				/* Lock out others. */
 
 	if (dev->flags & IFF_PROMISC) {			/* Set promiscuous.  */
 		ip->emcr |= EMCR_PROMISC;
-		ioc3_w_emcr(ip->emcr);
-		(void) ioc3_r_emcr();
+		writel(ip->emcr, &regs->emcr);
+		readl(&regs->emcr);
 	} else {
 		ip->emcr &= ~EMCR_PROMISC;
-		ioc3_w_emcr(ip->emcr);			/* Clear promiscuous. */
-		(void) ioc3_r_emcr();
+		writel(ip->emcr, &regs->emcr);		/* Clear promiscuous. */
+		readl(&regs->emcr);
 
 		if ((dev->flags & IFF_ALLMULTI) ||
 		    (netdev_mc_count(dev) > 64)) {
@@ -1653,8 +1605,8 @@ static void ioc3_set_multicast_list(struct net_device *dev)
 			ip->ehar_h = ehar >> 32;
 			ip->ehar_l = ehar & 0xffffffff;
 		}
-		ioc3_w_ehar_h(ip->ehar_h);
-		ioc3_w_ehar_l(ip->ehar_l);
+		writel(ip->ehar_h, &regs->ehar_h);
+		writel(ip->ehar_l, &regs->ehar_l);
 	}
 
 	netif_wake_queue(dev);			/* Let us get going again. */
-- 
2.13.7

