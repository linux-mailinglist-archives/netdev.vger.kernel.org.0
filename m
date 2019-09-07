Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCE1AC772
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 18:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394769AbfIGQAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 12:00:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390962AbfIGQAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 12:00:07 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 41054152F1ADD;
        Sat,  7 Sep 2019 09:00:04 -0700 (PDT)
Date:   Sat, 07 Sep 2019 18:00:02 +0200 (CEST)
Message-Id: <20190907.180002.1996556844471437344.davem@davemloft.net>
To:     shmulik@metanetworks.com
Cc:     alexander.duyck@gmail.com, daniel@iogearbox.net,
        eric.dumazet@gmail.com, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org, eyal@metanetworks.com,
        shmulik.ladkani@gmail.com
Subject: Re: [PATCH v2 net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906092350.13929-1-shmulik.ladkani@gmail.com>
References: <20190906092350.13929-1-shmulik.ladkani@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 09:00:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shmulik Ladkani <shmulik@metanetworks.com>
Date: Fri,  6 Sep 2019 12:23:50 +0300

> Historically, support for frag_list packets entering skb_segment() was
> limited to frag_list members terminating on exact same gso_size
> boundaries. This is verified with a BUG_ON since commit 89319d3801d1
> ("net: Add frag_list support to skb_segment"), quote:
> 
>     As such we require all frag_list members terminate on exact MSS
>     boundaries.  This is checked using BUG_ON.
>     As there should only be one producer in the kernel of such packets,
>     namely GRO, this requirement should not be difficult to maintain.
> 
> However, since commit 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper"),
> the "exact MSS boundaries" assumption no longer holds:
> An eBPF program using bpf_skb_change_proto() DOES modify 'gso_size', but
> leaves the frag_list members as originally merged by GRO with the
> original 'gso_size'. Example of such programs are bpf-based NAT46 or
> NAT64.
> 
> This lead to a kernel BUG_ON for flows involving:
>  - GRO generating a frag_list skb
>  - bpf program performing bpf_skb_change_proto() or bpf_skb_adjust_room()
>  - skb_segment() of the skb
> 
> See example BUG_ON reports in [0].
> 
> In commit 13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb"),
> skb_segment() was modified to support the "gso_size mangling" case of
> a frag_list GRO'ed skb, but *only* for frag_list members having
> head_frag==true (having a page-fragment head).
> 
> Alas, GRO packets having frag_list members with a linear kmalloced head
> (head_frag==false) still hit the BUG_ON.
> 
> This commit adds support to skb_segment() for a 'head_skb' packet having
> a frag_list whose members are *non* head_frag, with gso_size mangled, by
> disabling SG and thus falling-back to copying the data from the given
> 'head_skb' into the generated segmented skbs - as suggested by Willem de
> Bruijn [1].
> 
> Since this approach involves the penalty of skb_copy_and_csum_bits()
> when building the segments, care was taken in order to enable this
> solution only when required:
>  - untrusted gso_size, by testing SKB_GSO_DODGY is set
>    (SKB_GSO_DODGY is set by any gso_size mangling functions in
>     net/core/filter.c)
>  - the frag_list is non empty, its item is a non head_frag, *and* the
>    headlen of the given 'head_skb' does not match the gso_size.
> 
> [0]
> https://lore.kernel.org/netdev/20190826170724.25ff616f@pixies/
> https://lore.kernel.org/netdev/9265b93f-253d-6b8c-f2b8-4b54eff1835c@fb.com/
> 
> [1]
> https://lore.kernel.org/netdev/CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com/
> 
> Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
> Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> ---
> v2: reorder the test conditions, as suggested by Alexander Duyck

Applied and queued up for -stable, thanks.
