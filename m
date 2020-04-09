Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B81A3CD5
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 01:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgDIX1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 19:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgDIX13 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 19:27:29 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC0F820757;
        Thu,  9 Apr 2020 23:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586474849;
        bh=kAvq0YlYNtUXb63H+0+l03/onQQYZceeXPUV0wZBEfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wA8fHmEhsXNJ8Uv+4dZb1cP1pylnHFoWo7VGip625acR/LEZhhJLWXxqzHU+ar9Z3
         HiIgmV3jCtBVh8Yw+dtqRjpNj0LWNCcddnIjljrcEdvbubwMakCyc578SA2jpc+ITM
         t2/qFQTTOLL6WxDqE41lUAYHCASNzRdZkLUvfCgo=
Date:   Thu, 9 Apr 2020 16:27:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200409162727.5f17d305@kicinski-fedora-PC1C0HJN>
In-Reply-To: <7a92118a956a29bbc62373af43832e30a39225f5.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634663936.707275.3156718045905620430.stgit@firesoul>
        <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
        <a101ea0284504b65edcd8f83bd7a05747c6f8014.camel@mellanox.com>
        <20200408181308.4e1cf9fc@kicinski-fedora-PC1C0HJN>
        <7a92118a956a29bbc62373af43832e30a39225f5.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 23:07:42 +0000 Saeed Mahameed wrote:
> > My concern is that driver may allocate a full page for each frame but
> > only DMA map the amount that can reasonably contain data given the
> > MTU.
> > To save on DMA syncs.
> > 
> > Today that wouldn't be a problem, because XDP_REDIRECT will re-map
> > the
> > page, and XDP_TX has the same MTU.
> 
> I am not worried about dma at all, i am worried about the xdp progs
> which are now allowed to extend packets beyond the mtu and do XDP_TX.
> but as i am thinking about this i just realized that this can already
> happen with xdp_adjust_head()..
> 
> but as you stated above this puts alot of assumptions on how driver
> should dma rx buffs 
> 
> > In this set xdp_data_hard_end is used both to find the end of memory
> > buffer, and end of DMA buffer. Implementation of
> > bpf_xdp_adjust_tail()
> > assumes anything < SKB_DATA_ALIGN(sizeof(struct skb_shared_info))
> > from
> > the end is fair game.
> 
> but why skb_shared_info in particular though ? this assumes someone
> needs this tail for building skbs .. looks weird to me.

Fair, simplifies the internals, I guess.

> > So I was trying to say that we should warn driver authors that the
> > DMA
> > buffer can now grow / move beyond what the driver may expect in
> > XDP_TX.  
> 
> Ack, but can we do it by desing ? i.e instead of having hardcoded
> limits (e.g. SKB_DATA_ALIGN(shinfo)) in bpf_xdp_adjust_tail(), let the
> driver provide this, or any other restrictions, e.g mtu for tx, or
> driver specific memory model restrictions .. 

Right, actually for NFP we need to add the check already - looking at
the code - the DMA mapping does not cover anything beyond the headroom +
MTU.

> > Drivers can either DMA map enough memory, or handle the corner case
> > in
> > a special way.
> > 
> > IDK if that makes sense, we may be talking past each other :)  
