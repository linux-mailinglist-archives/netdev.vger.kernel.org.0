Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87ED48EB86
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiANOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiANOUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:20:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADD0C061574;
        Fri, 14 Jan 2022 06:20:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FF6461D0D;
        Fri, 14 Jan 2022 14:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479CBC36AE5;
        Fri, 14 Jan 2022 14:20:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Of2CtCO7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642170033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p73GT/WOIEJH2mM8NA3RLurQZTMni+o2wzFAvGzs/BI=;
        b=Of2CtCO7ODBOXhxJzAEn+WoBbYl0u+pO6pGwtBslsFhg4aDeAmh2ikSM5Aff8hGuZh11Hk
        uw7iqGI74SPQqXchCG4HoFGEtNzOZaTLUAsgYI+OFYrbTq1TIkJsQbsNk+Eg8GS6UaZe+V
        ATHmLo1f6B0OK2wnCKHeDjA2QmWX9pI=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 11951d38 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 14:20:32 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>, Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH RFC v2 0/3] remove remaining users of SHA-1
Date:   Fri, 14 Jan 2022 15:20:12 +0100
Message-Id: <20220114142015.87974-1-Jason@zx2c4.com>
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

Version 2 makes the ipv6 handling a bit cleaner and fixes a build
warning from the last commit. Since this is just an RFC-for-discussion,
there's not technically a need to be sending this, but from the looks of
it, a real solution here might involve a bit more heavy lifting, so I
wanted to at least get my latest on the list in case others want to play
around with solutions in this space too. Also, the original recipient
list was too narrow, so this v2 expands that a bit.

Thoughts? Comments?

Thanks,
Jason

Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Erik Kline <ek@google.com>
Cc: Fernando Gont <fgont@si6networks.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Lorenzo Colitti <lorenzo@google.com>

Jason A. Donenfeld (3):
  bpf: move from sha1 to blake2s in tag calculation
  ipv6: move from sha1 to blake2s in address calculation
  crypto: sha1_generic - import lib/sha1.c locally

 crypto/sha1_generic.c | 182 +++++++++++++++++++++++++++++++++++++
 include/crypto/sha1.h |  10 ---
 kernel/bpf/core.c     |  39 +-------
 lib/Makefile          |   2 +-
 lib/sha1.c            | 204 ------------------------------------------
 net/ipv6/addrconf.c   |  56 +++---------
 6 files changed, 201 insertions(+), 292 deletions(-)
 delete mode 100644 lib/sha1.c

-- 
2.34.1

