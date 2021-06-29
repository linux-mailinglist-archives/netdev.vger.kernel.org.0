Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33783B77EC
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhF2Sjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:39:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234971AbhF2Sjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 14:39:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086BE61CC4;
        Tue, 29 Jun 2021 18:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624991835;
        bh=nZiC7/KGmj6i/GanMyQvyR9yYYIExYb6CHGyCMPX54I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h4ttunrbU7BPR9zhqpf3t291Jw5VHnFoulmEvOh06sUFgorZHAbLeYlXwFxwWmArS
         /RJ1zEHE6/NP0j/2F17uCpLlEg/VDr42onRi1o5ZVsyhcB/M6nFzJsFjdXPpzQwtzJ
         OCuxi1y4g1xtx6dqxhAXXZfi8mX/p0FMDzS9h8IVqKJpBaK1RzrAv1m4Dr3UFODotl
         N1qubI7ocBsKTx0EOi8UJG4t+Iulin6YuFPxpf6rVeb0D5Ml/ZjmgJWDbHzgEBronj
         RdCH0i9ZxkFmTV3uom2QLF7UAx+x1eIzR7cZoEP6Oex9k3Bjz2iS10W2wsVFzzPrCu
         wuM3kF84IKpcA==
Date:   Tue, 29 Jun 2021 11:37:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        bpf <bpf@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Subject: Re: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to
 skb_shared_info
Message-ID: <20210629113714.6d8e2445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
        <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
        <CAKgT0UcwYHXosz-XuQximak63=ugb9thEc=dkUUZzDpoPCH+Qg@mail.gmail.com>
        <YNsVyBw5i4hAHRN8@lore-desk>
        <20210629100852.56d995a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKgT0Ue1HKMpsBtoW=js2oMRAhcqSrAfTTmPC8Wc97G6=TiaZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Jun 2021 11:18:38 -0700 Alexander Duyck wrote:
> On Tue, Jun 29, 2021 at 10:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > ack, I agree. I will fix it in v10.  
> >
> > Why is XDP mb incompatible with LRO? I thought that was one of the use
> > cases (mentioned by Willem IIRC).  
> 
> XDP is meant to be a per packet operation with support for TX and
> REDIRECT, and LRO isn't routable. So we could put together a large LRO
> frame but we wouldn't be able to break it apart again. If we allow
> that then we are going to need a ton more exception handling added to
> the XDP paths.
> 
> As far as GSO it would require setting many more fields in order to
> actually make it offloadable by any hardware.

It would require more work, but TSO seems to be explicitly stated 
as what the series builds towards (in the cover letter). It's fine
to make choices we'd need to redo later, I guess, I'm just trying
to understand the why.

> My preference would be
> to make use of gso_segs and gso_size to store the truesize and datalen
> of the pages. That way we keep all of the data fields used in the
> shared info in the first 8 bytes assuming we don't end up having to
> actually use multiple buffers.

Is 8B significant? We expect the compiler to load 8B and then slice it
out? Can the CPU do that? We're not expecting sinfo to be misaligned
(e.g. placed directly after xdp_buff), right?
