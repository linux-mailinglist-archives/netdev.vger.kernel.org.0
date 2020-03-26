Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF64A194ABF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgCZViR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:38:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:34323 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCZViR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:38:17 -0400
IronPort-SDR: P1w6pfYYarAaklk/BTS6JWimhpr9TBCDS4Ek8RA1lMpK8LkKrGp5inCmcOirVdWi3W5l9Qt6UB
 fuAVPZ2P5PSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 14:38:16 -0700
IronPort-SDR: mjwoKS1WtwGGJcbw/AgihDXw80X+i+uT2chDKdC6jrOxKW+PgHneSnYB2k+hQsPtBMBVgkBygf
 GJj+tA5LoZJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358288912"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 14:38:16 -0700
Subject: Re: [PATCH net-next v3 11/11] ice: add a devlink region for dumping
 NVM contents
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
 <20200326183718.2384349-12-jacob.e.keller@intel.com>
 <20200326211908.GG11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <deb40048-bd2a-efcb-d381-29eb4a880707@intel.com>
Date:   Thu, 26 Mar 2020 14:38:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326211908.GG11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 2:19 PM, Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 07:37:18PM CET, jacob.e.keller@intel.com wrote:
>> Add a devlink region for exposing the device's Non Volatime Memory flash
>> contents.
>>
>> Support the recently added .snapshot operation, enabling userspace to
>> request a snapshot of the NVM contents via DEVLINK_CMD_REGION_NEW.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> Changes since RFC:
>> * Capture the entire NVM instead of just Shadow RAM
>> * Use vmalloc instead of kmalloc, since the memory does not need to be
>>  physically contiguous.
>> * Remove the direct reading function, as this will be sent in a separate
>>  series
>>
>> Changes since v1:
>> * use dev_err instead of dev_warn when a region fails to be created
>>
>> Changes since v2:
>> * Removed redundant "out of memory" extack message
>> * Fixed up function declaration alignment to avoid checkpatch.pl warnings
>>
>> Documentation/networking/devlink/ice.rst     | 26 ++++++
>> drivers/net/ethernet/intel/ice/ice.h         |  2 +
>> drivers/net/ethernet/intel/ice/ice_devlink.c | 96 ++++++++++++++++++++
>> drivers/net/ethernet/intel/ice/ice_devlink.h |  3 +
>> drivers/net/ethernet/intel/ice/ice_main.c    |  4 +
>> 5 files changed, 131 insertions(+)
>>
>> diff --git a/Documentation/networking/devlink/ice.rst b/Documentation/networking/devlink/ice.rst
>> index 37fbbd40a5e5..f3d6a3b50342 100644
>> --- a/Documentation/networking/devlink/ice.rst
>> +++ b/Documentation/networking/devlink/ice.rst
>> @@ -69,3 +69,29 @@ The ``ice`` driver reports the following versions
>>       - The version of the DDP package that is active in the device. Note
>>         that both the name (as reported by ``fw.app.name``) and version are
>>         required to uniquely identify the package.
>> +
>> +Regions
>> +=======
>> +
>> +The ``ice`` driver enables access to the contents of the Non Volatile Memory
>> +flash chip via the ``nvm-flash`` region.
>> +
>> +Users can request an immediate capture of a snapshot via the
>> +``DEVLINK_CMD_REGION_NEW``
>> +
>> +.. code:: shell
>> +
>> +    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>> +
>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>> +    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>> +    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>> +    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
>> +    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
>> +
>> +    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
>> +        length 16
> 
> I still think this should be one line. Anyway,
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> 

Ugh, I knew I was forgetting something.
