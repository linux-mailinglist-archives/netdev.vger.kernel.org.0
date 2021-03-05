Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC7E32E00D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhCEDZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:25:05 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13060 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEDZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:25:05 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DsCjR3kjszMjHB;
        Fri,  5 Mar 2021 11:22:51 +0800 (CST)
Received: from [10.67.102.197] (10.67.102.197) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Mar 2021 11:24:55 +0800
Subject: Re: [PATCH 4/4] nfc: Avoid endless loops caused by repeated
 llcp_sock_connect()(Internet mail)
To:     =?UTF-8?B?a2l5aW4o5bC55LquKQ==?= <kiyin@tencent.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "wangle6@huawei.com" <wangle6@huawei.com>,
        "xiaoqian9@huawei.com" <xiaoqian9@huawei.com>
References: <20210303061654.127666-1-nixiaoming@huawei.com>
 <20210303061654.127666-5-nixiaoming@huawei.com>
 <2965a9b88d254b7f8e7f4356875bbedb@tencent.com>
From:   Xiaoming Ni <nixiaoming@huawei.com>
Message-ID: <9295c052-a9e2-619c-eb40-87b592e2c08d@huawei.com>
Date:   Fri, 5 Mar 2021 11:24:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <2965a9b88d254b7f8e7f4356875bbedb@tencent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.197]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/3 17:28, kiyin(尹亮) wrote:
> Hi xiaoming,
>    the path can only fix the endless loop problem. it can't fix the meaningless llcp_sock->service_name problem.
>    if we set llcp_sock->service_name to meaningless string, the connect will be failed. and sk->sk_state will not be LLCP_CONNECTED. then we can call llcp_sock_connect() many times. that leaks everything: llcp_sock->dev, llcp_sock->local, llcp_sock->ssap, llcp_sock->service_name...

I didn't find the code to modify sk->sk_state after a connect failure. 
Can you provide guidance?

Based on my understanding of the current code:
After llcp_sock_connect() is invoked using the meaningless service_name 
as the parameter, sk->sk_state is set to LLCP_CONNECTING. After that, no 
corresponding service responds to the request because the service_name 
is meaningless, the value of sk->sk_state remains unchanged.
Therefore, when llcp_sock_connect() is invoked again, resources such as 
llcp_sock->service_name are not repeatedly applied because sk_state is 
set to LLCP_CONNECTING.

In this way, the repeated invoking of llcp_sock_connect() does not 
repeatedly leak resources.

Thanks
Xiaoming Ni


> 
>> -----Original Message-----
>> From: Xiaoming Ni [mailto:nixiaoming@huawei.com]
>> Sent: Wednesday, March 3, 2021 2:17 PM
>> To: linux-kernel@vger.kernel.org; kiyin(尹亮) <kiyin@tencent.com>;
>> stable@vger.kernel.org; gregkh@linuxfoundation.org; sameo@linux.intel.com;
>> linville@tuxdriver.com; davem@davemloft.net; kuba@kernel.org;
>> mkl@pengutronix.de; stefan@datenfreihafen.org;
>> matthieu.baerts@tessares.net; netdev@vger.kernel.org
>> Cc: nixiaoming@huawei.com; wangle6@huawei.com; xiaoqian9@huawei.com
>> Subject: [PATCH 4/4] nfc: Avoid endless loops caused by repeated
>> llcp_sock_connect()(Internet mail)
>>
>> When sock_wait_state() returns -EINPROGRESS, "sk->sk_state" is
>> LLCP_CONNECTING. In this case, llcp_sock_connect() is repeatedly invoked,
>>   nfc_llcp_sock_link() will add sk to local->connecting_sockets twice.
>>   sk->sk_node->next will point to itself, that will make an endless loop  and
>> hang-up the system.
>> To fix it, check whether sk->sk_state is LLCP_CONNECTING in
>>   llcp_sock_connect() to avoid repeated invoking.
>>
>> fix CVE-2020-25673
>> Fixes: b4011239a08e ("NFC: llcp: Fix non blocking sockets connections")
>> Reported-by: "kiyin(尹亮)" <kiyin@tencent.com>
>> Link: https://www.openwall.com/lists/oss-security/2020/11/01/1
>> Cc: <stable@vger.kernel.org> #v3.11
>> Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
>> ---
>>   net/nfc/llcp_sock.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c index
>> 59172614b249..a3b46f888803 100644
>> --- a/net/nfc/llcp_sock.c
>> +++ b/net/nfc/llcp_sock.c
>> @@ -673,6 +673,10 @@ static int llcp_sock_connect(struct socket *sock,
>> struct sockaddr *_addr,
>>   		ret = -EISCONN;
>>   		goto error;
>>   	}
>> +	if (sk->sk_state == LLCP_CONNECTING) {
>> +		ret = -EINPROGRESS;
>> +		goto error;
>> +	}
>>
>>   	dev = nfc_get_device(addr->dev_idx);
>>   	if (dev == NULL) {
>> --
>> 2.27.0
>>
> 

