Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6D823F636
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 05:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgHHDmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 23:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHDmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 23:42:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A87D6C061756;
        Fri,  7 Aug 2020 20:42:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C6B0F12786F41;
        Fri,  7 Aug 2020 20:26:00 -0700 (PDT)
Date:   Fri, 07 Aug 2020 20:42:43 -0700 (PDT)
Message-Id: <20200807.204243.696618708291045170.davem@davemloft.net>
To:     luobin9@huawei.com
Cc:     David.Laight@ACULAB.COM, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, luoxianjun@huawei.com,
        yin.yinshi@huawei.com, cloud.wangxiaoyun@huawei.com,
        chiqijun@huawei.com
Subject: Re: [PATCH net-next v1] hinic: fix strncpy output truncated
 compile warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
References: <20200807020914.3123-1-luobin9@huawei.com>
        <e7a4fcf12a4e4d179e2fae8ffb44f992@AcuMS.aculab.com>
        <b886a6ff-8ed8-c857-f190-e99f8f735e02@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 20:26:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "luobin (L)" <luobin9@huawei.com>
Date: Sat, 8 Aug 2020 11:36:42 +0800

> On 2020/8/7 17:32, David Laight wrote:
>>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>> b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>> index c6adc776f3c8..1ec88ebf81d6 100644
>>> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
>>> @@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
>>>
>>>  	level = event->event.chip.err_level;
>>>  	if (level < FAULT_LEVEL_MAX)
>>> -		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
>>> +		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
>> 
>> Have you even considered what that code is actually doing?
 ...
> I'm sorry that I haven't got what you mean and I haven't found any defects in that code. Can you explain more to me?

David is trying to express the same thing I was trying to explain to
you, you should use sizeof(level_str) as the third argument because
the code is trying to make sure that the destination buffer is not
overrun.

If you use the strlen() of the source buffer, the strncpy() can still
overflow the destination buffer.

Now do you understand?
