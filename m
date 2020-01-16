Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291E713F2C8
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407179AbgAPShu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:37:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390549AbgAPRMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35A102469B;
        Thu, 16 Jan 2020 17:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194763;
        bh=+LjzRZhG/asUPV6mXmu3rlMw0EJxr7fb6ki0KxCziZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haCFxe/sDJyXUtzlFTQ3G1tZqAbmtIZ09mCv4K+MQorLEMCkj1o9I0avcbn1adcGl
         0dRFuZXF6S/txlcsn/YHSAVZE1cwj8nVJa/UE+wAbtX3nF3BUgDLt9Ghf8q1OF1LXI
         Ru+d9r8MFRsbZvHFbXr63Vfz88v7gWIHCz1new6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antonio Borneo <antonio.borneo@st.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 584/671] net: stmmac: fix disabling flexible PPS output
Date:   Thu, 16 Jan 2020 12:03:42 -0500
Message-Id: <20200116170509.12787-321-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antonio Borneo <antonio.borneo@st.com>

[ Upstream commit 520cf6002147281d1e7b522bb338416b623dcb93 ]

Accordingly to Synopsys documentation [1] and [2], when bit PPSEN0
in register MAC_PPS_CONTROL is set it selects the functionality
command in the same register, otherwise selects the functionality
control.
Command functionality is required to either enable (command 0x2)
and disable (command 0x5) the flexible PPS output, but the bit
PPSEN0 is currently set only for enabling.

Set the bit PPSEN0 to properly disable flexible PPS output.

Tested on STM32MP15x, based on dwmac 4.10a.

[1] DWC Ethernet QoS Databook 4.10a October 2014
[2] DWC Ethernet QoS Databook 5.00a September 2017

Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
Fixes: 9a8a02c9d46d ("net: stmmac: Add Flexible PPS support")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 3f4f3132e16b..e436fa160c7d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -515,6 +515,7 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 
 	if (!enable) {
 		val |= PPSCMDx(index, 0x5);
+		val |= PPSEN0;
 		writel(val, ioaddr + MAC_PPS_CONTROL);
 		return 0;
 	}
-- 
2.20.1

