Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242AF48B56B
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242664AbiAKSKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbiAKSKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 13:10:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB96CC06173F;
        Tue, 11 Jan 2022 10:10:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B5A61243;
        Tue, 11 Jan 2022 18:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB07C36AE9;
        Tue, 11 Jan 2022 18:10:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kHJKk0M1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641924651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TcLFMr0ORzl74yoB9aAnSVhN8g+ePL3bE8WfceccoNc=;
        b=kHJKk0M1CvupLsq+a7MQZPfeqBeBb9rZ9HkorNwEg6F+lo8uG4VovY+Vg4roTmHTp72r+/
        pbjdUIoMiinFw+v2jmLqqEw1eLnVNEI95/mfYPFS17MMXB4XZ1yjHPYTwU/UvSozyY3j4Q
        vDNucOiesSmaVn3nJzNq5wW0GmVPrQ8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 498a0ec0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 11 Jan 2022 18:10:50 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH crypto v2 0/2] reduce code size from blake2s on m68k and other small platforms
Date:   Tue, 11 Jan 2022 19:10:35 +0100
Message-Id: <20220111181037.632969-1-Jason@zx2c4.com>
In-Reply-To: <20220111134934.324663-1-Jason@zx2c4.com>
References: <20220111134934.324663-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Geert emailed me this afternoon concerned about blake2s codesize on m68k
and other small systems. We identified two effective ways of chopping
down the size. One of them moves some wireguard-specific things into
wireguard proper. The other one adds a slower codepath for small
machines to blake2s. This worked, and was v1 of this patchset, but I
wasn't so much of a fan. Then someone pointed out that the generic C
SHA-1 implementation is still unrolled, which is a *lot* of extra code.
Simply rerolling that saves about as much as v1 did. So, we instead do
that in this v2 patchset. SHA-1 is being phased out, and soon it won't
be included at all (hopefully). And nothing performance-oriented has
anything to do with it anyway.

The result of these two patches mitigates Geert's feared code size
increase for 5.17.

Thanks,
Jason


Jason A. Donenfeld (2):
  lib/crypto: blake2s: move hmac construction into wireguard
  lib/crypto: sha1: re-roll loops to reduce code size

 drivers/net/wireguard/noise.c |  45 +++++++++++--
 include/crypto/blake2s.h      |   3 -
 lib/crypto/blake2s-selftest.c |  31 ---------
 lib/crypto/blake2s.c          |  37 -----------
 lib/sha1.c                    | 117 ++++++++--------------------------
 5 files changed, 64 insertions(+), 169 deletions(-)

-- 
2.34.1

