Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F1F1F8B3C
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 00:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgFNWrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 18:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNWrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 18:47:55 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A90C05BD43;
        Sun, 14 Jun 2020 15:47:54 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jkbPH-008wE4-VA; Sun, 14 Jun 2020 22:47:16 +0000
Date:   Sun, 14 Jun 2020 23:47:15 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Good idea to rename files in include/uapi/ ?
Message-ID: <20200614224715.GJ23230@ZenIV.linux.org.uk>
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 09:41:17PM +0200, Alexander A. Klimov wrote:
> Hello there!
> 
> At the moment one can't checkout a clean working directory w/o any changed
> files on a case-insensitive FS as the following file names have lower-case
> duplicates:

And if you use a filesystem that is limited to 14 characters in name (or that
weird 8 + 3 thing) you'll also have problems.  Doctor, it hurts when I do it...

> Also even on a case-sensitive one VIm seems to have trouble with editing
> both case-insensitively equal files at the same time.

So file a bug report against vim.  Or use a vi variant without such a problem
(FWIW, nvi has nothing of that sort).

> I was going to make a patch renaming the respective duplicates, but I'm not
> sure:
> 
> *Is it a good idea to rename files in include/uapi/ ?*

It is not.  Strictly speaking, C99 allows implementation to consider the
header names differing only in case as refering to the same file, but then
it allows to ignore everything between the 8th character and the first
dot in those.  Not done on Unices, so #include <Shite.h> is not going to
pick /usr/include/shite.h

If it's used by any userland code, that's it - changing the name (in any fashion)
will break that userland code.  If it isn't, it shouldn't have been in include/uabi
in the first place.
