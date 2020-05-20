Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F2B1DA971
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgETEtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:49:39 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35181 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgETEtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 00:49:39 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 15e07663;
        Wed, 20 May 2020 04:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=/CDx/8Pb1SC8aZG/DTS+Y80Vu
        HE=; b=hoPhdXife8YO+cbNH4DZfYX41FAgUFk94rRvKTYpSK1kyhHaYRcvNSiuo
        RF9S0fowfQFa4THdNINaCfoj1o3FqT9us4+HAfCl9m+iXZJnbZIsLJ+GjVfkcF/n
        TZxVIuKEN/3kwsHW0Rt8PL89wrNN0v+e4Y5AP3qhN6OdUVG0jAH2lGDVM+ATSxMO
        hy4dDrAEusrcVAX5h+pnlFbNHMvVOdzPj8DjsILUm7sUWVm0GXDKLeQpZycVyxPO
        sVTB8zHNUGd4/R0Ot72FMO1UtUHJWjnSVg+dEGl1gVDOGf0ZbsmAZlogsN9mYvGg
        1ypFfu2wTO80oYWQ6tbEsYDq4O0KQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7a3feff1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 20 May 2020 04:35:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/4] wireguard fixes for 5.7-rc7
Date:   Tue, 19 May 2020 22:49:26 -0600
Message-Id: <20200520044930.8131-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Hopefully these are the last fixes for 5.7:

1) A trivial bump in the selftest harness to support gcc-10.
   build.wireguard.com is still on gcc-9 but I'll probably switch to
   gcc-10 in the coming weeks.

2) A concurrency fix regarding userspace modifying the pre-shared key at
   the same time as packets are being processed, reported by Matt
   Dunwoodie.

3) We were previously clearing skb->hash on egress, which broke
   fq_codel, cake, and other things that actually make use of the flow
   hash for queueing, reported by Dave Taht and Toke Høiland-Jørgensen.

4) A fix for the increased memory usage caused by (3). This can be
   thought of as part of patch (3), but because of the separate
   reasoning and breadth of it I thought made it a bit cleaner to put in
   a standalone commit.

Fixes (2), (3), and (4) are -stable material.

Thanks,
Jason

Jason A. Donenfeld (4):
  wireguard: selftests: use newer iproute2 for gcc-10
  wireguard: noise: read preshared key while taking lock
  wireguard: queueing: preserve flow hash across packet scrubbing
  wireguard: noise: separate receive counter from send counter

 drivers/net/wireguard/messages.h              |  2 +-
 drivers/net/wireguard/noise.c                 | 22 ++++------
 drivers/net/wireguard/noise.h                 | 14 +++---
 drivers/net/wireguard/queueing.h              | 10 ++++-
 drivers/net/wireguard/receive.c               | 44 +++++++++----------
 drivers/net/wireguard/selftest/counter.c      | 17 ++++---
 drivers/net/wireguard/send.c                  | 19 ++++----
 .../testing/selftests/wireguard/qemu/Makefile |  2 +-
 8 files changed, 71 insertions(+), 59 deletions(-)

-- 
2.26.2

