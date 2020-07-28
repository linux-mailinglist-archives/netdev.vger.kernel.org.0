Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A5F231110
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbgG1RnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:43:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:4616 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732035AbgG1RnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 13:43:09 -0400
IronPort-SDR: sRO4lEVEmTUWwnvummb5WesEHVDPGeuF2iB1p6liJsbYBM4rbNed3jV3um0kc37XiojttWhMBH
 70g5KGjGtZEQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="130840501"
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="130840501"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 10:43:09 -0700
IronPort-SDR: 2qECmcS056jM0kPzHihJDND4hI00z1RUWNpy6T1X3zxUqrToHf7VrVKiB7NM/nflZpyifX0MF+
 vmolltTq84Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,406,1589266800"; 
   d="scan'208";a="434400931"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by orsmga004.jf.intel.com with ESMTP; 28 Jul 2020 10:43:07 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200722105139.GA3154@nanopsycho>
 <02874ECE860811409154E81DA85FBB58C8AF3382@fmsmsx101.amr.corp.intel.com>
 <20200726071606.GB2216@nanopsycho>
 <cfbed715-8b01-2f56-bc58-81c7be86b1c3@intel.com>
 <20200728111950.GB2207@nanopsycho>
 <a41db4d7-e3f3-ecbb-0876-4ccb7da0339f@intel.com>
 <20200728100939.108f33f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <3af3e45e-1e77-ebc7-bf5e-656f6017193e@intel.com>
Date:   Tue, 28 Jul 2020 10:43:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200728100939.108f33f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2020 10:09 AM, Jakub Kicinski wrote:
> On Tue, 28 Jul 2020 09:58:44 -0700 Jacob Keller wrote:
>> On 7/28/2020 4:19 AM, Jiri Pirko wrote:
>>> Yes. Documentation is very easy to ignore unfortunatelly. The driver
>>> developer has to be tight up by the core code and api, I believe.
>>
>> So I'm not sure what the best proposal here is. We do have a list of
>> generic components, but given that each piece of HW has different
>> elements, it's not always feasible to have fully generic names. Some of
>> the names are driver specific.
>>
>> I guess we could use some system where components are "registered" when
>> loading the devlink, so that they can be verified by the stack when used
>> as a parameter for flash update? Perhaps take something like the
>> table-driven approach used for infos and extend that into devlink core
>> so that drivers basically register a table of the components which
>> includes both a function callback that gets the version string as well
>> as an indication of whether that component can be updated via flash_update?
>>
>> I know it would also be useful for ice to have a sort of "pre-info"
>> callback that generates a context structure that is passed to each of
>> the info callbacks. (that way a single up-front step could be to lookup
>> the relevant information, and this is then forwarded to each of the
>> formatter functions for each component).
>>
>> Am I on the right track here or just over-engineering?
> 
> I don't understand why we're having this conversation.
> 
> No driver right now uses the component name.
> 
> AFAIU we agreed not to use the component name for config vs code.
> 
> So you may as well remove the component name from the devlink op and
> add a todo there saying "when adding component back, make sure it's
> tightly coupled to info".
> 

Fair enough yea.
