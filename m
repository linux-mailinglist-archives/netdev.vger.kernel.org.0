Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3C43192A9D
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbgCYN6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:58:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:10418 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbgCYN6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 09:58:23 -0400
IronPort-SDR: V9Bot/xFNlAp1BwJGAPiIBt57jcSVl197M5O5zPW2mNzKgfmRB1RDs5Z6hqkcyDeSE7VCAG4PJ
 qr8R86Zk8sgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 06:58:22 -0700
IronPort-SDR: o9zSkCT5hDK5XmHbZCnGADHqvotdopCLhW8E7HR5FuWibpPdWFbThBbapqlEXWRUKcXKKgDD7J
 sbLcFc/fPbFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,304,1580803200"; 
   d="scan'208";a="235943153"
Received: from sneftin-mobl1.ger.corp.intel.com (HELO [10.214.229.188]) ([10.214.229.188])
  by orsmga007.jf.intel.com with ESMTP; 25 Mar 2020 06:58:18 -0700
Subject: Re: [PATCH] e1000e: bump up timeout to wait when ME un-configure ULP
 mode
To:     Aaron Ma <aaron.ma@canonical.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>, rex.tsai@intel.com
References: <20200323191639.48826-1-aaron.ma@canonical.com>
 <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
 <2c765c59-556e-266b-4d0d-a4602db94476@intel.com>
 <899895bc-fb88-a97d-a629-b514ceda296d@canonical.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <750ad0ad-816a-5896-de2f-7e034d2a2508@intel.com>
Date:   Wed, 25 Mar 2020 15:58:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <899895bc-fb88-a97d-a629-b514ceda296d@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/2020 08:43, Aaron Ma wrote:
> 
> 
> On 3/25/20 2:36 PM, Neftin, Sasha wrote:
>> On 3/25/2020 06:17, Kai-Heng Feng wrote:
>>> Hi Aaron,
>>>
>>>> On Mar 24, 2020, at 03:16, Aaron Ma <aaron.ma@canonical.com> wrote:
>>>>
>>>> ME takes 2+ seconds to un-configure ULP mode done after resume
>>>> from s2idle on some ThinkPad laptops.
>>>> Without enough wait, reset and re-init will fail with error.
>>>
>>> Thanks, this patch solves the issue. We can drop the DMI quirk in
>>> favor of this patch.
>>>
>>>>
>>>> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
>>>> BugLink: https://bugs.launchpad.net/bugs/1865570
>>>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>>>> ---
>>>> drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
>>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>> b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>> index b4135c50e905..147b15a2f8b3 100644
>>>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>>>> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct
>>>> e1000_hw *hw, bool force)
>>>>              ew32(H2ME, mac_reg);
>>>>          }
>>>>
>>>> -        /* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
>>>> +        /* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
>>>>          while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
>>>> -            if (i++ == 30) {
>>>> +            if (i++ == 250) {
>>>>                  ret_val = -E1000_ERR_PHY;
>>>>                  goto out;
>>>>              }
>>>
>>> The return value was not caught by the caller, so the error ends up
>>> unnoticed.
>>> Maybe let the caller check the return value of
>>> e1000_disable_ulp_lpt_lp()?
>>>
>>> Kai-Heng
>> Hello Kai-Heng and Aaron,
>> I a bit confused. In our previous conversation you told ME not running.
>> let me shimming in. Increasing delay won't be solve the problem and just
>> mask it. We need to understand why ME take too much time. What is
>> problem with this specific system?
>> So, basically no ME system should works for you.
> 
> Some laptops ME work that's why only reproduce issue on some laptops.
> In this issue i219 is controlled by ME.
> 
Who can explain - why ME required too much time on this system?
Probably need work with ME/BIOS vendor and understand it.
Delay will just mask the real problem - we need to find root cause.
> Quirk is only for 1 model type. But issue is reproduced by more models.
> So it won't work.
> 
> Regard,
> Aaron
> 
>>
>> Meanwhile I prefer keep DMI quirk.
>> Thanks,
>> Sasha
>>>
>>>> -- 
>>>> 2.17.1
>>>>
>>>
>>

