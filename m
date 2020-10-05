Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B705C28434A
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 02:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgJFAWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 20:22:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:52450 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbgJFAWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 20:22:21 -0400
IronPort-SDR: rxyEtF/3xzvdTJyy3Ogh5+rwm6f4lmk9DQD5MdikkSCvfuAxNnks1N74SzduGZktCn4Sn94s2m
 DIG8mtDNucIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="161661798"
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="161661798"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP; 05 Oct 2020 17:22:19 -0700
IronPort-SDR: lF/hjPdCIR6cwUIFN5AQ4dlbmt+q+8kIjzjLWyrVpQl4aGGRV64/Hwiinos+KyxIWcN/P1A3NN
 h5WqMSL/dUAQ==
X-IronPort-AV: E=Sophos;i="5.77,341,1596524400"; 
   d="scan'208";a="327158462"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 14:52:53 -0700
Subject: Re: [PATCH net-next 1/6] ethtool: wire up get policies to ops
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        jiri@resnulli.us, andrew@lunn.ch, mkubecek@suse.cz
References: <20201005155753.2333882-1-kuba@kernel.org>
 <20201005155753.2333882-2-kuba@kernel.org>
 <631a2328a95d0dd06d901cdb411c3eb06f90bda7.camel@sipsolutions.net>
 <20201005121622.55607210@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <de5a03325d397fe559ce6c6182dfedc0cdad2c3b.camel@sipsolutions.net>
 <20201005123120.7e8caa84@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5c91beb0-8b25-0d2f-87b3-3ada27e51e73@intel.com>
Date:   Mon, 5 Oct 2020 14:52:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <3e793f3b5c99bb4a5584d621b1dd5b30e62d81f2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/5/2020 12:33 PM, Johannes Berg wrote:
> On Mon, 2020-10-05 at 12:31 -0700, Jakub Kicinski wrote:
> 
>> Yea, I think we're both confused. Agreed with the above.
>>
>> Are you suggesting:
>>
>> const struct nla_policy policy[/* no size */] = {
>> 	[HEADER]	= NLA_POLICY(...)
>> 	[OTHER_ATTR]	= NLA_POLICY(...)
>> };
>>
>> extern const struct nla_policy policy[/* no size */];
>>
>> op = {
>> 	.policy = policy,
>> 	.max_attr = OTHER_ATTR,
>> }
> 
> No, that'd be awkward, for the reason you stated below.
> 
>> What I'm saying is that my preference would be:
>>
>> const struct nla_policy policy[OTHER_ATTR + 1] = {
>> 	[HEADER]	= NLA_POLICY(...)
>> 	[OTHER_ATTR]	= NLA_POLICY(...)
>> };
>>
>> extern const struct nla_policy policy[OTHER_ATTR + 1];
>>
>> op = {
>> 	.policy = policy,
>> 	.max_attr = ARRAY_SIZE(policy) - 1,
>> }
>>
>> Since it's harder to forget to update the op (you don't have to update
>> op, and compiler will complain about the extern out of sync).
> 
> Yeah.
> 
> I was thinking the third way ;-)
> 
> const struct nla_policy policy[] = {
> 	[HEADER]	= NLA_POLICY(...)
> 	[OTHER_ATTR]	= NLA_POLICY(...)
> };
> 
> op = {
> 	.policy = policy,
> 	.maxattr = ARRAY_SIZE(policy) - 1,
> };
> 
> 
> Now you can freely add any attributes, and, due to strict validation,
> anything not specified in the policy will be rejected, whether by being
> out of range (> maxattr) or not specified (NLA_UNSPEC).
> 
> johannes
> 

This is what I was thinking of as well.
