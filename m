Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04FC6AAC7C
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjCDUpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCDUpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:45:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7328B13DE6
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 12:45:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FD5F60A78
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 20:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C63C433D2;
        Sat,  4 Mar 2023 20:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677962718;
        bh=VhACX2BzP2CJ6dJLPQ+50XcvA66BdZH2ABZ8DF7ECSM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFs5fCIRcX2VOqpv56MRzafPSgTXmcsOPQYTwdwg57MF7ZOIwDzbHq/RV712fCYhO
         SHCAgbhBdzAi7YQiohNAa/1BnXPn6FEPv8zc3s0ol6gCeum6c3nD5IrVZfX03h64U3
         vfmPWrienNCZXNwdJLxppQc4wQurKsNslVlbm3cWFSML8f1fs71f+VnAKLlYhuP9eD
         9niddf1s1nNCS8xWtCbuVeKox/PG9MNJ+4f+OgUQUIb/mApFd+B/7dMTNkpQv0rPAA
         ZnDbgj113QV4b96w04zWUM7UL8xOg1cDFPpdLPkk5vVHHfmwtGjU9Vu1ySvPxxAVGD
         HNr8P1a0ud+qA==
Date:   Sat, 4 Mar 2023 12:45:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230304124517.394695e8@kernel.org>
In-Reply-To: <0C0B6439-B3D0-46F3-8CD2-6AACD0DDE923@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
        <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
        <20230303182131.1d1dd4d8@kernel.org>
        <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
        <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
        <20230304111616.1b11acea@kernel.org>
        <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
        <20230304120108.05dd44c5@kernel.org>
        <0C0B6439-B3D0-46F3-8CD2-6AACD0DDE923@oracle.com>
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

On Sat, 4 Mar 2023 20:19:06 +0000 Chuck Lever III wrote:
> >> Sorry to make trouble -- hopefully this discussion is also
> >> keeping you out of trouble too.  
> > 
> > I was hoping choice of BSD would keep me out of trouble :)
> > My second choice was to make them public domain.. but lawyers should
> > like BSD-3-clause more because of the warranty statement.  
> 
> The issue is that the GPL forces our hand. Derived code
> is under GPL if the spec is under GPL. The 3 existing
> specs in Documentation/netlink/specs are unlabeled, and
> therefore I think would be subsumed under the blanket
> license that other kernel source falls under.

Understood.

> I don't think you can simply choose a license for
> the derived code. The only way to fix this so that the
> generated code is under BSD-3-clause is to explicitly
> re-license the specs under Documentation/netlink/specs/
> as BSD-3-clause. (which is as easy as asking the authors
> for permission to do that - I assume this stuff is new
> enough that it won't be difficult to track them down).

Fair point. I'll relicense, they are all written by me.
The two other people who touched them should be easy to
get hold of.

> Again, it would be convenient for contributors in this
> area to specify the spec and code license in the YAML
> spec. Anyone can contribute under BSD-3-clause or GPL,
> but the code and spec licenses have to match, IMO.

Yes, I'll clean the existing specs up. The only outstanding
question AFAICT is whether we really need the GPL or you can 
get an exception for yourself and use BSD?

I care more about the downstream users than kernel devs on this,
I'd really prefer for the users not to have to worry about 
licensing. There may be a codegen for some funky new language 
which requires a specific license which may not be compatible
with GPL.

For normal C this is covered by the "uAPI note" but I doubt
that will cover generated code. And frankly would prefer not 
to have to ask :( So let's try BSD?

FWIW I always thought that companies which have an explicit
"can contribute to the kernel in GPL" policy do it because
one needs an exception _for_GPL_, not for the kernel.
Logically the answer to BSD-3-Clause to be "oh, yea, we 
don't care"... I said "logically", you can make the obvious
joke yourself :)

> I can start with the LF first to see if we actually have
> a problem.
