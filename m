Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83A842CB5
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409469AbfFLQwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:52:38 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:41825 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405826AbfFLQwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:52:37 -0400
Received: by mail-pf1-f201.google.com with SMTP id b127so12390999pfb.8
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 09:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HsWCGJqguVRWfPio0VAZQeoVi+xrjglMsGTBnfa/Cf8=;
        b=OQDJ2LZuVXolwABACvRXK4N7jGjK5hu0SWf28krx3zznFH9RYDocCiczqm6k7WrW7E
         Qqqklx9Hz89+c+pVqqQAmylxXvMmvkUABene3MbOEOHVZ+9abvjHJE2/wUm+09lfQ7V6
         BPRaZZSqP5FubiyvGhNuoNdSMBKgsugW6RqkhApLBU8NzwMmfZ6DWaG/yP6rmot2O5Io
         HMSF7H7lYHS9L5/Axvs7A3nKZpBoLZyRMf2RWX0Y4vjYfqiIKXWS5tIiw+cabpmpe1dL
         A567CNCcAn6ilttsa6oLg76xvTNGw7L7S2QmxC24+dzPOaGMDU/ax5EnmRrXhnPmdEWV
         feAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HsWCGJqguVRWfPio0VAZQeoVi+xrjglMsGTBnfa/Cf8=;
        b=T+WSib/ETRFl2xliVmyxxemKFXfy6O7tJN00kAGVGp8EZOR1m1w1DGqZcQUUFnyS1H
         rRJ8dANBhsU80+qjQi8KPdgkMKh1kzDmOifwjt9czEQsh4dful8kkkJpMYXASkEI6QjZ
         AaxGYbOVaZM2uQx4TiN7moiNe7xIdkRB/Xno3EH0/FVdU9sFOor+me+iGRebd0RwIW9S
         PtKg52m/KiuxT39cPmooOlXA8EQz1KYmfrzxpnf7fKayrrdN+aoxZPlrVj4PqyGgtuiy
         rqUl03Zg9ii9dW72ON9ezwXrmA/iGKvNVnHg4OAT86+CSYO+NbdOyRijs20pmIfeIRwB
         Yw5g==
X-Gm-Message-State: APjAAAWEGzkOzLpflqx5AHltW8zsCkQPO+fjPsVfKWdbMwONYE+HIf0m
        fLqF5p1+vY/5I4lwC2W2gTu9fxxpyO91Pw==
X-Google-Smtp-Source: APXvYqyzj+J5q2aEHkxnoSo10hw2TvcPW9YdNflks4qBcqhrmrribyE02Ms2TQeQmXLc5+GLpI8Kq6XT6UHysA==
X-Received: by 2002:a63:e709:: with SMTP id b9mr24703110pgi.209.1560358356691;
 Wed, 12 Jun 2019 09:52:36 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:52:25 -0700
Message-Id: <20190612165233.109749-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH net-next 0/8] net/packet: better behavior under DDOS
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using tcpdump (or other af_packet user) on a busy host can lead to
catastrophic consequences, because suddenly, potentially all cpus
are spinning on a contended spinlock.

Both packet_rcv() and tpacket_rcv() grab the spinlock
to eventually find there is no room for an additional packet.

This patch series align packet_rcv() and tpacket_rcv() to both
check if the queue is full before grabbing the spinlock.

If the queue is full, they both increment a new atomic counter
placed on a separate cache line to let readers drain the queue faster.

There is still false sharing on this new atomic counter,
we might in the future make it per cpu if there is interest.

Eric Dumazet (8):
  net/packet: constify __packet_get_status() argument
  net/packet: constify packet_lookup_frame() and __tpacket_has_room()
  net/packet: constify prb_lookup_block() and __tpacket_v3_has_room()
  net/packet: constify __packet_rcv_has_room()
  net/packet: make tp_drops atomic
  net/packet: implement shortcut in tpacket_rcv()
  net/packet: remove locking from packet_rcv_has_room()
  net/packet: introduce packet_rcv_try_clear_pressure() helper

 net/packet/af_packet.c | 96 ++++++++++++++++++++++++------------------
 net/packet/internal.h  |  1 +
 2 files changed, 56 insertions(+), 41 deletions(-)

-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

