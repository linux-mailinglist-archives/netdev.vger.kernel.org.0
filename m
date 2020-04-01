Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAFE19ABFB
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgDAMqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 08:46:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38868 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732354AbgDAMqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 08:46:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jJclN-0003PW-Ou; Wed, 01 Apr 2020 14:46:33 +0200
Date:   Wed, 1 Apr 2020 14:46:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Charles Bryant <ch.4g7vxy-nbkl8p@chch.co.uk>
Cc:     netdev@vger.kernel.org
Subject: Re: two bogus patches arising from CVE-2019-12381
Message-ID: <20200401124633.GH23604@breakpoint.cc>
References: <20200401105452.1376920.qmail@chch.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401105452.1376920.qmail@chch.co.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Charles Bryant <ch.4g7vxy-nbkl8p@chch.co.uk> wrote:
> I believe two patches from last year are mistaken. They are:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=95baa60a0da80a0143e3ddd4d3725758b4513825
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=425aa0e1d01513437668fa3d4a971168bbaa8515
> 
> Both of these make a function return immediately with ENOMEM if a kalloc()
> fails.  However in each case the function already correctly handled
> allocation failure later on. Furthermore, by making them exit early
> on allocation failure, it (very slightly) makes them worse as in some
> cases they might have correctly returned EADDRINUSE and not needed the
> allocated memory.
> 
> I think, therefore, that these changes should be reverted.

Both fixes are useless, as you explained above.

But they do not matter.  When GFP_KERNEL allocations fail the entire
system is screwed anyway.

So instead of revert, I would suggest that you wait until net-next
reopens, then:

For the first commit, send a patch that reverts, but also add a comment
that explains the error is handled below the loop.

For the second commit, send a patch that moves the allocation to where its
needed -- the spinlock was converted to a mutex so there is no need
for this ahead-of-time allocation anymore.
