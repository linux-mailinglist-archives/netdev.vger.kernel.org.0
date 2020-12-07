Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B4D2D1C4A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgLGVq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:46:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:31813 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbgLGVq2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 16:46:28 -0500
IronPort-SDR: htbr+mrnBvKFvJNUXlGmiR3ZEPNEkQt+ryHiqS5QnCsK2xSKkgU317205xanVQJq2Wu+CwztG+
 nrJyUwWZOLeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="235382250"
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="235382250"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 13:45:48 -0800
IronPort-SDR: e9dGbbBbJT562sc2IY8+SuDFX1mnYdrz13joajaDOSiMxT8wdr6qOBeZvJZ7MUNqXHCTbbbsbb
 X7+omVFu6boA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,400,1599548400"; 
   d="scan'208";a="363324947"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2020 13:45:44 -0800
Date:   Mon, 7 Dec 2020 22:37:11 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>, dsahern@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        lorenzo.bianconi@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v5 bpf-next 02/14] xdp: initialize xdp_buff mb bit to 0
 in all XDP drivers
Message-ID: <20201207213711.GA27205@ranger.igk.intel.com>
References: <cover.1607349924.git.lorenzo@kernel.org>
 <693d48b46dd5172763952acd94358cc5d02dcda3.1607349924.git.lorenzo@kernel.org>
 <CAKgT0UcjtERgpV9tke-HcmP7rWOns_-jmthnGiNPES+aqhScFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcjtERgpV9tke-HcmP7rWOns_-jmthnGiNPES+aqhScFg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 01:15:00PM -0800, Alexander Duyck wrote:
> On Mon, Dec 7, 2020 at 8:36 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> > This is a preliminary patch to enable xdp multi-buffer support.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> I'm really not a fan of this design. Having to update every driver in
> order to initialize a field that was fragmented is a pain. At a
> minimum it seems like it might be time to consider introducing some
> sort of initializer function for this so that you can update things in
> one central place the next time you have to add a new field instead of
> having to update every individual driver that supports XDP. Otherwise
> this isn't going to scale going forward.

Also, a good example of why this might be bothering for us is a fact that
in the meantime the dpaa driver got XDP support and this patch hasn't been
updated to include mb setting in that driver.

> 
> > ---
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 1 +
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 1 +
> >  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 1 +
> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 1 +
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 1 +
> >  drivers/net/ethernet/intel/ice/ice_txrx.c           | 1 +
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 1 +
> >  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 1 +
> >  drivers/net/ethernet/marvell/mvneta.c               | 1 +
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 1 +
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 1 +
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 1 +
> >  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 1 +
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 1 +
> >  drivers/net/ethernet/sfc/rx.c                       | 1 +
> >  drivers/net/ethernet/socionext/netsec.c             | 1 +
> >  drivers/net/ethernet/ti/cpsw.c                      | 1 +
> >  drivers/net/ethernet/ti/cpsw_new.c                  | 1 +
> >  drivers/net/hyperv/netvsc_bpf.c                     | 1 +
> >  drivers/net/tun.c                                   | 2 ++
> >  drivers/net/veth.c                                  | 1 +
> >  drivers/net/virtio_net.c                            | 2 ++
> >  drivers/net/xen-netfront.c                          | 1 +
> >  net/core/dev.c                                      | 1 +
> >  24 files changed, 26 insertions(+)
> >
