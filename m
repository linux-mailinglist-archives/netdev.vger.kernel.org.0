Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431C6E5C5E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfJZNUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728554AbfJZNUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 495262070B;
        Sat, 26 Oct 2019 13:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096004;
        bh=/jb/StiBkQnNp1GN92R6qCVPT5kDpfSTD9GsgwK4vug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jhbv/n13gadGqMpO3G5BWRS1SFk9k/GSFLN3DtWgxYkcRcqRnlBM1db76xwK3Oc0V
         WUypMIMcGq+24Mh3ztNDiJ2hA+GY5ZHCqqEbDIpDjd/YlvJUKpl70odSrgQOrpasbO
         scOxVzZF+5e8kzYj5fmS60j1+u5LX4mjTWWa1gt0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antonio Borneo <antonio.borneo@st.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/59] net: stmmac: fix disabling flexible PPS output
Date:   Sat, 26 Oct 2019 09:18:39 -0400
Message-Id: <20191026131910.3435-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
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
index 3f4f3132e16b3..e436fa160c7d6 100644
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

