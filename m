Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F363051AF13
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357414AbiEDUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242751AbiEDUdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4F64F9CE
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 13:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C9C8B828CD
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E5BC385AE;
        Wed,  4 May 2022 20:29:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HBgiE5KT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1651696175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5PXs2wNlsE2Uo3SL/braZDq1A/QPnoFzvJrwCKxxC2c=;
        b=HBgiE5KT3zdZAtvlC2JneeCzyVPP1eSOuDBuPKEJfDA1V5t3idAgREvnpAu1eXIvxDbImU
        /LLSJl5UZiy5ROVx+/CTtP1+5IvwxGXtEf+o3HoFy2L0KlCzAfGZKUXbY1tJzbZKChfSA9
        TSmELL2RVO4ea+WEe2gu9zqJKvE8Hqw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id af991ffa (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 4 May 2022 20:29:34 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/6] wireguard patches for 5.18-rc6
Date:   Wed,  4 May 2022 22:29:14 +0200
Message-Id: <20220504202920.72908-1-Jason@zx2c4.com>
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

Hi,

In working on some other problems, I wound up leaning on the WireGuard
CI more than usual and uncovered a few small issues with reliability.
These are fairly low key changes, since they don't impact kernel code
itself.

One change does stick out in particular, though, which is the "make
routing loop test non-fatal" commit. I'm not thrilled about doing this,
but currently [1] remains unsolved, and I'm still working on a real
solution to that (hopefully for 5.19 or 5.20 if I can come up with a
good idea...), so for now that test just prints a big red warning
instead.

Thanks,
Jason

[1] https://lore.kernel.org/netdev/YmszSXueTxYOC41G@zx2c4.com/


Jason A. Donenfeld (6):
  wireguard: selftests: make routing loop test non-fatal
  wireguard: selftests: limit parallelism to $(nproc) tests at once
  wireguard: selftests: use newer toolchains to fill out architectures
  wireguard: selftests: restore support for ccache
  wireguard: selftests: bump package deps
  wireguard: selftests: set panic_on_warn=1 from cmdline

 tools/testing/selftests/wireguard/netns.sh    |  34 ++-
 .../selftests/wireguard/qemu/.gitignore       |   1 +
 .../testing/selftests/wireguard/qemu/Makefile | 205 ++++++++++++------
 .../wireguard/qemu/arch/aarch64.config        |   5 +-
 .../wireguard/qemu/arch/aarch64_be.config     |   5 +-
 .../selftests/wireguard/qemu/arch/arm.config  |   5 +-
 .../wireguard/qemu/arch/armeb.config          |   5 +-
 .../selftests/wireguard/qemu/arch/i686.config |   2 +-
 .../selftests/wireguard/qemu/arch/m68k.config |   2 +-
 .../selftests/wireguard/qemu/arch/mips.config |   2 +-
 .../wireguard/qemu/arch/mips64.config         |   2 +-
 .../wireguard/qemu/arch/mips64el.config       |   2 +-
 .../wireguard/qemu/arch/mipsel.config         |   2 +-
 .../wireguard/qemu/arch/powerpc.config        |   2 +-
 .../wireguard/qemu/arch/powerpc64.config      |  13 ++
 .../wireguard/qemu/arch/powerpc64le.config    |   2 +-
 .../wireguard/qemu/arch/riscv32.config        |  12 +
 .../wireguard/qemu/arch/riscv64.config        |  12 +
 .../wireguard/qemu/arch/s390x.config          |   6 +
 .../wireguard/qemu/arch/x86_64.config         |   2 +-
 tools/testing/selftests/wireguard/qemu/init.c |   6 -
 21 files changed, 228 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/powerpc64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv32.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/riscv64.config
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/s390x.config

-- 
2.35.1

