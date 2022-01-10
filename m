Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7663489D68
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 17:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbiAJQVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 11:21:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38174 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbiAJQVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 11:21:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E59A612AF;
        Mon, 10 Jan 2022 16:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B5C36AE5;
        Mon, 10 Jan 2022 16:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641831665;
        bh=o9o0izpIfMYmc5M5r8xsUyttPDtVbrk5AEgPIjm4Cz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UdNmWB3Q8lTXIk4NH18aWuogd1Ao8SEvloE0Ti9ODrM2vhwl4ynXGzfksP1Y6y3Fx
         VTXk4VCZ7girEegwkuz4O1X4ckWh5BfYyCcUVetlz80ZQIamV4U9o7feYHZ8KNvf4K
         PD+PXPvCW2p3JDzNRWwShLy8KfwHGTqu4UxJTp95C1GHkw5xXnkQyOKfm3gTg922ik
         j4MBscKALpewawk886HaxHc2kSoCt66C5cOAKBR/t93MOyGN+T6sO9MnL3b/PeY7kv
         WsSJjgiiGtnydCjO6uQXHmaOurfnMuDpu4mlwYzsvNHA9yeHmx+ZnW/UPP5034FQJC
         RYehOzlVn26/A==
Date:   Mon, 10 Jan 2022 08:21:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
Subject: Re: Observation of a memory leak with commit 314001f0bf92
 ("af_unix: Add OOB support")
Message-ID: <20220110082104.2292d7ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
        <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <a754b7d0-8a20-9730-c439-1660994005d0@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 15:02:23 +0100 Thorsten Leemhuis wrote:
> On 09.01.22 22:20, Jakub Kicinski wrote:
> > On Fri, 7 Jan 2022 07:48:46 +0100 Lukas Bulwahn wrote:  
> >> Dear Rao and David,
> >>
> >>
> >> In our syzkaller instance running on linux-next,
> >> https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
> >> observing a memory leak in prepare_creds,
> >> https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3,
> >> for quite some time.
> >>
> >> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> >> So, it is in mainline, was released and has not been fixed in
> >> linux-next yet.
> >>
> >> As syzkaller also provides a reproducer, we bisected this memory leak
> >> to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> >> support").
> >>
> >> We also tested that reverting this commit on torvalds' current tree
> >> made the memory leak with the reproducer go away.
> >>
> >> Could you please have a look how your commit introduces this memory
> >> leak? We will gladly support testing your fix in case help is needed.  
> > 
> > Let's test the regression/bug report tracking bot :)
> > 
> > #regzbot introduced: 314001f0bf92  
> 
> Great, thx for trying, you only did a small mistake: it lacked a caret
> (^) before the "introduced", which would have told regzbot that the
> parent mail (the one you quoted) is the one containing the report (which
> later is linked in patch descriptions of fixes and allows rezgbot to
> connect things). That's why regzbot now thinks you reported the issue
> and looks out for patches and commits that link to your mail. :-/
> 
> Don't worry, I just added it properly and now mark this as duplicate:
> 
> #regzbot dup-of:
> https://lore.kernel.org/lkml/CAKXUXMzZkQvHJ35nwVhcJe%2BDrtEXGw%2BeKGVD04=xRJkVUC2sPA@mail.gmail.com/
> 
> Thx again for trying.

Ah, thanks for the fix up, I copy/pasted the example with the hash and
forgot about the caret.

> I wonder if this mistake could be avoided. I came up with one idea while
> walking the dog:
> 
>  * if there is *no* parent mail, then "regzbot introduce" could consider
> the current mail as the report
> 
>  * if there *is* a parent mail, then "regzbot introduce" could consider
> the parent as the report
> 
> Then regzbot would have done the right thing in this case. But there is
> a "but": I wonder if such an approach would be too much black magic that
> confuses more than it helps. What do you think?

IMHO heuristics may do more harm than good. At least for maintainers.
