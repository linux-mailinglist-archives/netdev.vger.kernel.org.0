Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053583E0187
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhHDM7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:59:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:49902 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236777AbhHDM7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 08:59:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="212050996"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="212050996"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 05:59:25 -0700
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="511901828"
Received: from dfuxbrum-mobl.ger.corp.intel.com (HELO [10.251.175.67]) ([10.251.175.67])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 05:59:22 -0700
Subject: Re: [Intel-wired-lan] [PATCH next-queue v6 4/4] igc: Add support for
 PTP getcrosststamp()
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     pmenzel@molgen.mpg.de, linux-pci@vger.kernel.org,
        richardcochran@gmail.com, hch@infradead.org,
        netdev@vger.kernel.org, bhelgaas@google.com, helgaas@kernel.org
References: <20210727033657.39885-1-vinicius.gomes@intel.com>
 <20210727033657.39885-5-vinicius.gomes@intel.com>
From:   "Fuxbrumer, Dvora" <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <fab9d5fd-d2ea-1e31-3b6f-d26d26244bd7@linux.intel.com>
Date:   Wed, 4 Aug 2021 15:59:21 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727033657.39885-5-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/2021 06:36, Vinicius Costa Gomes wrote:
> i225 supports PCIe Precision Time Measurement (PTM), allowing us to
> support the PTP_SYS_OFFSET_PRECISE ioctl() in the driver via the
> getcrosststamp() function.
> 
> The easiest way to expose the PTM registers would be to configure the PTM
> dialogs to run periodically, but the PTP_SYS_OFFSET_PRECISE ioctl()
> semantics are more aligned to using a kind of "one-shot" way of retrieving
> the PTM timestamps. But this causes a bit more code to be written: the
> trigger registers for the PTM dialogs are not cleared automatically.
> 
> i225 can be configured to send "fake" packets with the PTM
> information, adding support for handling these types of packets is
> left for the future.
> 
> PTM improves the accuracy of time synchronization, for example, using
> phc2sys, while a simple application is sending packets as fast as
> possible. First, without .getcrosststamp():
> 
> phc2sys[191.382]: enp4s0 sys offset      -959 s2 freq    -454 delay   4492
> phc2sys[191.482]: enp4s0 sys offset       798 s2 freq   +1015 delay   4069
> phc2sys[191.583]: enp4s0 sys offset       962 s2 freq   +1418 delay   3849
> phc2sys[191.683]: enp4s0 sys offset       924 s2 freq   +1669 delay   3753
> phc2sys[191.783]: enp4s0 sys offset       664 s2 freq   +1686 delay   3349
> phc2sys[191.883]: enp4s0 sys offset       218 s2 freq   +1439 delay   2585
> phc2sys[191.983]: enp4s0 sys offset       761 s2 freq   +2048 delay   3750
> phc2sys[192.083]: enp4s0 sys offset       756 s2 freq   +2271 delay   4061
> phc2sys[192.183]: enp4s0 sys offset       809 s2 freq   +2551 delay   4384
> phc2sys[192.283]: enp4s0 sys offset      -108 s2 freq   +1877 delay   2480
> phc2sys[192.383]: enp4s0 sys offset     -1145 s2 freq    +807 delay   4438
> phc2sys[192.484]: enp4s0 sys offset       571 s2 freq   +2180 delay   3849
> phc2sys[192.584]: enp4s0 sys offset       241 s2 freq   +2021 delay   3389
> phc2sys[192.684]: enp4s0 sys offset       405 s2 freq   +2257 delay   3829
> phc2sys[192.784]: enp4s0 sys offset        17 s2 freq   +1991 delay   3273
> phc2sys[192.884]: enp4s0 sys offset       152 s2 freq   +2131 delay   3948
> phc2sys[192.984]: enp4s0 sys offset      -187 s2 freq   +1837 delay   3162
> phc2sys[193.084]: enp4s0 sys offset     -1595 s2 freq    +373 delay   4557
> phc2sys[193.184]: enp4s0 sys offset       107 s2 freq   +1597 delay   3740
> phc2sys[193.284]: enp4s0 sys offset       199 s2 freq   +1721 delay   4010
> phc2sys[193.385]: enp4s0 sys offset      -169 s2 freq   +1413 delay   3701
> phc2sys[193.485]: enp4s0 sys offset       -47 s2 freq   +1484 delay   3581
> phc2sys[193.585]: enp4s0 sys offset       -65 s2 freq   +1452 delay   3778
> phc2sys[193.685]: enp4s0 sys offset        95 s2 freq   +1592 delay   3888
> phc2sys[193.785]: enp4s0 sys offset       206 s2 freq   +1732 delay   4445
> phc2sys[193.885]: enp4s0 sys offset      -652 s2 freq    +936 delay   2521
> phc2sys[193.985]: enp4s0 sys offset      -203 s2 freq   +1189 delay   3391
> phc2sys[194.085]: enp4s0 sys offset      -376 s2 freq    +955 delay   2951
> phc2sys[194.185]: enp4s0 sys offset      -134 s2 freq   +1084 delay   3330
> phc2sys[194.285]: enp4s0 sys offset       -22 s2 freq   +1156 delay   3479
> phc2sys[194.386]: enp4s0 sys offset        32 s2 freq   +1204 delay   3602
> phc2sys[194.486]: enp4s0 sys offset       122 s2 freq   +1303 delay   3731
> 
> Statistics for this run (total of 2179 lines), in nanoseconds:
>    average: -1.12
>    stdev: 634.80
>    max: 1551
>    min: -2215
> 
> With .getcrosststamp() via PCIe PTM:
> 
> phc2sys[367.859]: enp4s0 sys offset         6 s2 freq   +1727 delay      0
> phc2sys[367.959]: enp4s0 sys offset        -2 s2 freq   +1721 delay      0
> phc2sys[368.059]: enp4s0 sys offset         5 s2 freq   +1727 delay      0
> phc2sys[368.160]: enp4s0 sys offset        -1 s2 freq   +1723 delay      0
> phc2sys[368.260]: enp4s0 sys offset        -4 s2 freq   +1719 delay      0
> phc2sys[368.360]: enp4s0 sys offset        -5 s2 freq   +1717 delay      0
> phc2sys[368.460]: enp4s0 sys offset         1 s2 freq   +1722 delay      0
> phc2sys[368.560]: enp4s0 sys offset        -3 s2 freq   +1718 delay      0
> phc2sys[368.660]: enp4s0 sys offset         5 s2 freq   +1725 delay      0
> phc2sys[368.760]: enp4s0 sys offset        -1 s2 freq   +1721 delay      0
> phc2sys[368.860]: enp4s0 sys offset         0 s2 freq   +1721 delay      0
> phc2sys[368.960]: enp4s0 sys offset         0 s2 freq   +1721 delay      0
> phc2sys[369.061]: enp4s0 sys offset         4 s2 freq   +1725 delay      0
> phc2sys[369.161]: enp4s0 sys offset         1 s2 freq   +1724 delay      0
> phc2sys[369.261]: enp4s0 sys offset         4 s2 freq   +1727 delay      0
> phc2sys[369.361]: enp4s0 sys offset         8 s2 freq   +1732 delay      0
> phc2sys[369.461]: enp4s0 sys offset         7 s2 freq   +1733 delay      0
> phc2sys[369.561]: enp4s0 sys offset         4 s2 freq   +1733 delay      0
> phc2sys[369.661]: enp4s0 sys offset         1 s2 freq   +1731 delay      0
> phc2sys[369.761]: enp4s0 sys offset         1 s2 freq   +1731 delay      0
> phc2sys[369.861]: enp4s0 sys offset        -5 s2 freq   +1725 delay      0
> phc2sys[369.961]: enp4s0 sys offset        -4 s2 freq   +1725 delay      0
> phc2sys[370.062]: enp4s0 sys offset         2 s2 freq   +1730 delay      0
> phc2sys[370.162]: enp4s0 sys offset        -7 s2 freq   +1721 delay      0
> phc2sys[370.262]: enp4s0 sys offset        -3 s2 freq   +1723 delay      0
> phc2sys[370.362]: enp4s0 sys offset         1 s2 freq   +1726 delay      0
> phc2sys[370.462]: enp4s0 sys offset        -3 s2 freq   +1723 delay      0
> phc2sys[370.562]: enp4s0 sys offset        -1 s2 freq   +1724 delay      0
> phc2sys[370.662]: enp4s0 sys offset        -4 s2 freq   +1720 delay      0
> phc2sys[370.762]: enp4s0 sys offset        -7 s2 freq   +1716 delay      0
> phc2sys[370.862]: enp4s0 sys offset        -2 s2 freq   +1719 delay      0
> 
> Statistics for this run (total of 2179 lines), in nanoseconds:
>    average: 0.14
>    stdev: 5.03
>    max: 48
>    min: -27
> 
> For reference, the statistics for runs without PCIe congestion show
> that the improvements from enabling PTM are less dramatic. For two
> runs of 16466 entries:
>    without PTM: avg -0.04 stdev 10.57 max 39 min -42
>    with PTM: avg 0.01 stdev 4.20 max 19 min -16
> 
> One possible explanation is that when PTM is not enabled, and there's a lot
> of traffic in the PCIe fabric, some register reads will take more time
> than the others because of congestion on the PCIe fabric.
> 
> When PTM is enabled, even if the PTM dialogs take more time to
> complete under heavy traffic, the time measurements do not depend on
> the time to read the registers.
> 
> This was implemented following the i225 EAS version 0.993.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h         |   1 +
>   drivers/net/ethernet/intel/igc/igc_defines.h |  31 ++++
>   drivers/net/ethernet/intel/igc/igc_ptp.c     | 179 +++++++++++++++++++
>   drivers/net/ethernet/intel/igc/igc_regs.h    |  23 +++
>   4 files changed, 234 insertions(+)
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
