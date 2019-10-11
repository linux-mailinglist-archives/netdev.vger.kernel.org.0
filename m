Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF48D37CA
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfJKDRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:17:52 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:48854 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKDRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:17:52 -0400
Received: by mail-pf1-f202.google.com with SMTP id z13so6371190pfr.15
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9Ee20uMlC97XHP5axcrgByT+xwiONc4SgEW5z2mFe2s=;
        b=pgaYpT47qPtCo8WzX8P/M9TZEjEp9Zw2qMnlP03nQ7gaYw/yBr9ZAo+EofLjQ0MUJo
         TdhdICJF5iaANSEbvAk5pVISF9cKLDGD2WNhhR23HcmzkKwEJMTy6MQhKPA12Nbx/jU+
         EEsTJIxq0Pdi8sD2AwEK8lvCt1DnpOIP+/tf0pIOMys/N+KcLnwcZiPPAf+ZI1+6f+pM
         rfYm68eo02steBRhHztsGzZgPhjdaLxsH38UDPGvq/aPu0iP3RRS4kChfapVYNBE4dAy
         SJjPliR56TYm7ZMkVW6wNABOYdckzsI4ObM5L+ns7EHLnydWIRYlVT6X8pGma0Y4YIfh
         R7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9Ee20uMlC97XHP5axcrgByT+xwiONc4SgEW5z2mFe2s=;
        b=cQKVLIAMJzkntUi9WYRvOJNs1jNaAnrBb4DbNWNlBALoQKVwGs3GgWcBk+sOpIr/GM
         8X8Wz6DRWdEMaLiwslpA41MTFqET/LZ/Lhh64lo7YvRiJ1tYJ8hbbje+gbdQy1wFlspZ
         U+TkoafEByP865ke66uxE37W/s+0D6YfVG1Tl9af01tBDtOhOcr5czj0nIrYgLWlgANA
         DoTnPRSzSxjIfjbVUVUTkkftBHqDEUizYn+BwA7DvJm9mFcYgF+gsDj5GNkiuQb8D5j4
         7XpCN2GlrQ4nyKIeW8rSSpPiPxRDG9x7wSWLIhRVjgqpIvlYDouZ0IL07rUK7AxHV8TI
         j3lQ==
X-Gm-Message-State: APjAAAVh5Udky6egsLjybUwHeaz79IOqsldBQkxIBM4bQUgo4WNImYQo
        bfQ9ruYJGYFMCsTIGHHkFDy2myLyxkD82Q==
X-Google-Smtp-Source: APXvYqz4+5JhfI0qGj4DzRUtWVL1VVboKOM2s6UupKIq76Ka4b51ziGDCMy1p+TmnqVsNnWIuDMTK0SDJdK2mQ==
X-Received: by 2002:a65:638a:: with SMTP id h10mr14326295pgv.388.1570763869626;
 Thu, 10 Oct 2019 20:17:49 -0700 (PDT)
Date:   Thu, 10 Oct 2019 20:17:37 -0700
Message-Id: <20191011031746.16220-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net 0/9] tcp: address KCSAN reports in tcp_poll() (part I)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This all started with a KCSAN report (included
in "tcp: annotate tp->rcv_nxt lockless reads" changelog)

tcp_poll() runs in a lockless way. This means that about
all accesses of tcp socket fields done in tcp_poll() context
need annotations otherwise KCSAN will complain about data-races.

While doing this detective work, I found a more serious bug,
addressed by the first patch ("tcp: add rcu protection around
tp->fastopen_rsk").

Eric Dumazet (9):
  tcp: add rcu protection around tp->fastopen_rsk
  tcp: annotate tp->rcv_nxt lockless reads
  tcp: annotate tp->copied_seq lockless reads
  tcp: annotate tp->write_seq lockless reads
  tcp: annotate tp->snd_nxt lockless reads
  tcp: annotate tp->urg_seq lockless reads
  tcp: annotate sk->sk_rcvbuf lockless reads
  tcp: annotate sk->sk_sndbuf lockless reads
  tcp: annotate sk->sk_wmem_queued lockless reads

 include/linux/tcp.h             |  6 +--
 include/net/sock.h              | 29 ++++++++++-----
 include/net/tcp.h               |  7 ++--
 include/trace/events/sock.h     |  4 +-
 net/core/datagram.c             |  2 +-
 net/core/filter.c               |  6 ++-
 net/core/request_sock.c         |  2 +-
 net/core/skbuff.c               |  2 +-
 net/core/sock.c                 | 22 ++++++-----
 net/ipv4/inet_connection_sock.c |  4 +-
 net/ipv4/inet_diag.c            |  2 +-
 net/ipv4/tcp.c                  | 65 +++++++++++++++++++--------------
 net/ipv4/tcp_diag.c             |  5 ++-
 net/ipv4/tcp_fastopen.c         |  2 +-
 net/ipv4/tcp_input.c            | 37 +++++++++++--------
 net/ipv4/tcp_ipv4.c             | 28 ++++++++------
 net/ipv4/tcp_minisocks.c        | 17 ++++++---
 net/ipv4/tcp_output.c           | 32 ++++++++--------
 net/ipv4/tcp_timer.c            | 11 +++---
 net/ipv6/tcp_ipv6.c             | 18 +++++----
 net/sched/em_meta.c             |  2 +-
 21 files changed, 175 insertions(+), 128 deletions(-)

-- 
2.23.0.700.g56cf767bdb-goog

