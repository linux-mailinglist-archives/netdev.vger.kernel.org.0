Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F59F1488C7
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392553AbgAXOat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgAXOUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D4212087E;
        Fri, 24 Jan 2020 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875639;
        bh=3W4e0XKZhhaF9tAaPYZ+RQC+VzFFoSU+Mwv6uq38g9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i22zTd5awPNs/YXFw2e07AQZ7J4sa/y0s4PMI1G4hwHpWAjgyGtGSjRWSPrtHW8dI
         rRFhYJvAuay6V+tNqN/37w4j73OPXpc0Me14MOJhyH1rIbVsug0LnAnFLOP4eK4TJF
         ZU3fMA4MGBdJuhtvLYX9ScU6/oP6oTXxm+2IiRx8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 23/56] sh_eth: check sh_eth_cpu_data::dual_port when dumping registers
Date:   Fri, 24 Jan 2020 09:19:39 -0500
Message-Id: <20200124142012.29752-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit 3249b1e442a1be1a6b9f1026785b519d1443f807 ]

When adding the sh_eth_cpu_data::dual_port flag I forgot to add the flag
checks to __sh_eth_get_regs(), causing the non-existing TSU registers to
be dumped by 'ethtool' on the single port Ether controllers having TSU...

Fixes: a94cf2a614f8 ("sh_eth: fix TSU init on SH7734/R8A7740")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 38 +++++++++++++++------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 5e3e6e262ba37..6068e96f5ac1e 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2184,24 +2184,28 @@ static size_t __sh_eth_get_regs(struct net_device *ndev, u32 *buf)
 	if (cd->tsu) {
 		add_tsu_reg(ARSTR);
 		add_tsu_reg(TSU_CTRST);
-		add_tsu_reg(TSU_FWEN0);
-		add_tsu_reg(TSU_FWEN1);
-		add_tsu_reg(TSU_FCM);
-		add_tsu_reg(TSU_BSYSL0);
-		add_tsu_reg(TSU_BSYSL1);
-		add_tsu_reg(TSU_PRISL0);
-		add_tsu_reg(TSU_PRISL1);
-		add_tsu_reg(TSU_FWSL0);
-		add_tsu_reg(TSU_FWSL1);
+		if (cd->dual_port) {
+			add_tsu_reg(TSU_FWEN0);
+			add_tsu_reg(TSU_FWEN1);
+			add_tsu_reg(TSU_FCM);
+			add_tsu_reg(TSU_BSYSL0);
+			add_tsu_reg(TSU_BSYSL1);
+			add_tsu_reg(TSU_PRISL0);
+			add_tsu_reg(TSU_PRISL1);
+			add_tsu_reg(TSU_FWSL0);
+			add_tsu_reg(TSU_FWSL1);
+		}
 		add_tsu_reg(TSU_FWSLC);
-		add_tsu_reg(TSU_QTAGM0);
-		add_tsu_reg(TSU_QTAGM1);
-		add_tsu_reg(TSU_FWSR);
-		add_tsu_reg(TSU_FWINMK);
-		add_tsu_reg(TSU_ADQT0);
-		add_tsu_reg(TSU_ADQT1);
-		add_tsu_reg(TSU_VTAG0);
-		add_tsu_reg(TSU_VTAG1);
+		if (cd->dual_port) {
+			add_tsu_reg(TSU_QTAGM0);
+			add_tsu_reg(TSU_QTAGM1);
+			add_tsu_reg(TSU_FWSR);
+			add_tsu_reg(TSU_FWINMK);
+			add_tsu_reg(TSU_ADQT0);
+			add_tsu_reg(TSU_ADQT1);
+			add_tsu_reg(TSU_VTAG0);
+			add_tsu_reg(TSU_VTAG1);
+		}
 		add_tsu_reg(TSU_ADSBSY);
 		add_tsu_reg(TSU_TEN);
 		add_tsu_reg(TSU_POST1);
-- 
2.20.1

