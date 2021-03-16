Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABDB33D237
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhCPK5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:57:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236878AbhCPK4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:56:35 -0400
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615892191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=INoRzHytORcFF318cgFlEmF9yFvH62+Uzf6e2/NCyl0=;
        b=w7nQn9wRkTuVsLAN8RR2kmndEtEnruYpbi2GGQ20bOobqxPJ6UeHBrmZLhbj3RVfIeruO1
        gyTDknu1tW5Byf4Uh5hodvYKy6umho6ZTB7Cao3MeAiNm62/YlNW2tSLr+Tyz2k7tLBnDx
        7Ip5MMbc+np0Yxl/GROyoSCZAh6j2yIyM+8Y8iA5BH54PxT4SV4tFI+CitD0gjWm7GPUQS
        laaZe21xt0oX5OCumM9uIYkxYsrz6x0gEYLlGnIWT2vUHqldYNEIJ+c/hG57HgSDc4jbnB
        n0D1sX2XaIAB6ADQUzhCuQZH6iqa5DpwrTnA8+XHzXfG/4se9OfazmqmPGr2aA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615892191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=INoRzHytORcFF318cgFlEmF9yFvH62+Uzf6e2/NCyl0=;
        b=0LuQVMQRUKRody594oJt6NVMtuP1VRFd0y2z3BYZblC11VrCdPseXyLPaM3m7H1QsniTmR
        BMiDykJK24uvJ8DA==
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <sebastian.siewior@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v1 0/2] net: xfrm: Use seqcount_spinlock_t
Date:   Tue, 16 Mar 2021 11:56:28 +0100
Message-Id: <20210316105630.1020270-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a small series to trasform xfrm_state_hash_generation sequence
counter to seqcount_spinlock_t, instead of plain seqcount_t.

In general, seqcount_LOCKNAME_t sequence counters allows to associate
the lock used for write serialization with the seqcount. This enables
lockdep to verify that the write serialization lock is always held
before entering the seqcount write section.

If lockdep is disabled, this lock association is compiled out and has
neither storage size nor runtime overhead.

The first patch is a general mainline fix, and has a Fixes tag.

Thanks,

8<----------

Ahmed S. Darwish (2):
  net: xfrm: Localize sequence counter per network namespace
  net: xfrm: Use sequence counter with associated spinlock

 include/net/netns/xfrm.h |  4 +++-
 net/xfrm/xfrm_state.c    | 11 ++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

base-commit: 1e28eed17697bcf343c6743f0028cc3b5dd88bf0
--
2.30.2
