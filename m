Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDC02F30E3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbhALNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:12:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390385AbhALM54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC359236F9;
        Tue, 12 Jan 2021 12:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456216;
        bh=hFIOfH+hro2qgV4reHOMhXX2n/F4QodE6AHLGwF4bdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwfNq/wQU8TKHh/rWeBswMhgbu1isrfheax9qCqk8cuwhxXWSy9fA5rhY3FNaUPds
         aO3pDPTLsfEPaWN6QQweYUaHyv+0c073uaW4eNy5DRjnYeET5IctDJGUBPIqS+hYWz
         b+8bB/OAnn9yRg3AUAvr/40AKmAOqBFQ6Ua+zazJ4vP7DOKqBDpLPviA3UQDwxrqbx
         8PTudhiIDLRRJotJ8RORFqEmkb08AcsFcQlwckH5ux2r4PD/dBuC6yqUtp67x3Kl5i
         lT/JVxofA6VSAjlyyFCgN841dtIKI2UGNv3VMAJkF+geOlO9MijBwheIyAi39R9BlK
         cWJN4kcj9j+dQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 08/28] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
Date:   Tue, 12 Jan 2021 07:56:24 -0500
Message-Id: <20210112125645.70739-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

[ Upstream commit 887078de2a23689e29d6fa1b75d7cbc544c280be ]

Table 8-53 in the QUICC Engine Reference manual shows definitions of
fields up to a size of 192 bytes, not just 128. But in table 8-111,
one does find the text

  Base Address of the Global Transmitter Parameter RAM Page. [...]
  The user needs to allocate 128 bytes for this page. The address must
  be aligned to the page size.

I've checked both rev. 7 (11/2015) and rev. 9 (05/2018) of the manual;
they both have this inconsistency (and the table numbers are the
same).

Adding a bit of debug printing, on my board the struct
ucc_geth_tx_global_pram is allocated at offset 0x880, while
the (opaque) ucc_geth_thread_data_tx gets allocated immediately
afterwards, at 0x900. So whatever the engine writes into the thread
data overlaps with the tail of the global tx pram (and devmem says
that something does get written during a simple ping).

I haven't observed any failure that could be attributed to this, but
it seems to be the kind of thing that would be extremely hard to
debug. So extend the struct definition so that we do allocate 192
bytes.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/ucc_geth.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.h b/drivers/net/ethernet/freescale/ucc_geth.h
index a86a42131fc71..b00fbef612cfe 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -576,7 +576,14 @@ struct ucc_geth_tx_global_pram {
 	u32 vtagtable[0x8];	/* 8 4-byte VLAN tags */
 	u32 tqptr;		/* a base pointer to the Tx Queues Memory
 				   Region */
-	u8 res2[0x80 - 0x74];
+	u8 res2[0x78 - 0x74];
+	u64 snums_en;
+	u32 l2l3baseptr;	/* top byte consists of a few other bit fields */
+
+	u16 mtu[8];
+	u8 res3[0xa8 - 0x94];
+	u32 wrrtablebase;	/* top byte is reserved */
+	u8 res4[0xc0 - 0xac];
 } __packed;
 
 /* structure representing Extended Filtering Global Parameters in PRAM */
-- 
2.27.0

