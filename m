Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9D448C477
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353406AbiALNM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353385AbiALNMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 08:12:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627DFC06173F;
        Wed, 12 Jan 2022 05:12:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20E36B81EC6;
        Wed, 12 Jan 2022 13:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024AEC36AEA;
        Wed, 12 Jan 2022 13:12:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="duvHyM0s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641993135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Mk0o4WEVS4MFMzcuEtCDSmeOAzPRDrri9N4SlRDKulo=;
        b=duvHyM0s1YPHtopApK9fAZHiSE2uyvmgczs8AZjbiHOXijWEYYEP60x/Tn7Bs1SZhTMWHP
        8hCHVu8oA7SW1FGODnSV1jaZbW2F2YTrvfplBmpKNDj4kRRJB+ssFnKNkkncg5o0SdjH1n
        5UiWbH8BWx3sjjjl1jDpB+kgS/a437E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 543ffb56 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 12 Jan 2022 13:12:15 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH RFC v1 0/3] remove remaining users of SHA-1
Date:   Wed, 12 Jan 2022 14:12:01 +0100
Message-Id: <20220112131204.800307-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

There are currently two remaining users of SHA-1 left in the kernel: bpf
tag generation, and ipv6 address calculation. In an effort to reduce
code size and rid ourselves of insecure primitives, this RFC patchset
moves to using the more secure BLAKE2s function. I wanted to get your
feedback on how feasible this patchset is, and if there is some
remaining attachment to SHA-1, why exactly, and what could be done to
mitigate it. Rather than sending a mailing list post just asking, "what
do you think?" I figured it'd be easier to send this as an RFC patchset,
so you see specifically what I mean.

Thoughts? Comments?

Thanks,
Jason

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: linux-crypto@vger.kernel.org

Jason A. Donenfeld (3):
  bpf: move from sha1 to blake2s in tag calculation
  ipv6: move from sha1 to blake2s in address calculation
  crypto: sha1_generic - import lib/sha1.c locally

 crypto/sha1_generic.c | 114 +++++++++++++++++++++++++++++++++++
 include/crypto/sha1.h |  10 ---
 kernel/bpf/core.c     |  39 ++----------
 lib/Makefile          |   2 +-
 lib/sha1.c            | 137 ------------------------------------------
 net/ipv6/addrconf.c   |  31 +++-------
 6 files changed, 128 insertions(+), 205 deletions(-)
 delete mode 100644 lib/sha1.c

-- 
2.34.1

