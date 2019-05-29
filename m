Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C22F92D865
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE2I70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:59:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:17603 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfE2I7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:59:25 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7F31D5AE3A8FF4DC23B1;
        Wed, 29 May 2019 16:59:23 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 29 May 2019
 16:59:13 +0800
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
To:     David Miller <davem@davemloft.net>
CC:     <hkallweit1@gmail.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
 <20190528.235806.323127882998745493.davem@davemloft.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6e9b41c9-6edb-be7f-07ee-5480162a227e@huawei.com>
Date:   Wed, 29 May 2019 16:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190528.235806.323127882998745493.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/29 14:58, David Miller wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Mon, 27 May 2019 09:47:54 +0800
> 
>> When user has configured a large number of virtual netdev, such
>> as 4K vlans, the carrier on/off operation of the real netdev
>> will also cause it's virtual netdev's link state to be processed
>> in linkwatch. Currently, the processing is done in a work queue,
>> which may cause worker starvation problem for other work queue.
>>
>> This patch releases the cpu when link watch worker has processed
>> a fixed number of netdev' link watch event, and schedule the
>> work queue again when there is still link watch event remaining.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> Why not rtnl_unlock(); yield(); rtnl_lock(); every "100" events
> processed?
> 
> That seems better than adding all of this overhead to reschedule the
> workqueue every 100 items.

One minor concern, the above solution does not seem to solve the cpu
starvation for other normal workqueue which was scheduled on the same
cpu as linkwatch. Maybe I misunderstand the workqueue or there is other
consideration here? :)

Anyway, I will implemet it as you suggested and test it before posting V2.
Thanks.

> 
> .
> 

