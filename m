Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFED587CB6
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiHBM43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiHBM42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:56:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35B2D114
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:56:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 684B7B81EF9
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9033DC433D6;
        Tue,  2 Aug 2022 12:56:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nQSMaaSe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659444983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nVH3DB2uvTZXSm4IzKMDDge+S5Pwp5kKvNBXk3fJmVM=;
        b=nQSMaaSelHIDiD0v3CF5HM2pxGsZbZCNgD644R/687sflFjjvRxN414icAL44f1HjqO+fv
        SNYScrzxwRjJyhjeFlnl2T7xlrDmwZ4iclmLDH5Ig3HTKFMJ8bYwXXrteDz2w+EdsoWD3t
        JPAb0vHYvFUh5dnpwZ8dv/t3H/53JL4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2a771cb3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 2 Aug 2022 12:56:22 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH next-next 0/4] wireguard patches for 5.20-rc1
Date:   Tue,  2 Aug 2022 14:56:09 +0200
Message-Id: <20220802125613.340848-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

I had planned to send these out eventually as net.git patches, but as
you emailed earlier, I figure there's no harm in just doing this now for
net-next.git. Please apply the following small fixes:

1) Rather than using msleep() in order to approximate ktime_get_coarse_
   boottime_ns(), instead use an hrtimer, rounded heuristically.

2) An update in selftest config fragments, from Lukas.

3) Linus noticed that a debugging WARN_ON() to detect (impossible) stack
   corruption would still allow the corruption to happen, making it harder
   to get the report about the corruption subsequently.

4) Support for User Mode Linux in the test suite. This depends on some
   UML patches that are slated for 5.20. Richard hasn't sent his pull
   in, but they're in his tree, so I assume it'll happen.

Thanks,
Jason

Jason A. Donenfeld (3):
  wireguard: ratelimiter: use hrtimer in selftest
  wireguard: allowedips: don't corrupt stack when detecting overflow
  wireguard: selftests: support UML

Lukas Bulwahn (1):
  wireguard: selftests: update config fragments

 drivers/net/wireguard/allowedips.c            |  9 ++++---
 drivers/net/wireguard/selftest/allowedips.c   |  6 ++---
 drivers/net/wireguard/selftest/ratelimiter.c  | 25 +++++++++++--------
 kernel/time/hrtimer.c                         |  1 +
 .../testing/selftests/wireguard/qemu/Makefile | 17 ++++++++++++-
 .../selftests/wireguard/qemu/arch/um.config   |  3 +++
 .../selftests/wireguard/qemu/debug.config     |  5 ----
 .../selftests/wireguard/qemu/kernel.config    |  1 -
 8 files changed, 43 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/um.config

-- 
2.35.1

