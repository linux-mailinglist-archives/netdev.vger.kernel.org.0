Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74847AC4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 09:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfFQH2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 03:28:20 -0400
Received: from mail-m963.mail.126.com ([123.126.96.3]:49322 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfFQH2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 03:28:20 -0400
X-Greylist: delayed 1883 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2019 03:28:18 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=gmRVQ
        eFD/AvA76XiNCTGu/tE4Cf08n894khgBNT06SI=; b=RmmWGbfuaCwybYrxa9B2n
        0vsIOv+45oFhaYglUvudhvHLa8kkyUnVkTFksFJfxph+13IMctWkPX8e4InwT1Ww
        vsvup0N52OSQgO/nsKOuDMvD3a+bP8cAfG4ibb2BjCAqRN6qZWMl4g8Xb9uV7/68
        2Cug2IwENgFxvtbbmKic9s=
Received: from [172.20.10.3] (unknown [124.64.16.121])
        by smtp8 (Coremail) with SMTP id NORpCgCXti+bOQdd3TrACg--.697S2;
        Mon, 17 Jun 2019 14:56:29 +0800 (CST)
Subject: Re: [PATCH] 9p: Transport error uninitialized
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190613070854.10434-1-shuaibinglu@126.com>
 <20190613111027.GB9525@nautica>
From:   Shuaibing Lu <shuaibinglu@126.com>
Message-ID: <692e328c-3d4a-c39c-0e6d-ba86828c6b41@126.com>
Date:   Mon, 17 Jun 2019 14:56:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613111027.GB9525@nautica>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: NORpCgCXti+bOQdd3TrACg--.697S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWrZr17GF1rCw1DXF17Awb_yoW5try5pr
        sxKFWxCw4ktryjva1jya1kJF10yF4kA3W3Jr1fKr12k3WkGr1kAa4UtF4jgFyUur98AFy7
        JFyjq390qr1UJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bIXocUUUUU=
X-Originating-IP: [124.64.16.121]
X-CM-SenderInfo: 5vkxtxpelqwzbx6rjloofrz/1tbinx3Wq1pD8zTPZwAAsJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2019/6/13 下午7:10, Dominique Martinet 写道:
> Lu Shuaibing wrote on Thu, Jun 13, 2019:
>> The p9_tag_alloc() does not initialize the transport error t_err field.
>> The struct p9_req_t *req is allocated and stored in a struct p9_client
>> variable. The field t_err is never initialized before p9_conn_cancel()
>> checks its value.
>>
>> KUMSAN(KernelUninitializedMemorySantizer, a new error detection tool)
>> reports this bug.
>>
>> ==================================================================
>> BUG: KUMSAN: use of uninitialized memory in p9_conn_cancel+0x2d9/0x3b0
>> Read of size 4 at addr ffff88805f9b600c by task kworker/1:2/1216
>>
>> CPU: 1 PID: 1216 Comm: kworker/1:2 Not tainted 5.2.0-rc4+ #28
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>> Workqueue: events p9_write_work
>> Call Trace:
>>  dump_stack+0x75/0xae
>>  __kumsan_report+0x17c/0x3e6
>>  kumsan_report+0xe/0x20
>>  p9_conn_cancel+0x2d9/0x3b0
>>  p9_write_work+0x183/0x4a0
>>  process_one_work+0x4d1/0x8c0
>>  worker_thread+0x6e/0x780
>>  kthread+0x1ca/0x1f0
>>  ret_from_fork+0x35/0x40
>>
>> Allocated by task 1979:
>>  save_stack+0x19/0x80
>>  __kumsan_kmalloc.constprop.3+0xbc/0x120
>>  kmem_cache_alloc+0xa7/0x170
>>  p9_client_prepare_req.part.9+0x3b/0x380
>>  p9_client_rpc+0x15e/0x880
>>  p9_client_create+0x3d0/0xac0
>>  v9fs_session_init+0x192/0xc80
>>  v9fs_mount+0x67/0x470
>>  legacy_get_tree+0x70/0xd0
>>  vfs_get_tree+0x4a/0x1c0
>>  do_mount+0xba9/0xf90
>>  ksys_mount+0xa8/0x120
>>  __x64_sys_mount+0x62/0x70
>>  do_syscall_64+0x6d/0x1e0
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> Freed by task 0:
>> (stack is not available)
>>
>> The buggy address belongs to the object at ffff88805f9b6008
>>  which belongs to the cache p9_req_t of size 144
>> The buggy address is located 4 bytes inside of
>>  144-byte region [ffff88805f9b6008, ffff88805f9b6098)
>> The buggy address belongs to the page:
>> page:ffffea00017e6d80 refcount:1 mapcount:0 mapping:ffff888068b63740 index:0xffff88805f9b7d90 compound_mapcount: 0
>> flags: 0x100000000010200(slab|head)
>> raw: 0100000000010200 ffff888068b66450 ffff888068b66450 ffff888068b63740
>> raw: ffff88805f9b7d90 0000000000100001 00000001ffffffff 0000000000000000
>> page dumped because: kumsan: bad access detected
>> ==================================================================
>>
>> Signed-off-by: Lu Shuaibing <shuaibinglu@126.com>
> Looks good to me, will queue it up for -next after I've had time to run
> some tests - probably early next week.
>
> This made me realize that this refcount_set is too late, it is possible
> in theory to find the request with p9_tag_lookup as soon as the tag
> alloc worked so both this req->t_err and refcount initialization should
> go before the idr chunk with the other field initializations.
>
> I also checked by the way that no other fields were forgotten, the only
> field that is not initialized now is ->aux, but that field is never used
> so it might be just as fast to remove the field instead...
> I'll submit a couple of patches to move these two inits up and remove
> the aux field when I find time.
>
>
> Thanks!

Thanks for your reply. The kumsan tool finds only one field is used
initialized. The ->aux field could

be replaced.

