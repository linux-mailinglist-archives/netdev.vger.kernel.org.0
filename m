Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F23C2315E4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 01:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgG1W75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 18:59:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:38502 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729744AbgG1W75 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 18:59:57 -0400
IronPort-SDR: LPGFYm22Y+1CoxJszDwx30k1w4c42L6A7deqx6tjK66cC6J2HgRCUzOax6PFpHipd6k7ULPcGv
 COVGKUV7L5Wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9696"; a="130887614"
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="130887614"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 15:59:57 -0700
IronPort-SDR: QK9tqkkhyj4ovd8wcJdDdpDYFbArxqgT1ClRdBk3wOWwMHFO1JFZmNnS2o9WvF/xGRXbOE/mw7
 L64B67MQTeeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,408,1589266800"; 
   d="scan'208";a="273704453"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.199]) ([10.212.32.199])
  by fmsmga008.fm.intel.com with ESMTP; 28 Jul 2020 15:59:56 -0700
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
Message-ID: <f7f2693c-13ee-8a60-65e0-05709464b838@intel.com>
Date:   Tue, 28 Jul 2020 15:59:56 -0700
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

Another simpler option would be to just call .info_get and verify that
the requested component appeared in that list. Ofcourse we'd be making
this call every flash_update...
