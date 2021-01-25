Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B595304B08
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbhAZEvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:51:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36530 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726551AbhAYJZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611566668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QDsYKYdE9xnD8PZO2/oXTlbgUjCrmpaZCS6Ef2BKYBQ=;
        b=JZfX+YSWSGyH2eays9Ag11hkyy7/zqDeydZ4xVxWGVfDMKKzc+Vap6v2DVnYbRe7/pkHk9
        EsGXsYV5IpzBWcCNWZC3Wpy0/zo0Em7yghRNWo33xSzfm8bKrV9D5iH92FJRpdPiMx9GpK
        0EW21VtxP8uP5XLOIptUz6NTNLiSIe8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-yLYxnAOfN3av0bSrpVTM1w-1; Mon, 25 Jan 2021 03:41:59 -0500
X-MC-Unique: yLYxnAOfN3av0bSrpVTM1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C7A18018A7;
        Mon, 25 Jan 2021 08:41:57 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FF5F7216D;
        Mon, 25 Jan 2021 08:41:49 +0000 (UTC)
Date:   Mon, 25 Jan 2021 09:41:48 +0100
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
Subject: Re: [PATCH bpf-next V12 4/7] bpf: add BPF-helper for MTU checking
Message-ID: <20210125094148.2b3bb128@carbon>
In-Reply-To: <6772a12b-2a60-bb3b-93df-1d6d6c7c7fd7@iogearbox.net>
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
        <161098887018.108067.13643446976934084937.stgit@firesoul>
        <6772a12b-2a60-bb3b-93df-1d6d6c7c7fd7@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 02:35:41 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

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
> [...]
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
> > +	 * must choose if segs are to be MTU checked.
> > +	 */
> > +	if (skb_is_gso(skb)) {
> > +		ret = BPF_MTU_CHK_RET_SUCCESS;
> > +
> > +		if (flags & BPF_MTU_CHK_SEGS &&
> > +		    !skb_gso_validate_network_len(skb, mtu))
> > +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;  
> 
> I think that looks okay overall now. One thing that will easily slip through
> is that in the helper description you mentioned 'Check cannot use len_diff.'
> for BPF_MTU_CHK_SEGS flag. So right now for non-zero len_diff the user
> will still get BPF_MTU_CHK_RET_SUCCESS if the current length check via
> skb_gso_validate_network_len(skb, mtu) passes. If it cannot be checked,
> maybe enforce len_diff == 0 for gso skbs on BPF_MTU_CHK_SEGS?

Ok. Do you want/think this can be enforced by the verifier or are you
simply requesting that the helper will return -EINVAL (or another errno)?

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

