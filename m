Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5092EF750
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbhAHS1M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 13:27:12 -0500
Received: from mga12.intel.com ([192.55.52.136]:27396 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbhAHS1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 13:27:11 -0500
IronPort-SDR: Gk1gLUY6DHU3A9p4JX+K2BvvVJHkEHveGnx3IsyXMQqOk3ihDY/Cd4B9MaghXHaWAFUTE6XiQ6
 Q/oWcahLo66A==
X-IronPort-AV: E=McAfee;i="6000,8403,9858"; a="156823468"
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="156823468"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:26:30 -0800
IronPort-SDR: bnp1s7+11gFdcXaxj5lq/veRhfyI2zhVB/lG3e0cFQ6vBSp+IeCPDPc1Ga51Tz0hIxs/um/GVW
 eJyJMyei0+RQ==
X-IronPort-AV: E=Sophos;i="5.79,332,1602572400"; 
   d="scan'208";a="399061275"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.68.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2021 10:26:30 -0800
Date:   Fri, 8 Jan 2021 10:26:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next v1 1/2] net: core: count drops from GRO
Message-ID: <20210108102630.00004202@intel.com>
In-Reply-To: <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
References: <20210106215539.2103688-1-jesse.brandeburg@intel.com>
        <20210106215539.2103688-2-jesse.brandeburg@intel.com>
        <1e4ee1cf-c2b7-8ba3-7cb1-5c5cb3ff1e84@pensando.io>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shannon Nelson wrote:

> On 1/6/21 1:55 PM, Jesse Brandeburg wrote:
> > When drivers call the various receive upcalls to receive an skb
> > to the stack, sometimes that stack can drop the packet. The good
> > news is that the return code is given to all the drivers of
> > NET_RX_DROP or GRO_DROP. The bad news is that no drivers except
> > the one "ice" driver that I changed, check the stat and increment
> 
> If the stack is dropping the packet, isn't it up to the stack to track 
> that, perhaps with something that shows up in netstat -s?  We don't 
> really want to make the driver responsible for any drops that happen 
> above its head, do we?

I totally agree!

In patch 2/2 I revert the driver-specific changes I had made in an
earlier patch, and this patch *was* my effort to make the stack show the
drops.

Maybe I wasn't clear. I'm seeing packets disappear during TCP
workloads, and this GRO_DROP code was the source of the drops (I see it
returning infrequently but regularly)

The driver processes the packet but the stack never sees it, and there
were no drop counters anywhere tracking it.

