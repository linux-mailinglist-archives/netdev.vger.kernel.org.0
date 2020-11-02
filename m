Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEF22A28DA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKBLQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:16:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728288AbgKBLQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:16:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604315762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RMlHTzqu9dwMlTgXD4m+TiGPhehrYvoCAtcJOkl1hus=;
        b=T2gUZg/500FXcWWlw95azZqxqBHB8l5pU5CQv3VlHObkuwtAY5u4k0VFUuyztlTVEpTWZc
        My1biGLgQuPt5RMZKKppzfol/lMnGtRMoH68b9dA6V+yN8a29NgnZarEDcR/7PBSDVXz6c
        03Fdh+YScD2BM5iJIWBrFTM433RP/90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-D3Sx_8bCOauk1d-s7caCLA-1; Mon, 02 Nov 2020 06:15:59 -0500
X-MC-Unique: D3Sx_8bCOauk1d-s7caCLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1972210866C3;
        Mon,  2 Nov 2020 11:15:57 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7915C629;
        Mon,  2 Nov 2020 11:15:49 +0000 (UTC)
Date:   Mon, 2 Nov 2020 12:15:48 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next V5 3/5] bpf: add BPF-helper for MTU checking
Message-ID: <20201102121548.5e2c36b1@carbon>
In-Reply-To: <5f9c764fc98c6_16d4208d5@john-XPS-13-9370.notmuch>
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
        <160407666238.1525159.9197344855524540198.stgit@firesoul>
        <5f9c764fc98c6_16d4208d5@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:23:43 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> > 
> > The API is designed to help the BPF-programmer, that want to do packet
> > context size changes, which involves other helpers. These other helpers
> > usually does a delta size adjustment. This helper also support a delta
> > size (len_diff), which allow BPF-programmer to reuse arguments needed by
> > these other helpers, and perform the MTU check prior to doing any actual
> > size adjustment of the packet context.
> > 
> > It is on purpose, that we allow the len adjustment to become a negative
> > result, that will pass the MTU check. This might seem weird, but it's not
> > this helpers responsibility to "catch" wrong len_diff adjustments. Other
> > helpers will take care of these checks, if BPF-programmer chooses to do
> > actual size adjustment.
> > 
> > V4: Lot of changes
> >  - ifindex 0 now use current netdev for MTU lookup
> >  - rename helper from bpf_mtu_check to bpf_check_mtu
> >  - fix bug for GSO pkt length (as skb->len is total len)
> >  - remove __bpf_len_adj_positive, simply allow negative len adj
> > 
> > V3: Take L2/ETH_HLEN header size into account and document it.
> > 
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---  
> 
> Sorry for the late feedback here.
> 
> This seems like a lot of baked in functionality into the helper? Can you
> say something about why the simpler and, at least to me, more intuitive
> helper to simply return the ifindex mtu is not ideal?

I tried to explain this in the patch description.  This is for easier
collaboration with other helpers, that also have the len_diff parameter.
This API allow to check the MTU *prior* to doing the size adjustment.

Let me explain what is not in the patch desc:

In the first patchset, I started with the simply implementation of
returning the MTU.  Then I realized that this puts more work into the
BPF program (thus increasing BPF code instructions).  As we in BPF-prog
need to extract the packet length to compare against the returned MTU
size. Looking at other programs that does the ctx/packet size adjust, we
don't extract the packet length as ctx is about to change, and we don't
need the MTU variable in the BPF prog (unless it fails).


> Rough pseudo code being,
> 
>  my_sender(struct __sk_buff *skb, int fwd_ifindex)
>  {
>    mtu = bpf_get_ifindex_mtu(fwd_ifindex, 0);
>    if (skb->len + HDR_SIZE < mtu)
>        return send_with_hdrs(skb);
>    return -EMSGSIZE
>  }
> 
> 
> >  include/uapi/linux/bpf.h       |   70 +++++++++++++++++++++++
> >  net/core/filter.c              |  120 ++++++++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |   70 +++++++++++++++++++++++
> >  3 files changed, 260 insertions(+)
> >   
> 
> [...]
> 
> > + *              **BPF_MTU_CHK_RELAX**
> > + *			This flag relax or increase the MTU with room for one
> > + *			VLAN header (4 bytes). This relaxation is also used by
> > + *			the kernels own forwarding MTU checks.  
> 
> I noted below as well, but not sure why this is needed. Seems if user
> knows to add a flag because they want a vlan header we can just as
> easily expect BPF program to do it. Also it only works for VLAN headers
> any other header data wont be accounted for so it seems only useful
> in one specific case.

