Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CC018A9CC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgCSAau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:50 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:50 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 113907c2;
        Thu, 19 Mar 2020 00:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=ADT2x3MfY9Do41eWJ+yA+zzB9zo=; b=gFBKUMTMLQSgVml5n1KG
        k/xt0gg2HJJra4M8WoeifHtwPdE3fyNhr52K3HqBsxPWyAtJHTQjfwS4iuDoPT/L
        jd3nv4HGOM/EfcLRybeaBkL2X7GaV9JFIb6IdIhZ4dgKI5EN3Rh58LYiPnlC63WZ
        RY9ivvwouI/EsguYrxFIDlc3pvHLxq0kjiN7rCn5nX0sMsb5tkASpm2KRbIYK0Gm
        auoSRpLkNsW84pk3qowmkfkQuPqMHCgmjKn3QnNw6S9hrXiNKBVdyebEvTL82tmC
        eqMdEqs/vNfU5V8seuN/UytlYXUJnz502Kdkf31NY7/4iGAVwTM9uEaQLddeRJDA
        ZQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7c14b63d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:24 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/5] wireguard fixes for 5.6-rc7
Date:   Wed, 18 Mar 2020 18:30:42 -0600
Message-Id: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

I originally intended to spend this cycle working on fun optimizations
and architecture for WireGuard for 5.7, but I've been a bit neurotic
about having 5.6 ship without any show stopper bugs. WireGuard has been
stable for a long time now, but that doesn't make me any less nervous
about the real deal in 5.6. To that end, I've been doing code reviews
and having discussions, and we also had a security firm audit the code.
That audit didn't turn up any vulnerabilities, but they did make a good
defense-in-depth suggestion. This series contains:

1) Removal of a duplicated header, from YueHaibing.
2) Testing with 64-bit time in our test suite.
3) Account for skb->protocol==0 due to AF_PACKET sockets, suggested
   by Florian Fainelli.
4) Clean up some code in an unreachable switch/case branch, suggested
   by Florian Fainelli.
5) Better handling of low-order points, discussed with Mathias
   Hall-Andersen.

Thanks,
Jason

Jason A. Donenfeld (4):
  wireguard: selftests: test using new 64-bit time_t
  wireguard: queueing: account for skb->protocol==0
  wireguard: receive: remove dead code from default packet type case
  wireguard: noise: error out precomputed DH during handshake rather
    than config

YueHaibing (1):
  wireguard: selftests: remove duplicated include <sys/types.h>

 drivers/net/wireguard/device.c                |  2 +-
 drivers/net/wireguard/netlink.c               |  8 +--
 drivers/net/wireguard/noise.c                 | 55 ++++++++++---------
 drivers/net/wireguard/noise.h                 | 12 ++--
 drivers/net/wireguard/peer.c                  |  7 +--
 drivers/net/wireguard/queueing.h              |  8 ++-
 drivers/net/wireguard/receive.c               |  7 +--
 tools/testing/selftests/wireguard/netns.sh    |  6 --
 .../testing/selftests/wireguard/qemu/Makefile |  2 +-
 tools/testing/selftests/wireguard/qemu/init.c |  1 -
 .../selftests/wireguard/qemu/kernel.config    |  1 -
 11 files changed, 51 insertions(+), 58 deletions(-)

-- 
2.25.1

