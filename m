Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706A02D6DE0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 03:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391634AbgLKB70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 20:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389680AbgLKB7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:59:09 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A77C0613D3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:29 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c12so4505534pll.12
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=X3AoiKidQ6crGHD5wFDjzqhurb9cqFSlsgkfzt0x/6g=;
        b=rbpEnMrvqzGoVBNEIxdvmt42OVp8gS2HseDuthH7KFwBY5/+swso8bllcGKBG5An1L
         TUglQYQE+3XhjiQuyEFRwqrPUOujWVnEclYdpKlUp7pCuhIiFjeoYVg0XvsstAkgxC2t
         XrAVUToqYXxT+Ee0H0V50oxqPrfEDXVPSt/FXpese/7yWEuSvWHUJaMILffHwRKiy/e7
         KTaLsUDvU1rlfk6Z8Yd+82HK7spF6UWrh1Tp+GsQs8DkLR6z6+kM2m6NZpps5xetM06W
         kqzG4Jj+a5dteYxsTf6kTNEWwJJimL1bpOrMuJrlK6BE46MpknEqHgHyOuuBqwwbwHwR
         iRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=X3AoiKidQ6crGHD5wFDjzqhurb9cqFSlsgkfzt0x/6g=;
        b=pfG7ivO5+avletEpTzBYS59g5gPn2u0FbfABmaSxV4D75Ya8L7t5LCQwEzFL1nHuhF
         tPMobYnA/zlGyWIDMNTdEdMNb7wU9jrHf0TtEjJfnP0/qw9jP88VA84MnPPRosaMpEs0
         41c7vrxFKxLpoUArKioIS4iTz8PR1avpKDPUx0tlNKFxnb3anK5jADCupqVMBVgeMc2t
         OM3rCaFd7ITuGQvE/sZjYCglOvAyzYTJ4y5XF5zwirGWbQS6ip2+qXPXQQa8hU8+uRbJ
         aMLGl/i1EaTqnV9TRtQrUEUqmoqEsH0npXJ/+yZKL2tnlWCtt+TBW9ysiZwBQQ+D2ENJ
         eZJA==
X-Gm-Message-State: AOAM532s0AgZBRBc8k90kkQTnLMVTvqAO5IrFQPQ/GYSFJ4OixTN6D3E
        Y4xq1+3ayZ+HVn9H9EKamZv8pO+fp9H2
X-Google-Smtp-Source: ABdhPJybdXTxqR8G4ayNenBgynQQS10dU1MLFcc27pOkmymWS6fT/KQpiZH311OrIaDRhnBkIpfxy4Ssx2Av
Sender: "brianvv via sendgmr" <brianvv@brianvv.c.googlers.com>
X-Received: from brianvv.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:348])
 (user=brianvv job=sendgmr) by 2002:a17:902:e904:b029:db:c0d6:5823 with SMTP
 id k4-20020a170902e904b02900dbc0d65823mr8660082pld.11.1607651909009; Thu, 10
 Dec 2020 17:58:29 -0800 (PST)
Date:   Fri, 11 Dec 2020 01:58:19 +0000
Message-Id: <20201211015823.1079574-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH net-next 0/4] net: avoid indirect calls in dst functions
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: brianvv <brianvv@google.com>

Use of the indirect call wrappers in some dst related functions for the
ipv6/ipv4 case. This is a small improvent for CONFIG_RETPOLINE=y

brianvv (4):
  net: use indirect call helpers for dst_input
  net: use indirect call helpers for dst_output
  net: use indirect call helpers for dst_mtu
  net: indirect call helpers for ipv4/ipv6 dst_check functions

 include/net/dst.h   | 25 +++++++++++++++++++++----
 net/core/sock.c     | 12 ++++++++++--
 net/ipv4/route.c    | 12 ++++++++----
 net/ipv4/tcp_ipv4.c |  5 ++++-
 net/ipv6/route.c    | 12 ++++++++----
 net/ipv6/tcp_ipv6.c |  5 ++++-
 6 files changed, 55 insertions(+), 16 deletions(-)

-- 
2.29.2.576.ga3fc446d84-goog

