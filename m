Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5B8693F1F
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjBMHwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMHwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:52:43 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79ED6729D;
        Sun, 12 Feb 2023 23:52:41 -0800 (PST)
Received: (from willy@localhost)
        by mail.home.local (8.17.1/8.17.1/Submit) id 31D7qYBZ007862;
        Mon, 13 Feb 2023 08:52:34 +0100
Date:   Mon, 13 Feb 2023 08:52:34 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Winter <winter@winter.cafe>, stable@vger.kernel.org,
        regressions@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE
 from bind
Message-ID: <Y+nsQlVzmTP0meTX@1wt.eu>
References: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
 <Y+m8F7Q95al39ctV@1wt.eu>
 <Y+nl7nzQ3GPxlztq@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+nl7nzQ3GPxlztq@kroah.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Mon, Feb 13, 2023 at 08:25:34AM +0100, Greg KH wrote:
> On Mon, Feb 13, 2023 at 05:27:03AM +0100, Willy Tarreau wrote:
> > Hi,
> > 
> > [CCed netdev]
> > 
> > On Sun, Feb 12, 2023 at 10:38:40PM -0500, Winter wrote:
> > > Hi all,
> > > 
> > > I'm facing the same issue as
> > > https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/,
> > > but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce
> > > on 5.15.93.
> > > 
> > > However, I cannot seem to find the identified problematic commit in the 5.15
> > > branch, so I'm unsure if this is a different issue or not.
> > > 
> > > There's a few ways to reproduce this issue, but the one I've been using is
> > > running libuv's (https://github.com/libuv/libuv) tests, specifically tests
> > > 271 and 277.
> > 
> > >From the linked patch:
> > 
> >   https://lore.kernel.org/stable/20221228144337.512799851@linuxfoundation.org/
> 
> But that commit only ended up in 6.0.y, not 5.15, so how is this an
> issue in 5.15.y?

Hmmm I plead -ENOCOFFEE on my side, I hadn't notice the "can't find the
problematic commit", you're right indeed.

However if the issue happened in 5.15.88, the only part touching the
network listening area is this one which may introduce an EINVAL on
one listening path, but that seems unrelated to me given that it's
only for ULP that libuv doesn't seem to be using:

  dadd0dcaa67d ("net/ulp: prevent ULP without clone op from entering the LISTEN status")

I guess the reporter will need to further bisect the problem to figure
the exact patch at this point.

Willy
