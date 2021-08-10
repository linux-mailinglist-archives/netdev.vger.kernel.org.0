Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C553E5B77
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241539AbhHJNZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:10885 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241418AbhHJNZN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="194490844"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="194490844"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 06:24:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="469022924"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 10 Aug 2021 06:24:47 -0700
Date:   Tue, 10 Aug 2021 15:10:56 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Creeley, Brett" <brett.creeley@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "joamaki@gmail.com" <joamaki@gmail.com>
Subject: Re: [PATCH v3 intel-next 1/6] ice: split ice_ring onto Tx/Rx
 separate structs
Message-ID: <20210810131056.GA8539@ranger.igk.intel.com>
References: <20210805230046.28715-1-maciej.fijalkowski@intel.com>
 <20210805230046.28715-2-maciej.fijalkowski@intel.com>
 <43a691ebd8d1672a138a17dfd356f1451e8099ac.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43a691ebd8d1672a138a17dfd356f1451e8099ac.camel@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 09:46:07PM +0100, Creeley, Brett wrote:
> On Fri, 2021-08-06 at 01:00 +0200, Maciej Fijalkowski wrote:
> > While it was convenient to have a generic ring structure that served
> > both Tx and Rx sides, next commits are going to introduce several
> > Tx-specific fields, so in order to avoid hurting the Rx side, let's
> > pull out the Tx ring onto new ice_tx_ring struct and let the ice_ring
> > handle the Rx rings only.
> 
> I like this change. It makes a lot of sense because the Rx/Tx rings
> have diverged so much.

Glad to hear! First of all, thanks a lot for taking a look at this.

> 
> I don't see any changes in the coalesce code. I'm pretty sure there
> should be some changes in ice_set_rc_coalesce() at the very least
> based on these changes.

Yeah I guess we need some adjustments with regards to type of the ring
container.

