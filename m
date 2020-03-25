Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C230192D57
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgCYPtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:49:11 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:36069 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727840AbgCYPtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 11:49:09 -0400
Received: from [192.168.0.2] (ip5f5af719.dynamic.kabel-deutschland.de [95.90.247.25])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 16137202254DE;
        Wed, 25 Mar 2020 16:49:06 +0100 (CET)
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: bump up timeout to wait when ME
 un-configure ULP mode
To:     Sasha Neftin <sasha.neftin@intel.com>,
        Aaron Ma <aaron.ma@canonical.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        Rex Tsai <rex.tsai@intel.com>
References: <20200323191639.48826-1-aaron.ma@canonical.com>
 <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
 <2c765c59-556e-266b-4d0d-a4602db94476@intel.com>
 <899895bc-fb88-a97d-a629-b514ceda296d@canonical.com>
 <750ad0ad-816a-5896-de2f-7e034d2a2508@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <f9dc1980-fa8b-7df9-6460-b0944c7ebc43@molgen.mpg.de>
Date:   Wed, 25 Mar 2020 16:49:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <750ad0ad-816a-5896-de2f-7e034d2a2508@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux folks,


Am 25.03.20 um 14:58 schrieb Neftin, Sasha:
> On 3/25/2020 08:43, Aaron Ma wrote:

>> On 3/25/20 2:36 PM, Neftin, Sasha wrote:
>>> On 3/25/2020 06:17, Kai-Heng Feng wrote:

>>>>> On Mar 24, 2020, at 03:16, Aaron Ma <aaron.ma@canonical.com> wrote:
>>>>>
>>>>> ME takes 2+ seconds to un-configure ULP mode done after resume
>>>>> from s2idle on some ThinkPad laptops.
>>>>> Without enough wait, reset and re-init will fail with error.
>>>>
>>>> Thanks, this patch solves the issue. We can drop the DMI quirk in
>>>> favor of this patch.
>>>>
>>>>> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
>>>>> BugLink: https://bugs.launchpad.net/bugs/1865570
>>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>>> ---
>>>>> drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
>>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> index b4135c50e905..147b15a2f8b3 100644
>>>>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>>> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct
>>>>> e1000_hw *hw, bool force)
>>>>>              ew32(H2ME, mac_reg);
>>>>>          }
>>>>>
>>>>> -        /* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
>>>>> +        /* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
>>>>>          while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
>>>>> -            if (i++ == 30) {
>>>>> +            if (i++ == 250) {
>>>>>                  ret_val = -E1000_ERR_PHY;
>>>>>                  goto out;
>>>>>              }
>>>>
>>>> The return value was not caught by the caller, so the error ends up
>>>> unnoticed.
>>>> Maybe let the caller check the return value of
>>>> e1000_disable_ulp_lpt_lp()?

>>> I a bit confused. In our previous conversation you told ME not running.
>>> let me shimming in. Increasing delay won't be solve the problem and just
>>> mask it. We need to understand why ME take too much time. What is
>>> problem with this specific system?
>>> So, basically no ME system should works for you.
>>
>> Some laptops ME work that's why only reproduce issue on some laptops.
>> In this issue i219 is controlled by ME.
>
> Who can explain - why ME required too much time on this system?
> Probably need work with ME/BIOS vendor and understand it.
> Delay will just mask the real problem - we need to find root cause.
>> Quirk is only for 1 model type. But issue is reproduced by more models.
>> So it won't work.

(Where is Aaron’s reply? It wasn’t delivered to me yet.)

As this is clearly a regression, please revert the commit for now, and 
then find a way to correctly implement S0ix support. Linux’ regression 
policy demands that as no fix has been found since v5.5-rc1. Changing 
Intel ME settings, even if it would work around the issue, is not an 
acceptable solution. Delaying the resume time is also not a solution.

Regarding Intel Management Engine, only Intel knows what it does and 
what the error is, as the ME firmware is proprietary and closed.

Lastly, there is no way to fully disable the Intel Management Engine. 
The HAP stuff claims to stop the Intel ME execution, but nobody knows, 
if it’s successful.

Aaron, Kai-Hang, can you send the revert?


Kind regards,

Paul


