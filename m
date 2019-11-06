Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70D80F138E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbfKFKMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:12:45 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41010 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727257AbfKFKMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:12:44 -0500
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6ABnYf015178;
        Wed, 6 Nov 2019 11:12:27 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=8qOd10w9hoYCJyi/2Rbap3apd+BpOD74qFKDt1hG8ng=;
 b=Es73D/nEAVypIDQTGrhni6kNsmkv5WeXwTVZSCjpTOZXMcr7tPiJKhmb2emFz+8OibYm
 uKYcMkxOwjocGfb0rAlDazFbQME3siJIBx0fi793URfUyQFtD8H+3lD9CXIvLBOn8Y2o
 fCI/v0zEPu4YvqENhIX+iHzKIzlgtMg43fCKr/AUuk8vGafSSLVncdW7NAeQZfGv/Y3q
 lWaIVlAlN5FwoLiwT+6/6pf4cdLbYifivNTHWL78YAOKd//1szRxSNAK6qw6WCHhhH4x
 W17tVe80xpWbpMVYuPAKrfhicerUPUJig9UNSm4DaD62VQZsEjVtncpCvMdP0W/QtaQX sw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w11jnd2vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Nov 2019 11:12:27 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id ADC6A10003E;
        Wed,  6 Nov 2019 11:12:22 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 963FB2AD343;
        Wed,  6 Nov 2019 11:12:22 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019
 11:12:22 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Wed, 6 Nov 2019 11:12:21
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V3 net-next 0/4] net: ethernet: stmmac: cleanup clock and optimization
Date:   Wed, 6 Nov 2019 11:12:16 +0100
Message-ID: <20191106101220.12693-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_02:2019-11-06,2019-11-06 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements: 
 - manage syscfg as optional clock, 
 - update slew rate of ETH_MDIO pin, 
 - Enable gating of the MAC TX clock during TX low-power mode

V3: Update with Andrew Lunn remark

Christophe Roullier (4):
  net: ethernet: stmmac: Add support for syscfg clock
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 ++++--
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 ++---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 28 +++++++++++--------
 3 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.17.1

