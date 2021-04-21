Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241D8366682
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237449AbhDUHyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 03:54:44 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:60823 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234659AbhDUHyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 03:54:43 -0400
Received: from [192.168.0.3] (ip5f5ae88d.dynamic.kabel-deutschland.de [95.90.232.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7B9B620647B7A;
        Wed, 21 Apr 2021 09:54:07 +0200 (CEST)
Subject: Re: [Intel-wired-lan] [PATCH V2 net] ice: Re-organizes reqstd/avail
 {R, T}XQ check/code for efficiency+readability
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     linuxarm@openeuler.org, netdev@vger.kernel.org,
        linuxarm@huawei.com, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210413224446.16612-1-salil.mehta@huawei.com>
 <7974e665-73bd-401c-f023-9da568e1dffc@molgen.mpg.de>
 <418702bdb5244eb4811a2a1a536c55c0@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <9335975a-ef19-863c-005a-d460eac83e03@molgen.mpg.de>
Date:   Wed, 21 Apr 2021 09:54:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <418702bdb5244eb4811a2a1a536c55c0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC: Remove Jeff, as email is rejected]

Dear Salil,


Am 21.04.21 um 09:41 schrieb Salil Mehta:
>> From: Paul Menzel [mailto:pmenzel@molgen.mpg.de]
>> Sent: Wednesday, April 21, 2021 6:36 AM

[…]

>> In the git commit message summary, could you please use imperative mood [1]?
> 
> No issues. There is always a scope of improvement.
> 
>>> Re-organize reqstd/avail {R, T}XQ check/code for efficiency+readability
>>
>> It’s a bit long though. Maybe:
>>
>> Avoid unnecessary assignment with user specified {R,T}XQs
> 
> Umm..above conveys the wrong meaning as this is not what patch is doing.
> 
> If you see the code, in the presence of the user specified {R,T}XQs it
> avoids fetching available {R,T}XQ count.
> 
> What about below?
> 
> "Avoid unnecessary avail_{r,t}xq assignments if user has specified Qs"

Sounds good, still a little long. Maybe:

> Avoid unnecessary avail_{r,t}xq assignments with user specified Qs

>> Am 14.04.21 um 00:44 schrieb Salil Mehta:
>>> If user has explicitly requested the number of {R,T}XQs, then it is
>>> unnecessary to get the count of already available {R,T}XQs from the
>>> PF avail_{r,t}xqs bitmap. This value will get overridden by user specified
>>> value in any case.
>>>
>>> This patch does minor re-organization of the code for improving the flow
>>> and readabiltiy. This scope of improvement was found during the review of
>>
>> readabil*it*y
> 
> Thanks. Missed that earlier. My shaky fingers :(
> 
>>> the ICE driver code.
>>>
>>> FYI, I could not test this change due to unavailability of the hardware.
>>> It would be helpful if somebody can test this patch and provide Tested-by
>>> Tag. Many thanks!
>>
>> This should go outside the commit message (below the --- for example).
> 
> Agreed.
> 
>>> Fixes: 87324e747fde ("ice: Implement ethtool ops for channels")
>>
>> Did you check the behavior before is actually a bug? Or is it just for
>> the detection heuristic for commits to be applied to the stable series?
> 
> Right, later was the idea.
>   
>>> Cc: intel-wired-lan@lists.osuosl.org
>>> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
>>> --
>>> Change V1->V2
>>>    (*) Fixed the comments from Anthony Nguyen(Intel)
>>>        Link: https://lkml.org/lkml/2021/4/12/1997
>>> ---
>>>    drivers/net/ethernet/intel/ice/ice_lib.c | 14 ++++++++------
>>>    1 file changed, 8 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
>>> index d13c7fc8fb0a..d77133d6baa7 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_lib.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
>>> @@ -161,12 +161,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
>>>
>>>    	switch (vsi->type) {
>>>    	case ICE_VSI_PF:
>>> -		vsi->alloc_txq = min3(pf->num_lan_msix,
>>> -				      ice_get_avail_txq_count(pf),
>>> -				      (u16)num_online_cpus());
>>>    		if (vsi->req_txq) {
>>>    			vsi->alloc_txq = vsi->req_txq;
>>>    			vsi->num_txq = vsi->req_txq;
>>> +		} else {
>>> +			vsi->alloc_txq = min3(pf->num_lan_msix,
>>> +					      ice_get_avail_txq_count(pf),
>>> +					      (u16)num_online_cpus());
>>>    		}
>>
>> I am curious, did you check the compiler actually creates different
>> code, or did it notice the inefficiency by itself and optimized it already?
> 
> I have not looked into that detail but irrespective of what compiler generates
> I would like to keep the code in a shape which is more efficient and more readable.
> 
> I do understand in certain cases we have to do tradeoff between efficiency
> and readability but I do not see that here.

I agree, as *efficiency* is mentioned several times, I assume it was 
tested. Thank you for the clarification.

>>>    		pf->num_lan_tx = vsi->alloc_txq;
>>> @@ -175,12 +176,13 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
>>>    		if (!test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
>>>    			vsi->alloc_rxq = 1;
>>>    		} else {
>>> -			vsi->alloc_rxq = min3(pf->num_lan_msix,
>>> -					      ice_get_avail_rxq_count(pf),
>>> -					      (u16)num_online_cpus());
>>>    			if (vsi->req_rxq) {
>>>    				vsi->alloc_rxq = vsi->req_rxq;
>>>    				vsi->num_rxq = vsi->req_rxq;
>>> +			} else {
>>> +				vsi->alloc_rxq = min3(pf->num_lan_msix,
>>> +						      ice_get_avail_rxq_count(pf),
>>> +						      (u16)num_online_cpus());
>>>    			}
>>>    		}
>>>


Kind regards,

Paul
