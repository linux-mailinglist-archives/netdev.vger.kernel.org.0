Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0E1C03F2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgD3Rfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:35:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0DEC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b6so8600528ybo.8
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vW4WaPtEQrAyBFCgXAHp4+GofM7sn1DVx0E9PsruFBQ=;
        b=YtCa5mHV+Coso4rRrNlwerAUshUtwB6c2I4r1T0WpbaRs1UeewIp/VN8JRnJnhD98Z
         5Tz2JPRpTTqFG17qCGOjLoPCDpMW87PkohUzBw/mV8+7HzHjy5YRDzsBvu6oi/EYjcYu
         wWASENyDin+nghxBquL+Shc5VAHacO6ktJi6mm3VKMmKGZS6ZbmMSdkK+l39AVRBBRvZ
         2XOpRFoaHzZ97PIqKKU5BCXEkchD+kizOxfpRAXuMJ5zbOXa1/3HpROeYdI2/YWyOkmQ
         dJZVmio0eFSBp+YiNXiHobshmVMShFwFNiIvb+529EvBbuwFTr8nZWdVJA8+IrrxGx9T
         WwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vW4WaPtEQrAyBFCgXAHp4+GofM7sn1DVx0E9PsruFBQ=;
        b=X70Musx74+O7iubGvtHDGQ7lmwkd7GILjZlyoEDfYqw5F8/1rOfVJqoeHB3tJIN2tK
         zSoZoCov5nD3bWpm4Qq1DA3IvZYQok0/cvX8r3sSY4Igg9+r2RKpJznrAaEgNgNBd4SR
         cYsJc35uH/dHhudI8nQvndGzGzIUID3cXrVMr2w3ct3fSWniixujg+AHBFS9lul614/S
         NAKr57EDxX3EZw9/L9ACoAGv+wDZZA5LthzKFHVDhJ5DfoYz4zxCj6tPTFdRTzNt46Wa
         zNhEhhebXHWCXJukkvSWtrQkcBRL0seW89zA2oLkJBA9reOOjPin9stm6NWLSfa799yK
         bJzA==
X-Gm-Message-State: AGi0Pubj59bK7qjXFzyeHh66AwaBbYOkkBCSURdoA66c7dae3wTAFxZV
        9ID+V/Efc+XlvbzatEO6abKkdPWpmeikYw==
X-Google-Smtp-Source: APiQypJ7d6flXd8eMOA5T/NsISXp/4qwFRXsnLD3S218VRsr0i0bMvCov0jhE6esQ95xGBx8P9fttylbuwRQyQ==
X-Received: by 2002:a5b:5c6:: with SMTP id w6mr8315072ybp.261.1588268147055;
 Thu, 30 Apr 2020 10:35:47 -0700 (PDT)
Date:   Thu, 30 Apr 2020 10:35:40 -0700
Message-Id: <20200430173543.41026-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net-next 0/3] tcp: sack compression changes
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch series refines SACK compression.

We had issues with missing SACK when TCP option space is tight.

Uses hrtimer slack to improve performance.

Eric Dumazet (3):
  tcp: add tp->dup_ack_counter
  tcp: tcp_sack_new_ofo_skb() should be more conservative
  tcp: add hrtimer slack to sack compression

 Documentation/networking/ip-sysctl.rst |  8 ++++
 include/linux/tcp.h                    |  1 +
 include/net/netns/ipv4.h               |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  7 ++++
 net/ipv4/tcp_input.c                   | 51 ++++++++++++++++++++------
 net/ipv4/tcp_ipv4.c                    |  1 +
 net/ipv4/tcp_output.c                  |  6 +--
 net/ipv4/tcp_timer.c                   |  8 +++-
 8 files changed, 68 insertions(+), 15 deletions(-)

-- 
2.26.2.303.gf8c07b1a785-goog

