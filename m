Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A540E826
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350456AbhIPRn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355815AbhIPRmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A2F6135D;
        Thu, 16 Sep 2021 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631811341;
        bh=oet03B0tk8Jg1WKB9/4I0mmwl+aXd06NhAi5DrXnSfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B6OXBpmV/CUzXULybemleifI6HafjBtdAj4UraOYq3Pazde6rRjtlyWtRA9iQW4uj
         poAf3qoLloG1uEhnS0bgRCWS+OEmgCAr+HztUF8vlsWpTEtFcRyrCmuitRqhwOoixP
         vmSum37sMNXPdtLkqBMsDF1USGsELUOOOmf2WxQRPJ3zpCZ6ALP1Fyf2fYXilmGPB8
         RZswsVM7rpXWZBLx+Qb//+RYsPetUS/k5W1NW4VqaZBb08y80Ffdkc7x4XDr/fPN+/
         zhxPGBf44qI8+EElKC7+vel1jsAycr/6hq0YMGX30N+5DQHBK4wzGcDBJnf5+FOuPK
         5ukY8EdA+Mnyg==
Date:   Thu, 16 Sep 2021 09:55:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Sep 2021 18:14:06 +0200 Lorenzo Bianconi wrote:
> The two following ebpf helpers (and related selftests) has been introduced:
> - bpf_xdp_adjust_data:
>   Move xdp_md->data and xdp_md->data_end pointers in subsequent fragments
>   according to the offset provided by the ebpf program. This helper can be
>   used to read/write values in frame payload.
> - bpf_xdp_get_buff_len:
>   Return the total frame size (linear + paged parts)

> More info about the main idea behind this approach can be found here [1][2].

Is there much critique of the skb helpers we have? My intuition would
be to follow a similar paradigm from the API perspective. It may seem
trivial to us to switch between the two but "normal" users could easily
be confused.

By skb paradigm I mean skb_pull_data() and bpf_skb_load/store_bytes().

Alternatively how about we produce a variation on skb_header_pointer()
(use on-stack buffer or direct access if the entire region is in one
frag).

bpf_xdp_adjust_data() seems to add cost to helpers and TBH I'm not sure
how practical it would be to applications. My understanding is that the
application is not supposed to make assumptions about the fragment
geometry, meaning data can be split at any point. Parsing data
arbitrarily split into buffers is hard if pull() is not an option, let
alone making such parsing provably correct.

Won't applications end up building something like skb_header_pointer()
based on bpf_xdp_adjust_data(), anyway? In which case why don't we
provide them what they need?

say: 

void *xdp_mb_pointer(struct xdp_buff *xdp_md, u32 flags, 
                     u32 offset, u32 len, void *stack_buf)

flags and offset can be squashed into one u64 as needed. Helper returns
pointer to packet data, either real one or stack_buf. Verifier has to
be taught that the return value is NULL or a pointer which is safe with
offsets up to @len.

If the reason for access is write we'd also need:

void *xdp_mb_pointer_flush(struct xdp_buff *xdp_md, u32 flags, 
                           u32 offset, u32 len, void *stack_buf)

Same inputs, if stack buffer was used it does write back, otherwise nop.

Sorry for the longish email if I'm missing something obvious and/or
discussed earlier.


The other thing I wanted to double check - was the decision on program
compatibility made? Is a new program type an option? It'd be extremely
useful operationally to be able to depend on kernel enforcement.
