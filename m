Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23437462041
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhK2TXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350946AbhK2TVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:21:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95172C061191
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:39:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E1E3ACE12FD
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 15:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDD0C53FAD;
        Mon, 29 Nov 2021 15:39:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IiHilm6m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638200381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vg8cBIgEKcsZAIxv08JYqcHCDn7mzWJPmsUn31Jwvbc=;
        b=IiHilm6mKOCVtQdP6yrRcpcUHrANDd27l8JxeR95hwmxYUSWxL2oPAHCfecrlacsKYydIP
        ZcQDLcWd6XczWthjtBQIgHpFLDjtHjaEgOf35lHLNl9oRe7B2KzLy2U1ENHKVVoLgkPRvh
        eBY4hA1P5IT4IP814ehNKV58LMgDiLY=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id e9c22735 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Mon, 29 Nov 2021 15:39:41 +0000 (UTC)
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

