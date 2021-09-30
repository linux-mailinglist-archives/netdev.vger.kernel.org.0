Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07441DDB6
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbhI3Pkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344621AbhI3Pkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 11:40:37 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5C6C06176A;
        Thu, 30 Sep 2021 08:38:54 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4HKy8C3MNBzQk9N;
        Thu, 30 Sep 2021 17:38:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
References: <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com> <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
 <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl>
 <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
 <CAHp75Vd5iCLELx8s+Zvcj8ufd2bN6CK26soDMkZyC1CwMO2Qeg@mail.gmail.com>
 <20210923202231.t2zjoejpxrbbe5hc@pali>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <db583b3c-6bfc-d765-a588-eb47c76cea31@v0yd.nl>
Date:   Thu, 30 Sep 2021 17:38:43 +0200
MIME-Version: 1.0
In-Reply-To: <20210923202231.t2zjoejpxrbbe5hc@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08D8D271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/21 10:22 PM, Pali Rohár wrote:
> On Thursday 23 September 2021 22:41:30 Andy Shevchenko wrote:
>> On Thu, Sep 23, 2021 at 6:28 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>> On 9/22/21 2:50 PM, Jonas Dreßler wrote:
>>
>> ...
>>
>>> - Just calling mwifiex_write_reg() once and then blocking until the card
>>> wakes up using my delay-loop doesn't fix the issue, it's actually
>>> writing multiple times that fixes the issue
>>>
>>> These observations sound a lot like writes (and even reads) are actually
>>> being dropped, don't they?
>>
>> It sounds like you're writing into a not ready (fully powered on) device.
> 
> This reminds me a discussion with Bjorn about CRS response returned
> after firmware crash / reset when device is not ready yet:
> https://lore.kernel.org/linux-pci/20210922164803.GA203171@bhelgaas/
> 
> Could not be this similar issue? You could check it via reading
> PCI_VENDOR_ID register from config space. And if it is not valid value
> then card is not really ready yet.
> 
>> To check this, try to put a busy loop for reading and check the value
>> till it gets 0.
>>
>> Something like
>>
>>    unsigned int count = 1000;
>>
>>    do {
>>      if (mwifiex_read_reg(...) == 0)
>>        break;
>>    } while (--count);
>>
>>
>> -- 
>> With Best Regards,
>> Andy Shevchenko

I've tried both reading PCI_VENDOR_ID and the firmware status using a 
busy loop now, but sadly none of them worked. It looks like the card 
always replies with the correct values even though it sometimes won't 
wake up after that.

I do have one new observation though, although I've no clue what could 
be happening here: When reading PCI_VENDOR_ID 1000 times to wakeup we 
can "predict" the wakeup failure because exactly one (usually around the 
20th) of those 1000 reads will fail. Maybe the firmware actually tries 
to wake up, encounters an error somewhere in its wakeup routines and 
then goes down a special failure code path. That code path keeps the 
cards CPU so busy that at some point a PCI_VENDOR_ID request times out?

Or well, maybe the card actually wakes up fine, but we don't receive the 
interrupt on our end, so many possibilities...
