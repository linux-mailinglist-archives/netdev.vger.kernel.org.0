Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF02A150B3
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfEFPvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 11:51:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7174 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726357AbfEFPvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 11:51:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 321F46582DD6F97E3708;
        Mon,  6 May 2019 23:51:11 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 6 May 2019
 23:51:02 +0800
Subject: Re: [PATCH iproute2 v3] ipnetns: use-after-free problem in
 get_netnsid_from_name func
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <liuhangbin@gmail.com>, <kuznet@ms2.inr.ac.ru>,
        <nicolas.dichtel@6wind.com>, <phil@nwl.cc>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>,
        "Zhoukang (A)" <zhoukang7@huawei.com>, <kouhuiying@huawei.com>,
        <netdev@vger.kernel.org>
References: <f6c76a60-d5c4-700f-2fbf-912fc1545a31@huawei.com>
 <815afacc-4cd2-61b4-2181-aabce6582309@huawei.com>
 <1fca256d-fbce-4da9-471f-14573be4ea21@huawei.com>
 <20190506084230.196fee67@hermes.lan>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <03039f80-3abe-00ef-5174-f5c358fb6190@huawei.com>
Date:   Mon, 6 May 2019 23:50:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190506084230.196fee67@hermes.lan>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sat, 4 May 2019 15:26:25 +0800
> Zhiqiang Liu <liuzhiqiang26@huawei.com> wrote:
> 
>> From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>>
>> Follow the following steps:
>> # ip netns add net1
>> # export MALLOC_MMAP_THRESHOLD_=0
>> # ip netns list
>> then Segmentation fault (core dumped) will occur.
>>
>> In get_netnsid_from_name func, answer is freed before rta_getattr_u32(tb[NETNSA_NSID]),
>> where tb[] refers to answer`s content. If we set MALLOC_MMAP_THRESHOLD_=0, mmap will
>> be adoped to malloc memory, which will be freed immediately after calling free func.
>> So reading tb[NETNSA_NSID] will access the released memory after free(answer).
>>
>> Here, we will call get_netnsid_from_name(tb[NETNSA_NSID]) before free(answer).
>>
>> Fixes: 86bf43c7c2f ("lib/libnetlink: update rtnl_talk to support malloc buff at run time")
>> Reported-by: Huiying Kou <kouhuiying@huawei.com>
>> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
>> Acked-by: Phil Sutter <phil@nwl.cc>
> 
> Applied. You can get better and more detailed checks by running with
> valgrind. Which is what I did after applying your patch.

Thank you for your advice. I will learn how to use valgrind, and use it to
obtain more detailed checks.

> 
> .
> 

