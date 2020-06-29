Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E249E20DA88
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbgF2T6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:58:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:4583 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731831AbgF2T6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:58:00 -0400
IronPort-SDR: jdaL4X3H6ayj4YPxBPJhNvvYueXdPlepPt5ov4whdBJQisQn93k6oxNXgsgP4uZryUXc9nBNdy
 BZjmCxUNQBJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="146049469"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="146049469"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 12:57:59 -0700
IronPort-SDR: Isw7lqr5zUf76ZtLl+jg9OWoaRngqL7x1PsdxLeDA8CeA8Pw57/bqNEtShR3jeKpXmk7UEpkmI
 UH4WeOutFmfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="277183338"
Received: from otc-nc-03.jf.intel.com (HELO otc-nc-03) ([10.54.39.25])
  by orsmga003.jf.intel.com with ESMTP; 29 Jun 2020 12:57:59 -0700
Date:   Mon, 29 Jun 2020 12:57:59 -0700
From:   "Raj, Ashok" <ashok.raj@intel.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Aya Levin <ayal@mellanox.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>, linux-pci@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        Casey Leedom <leedom@chelsio.com>,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200629195759.GA255688@otc-nc-03>
References: <ca121a18-8c11-5830-9840-51f353c3ddd2@mellanox.com>
 <20200629193316.GA3283437@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629193316.GA3283437@bjorn-Precision-5520>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn


On Mon, Jun 29, 2020 at 02:33:16PM -0500, Bjorn Helgaas wrote:
> [+cc Ashok, Ding, Casey]
> 
> On Mon, Jun 29, 2020 at 12:32:44PM +0300, Aya Levin wrote:
> > I wanted to turn on RO on the ETH driver based on
> > pcie_relaxed_ordering_enabled().
> > From my experiments I see that pcie_relaxed_ordering_enabled() return true
> > on Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. This CPU is from Haswell
> > series which is known to have bug in RO implementation. In this case, I
> > expected pcie_relaxed_ordering_enabled() to return false, shouldn't it?
> 
> Is there an erratum for this?  How do we know this device has a bug
> in relaxed ordering?

https://software.intel.com/content/www/us/en/develop/download/intel-64-and-ia-32-architectures-optimization-reference-manual.html

For some reason they weren't documented in the errata, but under
Optimization manual :-)

Table 3-7. Intel Processor CPU RP Device IDs for Processors Optimizing PCIe
Performance
Processor CPU RP Device IDs
Intel Xeon processors based on Broadwell microarchitecture 6F01H-6F0EH
Intel Xeon processors based on Haswell microarchitecture 2F01H-2F0EH

These are the two that were listed in the manual. drivers/pci/quirks.c also
has an eloborate list of root ports where relaxed_ordering is disabled. Did
you check if its not already covered here?

Send lspci if its not already covered by this table.


> 
> > In addition, we are worried about future bugs in new CPUs which may result
> > in performance degradation while using RO, as long as the function
> > pcie_relaxed_ordering_enabled() will return true for these CPUs. 
> 
> I'm worried about this too.  I do not want to add a Device ID to the
> quirk_relaxedordering_disable() list for every new Intel CPU.  That's
> a huge hassle and creates a real problem for old kernels running on
> those new CPUs, because things might work "most of the time" but not
> always.

I'll check when this is fixed, i was told newer ones should work properly.
But I'll confirm.


