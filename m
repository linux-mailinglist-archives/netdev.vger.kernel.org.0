Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF7722FCD9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgG0XSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:18:40 -0400
Received: from mga07.intel.com ([134.134.136.100]:37735 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0XSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:18:40 -0400
IronPort-SDR: 6Y/b5yryBtSUTQJJMZ6xc9xdof9OO4osaInt8uYDOPpe0nSETJUeXFUAztd7ay7TYvqMVy1FTV
 kFX8OuxrX0hA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="215656919"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="215656919"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 16:18:38 -0700
IronPort-SDR: 63Fga2xdxv+H2rTQ2S4ohjjE0JHQop5j9OZ1mtOMWHY2sJnBuTib28YolpVI3ufjFgNxImG79U
 Dt7uu6FCPxww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="303634319"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 16:18:38 -0700
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727222158.bg52mg2mfsta2f37@lion.mk-sys.cz>
 <10bd731c-8286-f62e-19d4-9ee567910392@intel.com>
 <20200727225359.hsy4bzmmfvrkw23e@lion.mk-sys.cz>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <06f2b84a-c015-a878-6c36-745e32e17e5e@intel.com>
Date:   Mon, 27 Jul 2020 16:18:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727225359.hsy4bzmmfvrkw23e@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 3:53 PM, Michal Kubecek wrote:
> On Mon, Jul 27, 2020 at 03:32:34PM -0700, Jacob Keller wrote:
>> On 7/27/2020 3:21 PM, Michal Kubecek wrote:
>>> On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
>>>> The ethtool netlink API can send bitsets without an associated bitmask.
>>>> These do not get displayed properly, because the dump_link_modes, and
>>>> bitset_get_bit to not check whether the provided bitset is a NOMASK
>>>> bitset. This results in the inability to display peer advertised link
>>>> modes.
>>>>
>>>> The dump_link_modes and bitset_get_bit functions are designed so they
>>>> can print either the values or the mask. For a nomask bitmap, this
>>>> doesn't make sense. There is no mask.
>>>>
>>>> Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
>>>> bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
>>>> regardless of the request to display the mask or the value. For full
>>>> size bitmaps, the set of provided bits indicates the valid values,
>>>> without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
>>>> bits without this attribute if nomask is set. This essentially means
>>>> that dump_link_modes will treat a NOMASK bitset as having a mask
>>>> equivalent to all of its set bits.
>>>>
>>>> For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
>>>> bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
>>>> For full bitmaps, if nomask is set, then always return true of the bit
>>>> is in the set, rather than only if it provides an
>>>> ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
>>>> bits.
>>>>
>>>> This fixes display of link partner advertised fields when using the
>>>> netlink API.
>>>>
>>>> Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
>>>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>>>> ---
>>>>  netlink/bitset.c   | 9 ++++++---
>>>>  netlink/settings.c | 8 +++++---
>>>>  2 files changed, 11 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/netlink/bitset.c b/netlink/bitset.c
>>>> index 130bcdb5b52c..ba5d3ea77ff7 100644
>>>> --- a/netlink/bitset.c
>>>> +++ b/netlink/bitset.c
>>>> @@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>>>>  	DECLARE_ATTR_TB_INFO(bitset_tb);
>>>>  	const struct nlattr *bits;
>>>>  	const struct nlattr *bit;
>>>> +	bool nomask;
>>>>  	int ret;
>>>>  
>>>>  	*retptr = 0;
>>>> @@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>>>>  	if (ret < 0)
>>>>  		goto err;
>>>>  
>>>> -	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
>>>> -		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
>>>> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
>>>> +
>>>> +	bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
>>>> +		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
>>>>  	if (bits) {
>>>>  		const uint32_t *bitmap =
>>>>  			(const uint32_t *)mnl_attr_get_payload(bits);
>>>
>>> I don't like this part: (mask && nomask) is a situation which should
>>> never happen as it would mean we are trying to get mask value from
>>> a bitmap which does not any. In other words, if we ever see such
>>> combination, it is a result of a bug either on ethtool side or on kernel
>>> side.
>>>
>>> Rather than silently returning something else than asked, we should
>>> IMHO report an error. Which is easy in dump_link_modes() but it would
>>> require rewriting bitset_get_bit().
>>>
>>> Michal
>>
>> The "mask" boolean is an indication that you want to print the mask for
>> a bitmap, rather than its value. I think treating a bitmap without a
>> predefined mask to have its mask be equivalent to its values is
>> reasonable.
> 
> It depends on the context. In requests, value=0x1,mask=0x1 means "set
> bit 0 and leave the rest untouched" while nomask bitmap with value=0x1
> would mean "set bit 0 and clear the rest".
> 
> For kernel replies, it should be documented which variant is expected.
> 

Right, I was mostly referring to the reply side of things. I've updated
the patch in v2 to explicitly reject trying to print the mask of a NO
MASK bitset.

Thanks,
Jake
