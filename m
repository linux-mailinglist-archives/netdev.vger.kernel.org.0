Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9D3E00D4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237982AbhHDMHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:07:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:49804 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234765AbhHDMHJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 08:07:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="274958502"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="274958502"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 05:06:56 -0700
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="511886792"
Received: from dfuxbrum-mobl.ger.corp.intel.com (HELO [10.251.175.67]) ([10.251.175.67])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 05:06:53 -0700
Subject: Re: [Intel-wired-lan] [PATCH v2] igc: fix page fault when thunderbolt
 is unplugged
To:     Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210713130036.741188-1-aaron.ma@canonical.com>
From:   "Fuxbrumer, Dvora" <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <567b12f8-359a-5268-e020-edcf2dd46937@linux.intel.com>
Date:   Wed, 4 Aug 2021 15:06:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210713130036.741188-1-aaron.ma@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/2021 16:00, Aaron Ma wrote:
> After unplug thunerbolt dock with i225, pciehp interrupt is triggered,
> remove call will read/write mmio address which is already disconnected,
> then cause page fault and make system hang.
> 
> Check PCI state to remove device safely.
> 
> Trace:
> BUG: unable to handle page fault for address: 000000000000b604
> Oops: 0000 [#1] SMP NOPTI
> RIP: 0010:igc_rd32+0x1c/0x90 [igc]
> Call Trace:
> igc_ptp_suspend+0x6c/0xa0 [igc]
> igc_ptp_stop+0x12/0x50 [igc]
> igc_remove+0x7f/0x1c0 [igc]
> pci_device_remove+0x3e/0xb0
> __device_release_driver+0x181/0x240
> 
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 32 ++++++++++++++---------
>   drivers/net/ethernet/intel/igc/igc_ptp.c  |  3 ++-
>   2 files changed, 21 insertions(+), 14 deletions(-)
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
