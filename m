Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 113AA46CCA
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbfFNXW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:28 -0400
Received: from mail-ot1-f73.google.com ([209.85.210.73]:39145 "EHLO
        mail-ot1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNXW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:28 -0400
Received: by mail-ot1-f73.google.com with SMTP id x27so1849408ote.6
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1G/V6xb7iP/IeBqnKStIfAVjteGJ7Atgu2Aw8zY6rzU=;
        b=FAvIe3CrkbCNPSsFFhqpovJU5n7e0vqat/uuUhKjvAW4WUHft08DvyN665Z5ChTIQL
         nX20wHBjTFsNVYRla12j8JK2tQD6nXmvWlXqj6MvxK4Oc7/hpT9YX6zeim0BL3Qn3367
         mdwToy6/f9zsPKZNk/QBnknYLROckMRqMG2PIayv/8lAYOKUXoSGFgJuZWE1EjWfQDlv
         KJK9vEoTcO2N6ybScJ8qNSelo06kbBnJVcxgF+lD8SPJztAb/jwnOKZtGr7NRNr/oTza
         ppfMv9Y9Fa6csQSn7ePvp4gZoeXWsh8ZetmSU9XnRmhMFZl9/6V5ZxJ2/i5yJnfzXlXL
         99TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1G/V6xb7iP/IeBqnKStIfAVjteGJ7Atgu2Aw8zY6rzU=;
        b=lUmp98AgUUTL/wLH5LOb5fCwK5rEOs6zwE5Ec9g2kj7dnFwcvODWPiv9yv8YnVtw3y
         K7GCf84NXQIxw4DENliFObMxOKWOZmWV9WWxHm02mVLfP5PYtmdBHZbyOW4NuRUVtUym
         /lw6+gY/3b/HJIORt5hwWDPcgu+4DTIgPBLIEGrsQkpkVVGZi/VAQI7UZZyVFjyJxmNT
         fib6ycQag2ykckFxUHa42quFVU/n24sLJ3yY0EDm6cxLYcjI4u9Jie87f+4EChYDr/VK
         d1ZPVGVmBA4zPMwKYLwQPDQKC02mCbE/K3HNowxnjCSwyNWWyB8g6n6WL5IAAPiUsgSa
         L1Cg==
X-Gm-Message-State: APjAAAXBDlSfAfoRTxa7NPgn5RhSwJVhOTeiw1sQizpxSGnjTSjtPaqz
        OvKZFUux2qQbGDBAi0omV5Pl6maluTKRyg==
X-Google-Smtp-Source: APXvYqzqDfj6XB+ulImYax/jsnWN/HVZe4jDfD4hUKt4fXBQ8LP1oRD0+YFPrjEudM0+VQmLwkXWMcXO5GNmzQ==
X-Received: by 2002:aca:51ce:: with SMTP id f197mr3504523oib.33.1560554547167;
 Fri, 14 Jun 2019 16:22:27 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:22:17 -0700
Message-Id: <20190614232221.248392-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 0/4] tcp: add three static keys
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent addition of per TCP socket rx/tx cache brought
regressions for some workloads, as reported by Feng Tang.

It seems better to make them opt-in, before we adopt better
heuristics.

The last patch adds high_order_alloc_disable sysctl
to ask TCP sendmsg() to exclusively use order-0 allocations,
as mm layer has specific optimizations.

Eric Dumazet (4):
  sysctl: define proc_do_static_key()
  tcp: add tcp_rx_skb_cache sysctl
  tcp: add tcp_tx_skb_cache sysctl
  net: add high_order_alloc_disable sysctl/static key

 Documentation/networking/ip-sysctl.txt |  8 +++++
 include/linux/bpf.h                    |  1 -
 include/linux/sysctl.h                 |  3 ++
 include/net/sock.h                     | 12 ++++---
 kernel/bpf/core.c                      |  1 -
 kernel/sysctl.c                        | 44 ++++++++++++++------------
 net/core/sock.c                        |  4 ++-
 net/core/sysctl_net_core.c             |  7 ++++
 net/ipv4/sysctl_net_ipv4.c             | 17 ++++++++++
 9 files changed, 68 insertions(+), 29 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

