Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA1ECE3
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729603AbfD2Wq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:46:29 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:38574 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbfD2Wq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 18:46:29 -0400
Received: by mail-ot1-f73.google.com with SMTP id b5so5751955otq.5
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 15:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=aibnZ8bGfMzCIp+iveKuYD5w3HmkzTsLDl7zipWMzVk=;
        b=UQRollDgPgSvApBJdXwinjT9QvtLCKlOhaA0lCS+qfIHobfQCyBtxWl3bnnTYC9XW3
         A1Hue+LUGfKu/dEDnWcvGp+7jktyUeVCDpK43zbd3WO0PJYhEq2PNVbRUMhh6UBXZUgG
         206U76f7pz2SXozNJV+PV+CNoSLmb7HwhPHG/ryetfRW4L4Pl/e2RZGOXZZqNC/pH02X
         Qfm7fNOiRHWMMKbYhta2A823iFRQKhox0jmyBnXqchRnqt4K6cZXzgWycFnniSWbjtWR
         yLG4SC4c+z8xfFBweM+W1LubsAdCexccxJFee3CxXi6YdPgDKnhsXeHUZXuDhoVydo8x
         ipJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=aibnZ8bGfMzCIp+iveKuYD5w3HmkzTsLDl7zipWMzVk=;
        b=ZgGChDqbPvchUkJAtBn9CAnH1NypMaRxucLxw40a4GMXewCHgvNkhI1dMmivYC3JSr
         sn2Ncp2QkvbcmRKjjSq9fc2QccGFGgqZWHsJjo4M8SDpkteejhLMKEnPYfoAdMz1OaLs
         F3UvB9Mk0wZdeWNpCAFgI1R+qPOX5kAAhId+2L/IGgpoIMf7jAKGluR8yyG91/QLD7br
         Y+VAhf5r+R9QAwfTqaYw62tD52n/Y0gj1VU6jmREj0KYLPlJX6OXT8pUTqSBFmsx9xx7
         H0hk/uC+bofjxcPajXvHj5yKikCuDBzOcLXHDn/rVNZIie09q0V1M7ObjbXeyogp2tFl
         b4Ow==
X-Gm-Message-State: APjAAAW0tD3FAYGUOk95VlMDBP4YdlS/sIFYExXMpwUjHmoeClHNR4Xg
        ISg86TfX8aUYawKZfL/1BIBFYnTUwAI=
X-Google-Smtp-Source: APXvYqzHYGpshgjTASF+829DZK0dCBeBGF+X1QXzAyQZOE0HYiANRXdckOr+Vb77/knS7FADUep2ktRV4OA=
X-Received: by 2002:aca:61d7:: with SMTP id v206mr1098683oib.97.1556577988236;
 Mon, 29 Apr 2019 15:46:28 -0700 (PDT)
Date:   Mon, 29 Apr 2019 15:46:12 -0700
Message-Id: <20190429224620.151064-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH net-next 0/8] undo congestion window on spurious SYN or SYNACK timeout
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, ncardwell@google.com, soheil@google.com,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux TCP currently uses the initial congestion window of 1 packet
if multiple SYN or SYNACK timeouts per RFC6298. However such
timeouts are often spurious on wireless or cellular networks that
experience high delay variances (e.g. ramping up dormant radios or
local link retransmission). Another case is when the underlying
path is longer than the default SYN timeout (e.g. 1 second). In
these cases starting the transfer with a minimal congestion window
is detrimental to the performance for short flows.

One naive approach is to simply ignore SYN or SYNACK timeouts and
always use a larger or default initial window. This approach however
risks pouring gas to the fire when the network is already highly
congested. This is particularly true in data center where application
could start thousands to millions of connections over a single or
multiple hosts resulting in high SYN drops (e.g. incast).

This patch-set detects spurious SYN and SYNACK timeouts upon
completing the handshake via the widely-supported TCP timestamp
options. Upon such events the sender reverts to the default
initial window to start the data transfer so it gets best of both
worlds. This patch-set supports this feature for both active and
passive as well as Fast Open or regular connections.


Yuchung Cheng (8):
  tcp: avoid unconditional congestion window undo on SYN retransmit
  tcp: undo initial congestion window on false SYN timeout
  tcp: better SYNACK sent timestamp
  tcp: undo init congestion window on false SYNACK timeout
  tcp: lower congestion window on Fast Open SYNACK timeout
  tcp: undo cwnd on Fast Open spurious SYNACK retransmit
  tcp: refactor to consolidate TFO passive open code
  tcp: refactor setting the initial congestion window

 net/ipv4/tcp.c           | 12 -----
 net/ipv4/tcp_input.c     | 99 +++++++++++++++++++++++++++++-----------
 net/ipv4/tcp_metrics.c   | 10 ----
 net/ipv4/tcp_minisocks.c |  5 ++
 net/ipv4/tcp_output.c    |  4 ++
 net/ipv4/tcp_timer.c     |  3 ++
 6 files changed, 84 insertions(+), 49 deletions(-)

-- 
2.21.0.593.g511ec345e18-goog

