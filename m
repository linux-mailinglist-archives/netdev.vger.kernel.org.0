Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1DE2F6346
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbhANOhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:37:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726777AbhANOhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:37:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610634981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FE5+f6cKkd00QYi2i3LRJH0dlGpTZMo6S+koI2GJz0k=;
        b=brIX0e7EL/XGhpXiy60N0oltcQIIC1KkVhScM6yCtkRvgCFQ5BMsKrUJ+69eDOxqZEbDOS
        mZMBmNq5BWfhANgibpfo+Er95vxtBH5GcWKk1XXR1WdEUvqxAqZ2lQwSJslpJxkPFV37yU
        UPawsaAyYptgNRcQY2lX7Sb4GT2ZElA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-_Dz3gVpOPR6iZxyk-vW8Ug-1; Thu, 14 Jan 2021 09:36:17 -0500
X-MC-Unique: _Dz3gVpOPR6iZxyk-vW8Ug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFDB8102CB9B;
        Thu, 14 Jan 2021 14:36:14 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97A4510016FB;
        Thu, 14 Jan 2021 14:36:08 +0000 (UTC)
Date:   Thu, 14 Jan 2021 15:36:07 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V11 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210114153607.6eea9b37@carbon>
In-Reply-To: <a14a7490-88c6-9d14-0886-547113242c45@iogearbox.net>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
        <161047352084.4003084.16468571234023057969.stgit@firesoul>
        <a14a7490-88c6-9d14-0886-547113242c45@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 00:07:14 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 1/12/21 6:45 PM, Jesper Dangaard Brouer wrote:
