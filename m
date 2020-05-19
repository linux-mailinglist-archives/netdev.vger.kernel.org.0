Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E481D9969
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgESOVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 10:21:52 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46694 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726203AbgESOVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 10:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589898110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjSMUopkgj88ItQVm6fnWGeCUw8GYSQprXAblV6LgFc=;
        b=LPPDZW73Ov3X/uniW3FvLrWpMQHYJPbm6VHQIrLFqyYaXC4YQby5VmBe6VkWXDDBk7Pr39
        U6flBHXqCeliKXKwLEA8Ep++ZrV67AWTLNy7E3PcbIo5uucNjLrpa58x8zeCR1aedo6mj/
        CXVa2TEvz2WuV9zUzS7iWFdbswPinx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-eUx_LJciMrOHlraZoOVM_Q-1; Tue, 19 May 2020 10:21:46 -0400
X-MC-Unique: eUx_LJciMrOHlraZoOVM_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 408EB18FE867;
        Tue, 19 May 2020 14:21:44 +0000 (UTC)
Received: from carbon (unknown [10.40.208.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 203DF2BFCC;
        Tue, 19 May 2020 14:21:28 +0000 (UTC)
Date:   Tue, 19 May 2020 16:21:27 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <toke@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com, Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress
 path
Message-ID: <20200519162127.00308f3b@carbon>
In-Reply-To: <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
References: <20200513014607.40418-1-dsahern@kernel.org>
        <87sgg4t8ro.fsf@toke.dk>
        <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
        <87lflppq38.fsf@toke.dk>
        <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
        <87h7wdnmwi.fsf@toke.dk>
        <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
        <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
        <d705cf50-b5b3-8778-16fe-3a29b9eb1e85@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 15:31:20 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 5/19/20 2:02 AM, David Ahern wrote:
> > On 5/18/20 3:06 PM, Daniel Borkmann wrote:  
> >>
> >> So given we neither call this hook on the skb path, nor XDP_TX nor
> >> AF_XDP's TX path, I was wondering also wrt the discussion with
> >> John if it makes sense to make this hook a property of the devmap
> >> _itself_, for example, to have a default BPF prog upon devmap
> >> creation or a dev-specific override that is passed on map update
> >> along with the dev. At least this would make it very clear where
> >> this is logically tied to and triggered from, and if needed (?)
> >> would provide potentially more flexibility on specifiying BPF
> >> progs to be called while also solving your use-case.  
> > 
> > You lost me on the 'property of the devmap.' The programs need to be per
> > netdevice, and devmap is an array of devices. Can you elaborate?  
> 
> I meant that the dev{map,hash} would get extended in a way where the
> __dev_map_update_elem() receives an (ifindex, BPF prog fd) tuple from
> user space and holds the program's ref as long as it is in the map slot.
> Then, upon redirect to the given device in the devmap, we'd execute the
> prog as well in order to also allow for XDP_DROP policy in there. Upon
> map update when we drop the dev from the map slot, we also release the
> reference to the associated BPF prog. What I mean to say wrt 'property
> of the devmap' is that this program is _only_ used in combination with
> redirection to devmap, so given we are not solving all the other egress
> cases for reasons mentioned, it would make sense to tie it logically to
> the devmap which would also make it clear from a user perspective _when_
> the prog is expected to run.

Yes, I agree.

I also have a use-case for 'cpumap' (cc. Lorenzo as I asked him to
work on it).  We want to run another XDP program on the CPU that
receives the xdp_frame, and then allow it to XDP redirect again.
It would make a lot of sense, to attach this XDP program via inserting
an BPF-prog-fd into the map as a value.

Notice that we would also need another expected-attach-type for this
case, as we want to allow XDP program to read xdp_md->ingress_ifindex,
but we don't have xdp_rxq_info any-longer. Thus, we need to remap that
to xdp_frame->dev_rx->ifindex (instead of rxq->dev->ifindex).

The practical use-case is the espressobin mvneta based ARM64 board,
that can only receive IRQs + RX-frames on CPU-0, but hardware have more
TX-queues that we would like to take advantage of on both CPUs.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

