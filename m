Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53925E2A0C
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406961AbfJXFo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:44:56 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:43679 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404418AbfJXFo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:44:56 -0400
Received: by mail-pg1-f201.google.com with SMTP id i4so10977359pgh.10
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 22:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Hk1rrY+h6ZoSnVU+7pjpPmP7tBA6KvnRXOUQwGhzxs0=;
        b=vJqN9US7o1ja6mV8aQPBEi8vj8zZqs5WWUFeVTNHj26yMKmixXlHYocjaid+/cz2t/
         dblw6Mb998ryhe17m1K3cJl7XkB98UZ9bv0CtlT67ve7TYE37Lz8Gzjmg5wOd+LfMKk0
         9c3MqNbh4F+25avj4cETsOgjw6rJbE64B1jOxPtWipT01qXRXzRRHSQ4NjZEo9aBnDia
         eeBA+cJpkFQXPlZs4/0RV7G7Wp6Ke7lnRu0oMEp/+czrX0gsrKWyckVTsksa9Szwu9ia
         JvR156Rvw+BCW9s57/aDOa949NrnOgk/WHMwAUHUqoFos/xGZSa1qPgoftQd/2qkgSU5
         +btA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Hk1rrY+h6ZoSnVU+7pjpPmP7tBA6KvnRXOUQwGhzxs0=;
        b=DEzJHRP94mgeVqmel41DsCvOg7emtl9qQrImYAuj7OgQJkjmBLEcS266BMTXdhHikm
         x9tLcEog32/EvWfyvVLIZoltkLOIH/XQS6fWJa7X1NJ6k4vYMdTJa37mcVqfosQRrqFG
         qT5NiG10kgREPkGOHfrzPisTAmHG5ppYj+Rbc8TaNpvEjX6bzVXVBz8k9vouxTxE9hN1
         5MzhvjwrOl6dSDW7ihrRCNbCox6mFjN+9PAb+t/I4klx+WEI/dyZZdWsnByN3deTS/Wz
         sI/qDtymuDG3uU+4jdvGt6lxDuTk4e0OThQ1zD1/E03ZO6GsLCKDJoS/B08fKt2Kh3NZ
         UdvA==
X-Gm-Message-State: APjAAAX75yGNy6ZSjIefRM27UV3QLEHBBAkehyjEzKfaOfOX9pR8Gm4Q
        0eyqaOnfyA8e73NYjEzi6HKoBJncYYGryQ==
X-Google-Smtp-Source: APXvYqwcb+7cJTbXpRip5XcxyzR4LWZ5rrpPqhrG/DwVxNT2/eH27vlch8xu9UxlZ4uxsa5TlyyZ2pUppouTcQ==
X-Received: by 2002:a63:ad02:: with SMTP id g2mr14352842pgf.450.1571895895231;
 Wed, 23 Oct 2019 22:44:55 -0700 (PDT)
Date:   Wed, 23 Oct 2019 22:44:47 -0700
Message-Id: <20191024054452.81661-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net 0/5] net: avoid KCSAN splats
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Often times we use skb_queue_empty() without holding a lock,
meaning that other cpus (or interrupt) can change the queue
under us. This is fine, but we need to properly annotate
the lockless intent to make sure the compiler wont over
optimize things.

Eric Dumazet (5):
  net: add skb_queue_empty_lockless()
  udp: use skb_queue_empty_lockless()
  net: use skb_queue_empty_lockless() in poll() handlers
  net: use skb_queue_empty_lockless() in busy poll contexts
  net: add READ_ONCE() annotation in __skb_wait_for_more_packets()

 drivers/crypto/chelsio/chtls/chtls_io.c |  2 +-
 drivers/isdn/capi/capi.c                |  2 +-
 drivers/nvme/host/tcp.c                 |  2 +-
 include/linux/skbuff.h                  | 33 ++++++++++++++++++-------
 net/atm/common.c                        |  2 +-
 net/bluetooth/af_bluetooth.c            |  4 +--
 net/caif/caif_socket.c                  |  2 +-
 net/core/datagram.c                     |  8 +++---
 net/core/sock.c                         |  2 +-
 net/decnet/af_decnet.c                  |  2 +-
 net/ipv4/tcp.c                          |  4 +--
 net/ipv4/udp.c                          |  8 +++---
 net/nfc/llcp_sock.c                     |  4 +--
 net/phonet/socket.c                     |  4 +--
 net/sctp/socket.c                       |  6 ++---
 net/tipc/socket.c                       |  4 +--
 net/unix/af_unix.c                      |  6 ++---
 net/vmw_vsock/af_vsock.c                |  2 +-
 18 files changed, 56 insertions(+), 41 deletions(-)

-- 
2.23.0.866.gb869b98d4c-goog

