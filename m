Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC7E263039
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729911AbgIIPLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:11:08 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:44203 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730068AbgIIL7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 07:59:14 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2996529b;
        Wed, 9 Sep 2020 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=sGX1PxzU4jdQsmH2mBtiSUZwnic=; b=Sb3Wpqz8qw9lGhX9Xsaf
        Bxu+0gc+y8jYBw76K3qivyWmWu9NrC2546YmjIXVUTpGVneg9IMyc1nnOsMykRbi
        NYr9bit7+T9V+T2deJ4/W4H4t9QjcBB5ckJ5kNE/JsvlAGLh1Yetd1OstyFb/+Tf
        74MSJscWtGgOoOwjWAZgPg2vligdYUYetUB8HGa1xmfHJtgwbbHO4BnTi0ReAC+1
        XIO0RI2AX5TdHNk2PAPuSIz/apE7azK7xHaopZa1EYPmVrOHxOnN1L/gf+MVQbGV
        iSjK6AJYSu02QfHsj2GdNX3JH3xS7vIjq2AHHfajnzxU2Ldhn3EePupaIQFVNldL
        Bw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3d93d117 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 9 Sep 2020 11:29:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 0/2] wireguard fixes for 5.9-rc5
Date:   Wed,  9 Sep 2020 13:58:13 +0200
Message-Id: <20200909115815.522168-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Yesterday, Eric reported a race condition found by syzbot. This series
contains two commits, one that fixes the direct issue, and another that
addresses the more general issue, as a defense in depth.

1) The basic problem syzbot unearthed was that one particular mutation
   of handshake->entry was not protected by the handshake mutex like the
   other cases, so this patch basically just reorders a line to make
   sure the mutex is actually taken at the right point. Most of the work
   here went into making sure the race was fully understood and making a
   reproducer (which syzbot was unable to do itself, due to the rarity
   of the race).

2) Eric's initial suggestion for fixing this was taking a spinlock
   around the hash table replace function where the null ptr deref was
   happening. This doesn't address the main problem in the most precise
   possible way like (1) does, but it is a good suggestion for
   defense-in-depth, in case related issues come up in the future, and
   basically costs nothing from a performance perspective. I thought it
   aided in implementing a good general rule: all mutators of that hash
   table take the table lock. So that's part of this series as a
   companion.

Both of these contain Fixes: tags and are good candidates for stable.

Jason A. Donenfeld (2):
  wireguard: noise: take lock when removing handshake entry from table
  wireguard: peerlookup: take lock before checking hash in replace
    operation

 drivers/net/wireguard/noise.c      |  5 +----
 drivers/net/wireguard/peerlookup.c | 11 ++++++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

Cc: Eric Dumazet <edumazet@google.com>

-- 
2.28.0

