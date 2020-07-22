Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10113229F24
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgGVSVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:21:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:43021 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgGVSVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 14:21:23 -0400
IronPort-SDR: TTdx/jJpNyJl00LZpCwy06wOF8C2oxKQ01P8m3FYKFdlZ4Y1dlBSyOiYzrLE15WjXdr/eT0b32
 Jcg2RHItN0Cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="148347220"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="148347220"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 11:21:22 -0700
IronPort-SDR: 59Mgu9f2BpEGeeCTbgmYr2plDdL4S31mf6T5/Wf7r5pX9z2cqBjqESDlg+5nsmHPrjeRH3AdP+
 nCi4ef6FVyCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="326773987"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.20.201]) ([10.254.20.201])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jul 2020 11:21:22 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
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
 <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7d3a4dfb-ca4d-039a-9fad-2dcb5dbd9600@intel.com>
Date:   Wed, 22 Jul 2020 11:21:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200722095228.2f2c61b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2020 9:52 AM, Jakub Kicinski wrote:
> On Wed, 22 Jul 2020 15:30:05 +0000 Keller, Jacob E wrote:
>>> So perhaps we can introduce something like "component mask", which would
>>> allow to flash only part of the component. That is basically what Jacob
>>> has, I would just like to have it well defined.
>>
>> So, we could make this selection a series of masked bits instead of a
>> single enumeration value.
> 
> I'd still argue that components (as defined in devlink info) and config
> are pretty orthogonal. In my experience config is stored in its own
> section of the flash, and some of the knobs are in no obvious way
> associated with components (used by components).
> 
> That said, if we rename the "component mask" to "update mask" that's
> fine with me.
> 
> Then we'd have
> 
> bit 0 - don't overwrite config
> bit 1 - don't overwrite identifiers
> 
> ? 
> 
> Let's define a bit for "don't update program" when we actually need it.
> 


Ok. And this can be later extended with additional bits with new
meanings should the need arise.

Additionally, drivers can ensure that the valid combination of bits is
set. the drivers can reject requests for combinations that they do not
support.

I can make that change.

My preference is that "0" for a bit means do not overwrite while "1"
means overwrite. This way, if/when additional bits are added, drivers
won't need to be updated to reject such requests. If we make "1" the "do
not overwrite" then we'd have a case where drivers must update to ensure
they reject requests which don't set the bit.

Thanks,
Jake
