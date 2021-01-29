Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A865430869C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 08:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhA2Hi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 02:38:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232353AbhA2Hin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 02:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611905827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAijsio6LbsJva5/TMSZkoK53YmgFNTwzEUYKYO8Dbk=;
        b=QOB28UqNCmSJE0hnf3vryuhf6QJ/nIxZeUHPLEjLg8Fk6BEL58lxoNUyv3R9f0kRBY/Zg6
        K5oDwplnnGroi1nlVRx+zP+iNpfscM52lqMbd24+K0wePIq6kyO5xXrjNuG7c5p2YATalN
        XLws7BNZwtxbfT+1t3A8GuEU7dcd+i4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-yLuTMOj2P56dkQhs-qbLCQ-1; Fri, 29 Jan 2021 02:37:05 -0500
X-MC-Unique: yLuTMOj2P56dkQhs-qbLCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DAD31015C92;
        Fri, 29 Jan 2021 07:37:03 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D1107095C;
        Fri, 29 Jan 2021 07:36:56 +0000 (UTC)
Date:   Fri, 29 Jan 2021 08:36:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V13 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210129083654.14f343fa@carbon>
In-Reply-To: <6013b06b83ae2_2683c2085d@john-XPS-13-9370.notmuch>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
        <161159457239.321749.9067604476261493815.stgit@firesoul>
        <6013b06b83ae2_2683c2085d@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 22:51:23 -0800
John Fastabend <john.fastabend@gmail.com> wrote:

> Jesper Dangaard Brouer wrote:
> > This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.
> > 
> > The SKB object is complex and the skb->len value (accessible from
> > BPF-prog) also include the length of any extra GRO/GSO segments, but
> > without taking into account that these GRO/GSO segments get added
> > transport (L4) and network (L3) headers before being transmitted. Thus,
> > this BPF-helper is created such that the BPF-programmer don't need to
> > handle these details in the BPF-prog.
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

The nitpick below about len adjust can become negative, is on purpose
and why is described in above.

> > 
> > V13:
> >  - Enforce flag BPF_MTU_CHK_SEGS cannot use len_diff.
> > 
> > V12:
> >  - Simplify segment check that calls skb_gso_validate_network_len.
> >  - Helpers should return long
> > 
> > V9:
> > - Use dev->hard_header_len (instead of ETH_HLEN)
> > - Annotate with unlikely req from Daniel
> > - Fix logic error using skb_gso_validate_network_len from Daniel
> > 
> > V6:
> > - Took John's advice and dropped BPF_MTU_CHK_RELAX
> > - Returned MTU is kept at L3-level (like fib_lookup)
> > 
> > V4: Lot of changes
> >  - ifindex 0 now use current netdev for MTU lookup
> >  - rename helper from bpf_mtu_check to bpf_check_mtu
> >  - fix bug for GSO pkt length (as skb->len is total len)
> >  - remove __bpf_len_adj_positive, simply allow negative len adj

Notice V4 comment about "allow negative len adj"

> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  include/uapi/linux/bpf.h       |   67 ++++++++++++++++++++++++
> >  net/core/filter.c              |  114 ++++++++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h |   67 ++++++++++++++++++++++++
> >  3 files changed, 248 insertions(+)
> > 
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 05bfc8c843dc..f17381a337ec 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3839,6 +3839,61 @@ union bpf_attr {  
> 
> [...]
> 
> > +
> > +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> > +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)  
> 
> Maybe worth mentioning in description we expect len_diff < skb->len,
> at least I expect that otherwise result may be undefined.
> 
> > +{
> > +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +	struct net_device *dev = skb->dev;
> > +	int skb_len, dev_len;
> > +	int mtu;  
> 
> Perhaps getting a bit nit-picky here but shouldn't skb_len, dev_len
> and mtu all be 'unsigned int'
> 
> Then all the types will align. I guess MTUs are small so it
> doesn't really matter, but is easier to read IMO.

We need signed types, this is a deliberate choice made based on
discussion in V4.

> > +
> > +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
> > +		return -EINVAL;
> > +
> > +	if (unlikely(flags & BPF_MTU_CHK_SEGS && len_diff))
> > +		return -EINVAL;
> > +
> > +	dev = __dev_via_ifindex(dev, ifindex);
> > +	if (unlikely(!dev))
> > +		return -ENODEV;
> > +
> > +	mtu = READ_ONCE(dev->mtu);
> > +
> > +	dev_len = mtu + dev->hard_header_len;
> > +	skb_len = skb->len + len_diff; /* minus result pass check */
> > +	if (skb_len <= dev_len) {  
> 
> If skb_len is unsigned it will be >> dev_len when skb->len < len_diff. I
> think its a good idea to throw an error if skb_len calculation goes
> negative?

No, as comment says /* minus result pass check */.
And explained in patch desc.

> > +		ret = BPF_MTU_CHK_RET_SUCCESS;
> > +		goto out;
> > +	}
> > +	/* At this point, skb->len exceed MTU, but as it include length of all
> > +	 * segments, it can still be below MTU.  The SKB can possibly get
> > +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> > +	 * must choose if segs are to be MTU checked.
> > +	 */
> > +	if (skb_is_gso(skb)) {
> > +		ret = BPF_MTU_CHK_RET_SUCCESS;
> > +
> > +		if (flags & BPF_MTU_CHK_SEGS &&
> > +		    !skb_gso_validate_network_len(skb, mtu))
> > +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> > +	}
> > +out:
> > +	/* BPF verifier guarantees valid pointer */
> > +	*mtu_len = mtu;
> > +
> > +	return ret;
> > +}
> > +
> > +BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
> > +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> > +{
> > +	struct net_device *dev = xdp->rxq->dev;
> > +	int xdp_len = xdp->data_end - xdp->data;
> > +	int ret = BPF_MTU_CHK_RET_SUCCESS;
> > +	int mtu, dev_len;  
> 
> Same comment about types.
> 
> > +
> > +	/* XDP variant doesn't support multi-buffer segment check (yet) */
> > +	if (unlikely(flags))
> > +		return -EINVAL;
> > +
> > +	dev = __dev_via_ifindex(dev, ifindex);
> > +	if (unlikely(!dev))
> > +		return -ENODEV;
> > +
> > +	mtu = READ_ONCE(dev->mtu);
> > +
> > +	/* Add L2-header as dev MTU is L3 size */
> > +	dev_len = mtu + dev->hard_header_len;
> > +
> > +	xdp_len += len_diff; /* minus result pass check */
> > +	if (xdp_len > dev_len)
> > +		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +
> > +	/* BPF verifier guarantees valid pointer */
> > +	*mtu_len = mtu;
> > +
> > +	return ret;
> > +}  
> 
> Otherwise LGTM.

Thanks

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

