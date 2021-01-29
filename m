Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1965308F7C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhA2VdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:33:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:64108 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhA2VdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:33:02 -0500
IronPort-SDR: xe5eSyOcO7v1C1kzDroqTNneuc3OXhHTd23tslfwMcuIGWl/R4C6VlNBLnfKlsAwTt08Vo57kt
 YeXxx5M6iB0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9879"; a="168151655"
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="168151655"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:32:21 -0800
IronPort-SDR: jVfXkcxe27HLln4zumNdmyg0ZFIVD13R2LFVxOk2lPc9Fy0zdm/vwe7kP+p3M1fgBzW56CLUMM
 Sb23n5hKwttQ==
X-IronPort-AV: E=Sophos;i="5.79,386,1602572400"; 
   d="scan'208";a="475537120"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.127.25]) ([10.212.127.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2021 13:32:21 -0800
Subject: Re: [PATCH net-next 02/15] ice: cache NVM module bank information
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        sassmann@redhat.com, Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-3-anthony.l.nguyen@intel.com>
 <CAF=yD-LVEWjcezKidh-JUcuON-L8GWvs34EeMNRrQK1tn0YD8w@mail.gmail.com>
 <CAF=yD-JEFCz9OK2mgC7Xpka+HxnyQyKLx-REKwmoK6fjcntmRQ@mail.gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0ce0a270-7985-2d59-59dc-a4d7f8c9b04e@intel.com>
Date:   Fri, 29 Jan 2021 13:32:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-JEFCz9OK2mgC7Xpka+HxnyQyKLx-REKwmoK6fjcntmRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2021 1:04 PM, Willem de Bruijn wrote:
> On Fri, Jan 29, 2021 at 4:01 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>>
>> On Thu, Jan 28, 2021 at 7:46 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>>>
>>> From: Jacob Keller <jacob.e.keller@intel.com>
>>>
>>> The ice flash contains two copies of each of the NVM, Option ROM, and
>>> Netlist modules. Each bank has a pointer word and a size word. In order
>>> to correctly read from the active flash bank, the driver must calculate
>>> the offset manually.
>>>
>>> During NVM initialization, read the Shadow RAM control word and
>>> determine which bank is active for each NVM module. Additionally, cache
>>> the size and pointer values for use in calculating the correct offset.
>>>
>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>> Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>> ---
>>>  drivers/net/ethernet/intel/ice/ice_nvm.c  | 151 ++++++++++++++++++++++
>>>  drivers/net/ethernet/intel/ice/ice_type.h |  37 ++++++
>>>  2 files changed, 188 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
>>> index b0f0b4fc266b..308344045397 100644
>>> --- a/drivers/net/ethernet/intel/ice/ice_nvm.c
>>> +++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
>>> @@ -603,6 +603,151 @@ static enum ice_status ice_discover_flash_size(struct ice_hw *hw)
>>>         return status;
>>>  }
>>>
>>> +/**
>>> + * ice_read_sr_pointer - Read the value of a Shadow RAM pointer word
>>> + * @hw: pointer to the HW structure
>>> + * @offset: the word offset of the Shadow RAM word to read
>>> + * @pointer: pointer value read from Shadow RAM
>>> + *
>>> + * Read the given Shadow RAM word, and convert it to a pointer value specified
>>> + * in bytes. This function assumes the specified offset is a valid pointer
>>> + * word.
>>> + *
>>> + * Each pointer word specifies whether it is stored in word size or 4KB
>>> + * sector size by using the highest bit. The reported pointer value will be in
>>> + * bytes, intended for flat NVM reads.
>>> + */
>>> +static enum ice_status
>>> +ice_read_sr_pointer(struct ice_hw *hw, u16 offset, u32 *pointer)
>>> +{
>>> +       enum ice_status status;
>>> +       u16 value;
>>> +
>>> +       status = ice_read_sr_word(hw, offset, &value);
>>> +       if (status)
>>> +               return status;
>>> +
>>> +       /* Determine if the pointer is in 4KB or word units */
>>> +       if (value & ICE_SR_NVM_PTR_4KB_UNITS)
>>> +               *pointer = (value & ~ICE_SR_NVM_PTR_4KB_UNITS) * 4 * 1024;
>>> +       else
>>> +               *pointer = value * 2;
>>
>> Should this be << 2, for 4B words?
> 
> Never mind, sorry. I gather from patch 3 that wordsize is 16b.
> 


Ah, yes that could have been explained a bit better. In this context, a
word is indeed 2 bytes.

Perhaps we could have used "<< 1" and "<< 12" or similar instead of the
multiplication, but I felt this was a bit more clear.

Thanks,
Jake
