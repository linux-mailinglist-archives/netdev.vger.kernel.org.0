Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4460926E3BC
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgIQSdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:33:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:27797 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726325AbgIQScs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:32:48 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 14:32:42 EDT
IronPort-SDR: 7ew2Hb6n78lGQ3CqvJOe1JiPoVu193dtxB2v2OaHWgVNILDosVxvnq8P6UlKCEM2TqmkQaagiP
 nwN1OtBqaffQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="157152788"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="157152788"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:24:00 -0700
IronPort-SDR: yYtdAPkiDQ4SILsHO3HluWV0SOgMmQfmPW+5nbU66OIMIbrUlVibSnpBqoEUSwT69RNxgFV7pi
 IBD6K8SdIkxw==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483851908"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.251.16.238])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 11:24:00 -0700
Date:   Thu, 17 Sep 2020 11:23:59 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <frederic@kernel.org>,
        <mtosatti@redhat.com>, <sassmann@redhat.com>,
        <jeffrey.t.kirsher@intel.com>, <jacob.e.keller@intel.com>,
        <jlelli@redhat.com>, <hch@infradead.org>, <bhelgaas@google.com>,
        <mike.marciniszyn@intel.com>, <dennis.dalessandro@intel.com>,
        <thomas.lendacky@amd.com>, <jerinj@marvell.com>,
        <mathias.nyman@intel.com>, <jiri@nvidia.com>
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
Message-ID: <20200917112359.00006e10@intel.com>
In-Reply-To: <20200909150818.313699-3-nitesh@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
        <20200909150818.313699-3-nitesh@redhat.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nitesh Narayan Lal wrote:

> In a realtime environment, it is essential to isolate unwanted IRQs from
> isolated CPUs to prevent latency overheads. Creating MSIX vectors only
> based on the online CPUs could lead to a potential issue on an RT setup
> that has several isolated CPUs but a very few housekeeping CPUs. This is
> because in these kinds of setups an attempt to move the IRQs to the
> limited housekeeping CPUs from isolated CPUs might fail due to the per
> CPU vector limit. This could eventually result in latency spikes because
> of the IRQ threads that we fail to move from isolated CPUs.
> 
> This patch prevents i40e to add vectors only based on available
> housekeeping CPUs by using num_housekeeping_cpus().
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

The driver changes are straightforward, but this isn't the only driver
with this issue, right?  I'm sure ixgbe and ice both have this problem
too, you should fix them as well, at a minimum, and probably other
vendors drivers:

$ rg -c --stats num_online_cpus drivers/net/ethernet
...
50 files contained matches

for this patch i40e
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
