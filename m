Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28F46A2423
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 23:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBXWRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 17:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjBXWRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 17:17:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFE06C1B6;
        Fri, 24 Feb 2023 14:17:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD4C61984;
        Fri, 24 Feb 2023 22:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90471C433D2;
        Fri, 24 Feb 2023 22:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677277062;
        bh=7lRSlQmVLHZZ0EJH5h6DpbLhkxYWUyaYvb0f4M6ASdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RMGtiAkqLeK+zHUbpS8ZH5f5DVC2VrukS27Y8Psml6ahFfxamfIQPoWMDOzxaXwEg
         TJjzdKTHlCYSNWuwlBfptuGBdt45iMd5jNHTQg/bGh1o4F69Ai2DYkpGTXp9VxPlm5
         5VPCZFV/hYXLROz2iJDa9cbfxydETUKpsfCE6jQhfLmYbroxfzNKFQ89FGyFMdIIAi
         BeujsGkeyYRXaLb60jNOzllPyls6YZKWqEuGTkkN/8LOao8/ydoDY9P5fxYVkbaBla
         IeYEBkZZYQxfJmq+3LLKCC/SoFvOW+PCbs9Cgeuq9QKsbqEJkWrViPAifhtEW8EzaL
         1OjFXHskqzQfQ==
Date:   Fri, 24 Feb 2023 14:17:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Hangyu Hua <hbh25y@gmail.com>, Florian Westphal <fw@strlen.de>,
        borisp@nvidia.com, john.fastabend@gmail.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, davejwatson@fb.com,
        aviadye@mellanox.com, ilyal@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <20230224141740.63d5e503@kernel.org>
In-Reply-To: <Y/kwyS2n4uLn8eD0@hog>
References: <20230224105811.27467-1-hbh25y@gmail.com>
        <20230224120606.GI26596@breakpoint.cc>
        <20230224105508.4892901f@kernel.org>
        <Y/kck0/+NB+Akpoy@hog>
        <20230224130625.6b5261b4@kernel.org>
        <Y/kwyS2n4uLn8eD0@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 22:48:57 +0100 Sabrina Dubroca wrote:
> 2023-02-24, 13:06:25 -0800, Jakub Kicinski wrote:
> > On Fri, 24 Feb 2023 21:22:43 +0100 Sabrina Dubroca wrote:  
>  [...]  
> > > 
> > > I suggested a change of locking in do_tls_getsockopt_conf this
> > > morning [1]. The issue reported last seemed valid, but this patch is not
> > > at all what I had in mind.
> > > [1] https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/  
> > 
> > Ack, I read the messages out of order, sorry.
> >   
> > > do_tls_setsockopt_conf fills crypto_info immediately from what
> > > userspace gives us (and clears it on exit in case of failure), which
> > > getsockopt could see since it's not locking the socket when it checks
> > > TLS_CRYPTO_INFO_READY. So getsockopt would progress up to the point it
> > > finally locks the socket, but if setsockopt failed, we could have
> > > cleared TLS_CRYPTO_INFO_READY and freed iv/rec_seq.  
> > 
> > Makes sense. We should just take the socket lock around all of
> > do_tls_getsockopt(), then?   
> 
> That would make things simple and consistent. My idea was just taking
> the existing lock_sock in do_tls_getsockopt_conf out of the switch and
> put it just above TLS_CRYPTO_INFO_READY.
> 
> While we're at it, should we move the
> 
>     ctx->prot_info.version != TLS_1_3_VERSION
> 
> check in do_tls_setsockopt_no_pad under lock_sock?

Yes, or READ_ONCE(), same for do_tls_getsockopt_tx_zc() and its access
on ctx->zerocopy_sendfile.

>  I don't think that
> can do anything wrong (we'd have to get past this check just before a
> failing setsockopt clears crypto_info, and even then we're just
> reading a bit from the context), it just looks a bit strange. Or just
> lock the socket around all of do_tls_setsockopt_no_pad, like the other
> options we have.

The delayed locking feels like a premature optimization, we'll keep
having such issues with new options. Hence my vote to lock all of
do_tls_getsockopt().
