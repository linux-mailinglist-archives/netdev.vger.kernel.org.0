Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DEDEFD87
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 13:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388918AbfKEMpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 07:45:40 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45656 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388789AbfKEMp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 07:45:29 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5ChmrF023569;
        Tue, 5 Nov 2019 13:45:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=sXCMWOxnkEW+1vUrP3Lq9Dd4y+mfUnnBxv45mlaWJ+Y=;
 b=C1uCkmLseaAZJlx82MhOhoz6K3QuVCKLNO3igaOI5G2Z56M/km6M+MFU8ho7Mg0CiBYp
 GSL2Fi5k4nN7E7atp5EhlZfb3VdO40Vs3lhqocdNZ4pduIC5T78rwcjaBADMWUH/1Jgy
 CgZS+gv9+Un4nQvgGjYw5g8QoNLLNXVdxkC93qUj34mSavlcX6YWTUbAWFbIjFw4VDJx
 ccxPHTPf8gVW0MNw61QzXjWHYHluXFsG7yPcQQNjSeBcNDgG6QUqhxX4U5W+tEAbh3//
 mE5sPSHf+bJsLcijhAL3sji9qGKraDgVAGbIhi8qcjxfMwfqwGwtCqrCpVBtOAr4UsG2 oQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w11jn7j8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 13:45:09 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 228E7100034;
        Tue,  5 Nov 2019 13:45:08 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 0A25F2B97D9;
        Tue,  5 Nov 2019 13:45:08 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 5 Nov 2019
 13:45:07 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Tue, 5 Nov 2019 13:45:07
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V2 net-next 0/4] net: ethernet: stmmac: cleanup clock and optimization
Date:   Tue, 5 Nov 2019 13:45:01 +0100
Message-ID: <20191105124505.4738-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_04:2019-11-05,2019-11-05 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements: 
 - manage syscfg as optional clock, 
 - update slew rate of ETH_MDIO pin, 
 - Enable gating of the MAC TX clock during TX low-power mode

V2: Update with D.Miller remark

Christophe Roullier (4):
  net: ethernet: stmmac: Add support for syscfg clock
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 ++++--
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 ++--
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 32 ++++++++++++-------
 3 files changed, 31 insertions(+), 17 deletions(-)

-- 
2.17.1

