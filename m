Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DDE284349
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 02:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgJFAUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 20:20:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:37454 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgJFAUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 20:20:21 -0400
IronPort-SDR: GbVy/zscRoDYwbRY199tf8wdm6pdwi78MmlwYYNFAs97C5pyvO/KFimM9zGdcdkWfmIUqImrS4
 wpwLtVDyIsHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="248983793"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="248983793"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP; 05 Oct 2020 17:20:19 -0700
IronPort-SDR: kWu67G0hJ/r3jLZxx7doQFvQ99Cj1S4qtbaTk3K9WOovGfBXhhjiA1x1eACnzUj7wJlCGRwtL6
 uHMlFvl/p6ow==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="327153157"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 14:33:58 -0700
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
References: <20201005155753.2333882-1-kuba@kernel.org>
 <20201005155753.2333882-2-kuba@kernel.org>
 <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
 <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
 <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f5fdf3bf-a30f-50eb-c9d1-7f3776af1391@intel.com>
Date:   Mon, 5 Oct 2020 14:33:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 12:31 PM, Jakub Kicinski wrote:
> On Mon, 05 Oct 2020 21:21:36 +0200 Johannes Berg wrote:
>>>> But with the difference it seems to me that it'd be possible to get this
>>>> mixed up?  
>>>
>>> Right, I prefer not to have the unnecessary NLA_REJECTS, so my thinking
>>> was - use the format I like for the new code, but leave the existing
>>> rejects for a separate series / discussion.
>>>
>>> If we remove the rejects we still need something like
>>>
>>> extern struct nla_policy policy[lastattr + 1];  
>>
>> Not sure I understand? You're using strict validation (I think), so
>> attrs that are out of range will be rejected same as NLA_REJECT (well,
>> with a different message) in __nla_validate_parse():
>>
>>         nla_for_each_attr(nla, head, len, rem) {
>>                 u16 type = nla_type(nla);
>>
>>                 if (type == 0 || type > maxtype) {
>>                         if (validate & NL_VALIDATE_MAXTYPE) {
>>                                 NL_SET_ERR_MSG_ATTR(extack, nla,
>>                                                     "Unknown attribute type");
>>                                 return -EINVAL;
>>                         }
>>
>>
>> In fact, if you're using strict validation even the default
>> (0==NLA_UNSPEC) will be rejected, just like NLA_REJECT.
>>
>>
>> Or am I confused somewhere?
> 
> Yea, I think we're both confused. Agreed with the above.
> 
> Are you suggesting:
> 
> const struct nla_policy policy[/* no size */] = {
> 	[HEADER]	= NLA_POLICY(...)
> 	[OTHER_ATTR]	= NLA_POLICY(...)
> };
> 
> extern const struct nla_policy policy[/* no size */];
> 
> op = {
> 	.policy = policy,
> 	.max_attr = OTHER_ATTR,
> }
> 

Why can't .max_attr here just be derived from ARRAY_SIZE? In this
example, ARRAY_SIZE should return 2, so max_attr would be ARRAY_SIZE - 1.

Well, I guess HEADER/OTHER_ATTR could make this a sparse array... in
which case it might not work?

> ?
> 
> What I'm saying is that my preference would be:
> 
> const struct nla_policy policy[OTHER_ATTR + 1] = {
> 	[HEADER]	= NLA_POLICY(...)
> 	[OTHER_ATTR]	= NLA_POLICY(...)
> };
> 
> extern const struct nla_policy policy[OTHER_ATTR + 1];
> 
> op = {
> 	.policy = policy,
> 	.max_attr = ARRAY_SIZE(policy) - 1,
> }
> 
> Since it's harder to forget to update the op (you don't have to update
> op, and compiler will complain about the extern out of sync).
> 
Ahh.. Ok so I guess what you're doing here is defining the array size as
OTHER_ATTR + 1, so that ARRAY_SIZE() - 1 guarantees to equal
OTHER_ATTR.. so as long as OTHER_ATTR is the largest element in the array...

But wouldn't that be the case in the previous example where array size
is automatically determined... as long as you keep the index ordering in
ascending order, then the size of the array would be 1 larger than the
last element...
