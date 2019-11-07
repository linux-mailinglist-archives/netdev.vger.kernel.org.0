Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0FAF29B0
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbfKGIsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:48:43 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:40483 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733204AbfKGIsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:48:42 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA78l9gt010906;
        Thu, 7 Nov 2019 09:48:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=rtKW3l2rzJlicglZujNA3kuhYJNSKzKPNkK0J/trcXQ=;
 b=ptRC1w6yXp9Kh+uB4pCdTkpwgtoCSz05d6BQyVzV3Gy/1Or25bGveqrNHfqVu0mxGw3s
 fbbHm2//txc87JhlKYpPTKNFqkl7NWycpce7JR29mo6Vat1WI48vpQPbuHvtSPi25b+C
 Uti1c83gQ4SDbLJbnfZGqvrgWE5tQZRaj2Rdp4q8uXl0JLFaKfEbQ1lomBeH1Q68qLt0
 a/vipIrJcGOwB/OaEzPsWnWM85ACY235ekANrTcNopRWNGbsqYczHTnVnvhiARRSd9ef
 KsedtbbYQ13VF6o5CfyrSI5JjPfECTWTpFf2S2gbhTqoHnvmNd4NBm5JaqWhoYscpEHw JQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w41vduy7w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 09:48:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id B08ED100068;
        Thu,  7 Nov 2019 09:48:02 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas24.st.com [10.75.90.94])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7D0632AB105;
        Thu,  7 Nov 2019 09:48:02 +0100 (CET)
Received: from SAFEX1HUBCAS21.st.com (10.75.90.45) by Safex1hubcas24.st.com
 (10.75.90.94) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 7 Nov 2019
 09:48:02 +0100
Received: from localhost (10.201.22.222) by Webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 7 Nov 2019 09:48:01
 +0100
From:   Christophe Roullier <christophe.roullier@st.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@st.com>, <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <christophe.roullier@st.com>, <andrew@lunn.ch>
Subject: [PATCH V4 net-next 0/4] net: ethernet: stmmac: cleanup clock and optimization
Date:   Thu, 7 Nov 2019 09:47:53 +0100
Message-ID: <20191107084757.17910-1-christophe.roullier@st.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.22.222]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_02:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some improvements: 
 - manage syscfg as optional clock, 
 - update slew rate of ETH_MDIO pin, 
 - Enable gating of the MAC TX clock during TX low-power mode

V4: Update with Andrew Lunn remark

Christophe Roullier (4):
  net: ethernet: stmmac: Add support for syscfg clock
  ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
  ARM: dts: stm32: adjust slew rate for Ethernet
  ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
    mode on stm32mp157c

 arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 ++++++--
 arch/arm/boot/dts/stm32mp157c.dtsi            |  7 +++---
 .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 23 +++++++------------
 3 files changed, 18 insertions(+), 21 deletions(-)

-- 
2.17.1