> 
> >
> > Make the union out of the ring container within ice_q_vector so that
> > it
> > is possible to iterate over newly introduced ice_tx_ring.
> >
> > Remove the @size as it's only accessed from control path and it can
> > be
> > calculated pretty easily.
> >
> > Remove @ring_active as it's not actively used anywhere.
> >
> > Change definitions of ice_update_ring_stats and
> > ice_fetch_u64_stats_per_ring so that they are ring agnostic and can
> > be
> > used for both Rx and Tx rings.
> >
> > Sizes of Rx and Tx ring structs are 256 and 192 bytes, respectively.
> > In
> > Rx ring xdp_rxq_info occupies its own cacheline, so it's the major
> > difference now.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h          | 27 ++++--
> >  drivers/net/ethernet/intel/ice/ice_base.c     | 27 +++---
> >  drivers/net/ethernet/intel/ice/ice_base.h     |  6 +-
> >  drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  5 +-
> >  drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |  6 +-
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c  | 17 ++--
> >  drivers/net/ethernet/intel/ice/ice_lib.c      | 28 +++---
> >  drivers/net/ethernet/intel/ice/ice_lib.h      |  4 +-
> >  drivers/net/ethernet/intel/ice/ice_main.c     | 47 +++++-----
> >  drivers/net/ethernet/intel/ice/ice_trace.h    |  8 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     | 87 ++++++++++-------
> > -
> >  drivers/net/ethernet/intel/ice/ice_txrx.h     | 90 ++++++++++++-----
> > --
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  6 +-
> >  drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  8 +-
> >  .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  2 +-
> >  drivers/net/ethernet/intel/ice/ice_xsk.c      | 29 +++---
> >  drivers/net/ethernet/intel/ice/ice_xsk.h      |  8 +-
> >  17 files changed, 233 insertions(+), 172 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice.h
> > b/drivers/net/ethernet/intel/ice/ice.h
> > index a450343fbb92..2e15e097bc0f 100644
> > --- a/drivers/net/ethernet/intel/ice/ice.h
> > +++ b/drivers/net/ethernet/intel/ice/ice.h
> > @@ -266,7 +266,7 @@ struct ice_vsi {
> >       struct ice_pf *back;             /* back pointer to PF */
> >       struct ice_port_info *port_info; /* back pointer to port_info
> > */
> >       struct ice_ring **rx_rings;      /* Rx ring array */
> 
> If you are doing this, we should be explicit for Rx rings too and
> rename ice_ring to ice_rx_ring.

I just wanted to reduce the overhead by not doing so, but I agree it's
needed...

> 
> Obviously this would generate some more work here, but I think
> it's necessary with this change.
> 
> > -     struct ice_ring **tx_rings;      /* Tx ring array */
> > +     struct ice_tx_ring **tx_rings;   /* Tx ring array */
> >       struct ice_q_vector **q_vectors; /* q_vector array */
> >
> >       irqreturn_t (*irq_handler)(int irq, void *data);
> > @@ -343,7 +343,7 @@ struct ice_vsi {
> >       u16 qset_handle[ICE_MAX_TRAFFIC_CLASS];
> >       struct ice_tc_cfg tc_cfg;
> >       struct bpf_prog *xdp_prog;
> > -     struct ice_ring **xdp_rings;     /* XDP ring array */
> > +     struct ice_tx_ring **xdp_rings;  /* XDP ring array */
> >       unsigned long *af_xdp_zc_qps;    /* tracks AF_XDP ZC enabled
> > qps */
> >       u16 num_xdp_txq;                 /* Used XDP queues */
> >       u8 xdp_mapping_mode;             /*
> > ICE_MAP_MODE_[CONTIG|SCATTER] */
> > @@ -555,14 +555,14 @@ static inline bool ice_is_xdp_ena_vsi(struct
> > ice_vsi *vsi)
> >       return !!vsi->xdp_prog;
> >  }
> >
> > -static inline void ice_set_ring_xdp(struct ice_ring *ring)
> > +static inline void ice_set_ring_xdp(struct ice_tx_ring *ring)
> >  {
> >       ring->flags |= ICE_TX_FLAGS_RING_XDP;
> >  }
> >
> >  /**
> >   * ice_xsk_pool - get XSK buffer pool bound to a ring
> > - * @ring: ring to use
> > + * @ring: Rx ring to use
> >   *
> >   * Returns a pointer to xdp_umem structure if there is a buffer pool
> > present,
> >   * NULL otherwise.
> > @@ -572,8 +572,23 @@ static inline struct xsk_buff_pool
> > *ice_xsk_pool(struct ice_ring *ring)
> >       struct ice_vsi *vsi = ring->vsi;
> >       u16 qid = ring->q_index;
> >
> > -     if (ice_ring_is_xdp(ring))
> > -             qid -= vsi->num_xdp_txq;
> > +     if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi-
> > >af_xdp_zc_qps))
> > +             return NULL;
> > +
> > +     return xsk_get_pool_from_qid(vsi->netdev, qid);
> 
> Is this a bug fix? It seems like before we

Seems like you didn't finish your thought? But it's not a bugfix. This
func is now dedicated only for Rx rings which won't have the
ICE_TX_FLAGS_RING_XDP set as it's dedicated for XDP Tx ring, that's why I
removed the call to ice_ring_is_xdp().

Maybe you're referring to something else?

> > +}
> > +
> > +/**
> > + * ice_tx_xsk_pool - get XSK buffer pool bound to a ring
> > + * @ring: Tx ring to use
> > + *
> > + * Returns a pointer to xdp_umem structure if there is a buffer pool
> > present,
> > + * NULL otherwise. Tx equivalent of ice_xsk_pool.
> > + */
> > +static inline struct xsk_buff_pool *ice_tx_xsk_pool(struct
> > ice_tx_ring *ring)
> > +{
> > +     struct ice_vsi *vsi = ring->vsi;
> > +     u16 qid = ring->q_index - vsi->num_xdp_txq;
> 
> RCT. Should just assign the qid variable after to keep RCT
> ordering. Probably not strictly necessary though because it
> makes sense this way since you have to deref the vsi first.

If you insist, I can rewrite this in a way that RCT requirement is
satisfied.

> 
> >
> >       if (!ice_is_xdp_ena_vsi(vsi) || !test_bit(qid, vsi-
> > >af_xdp_zc_qps))
> >               return NULL;
> > diff --git a/drivers/net/ethernet/intel/ice/ice_base.c
> > b/drivers/net/ethernet/intel/ice/ice_base.c
> > index c36057efc7ae..838ee4b8d96f 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_base.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_base.c
> > @@ -146,6 +146,7 @@ static void ice_free_q_vector(struct ice_vsi
> > *vsi, int v_idx)
> >  {
> >       struct ice_q_vector *q_vector;
> >       struct ice_pf *pf = vsi->back;
> > +     struct ice_tx_ring *tx_ring;
> >       struct ice_ring *ring;
> struct ice_rx_ring *rx_ring; would be much more clear here
> >       struct device *dev;
> >
> > @@ -156,8 +157,8 @@ static void ice_free_q_vector(struct ice_vsi
> > *vsi, int v_idx)
> >       }
> >       q_vector = vsi->q_vectors[v_idx];
> >
> > -     ice_for_each_ring(ring, q_vector->tx)
> > -             ring->q_vector = NULL;
> > +     ice_for_each_tx_ring(tx_ring, q_vector->tx)
> > +             tx_ring->q_vector = NULL;
> 
> It seems like if we used a "void *ring" in the ice_ring_container
> it would simplify some of this and we wouldn't need a
> differnt "for_each" for loop.
> 
> The only downfall is we would have to cast to the correct ring
> type based on context when we want to dereference it.

I tried the void *ring approach and it turned out to have the same or even
worse overhead as all of the references to a Rx/Tx ring specific struct
within the for_each loop needed to be replaced.

> 
> >       ice_for_each_ring(ring, q_vector->rx)
> >               ring->q_vector = NULL;
> Then it would be more explicit:
> 
> ice_for_each_rx_ring(ring, q_vector->rx)
>         rx_ring->q_vector = NULL;

You need to do:
struct ice_rx_ring *rx_ring = (struct ice_rx_ring *)ring;

before NULLing and then do the s/ring/rx_ring/g within the loop.

> >
> > @@ -206,7 +207,7 @@ static void ice_cfg_itr_gran(struct ice_hw *hw)
> >   * @ring: ring to get the absolute queue index
> >   * @tc: traffic class number
> >   */
> > -static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_ring
> > *ring, u8 tc)
> > +static u16 ice_calc_q_handle(struct ice_vsi *vsi, struct ice_tx_ring
> > *ring, u8 tc)
> 
> should this be ice_calc_txq_handle()? Seems like it should have always
> been called that, but your change made it more obvious.

Agree!

> 
> >  {
> >       WARN_ONCE(ice_ring_is_xdp(ring) && tc, "XDP ring can't belong
> > to TC other than 0\n");
> >
> > @@ -224,7 +225,7 @@ static u16 ice_calc_q_handle(struct ice_vsi *vsi,
> > struct ice_ring *ring, u8 tc)
> >   * This enables/disables XPS for a given Tx descriptor ring
> >   * based on the TCs enabled for the VSI that ring belongs to.
> >   */
> > -static void ice_cfg_xps_tx_ring(struct ice_ring *ring)
> > +static void ice_cfg_xps_tx_ring(struct ice_tx_ring *ring)
> >  {
> >       if (!ring->q_vector || !ring->netdev)
> >               return;
> > @@ -246,7 +247,7 @@ static void ice_cfg_xps_tx_ring(struct ice_ring
> > *ring)
> >   * Configure the Tx descriptor ring in TLAN context.
> >   */
> >  static void
> > -ice_setup_tx_ctx(struct ice_ring *ring, struct ice_tlan_ctx
> > *tlan_ctx, u16 pf_q)
> > +ice_setup_tx_ctx(struct ice_tx_ring *ring, struct ice_tlan_ctx
> > *tlan_ctx, u16 pf_q)
> >  {
> >       struct ice_vsi *vsi = ring->vsi;
> >       struct ice_hw *hw = &vsi->back->hw;
> > @@ -258,7 +259,7 @@ ice_setup_tx_ctx(struct ice_ring *ring, struct
> > ice_tlan_ctx *tlan_ctx, u16 pf_q)
> >       /* Transmit Queue Length */
> >       tlan_ctx->qlen = ring->count;
> >
> > -     ice_set_cgd_num(tlan_ctx, ring);
> > +     ice_set_cgd_num(tlan_ctx, ring->dcb_tc);
> >
> >       /* PF number */
> >       tlan_ctx->pf_num = hw->pf_id;
> > @@ -660,16 +661,16 @@ void ice_vsi_map_rings_to_vectors(struct
> > ice_vsi *vsi)
> >               tx_rings_per_v = (u8)DIV_ROUND_UP(tx_rings_rem,
> >                                                 q_vectors - v_id);
> >               q_vector->num_ring_tx = tx_rings_per_v;
> > -             q_vector->tx.ring = NULL;
> > +             q_vector->tx.tx_ring = NULL;
> >               q_vector->tx.itr_idx = ICE_TX_ITR;
> >               q_base = vsi->num_txq - tx_rings_rem;
> >
> >               for (q_id = q_base; q_id < (q_base + tx_rings_per_v);
> > q_id++) {
> > -                     struct ice_ring *tx_ring = vsi->tx_rings[q_id];
> > +                     struct ice_tx_ring *tx_ring = vsi-
> > >tx_rings[q_id];
> >
> >                       tx_ring->q_vector = q_vector;
> > -                     tx_ring->next = q_vector->tx.ring;
> > -                     q_vector->tx.ring = tx_ring;
> > +                     tx_ring->next = q_vector->tx.tx_ring;
> > +                     q_vector->tx.tx_ring = tx_ring;
> >               }
> >               tx_rings_rem -= tx_rings_per_v;
> >
> > @@ -711,7 +712,7 @@ void ice_vsi_free_q_vectors(struct ice_vsi *vsi)
> >   * @qg_buf: queue group buffer
> >   */
> >  int
> > -ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
> > +ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
> >               struct ice_aqc_add_tx_qgrp *qg_buf)
> >  {
> >       u8 buf_len = struct_size(qg_buf, txqs, 1);
> > @@ -870,7 +871,7 @@ void ice_trigger_sw_intr(struct ice_hw *hw,
> > struct ice_q_vector *q_vector)
> >   */
> >  int
> >  ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src
> > rst_src,
> > -                  u16 rel_vmvf_num, struct ice_ring *ring,
> > +                  u16 rel_vmvf_num, struct ice_tx_ring *ring,
> >                    struct ice_txq_meta *txq_meta)
> >  {
> >       struct ice_pf *pf = vsi->back;
> > @@ -927,7 +928,7 @@ ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum
> > ice_disq_rst_src rst_src,
> >   * are needed for stopping Tx queue
> >   */
> >  void
> > -ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
> > +ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_tx_ring *ring,
> >                 struct ice_txq_meta *txq_meta)
> >  {
> >       u8 tc;
> > diff --git a/drivers/net/ethernet/intel/ice/ice_base.h
> > b/drivers/net/ethernet/intel/ice/ice_base.h
> > index 20e1c29aa68a..2ce777eb53b0 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_base.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_base.h
> > @@ -15,7 +15,7 @@ int ice_vsi_alloc_q_vectors(struct ice_vsi *vsi);
> >  void ice_vsi_map_rings_to_vectors(struct ice_vsi *vsi);
> >  void ice_vsi_free_q_vectors(struct ice_vsi *vsi);
> >  int
> > -ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_ring *ring,
> > +ice_vsi_cfg_txq(struct ice_vsi *vsi, struct ice_tx_ring *ring,
> >               struct ice_aqc_add_tx_qgrp *qg_buf);
> >  void ice_cfg_itr(struct ice_hw *hw, struct ice_q_vector *q_vector);
> >  void
> > @@ -25,9 +25,9 @@ ice_cfg_rxq_interrupt(struct ice_vsi *vsi, u16 rxq,
> > u16 msix_idx, u16 itr_idx);
> >  void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector
> > *q_vector);
> >  int
> >  ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src
> > rst_src,
> > -                  u16 rel_vmvf_num, struct ice_ring *ring,
> > +                  u16 rel_vmvf_num, struct ice_tx_ring *ring,
> >                    struct ice_txq_meta *txq_meta);
> >  void
> > -ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_ring *ring,
> > +ice_fill_txq_meta(struct ice_vsi *vsi, struct ice_tx_ring *ring,
> >                 struct ice_txq_meta *txq_meta);
> >  #endif /* _ICE_BASE_H_ */
> > diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> > b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> > index 926cf748c5ec..2507223bfdc7 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
> > @@ -194,7 +194,8 @@ u8 ice_dcb_get_tc(struct ice_vsi *vsi, int
> > queue_index)
> >   */
> >  void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi)
> >  {
> > -     struct ice_ring *tx_ring, *rx_ring;
> > +     struct ice_tx_ring *tx_ring;
> > +     struct ice_ring *rx_ring;
> >       u16 qoffset, qcount;
> >       int i, n;
> >
> > @@ -814,7 +815,7 @@ void ice_update_dcb_stats(struct ice_pf *pf)
> >   * tag will already be configured with the correct ID and priority
> > bits
> >   */
> >  void
> > -ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
> > +ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
> >                             struct ice_tx_buf *first)
> >  {
> >       struct sk_buff *skb = first->skb;
> > diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
> > b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
> > index 261b6e2ed7bc..a5bdf47cd34a 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.h
> > @@ -28,7 +28,7 @@ void ice_vsi_cfg_dcb_rings(struct ice_vsi *vsi);
> >  int ice_init_pf_dcb(struct ice_pf *pf, bool locked);
> >  void ice_update_dcb_stats(struct ice_pf *pf);
> >  void
> > -ice_tx_prepare_vlan_flags_dcb(struct ice_ring *tx_ring,
> > +ice_tx_prepare_vlan_flags_dcb(struct ice_tx_ring *tx_ring,
> >                             struct ice_tx_buf *first);
> >  void
> >  ice_dcb_process_lldp_set_mib_change(struct ice_pf *pf,
> > @@ -49,9 +49,9 @@ static inline bool ice_find_q_in_range(u16 low, u16
> > high, unsigned int tx_q)
> >  }
> >
> >  static inline void
> > -ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, struct ice_ring
> > *ring)
> > +ice_set_cgd_num(struct ice_tlan_ctx *tlan_ctx, u8 dcb_tc)
> >  {
> > -     tlan_ctx->cgd_num = ring->dcb_tc;
> > +     tlan_ctx->cgd_num = dcb_tc;
> 
> Seems like this change isn't 100% necessary as part of this patch,
> but I guess you would have had to update it to use ice_tx_ring,
> so this does make sense to just pass the dcb_tc.

I can pass the ice_tx_ring to keep the previous logic.

> 
> >  }
> >
> >  static inline bool ice_is_dcb_active(struct ice_pf *pf)
> > diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > index d95a5daca114..644ce9f3494d 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> > @@ -584,7 +584,7 @@ static bool ice_lbtest_check_frame(u8 *frame)
> >   *
> >   * Function sends loopback packets on a test Tx ring.
> >   */
> > -static int ice_diag_send(struct ice_ring *tx_ring, u8 *data, u16
> > size)
> > +static int ice_diag_send(struct ice_tx_ring *tx_ring, u8 *data, u16
> > size)
> >  {
> >       struct ice_tx_desc *tx_desc;
> >       struct ice_tx_buf *tx_buf;
> > @@ -676,9 +676,10 @@ static u64 ice_loopback_test(struct net_device
> > *netdev)
> >       struct ice_netdev_priv *np = netdev_priv(netdev);
> >       struct ice_vsi *orig_vsi = np->vsi, *test_vsi;
> >       struct ice_pf *pf = orig_vsi->back;
> > -     struct ice_ring *tx_ring, *rx_ring;
> >       u8 broadcast[ETH_ALEN], ret = 0;
> >       int num_frames, valid_frames;
> > +     struct ice_tx_ring *tx_ring;
> > +     struct ice_ring *rx_ring;
> >       struct device *dev;
> >       u8 *tx_frame;
> >       int i;
> > @@ -1318,6 +1319,7 @@ ice_get_ethtool_stats(struct net_device
> > *netdev,
> >       struct ice_netdev_priv *np = netdev_priv(netdev);
> >       struct ice_vsi *vsi = np->vsi;
> >       struct ice_pf *pf = vsi->back;
> > +     struct ice_tx_ring *tx_ring;
> >       struct ice_ring *ring;
> >       unsigned int j;
> >       int i = 0;
> > @@ -1336,10 +1338,10 @@ ice_get_ethtool_stats(struct net_device
> > *netdev,
> >       rcu_read_lock();
> >
> >       ice_for_each_alloc_txq(vsi, j) {
> > -             ring = READ_ONCE(vsi->tx_rings[j]);
> > +             tx_ring = READ_ONCE(vsi->tx_rings[j]);
> >               if (ring) {
> 
> This should be "if (tx_ring)"

Oops, thanks, lkp yelled at me as well.

> 
> > -                     data[i++] = ring->stats.pkts;
> > -                     data[i++] = ring->stats.bytes;
> > +                     data[i++] = tx_ring->stats.pkts;
> > +                     data[i++] = tx_ring->stats.bytes;
> >               } else {
> >                       data[i++] = 0;
> >                       data[i++] = 0;
> > @@ -2667,9 +2669,10 @@ ice_get_ringparam(struct net_device *netdev,
> > struct ethtool_ringparam *ring)
> >  static int
> >  ice_set_ringparam(struct net_device *netdev, struct
> > ethtool_ringparam *ring)
> >  {
> > -     struct ice_ring *tx_rings = NULL, *rx_rings = NULL;
> > +     struct ice_tx_ring *tx_rings = NULL;
> > +     struct ice_ring *rx_rings = NULL;
> >       struct ice_netdev_priv *np = netdev_priv(netdev);
> > -     struct ice_ring *xdp_rings = NULL;
> > +     struct ice_tx_ring *xdp_rings = NULL;
> 
> RCT got a little messed up here.

Will fix.

> 
> >       struct ice_vsi *vsi = np->vsi;
> >       struct ice_pf *pf = vsi->back;
> >       int i, timeout = 50, err = 0;
> > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c
> > b/drivers/net/ethernet/intel/ice/ice_lib.c
> > index dde9802c6c72..ac0d7a52406b 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_lib.c
> > @@ -379,12 +379,12 @@ static irqreturn_t ice_msix_clean_ctrl_vsi(int
> > __always_unused irq, void *data)
> >  {
> >       struct ice_q_vector *q_vector = (struct ice_q_vector *)data;
> >
> > -     if (!q_vector->tx.ring)
> 
> I don't think this function would have changed if we used a "void
> *ring" in the ice_ring_container.

Right, but I still think that this way we have less overhead given the
things that would be needed for void * approach I described above...

> 
> > +     if (!q_vector->tx.tx_ring)
> >               return IRQ_HANDLED;
> >
> >  #define FDIR_RX_DESC_CLEAN_BUDGET 64
> >       ice_clean_rx_irq(q_vector->rx.ring, FDIR_RX_DESC_CLEAN_BUDGET);
> > -     ice_clean_ctrl_tx_irq(q_vector->tx.ring);
> > +     ice_clean_ctrl_tx_irq(q_vector->tx.tx_ring);
> >
> >       return IRQ_HANDLED;
> >  }
> > @@ -1286,7 +1286,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi
> > *vsi)
> >       dev = ice_pf_to_dev(pf);
> >       /* Allocate Tx rings */
> >       for (i = 0; i < vsi->alloc_txq; i++) {
> > -             struct ice_ring *ring;
> > +             struct ice_tx_ring *ring;
> >
> >               /* allocate with kzalloc(), free with kfree_rcu() */
> >               ring = kzalloc(sizeof(*ring), GFP_KERNEL);
> > @@ -1296,7 +1296,6 @@ static int ice_vsi_alloc_rings(struct ice_vsi
> > *vsi)
> >
> >               ring->q_index = i;
> >               ring->reg_idx = vsi->txq_map[i];
> > -             ring->ring_active = false;
> >               ring->vsi = vsi;
> >               ring->tx_tstamps = &pf->ptp.port.tx;
> >               ring->dev = dev;
> > @@ -1315,7 +1314,6 @@ static int ice_vsi_alloc_rings(struct ice_vsi
> > *vsi)
> >
> >               ring->q_index = i;
> >               ring->reg_idx = vsi->rxq_map[i];
> > -             ring->ring_active = false;
> >               ring->vsi = vsi;
> >               ring->netdev = vsi->netdev;
> >               ring->dev = dev;
> > @@ -1710,7 +1708,7 @@ int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi,
> > u16 q_idx)
> >       return ice_vsi_cfg_rxq(vsi->rx_rings[q_idx]);
> >  }
> >
> > -int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring
> > **tx_rings, u16 q_idx)
> > +int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring
> > **tx_rings, u16 q_idx)
> >  {
> >       struct ice_aqc_add_tx_qgrp *qg_buf;
> >       int err;
> > @@ -1766,7 +1764,7 @@ int ice_vsi_cfg_rxqs(struct ice_vsi *vsi)
> >   * Configure the Tx VSI for operation.
> >   */
> >  static int
> > -ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_ring **rings, u16
> > count)
> > +ice_vsi_cfg_txqs(struct ice_vsi *vsi, struct ice_tx_ring **rings,
> > u16 count)
> >  {
> >       struct ice_aqc_add_tx_qgrp *qg_buf;
> >       u16 q_idx = 0;
> > @@ -1818,7 +1816,7 @@ int ice_vsi_cfg_xdp_txqs(struct ice_vsi *vsi)
> >               return ret;
> >
> >       for (i = 0; i < vsi->num_xdp_txq; i++)
> > -             vsi->xdp_rings[i]->xsk_pool = ice_xsk_pool(vsi-
> > >xdp_rings[i]);
> > +             vsi->xdp_rings[i]->xsk_pool = ice_tx_xsk_pool(vsi-
> > >xdp_rings[i]);
> >
> >       return ret;
> >  }
> > @@ -2057,7 +2055,7 @@ int ice_vsi_stop_all_rx_rings(struct ice_vsi
> > *vsi)
> >   */
> >  static int
> >  ice_vsi_stop_tx_rings(struct ice_vsi *vsi, enum ice_disq_rst_src
> > rst_src,
> > -                   u16 rel_vmvf_num, struct ice_ring **rings, u16
> > count)
> > +                   u16 rel_vmvf_num, struct ice_tx_ring **rings, u16
> > count)
> >  {
> >       u16 q_idx;
> >
> > @@ -3357,10 +3355,10 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8
> > ena_tc)
> >   *
> >   * This function assumes that caller has acquired a u64_stats_sync
> > lock.
> >   */
> > -static void ice_update_ring_stats(struct ice_ring *ring, u64 pkts,
> > u64 bytes)
> > +static void ice_update_ring_stats(struct ice_q_stats *stats, u64
> > pkts, u64 bytes)
> >  {
> > -     ring->stats.bytes += bytes;
> > -     ring->stats.pkts += pkts;
> > +     stats->bytes += bytes;
> > +     stats->pkts += pkts;
> 
> This is a nice little clean up.
> 
> >  }
> >
> >  /**
> > @@ -3369,10 +3367,10 @@ static void ice_update_ring_stats(struct
> > ice_ring *ring, u64 pkts, u64 bytes)
> >   * @pkts: number of processed packets
> >   * @bytes: number of processed bytes
> >   */
> > -void ice_update_tx_ring_stats(struct ice_ring *tx_ring, u64 pkts,
> > u64 bytes)
> > +void ice_update_tx_ring_stats(struct ice_tx_ring *tx_ring, u64 pkts,
> > u64 bytes)
> >  {
> >       u64_stats_update_begin(&tx_ring->syncp);
> > -     ice_update_ring_stats(tx_ring, pkts, bytes);
> > +     ice_update_ring_stats(&tx_ring->stats, pkts, bytes);
> >       u64_stats_update_end(&tx_ring->syncp);
> >  }
> >
> > @@ -3385,7 +3383,7 @@ void ice_update_tx_ring_stats(struct ice_ring
> > *tx_ring, u64 pkts, u64 bytes)
> >  void ice_update_rx_ring_stats(struct ice_ring *rx_ring, u64 pkts,
> > u64 bytes)
> >  {
> >       u64_stats_update_begin(&rx_ring->syncp);
> > -     ice_update_ring_stats(rx_ring, pkts, bytes);
> > +     ice_update_ring_stats(&rx_ring->stats, pkts, bytes);
> >       u64_stats_update_end(&rx_ring->syncp);
> >  }
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h
> > b/drivers/net/ethernet/intel/ice/ice_lib.h
> > index d5a28bf0fc2c..2a69666db194 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_lib.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_lib.h
> > @@ -14,7 +14,7 @@ void ice_update_eth_stats(struct ice_vsi *vsi);
> >
> >  int ice_vsi_cfg_single_rxq(struct ice_vsi *vsi, u16 q_idx);
> >
> > -int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_ring
> > **tx_rings, u16 q_idx);
> > +int ice_vsi_cfg_single_txq(struct ice_vsi *vsi, struct ice_tx_ring
> > **tx_rings, u16 q_idx);
> >
> >  int ice_vsi_cfg_rxqs(struct ice_vsi *vsi);
> >
> > @@ -93,7 +93,7 @@ void ice_vsi_free_tx_rings(struct ice_vsi *vsi);
> >
> >  void ice_vsi_manage_rss_lut(struct ice_vsi *vsi, bool ena);
> >
> > -void ice_update_tx_ring_stats(struct ice_ring *ring, u64 pkts, u64
> > bytes);
> > +void ice_update_tx_ring_stats(struct ice_tx_ring *ring, u64 pkts,
> > u64 bytes);
> >
> >  void ice_update_rx_ring_stats(struct ice_ring *ring, u64 pkts, u64
> > bytes);
> >
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> > b/drivers/net/ethernet/intel/ice/ice_main.c
> > index ef8d1815af56..cbcb4ad60852 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -61,7 +61,7 @@ bool netif_is_ice(struct net_device *dev)
> >   * ice_get_tx_pending - returns number of Tx descriptors not
> > processed
> >   * @ring: the ring of descriptors
> >   */
> > -static u16 ice_get_tx_pending(struct ice_ring *ring)
> > +static u16 ice_get_tx_pending(struct ice_tx_ring *ring)
> >  {
> >       u16 head, tail;
> >
> > @@ -101,7 +101,7 @@ static void ice_check_for_hang_subtask(struct
> > ice_pf *pf)
> >       hw = &vsi->back->hw;
> >
> >       for (i = 0; i < vsi->num_txq; i++) {
> 
> Interesting that this isn't using ice_for_each_txq()

I see that there are two more occurrences of such loop that could be
replaced with ice_for_each_txq(). Separate patch?

> 
> > -             struct ice_ring *tx_ring = vsi->tx_rings[i];
> > +             struct ice_tx_ring *tx_ring = vsi->tx_rings[i];
> >
> >               if (tx_ring && tx_ring->desc) {
> >                       /* If packet counter has not changed the queue
> > is

[...]

> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > index 1e46e80f3d6f..d4ab3558933e 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> > @@ -154,7 +154,7 @@ struct ice_tx_buf {
> >
> >  struct ice_tx_offload_params {
> >       u64 cd_qw1;
> > -     struct ice_ring *tx_ring;
> > +     struct ice_tx_ring *tx_ring;
> >       u32 td_cmd;
> >       u32 td_offset;
> >       u32 td_l2tag1;
> > @@ -267,16 +267,11 @@ struct ice_ring {
> >       struct ice_vsi *vsi;            /* Backreference to
> > associated VSI */
> >       struct ice_q_vector *q_vector;  /* Backreference to
> > associated vector */
> >       u8 __iomem *tail;
> > -     union {
> > -             struct ice_tx_buf *tx_buf;
> > -             struct ice_rx_buf *rx_buf;
> > -     };
> > +     struct ice_rx_buf *rx_buf;
> >       /* CL2 - 2nd cacheline starts here */
> > +     struct xdp_rxq_info xdp_rxq;
> > +     /* CL3 - 3rd cacheline starts here */
> >       u16 q_index;                    /* Queue number of ring */
> > -     u16 q_handle;                   /* Queue handle per TC */
> > -
> > -     u8 ring_active:1;               /* is ring online or not */
> 
> Seems like "ring_active" could be removed as a separate patch since
> it doesn't seemed to be used at all. Am I missing something here?

I don't mind pulling this out to a separate patch. This is not used for a
long time AFAICT.

> 
> > -
> >       u16 count;                      /* Number of descriptors */
> >       u16 reg_idx;                    /* HW register index of the
> > ring */
> >
> > @@ -284,38 +279,61 @@ struct ice_ring {
> >       u16 next_to_use;
> >       u16 next_to_clean;
> >       u16 next_to_alloc;
> > +     u16 rx_offset;
> > +     u16 rx_buf_len;
> >
> >       /* stats structs */
> > +     struct ice_rxq_stats rx_stats;
> >       struct ice_q_stats      stats;
> >       struct u64_stats_sync syncp;
> > -     union {
> > -             struct ice_txq_stats tx_stats;
> > -             struct ice_rxq_stats rx_stats;
> > -     };
> >
> >       struct rcu_head rcu;            /* to avoid race on free */
> > -     DECLARE_BITMAP(xps_state, ICE_TX_NBITS);        /* XPS Config State
> > */
> > +     /* CL4 - 3rd cacheline starts here */
> >       struct bpf_prog *xdp_prog;
> >       struct xsk_buff_pool *xsk_pool;
> > -     u16 rx_offset;
> > -     /* CL3 - 3rd cacheline starts here */
> > -     struct xdp_rxq_info xdp_rxq;
> >       struct sk_buff *skb;
> > -     /* CLX - the below items are only accessed infrequently and
> > should be
> > -      * in their own cache line if possible
> > -      */
> > -#define ICE_TX_FLAGS_RING_XDP                BIT(0)
> > +     dma_addr_t dma;                 /* physical address of ring
> > */
> >  #define ICE_RX_FLAGS_RING_BUILD_SKB  BIT(1)
> > +     u64 cached_phctime;
> > +     u8 dcb_tc;                      /* Traffic class of ring */
> > +     u8 ptp_rx;
> >       u8 flags;
> > +} ____cacheline_internodealigned_in_smp;
> > +
> > +struct ice_tx_ring {
> > +     /* CL1 - 1st cacheline starts here */
> > +     struct ice_tx_ring *next;       /* pointer to next ring in q_vector
> > */
> > +     void *desc;                     /* Descriptor ring memory */
> > +     struct device *dev;             /* Used for DMA mapping */
> > +     u8 __iomem *tail;
> > +     struct ice_tx_buf *tx_buf;
> > +     struct ice_q_vector *q_vector;  /* Backreference to
> > associated vector */
> > +     struct net_device *netdev;      /* netdev ring maps to */
> > +     struct ice_vsi *vsi;            /* Backreference to
> > associated VSI */
> > +     /* CL2 - 2nd cacheline starts here */
> >       dma_addr_t dma;                 /* physical address of ring
> > */
> > -     unsigned int size;              /* length of descriptor ring
> > in bytes */
> > +     u16 next_to_use;
> > +     u16 next_to_clean;
> > +     u16 count;                      /* Number of descriptors */
> > +     u16 q_index;                    /* Queue number of ring */
> > +     struct xsk_buff_pool *xsk_pool;
> > +
> > +     /* stats structs */
> > +     struct ice_q_stats      stats;
> > +     struct u64_stats_sync syncp;
> > +     struct ice_txq_stats tx_stats;
> > +
> > +     /* CL3 - 3rd cacheline starts here */
> > +     struct rcu_head rcu;            /* to avoid race on free */
> > +     DECLARE_BITMAP(xps_state, ICE_TX_NBITS);        /* XPS Config State
> > */
> > +     struct ice_ptp_tx *tx_tstamps;
> >       u32 txq_teid;                   /* Added Tx queue TEID */
> > -     u16 rx_buf_len;
> > +     u16 q_handle;                   /* Queue handle per TC */
> > +     u16 reg_idx;                    /* HW register index of the
> > ring */
> > +#define ICE_TX_FLAGS_RING_XDP                BIT(0)
> > +     u8 flags;
> >       u8 dcb_tc;                      /* Traffic class of ring */
> > -     struct ice_ptp_tx *tx_tstamps;
> > -     u64 cached_phctime;
> > -     u8 ptp_rx:1;
> > -     u8 ptp_tx:1;
> > +     u8 ptp_tx;
> >  } ____cacheline_internodealigned_in_smp;
> >
> >  static inline bool ice_ring_uses_build_skb(struct ice_ring *ring)
> > @@ -333,14 +351,17 @@ static inline void
> > ice_clear_ring_build_skb_ena(struct ice_ring *ring)
> >       ring->flags &= ~ICE_RX_FLAGS_RING_BUILD_SKB;
> >  }
> >
> > -static inline bool ice_ring_is_xdp(struct ice_ring *ring)
> > +static inline bool ice_ring_is_xdp(struct ice_tx_ring *ring)
> >  {
> >       return !!(ring->flags & ICE_TX_FLAGS_RING_XDP);
> >  }
> >
> >  struct ice_ring_container {
> >       /* head of linked-list of rings */
> > -     struct ice_ring *ring;
> > +     union {
> > +             struct ice_ring *ring;
> > +             struct ice_tx_ring *tx_ring;
> > +     };
> >       struct dim dim;         /* data for net_dim algorithm */
> >       u16 itr_idx;            /* index in the interrupt vector */
> >       /* this matches the maximum number of ITR bits, but in usec
> > @@ -363,6 +384,9 @@ struct ice_coalesce_stored {
> >  #define ice_for_each_ring(pos, head) \
> >       for (pos = (head).ring; pos; pos = pos->next)
> >
> > +#define ice_for_each_tx_ring(pos, head) \
> > +     for (pos = (head).tx_ring; pos; pos = pos->next)
> > +
> >  {
> >  #if (PAGE_SIZE < 8192)
> > @@ -378,16 +402,16 @@ union ice_32b_rx_flex_desc;
> >
> >  bool ice_alloc_rx_bufs(struct ice_ring *rxr, u16 cleaned_count);
> >  netdev_tx_t ice_start_xmit(struct sk_buff *skb, struct net_device
> > *netdev);
> > -void ice_clean_tx_ring(struct ice_ring *tx_ring);
> > +void ice_clean_tx_ring(struct ice_tx_ring *tx_ring);
> >  void ice_clean_rx_ring(struct ice_ring *rx_ring);
> > -int ice_setup_tx_ring(struct ice_ring *tx_ring);
> > +int ice_setup_tx_ring(struct ice_tx_ring *tx_ring);
> >  int ice_setup_rx_ring(struct ice_ring *rx_ring);
> > -void ice_free_tx_ring(struct ice_ring *tx_ring);
> > +void ice_free_tx_ring(struct ice_tx_ring *tx_ring);
> >  void ice_free_rx_ring(struct ice_ring *rx_ring);
> >  int ice_napi_poll(struct napi_struct *napi, int budget);
> >  int
> >  ice_prgm_fdir_fltr(struct ice_vsi *vsi, struct ice_fltr_desc
> > *fdir_desc,
> >                  u8 *raw_packet);
> >  int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget);
> > -void ice_clean_ctrl_tx_irq(struct ice_ring *tx_ring);
> > +void ice_clean_ctrl_tx_irq(struct ice_tx_ring *tx_ring);
> >  #endif /* _ICE_TXRX_H_ */
> > diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > index 171397dcf00a..74519c603872 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
> > @@ -217,7 +217,7 @@ ice_receive_skb(struct ice_ring *rx_ring, struct
> > sk_buff *skb, u16 vlan_tag)
> >   * @size: packet data size
> >   * @xdp_ring: XDP ring for transmission
> >   */
> > -int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring
> > *xdp_ring)
> > +int ice_xmit_xdp_ring(void *data, u16 size, struct ice_tx_ring
> > *xdp_ring)
> >  {
> >       u16 i = xdp_ring->next_to_use;
> >       struct ice_tx_desc *tx_desc;
> > @@ -269,7 +269,7 @@ int ice_xmit_xdp_ring(void *data, u16 size,
> > struct ice_ring *xdp_ring)
> >   *
> >   * Returns negative on failure, 0 on success.
> >   */
> > -int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_ring
> > *xdp_ring)
> > +int ice_xmit_xdp_buff(struct xdp_buff *xdp, struct ice_tx_ring
> > *xdp_ring)
> >  {
> >       struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
> >
> > @@ -294,7 +294,7 @@ void ice_finalize_xdp_rx(struct ice_ring
> > *rx_ring, unsigned int xdp_res)
> >               xdp_do_flush_map();
> >
> >       if (xdp_res & ICE_XDP_TX) {
> > -             struct ice_ring *xdp_ring =
> > +             struct ice_tx_ring *xdp_ring =
> >                       rx_ring->vsi->xdp_rings[rx_ring->q_index];
> 
> Probably me not understanding XDP, but this looks a little strange.

Very strange, but later patches change the ice_finalize_xdp_rx() to get
xdp_ring directly as an input so there won't be a need for this weird
digging anymore. So this part will look like:

	if (xdp_res & ICE_XDP_TX)
		ice_xdp_ring_update_tail(xdp_ring);

> 
> >
> >               ice_xdp_ring_update_tail(xdp_ring);

[...]
