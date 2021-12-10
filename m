Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A5D470253
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbhLJOFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbhLJOFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:05:19 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA44C0617A1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:01:44 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mvgSw-0001Wl-TR; Fri, 10 Dec 2021 15:01:39 +0100
Message-ID: <5c5b606a-4694-be1b-0d4b-80aad1999bd9@leemhuis.info>
Date:   Fri, 10 Dec 2021 15:01:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
Content-Language: en-BS
To:     Stefan Dietrich <roots@gmx.de>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     kuba@kernel.org, greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, regressions@lists.linux.dev
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
 <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
 <87o85yljpu.fsf@intel.com>
 <063995d8-acf3-9f33-5667-f284233c94b4@leemhuis.info>
 <8e59b7d6b5d4674d5843bb45dde89e9881d0c741.camel@gmx.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <8e59b7d6b5d4674d5843bb45dde89e9881d0c741.camel@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639144904;6be6ba00;
X-HE-SMSGID: 1mvgSw-0001Wl-TR
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.12.21 14:45, Stefan Dietrich wrote:
> 
> thanks for keeping an eye on the issue. I've sent the files in private
> because I did not want to spam the mailing lists with them. Please let
> me know if this is the correct procedure.

It's likely okay in this case, but FWIW: most of the time it's the wrong
thing to do as outlined here:

https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html#general-advice-for-further-interactions

One reason for this: others that might want to look into the issue now
or a in a year or two might be unable to if crucial data was only sent
in private.

Ciao, Thorsten

> On Fri, 2021-12-10 at 10:40 +0100, Thorsten Leemhuis wrote:
>> Hi, this is your Linux kernel regression tracker speaking.
>>
>> On 02.12.21 23:34, Vinicius Costa Gomes wrote:
>>> Hi Stefan,
>>>
>>> Stefan Dietrich <roots@gmx.de> writes:
>>>
>>>> Hi Vinicius,
>>>>
>>>> thanks for the patch - unfortunately it did not solve the issue
>>>> and I
>>>> am still getting reboots/lockups.
>>>>
>>>
>>> Thanks for the test. We learned something, not a lot, but
>>> something: the
>>> problem you are facing is PTM related and it's not the same bug as
>>> that
>>> PM deadlock.
>>>
>>> I am still trying to understand what's going on.
>>>
>>> Are you able to send me the 'dmesg' output for the two kernel
>>> configs
>>> (CONFIG_PCIE_PTM enabled and disabled)? (no need to bring the
>>> network
>>> interface up or down). Your kernel .config would be useful as well.
>>
>> Stefan, could you provide the data Vinicius asked for? Or did you do
>> that in private already? Or was progress made somewhere else and I
>> simply missed this?
>>
>> Ciao, Thorsten, your Linux kernel regression tracker.
>>
>> P.S.: As a Linux kernel regression tracker I'm getting a lot of
>> reports
>> on my table. I can only look briefly into most of them. Unfortunately
>> therefore I sometimes will get things wrong or miss something
>> important.
>> I hope that's not the case here; if you think it is, don't hesitate
>> to
>> tell me about it in a public reply. That's in everyone's interest, as
>> what I wrote above might be misleading to everyone reading this; any
>> suggestion I gave they thus might sent someone reading this down the
>> wrong rabbit hole, which none of us wants.
>>
>> BTW, I have no personal interest in this issue, which is tracked
>> using
>> regzbot, my Linux kernel regression tracking bot
>> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
>> this mail to get things rolling again and hence don't need to be CC
>> on
>> all further activities wrt to this regression.
>>
>> #regzbot poke
>>
>>>> On Wed, 2021-12-01 at 10:57 -0800, Vinicius Costa Gomes wrote:
>>>>> Inspired by:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>>>>
>>>>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>>>>> ---
>>>>> Just to see if it's indeed the same problem as the bug report
>>>>> above.
>>>>>
>>>>>  drivers/net/ethernet/intel/igc/igc_main.c | 19 +++++++++++++
>>>>> ------
>>>>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> b/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> index 0e19b4d02e62..c58bf557a2a1 100644
>>>>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>>>>> @@ -6619,7 +6619,7 @@ static void
>>>>> igc_deliver_wake_packet(struct
>>>>> net_device *netdev)
>>>>>  	netif_rx(skb);
>>>>>  }
>>>>>
>>>>> -static int __maybe_unused igc_resume(struct device *dev)
>>>>> +static int __maybe_unused __igc_resume(struct device *dev,
>>>>> bool rpm)
>>>>>  {
>>>>>  	struct pci_dev *pdev = to_pci_dev(dev);
>>>>>  	struct net_device *netdev = pci_get_drvdata(pdev);
>>>>> @@ -6661,20 +6661,27 @@ static int __maybe_unused
>>>>> igc_resume(struct
>>>>> device *dev)
>>>>>
>>>>>  	wr32(IGC_WUS, ~0);
>>>>>
>>>>> -	rtnl_lock();
>>>>> +	if (!rpm)
>>>>> +		rtnl_lock();
>>>>>  	if (!err && netif_running(netdev))
>>>>>  		err = __igc_open(netdev, true);
>>>>>
>>>>>  	if (!err)
>>>>>  		netif_device_attach(netdev);
>>>>> -	rtnl_unlock();
>>>>> +	if (!rpm)
>>>>> +		rtnl_unlock();
>>>>>
>>>>>  	return err;
>>>>>  }
>>>>>
>>>>>  static int __maybe_unused igc_runtime_resume(struct device
>>>>> *dev)
>>>>>  {
>>>>> -	return igc_resume(dev);
>>>>> +	return __igc_resume(dev, true);
>>>>> +}
>>>>> +
>>>>> +static int __maybe_unused igc_resume(struct device *dev)
>>>>> +{
>>>>> +	return __igc_resume(dev, false);
>>>>>  }
>>>>>
>>>>>  static int __maybe_unused igc_suspend(struct device *dev)
>>>>> @@ -6738,7 +6745,7 @@ static pci_ers_result_t
>>>>> igc_io_error_detected(struct pci_dev *pdev,
>>>>>   *  @pdev: Pointer to PCI device
>>>>>   *
>>>>>   *  Restart the card from scratch, as if from a cold-boot.
>>>>> Implementation
>>>>> - *  resembles the first-half of the igc_resume routine.
>>>>> + *  resembles the first-half of the __igc_resume routine.
>>>>>   **/
>>>>>  static pci_ers_result_t igc_io_slot_reset(struct pci_dev
>>>>> *pdev)
>>>>>  {
>>>>> @@ -6777,7 +6784,7 @@ static pci_ers_result_t
>>>>> igc_io_slot_reset(struct pci_dev *pdev)
>>>>>   *
>>>>>   *  This callback is called when the error recovery driver
>>>>> tells us
>>>>> that
>>>>>   *  its OK to resume normal operation. Implementation
>>>>> resembles the
>>>>> - *  second-half of the igc_resume routine.
>>>>> + *  second-half of the __igc_resume routine.
>>>>>   */
>>>>>  static void igc_io_resume(struct pci_dev *pdev)
>>>>>  {
>>>
>>> Cheers,
>>>
> 
> 
> 
