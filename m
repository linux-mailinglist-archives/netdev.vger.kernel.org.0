Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05752AF403
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 03:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfIKBa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 21:30:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55550 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726224AbfIKBa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 21:30:56 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A8175ACB86E4CABFD3C3;
        Wed, 11 Sep 2019 09:30:53 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Sep 2019
 09:30:49 +0800
Subject: Re: [PATCH net 1/2] sctp: remove redundant assignment when call
 sctp_get_port_local
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     <vyasevich@gmail.com>, <nhorman@tuxdriver.com>,
        <marcelo.leitner@gmail.com>, <davem@davemloft.net>,
        <linux-sctp@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20190910071343.18808-1-maowenan@huawei.com>
 <20190910071343.18808-2-maowenan@huawei.com> <20190910185710.GF15977@kadam>
 <20190910192207.GE20699@kadam>
From:   maowenan <maowenan@huawei.com>
Message-ID: <53556c87-a351-4314-cbd9-49a39d0b41aa@huawei.com>
Date:   Wed, 11 Sep 2019 09:30:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <20190910192207.GE20699@kadam>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/9/11 3:22, Dan Carpenter wrote:
> On Tue, Sep 10, 2019 at 09:57:10PM +0300, Dan Carpenter wrote:
>> On Tue, Sep 10, 2019 at 03:13:42PM +0800, Mao Wenan wrote:
>>> There are more parentheses in if clause when call sctp_get_port_local
>>> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
>>> do cleanup.
>>>
>>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>>> ---
>>>  net/sctp/socket.c | 3 +--
>>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
>>> index 9d1f83b10c0a..766b68b55ebe 100644
>>> --- a/net/sctp/socket.c
>>> +++ b/net/sctp/socket.c
>>> @@ -399,9 +399,8 @@ static int sctp_do_bind(struct sock *sk, union sctp_addr *addr, int len)
>>>  	 * detection.
>>>  	 */
>>>  	addr->v4.sin_port = htons(snum);
>>> -	if ((ret = sctp_get_port_local(sk, addr))) {
>>> +	if (sctp_get_port_local(sk, addr))
>>>  		return -EADDRINUSE;
>>
>> sctp_get_port_local() returns a long which is either 0,1 or a pointer
>> casted to long.  It's not documented what it means and neither of the
>> callers use the return since commit 62208f12451f ("net: sctp: simplify
>> sctp_get_port").
> 
> Actually it was commit 4e54064e0a13 ("sctp: Allow only 1 listening
> socket with SO_REUSEADDR") from 11 years ago.  That patch fixed a bug,
> because before the code assumed that a pointer casted to an int was the
> same as a pointer casted to a long.

commit 4e54064e0a13 treated non-zero return value as unexpected, so the current
cleanup is ok?

> 
> regards,
> dan carpenter
> 
> 
> .
> 

