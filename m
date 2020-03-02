Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0B55176803
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgCBXVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:21:07 -0500
Received: from mga06.intel.com ([134.134.136.31]:37890 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbgCBXVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 18:21:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:21:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="258141781"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 15:21:06 -0800
Subject: Re: ip link vf info truncating with many VFs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>
References: <16b289f6-b025-5dd3-443d-92d4c167e79c@intel.com>
 <20200302151704.56fe3dd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <ff51329f-9f01-53c7-8214-96542321400f@intel.com>
Date:   Mon, 2 Mar 2020 15:21:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302151704.56fe3dd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/2020 3:17 PM, Jakub Kicinski wrote:
> On Fri, 28 Feb 2020 16:33:40 -0800 Jacob Keller wrote:
>> Hi,
>>
>> I recently noticed an issue in the rtnetlink API for obtaining VF
>> information.
>>
>> If a device creates 222 or more VF devices, the rtnl_fill_vf function
>> will incorrectly label the size of the IFLA_VFINFO_LIST attribute. This
>> occurs because rtnl_fill_vfinfo will have added more than 65k (maximum
>> size of a single attribute since nla_len is a __u16).
>>
>> This causes the calculation in nla_nest_end to overflow and report a
>> significantly shorter length value. Worse case, with 222 VFs, the "ip
>> link show <device>" reports no VF info at all.
>>
>> For some reason, the nla_put calls do not trigger an EMSGSIZE error,
>> because the skb itself is capable of holding the data.
>>
>> I think the right thing is probably to do some sort of
>> overflow-protected calculation and print a warning... or find a way to
>> fix nla_put to error with -EMSGSIZE if we would exceed the nested
>> attribute size limit... I am not sure how to do that at a glance.
> 
> Making nla_nest_end() return an error on overflow seems like 
> the most reasonable way forward to me, FWIW. Simply compare
> the result to U16_MAX, I don't think anything more clever is
> needed.
> 

Sure, I alto think that's the right approach to fix this.

As long we calculate the value using something larger than a u16 first,
that should work.

> Some of the callers actually already check for errors of
> nla_nest_end() (qdiscs' dump methods use the result which 
> is later checked for less that zero).

I'll take a look at the qdisc code.

> 
> Then rtnetlink code should be made aware that nla_nest_end() 
> may fail.
> 

Right.

> (When you post it's probably a good idea to widen the CC list 
> to Johannes Berg, Pablo, DaveA, Jiri..)
> 

Yep. I wasn't sure who all to add here, so I tried looking at the
MAINTAINERS file.

Thanks,
Jake
