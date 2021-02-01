Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B4A30B237
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBAVlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:41:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:50421 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhBAVlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:41:11 -0500
IronPort-SDR: 5a5/VOEsjs4bFcXZ7ASbMNDKwoaN5O4I1Vkcbu6RT2K1kmB+Ruz8pLbodRlW7YMvFgUY0h/HLv
 hSpup3+SP7ag==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="265589042"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="265589042"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:40:30 -0800
IronPort-SDR: 5PwmU5+u65UknpqFhyNRMJdUHiHWwOn5zmVNz7LetRYDtRqy/XjGFrybM7509KGCb/8xPtFA2+
 3hDTvhRX5aNQ==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="412917486"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.75.41]) ([10.212.75.41])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 13:40:30 -0800
Subject: Re: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
To:     Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
 <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <977ae41c-c547-bc44-9857-24c88c228412@intel.com>
Date:   Mon, 1 Feb 2021 13:40:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/29/2021 10:37 PM, Jakub Kicinski wrote:
> On Thu, 28 Jan 2021 16:43:27 -0800 Tony Nguyen wrote:
>> When reporting the versions via devlink info, first read the device
>> capabilities. If there is a pending flash update, use this new function
>> to extract the inactive flash versions. Add the stored fields to the
>> flash version map structure so that they will be displayed when
>> available.
> 
> Why only report them when there is an update pending?
> 
> The expectation was that you'd always report what you can and user 
> can tell the update is pending by comparing the fields.
> 

If there is no pending update, what is the expected behavior? We report
the currently active image version as both stored and running?

In our case, the device has 2 copies of each of the 3 modules: NVM,
Netlist, and UNDI/OptionROM.

For each module, the device has a bit that indicates whether it will
boot from the first or second bank of the image. When we update,
whichever bank is not active is erased, and then populated with the new
image contents. The bit indicating which bank to load is flipped. Once
the device is rebooted (EMP reset), then the new bank is loaded, and the
firmware performs some onetime initialization.

So for us, in theory we have up to 2 versions within the device for each
bank: the version in the currently active bank, and a version in the
inactive bank. In the inactive case, it may or may not be valid
depending on if that banks contents were ever a valid image. On a fresh
card, this might be empty or filled with garbage.

Presumably we do not want to report that we have "stored" a version
which is not going to be activated next time that we boot?

The documentation indicated that stored should be the version which
*will* be activated.

If I just blindly always reported what was inactive, then the following
scenarios exist:

# Brand new card:

running:
  fw.bundle_id: Version
stored
  fw.bundle_id: <zero or garbage>

# Do an update:

running:
  fw.bundle_id: Version
stored
  fw.bundle_id: NewVersion

# reset/reboot

running:
  fw.bundle_id: NewVersion
stored:
  fw.bundle_id: Version


I could get behind that if we do not have a pending update we report the
stored value as the same as the running value (i.e. from the active
bank), where as if we have a pending update that will be triggered we
would report the inactive bank. I didn't see the value in that before
because it seemed like "if you don't have a pending update, you don't
have a stored value, so just report the active version in the running
category")

It's also plausibly useful to report the stored but not pending value in
some cases, but I really don't want to report zeros or garbage data on
accident. This would almost certainly lead to confusing support
conversations.
