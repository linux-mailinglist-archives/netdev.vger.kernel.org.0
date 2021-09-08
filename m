Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399E94038B9
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 13:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351470AbhIHL2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 07:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235210AbhIHL2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 07:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABE67610C8;
        Wed,  8 Sep 2021 11:27:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="I/1fwZMJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1631100444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a1wqLRAjQGQbL5Ky9793jaFJYPOWY+qCKsygcQkNMnU=;
        b=I/1fwZMJdlrivF4T0fRC+1O8hYK77EBb2N4NVvyYGHbPX8WW1XKimJmPWjQ7c9rYqIYXtc
        ZgdnSOcycX6q2wF80uwkilKf8cHvqF+Qd5pdkABP+3FGm8Y4g4/qnRdFm7tqonj7DBTxa7
        8jCybFdXdgE5h0Hq2vpJfPM57S5HPyc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bfbfb799 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 8 Sep 2021 11:27:24 +0000 (UTC)
Received: by mail-yb1-f173.google.com with SMTP id r4so3530254ybp.4;
        Wed, 08 Sep 2021 04:27:24 -0700 (PDT)
X-Gm-Message-State: AOAM531F1dtzf5fsfT+IlIaQXjP5WJv9CtDkoT8SYP7gLvcS9K0l6Y7+
        cCPI3LpLOkvE9BZ+/Aa4Q7kCJYVgxgW8w7AbLPU=
X-Google-Smtp-Source: ABdhPJyc9K7c0UeY7LWpa1WLVs/jCnQb0RO0Eqvco1gj6mJUZ1r2lBZUnhai4+U1VSXRFVL2ey1jYQX9WDYgY2Tv5mc=
X-Received: by 2002:a25:938d:: with SMTP id a13mr4754369ybm.62.1631100442956;
 Wed, 08 Sep 2021 04:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210806044315.169657-1-someguy@effective-light.com> <OD24ZQ.IQOQXX8U0YST@effective-light.com>
In-Reply-To: <OD24ZQ.IQOQXX8U0YST@effective-light.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 8 Sep 2021 13:27:12 +0200
X-Gmail-Original-Message-ID: <CAHmME9oSo=4BtfO+=327n=gsor5gWcvhzAMS_BpqQ-6=6yxVRA@mail.gmail.com>
Message-ID: <CAHmME9oSo=4BtfO+=327n=gsor5gWcvhzAMS_BpqQ-6=6yxVRA@mail.gmail.com>
Subject: Re: [PATCH] wireguard: convert index_hashtable and pubkey_hashtable
 into rhashtables
To:     someguy@effective-light.com
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hamza,

Thanks for this patch. I have a few concerns/questions about it:

- What's performance like? Does the abstraction of rhashtable
introduce overhead? These are used in fast paths -- for every packet
-- so being quick is important.

- How does this interact with the timing side channel concerns in the
comment of the file? Will the time required to find an unused index
leak the number of items in the hash table? Do we need stochastic
masking? Or is the construction of rhashtable such that we always get
ball-park same time?

Thanks,
Jason
