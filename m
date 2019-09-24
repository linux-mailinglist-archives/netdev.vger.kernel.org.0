Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F063EBC4EB
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504261AbfIXJeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:34:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2773 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504239AbfIXJeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:34:12 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D9E1F99325EA1F14D8C6;
        Tue, 24 Sep 2019 17:34:10 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Sep 2019
 17:34:05 +0800
Subject: Re: [PATCH stable 4.4 net] net: rds: Fix NULL ptr use in
 rds_tcp_kill_sock
From:   maowenan <maowenan@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     <chien.yen@oracle.com>, <davem@davemloft.net>,
        <stable@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20190918083733.50266-1-maowenan@huawei.com>
 <20190918083253.GA1862222@kroah.com>
 <c8953355-2b98-c4d0-2af2-4a69ad3e2d2d@huawei.com>
Message-ID: <8b5b7fd5-dd53-4a73-371d-c997b1b3ce78@huawei.com>
Date:   Tue, 24 Sep 2019 17:33:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <c8953355-2b98-c4d0-2af2-4a69ad3e2d2d@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kindly ping...

On 2019/9/18 17:02, maowenan wrote:
> 
> 
> On 2019/9/18 16:32, Greg KH wrote:
>> On Wed, Sep 18, 2019 at 04:37:33PM +0800, Mao Wenan wrote:
>>> After the commit c4e97b06cfdc ("net: rds: force to destroy
>>> connection if t_sock is NULL in rds_tcp_kill_sock()."),
>>> it introduced null-ptr-deref in rds_tcp_kill_sock as below:
>>>
>>> BUG: KASAN: null-ptr-deref on address 0000000000000020
>>> Read of size 8 by task kworker/u16:10/910
>>> CPU: 3 PID: 910 Comm: kworker/u16:10 Not tainted 4.4.178+ #3
>>> Hardware name: linux,dummy-virt (DT)
>>> Workqueue: netns cleanup_net
>>> Call trace:
>>> [<ffffff90080abb50>] dump_backtrace+0x0/0x618
>>> [<ffffff90080ac1a0>] show_stack+0x38/0x60
>>> [<ffffff9008c42b78>] dump_stack+0x1a8/0x230
>>> [<ffffff90085d469c>] kasan_report_error+0xc8c/0xfc0
>>> [<ffffff90085d54a4>] kasan_report+0x94/0xd8
>>> [<ffffff90085d1b28>] __asan_load8+0x88/0x150
>>> [<ffffff9009c9cc2c>] rds_tcp_dev_event+0x734/0xb48
>>> [<ffffff90081eacb0>] raw_notifier_call_chain+0x150/0x1e8
>>> [<ffffff900973fec0>] call_netdevice_notifiers_info+0x90/0x110
>>> [<ffffff9009764874>] netdev_run_todo+0x2f4/0xb08
>>> [<ffffff9009796d34>] rtnl_unlock+0x2c/0x48
>>> [<ffffff9009756484>] default_device_exit_batch+0x444/0x528
>>> [<ffffff9009720498>] ops_exit_list+0x1c0/0x240
>>> [<ffffff9009724a80>] cleanup_net+0x738/0xbf8
>>> [<ffffff90081ca6cc>] process_one_work+0x96c/0x13e0
>>> [<ffffff90081cf370>] worker_thread+0x7e0/0x1910
>>> [<ffffff90081e7174>] kthread+0x304/0x390
>>> [<ffffff9008094280>] ret_from_fork+0x10/0x50
>>>
>>> If the first loop add the tc->t_sock = NULL to the tmp_list,
>>> 1). list_for_each_entry_safe(tc, _tc, &rds_tcp_conn_list, t_tcp_node)
>>>
>>> then the second loop is to find connections to destroy, tc->t_sock
>>> might equal NULL, and tc->t_sock->sk happens null-ptr-deref.
>>> 2). list_for_each_entry_safe(tc, _tc, &tmp_list, t_tcp_node)
>>>
>>> Fixes: c4e97b06cfdc ("net: rds: force to destroy connection if t_sock is NULL in rds_tcp_kill_sock().")
>>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>>> ---
>>>  net/rds/tcp.c | 8 +++++---
>>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>
>> Why is this not needed upstream as well?
> Upstream does not use tc->t_sock in the second loop after below two patches.
> afb4164d91c7 ("RDS: TCP: Refactor connection destruction to handle multiple paths") and
> 2d746c93b6e5 ("rds: tcp: remove redundant function rds_tcp_conn_paths_destroy()")
> 
>>
>> 4.9.y?  4.14.y?  anything else?
> 4.19.y and 4.14.y exist rds_tcp_conn_paths_destroy()
> to guarantee that.
> +static void rds_tcp_conn_paths_destroy(struct rds_connection *conn)
> +{
> +       struct rds_conn_path *cp;
> +       struct rds_tcp_connection *tc;
> +       int i;
> +       struct sock *sk;
> +
> +       for (i = 0; i < RDS_MPATH_WORKERS; i++) {
> +               cp = &conn->c_path[i];
> +               tc = cp->cp_transport_data;
> +               if (!tc->t_sock)
> +                       continue;
> +               sk = tc->t_sock->sk;
> +               sk->sk_prot->disconnect(sk, 0);
> +               tcp_done(sk);
> +       }
> +}
> +
> 
>>
>> thanks,
>>
>> greg k-h
>>
>> .
>>
> 
> 
> .
> 

