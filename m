Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F9E39F688
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhFHM2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:28:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:55188 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232530AbhFHM17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 08:27:59 -0400
IronPort-SDR: QDIZoaNZ/FJeDOfiwToxfANS1R9g/sS9dCsps66mJqvXy+a55ZThuzFes5KWcj4GoxOYwvEDfa
 e4tu/yoToGZg==
X-IronPort-AV: E=McAfee;i="6200,9189,10008"; a="201812287"
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="201812287"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 05:26:02 -0700
IronPort-SDR: 1bb5WJ3mCHSSL5VrOzifX8sfMZtnoQj+fFtXefgePoJi8+w1TsW8E0q/h9K/bDl1kSIZgf8e+P
 0GTjLGdSUeOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,258,1616482800"; 
   d="scan'208";a="476586564"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2021 05:26:00 -0700
Date:   Tue, 8 Jun 2021 14:13:40 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH intel-next 2/2] ice: introduce XDP Tx fallback path
Message-ID: <20210608121340.GB1971@ranger.igk.intel.com>
References: <20210601113236.42651-1-maciej.fijalkowski@intel.com>
 <20210601113236.42651-3-maciej.fijalkowski@intel.com>
 <39b84a66bae09568cd1f95802395af3e2df8fdb1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b84a66bae09568cd1f95802395af3e2df8fdb1.camel@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 01:52:38AM +0100, Nguyen, Anthony L wrote:
> On Tue, 2021-06-01 at 13:32 +0200, Maciej Fijalkowski wrote:
> > Under rare circumstances there might be a situation where a
> > requirement
> > of having a XDP Tx queue per core could not be fulfilled and some of
> > the
> > Tx resources would have to be shared between cores. This yields a
> > need
> > for placing accesses to xdp_rings array onto critical section
> > protected
> > by spinlock.
> >
> > Design of handling such scenario is to at first find out how many
> > queues
> > are there that XDP could use. Any number that is not less than the
> > half
> > of a count of cores of platform is allowed. XDP queue count < cpu
> > count
> > is signalled via new VSI state ICE_VSI_XDP_FALLBACK which carries the
> > information further down to Rx rings where new ICE_TX_XDP_LOCKED is
> > set
> > based on the mentioned VSI state. This ring flag indicates that
> > locking
> > variants for getting/putting xdp_ring need to be used in fast path.
> >
> > For XDP_REDIRECT the impact on standard case (one XDP ring per CPU)
> > can
> > be reduced a bit by providing a separate ndo_xdp_xmit and swap it at
> > configuration time. However, due to the fact that net_device_ops
> > struct
> > is a const, it is not possible to replace a single ndo, so for the
> > locking variant of ndo_xdp_xmit, whole net_device_ops needs to be
> > replayed.
> >
> > It has an impact on performance (1-2 %) of a non-fallback path as
> > branches are introduced.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h          | 37 +++++++++
> >  drivers/net/ethernet/intel/ice/ice_base.c     |  5 ++
> >  drivers/net/ethernet/intel/ice/ice_lib.c      |  4 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c     | 76
> > ++++++++++++++++++-
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     | 62 ++++++++++++++-
> >  drivers/net/ethernet/intel/ice/ice_txrx.h     |  2 +
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 13 +++-
> >  7 files changed, 191 insertions(+), 8 deletions(-)
> 
> This isn't applying to next-queue/dev-queue. I believe it's becuase the
> branch has the soon to be sent tracing patch from Magnus [1].

Thanks for a heads up Tony, I'll send rebased revision.

> 
> Thanks,
> Tony
> 
> [1] https://patchwork.ozlabs.org/project/intel-wired-
> lan/patch/20210510093854.31652-3-magnus.karlsson@gmail.com/
