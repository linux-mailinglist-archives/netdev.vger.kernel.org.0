Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631073FA564
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhH1L1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:27:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14432 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhH1L1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 07:27:24 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxZ1p73FnzbdN7;
        Sat, 28 Aug 2021 19:22:38 +0800 (CST)
Received: from [10.174.176.245] (10.174.176.245) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Sat, 28 Aug 2021 19:26:30 +0800
Subject: Re: Re: [PATCH v3 0/3] auth_gss: netns refcount leaks when
 use-gss-proxy==1
To:     "J. Bruce Fields" <bfields@fieldses.org>,
        Wenbin Zeng <wenbin.zeng@gmail.com>
CC:     <davem@davemloft.net>, <viro@zeniv.linux.org.uk>,
        <jlayton@kernel.org>, <trond.myklebust@hammerspace.com>,
        <anna.schumaker@netapp.com>, <wenbinzeng@tencent.com>,
        <dsahern@gmail.com>, <nicolas.dichtel@6wind.com>,
        <willy@infradead.org>, <edumazet@google.com>,
        <jakub.kicinski@netronome.com>, <tyhicks@canonical.com>,
        <chuck.lever@oracle.com>, <neilb@suse.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-nfs@vger.kernel.org>
References: <1556692945-3996-1-git-send-email-wenbinzeng@tencent.com>
 <1560341370-24197-1-git-send-email-wenbinzeng@tencent.com>
 <20190801195346.GA21527@fieldses.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <9cfbd851-81ce-e272-8693-d3430c381c7a@huawei.com>
Date:   Sat, 28 Aug 2021 19:26:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801195346.GA21527@fieldses.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2019/8/2 3:53, J. Bruce Fields Ð´µÀ:
> I lost track, what happened to these patches?
>
> --b.
>
> On Wed, Jun 12, 2019 at 08:09:27PM +0800, Wenbin Zeng wrote:
>> This patch series fixes an auth_gss bug that results in netns refcount
>> leaks when use-gss-proxy is set to 1.
>>
>> The problem was found in privileged docker containers with gssproxy service
>> enabled and /proc/net/rpc/use-gss-proxy set to 1, the corresponding
>> struct net->count ends up at 2 after container gets killed, the consequence
>> is that the struct net cannot be freed.
>>
>> It turns out that write_gssp() called gssp_rpc_create() to create a rpc
>> client, this increases net->count by 2; rpcsec_gss_exit_net() is supposed
>> to decrease net->count but it never gets called because its call-path is:
>>          net->count==0 -> cleanup_net -> ops_exit_list -> rpcsec_gss_exit_net
>> Before rpcsec_gss_exit_net() gets called, net->count cannot reach 0, this
>> is a deadlock situation.
>>
>> To fix the problem, we must break the deadlock, rpcsec_gss_exit_net()
>> should move out of the put() path and find another chance to get called,
>> I think nsfs_evict() is a good place to go, when netns inode gets evicted
>> we call rpcsec_gss_exit_net() to free the rpc client, this requires a new
>> callback i.e. evict to be added in struct proc_ns_operations, and add
>> netns_evict() as one of netns_operations as well.
>>
>> v1->v2:
>>   * in nsfs_evict(), move ->evict() in front of ->put()
>> v2->v3:
>>   * rpcsec_gss_evict_net() directly call gss_svc_shutdown_net() regardless
>>     if gssp_clnt is null, this is exactly same to what rpcsec_gss_exit_net()
>>     previously did
>>
>> Wenbin Zeng (3):
>>    nsfs: add evict callback into struct proc_ns_operations
>>    netns: add netns_evict into netns_operations
>>    auth_gss: fix deadlock that blocks rpcsec_gss_exit_net when
>>      use-gss-proxy==1
>>
>>   fs/nsfs.c                      |  2 ++
>>   include/linux/proc_ns.h        |  1 +
>>   include/net/net_namespace.h    |  1 +
>>   net/core/net_namespace.c       | 12 ++++++++++++
>>   net/sunrpc/auth_gss/auth_gss.c |  4 ++--
>>   5 files changed, 18 insertions(+), 2 deletions(-)
>>
>> -- 
>> 1.8.3.1
These patchsets don't seem to merge into the mainline, are there any 
other patches that fix this bug?
