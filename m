Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8C4461D02
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbhK2Rxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:53:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43090 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhK2Rvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:51:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69087B80EB9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B6DC53FAD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:48:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DntUElb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638208098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vg8cBIgEKcsZAIxv08JYqcHCDn7mzWJPmsUn31Jwvbc=;
        b=DntUElb5I/TQl6IRBWSivu8SbksVIxS+5wOkOKGW//naS3+GJRBoGmh+zVsTollC0Mqon9
        y2kDllGBWxBh1y1WgX1LRFhHEVbY5id9+Q4NkoPDD3EpdsvoFSy5qMOqY0pk2hkGlVV8ua
        OcnfIclYTRhgS869/Elr3JOKtc2darI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 215db00a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 17:48:18 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 00/10] wireguard/siphash patches for 5.16-rc6
Date:   Mon, 29 Nov 2021 10:39:19 -0500
Message-Id: <20211129153929.3457-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub,

Here's quite a largeish set of stable patches I've had queued up and
testing for a number of months now:

  - Patch (1) squelches a sparse warning by fixing an annotation.
  - Patches (2), (3), and (5) are minor improvements and fixes to the
    test suite.
  - Patch (4) is part of a tree-wide cleanup to have module-specific
    init and exit functions.
  - Patch (6) fixes a an issue with dangling dst references, by having a
    function to release references immediately rather than deferring,
    and adds an associated test case to prevent this from regressing.
  - Patches (7) and (8) help mitigate somewhat a potential DoS on the
    ingress path due to the use of skb_list's locking hitting contention
    on multiple cores by switching to using a ring buffer and dropping
    packets on contention rather than locking up another core spinning.
  - Patch (9) switches kvzalloc to kvcalloc for better form.
  - Patch (10) fixes alignment traps in siphash with clang-13 (and maybe
    other compilers) on armv6, by switching to using the unaligned
    functions by default instead of the aligned functions by default.

Thanks,
Jason

Arnd Bergmann (1):
  siphash: use _unaligned version by default

Gustavo A. R. Silva (1):
  wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Jason A. Donenfeld (6):
  wireguard: allowedips: add missing __rcu annotation to satisfy sparse
  wireguard: selftests: increase default dmesg log size
  wireguard: selftests: actually test for routing loops
  wireguard: device: reset peer src endpoint when netns exits
  wireguard: receive: use ring buffer for incoming handshakes
  wireguard: receive: drop handshakes if queue lock is contended

Li Zhijian (1):
  wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST

Randy Dunlap (1):
  wireguard: main: rename 'mod_init' & 'mod_exit' functions to be
    module-specific

 drivers/net/wireguard/allowedips.c            |  2 +-
 drivers/net/wireguard/device.c                | 39 ++++++++++---------
 drivers/net/wireguard/device.h                |  9 ++---
 drivers/net/wireguard/main.c                  |  8 ++--
 drivers/net/wireguard/queueing.c              |  6 +--
 drivers/net/wireguard/queueing.h              |  2 +-
 drivers/net/wireguard/ratelimiter.c           |  4 +-
 drivers/net/wireguard/receive.c               | 39 +++++++++++--------
 drivers/net/wireguard/socket.c                |  2 +-
 include/linux/siphash.h                       | 14 ++-----
 include/net/dst_cache.h                       | 11 ++++++
 lib/siphash.c                                 | 12 +++---
 net/core/dst_cache.c                          | 19 +++++++++
 tools/testing/selftests/wireguard/netns.sh    | 30 +++++++++++++-
 .../selftests/wireguard/qemu/debug.config     |  2 +-
 .../selftests/wireguard/qemu/kernel.config    |  1 +
 16 files changed, 129 insertions(+), 71 deletions(-)

-- 
2.34.1

