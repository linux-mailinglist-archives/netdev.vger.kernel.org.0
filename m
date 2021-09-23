Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B55341620A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 17:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241967AbhIWPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 11:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhIWPaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 11:30:06 -0400
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685AFC061574;
        Thu, 23 Sep 2021 08:28:34 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4HFfFX2FTWzQk1m;
        Thu, 23 Sep 2021 17:28:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
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
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com> <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
 <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl>
Message-ID: <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
Date:   Thu, 23 Sep 2021 17:28:24 +0200
MIME-Version: 1.0
In-Reply-To: <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF86118B0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 2:50 PM, Jonas Dreßler wrote:
> On 9/20/21 7:48 PM, Brian Norris wrote:
>> On Sat, Sep 18, 2021 at 12:37 AM Jonas Dreßler <verdre@v0yd.nl> wrote:
>>> Thanks for the pointer to that commit Brian, it turns out this is
>>> actually the change that causes the "Firmware wakeup failed" issues that
>>> I'm trying to fix with the second patch here.
>>
>> Huh. That's interesting, although I guess it makes some sense given
>> your theory of "dropped writes". FWIW, this strategy (post a single
>> write, then wait for wakeup) is the same used by some other
>> chips/drivers too (e.g., ath10k/pci), although in those cases card
>> wakeup is much much faster. But if the bus was dropping writes
>> somehow, those strategies would fail too.
>>
>>> Also my approach is a lot messier than just reverting
>>> 062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3 and also appears to be blocking
>>> even longer...
>>
>> For the record, in case you're talking about my data ("blocking even
>> longer"): I was only testing patch 1. Patch 2 isn't really relevant to
>> my particular systems (Rockchip RK3399 + Marvell 8997/PCIe), because
>> (a) I'm pretty sure my system isn't "dropping" any reads or writes
>> (b) all my delay is in the read-back; the Rockchip PCIe bus is waiting
>> indefinitely for the card to wake up, instead of timing out and
>> reporting all-1's like many x86 systems appear to do (I've tested
>> this).
>>
>> So, the 6ms delay is entirely sitting in the ioread32(), not a delay 
>> loop.
>>
>> I haven't yet tried your version 2 (which avoids the blocking read to
>> wake up; good!), but it sounds like in theory it could solve your
>> problem while avoiding 6ms delays for me. I intend to test your v2
>> this week.
>>
> 
> With "blocking even longer" I meant that (on my system) the delay-loop 
> blocks even longer than waking up the card via mwifiex_read_reg() (both 
> are in the orders of milliseconds). And given that in certain cases the 
> card wakeup (or a write getting through to the card, I have no idea) can 
> take extremely long, I'd feel more confident going with the 
> mwifiex_read_reg() method to wake up the card.
> 
> Anyway, you know what's even weirder with all this: I've been testing 
> the first commit of patch v2 (so just the single read-back instead of 
> the big hammer) together with 062e008a6e83e7c4da7df0a9c6aefdbc849e2bb3 
> reverted for a good week now and haven't seen any wakeup failure yet. 
> Otoh I'm fairly sure the big hammer with reading back every write wasn't 
> enough to fix the wakeup failures, otherwise I wouldn't even have 
> started working on the second commit.
> 
> So that would mean there's a difference between writing and then reading 
> back vs only reading to wake up the card: Only the latter fixes the 
> wakeup failures.
> 
>>> Does anyone have an idea what could be the reason for the posted write
>>> not going through, or could that also be a potential firmware bug in the
>>> chip?
>>
>> I have no clue about that. That does sound downright horrible, but so
>> are many things when dealing with this family of hardware/firmware.
>> I'm not sure how to prove out whether this is a host bus problem, or
>> an endpoint/firmware problem, other than perhaps trying the same
>> module/firmware on another system, if that's possible.
>>
>> Anyway, to reiterate: I'm not fundamentally opposed to v2 (pending a
>> test run here), even if it is a bit ugly and perhaps not 100%
>> understood.
>>
> 
> I'm not 100% sure about all this yet, I think I'm gonna try to confirm 
> my older findings once again now and then we'll see. FTR, would you be 
> fine with using the mwifiex_read_reg() method to wake up the card and 
> somehow quirking your system to use write_reg()?
> 
>> Brian
>>
> 

Okay, so I finally managed to find my exact reproducer for the bug again:

1) Make sure wifi powersaving is enabled (iw dev wlp1s0 set power_save on)
2) Connect to any wifi network (makes firmware go into wifi powersaving 
mode, not deep sleep)
3) Make sure bluetooth is turned off (to ensure the firmware actually 
enters powersave mode and doesn't keep the radio active doing bluetooth 
stuff)
4) To confirm that wifi powersaving is entered ping a device on the LAN, 
pings should be a few ms higher than without powersaving
5) Run "while true; do iwconfig; sleep 0.0001; done", this wakes and 
suspends the firmware extremely often
6) Wait until things explode, for me it consistently takes <5 minutes

Using this reproducer I was able to clear things up a bit:

- There still are wakeup failures when using (only) mwifiex_read_reg() 
to wake the card, so there's no weird difference between waking up using 
read vs write+read-back

- Just calling mwifiex_write_reg() once and then blocking until the card 
wakes up using my delay-loop doesn't fix the issue, it's actually 
writing multiple times that fixes the issue

These observations sound a lot like writes (and even reads) are actually 
being dropped, don't they?
