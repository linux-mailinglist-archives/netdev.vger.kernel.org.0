Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FB3192139
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 07:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgCYGgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 02:36:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:47292 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCYGgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 02:36:42 -0400
IronPort-SDR: pxhg9WRJMgcsIu/oQcAFkmOaf/HP8qFaq/sjenQka4WnGzDLeoVJXccsJq0LG1y0xMxbHCLyRL
 /y+rRR1TrnUA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 23:36:41 -0700
IronPort-SDR: 3Td4nQqzHu1XAMtC2noNIdMXCZj4aCwq/T1T4z21ZSQoVVZPPaCeM7Dx+0o7jbNSRY25BfdeB7
 +tehq/JEvJTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="270704738"
Received: from sneftin-mobl1.ger.corp.intel.com (HELO [10.214.212.82]) ([10.214.212.82])
  by fmsmga004.fm.intel.com with ESMTP; 24 Mar 2020 23:36:38 -0700
Subject: Re: [PATCH] e1000e: bump up timeout to wait when ME un-configure ULP
 mode
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Aaron Ma <aaron.ma@canonical.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>, rex.tsai@intel.com
References: <20200323191639.48826-1-aaron.ma@canonical.com>
 <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <2c765c59-556e-266b-4d0d-a4602db94476@intel.com>
Date:   Wed, 25 Mar 2020 08:36:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <EC4F7F0B-90F8-4325-B170-84C65D8BBBB8@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/2020 06:17, Kai-Heng Feng wrote:
> Hi Aaron,
> 
>> On Mar 24, 2020, at 03:16, Aaron Ma <aaron.ma@canonical.com> wrote:
>>
>> ME takes 2+ seconds to un-configure ULP mode done after resume
>> from s2idle on some ThinkPad laptops.
>> Without enough wait, reset and re-init will fail with error.
> 
> Thanks, this patch solves the issue. We can drop the DMI quirk in favor of this patch.
> 
>>
>> Fixes: f15bb6dde738cc8fa0 ("e1000e: Add support for S0ix")
>> BugLink: https://bugs.launchpad.net/bugs/1865570
>> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
>> ---
>> drivers/net/ethernet/intel/e1000e/ich8lan.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> index b4135c50e905..147b15a2f8b3 100644
>> --- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> +++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
>> @@ -1240,9 +1240,9 @@ static s32 e1000_disable_ulp_lpt_lp(struct e1000_hw *hw, bool force)
>> 			ew32(H2ME, mac_reg);
>> 		}
>>
>> -		/* Poll up to 300msec for ME to clear ULP_CFG_DONE. */
>> +		/* Poll up to 2.5sec for ME to clear ULP_CFG_DONE. */
>> 		while (er32(FWSM) & E1000_FWSM_ULP_CFG_DONE) {
>> -			if (i++ == 30) {
>> +			if (i++ == 250) {
>> 				ret_val = -E1000_ERR_PHY;
>> 				goto out;
>> 			}
> 
> The return value was not caught by the caller, so the error ends up unnoticed.
> Maybe let the caller check the return value of e1000_disable_ulp_lpt_lp()?
> 
> Kai-Heng
Hello Kai-Heng and Aaron,
I a bit confused. In our previous conversation you told ME not running. 
let me shimming in. Increasing delay won't be solve the problem and just 
mask it. We need to understand why ME take too much time. What is 
problem with this specific system?
So, basically no ME system should works for you.

Meanwhile I prefer keep DMI quirk.
Thanks,
Sasha
> 
>> -- 
>> 2.17.1
>>
> 

