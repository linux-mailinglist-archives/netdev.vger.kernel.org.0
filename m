Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E7224FCF
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 07:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgGSFeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 01:34:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:36650 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgGSFeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Jul 2020 01:34:16 -0400
IronPort-SDR: SKTYMHO07hzyfJ5TiMoBf+t7p7CoRGY/e+fAhxhY6QeRokTQypCGrRhtdByGuQpXN2ZXSexRC7
 HsiJ/xu0cbFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9686"; a="129865719"
X-IronPort-AV: E=Sophos;i="5.75,369,1589266800"; 
   d="scan'208";a="129865719"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2020 22:34:15 -0700
IronPort-SDR: FXW1Ac7iCitpqkwhFvTSn54O81Pc62W1bjCaB9G8zwy97xDiluuZbiRJb2PRtHwllONbbVj6kR
 IbZFJPomRm6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,369,1589266800"; 
   d="scan'208";a="269858023"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.249.88.79]) ([10.249.88.79])
  by fmsmga007.fm.intel.com with ESMTP; 18 Jul 2020 22:34:13 -0700
Subject: Re: [Intel-wired-lan] [PATCH] igc: Do not use link uninitialized in
 igc_check_for_copper_link
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20200716044934.152364-1-natechancellor@gmail.com>
 <cdfec63a-e51f-e1a6-aa60-6ca949338306@intel.com>
 <20200717021235.GA4098394@ubuntu-n2-xlarge-x86>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <96131050-57e4-934a-3d9a-a285f234e633@intel.com>
Date:   Sun, 19 Jul 2020 08:34:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200717021235.GA4098394@ubuntu-n2-xlarge-x86>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/2020 05:12, Nathan Chancellor wrote:
> On Thu, Jul 16, 2020 at 07:29:03PM +0300, Neftin, Sasha wrote:
>> On 7/16/2020 07:49, Nathan Chancellor wrote:
>>> Clang warns:
>>>
>> Hello Nathan,
>> Thanks for tracking our code.Please, look at https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200709073416.14126-1-sasha.neftin@intel.com/
>> - I hope this patch already address this Clang warns - please, let me know.
> 
> I have not explicitly tested it but it seems obvious that it will. Let's
> go with that.
> 
Good Nathan, let's go with my 
https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20200709073416.14126-1-sasha.neftin@intel.com/ 
and let me know if warning still generated.
Thanks,
Sasha
> Cheers,
> Nathan
> 
>>> drivers/net/ethernet/intel/igc/igc_mac.c:374:6: warning: variable 'link'
>>> is used uninitialized whenever 'if' condition is true
>>> [-Wsometimes-uninitialized]
>>>           if (!mac->get_link_status) {
>>>               ^~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/intel/igc/igc_mac.c:424:33: note: uninitialized use
>>> occurs here
>>>           ret_val = igc_set_ltr_i225(hw, link);
>>>                                          ^~~~
>>> drivers/net/ethernet/intel/igc/igc_mac.c:374:2: note: remove the 'if' if
>>> its condition is always false
>>>           if (!mac->get_link_status) {
>>>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/intel/igc/igc_mac.c:367:11: note: initialize the
>>> variable 'link' to silence this warning
>>>           bool link;
>>>                    ^
>>>                     = 0
>>> 1 warning generated.
>>>
>>> It is not wrong, link is only uninitialized after this through
>>> igc_phy_has_link. Presumably, if we skip the majority of this function
>>> when get_link_status is false, we should skip calling igc_set_ltr_i225
>>> as well. Just directly return 0 in this case, rather than bothering with
>>> adding another label or initializing link in the if statement.
>>>
>>> Fixes: 707abf069548 ("igc: Add initial LTR support")
>>> Link: https://github.com/ClangBuiltLinux/linux/issues/1095
>>> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>>> ---
>>>    drivers/net/ethernet/intel/igc/igc_mac.c | 6 ++----
>>>    1 file changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
>>> index b47e7b0a6398..26e3c56a4a8b 100644
>>> --- a/drivers/net/ethernet/intel/igc/igc_mac.c
>>> +++ b/drivers/net/ethernet/intel/igc/igc_mac.c
>>> @@ -371,10 +371,8 @@ s32 igc_check_for_copper_link(struct igc_hw *hw)
>>>    	 * get_link_status flag is set upon receiving a Link Status
>>>    	 * Change or Rx Sequence Error interrupt.
>>>    	 */
>>> -	if (!mac->get_link_status) {
>>> -		ret_val = 0;
>>> -		goto out;
>>> -	}
>>> +	if (!mac->get_link_status)
>>> +		return 0;
>>>    	/* First we want to see if the MII Status Register reports
>>>    	 * link.  If so, then we want to get the current speed/duplex
>>>
>>> base-commit: ca0e494af5edb59002665bf12871e94b4163a257
>>>
>> Thanks,
>> Sasha

