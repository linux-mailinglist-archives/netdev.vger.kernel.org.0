Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BC5206ABB
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 05:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388776AbgFXDlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 23:41:24 -0400
Received: from mail.loongson.cn ([114.242.206.163]:45244 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388519AbgFXDlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 23:41:24 -0400
Received: from [10.130.0.66] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Ax9ulby_JeVBBJAA--.524S3;
        Wed, 24 Jun 2020 11:41:16 +0800 (CST)
Subject: Re: [PATCH RESEND] net/cisco: Fix a sleep-in-atomic-context bug in
 enic_init_affinity_hint()
To:     David Miller <davem@davemloft.net>
References: <20200623.143311.995885759487352025.davem@davemloft.net>
 <20200623.152626.2206118203643133195.davem@davemloft.net>
 <7533075e-0e8e-2fde-c8fa-72e2ea222176@loongson.cn>
 <20200623.202324.442008830004872069.davem@davemloft.net>
Cc:     benve@cisco.com, _govind@gmx.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lixuefeng@loongson.cn,
        yangtiezhu@loongson.cn
From:   Kaige Li <likaige@loongson.cn>
Message-ID: <70519029-1cfa-5fce-52f3-cfb13bf00f7d@loongson.cn>
Date:   Wed, 24 Jun 2020 11:41:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <20200623.202324.442008830004872069.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Ax9ulby_JeVBBJAA--.524S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Jry8Xr15Zw48JF15CF45Wrg_yoWDCrcE9F
        yj93s7G345Xr4UtwnrJws5ur4ktw10krW5Z3y5XFWY9wn5tFWUGF4DC342vF4xWFZ7Zr9F
        kwnaqF15Zr129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb0D73
        UUUUU==
X-CM-SenderInfo: 5olntxtjh6z05rqj20fqof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/24/2020 11:23 AM, David Miller wrote:
> From: Kaige Li <likaige@loongson.cn>
> Date: Wed, 24 Jun 2020 09:56:47 +0800
>
>> On 06/24/2020 06:26 AM, David Miller wrote:
>>> From: David Miller <davem@davemloft.net>
>>> Date: Tue, 23 Jun 2020 14:33:11 -0700 (PDT)
>>>
>>>> Calling a NIC driver open function from a context holding a spinlock
>>>> is very much the real problem, so many operations have to sleep and
>>>> in face that ->ndo_open() method is defined as being allowed to sleep
>>>> and that's why the core networking never invokes it with spinlocks
>>>                                                         ^^^^
>>>
>>> I mean "without" of course. :-)
>>>
>>>> held.
>> Did you mean that open function should be out of spinlock? If so, I
>> will
>> send V2 patch.
> Yes, but only if that is safe.
>
> You have to analyze the locking done by this driver and fix it properly.
> I anticipate it is not just a matter of changing where the spinlock
> is held, you will have to rearchitect things a bit.

Okay, I will careful analyze this question, and make a suitable patch in V2.

Thank you.

