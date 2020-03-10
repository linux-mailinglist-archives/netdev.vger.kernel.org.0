Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD1180A04
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbgCJVJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 17:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJVJy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 17:09:54 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42B51222C3;
        Tue, 10 Mar 2020 21:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583874593;
        bh=ZRh9g6z0hg/hHDmXvI0luI6O1qGbNra5yMZfRLcTT5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oOS9a4HS7A3Y/fTyK4lad1/nt2Ojxu6ld0CXo+irOoZbGOpr8LC1/Vaq1ZaIf/HsR
         8MwieH3Kn9YJl8TEqFVX0E4IkZRiE0VTcSAX9kQHfb+WpCoCyeI/UzdgF0hrNEd/kZ
         M++Jk3CDkBRqj0qKknlct/KNEzi59h4u10sfGYBw=
Date:   Tue, 10 Mar 2020 14:09:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
Message-ID: <20200310140951.64a3a7dc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310110412.66b60677@carbon>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
        <20200309.175534.1029399234531592179.davem@davemloft.net>
        <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
        <20200310110412.66b60677@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 11:04:12 +0100 Jesper Dangaard Brouer wrote:
> On Tue, 10 Mar 2020 02:30:34 +0000
> Saeed Mahameed <saeedm@mellanox.com> wrote:
> > On Mon, 2020-03-09 at 17:55 -0700, David Miller wrote:  
> > > From: Jonathan Lemon <jonathan.lemon@gmail.com>
> > > Date: Mon, 9 Mar 2020 12:49:29 -0700
> > >     
> > > > netpoll may be called from IRQ context, which may access the
> > > > page pool ring.  The current _bh variants do not provide sufficient
> > > > protection, so use irqsave/restore instead.
> > > > 
> > > > Error observed on a modified mlx4 driver, but the code path exists
> > > > for any driver which calls page_pool_recycle from napi poll.  
> 
> Netpoll calls into drivers are problematic, nasty and annoying. Drivers
> usually catch netpoll calls via seeing NAPI budget is zero, and handle
> the situation inside the driver e.g.[1][2]. (even napi_consume_skb
> catch it this way).

I'm probably just repeating what you said, but would it be reasonable
to expect page_pool users to special-case XDP rings to not be cleaned?
netpoll has no use for them.

Perhaps that would not solve the issue for those funky drivers which
use the same rings for both XDP and the stack. Sigh. Do we care about
them?
