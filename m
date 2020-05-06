Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0E41C65B0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 03:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgEFBuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 21:50:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3851 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728069AbgEFBuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 21:50:54 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7772AED51D9EDAEEF549;
        Wed,  6 May 2020 09:50:52 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.99) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 09:50:44 +0800
Subject: Re: cgroup pointed by sock is leaked on mode switch
To:     Tejun Heo <tj@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        "Libin (Huawei)" <huawei.libin@huawei.com>, <guofan5@huawei.com>,
        <wangkefeng.wang@huawei.com>, <lizefan@huawei.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
 <20200505160639.GG12217@mtj.thefacebook.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <c9879fd2-cb91-2a08-8293-c6a436b5a539@huawei.com>
Date:   Wed, 6 May 2020 09:50:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505160639.GG12217@mtj.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.215.99]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+cc lizefan@huawei.com

On 2020/5/6 0:06, Tejun Heo wrote:
> Hello, Yang.
>
> On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
>> I find the number nr_dying_descendants is increasing:
>> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
>> '^nr_dying_descendants [^0]'  {} +
>> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
>> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
>> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants
>> 1
>> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants
>> 78
>> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants
>> 78
> Those numbers are nowhere close to causing oom issues. There are some
> aspects of page and other cache draining which is being improved but unless
> you're seeing numbers multiple orders of magnitude higher, this isn't the
> source of your problem.
>
>> The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add
>> sock->sk_cgroup") describes.
>> "On mode switch, cgroup references which are already being pointed to by
>> socks may be leaked."
> I'm doubtful that you're hitting that issue. Mode switching means memcg
> being switched between cgroup1 and cgroup2 hierarchies, which is unlikely to
> be what's happening when you're launching docker containers.
>
> The first step would be identifying where memory is going and finding out
> whether memcg is actually being switched between cgroup1 and 2 - look at the
> hierarchy number in /proc/cgroups, if that's switching between 0 and
> someting not zero, it is switching.
>
> Thanks.
>

