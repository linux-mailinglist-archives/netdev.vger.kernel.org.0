Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71D061598AE
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 19:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbgBKScc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 13:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730447AbgBKScb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 13:32:31 -0500
Received: from localhost (unknown [104.133.9.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE78206D6;
        Tue, 11 Feb 2020 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581445950;
        bh=l9B+V0tjpsUXumO8m1fXx8yAwXOYw55xHJWpqlZZu64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AljyERKVtVZzKWL/35kIi13azAOhEClGA0qIBfrqRNHizL+bxD4i8TJRDkRr3K/ft
         hHk8rib5cwIff+tzmovuP09YVBlREmmcnpoDgkjn6NGkzmel0nhx3kXjTkbXhu7vSQ
         bppECNBYnPWY2F7QTqkErI0ga8CUb9sK8z7SLLWE=
Date:   Tue, 11 Feb 2020 10:32:29 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
Message-ID: <20200211183229.GA1938663@kroah.com>
References: <20200211174126.GA29960@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211174126.GA29960@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 11:41:26AM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> unadvertenly introduced[3] to the codebase from now on.
> 
> All these instances of code were found with the help of the following
> Coccinelle script:
> 
> @@
> identifier S, member, array;
> type T1, T2;
> @@
> 
> struct S {
>   ...
>   T1 member;
>   T2 array[
> - 0
>   ];
> };
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> NOTE: I'll carry this in my -next tree for the v5.6 merge window.

Why not carve this up into per-subsystem patches so that we can apply
them to our 5.7-rc1 trees and then you submit the "remaining" that don't
somehow get merged at that timeframe for 5.7-rc2?

thanks,

greg k-h
