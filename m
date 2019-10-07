Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6D7ECE818
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfJGPng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:43:36 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57812 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728552AbfJGPnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:43:35 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x97FR4s5010335;
        Mon, 7 Oct 2019 17:43:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=STMicroelectronics;
 bh=F2nmdBj0FoWdFw4qxwGsJgaztWqFmLqoBCS6qM87rok=;
 b=WzVkM83jKSXKgBWgGZKtuAymZMgFEQZKjiPeuNgLrmLa7Nu2TW+2WC9FEq4nXeBd1217
 ZmacNofFfKfskSXyDT9VcS2477whBVt+ugn1sKv71DnKZag9ZWW5IJ25SgloTyWnd5tq
 c5PBeylXg8BY89fcqotdybiu3lHAaEimP0TLDfx3UYeL0qtYpt7gBXIcqKokCoNS8+1c
 iL2rgf20FcSmH59OcUc+GFKgKNrS6cQsk1Bi6uAxAgPepQfU84SqdTpWOw+aWPmzK1ha
 aiEUArQJOD2EAYqxKpD/GqpxOLgGXI0upO5ZkNjY8T/32Yr0lN6UCCSTCEX809Xl/23f RA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2vej2p35ke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Oct 2019 17:43:19 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 715B4100038;
        Mon,  7 Oct 2019 17:43:19 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 696122B1E43;
        Mon,  7 Oct 2019 17:43:19 +0200 (CEST)
Received: from localhost (10.75.127.49) by SFHDAG5NODE3.st.com (10.75.127.15)
 with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Oct 2019 17:43:19
 +0200
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Antonio Borneo <antonio.borneo@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: fix disabling flexible PPS output
Date:   Mon, 7 Oct 2019 17:43:05 +0200
Message-ID: <20191007154306.95827-4-antonio.borneo@st.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191007154306.95827-1-antonio.borneo@st.com>
References: <20191007154306.95827-1-antonio.borneo@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-07_03:2019-10-07,2019-10-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.23.0

