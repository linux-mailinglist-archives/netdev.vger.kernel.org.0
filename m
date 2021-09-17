Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6640FF71
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235206AbhIQSef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231364AbhIQSee (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 14:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C8C161056;
        Fri, 17 Sep 2021 18:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631903592;
        bh=8D5/YlF+kcWUWkyQkhqBFljmIJow8Mh0mwd1sVRyxfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dN4o7ghlUg6SpPe11dsBBu1/nywj6KF20ZVGqZecqcGZKJfRT7++dYCDBgVWQzA8Y
         LOBxhvGV7SxWfXMU2W7Z/CoxD4x7zTfB4daccUn14RJEURUV05F5pyO4U+/B+0a00W
         TbbJfCAsj8DcOfzG1ElaJLhAXdMm7FMHA0POrq2Hjq7Dw2NvqW+M4gBaNvJau58soH
         2bRMcPnU1WVUmkfYChlDg/RJyLnbmxBR1r9oZOx+93oYkl6A+BzBvxYh1D9Kg+9PHo
         +oy+pTcikX6Jv6p1q8oc52kljo96pDUiGbfTYQ77AQnUPzcp2ZPSNfmzSW33eyRZaF
         v0vfeg1SyIcSw==
Date:   Fri, 17 Sep 2021 11:33:10 -0700
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
Message-ID: <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YUSrWiWh57Ys7UdB@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YUSrWiWh57Ys7UdB@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 16:51:06 +0200 Lorenzo Bianconi wrote:
> > Is there much critique of the skb helpers we have? My intuition would
> > be to follow a similar paradigm from the API perspective. It may seem
> > trivial to us to switch between the two but "normal" users could easily
> > be confused.
> > 
> > By skb paradigm I mean skb_pull_data() and bpf_skb_load/store_bytes().
> > 
> > Alternatively how about we produce a variation on skb_header_pointer()
> > (use on-stack buffer or direct access if the entire region is in one
> > frag).
> > 
> > bpf_xdp_adjust_data() seems to add cost to helpers and TBH I'm not sure
> > how practical it would be to applications. My understanding is that the
> > application is not supposed to make assumptions about the fragment
> > geometry, meaning data can be split at any point. Parsing data
> > arbitrarily split into buffers is hard if pull() is not an option, let
> > alone making such parsing provably correct.
> > 
> > Won't applications end up building something like skb_header_pointer()
> > based on bpf_xdp_adjust_data(), anyway? In which case why don't we
> > provide them what they need?  
> 
> Please correct me if I am wrong, here you mean in bpf_xdp_adjust_data()
> we are moving the logic to read/write data across fragment boundaries
> to the caller. Right.
> I do not have a clear view about what could be a real use-case for the helper
> (maybe John can help on this), but similar to what you are suggesting, what
> about doing something like bpf_skb_load/store_bytes()?
> 
> - bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, u32 len,
> 		     void *data)
> 
> - bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, u32 len,
> 		      void *data)
> 
> the helper can take care of reading/writing across fragment boundaries
> and remove any layout info from the caller. The only downside here
> (as for bpf_skb_load/store_bytes()) is we need to copy.

If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
can start with that. In all honesty I don't know what the exact
use cases for looking at data are, either. I'm primarily worried 
about exposing the kernel internals too early.

What I'm imagining is that data access mostly works around bad
header/data split or loading some simple >L4 headers. On one hand
such headers will fall into one frag, so 99.9% of the time the copy
isn't really required. But as I said I'm happy with load/store, to
begin with.

> But in a real application, is it actually an issue? (since we have
> much less pps for xdp multi-buff).
> Moreover I do not know if this solution will requires some verifier
> changes.
> 
> @John: can this approach works in your use-case?
> 
> Anyway I think we should try to get everyone on the same page here
> since the helper can change according to specific use-case. Since
> this series is on the agenda for LPC next week, I hope you and others
> who have an opinion about this will find the time to come and discuss
> it during the conference :)

Yup, I'll be there. I'm not good at thinking on my feet tho, hence
sharing my comments now.
