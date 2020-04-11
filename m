Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2E81A5569
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgDKXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727896AbgDKXKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8560A2173E;
        Sat, 11 Apr 2020 23:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646630;
        bh=GpG7SgNPKRx1j9e/aqAr1om+GGdvtLD4zCJ7C3bOTrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YxjzDp413Jn2QDphTHxqthvuDCnq4r/kr9cPEWklmXyRznPH8ohC86jRSDUYoN68+
         gEU6h6APM7OPaMtW9C3I800UD2hbw0F//zXV+5t3nK0+1dplbhBdMdhpksL924fzke
         rTRpqwsmzbYm7xqHVPNccI/YFPf7Ln+gcssMrvtk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 038/108] sh_eth: check sh_eth_cpu_data::no_tx_cntrs when dumping registers
Date:   Sat, 11 Apr 2020 19:08:33 -0400
Message-Id: <20200411230943.24951-38-sashal@kernel.org>
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
index 8aa1b1bda96d1..6488d19c0b4d2 100644
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

