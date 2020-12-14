Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E097B2D9944
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403852AbgLNNxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:53:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728446AbgLNNxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:53:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607953901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDkRp2qRbnWF9+i4J4sLPRtdAIpeZ2Kke3VeR7rVDKs=;
        b=KIuzslZeApKtLF1kRBQ82R+qeV8HbWmZzfUuiqXqo4bK0Lsc2fbSQq6mz9vuYCxJfXshE4
        BC8IgC0CTr+Czm+aoNSnpvDJgn6haez08HP+aql2xs9nRVlt9esXABAtYqgAZTtXHg6iuf
        u6QdSTSXTzPKkvHzIN8wwTiABTUi8PQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-f7zaRQw5O2mmf5s0jEr_KQ-1; Mon, 14 Dec 2020 08:51:39 -0500
X-MC-Unique: f7zaRQw5O2mmf5s0jEr_KQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 905278144E9;
        Mon, 14 Dec 2020 13:51:37 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4B2E1007606;
        Mon, 14 Dec 2020 13:51:29 +0000 (UTC)
Date:   Mon, 14 Dec 2020 14:51:28 +0100
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
Subject: Re: [PATCH bpf-next V8 4/8] bpf: add BPF-helper for MTU checking
Message-ID: <20201214145128.0046316c@carbon>
In-Reply-To: <e5d7ade3-6648-5934-ede1-956e379834a2@iogearbox.net>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
        <160650039783.2890576.1174164236647947165.stgit@firesoul>
        <e5d7ade3-6648-5934-ede1-956e379834a2@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Dec 2020 00:23:14 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 11/27/20 7:06 PM, Jesper Dangaard Brouer wrote:
> [...]
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
> > +	int len;
> > +	int mtu;
> > +
> > +	if (flags & ~(BPF_MTU_CHK_SEGS))  
> 
> nit: unlikely() (similar for XDP case)

ok

> > +		return -EINVAL;
> > +
> > +	dev = __dev_via_ifindex(dev, ifindex);
> > +	if (!dev)  
> 
> nit: unlikely() (ditto XDP)

ok

> > +		return -ENODEV;
> > +
> > +	mtu = READ_ONCE(dev->mtu);
> > +
> > +	/* TC len is L2, remove L2-header as dev MTU is L3 size */
> > +	len = skb->len - ETH_HLEN;  
> 
> s/ETH_HLEN/dev->hard_header_len/ ?

ok
 
> > +	len += len_diff; /* len_diff can be negative, minus result pass check */
> > +	if (len <= mtu) {
> > +		ret = BPF_MTU_CHK_RET_SUCCESS;  
> 
> Wouldn't it be more intuitive to do ...
> 
>     len_dev = READ_ONCE(dev->mtu) + dev->hard_header_len + VLAN_HLEN;
>     len_skb = skb->len + len_diff;
>     if (len_skb <= len_dev) {
>        ret = BPF_MTU_CHK_RET_SUCCESS;
>        got out;
>     }

Yes, that is more intuitive to read.


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
> > +		if (flags & BPF_MTU_CHK_SEGS &&
> > +		    skb_gso_validate_network_len(skb, mtu)) {
> > +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> > +			goto out;  
> 
> Maybe my lack of coffe, but looking at ip_exceeds_mtu() for example, shouldn't
> the above test be on !skb_gso_validate_network_len() instead?

Yes, you are right!

> skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu) would indicate that
> it does /not/ exceed mtu.
> 
> > +		}
> > +
> > +		len = skb_headlen(skb) - ETH_HLEN + len_diff;  
> 
> How does this work with GRO when we invoke this helper at tc ingress, e.g. when
> there is still non-linear data in skb_shinfo(skb)->frags[]?

In case of skb_is_gso() then this code will check the linear part
skb_headlen(skb) against the MTU.  I though this was an improvement
from what we have today, where skb_is_gso() packets will skip all
checks, which have caused a lot of confusion by end-users.

I will put this under the BPF_MTU_CHK_SEGS flag (in V9) as I understand
from you comment, you don't think this is correct at tc ingress.

> > +		if (len > mtu) {
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
[...]

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

