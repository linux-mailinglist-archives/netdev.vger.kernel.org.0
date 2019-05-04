Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0FA13726
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfEDDlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:41:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDDlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:41:40 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EF3B14D68898;
        Fri,  3 May 2019 20:41:35 -0700 (PDT)
Date:   Fri, 03 May 2019 23:41:31 -0400 (EDT)
Message-Id: <20190503.234131.1909607319842703379.davem@davemloft.net>
To:     baijiaju1990@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: via-rhine: net: Fix a resource leak in
 rhine_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f2e7c284-aa70-2b67-b9dd-461db102cbc5@gmail.com>
References: <20190504030813.17684-1-baijiaju1990@gmail.com>
        <20190503.231308.1440125282445011089.davem@davemloft.net>
        <f2e7c284-aa70-2b67-b9dd-461db102cbc5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:41:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Date: Sat, 4 May 2019 11:23:06 +0800

> 
> 
> On 2019/5/4 11:13, David Miller wrote:
>> From: Jia-Ju Bai <baijiaju1990@gmail.com>
>> Date: Sat,  4 May 2019 11:08:13 +0800
>>
>>> When platform_driver_register() fails, pci_unregister_driver() is not
>>> called to release the resource allocated by pci_register_driver().
>>>
>>> To fix this bug, error handling code for platform_driver_register()
>>> and
>>> pci_register_driver() is separately implemented.
>>>
>>> This bug is found by a runtime fuzzing tool named FIZZER written by
>>> us.
>>>
>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> I think the idea here is that PCI is not enabled in the kernel, it is
>> fine for the pci register to fail and only the platform register to
>> succeed.
>>
>> You are breaking that.
> 
> Okay, I can understand it.
> If so, I think that platform_driver_register() should be called before
> pci_register_driver(), and it is still necessary to separately handle
> their errors.
> If you agree, I will send a v2 patch.

It is only a failure if both fail.

If at least one succeeds, the driver can potentially probe properly.
