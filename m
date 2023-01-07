Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833DD661286
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 00:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjAGXUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 18:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAGXUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 18:20:22 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB453C732;
        Sat,  7 Jan 2023 15:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F0A98CE0AD8;
        Sat,  7 Jan 2023 23:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27B81C433EF;
        Sat,  7 Jan 2023 23:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673133618;
        bh=OmcuvtgNtVSGffCtlj/gTL7e54P/hIB2iUQ+Kj8YGeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JrGeQV3Me/mM3sYU882AoaiBRpnQB8eR/egyoRK7PhGNx/0kFwQRoocLg8YsAs1c5
         4DeVPpYX0MZuFRkpG9tvHCy91nS2aLxvNigvczHs7VirOcotqNqa2wKO9wU8nvsdra
         zdxgbvbGInw3qkjmN3Vt/BOI3dUJYQOGFsYleQxPnWeG4QT8D6kuFGJSlMnM93Ok0o
         Yw+Tn/M6hMAQGaXwSG7A4ifmJHClg+LL1QTTX2r+6qzGp9XcsyU06wwz0NG9kO99kq
         NbXhN8VQCX4OShAWyUa1r4B5PmipcZAvqVkmABV251PSD7+QhfGuzYqs2ZjfqMULlQ
         OQkaSsLfKvKjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A8A4E21EEB;
        Sat,  7 Jan 2023 23:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 00/19] rxrpc: Fix race between call connection,
 data transmit and call disconnect
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167313361803.12002.2228474134928955888.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 23:20:18 +0000
References: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
In-Reply-To: <167308517118.1538866.3440481802366869065.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        syzbot+c22650d2844392afdcfd@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David Howells <dhowells@redhat.com>:

On Sat, 07 Jan 2023 09:52:51 +0000 you wrote:
> Here are patches to fix an oops[1] caused by a race between call
> connection, initial packet transmission and call disconnection which
> results in something like:
> 
> 	kernel BUG at net/rxrpc/peer_object.c:413!
> 
> when the syzbot test is run.  The problem is that the connection procedure
> is effectively split across two threads and can get expanded by taking an
> interrupt, thereby adding the call to the peer error distribution list
> *after* it has been disconnected (say by the rxrpc socket shutting down).
> 
> [...]

Here is the summary with links:
  - [net,01/19] rxrpc: Stash the network namespace pointer in rxrpc_local
    https://git.kernel.org/netdev/net/c/8a758d98dba3
  - [net,02/19] rxrpc: Make the local endpoint hold a ref on a connected call
    https://git.kernel.org/netdev/net/c/5040011d073d
  - [net,03/19] rxrpc: Separate call retransmission from other conn events
    https://git.kernel.org/netdev/net/c/30df927b936b
  - [net,04/19] rxrpc: Only set/transmit aborts in the I/O thread
    https://git.kernel.org/netdev/net/c/a343b174b4bd
  - [net,05/19] rxrpc: Only disconnect calls in the I/O thread
    https://git.kernel.org/netdev/net/c/03fc55adf876
  - [net,06/19] rxrpc: Implement a mechanism to send an event notification to a connection
    https://git.kernel.org/netdev/net/c/f2cce89a074e
  - [net,07/19] rxrpc: Clean up connection abort
    https://git.kernel.org/netdev/net/c/a00ce28b1778
  - [net,08/19] rxrpc: Tidy up abort generation infrastructure
    https://git.kernel.org/netdev/net/c/57af281e5389
  - [net,09/19] rxrpc: Make the set of connection IDs per local endpoint
    https://git.kernel.org/netdev/net/c/f06cb2918936
  - [net,10/19] rxrpc: Offload the completion of service conn security to the I/O thread
    https://git.kernel.org/netdev/net/c/2953d3b8d8fd
  - [net,11/19] rxrpc: Set up a connection bundle from a call, not rxrpc_conn_parameters
    https://git.kernel.org/netdev/net/c/1bab27af6b88
  - [net,12/19] rxrpc: Split out the call state changing functions into their own file
    https://git.kernel.org/netdev/net/c/0b9bb322f13d
  - [net,13/19] rxrpc: Wrap accesses to get call state to put the barrier in one place
    https://git.kernel.org/netdev/net/c/d41b3f5b9688
  - [net,14/19] rxrpc: Move call state changes from sendmsg to I/O thread
    https://git.kernel.org/netdev/net/c/2d689424b618
  - [net,15/19] rxrpc: Move call state changes from recvmsg to I/O thread
    https://git.kernel.org/netdev/net/c/93368b6bd58a
  - [net,16/19] rxrpc: Remove call->state_lock
    https://git.kernel.org/netdev/net/c/96b4059f43ce
  - [net,17/19] rxrpc: Move the client conn cache management to the I/O thread
    https://git.kernel.org/netdev/net/c/0d6bf319bc5a
  - [net,18/19] rxrpc: Move client call connection to the I/O thread
    https://git.kernel.org/netdev/net/c/9d35d880e0e4
  - [net,19/19] rxrpc: Fix incoming call setup race
    https://git.kernel.org/netdev/net/c/42f229c350f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


