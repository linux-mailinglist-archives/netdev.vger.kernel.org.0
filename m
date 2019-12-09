Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FA4116E74
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbfLIOCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:02:42 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:42301 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727684AbfLIOCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:02:41 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB9E17Rh002940;
        Mon, 9 Dec 2019 15:02:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=h0NDLxS3j9GuxtUF4CHpY+EnFaY9d7pHHOIkb2OZAns=;
 b=TL77VmqZ6PBbQBR4bgNU6G/GBf+MokTel3SnHpeiyO76m2Aa3yPOTu6R+dB+zSNQdVf0
 vauYvasBECN30yo6TxYqKQQWZIAjO6aZidp1Miyn5dm7zEWYrzX0LLw2LpqMCzO1pos9
 KJRAYmhEXNe1B1gOAAXspNV0Cy4WsPV/7NUjWRQRHndTlGhOVyyZMOjNbcS/mD9rQUWr
 ik1MGKkBCkcVpz7MfGAvXqQdG9MJ6Oj8taMOoEYbToFfKpy4x2iZ1MOdqkVFKI7T47s6
 ssFGg7FczNryUw10RQfmhakYWkoaQxq48dqQYUmJPo8bBeSB12lJkAw793nSRfnyjG5a FQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2wrapxfpn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Dec 2019 15:02:23 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 1606D100038;
        Mon,  9 Dec 2019 15:02:21 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id EACFA2FF5F7;
        Mon,  9 Dec 2019 15:02:20 +0100 (CET)
Received: from lmecxl0912.lme.st.com (10.75.127.48) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Mon, 9 Dec
 2019 15:02:20 +0100
Subject: Re: [PATCH V4 net-next 0/4] net: ethernet: stmmac: cleanup clock and
 optimization
To:     Christophe Roullier <christophe.roullier@st.com>,
        <robh@kernel.org>, <davem@davemloft.net>, <joabreu@synopsys.com>,
        <mark.rutland@arm.com>, <mcoquelin.stm32@gmail.com>,
        <peppe.cavallaro@st.com>
CC:     <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20191107084757.17910-1-christophe.roullier@st.com>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <5b1774f4-c0ec-030d-90a8-65b714545b9b@st.com>
Date:   Mon, 9 Dec 2019 15:02:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107084757.17910-1-christophe.roullier@st.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_04:2019-12-09,2019-12-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christophe

On 11/7/19 9:47 AM, Christophe Roullier wrote:
> Some improvements:
>   - manage syscfg as optional clock,
>   - update slew rate of ETH_MDIO pin,
>   - Enable gating of the MAC TX clock during TX low-power mode
> 
> V4: Update with Andrew Lunn remark
> 
> Christophe Roullier (4):
>    net: ethernet: stmmac: Add support for syscfg clock
>    ARM: dts: stm32: remove syscfg clock on stm32mp157c ethernet
>    ARM: dts: stm32: adjust slew rate for Ethernet
>    ARM: dts: stm32: Enable gating of the MAC TX clock during TX low-power
>      mode on stm32mp157c
> 
>   arch/arm/boot/dts/stm32mp157-pinctrl.dtsi     |  9 ++++++--
>   arch/arm/boot/dts/stm32mp157c.dtsi            |  7 +++---
>   .../net/ethernet/stmicro/stmmac/dwmac-stm32.c | 23 +++++++------------
>   3 files changed, 18 insertions(+), 21 deletions(-)
> 

For DT patches:

Applied on stm32-next.

Thanks.
Alex