This was added because the kernels own forwarding have this relaxation
build in.  Thus, I though that I should add flag to compatible with the
kernels forwarding checks.

> > + *
> > + *		**BPF_MTU_CHK_SEGS**
> > + *			This flag will only works for *ctx* **struct sk_buff**.
> > + *			If packet context contains extra packet segment buffers
> > + *			(often knows as GSO skb), then MTU check is partly
> > + *			skipped, because in transmit path it is possible for the
> > + *			skb packet to get re-segmented (depending on net device
> > + *			features).  This could still be a MTU violation, so this
> > + *			flag enables performing MTU check against segments, with
> > + *			a different violation return code to tell it apart.
> > + *
> > + *		The *mtu_result* pointer contains the MTU value of the net
> > + *		device including the L2 header size (usually 14 bytes Ethernet
> > + *		header). The net device configured MTU is the L3 size, but as
> > + *		XDP and TX length operate at L2 this helper include L2 header
> > + *		size in reported MTU.
> > + *
> > + *	Return
> > + *		* 0 on success, and populate MTU value in *mtu_result* pointer.
> > + *
> > + *		* < 0 if any input argument is invalid (*mtu_result* not updated)
> > + *
> > + *		MTU violations return positive values, but also populate MTU
> > + *		value in *mtu_result* pointer, as this can be needed for
> > + *		implementing PMTU handing:
> > + *
> > + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> > + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> > + *
> >   */  
> 
> [...]
> 
> > +static int __bpf_lookup_mtu(struct net_device *dev_curr, u32 ifindex, u64 flags)
> > +{
> > +	struct net *netns = dev_net(dev_curr);
> > +	struct net_device *dev;
> > +	int mtu;
> > +
> > +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> > +	if (ifindex == 0)
> > +		dev = dev_curr;
> > +	else
> > +		dev = dev_get_by_index_rcu(netns, ifindex);
> > +
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	/* XDP+TC len is L2: Add L2-header as dev MTU is L3 size */
> > +	mtu = dev->mtu + dev->hard_header_len;  
> 
> READ_ONCE() on dev->mtu and hard_header_len as well? We don't have
> any locks.

This is based on similar checks done in the same execution context,
which don't have these READ_ONCE() macros.  I'm not introducing reading
these, I'm simply moving when they are read.  If this is really needed,
then I think we need separate fixes patches, for stable backporting.

While doing this work, I've realized that mtu + hard_header_len is
located on two different cache-lines, which is unfortunate, but I will
look at fixing this in followup patches.


> > +
> > +	/*  Same relax as xdp_ok_fwd_dev() and is_skb_forwardable() */
> > +	if (flags & BPF_MTU_CHK_RELAX)
> > +		mtu += VLAN_HLEN;  
> 
> I'm trying to think about the use case where this might be used?
> Compared to just adjusting MTU in BPF program side as needed for
> packet encapsulation/headers/etc.

As I wrote above, this were added because the kernels own forwarding
have this relaxation in it's checks (in is_skb_forwardable()).  I even
tried to dig through the history, introduced in [1] and copy-pasted
in[2].  And this seems to be a workaround, that have become standard,
that still have practical implications.

My practical experiments showed, that e.g. ixgbe driver with MTU=1500
(L3-size) will allow and fully send packets with 1504 (L3-size). But
i40e will not, and drops the packet in hardware/firmware step.  So,
what is the correct action, strict or relaxed?

My own conclusion is that we should inverse the flag.  Meaning to
default add this VLAN_HLEN (4 bytes) relaxation, and have a flag to do
more strict check,  e.g. BPF_MTU_CHK_STRICT. As for historical reasons
we must act like kernels version of MTU check. Unless you object, I will
do this in V6.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[1] https://git.kernel.org/torvalds/c/57f89bfa2140 ("network: Allow af_packet to transmit +4 bytes for VLAN packets.") (Author: Ben Greear)
 
[2] https://git.kernel.org/torvalds/c/79b569f0ec53 ("netdev: fix mtu check when TSO is enabled") (Author: Daniel Lezcano)

