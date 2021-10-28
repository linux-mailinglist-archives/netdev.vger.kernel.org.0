Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADF43DC11
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhJ1Hfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:35:55 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26130 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1Hfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:35:55 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Hfy0t2pkgz1DHpx;
        Thu, 28 Oct 2021 15:31:26 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 15:33:22 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 28 Oct 2021 15:33:21 +0800
Subject: Re: [PATCH net 2/3] can: j1939: j1939_can_recv(): ignore messages
 with invalid source address
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Robin van der Gracht <robin@protonic.nl>,
        <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <netdev@vger.kernel.org>, "Marc Kleine-Budde" <mkl@pengutronix.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Jakub Kicinski <kuba@kernel.org>, <linux-can@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
 <1634825057-47915-3-git-send-email-zhangchangzhong@huawei.com>
 <20211022102306.GB20681@pengutronix.de>
 <9c636d7f-70df-18c9-66ed-46eb21f4ffbb@huawei.com>
 <20211028065144.GE20681@pengutronix.de>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <ff21f8b9-0fe0-e6be-73d4-18b9f5bfd773@huawei.com>
Date:   Thu, 28 Oct 2021 15:33:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20211028065144.GE20681@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/28 14:51, Oleksij Rempel wrote:
> Hi,
> 
> On Mon, Oct 25, 2021 at 03:30:57PM +0800, Zhang Changzhong wrote:
>> On 2021/10/22 18:23, Oleksij Rempel wrote:
>>> On Thu, Oct 21, 2021 at 10:04:16PM +0800, Zhang Changzhong wrote:
>>>> According to SAE-J1939-82 2015 (A.3.6 Row 2), a receiver should never
>>>> send TP.CM_CTS to the global address, so we can add a check in
>>>> j1939_can_recv() to drop messages with invalid source address.
>>>>
>>>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>>
>>> NACK. This will break Address Claiming, where first message is SA == 0xff
>>
>> I know that 0xfe can be used as a source address, but which message has a source
>> address of 0xff?
>>
>> According to SAE-J1939-81 2017 4.2.2.8：
>>
>>   The network address 255, also known as the Global address, is permitted in the
>>   Destination Address field of the SAE J1939 message identifier but never in the
>>   Source Address field.
> 
> You are right. Thx!
> 
> Are you using any testing frameworks?
> Can you please take a look here:
> https://github.com/linux-can/can-tests/tree/master/j1939
> 
> We are using this scripts for regression testing of some know bugs.

Great! I'll run these scripts before posting patches.

> 
>>
>>>
>>>> ---
>>>>  net/can/j1939/main.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
>>>> index 08c8606..4f1e4bb 100644
>>>> --- a/net/can/j1939/main.c
>>>> +++ b/net/can/j1939/main.c
>>>> @@ -75,6 +75,10 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
>>>>  	skcb->addr.pgn = (cf->can_id >> 8) & J1939_PGN_MAX;
>>>>  	/* set default message type */
>>>>  	skcb->addr.type = J1939_TP;
>>>> +	if (!j1939_address_is_valid(skcb->addr.sa))
>>>> +		/* ignore messages whose sa is broadcast address */
>>>> +		goto done;
> 
> Please add some warning once message here. We wont to know if something bad
> is happening on the bus.

Will do. Thanks for your suggestions.

Regards,
Changzhong

> 
>>>> +
>>>>  	if (j1939_pgn_is_pdu1(skcb->addr.pgn)) {
>>>>  		/* Type 1: with destination address */
>>>>  		skcb->addr.da = skcb->addr.pgn;
>>>> -- 
>>>> 2.9.5
>>>>
>>>>
>>>>
>>>
>>
>>
> 
> Regards,
> Oleksij
> 
