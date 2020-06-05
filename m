Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B711EEF58
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 04:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgFECKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 22:10:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34044 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbgFECKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 22:10:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B4A92E608DFB6990351D;
        Fri,  5 Jun 2020 10:10:39 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.138) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Fri, 5 Jun 2020
 10:10:30 +0800
Subject: Re: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
CC:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>
References: <20200604144910.133756-1-zhengbin13@huawei.com>
 <bc4755e6c5cee7a326cf06f983907a3170be1649.camel@hammerspace.com>
From:   "Zhengbin (OSKernel)" <zhengbin13@huawei.com>
Message-ID: <b04044c7-597c-0487-f459-4d0032d66d5b@huawei.com>
Date:   Fri, 5 Jun 2020 10:10:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <bc4755e6c5cee7a326cf06f983907a3170be1649.camel@hammerspace.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.215.138]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The complete process is like this:

xprt_destroy
   wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_UNINTERRUPTIBLE)  
-->getlock
   del_timer_sync(&xprt->timer)   -->del xprt->timer
   INIT_WORK(&xprt->task_cleanup, xprt_destroy_cb)

xprt_destroy_cb
   xs_destroy(xprt->ops->destroy)
     cancel_delayed_work_sync     -->will call 
transport->connect_worker, whose callback is xs_udp_setup_socket
     xs_xprt_free(xprt)                    -->free xprt

xs_udp_setup_socket
   sock = xs_create_sock
   xprt_unlock_connect
       if (!test_bit(XPRT_LOCKED, &xprt->state)) -->state is XPRT_LOCKED
       xprt_schedule_autodisconnect
         mod_timer
           internal_add_timer  -->insert xprt->timer to base timer list

On 2020/6/4 23:39, Trond Myklebust wrote:
> On Thu, 2020-06-04 at 22:49 +0800, Zheng Bin wrote:
>> If RPC use udp as it's transport protocol, transport->connect_worker
>> will call xs_udp_setup_socket.
>> xs_udp_setup_socket
>>    sock = xs_create_sock
>>    if (IS_ERR(sock))
>>      goto out;
>>    out:
>>      xprt_unlock_connect
>>        xprt_schedule_autodisconnect
>>          mod_timer
>>            internal_add_timer  -->insert xprt->timer to base timer
>> list
>>
>> xs_destroy
>>    cancel_delayed_work_sync(&transport->connect_worker)
>>    xs_xprt_free(xprt)           -->free xprt
>>
>> Thus use-after-free will happen.
>>
>> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
>> ---
>>   net/sunrpc/xprtsock.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>> index 845d0be805ec..c796808e7f7a 100644
>> --- a/net/sunrpc/xprtsock.c
>> +++ b/net/sunrpc/xprtsock.c
>> @@ -1242,6 +1242,7 @@ static void xs_destroy(struct rpc_xprt *xprt)
>>   	dprintk("RPC:       xs_destroy xprt %p\n", xprt);
>>
>>   	cancel_delayed_work_sync(&transport->connect_worker);
>> +	del_timer_sync(&xprt->timer);
>>   	xs_close(xprt);
>>   	cancel_work_sync(&transport->recv_worker);
>>   	cancel_work_sync(&transport->error_worker);
>> --
>> 2.26.0.106.g9fadedd
>>
> I'm confused. How can this happen given that xprt_destroy() first takes
> the XPRT_LOCK, and then deletes xprt->timer?
>
> Right now, the socket code knows nothing about the details of xprt-
>> timer and what it is used for. I'd prefer to keep it that way if
> possible.
>

