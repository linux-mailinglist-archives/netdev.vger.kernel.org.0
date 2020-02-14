Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 995DC15FA05
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 23:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgBNW5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 17:57:32 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:36023 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727811AbgBNW5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 17:57:32 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f846fd0f;
        Fri, 14 Feb 2020 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=06+yMhbdxeYZJncgZWh5JeOSc3g=; b=3icJgGR/IqTwuGfRikki
        dHIL7oA5331FFtNTfCsM7ER0XDC6xM4b5j1axYnrgFMClup7xyNSna6pGtdje0WV
        TLI98zzKLyj8GRcV8vRzyJQ0+fLTI91JWIbFEH+pBcE9ET11GCwDKqOnTGHSJpkx
        I7OUdKZ4ZoSWCfTtObTMRx00cVfCh4l55hEh+KI1J1aS1S0kxnfUOjxQPsws+VZn
        yyiURQHWP3fb8c4ui80d5Rurg1XZI6HlRy+pcb3pFugjDDOY0VBKaUjC+xlhXQx0
        bLWf7bllBC+1I7UvuTijbv8tIJP5NwD8Wfp18TRN6yjC3R8tZ1+zeajzdDHw5cyH
        Xw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75cb62ee (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 22:55:21 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v3 net 0/4] wireguard fixes for 5.6-rc2
Date:   Fri, 14 Feb 2020 23:57:19 +0100
Message-Id: <20200214225723.63646-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are four fixes for wireguard collected since rc1:

1) Some small cleanups to the test suite to help massively parallel
   builds.

2) A change in how we reset our load calculation to avoid a more
   expensive comparison, suggested by Matt Dunwoodie.

3) I've been loading more and more of wireguard's surface into
   syzkaller, trying to get our coverage as complete as possible,
   leading in this case to a fix for mtu=0 devices.

4) A removal of superfluous code, pointed out by Eric Dumazet.

v2 fixes a logical problem in the patch for (3) pointed out by Eric Dumazet. v3
replaces some non-obvious bitmath in (3) with a more obvious expression, and
adds patch (4).

Jason A. Donenfeld (4):
  wireguard: selftests: reduce complexity and fix make races
  wireguard: receive: reset last_under_load to zero
  wireguard: send: account for mtu=0 devices
  wireguard: socket: remove extra call to synchronize_net

 drivers/net/wireguard/device.c                |  7 ++--
 drivers/net/wireguard/receive.c               |  7 +++-
 drivers/net/wireguard/send.c                  | 16 +++++---
 drivers/net/wireguard/socket.c                |  1 -
 .../testing/selftests/wireguard/qemu/Makefile | 38 +++++++------------
 5 files changed, 34 insertions(+), 35 deletions(-)

-- 
2.25.0

