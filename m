Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47064438FD0
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 08:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhJYHCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 03:02:02 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:13977 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbhJYHCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 03:02:01 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hd5PJ4ksszZcSF;
        Mon, 25 Oct 2021 14:57:40 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 25 Oct 2021 14:59:32 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 25 Oct 2021 14:59:32 +0800
Subject: Re: [PATCH net 3/3] can: j1939: j1939_tp_cmd_recv(): check the dst
 address of TP.CM_BAM
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1634825057-47915-1-git-send-email-zhangchangzhong@huawei.com>
 <1634825057-47915-4-git-send-email-zhangchangzhong@huawei.com>
 <20211022102858.GC20681@pengutronix.de>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <671f5813-4d36-2c67-fea6-4dd9504e661f@huawei.com>
Date:   Mon, 25 Oct 2021 14:59:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20211022102858.GC20681@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/10/22 18:28, Oleksij Rempel wrote:
> On Thu, Oct 21, 2021 at 10:04:17PM +0800, Zhang Changzhong wrote:
>> The TP.CM_BAM message must be sent to the global address [1], so add a
>> check to drop TP.CM_BAM sent to a non-global address.
>>
>> Without this patch, the receiver will treat the following packets as
>> normal RTS/CTS tranport:
>> 18EC0102#20090002FF002301
>> 18EB0102#0100000000000000
>> 18EB0102#020000FFFFFFFFFF
>>
>> [1] SAE-J1939-82 2015 A.3.3 Row 1.
>>
>> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  net/can/j1939/transport.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
>> index 2efa606..93ec0c3 100644
>> --- a/net/can/j1939/transport.c
>> +++ b/net/can/j1939/transport.c
>> @@ -2019,6 +2019,8 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
>>  		extd = J1939_ETP;
>>  		fallthrough;
>>  	case J1939_TP_CMD_BAM:
>> +		if (!j1939_cb_is_broadcast(skcb))
> 
> Please add here netdev_err_once("with some message"), we need to know if
> some MCU makes bad things.

Ok, will do.

The current patch breaks ETP functionality as the J1939_ETP_CMD_RTS fallthrough
to J1939_TP_CMD_BAM, this will also be fixed in v2.

> 
>> +			return;
>>  		fallthrough;
>>  	case J1939_TP_CMD_RTS:
>>  		if (skcb->addr.type != extd)
>> -- 
>> 2.9.5
>>
>>
> 
