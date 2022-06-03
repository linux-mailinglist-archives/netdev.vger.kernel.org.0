Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEAE53CCA7
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241872AbiFCPvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 11:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243155AbiFCPvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 11:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7A350B01
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 08:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3646191F
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 15:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E01C34115;
        Fri,  3 Jun 2022 15:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654271502;
        bh=UWgvrAkAowkOVAxbyuXxCO7bhoyKbGVaMAkLgz9EPLo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bM8Yxi/sxQXJNXQUABKx82YDTwOCfF06nMIeBNpEgrInNOU8ZCPUDdAi1IVTXwm3e
         2T/1jS1rna2rCWXUbYYVgNUNoZS2zT+bVCsnQjacPDOr1Vrw0x7nvZjabyjyk5v2n6
         5S8FY86XYlIVp3YGTZ6V9irzawpM/+I4+DiUa3+vyV+6QTw2IXK3YWa4JQlum2U9zg
         9ilL3pAQ1Hl9dLMycP8mBk70RKUVz2AEdlTyamjbQB7yRbGQvePGrfjLDW7Wjolo13
         nT58rZFSW2UkCI0d9c1h0HBr9uhnWw4isjfr9JtlKofuYyLZPGc6CL6mVE7lOiDslv
         DmTvGk7Y0NQgw==
Date:   Fri, 3 Jun 2022 08:51:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Message-ID: <20220603085140.26f29d80@kernel.org>
In-Reply-To: <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
References: <20220601122343.2451706-1-maximmi@nvidia.com>
        <20220601234249.244701-1-kuba@kernel.org>
        <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
        <20220602094428.4464c58a@kernel.org>
        <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jun 2022 16:47:43 +0300 Maxim Mikityanskiy wrote:
> >> The kernel feature is exposed to the userspace as "zerocopy sendfile",
> >> see the constants for setsockopt and sock_diag.
> >> ss should just print  whatever is exposed via sock_diag as is. IMO,
> >> inventing new names for it would cause confusion. Calling the feature
> >> by the same name everywhere looks clearer to me.  
> > 
> > Sure, there discrepancy is a little annoying. Do you want to send
> > the kernel rename patch, or should I?  
> 
> You reviewed the kernel patch and were fine with the naming. Could you 
> tell me what happened after merging the patch, what changed your mind 
> and made you unhappy about it?

Ah, I had the explanation but I cut it to keep the email shorter :S

The difference is that the person writing the code (who will interact
with kernel defines) is likely to have a deeper understanding of the
technology and have read the doc. My concern is that an ss user will
have much more superficial understanding of the internals so we need 
to be more careful to present the information in the most meaningful
way.

E.g. see the patch for changing dev->operstate to UP from UNKNOWN
because users are "confused". If you just call the thing "zc is enabled"
I'm afraid users will start reporting that the "go fast mode" is not
engaged as a bug, without appreciation for the possible side effects.

> > I spent the last 8 months in meetings
> > about TLS and I had to explain over and over that TLS zero-copy is not
> > zero-copy. Granted that's the SW path that's to blame as it moves data
> > from one place to another and still calls that zero-copy. But the term
> > zero-copy is tainted for all of kernel TLS at this point.  
> 
> That sounds like a good reason to rename the "zero-copy which is not 
> actually zero-copy" feature. On the other hand, zerocopy sendfile is 
> truly zerocopy, it doesn't have this issue.

Well, maybe, or maybe the SW path does not make a copy either just
*crypts to a different buffer. IDK if that's a copy.

> > Unless we report a matrix with the number of copies per syscall I'd
> > prefer to avoid calling random ones zero-copy again.

This was a serious suggestion BTW. More legwork, but I believe it'd be
quite useful. If we could express the "number of data movements" in a
more comprehensive manner it'd be helpful for all the cases, and you'd
get the "0" for the sendfile.

Hopefully such a matrix would be complicated enough to make people look
at the docs for an explanation of the details.

> >> What is confusing is calling a feature not by its name, but by one of
> >> its implications, and picking a name that doesn't have any references
> >> elsewhere.  
> > 
> > The sockopt is a promise from the user space to the kernel that it will
> > not modify the data in the file. So I'd prefer to call it sendfile_ro.  
> 
> That's another way of thinking about it. So, one way is to request 
> specific effects and deal with the limitations. Another way is to 
> declare the limitations and let the supported optimizations kick in 
> automatically. Both approaches look valid, but I have to think about it. 
> It's hard to figure out which is better when we have only one 
> optimization and one limitation.

Dunno if it's useful but FWIW I pushed my WIP branch out:

https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=d923f1049a1ae1c2bdc1d8f0081fd9f3a35d4155
https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=b814ee782eef62d6e2602ab3ba7b31ca03cfe44c

> >> However, in the context of this patch, you call "zerocopy" a
> >> "salesman speak". What is different in this context that "zerocopy"
> >> became an unwanted term?  
> > 
> > I put that sentence in there because I thought you'd appreciate it.
> > I can remove it if it makes my opinion look inconsistent.
> > Trying to be nice always backfires for me, eh.  
> 
> I'm sorry if I didn't read your intention right, but I felt the opposite 
> of nice when I started receiving derogatory nicknames for my feature in 
> a passive-aggressive manner.
> 
> We could have prevented all the miscommunication if you had sent me a 
> note at the point when you felt we need to rename the whole feature. 
> Instead, I was under impression that you suddenly started hating my 
> feature, and I couldn't really get why.

Not at all, sorry. In fact I hope you / someone implements a similar
thing for sendmsg. At which point I may be involved in people using
it. Therefore I started to care about user reports / complaints coming
in and me having to explain the context over and over :(
