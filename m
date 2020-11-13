Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1E2B28C9
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKMWvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:51:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:53012 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKMWvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 17:51:44 -0500
IronPort-SDR: zdS1TODkx+tfj6hln57C6a53HwzWK7xJWinIhRSB29pliq9vu5gBuyq5KGjGTdXZ1T9nuS+Xc7
 05mz5SPg+rLg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="149812365"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="149812365"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 14:51:39 -0800
IronPort-SDR: lgN8aD/zTu5Rs9QJ+u5Q/O+btJF/3BkToPJucgmwuhp7/s/plMZ1m4OGtyDBVOeJ4s+VUJsmaE
 cPHbpH2+WIcA==
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="361488876"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.182]) ([10.212.32.182])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 14:51:39 -0800
Subject: Re: devlink userspace process appears stuck (was: Re: [net-next]
 devlink: move request_firmware out of driver)
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
References: <20201113000142.3563690-1-jacob.e.keller@intel.com>
 <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <01c79a25-3826-d0f3-8ea3-aa31e338dabe@intel.com>
 <6352e9d3-02af-721e-3a54-ef99a666be29@intel.com>
Organization: Intel Corporation
Message-ID: <baf44b88-156f-7b34-5e8d-9fe3bc2e2c40@intel.com>
Date:   Fri, 13 Nov 2020 14:51:36 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <6352e9d3-02af-721e-3a54-ef99a666be29@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/2020 2:32 PM, Jacob Keller wrote:
> 
> 
> On 11/13/2020 1:34 PM, Jacob Keller wrote:
>> Well, at least with ice, the experience is pretty bad. I tried out with
>> a garbage file name on one of my test systems. This was on a slightly
>> older kernel without this patch applied, and the device had a pending
>> update that had not yet been finalized with a reset:
>>
>> $ devlink dev flash pci/0000:af:00.0 file garbage_file_does_not_exist
>> Canceling previous pending update
>>
>>
>> The update looks like it got stuck, but actually it failed. Somehow the
>> extack error over the socket didn't get handled by the application very
>> well. Something buggy in the forked process probably.
>>
>> I do get this in the dmesg though:
>>
>> Nov 13 13:12:57 jekeller-stp-glorfindel kernel: ice 0000:af:00.0: Direct
>> firmware load for garbage_file_does_not_exist failed with error -2
>>
> 
> I think I figured out what is going on here, but I'm not sure what the
> best solution is.
> 
> in userspace devlink.c:3410, the condition for exiting the while loop
> that monitors the flash update process is:
> 
> (!ctx.flash_done || (ctx.not_first && !ctx.received_end))
> 

FWIW changing this to

(!ctx.flash_done && !ctx.received_end)

works for this problem, but I suspect that the original condition
intended to try and catch the case where flash update has exited but we
haven't yet processed all of the status messages?

I mean in some sense we could just wait for !ctx.flash_done only. Then
we'd always loop until the initial request exits.

There's a slight issue with the netlink extack message not being
displayed on its own line, but I think that just needs us to add a
pr_out("\n") somewhere to fix it.


> This condition means keep looping until flash is done *OR* we've
> received a message but have not yet received the end.
> 
> In the ice driver implementation, we perform a check for a pending flash
> update first, which could trigger a cancellation that causes us to send
> back a "cancelling previous pending flash update" status message, which
> was sent *before* the devlink_flash_update_begin_notify(). Then, after
> this we request the firmware object, which fails, and results in an
> error code being reported back..
> 
> However, we will never send either the begin or end notification at this
> point. Thus, the devlink userspace application will never quit, and
> won't display the extack message.
> 
> This occurs because we sent a status notify message before we actually
> sent a "begin notify". I think the ordering was done because of trying
> to avoid having a complicated cleanup logic.
> 
> In some sense, this is a bug in the ice driver.. but in another sense
> this is the devlink application being too strict about the requirements
> on ordering of these messages..
> 
> I guess one method if we really want to remain strict is moving the
> "begin" and "end" notifications outside of the driver into core so that
> it always sends a begin before calling the .flash_update handler, and
> always sends an end before exiting.
> 
> I guess we could simply relax the restriction on "not first" so that
> we'll always exit in the case where the forked process has quit on us,
> even if we haven't received a proper flash end notification...
> 
> Thoughts?
> 
