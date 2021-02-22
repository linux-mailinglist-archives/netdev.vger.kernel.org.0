Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F30321CE6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 17:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhBVQ0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 11:26:54 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:60986 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhBVQ0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 11:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1614011152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S6/DpgpFsSb0gLZ/q8eAVXCqyNRhvH6P2RqkfbXPv18=;
        b=prodQb4QoYHiw6LM6Jy8cJDPmdXC4l/20WW5wJQv9OnHKZhjAuuXjnlq+hpFZDIXn7NRGY
        n5J562GKc1QujiPlt5CbFkw/M3RF7OZTPULXeLHuMq2pc9+3tkQ1oLc0YmfBlNwZr7KxDY
        fayEQ67Aj9cqUBQ0lBwbQqBE5KI6r2c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ad2dec8d (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 22 Feb 2021 16:25:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH net 0/7] wireguard fixes for 5.12-rc1
Date:   Mon, 22 Feb 2021 17:25:42 +0100
Message-Id: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series has a collection of fixes that have piled up for a little
while now, that I unfortunately didn't get a chance to send out earlier.

1) Removes unlikely() from IS_ERR(), since it's already implied.

2) Remove a bogus sparse annotation that hasn't been needed for years.

3) Addition test in the test suite for stressing parallel ndo_start_xmit.

4) Slight struct reordering in preparation for subsequent fix.

5) If skb->protocol is bogus, we no longer attempt to send icmp messages.

6) Massive memory usage fix, hit by larger deployments.

7) Fix typo in kconfig dependency logic.

(1) and (2) are tiny cleanups, and (3) is just a test, so if you're
trying to reduce churn, you could not backport these. But (4), (5), (6),
and (7) fix problems and should be applied to stable. IMO, it's probably
easiest to just apply them all to stable.

Thanks,
Jason

Antonio Quartulli (1):
  wireguard: avoid double unlikely() notation when using IS_ERR()

Jann Horn (1):
  wireguard: socket: remove bogus __be32 annotation

Jason A. Donenfeld (5):
  wireguard: selftests: test multiple parallel streams
  wireguard: peer: put frequently used members above cache lines
  wireguard: device: do not generate ICMP for non-IP packets
  wireguard: queueing: get rid of per-peer ring buffers
  wireguard: kconfig: use arm chacha even with no neon

 drivers/net/Kconfig                        |  2 +-
 drivers/net/wireguard/device.c             | 21 +++---
 drivers/net/wireguard/device.h             | 15 ++--
 drivers/net/wireguard/peer.c               | 28 +++----
 drivers/net/wireguard/peer.h               |  8 +-
 drivers/net/wireguard/queueing.c           | 86 +++++++++++++++++-----
 drivers/net/wireguard/queueing.h           | 45 ++++++++---
 drivers/net/wireguard/receive.c            | 16 ++--
 drivers/net/wireguard/send.c               | 31 +++-----
 drivers/net/wireguard/socket.c             |  8 +-
 tools/testing/selftests/wireguard/netns.sh | 15 +++-
 11 files changed, 170 insertions(+), 105 deletions(-)

-- 
2.30.1

