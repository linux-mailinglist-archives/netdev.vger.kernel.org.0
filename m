Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA86F449A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 11:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbfKHKfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 05:35:50 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1675 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbfKHKft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 05:35:49 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8ARHkc030061;
        Fri, 8 Nov 2019 11:35:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=C7Ytb5ccJx46yUXyoXndkBMI9CQtxWg5KpH5r3iInZ8=;
 b=GH9uAbmNuzAIytWfQHvJoGGcaa3XfQizakPDih9XTMQcZNv9yhOju/+XEwD4dxMSI6Et
 MYAEj0TBlE1+zZj1WX/k00K4MA/26XQLwWeyUnpBmEOdzBDBNbdypQ0BZzflaf8BJOz7
 O/0OGDlxp3dnVm4cSnw9csIVXklDl+80lcd5vGDItgAMhtlHmLyh2z5jRgtowtpdyXYJ
 3FQuE9kZv35hNGwaI6s2LdO/E2srBP4ovFUwTVnJzax/VeQDlLG3rT9N5MOlbafFP+2R
 1TkjiJ9OaxFD89XLs3rqxWGcTNpX6T1WMPD0OeQ3PssVxWMrlpA2Ejms/k0v8F27yeLk 7g== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w41vmu27x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:35:30 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 93442100034;
        Fri,  8 Nov 2019 11:35:26 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node2.st.com [10.75.127.8])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 7CB1F2B0FED;
        Fri,  8 Nov 2019 11:35:26 +0100 (CET)
Received: from lmecxl0912.lme.st.com (10.75.127.50) by SFHDAG3NODE2.st.com
 (10.75.127.8) with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 8 Nov
 2019 11:35:23 +0100
Subject: Re: [PATCH V4 net-next 0/4] net: ethernet: stmmac: cleanup clock and
 optimization
To:     David Miller <davem@davemloft.net>, <christophe.roullier@st.com>
CC:     <robh@kernel.org>, <joabreu@synopsys.com>, <mark.rutland@arm.com>,
        <mcoquelin.stm32@gmail.com>, <peppe.cavallaro@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@lunn.ch>
References: <20191107084757.17910-1-christophe.roullier@st.com>
 <20191107.152640.1457462659040029467.davem@davemloft.net>
From:   Alexandre Torgue <alexandre.torgue@st.com>
Message-ID: <8c4efcce-b46f-ac94-a367-50ff5d78c8a2@st.com>
Date:   Fri, 8 Nov 2019 11:35:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107.152640.1457462659040029467.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG3NODE2.st.com
 (10.75.127.8)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_02:2019-11-07,2019-11-08 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

On 11/8/19 12:26 AM, David Miller wrote:
> From: Christophe Roullier <christophe.roullier@st.com>
> Date: Thu, 7 Nov 2019 09:47:53 +0100
> 
>> Some improvements:
>>   - manage syscfg as optional clock,
>>   - update slew rate of ETH_MDIO pin,
>>   - Enable gating of the MAC TX clock during TX low-power mode
>>
>> V4: Update with Andrew Lunn remark
> 
> This is mostly ARM DT updates, which tree should this go through?
> 
> I don't want to step on toes this time :-)
> 

I'll take DT patches in my STM32 tree.

Thanks
Alex
