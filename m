Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7A3624F7B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 02:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiKKBXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 20:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKKBXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 20:23:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5ECE0CD
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 17:23:15 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7gpq3mm4zqSHs;
        Fri, 11 Nov 2022 09:19:31 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 09:23:13 +0800
Message-ID: <61814668-2717-d140-5a01-f6a46e05de09@huawei.com>
Date:   Fri, 11 Nov 2022 09:23:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net/9p: fix issue of list_del corruption in
 p9_fd_cancel()
To:     <asmadeus@codewreck.org>
CC:     <v9fs-developer@lists.sourceforge.net>, <netdev@vger.kernel.org>,
        <ericvh@gmail.com>, <lucho@ionkov.net>, <linux_oss@crudebyte.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221110122606.383352-1-shaozhengchao@huawei.com>
 <Y2zz24jRIo9DdWw7@codewreck.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y2zz24jRIo9DdWw7@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/10 20:51, asmadeus@codewreck.org wrote:
> Zhengchao Shao wrote on Thu, Nov 10, 2022 at 08:26:06PM +0800:
>> Syz reported the following issue:
>> kernel BUG at lib/list_debug.c:53!
>> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
>> RIP: 0010:__list_del_entry_valid.cold+0x5c/0x72
>> Call Trace:
>> <TASK>
>> p9_fd_cancel+0xb1/0x270
>> p9_client_rpc+0x8ea/0xba0
>> p9_client_create+0x9c0/0xed0
>> v9fs_session_init+0x1e0/0x1620
>> v9fs_mount+0xba/0xb80
>> legacy_get_tree+0x103/0x200
>> vfs_get_tree+0x89/0x2d0
>> path_mount+0x4c0/0x1ac0
>> __x64_sys_mount+0x33b/0x430
>> do_syscall_64+0x35/0x80
>> entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> </TASK>
>>
>> The process is as follows:
>> Thread A:                       Thread B:
>> p9_poll_workfn()                p9_client_create()
>> ...                                 ...
>>      p9_conn_cancel()                p9_fd_cancel()
>>          list_del()                      ...
>>          ...                             list_del()  //list_del
>>                                                        corruption
>> There is no lock protection when deleting list in p9_conn_cancel(). After
>> deleting list in Thread A, thread B will delete the same list again. It
>> will cause issue of list_del corruption.
> 
> Thanks!
> 
> I'd add a couple of lines here describing the actual fix.
> Something like this?
> ---
> Setting req->status to REQ_STATUS_ERROR under lock prevents other
> cleanup paths from trying to manipulate req_list.
> The other thread can safely check req->status because it still holds a
> reference to req at this point.
> ---
> 
> With that out of the way, it's a good idea; I didn't remember that
> p9_fd_cancel (and cancelled) check for req status before acting on it.
> This really feels like whack-a-mole, but I'd say this is one step
> better.
> 
> Please tell me if you want to send a v2 with your words, or I'll just
> pick this up with my suggestion and submit to Linus in a week-ish after
> testing. No point in waiting a full cycle for this.
> 
> 
Hi Dominique:
	Thank you for your review. Your suggestion looks good to me, and
please add your suggestion. :)
>> Fixes: 52f1c45dde91 ("9p: trans_fd/p9_conn_cancel: drop client lock earlier")
>> Reported-by: syzbot+9b69b8d10ab4a7d88056@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>> v2: set req status when removing list
> 
> (I don't recall seeing a v1?)
> 
Sorry, please ignore this notes.
>> ---
>>   net/9p/trans_fd.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
>> index 56a186768750..bd28e63d7666 100644
>> --- a/net/9p/trans_fd.c
>> +++ b/net/9p/trans_fd.c
>> @@ -202,9 +202,11 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
>>   
>>   	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
>>   		list_move(&req->req_list, &cancel_list);
>> +		req->status = REQ_STATUS_ERROR;
>>   	}
>>   	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
>>   		list_move(&req->req_list, &cancel_list);
>> +		req->status = REQ_STATUS_ERROR;
>>   	}
>>   
>>   	spin_unlock(&m->req_lock);
> 
> --
> Dominique
