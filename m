Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903AC1A5887
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgDKXaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbgDKXKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 088482166E;
        Sat, 11 Apr 2020 23:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646632;
        bh=MdlG+GcXctz4ZHmEEK+eSLEy25eWy8aqvJH1dZzKMDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RG4IPJYHUpWynBi9QQcZYoZ1cIjN6p1Lf6zwqcHTaef2fZgt3tj/StfMgRmXbplEL
         f2wXCZPgxSuAcVZ2FzGcoojemSAHfkfgEGk/NbzxH/phkJRchsshbuA3MYNrMOo5XZ
         nBDtiVoTsBGOWqtBUYhzw+CPpbhTSyPyZzNrBooY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 040/108] sh_eth: check sh_eth_cpu_data::no_xdfar when dumping registers
Date:   Sat, 11 Apr 2020 19:08:35 -0400
Message-Id: <20200411230943.24951-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit 7bf47f609f7eaac4f7e9c407a85ad78997288a38 ]

When adding the sh_eth_cpu_data::no_xdfar flag I forgot to add the flag
check to  __sh_eth_get_regs(), causing the non-existing RDFAR/TDFAR to be
considered for dumping on the R-Car gen1/2 SoCs (the register offset check
has the final say here)...

Fixes: 4c1d45850d5 ("sh_eth: add sh_eth_cpu_data::cexcr flag")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 59f5db1ef29e9..7440da726d68f 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2140,11 +2140,13 @@ static size_t __sh_eth_get_regs(struct net_device *ndev, u32 *buf)
 	add_reg(EESR);
 	add_reg(EESIPR);
 	add_reg(TDLAR);
-	add_reg(TDFAR);
+	if (!cd->no_xdfar)
+		add_reg(TDFAR);
 	add_reg(TDFXR);
 	add_reg(TDFFR);
 	add_reg(RDLAR);
-	add_reg(RDFAR);
+	if (!cd->no_xdfar)
+		add_reg(RDFAR);
 	add_reg(RDFXR);
 	add_reg(RDFFR);
 	add_reg(TRSCER);
-- 
2.20.1

