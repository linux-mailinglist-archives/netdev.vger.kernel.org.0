Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43277EE107
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfKDNZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:25:56 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51508 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728188AbfKDNZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 08:25:55 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA4DNHxF017943;
        Mon, 4 Nov 2019 14:25:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=BRI5gcX+2AxiXlkddRX1j9VwcDYoWSzReQ63qtXx2AM=;
 b=EFXEq5nLGyJwzYxmGcphNpH7fLQU299jUVVmBVWl5v3Z4ubkJR5ZcwcXEIBoI7BQqeFE
 7K+7/8wIfHDAZgDvjxfwazQKyWhEgUIi2V7lyGWEy/ZObzfdoTGlWzcG9rkcpGfkP84w
 lIJ/gte0iC7FF/RIVJTtrE8GlO1sw1Ac6CnLDPfzNSQZdTDwTmxhu8NIXMHZy6Y+izjC
 LRASgBMyewb0j0eu2KA/qxsz1Re/uj4p88i9HBRJfod1/dMZht5DQmFIsgLZFDtBzPK5
 LHjm2A2EqGXgiAp1SKdZUOORKKrwC3BXp0XbWUiP8gAk98O8mj5K8W3cWN3cJzJFGT5Q zA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w11jn1v9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Nov 2019 14:25:37 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 48A3E10002A;
        Mon,  4 Nov 2019 14:25:36 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2BD972BFC79;
        Mon,  4 Nov 2019 14:25:36 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019
 14:25:36 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 4 Nov 2019 14:25:35
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH net-next 0/4] net: ethernet: stmmac: cleanup clock and optimization
Date:   Mon, 4 Nov 2019 14:25:29 +0100
Message-ID: <20191104132533.5153-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-04_08:2019-11-04,2019-11-04 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements: 
 - manage syscfg as optional clock, 
 - update slew rate of ETH_MDIO pin, 
 - Enable gating of the MAC TX clock during TX low-power mode

Christophe Roullier (4):
  net: ethernet: stmmac: Add support for syscfg clock
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 +++--
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 36 +++++++++++++------
 3 files changed, 35 insertions(+), 17 deletions(-)

-- 
2.17.1

