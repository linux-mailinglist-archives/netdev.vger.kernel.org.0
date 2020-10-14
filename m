Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC39C28EA5A
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389436AbgJOBk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389067AbgJOBjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:39:37 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650D0C05113A;
        Wed, 14 Oct 2020 16:12:13 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSpwI-000OHX-VT; Wed, 14 Oct 2020 23:12:11 +0000
Date:   Thu, 15 Oct 2020 00:12:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 20/20] ppc: propagate the calling conventions change
 down to csum_partial_copy_generic()
Message-ID: <20201014231210.GM3576660@ZenIV.linux.org.uk>
References: <20200724012512.GK2786714@ZenIV.linux.org.uk>
 <20200724012546.302155-1-viro@ZenIV.linux.org.uk>
 <20200724012546.302155-20-viro@ZenIV.linux.org.uk>
 <20201014222650.GA390346@zx2c4.com>
 <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgTrpV=mT_EZF1BbWxqezrFJRJcaDtuM58qXMXk9=iaZA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 03:51:00PM -0700, Linus Torvalds wrote:
> On Wed, Oct 14, 2020 at 3:27 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > This patch is causing crashes in WireGuard's CI over at
> > https://www.wireguard.com/build-status/ . Apparently sending a simple
> > network packet winds up triggering refcount_t's warn-on-saturate code. I
> 
> Ouch.
> 
> The C parts look fairly straightforward, and I don't see how they
> could cause that odd refcount issue.
> 
> So I assume it's the low-level asm code conversion that is buggy. And
> it's apparently the 32-bit conversion, since your ppc64 status looks
> fine.
> 
> I think it's this instruction:
> 
>         addi    r1,r1,16
> 
> that should be removed from the function exit, because Al removed the
> 
> -       stwu    r1,-16(r1)
> 
> on function entry.
> 
> So I think you end up with a corrupt stack pointer and basically
> random behavior.

Gyahh...  ACK, and I really wonder how the hell has it managed to avoid
crashing on testing.

Mea culpa, folks.
