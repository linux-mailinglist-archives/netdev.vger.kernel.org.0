Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6631EF52B
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 12:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFEKSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 06:18:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47390 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbgFEKSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 06:18:42 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 127055D65673BCB0F9F3;
        Fri,  5 Jun 2020 18:18:39 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.154) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Fri, 5 Jun 2020
 18:18:31 +0800
Subject: Re: [PATCH] sunrpc: need delete xprt->timer in xs_destroy
To:     "Zhengbin (OSKernel)" <zhengbin13@huawei.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
References: <20200604144910.133756-1-zhengbin13@huawei.com>
 <bc4755e6c5cee7a326cf06f983907a3170be1649.camel@hammerspace.com>
 <b04044c7-597c-0487-f459-4d0032d66d5b@huawei.com>
CC:     "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <63228c1a-5376-0641-1e25-02d8e4784adf@huawei.com>
Date:   Fri, 5 Jun 2020 18:18:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <b04044c7-597c-0487-f459-4d0032d66d5b@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue trigger like this:

mount_fs
  nfs_try_mount
   nfs_create_server
    nfs_init_server
     nfs_init_client
      nfs_create_rpc_client
       rpc_create
        xprt_create_transport
          xs_setup_udp
            xs_setup_xprt
          INIT_DELAYED_WORK(xs_udp_setup_socket)//timer
                                                                xs_connect
                                                                  queue_delayed_work
        rpc_create_xprt
          rpc_new_client
          rpc_ping //fail
          rpc_shutdown
            rpc_release_client
               rpc_free_auth
                  rpc_free_client
                      xprt_put
                        xprt_destroy
                          XPRT_LOCKED //wait lock
                          del_timer_sync
                          xprt_destroy_cb
                            xs_destroy
                               cancel_delayed_work_sync  --fire--> xs_udp_setup_socket
                                                                 xprt_unlock_connect
                                                                   xprt_schedule_autodisconnect
                                                                     mod_timer
                                 xs_xprt_free
                                                                 timer out, access xprt //UAF


On 2020/6/5 10:10, Zhengbin (OSKernel) wrote:
> The complete process is like this:
> 
> xprt_destroy
>   wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_UNINTERRUPTIBLE)  -->getlock
>   del_timer_sync(&xprt->timer)   -->del xprt->timer
>   INIT_WORK(&xprt->task_cleanup, xprt_destroy_cb)
> 
> xprt_destroy_cb
>   xs_destroy(xprt->ops->destroy)
>     cancel_delayed_work_sync     -->will call transport->connect_worker, whose callback is xs_udp_setup_socket
>     xs_xprt_free(xprt)                    -->free xprt
> 
> xs_udp_setup_socket
>   sock = xs_create_sock
>   xprt_unlock_connect
>       if (!test_bit(XPRT_LOCKED, &xprt->state)) -->state is XPRT_LOCKED
>       xprt_schedule_autodisconnect
>         mod_timer
>           internal_add_timer  -->insert xprt->timer to base timer list
> 
> On 2020/6/4 23:39, Trond Myklebust wrote:
>> On Thu, 2020-06-04 at 22:49 +0800, Zheng Bin wrote:
>>> If RPC use udp as it's transport protocol, transport->connect_worker
>>> will call xs_udp_setup_socket.
>>> xs_udp_setup_socket
>>>    sock = xs_create_sock
>>>    if (IS_ERR(sock))
>>>      goto out;
>>>    out:
>>>      xprt_unlock_connect
>>>        xprt_schedule_autodisconnect
>>>          mod_timer
>>>            internal_add_timer  -->insert xprt->timer to base timer
>>> list
>>>
>>> xs_destroy
>>>    cancel_delayed_work_sync(&transport->connect_worker)
>>>    xs_xprt_free(xprt)           -->free xprt
>>>
>>> Thus use-after-free will happen.
>>>
>>> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
>>> ---
>>>   net/sunrpc/xprtsock.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>>> index 845d0be805ec..c796808e7f7a 100644
>>> --- a/net/sunrpc/xprtsock.c
>>> +++ b/net/sunrpc/xprtsock.c
>>> @@ -1242,6 +1242,7 @@ static void xs_destroy(struct rpc_xprt *xprt)
>>>       dprintk("RPC:       xs_destroy xprt %p\n", xprt);
>>>
>>>       cancel_delayed_work_sync(&transport->connect_worker);
>>> +    del_timer_sync(&xprt->timer);
>>>       xs_close(xprt);
>>>       cancel_work_sync(&transport->recv_worker);
>>>       cancel_work_sync(&transport->error_worker);
>>> -- 
>>> 2.26.0.106.g9fadedd
>>>
>> I'm confused. How can this happen given that xprt_destroy() first takes
>> the XPRT_LOCK, and then deletes xprt->timer?
>>
>> Right now, the socket code knows nothing about the details of xprt-
>>> timer and what it is used for. I'd prefer to keep it that way if
>> possible.
>>
> 
> 
> .
> 

