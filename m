Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B943EFEB4
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhHRII0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:08:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:5486 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238650AbhHRIIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 04:08:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="214431696"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="214431696"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 01:07:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="510768096"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga004.fm.intel.com with ESMTP; 18 Aug 2021 01:07:47 -0700
Date:   Wed, 18 Aug 2021 09:52:56 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "joamaki@gmail.com" <joamaki@gmail.com>
Subject: Re: [PATCH v5 intel-next 0/9] XDP_TX improvements for ice
Message-ID: <20210818075256.GA16780@ranger.igk.intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
 <86e7bcc04d8211fe5796bd7ecbea9458a725ad03.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86e7bcc04d8211fe5796bd7ecbea9458a725ad03.camel@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 09:59:01PM +0100, Nguyen, Anthony L wrote:
> On Sat, 2021-08-14 at 16:08 +0200, Maciej Fijalkowski wrote:
> > With the v5, I think it's time for a proper change log.
> 
> This isn't applying to the Intel-wired-LAN tree. If you want it to go
> through there, could you base the patches on that tree?

Interestingly this is the first time that happens to me and I always based
my XDP related driver work on bpf-next.

iwl tree is some standalone tree or is it just the net-next ?

> 
> Also, looking at NIPA, it looks like patches 2 and 3 have kdoc issues.

Yeah I saw kdoc issue on patch 3 and wanted to ask you to fix this if you
would be applying that set but given that you're asking for a re-submit
i'll fix those by myself.

> 
> Thanks,
> Tony
> 
> > v4->v5:
> > * fix issues pointed by lkp; variables used for updating ring stats
> >   could be un-inited
> > * s/ice_ring/ice_rx_ring; it looks now symmetric given that we have
> >   ice_tx_ring struct dedicated for Tx ring
> > * go through the code and use ice_for_each_* macros; it was spotted
> > by
> >   Brett that there was a place around that code that this set is
> >   touching that was not using the ice_for_each_txq. Turned out that
> > there
> >   were more such places
> > * take care of coalesce related code; carry the info about type of
> > ring
> >   container in ice_ring_container
> > * pull out getting rid of @ring_active onto separate patch, as
> > suggested
> >   by Brett
> >
> > v3->v4:
> > * fix lkp issues;
> >
> > v2->v3:
> > * improve XDP_TX in a proper way
> > * split ice_ring
> > * propagate XDP ring pointer to Rx ring
> >
> > v1->v2:
> > * try to improve XDP_TX processing
> >
> > v4 :
> > https://lore.kernel.org/bpf/20210806095539.34423-1-maciej.fijalkowski@intel.com/
> > v3 :
> > https://lore.kernel.org/bpf/20210805230046.28715-1-maciej.fijalkowski@intel.com/
> > v2 :
> > https://lore.kernel.org/bpf/20210705164338.58313-1-maciej.fijalkowski@intel.com/
> > v1 :
> > https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/
> >
> > Thanks!
> > Maciej
> >
> > Maciej Fijalkowski (9):
> >   ice: remove ring_active from ice_ring
> >   ice: move ice_container_type onto ice_ring_container
> >   ice: split ice_ring onto Tx/Rx separate structs
> >   ice: unify xdp_rings accesses
> >   ice: do not create xdp_frame on XDP_TX
> >   ice: propagate xdp_ring onto rx_ring
> >   ice: optimize XDP_TX workloads
> >   ice: introduce XDP_TX fallback path
> >   ice: make use of ice_for_each_* macros
> >
> >  drivers/net/ethernet/intel/ice/ice.h          |  41 +++-
> >  drivers/net/ethernet/intel/ice/ice_arfs.c     |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_base.c     |  51 ++---
> >  drivers/net/ethernet/intel/ice/ice_base.h     |   8 +-
> >  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |   9 +-
> >  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  10 +-
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c  |  93 +++++----
> >  drivers/net/ethernet/intel/ice/ice_lib.c      |  88 +++++----
> >  drivers/net/ethernet/intel/ice/ice_lib.h      |   6 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c     | 142 +++++++++-----
> >  drivers/net/ethernet/intel/ice/ice_ptp.c      |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_ptp.h      |   4 +-
> >  drivers/net/ethernet/intel/ice/ice_trace.h    |  28 +--
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     | 183 +++++++++++-----
> > --
> >  drivers/net/ethernet/intel/ice/ice_txrx.h     | 126 +++++++-----
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  98 ++++++++--
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  14 +-
> >  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |   2 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c      |  70 ++++---
> >  drivers/net/ethernet/intel/ice/ice_xsk.h      |  20 +-
> >  20 files changed, 607 insertions(+), 390 deletions(-)
> >
