Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0274C2F9D91
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389917AbhARLGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:06:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389667AbhARLGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:06:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610967912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A41TTu6Um6DV/d7sLWeoM78YuWc5giE2Zxuf8cbA1Go=;
        b=BhQOUymAgToe+qdCHDeLxVkhfxI4Ttc1uU/IXYGwxc+58EXSFwyQNjgYXqTUTZ3dC6C5dW
        7M7AMH+SIhNt7c4Hib1s57UXVkq9Q2otKt69rIeeVSomA7hJ1jE4UsoRzWXpL7mdeSVbdf
        +t4ZrepLSLMGnZMopShfP3ysRIbnBdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-hQQv2VQKMqiMWKt6WgyLYA-1; Mon, 18 Jan 2021 06:05:09 -0500
X-MC-Unique: hQQv2VQKMqiMWKt6WgyLYA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49FD8107ACE3;
        Mon, 18 Jan 2021 11:05:07 +0000 (UTC)
Received: from carbon (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4F687046D;
        Mon, 18 Jan 2021 11:05:00 +0000 (UTC)
Date:   Mon, 18 Jan 2021 12:04:59 +0100
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
Message-ID: <20210118120459.4a7ac2e1@carbon>
In-Reply-To: <776c5832-da48-cc6b-730f-e70aebe73de8@iogearbox.net>
References: <161047346644.4003084.2653117664787086168.stgit@firesoul>
        <161047352084.4003084.16468571234023057969.stgit@firesoul>
        <a14a7490-88c6-9d14-0886-547113242c45@iogearbox.net>
        <20210114153607.6eea9b37@carbon>
        <776c5832-da48-cc6b-730f-e70aebe73de8@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 23:28:57 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 1/14/21 3:36 PM, Jesper Dangaard Brouer wrote:
> [...]
> >>> +BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
> >>> +	   u32, ifindex, u32 *, mtu_len, s32, len_diff, u64, flags)
> >>> +{
> >>> +	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
> >>> +	struct net_device *dev = skb->dev;
> >>> +	int skb_len, dev_len;
> >>> +	int mtu;
> >>> +
> >>> +	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
> >>> +		return -EINVAL;
> >>> +
> >>> +	dev = __dev_via_ifindex(dev, ifindex);
> >>> +	if (unlikely(!dev))
> >>> +		return -ENODEV;
> >>> +
> >>> +	mtu = READ_ONCE(dev->mtu);
> >>> +
> >>> +	dev_len = mtu + dev->hard_header_len;
> >>> +	skb_len = skb->len + len_diff; /* minus result pass check */
> >>> +	if (skb_len <= dev_len) {
> >>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> >>> +		goto out;
> >>> +	}
> >>> +	/* At this point, skb->len exceed MTU, but as it include length of all
> >>> +	 * segments, it can still be below MTU.  The SKB can possibly get
> >>> +	 * re-segmented in transmit path (see validate_xmit_skb).  Thus, user
> >>> +	 * must choose if segs are to be MTU checked.  Last SKB "headlen" is
> >>> +	 * checked against MTU.
> >>> +	 */
> >>> +	if (skb_is_gso(skb)) {
> >>> +		ret = BPF_MTU_CHK_RET_SUCCESS;
> >>> +
> >>> +		if (!(flags & BPF_MTU_CHK_SEGS))
> >>> +			goto out;
> >>> +
> >>> +		if (!skb_gso_validate_network_len(skb, mtu)) {
> >>> +			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
> >>> +			goto out;
> >>> +		}
> >>> +
> >>> +		skb_len = skb_headlen(skb) + len_diff;
> >>> +		if (skb_len > dev_len) {  
> [...]
> >> Do you have a particular use case for the BPF_MTU_CHK_SEGS?  
> > 
> > The complaint from Maze (and others) were that when skb_is_gso then all
> > the MTU checks are bypassed.  This flag enables checking the GSO part
> > via skb_gso_validate_network_len().  We cannot enable it per default,
> > as you say, it is universally correct in all cases.  
> 
> If there is a desire to have access to the skb_gso_validate_network_len(), I'd
> keep that behind the flag then, but would drop the skb_headlen(skb) + len_diff
> case given the mentioned case on rx where it would yield misleading results to
> users that might be unintuitive & hard to debug.

Okay, I will update the patch, and drop those lines.

> >> I also don't see the flag being used anywhere in your selftests, so I presume
> >> not as otherwise you would have added an example there?  
> > 
> > I'm using the flag in the bpf-examples code[1], this is how I've tested
> > the code path.
> > 
> > I've not found a way to generate GSO packet via the selftests
> > infrastructure via bpf_prog_test_run_xattr().  I'm
> > 
> > [1] https://github.com/xdp-project/bpf-examples/blob/master/MTU-tests/tc_mtu_enforce.c  
> 
> Haven't checked but likely something as prog_tests/skb_ctx.c might not be sufficient
> to pass it into the helper. For real case you might need a netns + veth setup like
> some of the other tests are doing and then generating TCP stream from one end to the
> other.

I have looked at prog_tests/skb_ctx.c and (as you say yourself) this is
not sufficient.  I can look into creating a netns+veth setup, but I
will appreciate if we can merge this patchset to make forward progress,
as I'm sure the netns+veth setup will require its own round of nitpicking.

I have created netns+veth test scripts before (see test_xdp_vlan.sh),
but my experience is that people/maintainers forget/don't to run these
separate shell scripts.  Thus, if I create a netns+veth test, then I
will prefer if I can integrate this into the "test_progs", as I know
that will be run by people/maintainers.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

