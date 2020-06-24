Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B220795C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404124AbgFXQmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390702AbgFXQmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:42:07 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAFCC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:06 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c5so1928501qtv.20
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fP96t1n1mOgaSAxA8U6zyJuH+feZFCop65adH08xTO0=;
        b=dUFha6owvrlR28hOYpPBUBa0tsPPffxvH69UuRXCKOd5x/9p5EcCP1UZkqWoQM2kgK
         wKyEf+Irto/GBWZMBoK6JKtRQZP8tk3cNGtQlUAKtJEmyUSanVaBynbGodKX4fOXs/xU
         nkNQ5BFT6h4bj7xGnKx0aAs8DlsVP9UyVVZ9zJb83rHTDmIPllQiVCDBkGLrodbaK09R
         X02MowJa8GltbqEUAKjXJR4fSeSgTXl++kjKCO8O9sMdKuFl1yaNFAzTVGk/UDV1/P5z
         Q5hWs8ig6GFWig5yxlKOPRcUO4WChjneFTNxp7iFm+Hg1BQqGAl2/AuXpnusmuzC/i9I
         Hpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fP96t1n1mOgaSAxA8U6zyJuH+feZFCop65adH08xTO0=;
        b=S7yAJVyIX2UTXbmj0MiflAq6aRHH9W1/O2o+v6gF8r5BMcCQQVKYOD4K1C/Q+wPCwJ
         FSoJP+0iyDlGrhx3stcdmPPra1j70NmWcUAN3jsQe+gWMihK/zBUnqpodL6tB4Tz0+3Y
         di6YvRXnN8sZoIInb3NdnGtOJU1rCWS4lwF79QhH6sm0X+oUKeMrAU724ceQ+xsmlqxW
         YjaZCrnL8GPaoui8yXjSaJONqaFXAzWYhEHodZcau3YCgNVdjsKRoTh82JvQM+r7KFHS
         GadgS4wdaE+602VYPHJecaNY7JuBt3UFkWuTcZdHb1AZT/JnbvtI6YYnBrdpWMyCk5tR
         Adjw==
X-Gm-Message-State: AOAM533kutD3yQfCQ39UgjMnkSt5Gxo6DGvefBtjxnqJiDrWAeQZbkuS
        6gI4Z9xxnajsZkuh3X2dXX6KvxI8T7X86Kc=
X-Google-Smtp-Source: ABdhPJwEKepMAGGMBZRugzeiwGxuPe2Ex0NPBydks91f74Ge+AstSOPpe32nUklAXkzXqlJCRDzJ3HZZtskZKmU=
X-Received: by 2002:ad4:4962:: with SMTP id p2mr31699028qvy.55.1593016925418;
 Wed, 24 Jun 2020 09:42:05 -0700 (PDT)
Date:   Wed, 24 Jun 2020 12:42:01 -0400
Message-Id: <20200624164203.183122-1-ncardwell@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH net 0/2] tcp_cubic: fix spurious HYSTART_DELAY on RTT decrease
From:   Neal Cardwell <ncardwell@google.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a long-standing bug in the TCP CUBIC
HYSTART_DELAY mechanim recently reported by Mirja Kuehlewind. The
code can cause a spurious exit of slow start in some particular
cases: upon an RTT decrease that happens on the 9th or later ACK
in a round trip. This series fixes the original Hystart code and
also the recent BPF implementation.

Neal Cardwell (2):
  tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT
  bpf: tcp: bpf_cubic: fix spurious HYSTART_DELAY exit upon drop in min
    RTT

 net/ipv4/tcp_cubic.c                          | 5 ++---
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

-- 
2.27.0.111.gc72c7da667-goog

