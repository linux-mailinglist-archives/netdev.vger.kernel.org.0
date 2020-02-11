Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5CA1599E5
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgBKTi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbgBKTiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 14:38:55 -0500
Received: from localhost (unknown [104.133.9.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 145F520848;
        Tue, 11 Feb 2020 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581449935;
        bh=DWVq3ZXFoLGeUdlpAjgyaHA6wqWdK8uMWTgLFkVA13k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AFkBVFR4FioxWg06MDhGcDIcsr87r0HVTYowLudkUyK7dozpJdYEhAGFn1BebOQHG
         71/5NNZc8G17HNDVwLyEFMjyDVf08iCdpl70IrBXultI6SPx/GBg0rhG2sSBjRd+Fe
         fBgi5PzzjDQd3QEMtRaeaAqUG9oZ8O9T0jzQPnDo=
Date:   Tue, 11 Feb 2020 11:38:54 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
Message-ID: <20200211193854.GA1972490@kroah.com>
References: <20200211174126.GA29960@embeddedor>
 <20200211183229.GA1938663@kroah.com>
 <3fdbb16a-897c-aa5b-d45d-f824f6810412@embeddedor.com>
 <202002111129.77DB1CCC7B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002111129.77DB1CCC7B@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 11:32:04AM -0800, Kees Cook wrote:
> On Tue, Feb 11, 2020 at 01:20:36PM -0600, Gustavo A. R. Silva wrote:
> > 
> > 
> > On 2/11/20 12:32, Greg KH wrote:
> > > On Tue, Feb 11, 2020 at 11:41:26AM -0600, Gustavo A. R. Silva wrote:
> > >> The current codebase makes use of the zero-length array language
> > >> extension to the C90 standard, but the preferred mechanism to declare
> > >> variable-length types such as these ones is a flexible array member[1][2],
> > >> introduced in C99:
> > >>
> > >> struct foo {
> > >>         int stuff;
> > >>         struct boo array[];
> > >> };
> > >>
> > >> By making use of the mechanism above, we will get a compiler warning
> > >> in case the flexible array does not occur last in the structure, which
> > >> will help us prevent some kind of undefined behavior bugs from being
> > >> unadvertenly introduced[3] to the codebase from now on.
> > >>
> > >> All these instances of code were found with the help of the following
> > >> Coccinelle script:
> > >>
> > >> @@
> > >> identifier S, member, array;
> > >> type T1, T2;
> > >> @@
> > >>
> > >> struct S {
> > >>   ...
> > >>   T1 member;
> > >>   T2 array[
> > >> - 0
> > >>   ];
> > >> };
> > >>
> > >> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > >> [2] https://github.com/KSPP/linux/issues/21
> > >> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> > >>
> > >> NOTE: I'll carry this in my -next tree for the v5.6 merge window.
> > > 
> > > Why not carve this up into per-subsystem patches so that we can apply
> > > them to our 5.7-rc1 trees and then you submit the "remaining" that don't
> > > somehow get merged at that timeframe for 5.7-rc2?
> > > 
> > 
> > Yep, sounds good. I'll do that.
> 
> FWIW, I'd just like to point out that since this is a mechanical change
> with no code generation differences (unlike the pre-C90 1-byte array
> conversions), it's a way better use of everyone's time to just splat
> this in all at once.
> 
> That said, it looks like Gustavo is up for it, but I'd like us to
> generally consider these kinds of mechanical changes as being easier to
> manage in a single patch. (Though getting Acks tends to be a bit
> harder...)

Hey, if this is such a mechanical patch, let's get it to Linus now,
what's preventing that from being merged now?

thanks,

greg k-h
