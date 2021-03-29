Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FC434C22D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhC2DT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 23:19:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:7351 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhC2DTV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 23:19:21 -0400
IronPort-SDR: NLUK0cWTVzWOM7rJYg/DEASXDOZpIh21uEbu+3VfWr0pnb3rkI+fkJTj7daNvql/2KTgI75VtN
 GBzvnhOGU9fQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9937"; a="190931290"
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="190931290"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 20:19:21 -0700
IronPort-SDR: ARP9HMJ6j3HLkrVp+cGiWP6izK7yof5wX5K0LHOiCR7NEU0PCCBuWu+pMar0EDarsu8Qg1Yuk9
 9tTEsQ3oiCZg==
X-IronPort-AV: E=Sophos;i="5.81,285,1610438400"; 
   d="scan'208";a="526786945"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.80.176]) ([10.212.80.176])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2021 20:19:20 -0700
Subject: Re: [PATCH net 1/4] virtchnl: Fix layout of RSS structures
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     anthony.l.nguyen@intel.com,
        Norbert Ciosek <norbertx.ciosek@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
 <20210325223119.3991796-2-anthony.l.nguyen@intel.com>
 <CAMuHMdXo_UOf_QLKSxtgm5ByvSAo_Uy_h2RTpy8B=xqdUGaBNQ@mail.gmail.com>
 <ce03118c-d368-def0-8a1f-8c3a770901d6@intel.com>
 <CAMuHMdW3BSkJXjSL5R4xuYv6Yb765U5zwBCLcsSW+zr_K7898g@mail.gmail.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <a47965c9-c7d6-7349-b717-4eb3bde193c7@intel.com>
Date:   Sun, 28 Mar 2021 20:19:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdW3BSkJXjSL5R4xuYv6Yb765U5zwBCLcsSW+zr_K7898g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/2021 2:53 AM, Geert Uytterhoeven wrote:
> Hi Samudrala,
>
> On Fri, Mar 26, 2021 at 11:45 PM Samudrala, Sridhar
> <sridhar.samudrala@intel.com> wrote:
>> On 3/26/2021 1:06 AM, Geert Uytterhoeven wrote:
>>> On Thu, Mar 25, 2021 at 11:29 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>>> From: Norbert Ciosek <norbertx.ciosek@intel.com>
>>>
>>> Remove padding from RSS structures. Previous layout
>>> could lead to unwanted compiler optimizations
>>> in loops when iterating over key and lut arrays.
>>>
>>>  From an earlier private conversation with Mateusz, I understand the real
>>> explanation is that key[] and lut[] must be at the end of the
>>> structures, because they are used as flexible array members?
>>>
>>> Fixes: 65ece6de0114 ("virtchnl: Add missing explicit padding to structures")
>>> Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
>>> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>
>>> --- a/include/linux/avf/virtchnl.h
>>> +++ b/include/linux/avf/virtchnl.h
>>> @@ -476,7 +476,6 @@ struct virtchnl_rss_key {
>>>          u16 vsi_id;
>>>          u16 key_len;
>>>          u8 key[1];         /* RSS hash key, packed bytes */
>>> -       u8 pad[1];
>>>   };
>>>
>>>   VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
>>> @@ -485,7 +484,6 @@ struct virtchnl_rss_lut {
>>>          u16 vsi_id;
>>>          u16 lut_entries;
>>>          u8 lut[1];        /* RSS lookup table */
>>> -       u8 pad[1];
>>>   };
>>>
>>> If you use a flexible array member, it should be declared without a size,
>>> i.e.
>>>
>>>      u8 key[];
>>>
>>> Everything else is (trying to) fool the compiler, and leading to undefined
>>> behavior, and people (re)adding explicit padding.
>> This header file is shared across other OSes that use C++ that doesn't support
>> flexible arrays. So the structures in this file use an array of size 1 as a last
>> element to enable variable sized arrays.
> I don't think it is accepted practice to have non-Linux-isms in
> include/*linux*/avf/virtchnl.h header files.  Moreover, using a size
> of 1 is counter-intuitive for people used to Linux kernel development,
> and may lead to off-by-one errors in calculation of sizes.
>
> If you insist on ignoring the above, this definitely deserves a
> comment next to the member's declaration.
Sure. We can add a comment indicating that these fields are used 
variable sized arrays.

Thanks
Sridhar
