Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494822F300A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbhALNBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:01:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390371AbhALM6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A76523130;
        Tue, 12 Jan 2021 12:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456307;
        bh=H31ckD32uFz5u09DVKuu1oHK6MaIgGfh0EAyr2/a5u8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eV5R8bfLXjjTkgEctEeQ6+7FJd3FuGAv6B1GiLGIIuRng0+rz6ySCtO/HujV7lhZg
         hbX+DijTax4A+0SsnGloTG8G01g25d53xAVLGhXEUwu7L6AxlrA0ysbrF1Md3e771r
         3+Omk5Ze4Pg2HF5nMfjeEhteSvFyzSzoHqlLIKKs52xWTq97ZvOFMpJE7kE+2IigtR
         7kgI0kPCDJyCZYRlCaITFKlJb476ZMnRtdBp8lrP3Kkcc4/PnYbwmZPdEX+Y2ol+XA
         BLUzaHrVaZCtF3xrYzAy3CrcL5AxbKidkl5fDUpv513VMKiwcVUJkrtvcczQ6WSLpP
         s9S2Mg76vXraA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.4 2/8] ethernet: ucc_geth: fix definition and size of ucc_geth_tx_global_pram
Date:   Tue, 12 Jan 2021 07:58:17 -0500
Message-Id: <20210112125823.71463-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125823.71463-1-sashal@kernel.org>
References: <20210112125823.71463-1-sashal@kernel.org>
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
index 75f337163ce3c..1a40a5f11081b 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.h
+++ b/drivers/net/ethernet/freescale/ucc_geth.h
@@ -580,7 +580,14 @@ struct ucc_geth_tx_global_pram {
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

