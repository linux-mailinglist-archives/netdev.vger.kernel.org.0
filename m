Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E3122FC39
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgG0Wcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:32:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:52713 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0Wcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:32:36 -0400
IronPort-SDR: bdswQU7p8hCiqLaYoYc0cCM67aJzLIHlRbtCSv/goeax5dmoHhiZF8OLGX0GEZicoP3yTLNCpR
 2urfEwtoCWeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="139156456"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="139156456"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:32:35 -0700
IronPort-SDR: rwrKdlyepANzKW2RZsh4jMHSixrEdFmkbPTISJ22xLtfr+IhzWpeCeGrhVLngRzvc/6TjegHXS
 +6Ond9tIL6Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="303623507"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 15:32:35 -0700
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727222158.bg52mg2mfsta2f37@lion.mk-sys.cz>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <10bd731c-8286-f62e-19d4-9ee567910392@intel.com>
Date:   Mon, 27 Jul 2020 15:32:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727222158.bg52mg2mfsta2f37@lion.mk-sys.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 3:21 PM, Michal Kubecek wrote:
> On Mon, Jul 27, 2020 at 02:47:00PM -0700, Jacob Keller wrote:
>> The ethtool netlink API can send bitsets without an associated bitmask.
>> These do not get displayed properly, because the dump_link_modes, and
>> bitset_get_bit to not check whether the provided bitset is a NOMASK
>> bitset. This results in the inability to display peer advertised link
>> modes.
>>
>> The dump_link_modes and bitset_get_bit functions are designed so they
>> can print either the values or the mask. For a nomask bitmap, this
>> doesn't make sense. There is no mask.
>>
>> Modify dump_link_modes to check ETHTOOL_A_BITSET_NOMASK. For compact
>> bitmaps, always check and print the ETHTOOL_A_BITSET_VALUE bits,
>> regardless of the request to display the mask or the value. For full
>> size bitmaps, the set of provided bits indicates the valid values,
>> without using ETHTOOL_A_BITSET_VALUE fields. Thus, do not skip printing
>> bits without this attribute if nomask is set. This essentially means
>> that dump_link_modes will treat a NOMASK bitset as having a mask
>> equivalent to all of its set bits.
>>
>> For bitset_get_bit, also check for ETHTOOL_A_BITSET_NOMASK. For compact
>> bitmaps, always use ETHTOOL_A_BITSET_BIT_VALUE as in dump_link_modes.
>> For full bitmaps, if nomask is set, then always return true of the bit
>> is in the set, rather than only if it provides an
>> ETHTOOL_A_BITSET_BIT_VALUE. This will then correctly report the set
>> bits.
>>
>> This fixes display of link partner advertised fields when using the
>> netlink API.
>>
>> Reported-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  netlink/bitset.c   | 9 ++++++---
>>  netlink/settings.c | 8 +++++---
>>  2 files changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/netlink/bitset.c b/netlink/bitset.c
>> index 130bcdb5b52c..ba5d3ea77ff7 100644
>> --- a/netlink/bitset.c
>> +++ b/netlink/bitset.c
>> @@ -50,6 +50,7 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>>  	DECLARE_ATTR_TB_INFO(bitset_tb);
>>  	const struct nlattr *bits;
>>  	const struct nlattr *bit;
>> +	bool nomask;
>>  	int ret;
>>  
>>  	*retptr = 0;
>> @@ -57,8 +58,10 @@ bool bitset_get_bit(const struct nlattr *bitset, bool mask, unsigned int idx,
>>  	if (ret < 0)
>>  		goto err;
>>  
>> -	bits = mask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
>> -		      bitset_tb[ETHTOOL_A_BITSET_VALUE];
>> +	nomask = bitset_tb[ETHTOOL_A_BITSET_NOMASK];
>> +
>> +	bits = mask && !nomask ? bitset_tb[ETHTOOL_A_BITSET_MASK] :
>> +		                 bitset_tb[ETHTOOL_A_BITSET_VALUE];
>>  	if (bits) {
>>  		const uint32_t *bitmap =
>>  			(const uint32_t *)mnl_attr_get_payload(bits);
> 
> I don't like this part: (mask && nomask) is a situation which should
> never happen as it would mean we are trying to get mask value from
> a bitmap which does not any. In other words, if we ever see such
> combination, it is a result of a bug either on ethtool side or on kernel
> side.
> 
> Rather than silently returning something else than asked, we should
> IMHO report an error. Which is easy in dump_link_modes() but it would
> require rewriting bitset_get_bit().
> 
> Michal

The "mask" boolean is an indication that you want to print the mask for
a bitmap, rather than its value. I think treating a bitmap without a
predefined mask to have its mask be equivalent to its values is
reasonable. However, I could see the argument for not wanting this since
it is effectively a bug somewhere.

For dump_link_modes, it is trivial. If nomask is set, and mask is
requested, bail out of the function. It looks like we can also report an
error for the bitset_get_bit too. I'll take a look closer.

Thanks,
Jake
