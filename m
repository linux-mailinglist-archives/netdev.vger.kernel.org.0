Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E388817CB6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfEHO7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:59:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:32920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbfEHO7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 10:59:34 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E4DE4F78B63A55120F8E;
        Wed,  8 May 2019 22:59:29 +0800 (CST)
Received: from [127.0.0.1] (10.184.227.228) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 22:59:21 +0800
Subject: Re: [PATCH 3/3] net-sysfs: Fix error path for kobject_init_and_add()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Tobin C. Harding" <tobin@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tyler Hicks <tyhicks@canonical.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-4-tobin@kernel.org>
 <20190430161124.GM9224@smile.fi.intel.com>
From:   "wanghai (M)" <wanghai26@huawei.com>
Message-ID: <2062f0d4-e51f-106e-cd0b-f0464d06f517@huawei.com>
Date:   Wed, 8 May 2019 22:52:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190430161124.GM9224@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.227.228]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/5/1 0:11, Andy Shevchenko 写道:
> On Tue, Apr 30, 2019 at 10:28:17AM +1000, Tobin C. Harding wrote:
>> Currently error return from kobject_init_and_add() is not followed by a
>> call to kobject_put().  This means there is a memory leak.
>>
>> Add call to kobject_put() in error path of kobject_init_and_add().
> It's not obvious to me if this will help to fix what is stated in the
> (reverted) commit 6b70fc94afd1 ("net-sysfs: Fix memory leak in
> netdev_register_kobject")?
>
> If so, perhaps we need to tell syzkaller guys about this.
Thanks for reminding. It seems that the bug has not been completely fixed.

in netdev_register_kobject():

1746         error = device_add(dev);
1747         if (error)
1748                 return error;
1749
1750         error = register_queue_kobjects(ndev);
1751         if (error) {
1752                 device_del(dev);
1753                 return error;
1754         }

This only fixes a memory leak after a failure in 
register_queue_kobjects(). If device_add() fails, kobject_put() still 
cann't be called, and the memory leak still exists.

