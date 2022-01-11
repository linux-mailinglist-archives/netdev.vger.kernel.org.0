Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4DC48AEDA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 14:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241107AbiAKNty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 08:49:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33974 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240964AbiAKNtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 08:49:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A295B81A8F;
        Tue, 11 Jan 2022 13:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C7C36AEB;
        Tue, 11 Jan 2022 13:49:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BsvqS/6i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1641908988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGdyaSA4unTed96pEkTkPEo6fhaUILE2qaTzi95OoUw=;
        b=BsvqS/6iIndVAioMFsu7NeJYcidazR5lGw1AyflFatkTBO/+TG189Aay+2keu8JjPH4dnM
        xuv5DYkQhyMw9iLAscm1Qwj1CFNToX/wtHh3gksyUseb994Em0t8XqfVYeYJ6DrUBkR9d6
        BFcM4/SIKxeoxTJ+ez6k7i0kHtXf7Gs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b462ade0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 11 Jan 2022 13:49:48 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, geert@linux-m68k.org, tytso@mit.edu,
        gregkh@linuxfoundation.org, jeanphilippe.aumasson@gmail.com,
        ardb@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH crypto 0/2] smaller blake2s code size on m68k and other small platforms
Date:   Tue, 11 Jan 2022 14:49:32 +0100
Message-Id: <20220111134934.324663-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
References: <CAHmME9qbnYmhvsuarButi6s=58=FPiti0Z-QnGMJ=OsMzy1eOg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Geert emailed me this afternoon concerned about blake2s codesize on m68k
and other small systems. We identified two extremely effective ways of
chopping down the size. One of them moves some wireguard-specific things
into wireguard proper. The other one adds a slower codepath for
CONFIG_CC_OPTIMIZE_FOR_SIZE configurations. I really don't like that
slower codepath, but since it is configuration gated, at least it stays
out of the way except for people who know they need a tiny kernel image

Thanks,
Jason

Jason A. Donenfeld (2):
  lib/crypto: blake2s-generic: reduce code size on small systems
  lib/crypto: blake2s: move hmac construction into wireguard

 drivers/net/wireguard/noise.c | 45 ++++++++++++++++++++++++++++++-----
 include/crypto/blake2s.h      |  3 ---
 lib/crypto/blake2s-generic.c  | 30 +++++++++++++----------
 lib/crypto/blake2s-selftest.c | 31 ------------------------
 lib/crypto/blake2s.c          | 37 ----------------------------
 5 files changed, 57 insertions(+), 89 deletions(-)

-- 
2.34.1

