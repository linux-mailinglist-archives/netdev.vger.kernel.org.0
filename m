Return-Path: <netdev+bounces-7340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D475671FC56
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:45:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 649B71C20BE4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:45:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B998379FB;
	Fri,  2 Jun 2023 08:45:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A5B5687
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:45:06 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE41E67;
	Fri,  2 Jun 2023 01:44:32 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aebf4.dynamic.kabel-deutschland.de [95.90.235.244])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2F6E361EA1BFF;
	Fri,  2 Jun 2023 10:43:27 +0200 (CEST)
Message-ID: <577f38ed-8532-c32e-07bd-4a3b384d5fe8@molgen.mpg.de>
Date: Fri, 2 Jun 2023 10:43:27 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Use PME poll to circumvent
 unreliable ACPI wake
Content-Language: en-US
To: Kai-Heng Feng <kai.heng.feng@canonical.com>,
 Alexander H Duyck <alexander.duyck@gmail.com>
Cc: linux-pm@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org
References: <20230601162537.1163270-1-kai.heng.feng@canonical.com>
 <269262acfcce8eb1b85ee1fe3424a5ef2991f481.camel@gmail.com>
 <CAAd53p7c6eEqxd3jecfgvpxuYO3nmmmovcqD=3PgbqSVCWFfxA@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAAd53p7c6eEqxd3jecfgvpxuYO3nmmmovcqD=3PgbqSVCWFfxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[Cc: linux-pci@vger.kernel.org]

Dear Kai,


Thank you for your patch.

Am 02.06.23 um 03:46 schrieb Kai-Heng Feng:
> On Fri, Jun 2, 2023 at 4:24 AM Alexander H Duyck wrote:
>>
>> On Fri, 2023-06-02 at 00:25 +0800, Kai-Heng Feng wrote:
>>> On some I219 devices, ethernet cable plugging detection only works once
>>> from PCI D3 state. Subsequent cable plugging does set PME bit correctly,
>>> but device still doesn't get woken up.

Could you please add the list of all the devices with the firmware 
version, you know this problem exists on? Please also add the URLs of 
the bug reports at the end of the commit message.

Is that problem logged somehow? Could a log message be added first?

>> Do we have a root cause on why things don't get woken up? This seems
>> like an issue where something isn't getting reset after the first
>> wakeup and so future ones are blocked.
> 
> No we don't know the root cause.
> I guess the D3 wake isn't really tested under Windows because I219
> doesn't use runtime D3 on Windows.

How do you know? Where you able to look at the Microsoft Windows driver 
source code?

>>> Since I219 connects to the root complex directly, it relies on platform
>>> firmware (ACPI) to wake it up. In this case, the GPE from _PRW only
>>> works for first cable plugging but fails to notify the driver for
>>> subsequent plugging events.
>>>
>>> The issue was originally found on CNP, but the same issue can be found
>>> on ADL too. So workaround the issue by continuing use PME poll after

The verb is spelled with a space: work around.

>>> first ACPI wake. As PME poll is always used, the runtime suspend
>>> restriction for CNP can also be removed.

When was that restriction for CNP added?

>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>>   drivers/net/ethernet/intel/e1000e/netdev.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> index bd7ef59b1f2e..f0e48f2bc3a2 100644
>>> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
>>> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
>>> @@ -7021,6 +7021,8 @@ static __maybe_unused int e1000e_pm_runtime_resume(struct device *dev)
>>>        struct e1000_adapter *adapter = netdev_priv(netdev);
>>>        int rc;
>>>
>>> +     pdev->pme_poll = true;
>>> +
>>>        rc = __e1000_resume(pdev);
>>>        if (rc)
>>>                return rc;
>>
>> Doesn't this enable this too broadly. I know there are a number of
>> devices that run under the e1000e and I would imagine that we don't
>> want them all running with "pme_poll = true" do we?
> 
> Whack a mole isn't scaling, either.
> The generation between CNP and ADL are probably affected too.
> 
>> It seems like at a minimum we should only be setting this for specific
>> platofrms or devices instead of on all of them.
>>
>> Also this seems like something we should be setting on the suspend side
>> since it seems to be cleared in the wakeup calls.
> 
> pme_poll gets cleared on wakeup, and once it's cleared the device will
> be removed from pci_pme_list.
> 
> To prevent that, reset pme_poll to true immediately on runtime resume.
> 
>> Lastly I am not sure the first one is necessarily succeeding. You might
>> want to check the status of pme_poll before you run your first test.
>> From what I can tell it looks like the initial state is true in
>> pci_pm_init. If so it might be getting cleared after the first wakeup
>> which is what causes your issues.
> 
> That's by design. pme_poll gets cleared when the hardware is capable
> to signal wakeup via PME# or ACPI GPE. For detected hardwares, the
> pme_poll will never be cleared.
> So this becomes tricky for the issue, since the ACPI GPE works for
> just one time, but never again.
> 
>>> @@ -7682,7 +7684,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>
>>>        dev_pm_set_driver_flags(&pdev->dev, DPM_FLAG_SMART_PREPARE);
>>>
>>> -     if (pci_dev_run_wake(pdev) && hw->mac.type != e1000_pch_cnp)
>>> +     if (pci_dev_run_wake(pdev))
>>>                pm_runtime_put_noidle(&pdev->dev);
>>>
>>>        return 0;
>>
>> I assume this is the original workaround that was put in to address
>> this issue. Perhaps you should add a Fixes tag to this to identify
>> which workaround this patch is meant to be replacing.
> 
> Another possibility is to remove runtime power management completely.
> I wonder why Windows keep the device at D0 all the time?

Who knows how to contact Intel’s driver developers for Microsoft Windows?

> Can Linux align with Windows?

Before deciding this, the power usage in the different states should be 
measured.


Kind regards,

Paul