> > This BPF-helper bpf_check_mtu() works for both XDP and TC-BPF programs.  
> [...]
> > + * int bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
> > + *	Description
> > + *		Check ctx packet size against MTU of net device (based on
> > + *		*ifindex*).  This helper will likely be used in combination with
> > + *		helpers that adjust/change the packet size.  The argument
> > + *		*len_diff* can be used for querying with a planned size
> > + *		change. This allows to check MTU prior to changing packet ctx.
> > + *
> > + *		Specifying *ifindex* zero means the MTU check is performed
> > + *		against the current net device.  This is practical if this isn't
> > + *		used prior to redirect.
> > + *
> > + *		The Linux kernel route table can configure MTUs on a more
> > + *		specific per route level, which is not provided by this helper.
> > + *		For route level MTU checks use the **bpf_fib_lookup**\ ()
> > + *		helper.
> > + *
> > + *		*ctx* is either **struct xdp_md** for XDP programs or
> > + *		**struct sk_buff** for tc cls_act programs.
> > + *
> > + *		The *flags* argument can be a combination of one or more of the
> > + *		following values:
> > + *
> > + *		**BPF_MTU_CHK_SEGS**
> > + *			This flag will only works for *ctx* **struct sk_buff**.
> > + *			If packet context contains extra packet segment buffers
> > + *			(often knows as GSO skb), then MTU check is harder to
> > + *			check at this point, because in transmit path it is
> > + *			possible for the skb packet to get re-segmented
> > + *			(depending on net device features).  This could still be
> > + *			a MTU violation, so this flag enables performing MTU
> > + *			check against segments, with a different violation
> > + *			return code to tell it apart. Check cannot use len_diff.
> > + *
> > + *		On return *mtu_len* pointer contains the MTU value of the net
> > + *		device.  Remember the net device configured MTU is the L3 size,
> > + *		which is returned here and XDP and TX length operate at L2.
> > + *		Helper take this into account for you, but remember when using
> > + *		MTU value in your BPF-code.  On input *mtu_len* must be a valid
> > + *		pointer and be initialized (to zero), else verifier will reject
> > + *		BPF program.
> > + *
> > + *	Return
> > + *		* 0 on success, and populate MTU value in *mtu_len* pointer.
> > + *
> > + *		* < 0 if any input argument is invalid (*mtu_len* not updated)
> > + *
> > + *		MTU violations return positive values, but also populate MTU
> > + *		value in *mtu_len* pointer, as this can be needed for
> > + *		implementing PMTU handing:
> > + *
> > + *		* **BPF_MTU_CHK_RET_FRAG_NEEDED**
> > + *		* **BPF_MTU_CHK_RET_SEGS_TOOBIG**
> > + *
> >    */
> >   #define __BPF_FUNC_MAPPER(FN)		\
> >   	FN(unspec),			\
> > @@ -3998,6 +4053,7 @@ union bpf_attr {
> >   	FN(ktime_get_coarse_ns),	\
> >   	FN(ima_inode_hash),		\
> >   	FN(sock_from_file),		\
> > +	FN(check_mtu),			\
> >   	/* */
> >   
> >   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > @@ -5030,6 +5086,17 @@ struct bpf_redir_neigh {
> >   	};
> >   };
> >   
> > +/* bpf_check_mtu flags*/
> > +enum  bpf_check_mtu_flags {
> > +	BPF_MTU_CHK_SEGS  = (1U << 0),
> > +};
> > +
> > +enum bpf_check_mtu_ret {
> > +	BPF_MTU_CHK_RET_SUCCESS,      /* check and lookup successful */
> > +	BPF_MTU_CHK_RET_FRAG_NEEDED,  /* fragmentation required to fwd */
> > +	BPF_MTU_CHK_RET_SEGS_TOOBIG,  /* GSO re-segmentation needed to fwd */
> > +};
> > +
> >   enum bpf_task_fd_type {
> >   	BPF_FD_TYPE_RAW_TRACEPOINT,	/* tp name */
> >   	BPF_FD_TYPE_TRACEPOINT,		/* tp name */
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index db59ab55572c..3f2e593244ca 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5604,6 +5604,124 @@ static const struct bpf_func_proto bpf_skb_fib_lookup_proto = {
> >   	.arg4_type	= ARG_ANYTHING,
> >   };
> >   
> > +static struct net_device *__dev_via_ifindex(struct net_device *dev_curr,
> > +					    u32 ifindex)
> > +{
> > +	struct net *netns = dev_net(dev_curr);
> > +
> > +	/* Non-redirect use-cases can use ifindex=0 and save ifindex lookup */
> > +	if (ifindex == 0)
> > +		return dev_curr;
> > +
> > +	return dev_get_by_index_rcu(netns, ifindex);
> > +}
> > +
> > +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> > +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> > +{
> > +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +	struct net_device *dev = skb->dev;
> > +	int skb_len, dev_len;
> > +	int mtu;
> > +
> > +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
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
> > +		ret = BPF_MTU_CHK_RET_SUCCESS;
> > +		goto out;
> > +	}
> > +	/* At this point, skb->len exceed MTU, but as it include length of all
> > +	 * segments, it can still be below MTU.  The SKB can possibly get
> > +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> > +	 * must choose if segs are to be MTU checked.  Last SKB "headlen" is
> > +	 * checked against MTU.
> > +	 */
> > +	if (skb_is_gso(skb)) {
> > +		ret = BPF_MTU_CHK_RET_SUCCESS;
> > +
> > +		if (!(flags & BPF_MTU_CHK_SEGS))
> > +			goto out;
> > +
> > +		if (!skb_gso_validate_network_len(skb, mtu)) {
> > +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> > +			goto out;
> > +		}
> > +
> > +		skb_len = skb_headlen(skb) + len_diff;
> > +		if (skb_len > dev_len) {

Maybe I'm misunderstanding you below?  Do you just want the above two
lines moved from the patch? (sure I can do that... as it is just an
extra check of the "head"/first segment of the packet, and only done if
BPF_MTU_CHK_SEGS is set)

> 
> This is still not universally correct given drivers could cook up non-linear
> skbs (e.g. page frags) on rx. So the result from BPF_MTU_CHK_SEGS flag cannot
> be relied on. 

That is why it is a flag, that need to be explicitly set.

> Do you have a particular use case for the BPF_MTU_CHK_SEGS?

The complaint from Maze (and others) were that when skb_is_gso then all
the MTU checks are bypassed.  This flag enables checking the GSO part
via skb_gso_validate_network_len().  We cannot enable it per default,
as you say, it is universally correct in all cases.

> I also don't see the flag being used anywhere in your selftests, so I presume
> not as otherwise you would have added an example there?

I'm using the flag in the bpf-examples code[1], this is how I've tested
the code path.

I've not found a way to generate GSO packet via the selftests
infrastructure via bpf_prog_test_run_xattr().  I'm 

[1] https://github.com/xdp-project/bpf-examples/blob/master/MTU-tests/tc_mtu_enforce.c


> I would just drop the flag altogether for the tc helper..

As explain I cannot drop the flag altogether, I would also have to
remove the code then.  Sorry, but I don't 100% understand the change
you are requesting.


> > +			ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> > +			goto out;
> > +		}
> > +	}
> > +out:
> > +	/* BPF verifier guarantees valid pointer */
> > +	*mtu_len = mtu;
> > +
> > +	return ret;
> > +}  
> 



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

