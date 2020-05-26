Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C9C1E32E7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404401AbgEZWr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:58466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390948AbgEZWrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:47:55 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BC42206D5;
        Tue, 26 May 2020 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590533274;
        bh=fDfKl46Flqy4/vh4x+SZ2vTaAuOkaqrZa/5sbdWNjgA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dSf2+ZtfyRClH1dLKUthz6IuFHm1qN9c0xC75M9oxi2HrRf62cR/xOqFZbEyamMpG
         p2YTQRibdihp/zJ0yeBFYPqNwkBN6oDa+Zu73p3boOKdsg980VKiOlNXtxykwJWG4/
         Q2nfn4ynmrj4T1gkoxqN+fo9KVALmPy9snR6CVZs=
Date:   Tue, 26 May 2020 15:47:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/3] bnxt_en: Fix accumulation of
 bp->net_stats_prev.
Message-ID: <20200526154752.2a7e5efc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CACKFLikEenWcFw+q6Kk=Cm8H-LSU4kNFJwVujWcHq_Mna981Dw@mail.gmail.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
        <1590442879-18961-2-git-send-email-michael.chan@broadcom.com>
        <20200526150443.7a91ce77@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CACKFLikEenWcFw+q6Kk=Cm8H-LSU4kNFJwVujWcHq_Mna981Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 15:43:52 -0700 Michael Chan wrote:
> On Tue, May 26, 2020 at 3:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 25 May 2020 17:41:17 -0400 Michael Chan wrote:  
> > > We have logic to maintain network counters across resets by storing
> > > the counters in bp->net_stats_prev before reset.  But not all resets
> > > will clear the counters.  Certain resets that don't need to change
> > > the number of rings do not clear the counters.  The current logic
> > > accumulates the counters before all resets, causing big jumps in
> > > the counters after some resets, such as ethtool -G.
> > >
> > > Fix it by only accumulating the counters during reset if the irq_re_init
> > > parameter is set.  The parameter signifies that all rings and interrupts
> > > will be reset and that means that the counters will also be reset.
> > >
> > > Reported-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> > > Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>  
> >
> > Hi Michael!
> >
> > Could you explain why accumulating counters causes a jump?  
> 
> Yes, during chip reset, we free most hardware resources including
> possibly hardware counter resources.  After freeing the hardware
> counters, the counters will go to zero.  To preserve the counters, we
> take a snapshot of the hardware counters and add them to the
> bp->net_stats_prev.  The counters in bp->net_stats_prev are always
> added to the current hardware counters to provide the true counters.
> 
> The problem is that not all resets will free the hardware counters.
> The old code is unconditionally taking the snapshot during reset.  So
> when we don't free the hardware counters, the snapshot will cause us
> to effectively double the hardware counters after the reset.

Aw! I see what you mean now, thanks for the explanation!
