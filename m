Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E08C4E6B63
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356848AbiCYAEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 20:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357170AbiCYADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 20:03:32 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BDFBB925
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648166519; x=1679702519;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=ktVK5Htz52j6HRtZgSHIYhD6bKZA/XuyDcXCgV6YkPY=;
  b=K4nzNYlPWPeyTOeza3PxCExT0+svOo9csI+uK6pTxHJtRyQ4U2f7hXgK
   o3QgzBy24yjmrfSHtborvmROcB6X8gt+hlSD6JK8iLtExL81lh4wTu3DE
   3f6LuEsHKlcAQH0PnIuVvEN2o3BsBI0kJ2cJcLr4VymG3Grz+GmRKOwPi
   mQxN/z4R5Bzdhu1Q/MI64zEurQKzlLG5GkeGAzea1iT6gXYIlaPeKA4Mr
   SChrbyGbHxrqtGrg6gp0HyK+JnjSLQtp/fe/4ONQ6lmflUyc7jwy993Xc
   JbpOHBxNPIU4yT213akvnavhu9yb+V9h0iMM8+TuIbg3gd6jgOsZ7kNek
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10296"; a="257344517"
X-IronPort-AV: E=Sophos;i="5.90,208,1643702400"; 
   d="scan'208";a="257344517"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 17:01:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,208,1643702400"; 
   d="scan'208";a="544866062"
Received: from lmmcwade-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.121.212])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2022 17:01:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: Re: [PATCH net-next v1 0/6] ptp: Support hardware clocks with
 additional free running time
In-Reply-To: <20220322210722.6405-1-gerhard@engleder-embedded.com>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
Date:   Thu, 24 Mar 2022 17:01:58 -0700
Message-ID: <87tubm5289.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Gerhard Engleder <gerhard@engleder-embedded.com> writes:

> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with TAPRIO hardware support
> is not possible anymore.
>
> If hardware would support a free running time additionally to the
> physical clock, then the physical clock does not need to be forced to
> free running. Thus, the physical clocks can still be synchronized while
> vclocks are in use.
>
> The physical clock could be used to synchronize the time domain of the
> TSN network and trigger TAPRIO. In parallel vclocks can be used to
> synchronize other time domains.
>
> One year ago I thought for two time domains within a TSN network also
> two physical clocks are required. This would lead to new kernel
> interfaces for asking for the second clock, ... . But actually for a
> time triggered system like TSN there can be only one time domain that
> controls the system itself. All other time domains belong to other
> layers, but not to the time triggered system itself. So other time
> domains can be based on a free running counter if similar mechanisms
> like 2 step synchroisation are used.

I tried to look at this series from the point of view of the Intel i225
NIC and its 4 sets of timer registers, and thinking how adding support
for the "extra" 4 timers would fit with this proposal.

From what I could gather, the idea that would make more sense would be
exposing the other(s?) i225 timers as vclocks. That sounds neat to me,
i.e. the extra timer registers are indeed other "views" to the same
clock (the name "virtual" makes sense).

When retrieving the timestamps from packets (we can timestamp each
packet with two timers), the driver knows what timestamp (and what to do
with it) the user is interested in.

Is this what you (and others) had in mind?

If so, API-wise this series looks good to me. I will take a closer look
at the code tomorrow.

>
> Synchronisation was tested with two time domains between two directly
> connected hosts. Each host run two ptp4l instances, the first used the
> physical clock and the second used the virtual clock. I used my FPGA
> based network controller as network device. ptp4l was used in
> combination with the virtual clock support patches from Miroslav
> Lichvar.
>
> v1:
> - comlete rework based on feedback to RFC (Richard Cochran)
>
> Gerhard Engleder (6):
>   ptp: Add cycles support for virtual clocks
>   ptp: Request cycles for TX timestamp
>   ptp: Pass hwtstamp to ptp_convert_timestamp()
>   ethtool: Add kernel API for PHC index
>   ptp: Support late timestamp determination
>   tsnep: Add physical clock cycles support
>
>  drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++-
>  drivers/net/ethernet/engleder/tsnep_main.c | 27 ++++++---
>  drivers/net/ethernet/engleder/tsnep_ptp.c  | 44 ++++++++++++++
>  drivers/ptp/ptp_clock.c                    | 58 +++++++++++++++++--
>  drivers/ptp/ptp_private.h                  | 10 ++++
>  drivers/ptp/ptp_sysfs.c                    | 10 ++--
>  drivers/ptp/ptp_vclock.c                   | 18 +++---
>  include/linux/ethtool.h                    |  8 +++
>  include/linux/ptp_clock_kernel.h           | 67 ++++++++++++++++++++--
>  include/linux/skbuff.h                     | 11 +++-
>  net/core/skbuff.c                          |  2 +
>  net/ethtool/common.c                       | 13 +++++
>  net/socket.c                               | 45 +++++++++++----
>  13 files changed, 275 insertions(+), 47 deletions(-)
>
> -- 
> 2.20.1
>

-- 
Vinicius
