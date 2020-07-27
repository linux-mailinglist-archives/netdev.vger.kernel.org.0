Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6564022FC0E
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgG0WW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:22:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:61145 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0WW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 18:22:28 -0400
IronPort-SDR: G/80DANNCeiZtpT2kaE8Pr3kTipIXgWOuuLROlSdx62OhXT7ThW9LfSCGswjRtTovQwu99b/Da
 aEq/F1eJ9Hag==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="151104710"
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="151104710"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 15:22:27 -0700
IronPort-SDR: t3Wf0H1GTkqCrIClzO099hu83Fzg5a4747BJyfbeKjjzuRQiZzigzJPHPBabHXGU/3Y9fPTPof
 fEBGCwcx+zWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,404,1589266800"; 
   d="scan'208";a="303621069"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.56.18]) ([10.212.56.18])
  by orsmga002.jf.intel.com with ESMTP; 27 Jul 2020 15:22:27 -0700
Subject: Re: [ethtool] ethtool: fix netlink bitmasks when sent as NOMASK
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Jamie Gloudon <jamie.gloudon@gmx.fr>
References: <20200727214700.5915-1-jacob.e.keller@intel.com>
 <20200727221104.GD1705504@lunn.ch>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <fb270523-f4b0-a824-7c98-e69e255061d6@intel.com>
Date:   Mon, 27 Jul 2020 15:22:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200727221104.GD1705504@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2020 3:11 PM, Andrew Lunn wrote:
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
> 
> Hi Jacob
> 
> This is close
> 
> Netlink
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
> 	                                     100baseT/Half 100baseT/Full
> 	                                     1000baseT/Full
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: No
> 
> IOCTL
> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full 
> 	                                     100baseT/Half 100baseT/Full 
> 	                                     1000baseT/Full 
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: Yes
> 	Link partner advertised FEC modes: Not reported
> 
> So just the FEC modes differ.
> 
> However, i don't think this was part of the original issue, so:
> 
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> 
> It would be nice to get the FEC modes fixed.
> 
>     Andrew
> 

Yea, it looks like FEC modes is because FEC actually send a "None" flag,
as opposed to using an empty set as "none". I can follow-up this fix
with a change I think will resolve this as well.

Thanks,
Jake
