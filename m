Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA522BCA9
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 03:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfE1BE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 21:04:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51944 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727257AbfE1BE2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 21:04:28 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A2211C3242096969BE59;
        Tue, 28 May 2019 09:04:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 28 May 2019
 09:04:19 +0800
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
 <20190527075838.5a65abf9@hermes.lan>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a0fe690b-2bfa-7d1a-40c5-5fb95cf57d0b@huawei.com>
Date:   Tue, 28 May 2019 09:04:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190527075838.5a65abf9@hermes.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/27 22:58, Stephen Hemminger wrote:
> On Mon, 27 May 2019 09:47:54 +0800
> Yunsheng Lin <linyunsheng@huawei.com> wrote:
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
> Why not put link watch in its own workqueue so it is scheduled
> separately from the system workqueue?

From testing and debuging, the workqueue runs on the cpu where the
workqueue is schedule when using normal workqueue, even using its
own workqueue instead of system workqueue. So if the cpu is busy
processing the linkwatch event, it is not able to process other
workqueue' work when the workqueue is scheduled on the same cpu.

Using unbound workqueue may solve the cpu starvation problem.
But the __linkwatch_run_queue is called with rtnl_lock, so if it
takes a lot time to process, other need to take the rtnl_lock may
not be able to move forward.


> 
> 

