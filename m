Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4782B2708
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgKMVfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:35:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:47385 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgKMVeu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:50 -0500
IronPort-SDR: Bhxqu7+vDudh7DOaVQFVl/mhUM43Inj8/2xPS5pTnj7KgaAWGaPugVQQkXRHhaoPGTyK8thota
 LttndCj5AmyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="149805739"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="149805739"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:49 -0800
IronPort-SDR: /6MyKBVUJ0aVAYt5/g0AOf8tXdJnh+dzD4fyuModnNDpGYp4+UtLVBHvNrU6QIlq/TbyImtm9E
 IozYWLKvRq1Q==
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="361475540"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.32.182]) ([10.212.32.182])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:34:49 -0800
Subject: Re: [net-next] devlink: move request_firmware out of driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
References: <20201113000142.3563690-1-jacob.e.keller@intel.com>
 <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <01c79a25-3826-d0f3-8ea3-aa31e338dabe@intel.com>
Date:   Fri, 13 Nov 2020 13:34:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/13/2020 1:12 PM, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 16:01:42 -0800 Jacob Keller wrote:
>> All drivers which implement the devlink flash update support, with the
>> exception of netdevsim, use either request_firmware or
>> request_firmware_direct to locate the firmware file. Rather than having
>> each driver do this separately as part of its .flash_update
>> implementation, perform the request_firmware within net/core/devlink.c
>>
>> Replace the file_name paramter in the struct devlink_flash_update_params
>> with a pointer to the fw object.
>>
>> Use request_firmware rather than request_firmware_direct. Although most
>> Linux distributions today do not have the fallback mechanism
>> implemented, only about half the drivers used the _direct request, as
>> compared to the generic request_firmware. In the event that
>> a distribution does support the fallback mechanism, the devlink flash
>> update ought to be able to use it to provide the firmware contents. For
>> distributions which do not support the fallback userspace mechanism,
>> there should be essentially no difference between request_firmware and
>> request_firmware_direct.
> 
> Thanks for working on this!
> 
>> This is a follow to the discussion that took place at [1]. After reading
>> through the docs for request_firmware vs request_firmware_direct, I believe
>> that the net/core/devlink.c should be using request_firmware. While it is
>> true that no distribution supports this today, it seems like we shouldn't
>> rule it out entirely here. I'm willing to change this if we think it's not
>> worth bothering to support it.
>>
>> Note that I have only compile-tested the drivers other than ice, as I do not
>> have hw for them. The only tricky transformation was in the bnxt driver
>> which shares code with the ethtool implementation. The rest were pretty
>> straight forward transformations.
>>
>> One other thing came to my attention while working on this and while
>> discussing the ice devlink support with colleagues: the userspace devlink
>> program doesn't really indicate that the flash file must be located in the
>> firmware search path (usually /lib/firmware/*).
> 
> It's in the man page, same as ethool.

Yea.

> 
>> It is probably worth some effort to make the userspace tool error out
>> more clearly when the file can't be found.
> 
> Can do, although the path is configurable AFAIR through some kconfig,
> and an extack from the kernel would probably be as informative?
> 

Well, at least with ice, the experience is pretty bad. I tried out with
a garbage file name on one of my test systems. This was on a slightly
older kernel without this patch applied, and the device had a pending
update that had not yet been finalized with a reset:

$ devlink dev flash pci/0000:af:00.0 file garbage_file_does_not_exist
Canceling previous pending update


The update looks like it got stuck, but actually it failed. Somehow the
extack error over the socket didn't get handled by the application very
well. Something buggy in the forked process probably.

I do get this in the dmesg though:

Nov 13 13:12:57 jekeller-stp-glorfindel kernel: ice 0000:af:00.0: Direct
firmware load for garbage_file_does_not_exist failed with error -2



This happens because the way the ice driver structured the checks we
handle cancelling a previous update before checking if we can get the
firmware object. In the new patch that goes away since we get the fw
object pretty early on.

I tried again after applying this patch to that system:

$ devlink dev flash pci/0000:af:00.0 file garbage_file_does_not_exist
Error: failed to locate the requested firmware file.
devlink answers: No such file or directory

So at least it is improved. But if "garbage_file_does_not_exist" happens
to be a file relative to the CWD, then it is very confusing to users who
may not fully understand the request_firmware interface..

What I'd have liked to see is something where the userspace tool
complains more loudly in the case where the file exists relative to CWD
and says something like "firmware files must be located in the firmware
search path".

I think we probably should also root cause and fix the bug I found above
where the program doesn't properly quit.

> Or are you thinking of doing something like copying/linking the file to
> /lib/firmware automatically if user provides path relative to CWD?
> 

I thought about copying to /lib/firmware, but I think that is
problematic. What if the file is quite large? Presumably we want to use
a temporary file, which now means we need to manage that file and ensure
we don't choose a name that collides with anything else, and that we
properly clean up that file all the time on exit...

That seems overly complicated. Mostly I think just offering a warning
like "we couldn't find your file in the search path, but it was relative
to the CWD.. you probably forgot to move the file into /lib/firmware".

> 
> ../drivers/net/ethernet/intel/ice/ice_devlink.c:250:17: warning: unused variable ‘dev’ [-Wunused-variable]
>   250 |  struct device *dev = &pf->pdev->dev;
>       |                 ^~~
> ../drivers/net/ethernet/qlogic/qed/qed_mcp.c:510:9: warning: context imbalance in '_qed_mcp_cmd_and_union' - unexpected unlock
> ../drivers/net/ethernet/mellanox/mlx5/core/devlink.c: In function ‘mlx5_devlink_flash_update’:
> ../drivers/net/ethernet/mellanox/mlx5/core/devlink.c:16:25: warning: unused variable ‘fw’ [-Wunused-variable]
>    16 |  const struct firmware *fw;
>       |                         ^~
> 

Heh. I knew I forgot something! Will fix.

Thanks,
Jake
