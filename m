Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552C714FEE8
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 20:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgBBTbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 14:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgBBTbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 14:31:55 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7872620679;
        Sun,  2 Feb 2020 19:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580671914;
        bh=Up6bGOLnP6QP4nIRjMNNttT/QS4CRYiealRAtJt+GAg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jH30Tz7X3YGQSsWGoBlDPKC64aHUJjiMrgRZ6rDKw3uGNk3sO/ciQNRFo3/+jJWIp
         q1pgYyuJDHYpVQ2QWzLUNpb75irlVt9izCAADYRgzBtna4ZnmGBBN+JK5xANw1Fu6/
         ZvoedrIPSCRirzkkgVjYlLGTRAXXxw8Hjk8WQynI=
Date:   Sun, 2 Feb 2020 11:31:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, jbrouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP
 programs in the egress path
Message-ID: <20200202113152.321b665f@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <e3f52be9-e5c8-ba4f-dd99-ddcc5d13bc91@gmail.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
        <20200123014210.38412-4-dsahern@kernel.org>
        <87tv4m9zio.fsf@toke.dk>
        <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
        <20200124072128.4fcb4bd1@cakuba>
        <87o8usg92d.fsf@toke.dk>
        <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
        <20200126141141.0b773aba@cakuba>
        <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
        <20200127061623.1cf42cd0@cakuba>
        <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
        <20200128055752.617aebc7@cakuba>
        <e3f52be9-e5c8-ba4f-dd99-ddcc5d13bc91@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2 Feb 2020 10:43:58 -0700, David Ahern wrote:
> you are making a lot of assumptions and frankly it's the 'c' word
> (complex) that I want to avoid. I do not believe in the OVS style of
> packet processing - one gigantic program with a bunch of logic and data
> driven flow lookups that affect every packet. I prefer simple, singly
> focused programs logically concatenated to make decisions. Simpler
> management, simpler lifecycle. The scope, scale and lifecycle management
> of VMs/containers is just as important as minimizing the cycles spent
> per packet. XDP in the Tx path is a missing primitive to make life simple.
> 
> As an example, the program on the ingress NICs to the host can be
> nothing more than a demux'er - use the ethernet header and vlan
> (preferably with vlan offload enabled) to do a <vlan,mac> lookup. No
> packet parsing at all at this level. The lookup returns an index of
> where to redirect the packet (e.g., the tap device of a VM). At the same
> time, packets can hit the "slow path" - processing support from the full
> stack when it is needed and still packets end up at the tap device. *IF*
> there is an ingress ACL for that tap device managed by the host, it can
> exist in 1 place - a program and map attached to the tap device limited
> to that tap device's networking function (VMs can have multiple
> connections to different networks with different needs at this point),
> and the program gets run for both XDP fast path and skb slow path.

I think our perspectives will be difficult to reconcile.

My reading is that you look at this from slow software device
perspective. Of which there are few (and already loaded with hacks).
And you want the control plane to be simple rather than performance.

I look at this from HW driver perspective of which there are many.
Saying that it's fine to load TX paths of all drivers with extra 
code, and that it's fine to effectively disable SG in the entire 
system just doesn't compute.

Is that a fair summary of the arguments?
