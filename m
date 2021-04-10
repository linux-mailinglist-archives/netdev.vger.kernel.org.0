Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FFC35A9E5
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 03:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhDJBUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 21:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235215AbhDJBUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 21:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBE1D610E5;
        Sat, 10 Apr 2021 01:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618017626;
        bh=o9O6FJiTRw7Uly2Adexs2jQP3Yt/576Qy74RRItm9z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=svlU/z/2P2AnlYDH6M2aQxXx8WhFh6j2FIQRe6xFdjDjLKkr7xf1xv8vdiWm40z3n
         hXuwOkKmT662LSanNEkSf1I8zddLiJMcb0KkDIfBoHB7EqMtUY813C/plm0vPxYwfW
         zjPtUvrmlfZ/fYOzvZu1mrDsaY3KqI5bQc9vSwF71eLAhIhyED6btmkUB6SQyvO4qr
         uepY03S392lG4x2gOrnwOn6VbAoVSmHaacgfMqDm1nOnIoou84i/2541FjRljp+pSK
         RSxU50YVg/btP80zBbrR52EXqS7FDdCM40i992zYHDdC621j60lSxSl7PDVcANj9P4
         OAOINN7eUQe1Q==
Date:   Fri, 9 Apr 2021 18:20:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: enetc: fix TX ring interrupt storm
Message-ID: <20210409182025.181ab75c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <734e7b08-9f2e-587f-1e47-35be6a191364@gmail.com>
References: <20210409192759.3895104-1-olteanv@gmail.com>
        <734e7b08-9f2e-587f-1e47-35be6a191364@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Apr 2021 00:29:23 +0300 Claudiu Manoil wrote:
> On 09.04.2021 22:27, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > The blamed commit introduced a bit in the TX software buffer descriptor
> > structure for determining whether a BD is final or not; we rearm the TX
> > interrupt vector for every frame (hence final BD) transmitted.
> > 
> > But there is a problem with the patch: it replaced a condition whose
> > expression is a bool which was evaluated at the beginning of the "while"
> > loop with a bool expression that is evaluated on the spot: tx_swbd->is_eof.
> > 
> > The problem with the latter expression is that the tx_swbd has already
> > been incremented at that stage, so the tx_swbd->is_eof check is in fact
> > with the _next_ software BD. Which is _not_ final.
> > 
> > The effect is that the CPU is in 100% load with ksoftirqd because it
> > does not acknowledge the TX interrupt, so the handler keeps getting
> > called again and again.
> > 
> > The fix is to restore the code structure, and keep the local bool is_eof
> > variable, just to assign it the tx_swbd->is_eof value instead of
> > !!tx_swbd->skb.
> > 
> > Fixes: d504498d2eb3 ("net: enetc: add a dedicated is_eof bit in the TX software BD")
> > Reported-by: Alex Marginean <alexandru.marginean@nxp.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> 
> Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks!
