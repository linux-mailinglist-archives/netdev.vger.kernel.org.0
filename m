Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A8733D741
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhCPPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:23:04 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:16028 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbhCPPWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615908155; x=1647444155;
  h=to:cc:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding:subject;
  bh=q5kbSbegqpzzJVt427pixcj7nixefER90+FzIpRlpB8=;
  b=WQkuVq8ouM/Unya6UcskLx+9ggTRFMeULTPvUxUKz4K9kFjfmJ1plrZ2
   w7zFhTUoIoQPJ/nXp7iE35ICosV1ogFtiQUgnvj89hYXkEXU6k27RmJsF
   jjSyED8Yl4U2aX7K6JzdfWcq27CMMPJItdn/Pf3lP4YF9aaFoCrWbgy+l
   c=;
X-IronPort-AV: E=Sophos;i="5.81,251,1610409600"; 
   d="scan'208";a="94984210"
Subject: Re: [net-next 1/2] xen-netback: add module parameter to disable ctrl-ring
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 16 Mar 2021 15:22:25 +0000
Received: from EX13D12EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-456ef9c9.us-west-2.amazon.com (Postfix) with ESMTPS id 0861EA7AF9;
        Tue, 16 Mar 2021 15:22:23 +0000 (UTC)
Received: from 147dda3ee008.ant.amazon.com (10.43.165.192) by
 EX13D12EUA002.ant.amazon.com (10.43.165.103) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 16 Mar 2021 15:22:22 +0000
To:     Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <wei.liu@kernel.org>, <paul@xen.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <xen-devel@lists.xenproject.org>
References: <20210311225944.24198-1-andyhsu@amazon.com>
 <YEuAKNyU6Hma39dN@lunn.ch> <ec5baac1-1410-86e4-a0d1-7c7f982a0810@amazon.com>
 <YEvQ6z5WFf+F4mdc@lunn.ch> <YE3foiFJ4sfiFex2@unreal>
From:   "Hsu, Chiahao" <andyhsu@amazon.com>
Message-ID: <64f5c7a8-cc09-3a7f-b33b-a64d373aed60@amazon.com>
Date:   Tue, 16 Mar 2021 16:22:21 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YE3foiFJ4sfiFex2@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.165.192]
X-ClientProxiedBy: EX13D01EUA004.ant.amazon.com (10.43.165.123) To
 EX13D12EUA002.ant.amazon.com (10.43.165.103)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Leon Romanovsky 於 2021/3/14 11:04 寫道:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>
>
>
> On Fri, Mar 12, 2021 at 09:36:59PM +0100, Andrew Lunn wrote:
>> On Fri, Mar 12, 2021 at 04:18:02PM +0100, Hsu, Chiahao wrote:
>>> Andrew Lunn 於 2021/3/12 15:52 寫道:
>>>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>>>
>>>>
>>>>
>>>> On Thu, Mar 11, 2021 at 10:59:44PM +0000, ChiaHao Hsu wrote:
>>>>> In order to support live migration of guests between kernels
>>>>> that do and do not support 'feature-ctrl-ring', we add a
>>>>> module parameter that allows the feature to be disabled
>>>>> at run time, instead of using hardcode value.
>>>>> The default value is enable.
>>>> Hi ChiaHao
>>>>
>>>> There is a general dislike for module parameters. What other mechanisms
>>>> have you looked at? Would an ethtool private flag work?
>>>>
>>>>        Andrew
>>>
>>> Hi Andrew,
>>>
>>> I can survey other mechanisms, however before I start doing that,
>>>
>>> could you share more details about what the problem is with using module
>>> parameters? thanks.
>> It is not very user friendly. No two kernel modules use the same
>> module parameters. Often you see the same name, but different
>> meaning. There is poor documentation, you often need to read the
>> kernel sources it figure out what it does, etc.
> +1, It is also global parameter to whole system/devices that use this
> module, which is rarely what users want.
>
> Thanks

Hi,
I think I would say the current implementation(modparams) isappropriate
after reviewing it again.

We are talking about 'feature leveling', a way to support live 
migrationof guest
between kernels that do and do not support the features. So we want to 
refrain
fromadding the features if guest would be migrated to the kernel which does
not support the feature. Everythingshould be done (in probe function) before
frontend connects, and this is why ethtool is not appropriate for this.

Thanks


