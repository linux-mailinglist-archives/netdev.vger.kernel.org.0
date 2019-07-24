Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C67273C34
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392560AbfGXUHG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 24 Jul 2019 16:07:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51098 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392493AbfGXUHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:07:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CD3C15430736;
        Wed, 24 Jul 2019 13:07:05 -0700 (PDT)
Date:   Wed, 24 Jul 2019 13:07:02 -0700 (PDT)
Message-Id: <20190724.130702.1012545920232372108.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
From:   David Miller <davem@davemloft.net>
In-Reply-To: <0ef47dc2-efdd-531f-d1a0-6f4d0d1b9f13@pensando.io>
References: <59e45fd2-3c62-58cf-cf63-935d17703d2c@pensando.io>
        <20190723.160538.2065000079755912945.davem@davemloft.net>
        <0ef47dc2-efdd-531f-d1a0-6f4d0d1b9f13@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 13:07:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 24 Jul 2019 10:49:09 -0700

> On 7/23/19 4:05 PM, David Miller wrote:
>> From: Shannon Nelson <snelson@pensando.io>
>> Date: Tue, 23 Jul 2019 15:50:22 -0700
>>
>>> On 7/23/19 2:18 PM, David Miller wrote:
>>>> From: Shannon Nelson <snelson@pensando.io>
>>>> Date: Mon, 22 Jul 2019 14:40:06 -0700
>>>>
>>>>> +void ionic_init_devinfo(struct ionic_dev *idev)
>>>>> +{
>>>>> + idev->dev_info.asic_type = ioread8(&idev->dev_info_regs->asic_type);
>>>>> + idev->dev_info.asic_rev = ioread8(&idev->dev_info_regs->asic_rev);
>>>>> +
>>>>> +	memcpy_fromio(idev->dev_info.fw_version,
>>>>> +		      idev->dev_info_regs->fw_version,
>>>>> +		      IONIC_DEVINFO_FWVERS_BUFLEN);
>>>>> +
>>>>> +	memcpy_fromio(idev->dev_info.serial_num,
>>>>> +		      idev->dev_info_regs->serial_num,
>>>>> +		      IONIC_DEVINFO_SERIAL_BUFLEN);
>>>>    ...
>>>>> +	sig = ioread32(&idev->dev_info_regs->signature);
>>>> I think if you are going to use the io{read,write}{8,16,32,64}()
>>>> interfaces then you should use io{read,write}{8,16,32,64}_rep()
>>>> instead of memcpy_{to,from}io().
>>>>
>>> Sure.
>> Note, I could be wrong.  Please test.
>>
>> I think the operation of the two things might be different.
> Yes, they are different things, the iowrite*_rep() functions write
> each value from a buffer all to the same single address, rather than
> copy a buffer into another buffer, and the ioread*_rep() functions
> repeatedly read from the same address to fill a buffer.
> 
> For example, the iowrite32_rep() boils down to this:
>         do {
>             __raw_writel(*buf++, addr);
>         } while (--count);
> 
> Not quite what I need.

That's what I suspected.
