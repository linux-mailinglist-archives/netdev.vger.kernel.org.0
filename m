Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 928151C7C7D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgEFVdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:23 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55147 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbgEFVdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:22 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a0b16c4b;
        Wed, 6 May 2020 21:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=Nu6DVaIpf9mUhchBmoy5f+VStO8=; b=e3WsBxjWZfEYOP9QvFqD
        OmE2sHfT56fKf88qNogjzq0WVWl/cwsPrw8pzi21B+e/YkrCWp9itVcoDMVbsixa
        2Z1K6sl35E/htEp+9AxH49oTB+ueyS44wCfJdz5iUsNo6TJlfpG9RacvNkOCqTyD
        jGQ8AoR87tT9Am7MGSVeS6Vofm6qmz83Yq3tUuCPMaxA366en/UYZq24JXxODmIc
        itVEfH9JJXYxDsoLor4Pwv1Ju5SZyw8NbRN5JsjbnjmUtAZyVftetCHs0594i8VU
        F6QxMKDgCnf+Msc2pPeV5lRFlt/wGso49qumNx1oC+S2khDgxgkOsRsFDfq8BLwN
        EA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a6c0d54c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:32 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/5] wireguard fixes for 5.7-rc5
Date:   Wed,  6 May 2020 15:33:01 -0600
Message-Id: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

With Ubuntu and Debian having backported this into their kernels, we're
finally seeing testing from places we hadn't seen prior, which is nice.
With that comes more fixes:

1) The CI for PPC64 was running with extremely small stacks for 64-bit,
   causing spurious crashes in surprising places.

2) There's was an old leftover routing loop restriction, which no longer
   makes sense given the queueing architecture, and was causing problems
   for people who really did want nested routing.

3) Not yielding our kthread on CONFIG_PREEMPT_VOLUNTARY systems caused
   RCU stalls and other issues, reported by Wang Jian, with the fix
   suggested by Sultan Alsawaf.

4) Clang spewed warnings in a selftest for CONFIG_IPV6=n, reported by
   Arnd Bergmann.

5) A complicated if statement was simplified to an assignment while also
   making the likely/unlikely hinting more correct and simple, and
   increasing readability, suggested by Sultan.

Patches (2) and (3) have Fixes: lines and are probably good candidates
for stable.

Thanks,
Jason

Jason A. Donenfeld (5):
  wireguard: selftests: use normal kernel stack size on ppc64
  wireguard: socket: remove errant restriction on looping to self
  wireguard: send/receive: cond_resched() when processing worker
    ringbuffers
  wireguard: selftests: initalize ipv6 members to NULL to squelch clang
    warning
  wireguard: send/receive: use explicit unlikely branch instead of
    implicit coalescing

 drivers/net/wireguard/receive.c               | 15 +++---
 drivers/net/wireguard/selftest/ratelimiter.c  |  4 +-
 drivers/net/wireguard/send.c                  | 19 +++----
 drivers/net/wireguard/socket.c                | 12 -----
 tools/testing/selftests/wireguard/netns.sh    | 54 +++++++++++++++++--
 .../wireguard/qemu/arch/powerpc64le.config    |  1 +
 6 files changed, 72 insertions(+), 33 deletions(-)

-- 
2.26.2

