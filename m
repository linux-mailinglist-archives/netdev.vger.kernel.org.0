Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF115696EB
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiGGAcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiGGAcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:32:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EAE20BFF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3B961FEF
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C18C3411C;
        Thu,  7 Jul 2022 00:32:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="AozkOVS7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657153940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qHdpSDdw2jqyJRBieI/R5aCWbapNMF6w1+2zGv5IWK0=;
        b=AozkOVS7sZtWXllPblfWDhtQm+/hpiFDLFd2OsgZG04aeVgKS6u3cl8BcOFm3Y7t8XtzXp
        0FkGyd7npEPwnWf0TX/quzvuOOwXv53qsnSuSZp9DVdnkkaBenkiUX8x8m4OvE9EvTuu9a
        Qy9P0JXxp5QBWIMxQ+QcM3Y/c9MqhjE=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4239a9c5 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 7 Jul 2022 00:32:19 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/6] wireguard patches for 5.19-rc6
Date:   Thu,  7 Jul 2022 02:31:51 +0200
Message-Id: <20220707003157.526645-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Davekubablo,

Please apply the following fixes for 5.19-rc6:

1) A few small fixups to the selftests, per usual. Of particular note is
   a fix for a test flake that occurred on especially fast systems that
   boot in less than a second.

2) An addition during this cycle of some s390 crypto interacted with the
   way wireguard selects dependencies, resulting in linker errors
   reported by the kernel test robot. So Vladis sent in a patch for
   that, which also required a small preparatory fix moving some Kconfig
   symbols around.

Thanks,
Jason


Jason A. Donenfeld (5):
  wireguard: selftests: set fake real time in init
  wireguard: selftests: use virt machine on m68k
  wireguard: selftests: always call kernel makefile
  wireguard: selftests: use microvm on x86
  crypto: s390 - do not depend on CRYPTO_HW for SIMD implementations

Vladis Dronov (1):
  wireguard: Kconfig: select CRYPTO_CHACHA_S390

 crypto/Kconfig                                | 114 +++++++++++++++++
 drivers/crypto/Kconfig                        | 115 ------------------
 drivers/net/Kconfig                           |   1 +
 .../testing/selftests/wireguard/qemu/Makefile |  20 +--
 .../selftests/wireguard/qemu/arch/arm.config  |   1 +
 .../wireguard/qemu/arch/armeb.config          |   1 +
 .../selftests/wireguard/qemu/arch/i686.config |   8 +-
 .../selftests/wireguard/qemu/arch/m68k.config |  10 +-
 .../selftests/wireguard/qemu/arch/mips.config |   1 +
 .../wireguard/qemu/arch/mipsel.config         |   1 +
 .../wireguard/qemu/arch/powerpc.config        |   1 +
 .../wireguard/qemu/arch/x86_64.config         |   7 +-
 tools/testing/selftests/wireguard/qemu/init.c |  11 ++
 13 files changed, 157 insertions(+), 134 deletions(-)

-- 
2.35.1

