Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12AEA1A5AD5
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgDKXE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727573AbgDKXEx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:04:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37E6720CC7;
        Sat, 11 Apr 2020 23:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646294;
        bh=FhwNWTInCUchQv6U+o9vDwjfJz9PnhafWTOYo4ykAIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g0bmSSvl9B9qzxkBiW16+ZoA8Qkh48VX0VRVvDewzkbPq/To7Ua+iwKwKmbgJVMNv
         bv5K2/rp+xMuM29rNGzT5erJF5h4apSZx4xm8qW8ySkGcLen4dPNz2Op0AgJOeTARK
         U3KzLl5Cc1nApQieatJzhY1TP5hitAFevQLtrRSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 054/149] sh_eth: check sh_eth_cpu_data::no_tx_cntrs when dumping registers
Date:   Sat, 11 Apr 2020 19:02:11 -0400
Message-Id: <20200411230347.22371-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit 6eaeedc1aa27a423bd89043705eca39215015bb3 ]

When adding the sh_eth_cpu_data::no_tx_cntrs flag I forgot to add the
flag check to  __sh_eth_get_regs(), causing the non-existing TX counter
registers to be considered for dumping on the R7S72100 SoC (the register
offset sanity check has the final say here)...

Fixes: ce9134dff6d9 ("sh_eth: add sh_eth_cpu_data::no_tx_cntrs flag")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 58ca126518a22..cd1f5842b1310 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2184,10 +2184,12 @@ static size_t __sh_eth_get_regs(struct net_device *ndev, u32 *buf)
 		add_reg(BCULR);
 	add_reg(MAHR);
 	add_reg(MALR);
-	add_reg(TROCR);
-	add_reg(CDCR);
-	add_reg(LCCR);
-	add_reg(CNDCR);
+	if (!cd->no_tx_cntrs) {
+		add_reg(TROCR);
+		add_reg(CDCR);
+		add_reg(LCCR);
+		add_reg(CNDCR);
+	}
 	add_reg(CEFCR);
 	add_reg(FRECR);
 	add_reg(TSFRCR);
-- 
2.20.1

