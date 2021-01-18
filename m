Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF71C2FA422
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405575AbhARPHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:07:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:22113 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405394AbhARPGq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:06:46 -0500
IronPort-SDR: XOmiFqWZ3Ggfh+sPXzHS4GKPPI8ojXOz97jXofcJWuw2Ij5WlsXkkST1u9jvczcO5ojw8qvnfH
 a97TorIVYXOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="178900874"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="178900874"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:05:48 -0800
IronPort-SDR: 9/ySQoyKlhXlCh12UwUlnaoj3wQ/zMzk5aPrISj82IJE6UEnOp+vd3dfpB0+by0joauKbgArGt
 rpF2dXDSaoYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="383600439"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 18 Jan 2021 07:05:44 -0800
Date:   Mon, 18 Jan 2021 15:56:35 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Brouer <brouer@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20210118145635.GA11335@ranger.igk.intel.com>
References: <cover.1608670965.git.lorenzo@kernel.org>
 <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
 <63bcde67-4124-121d-e96a-066493542ca9@iogearbox.net>
 <CAJ0CqmVsr=cv+0ndg3g4RDqVmKt=X6qQ7sbArNVrB+98e_3Sag@mail.gmail.com>
 <b76a6fc5-55fa-1ca8-f2b9-ae0332450333@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b76a6fc5-55fa-1ca8-f2b9-ae0332450333@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 12:16:41AM +0100, Daniel Borkmann wrote:
> On 12/29/20 7:09 PM, Lorenzo Bianconi wrote:
> > > > +                     hard_start = page_address(rx_buffer->page) +
> > > > +                                  rx_buffer->page_offset - offset;
> > > > +                     xdp_prepare_buff(&xdp, hard_start, offset, size, true);
> > > >    #if (PAGE_SIZE > 4096)
> > > >                        /* At larger PAGE_SIZE, frame_sz depend on len size */
> > > >                        xdp.frame_sz = ixgbevf_rx_frame_truesize(rx_ring, size);
> > 
> > Hi Daniel,
> > 
> > thx for the review.
> > 
> > > [...]
> > > The design is very similar for most of the Intel drivers. Why the inconsistency on
> > > ice driver compared to the rest, what's the rationale there to do it in one but not
> > > the others? Generated code better there?
> > 
> > I applied the same logic for the ice driver but the code is just
> > slightly different.
> > 
> > > Couldn't you even move the 'unsigned int offset = xyz_rx_offset(rx_ring)' out of the
> > > while loop altogether for all of them? (You already use the xyz_rx_offset() implicitly
> > > for most of them when setting xdp.frame_sz.)
> > 
> > We discussed moving "offset = xyz_rx_offset(rx_ring)" out of the while
> > loop before but Saeed asked to address it in a dedicated series since
> > it is a little bit out of the scope. I have no strong opinion on it,
> > do you prefer to address it directly here?
> 
> Fair enough, I might have preferred it in this series as part of the overall cleanup,
> but if you plan to follow up on this then this is also fine by me. Applied the v5 to
> bpf-next in that case, thanks!

I initially pointed out the fact that we could store the output of
xyz_rx_offset(rx_ring) onto a variable rather than call it per each
processed buffer because value returned by that func can not change
throughout the napi execution. It is based on ethtool priv flag which if
changed, resets the PF (so disables napi, frees irqs, loads different Rx
mem model, etc).

I realised that there is yet another place where we have unnecessary call
to xyz_rx_offset() in hot path which is xyz_alloc_mapped_page(), so I
expanded the idea of this optimization and I store the offset directly
onto Rx ring and refer to that value.

I am including the patches that do what described above onto pending
series of fixes that I had back in december '20 I suppose.
