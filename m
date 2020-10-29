Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76429E2BE
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404445AbgJ2CiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:38:02 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6923 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbgJ2Chj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:37:39 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CM8jv1XMSz6tv0;
        Thu, 29 Oct 2020 10:37:39 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 10:37:26 +0800
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Vishwanath Pai <vpai@akamai.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com>
 <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
 <CAM_iQpX0XzNDCzc2U5=g6aU-HGYs3oryHx=rmM3ue9sH=Jd4Gw@mail.gmail.com>
 <19f888c2-8bc1-ea56-6e19-4cb4841c4da0@akamai.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <93ab7f0f-7b5a-74c3-398d-a572274a4790@huawei.com>
Date:   Thu, 29 Oct 2020 10:37:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <19f888c2-8bc1-ea56-6e19-4cb4841c4da0@akamai.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/29 4:04, Vishwanath Pai wrote:
> On 10/28/20 1:47 PM, Cong Wang wrote:
>> On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath <vpai@akamai.com> wrote:
>>> Hi,
>>>
>>> We noticed some problems when testing the latest 5.4 LTS kernel and traced it
>>> back to this commit using git bisect. When running our tests the machine stops
>>> responding to all traffic and the only way to recover is a reboot. I do not see
>>> a stack trace on the console.
>>
>> Do you mean the machine is still running fine just the network is down?
>>
>> If so, can you dump your tc config with stats when the problem is happening?
>> (You can use `tc -s -d qd show ...`.)
>>
>>>
>>> This can be reproduced using the packetdrill test below, it should be run a
>>> few times or in a loop. You should hit this issue within a few tries but
>>> sometimes might take up to 15-20 tries.
>> ...
>>> I can reproduce the issue easily on v5.4.68, and after reverting this commit it
>>> does not happen anymore.
>>
>> This is odd. The patch in this thread touches netdev reset path, if packetdrill
>> is the only thing you use to trigger the bug (that is netdev is always active),
>> I can not connect them.
>>
>> Thanks.
> 
> Hi Cong,
> 
>> Do you mean the machine is still running fine just the network is down?
> 
> I was able to access the machine via serial console, it looks like it is
> up and running, just that networking is down.
> 
>> If so, can you dump your tc config with stats when the problem is happening?
>> (You can use `tc -s -d qd show ...`.)
> 
> If I try running tc when the machine is in this state the command never
> returns. It doesn't print anything but doesn't exit either.
> 
>> This is odd. The patch in this thread touches netdev reset path, if packetdrill
>> is the only thing you use to trigger the bug (that is netdev is always active),
>> I can not connect them.
> 
> I think packetdrill creates a tun0 interface when it starts the
> test and tears it down at the end, so it might be hitting this code path
> during teardown.

Hi, Is there any preparation setup before running the above packetdrill test
case, I run the above test case in 5.9-rc4 with this patch applied without any
preparation setup, did not reproduce it.

By the way, I am newbie to packetdrill:), it would be good to provide the
detail setup to reproduce it,thanks.

> 
> P.S: My mail server is having connectivity issues with vger.kernel.org
> so messages aren't getting delivered to netdev. It'll hopefully get
> resolved soon.
> 
> Thanks,
> Vishwanath
> 
> 
> .
> 
