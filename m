Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8B3EDD5F
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhHPSys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:54:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:40800 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhHPSys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 14:54:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203074599"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="203074599"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 11:54:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="423658813"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 16 Aug 2021 11:54:12 -0700
Date:   Mon, 16 Aug 2021 20:39:33 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Creeley, Brett" <brett.creeley@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "joamaki@gmail.com" <joamaki@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>
Subject: Re: [PATCH v5 intel-next 2/9] ice: move ice_container_type onto
 ice_ring_container
Message-ID: <20210816183933.GA1521@ranger.igk.intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
 <20210814140812.46632-3-maciej.fijalkowski@intel.com>
 <CO1PR11MB4835F0FDF2ABA2578B722095F5FD9@CO1PR11MB4835.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4835F0FDF2ABA2578B722095F5FD9@CO1PR11MB4835.namprd11.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 05:51:06PM +0100, Creeley, Brett wrote:
> > -----Original Message-----
> > From: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Sent: Saturday, August 14, 2021 7:08 AM
> > To: intel-wired-lan@lists.osuosl.org
> > Cc: netdev@vger.kernel.org; bpf@vger.kernel.org; davem@davemloft.net; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> > kuba@kernel.org; bjorn@kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Lobakin, Alexandr <alexandr.lobakin@intel.com>; joamaki@gmail.com; toke@redhat.com; Creeley,
> > Brett <brett.creeley@intel.com>; Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> > Subject: [PATCH v5 intel-next 2/9] ice: move ice_container_type onto ice_ring_container
> >
> > Currently ice_container_type is scoped only for ice_ethtool.c. Next
> > commit that will split the ice_ring struct onto Rx/Tx specific ring
> > structs is going to also modify the type of linked list of rings that is
> > within ice_ring_container. Therefore, the functions that are taking the
> > ice_ring_container as an input argument will need to be aware of a ring
> > type that will be looked up.
> >
> > Embed ice_container_type within ice_ring_container and initialize it
> > properly when allocating the q_vectors.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_base.c    |  2 ++
> >  drivers/net/ethernet/intel/ice/ice_ethtool.c | 36 ++++++++------------
> >  drivers/net/ethernet/intel/ice/ice_txrx.h    |  6 ++++
> >  3 files changed, 23 insertions(+), 21 deletions(-)
> 
> <snip>
> 
> > +enum ice_container_type {
> > +     ICE_RX_CONTAINER,
> > +     ICE_TX_CONTAINER,
> > +};
> > +
> >  struct ice_ring_container {
> >       /* head of linked-list of rings */
> >       struct ice_ring *ring;
> > @@ -347,6 +352,7 @@ struct ice_ring_container {
> >       u16 itr_setting:13;
> >       u16 itr_reserved:2;
> >       u16 itr_mode:1;
> > +     enum ice_container_type type;
> 
> It may not matter, but should you make sure
> the size of "type" doesn't negativelly affect this
> structure?

Seems that it doesn't matter.

Before:
struct ice_ring_container {
        struct ice_ring *          ring;                 /*     0     8 */
        struct dim                 dim;                  /*     8   120 */

        /* XXX last struct has 2 bytes of padding */

        /* --- cacheline 2 boundary (128 bytes) --- */
        u16                        itr_idx;              /*   128     2 */
        u16                        itr_setting:13;       /*   130: 0  2 */
        u16                        itr_reserved:2;       /*   130:13  2 */
        u16                        itr_mode:1;           /*   130:15  2 */

        /* size: 136, cachelines: 3, members: 6 */
        /* padding: 4 */
        /* paddings: 1, sum paddings: 2 */
        /* last cacheline: 8 bytes */


After:
struct ice_ring_container {
        union {
                struct ice_rx_ring * rx_ring;            /*     0     8 */
                struct ice_tx_ring * tx_ring;            /*     0     8 */
        };                                               /*     0     8 */
        struct dim                 dim;                  /*     8   120 */

        /* XXX last struct has 2 bytes of padding */

        /* --- cacheline 2 boundary (128 bytes) --- */
        u16                        itr_idx;              /*   128     2 */
        u16                        itr_setting:13;       /*   130: 0  2 */
        u16                        itr_reserved:2;       /*   130:13  2 */
        u16                        itr_mode:1;           /*   130:15  2 */
        enum ice_container_type    type;                 /*   132     4 */

        /* size: 136, cachelines: 3, members: 7 */
        /* paddings: 1, sum paddings: 2 */
        /* last cacheline: 8 bytes */

Still 3 cachelines and same sizes.


> 
> >  };
> >
> >  struct ice_coalesce_stored {
> > --
> > 2.20.1
> 
