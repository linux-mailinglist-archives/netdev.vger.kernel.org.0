Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99D1A57B8
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbgDKXYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:24:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgDKXMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:12:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968B920708;
        Sat, 11 Apr 2020 23:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646757;
        bh=Tm+Gv3r0kwh9oKuspeovhFX4K2Ys3zHo2UE/OiVpUFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+uAg4NbiVLIRKpe57qM7/Ev306OZc+B8Leo+4jJFJbm6ZhcIzjdjch0HcIWiu0W8
         ccaAK3R+bsMdxahXuMpu2FAEBYqmDoHgPpm6FF2OqidK8tgYXiRGG/X7+c3aKzyAbV
         M+vMXBRPkhbAChj/bvFSwffAFldd+ETCx/RuYC0U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Chris Brandt <chris.brandt@renesas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/66] sh_eth: check sh_eth_cpu_data::cexcr when dumping registers
Date:   Sat, 11 Apr 2020 19:11:25 -0400
Message-Id: <20200411231203.25933-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411231203.25933-1-sashal@kernel.org>
References: <20200411231203.25933-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit f75ca32403dbf91e20c275719aab705401b9e718 ]

When adding the sh_eth_cpu_data::cexcr flag I forgot to add the flag
check to  __sh_eth_get_regs(), causing the non-existing RX packet counter
registers to be considered for dumping on  the R7S72100 SoC (the register
offset sanity check has the final say here)...

Fixes: 4c1d45850d5 ("sh_eth: add sh_eth_cpu_data::cexcr flag")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 9e735b52b85fb..7d3207d2d6d6d 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2174,8 +2174,10 @@ static size_t __sh_eth_get_regs(struct net_device *ndev, u32 *buf)
 	add_reg(FRECR);
 	add_reg(TSFRCR);
 	add_reg(TLFRCR);
-	add_reg(CERCR);
-	add_reg(CEECR);
+	if (cd->cexcr) {
+		add_reg(CERCR);
+		add_reg(CEECR);
+	}
 	add_reg(MAFCR);
 	if (cd->rtrate)
 		add_reg(RTRATE);
-- 
2.20.1

