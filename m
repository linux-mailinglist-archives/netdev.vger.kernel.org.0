Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B125BAF76
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 16:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiIPOiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 10:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiIPOh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 10:37:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAC4B2848
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 07:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE69B82782
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 14:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F242BC433D6;
        Fri, 16 Sep 2022 14:37:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IG52wGiT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663339073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EqxUU8srYM8AxvnyJq7oLNg9aK+p/iVJDzhFLIx+fpw=;
        b=IG52wGiTAWs/wo6Mz2wGSrl93Dk/L/gbAw5KcIqL5PscfB+SDoxG+0veUOXCKwpNQSZMQa
        8PUGt5Cm64Fwsexbl62bvmphVZTJ8mVXus46ptf8wJQ+ks4LwF/y7sudhUH7oO9qFWsqt9
        B0/SnyOiOzLygyE4vSLtlnr/OGUbpKA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 87e98913 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 16 Sep 2022 14:37:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/3] wireguard patches for 6.0-rc6
Date:   Fri, 16 Sep 2022 15:37:37 +0100
Message-Id: <20220916143740.831881-1-Jason@zx2c4.com>
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

Hey guys,

Sorry we didn't get a chance to talk at Plumbers. I saw some of you very
briefly in passing but never had the opportunity to chat. Next time, I
hope.

Please pull the following fixes:

1) The ratelimiter timing test doesn't help outside of development, yet
   it is currently preventing the module from being inserted on some
   kernels when it flakes at insertion time. So we disable it.

2) A fix for a build error on UML, caused by a recent change in a
   different tree.

3) A WARN_ON() is triggered by Kees' new fortified memcpy() patch, due
   to memcpy()ing over a sockaddr pointer with the size of a
   sockaddr_in[6]. The type safe fix is pretty simple. Given how classic
   of a thing sockaddr punning is, I suspect this may be the first in a
   few patches like this throughout the net tree, once Kees' fortify
   series is more widely deployed (current it's just in next).

Thanks,
Jason

Jason A. Donenfeld (3):
  wireguard: ratelimiter: disable timings test by default
  wireguard: selftests: do not install headers on UML
  wireguard: netlink: avoid variable-sized memcpy on sockaddr

 drivers/net/wireguard/netlink.c               | 13 +++++-----
 drivers/net/wireguard/selftest/ratelimiter.c  | 25 ++++++++-----------
 .../testing/selftests/wireguard/qemu/Makefile |  2 ++
 3 files changed, 18 insertions(+), 22 deletions(-)

-- 
2.37.3

