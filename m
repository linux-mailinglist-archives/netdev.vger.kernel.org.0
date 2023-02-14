Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30EA6960D7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjBNKe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjBNKe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:34:58 -0500
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A89A222F8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:34:56 -0800 (PST)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id RseEpCV6Kar8pRseEpAfEj; Tue, 14 Feb 2023 11:34:54 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 14 Feb 2023 11:34:54 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Mark Brown <broonie@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-spi@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] spi: Reorder fields in 'struct spi_transfer'
Date:   Tue, 14 Feb 2023 11:34:50 +0100
Message-Id: <93a051da85a895bc6003aedfb00a13e1c2fc6338.1676370870.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Group some variables based on their sizes to reduce hole and avoid padding.
On x86_64, this shrinks the size from 144 to 128 bytes.

Turn 'timestamped' into a bitfield so that it can be easily merged with
some other bifields and move 'error'.

This should have no real impact on memory allocation because 'struct
spi_transfer' is mostly used on stack, but it can save a few cycles
when the structure is initialized or copied.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Using pahole

Before:
======
struct spi_transfer {
	const void  *              tx_buf;               /*     0     8 */
	void *                     rx_buf;               /*     8     8 */
	unsigned int               len;                  /*    16     4 */

	/* XXX 4 bytes hole, try to pack */

	dma_addr_t                 tx_dma;               /*    24     8 */
	dma_addr_t                 rx_dma;               /*    32     8 */
	struct sg_table            tx_sg;                /*    40    16 */
	struct sg_table            rx_sg;                /*    56    16 */
	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
	unsigned int               dummy_data:1;         /*    72: 0  4 */
	unsigned int               cs_off:1;             /*    72: 1  4 */
	unsigned int               cs_change:1;          /*    72: 2  4 */
	unsigned int               tx_nbits:3;           /*    72: 3  4 */
	unsigned int               rx_nbits:3;           /*    72: 6  4 */

	/* XXX 7 bits hole, try to pack */
	/* Bitfield combined with next fields */

	u8                         bits_per_word;        /*    74     1 */

	/* XXX 1 byte hole, try to pack */

	struct spi_delay           delay;                /*    76     4 */

	/* XXX last struct has 1 byte of padding */

	struct spi_delay           cs_change_delay;      /*    80     4 */

	/* XXX last struct has 1 byte of padding */

	struct spi_delay           word_delay;           /*    84     4 */

	/* XXX last struct has 1 byte of padding */

	u32                        speed_hz;             /*    88     4 */
	u32                        effective_speed_hz;   /*    92     4 */
	unsigned int               ptp_sts_word_pre;     /*    96     4 */
	unsigned int               ptp_sts_word_post;    /*   100     4 */
	struct ptp_system_timestamp * ptp_sts;           /*   104     8 */
	bool                       timestamped;          /*   112     1 */

	/* XXX 7 bytes hole, try to pack */

	struct list_head           transfer_list;        /*   120    16 */
	/* --- cacheline 2 boundary (128 bytes) was 8 bytes ago --- */
	u16                        error;                /*   136     2 */

	/* size: 144, cachelines: 3, members: 24 */
	/* sum members: 124, holes: 3, sum holes: 12 */
	/* sum bitfield members: 9 bits, bit holes: 1, sum bit holes: 7 bits */
	/* padding: 6 */
	/* paddings: 3, sum paddings: 3 */
	/* last cacheline: 16 bytes */
};


After:
=====
struct spi_transfer {
	const void  *              tx_buf;               /*     0     8 */
	void *                     rx_buf;               /*     8     8 */
	unsigned int               len;                  /*    16     4 */
	u16                        error;                /*    20     2 */

	/* XXX 2 bytes hole, try to pack */

	dma_addr_t                 tx_dma;               /*    24     8 */
	dma_addr_t                 rx_dma;               /*    32     8 */
	struct sg_table            tx_sg;                /*    40    16 */
	struct sg_table            rx_sg;                /*    56    16 */
	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
	unsigned int               dummy_data:1;         /*    72: 0  4 */
	unsigned int               cs_off:1;             /*    72: 1  4 */
	unsigned int               cs_change:1;          /*    72: 2  4 */
	unsigned int               tx_nbits:3;           /*    72: 3  4 */
	unsigned int               rx_nbits:3;           /*    72: 6  4 */
	unsigned int               timestamped:1;        /*    72: 9  4 */

	/* XXX 6 bits hole, try to pack */
	/* Bitfield combined with next fields */

	u8                         bits_per_word;        /*    74     1 */

	/* XXX 1 byte hole, try to pack */

	struct spi_delay           delay;                /*    76     4 */

	/* XXX last struct has 1 byte of padding */

	struct spi_delay           cs_change_delay;      /*    80     4 */

	/* XXX last struct has 1 byte of padding */

	struct spi_delay           word_delay;           /*    84     4 */

	/* XXX last struct has 1 byte of padding */

	u32                        speed_hz;             /*    88     4 */
	u32                        effective_speed_hz;   /*    92     4 */
	unsigned int               ptp_sts_word_pre;     /*    96     4 */
	unsigned int               ptp_sts_word_post;    /*   100     4 */
	struct ptp_system_timestamp * ptp_sts;           /*   104     8 */
	struct list_head           transfer_list;        /*   112    16 */

	/* size: 128, cachelines: 2, members: 24 */
	/* sum members: 123, holes: 2, sum holes: 3 */
	/* sum bitfield members: 10 bits, bit holes: 1, sum bit holes: 6 bits */
	/* paddings: 3, sum paddings: 3 */
};
---
 drivers/spi/spi.c       | 2 +-
 include/linux/spi/spi.h | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9f5c6b9f5135..44b85a8d47f1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1927,7 +1927,7 @@ void spi_take_timestamp_post(struct spi_controller *ctlr,
 	/* Capture the resolution of the timestamp */
 	xfer->ptp_sts_word_post = progress;
 
-	xfer->timestamped = true;
+	xfer->timestamped = 1;
 }
 EXPORT_SYMBOL_GPL(spi_take_timestamp_post);
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 988aabc31871..4fa26b9a3572 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1022,6 +1022,9 @@ struct spi_transfer {
 	void		*rx_buf;
 	unsigned	len;
 
+#define SPI_TRANS_FAIL_NO_START	BIT(0)
+	u16		error;
+
 	dma_addr_t	tx_dma;
 	dma_addr_t	rx_dma;
 	struct sg_table tx_sg;
@@ -1032,6 +1035,7 @@ struct spi_transfer {
 	unsigned	cs_change:1;
 	unsigned	tx_nbits:3;
 	unsigned	rx_nbits:3;
+	unsigned	timestamped:1;
 #define	SPI_NBITS_SINGLE	0x01 /* 1bit transfer */
 #define	SPI_NBITS_DUAL		0x02 /* 2bits transfer */
 #define	SPI_NBITS_QUAD		0x04 /* 4bits transfer */
@@ -1048,12 +1052,7 @@ struct spi_transfer {
 
 	struct ptp_system_timestamp *ptp_sts;
 
-	bool		timestamped;
-
 	struct list_head transfer_list;
-
-#define SPI_TRANS_FAIL_NO_START	BIT(0)
-	u16		error;
 };
 
 /**
-- 
2.34.1

