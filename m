Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D57432222D
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 23:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhBVWca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 17:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhBVWcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 17:32:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB6A664E15;
        Mon, 22 Feb 2021 22:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614033102;
        bh=VwYWVwba3/XzILXhjV/KrCFuc9crJLqmLUH5E11fX2s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YtxVHHM4hFwshr07YruIlYFbIB4sMP/sHQiEOGJY72cXlGpkiPV5sbOf+/mQSEUNb
         HcRcdSoGdPiIAQpj7e/BkQl4bUAIiPXyzjHxznn3Ko+FbDllHmQqn0lBKWFbYvG8TE
         8JV6ONTfw2vzMYmNmoOdYbGh+jlWbspcZSma9AM91u6FvRUdRaxtus1DaMMzNAGWOg
         2VmyD1M8ri074jUXPbqHBK3EA5FPtQ32MqYSG8EN0yqw/sBa0YygSm4qIi7kfjbYJo
         p+tBN94fCkfqXUF0DJ1nmLbkFXhZgI/unibvHfay+8HFHTyRtRn9FgcAAM0UGkL+2N
         5Ww6Im4JZQ+dg==
Date:   Mon, 22 Feb 2021 14:31:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthias Schiffer <mschiffer@universe-factory.net>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: l2tp: reduce log level when passing up invalid
 packets
Message-ID: <20210222143138.5711048a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
References: <f2a482212eed80b5ba22cb590e89d3edb290a872.1613760125.git.mschiffer@universe-factory.net>
        <20210219201201.GA4974@katalix.com>
        <2e75a78b-afa2-3776-2695-f9f6ac93eb67@universe-factory.net>
        <20210222114907.GA4943@katalix.com>
        <ec0f874e-b5af-1007-5a83-e3de7399ef29@universe-factory.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 17:40:16 +0100 Matthias Schiffer wrote:
> >> This will not be sufficient for my usecase: To stay compatible with older
> >> versions of fastd, I can't set the T flag in the first packet of the
> >> handshake, as it won't be known whether the peer has a new enough fastd
> >> version to understand packets that have this bit set. Luckily, the second
> >> handshake byte is always 0 in fastd's protocol, so these packets fail the
> >> tunnel version check and are passed to userspace regardless.
> >>
> >> I'm aware that this usecase is far outside of the original intentions of the
> >> code and can only be described as a hack, but I still consider this a
> >> regression in the kernel, as it was working fine in the past, without
> >> visible warnings.
> >>  
> > 
> > I'm sorry, but for the reasons stated above I disagree about it being
> > a regression.  
> 
> Hmm, is it common for protocol implementations in the kernel to warn about 
> invalid packets they receive? While L2TP uses connected sockets and thus 
> usually no unrelated packets end up in the socket, a simple UDP port scan 
> originating from the configured remote address/port will trigger the "short 
> packet" warning now (nmap uses a zero-length payload for UDP scans by 
> default). Log spam caused by a malicous party might also be a concern.

Indeed, seems like appropriate counters would be a good fit here? 
The prints are both potentially problematic for security and lossy.
