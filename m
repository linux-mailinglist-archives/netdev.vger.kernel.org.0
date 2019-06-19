Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4A4C3A0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 00:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfFSWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 18:32:11 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43664 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSWcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 18:32:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so416590pfg.10
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 15:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2FZuFAWaOBnlTsdxqssuN26dKKYXf2XKkwTlJt550w=;
        b=pgYh4MtTeQzsCXsnUW/9UnjyWy/0eGZJuFND5/0sz9X7/yGcBxPbOINlLoVU/PsgQo
         RVS4/vJT4OZYupZv1Juiu/NVXd6qw1XNtfdq1bbA7WtlP1o7S7bdy1VZgFlZ8aGOwmWo
         idlpK2pSpJwULZDJbu7fcJ04v0Dr7t6LCrgoZT2g4OxEJRJlGGN3L7ajp9jvWjsPpwNk
         VxnLMwuMF43ybVNtzb5lE12SSfNAx+M1UmuIbKvtFAbE+V5hyVQfc5ah8s0Fh9fuoPes
         EP96pfz7N3IMEY4dlha1TGlwnTwQDdWTcuVW60fosQ1BtfA7DVqiwInBfvoG68hv3a72
         Wgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n2FZuFAWaOBnlTsdxqssuN26dKKYXf2XKkwTlJt550w=;
        b=eVEOlYz59wJXhiFWDPFusU0r09WHlVrD9p3IyahmyJURWeQvZVielfrHvrdJ+IyQtJ
         ADZRBd98tcFA7+tJKCX7eGrinuryWCtLfbccSANYHlQ9NC0JkE3HDZR0gBnxwfz7tPK+
         CkGC6D/gkSH8inTbyyTtQWhprvTjqR2+VTlRn4Cb2fRyjucNQfPQOdqYZgR6hhShJcy/
         kbmkO3Er9h2L8V9KAodjLnxV6CNRL9RmL2egt/U2fNaYebgOK8o0bURvyUYGIMTbrDto
         HSE65ioggjjiTBMJxJdLsaNtlh/GoJvw6rrQFNWQjXCOC8tMvenjdx6Irvi4DCRQTqDk
         qreA==
X-Gm-Message-State: APjAAAUhBV8Uv39+2y3Ez+0x9YQJ90aoY+Piflclc2ugZSlBy1CBeN6x
        gRKjJqOPs0JS155/C3SE1gI=
X-Google-Smtp-Source: APXvYqyerT+pf+gIfLWVV6hslGbUsbgxVRuyqvNH6855c9Km1QcC62jYnQ7GTyablwxgobGLUCAxGg==
X-Received: by 2002:a63:4f07:: with SMTP id d7mr9648139pgb.77.1560983529792;
        Wed, 19 Jun 2019 15:32:09 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id g8sm20037687pgd.29.2019.06.19.15.32.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 15:32:09 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH v2 net-next 0/5] ipv6: avoid taking refcnt on dst during route lookup 
Date:   Wed, 19 Jun 2019 15:31:53 -0700
Message-Id: <20190619223158.35829-1-tracywwnj@gmail.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>

Ipv6 route lookup code always grabs refcnt on the dst for the caller.
But for certain cases, grabbing refcnt is not always necessary if the
call path is rcu protected and the caller does not cache the dst.
Another issue in the route lookup logic is:
When there are multiple custom rules, we have to do the lookup into
each table associated to each rule individually. And when we can't
find the route in one table, we grab and release refcnt on
net->ipv6.ip6_null_entry before going to the next table.
This operation is completely redundant, and causes false issue because
net->ipv6.ip6_null_entry is a shared object.

This patch set introduces a new flag RT6_LOOKUP_F_DST_NOREF for route
lookup callers to set, to avoid any manipulation on the dst refcnt. And
it converts the major input and output path to use it.

The performance gain is noticable.
I ran synflood tests between 2 hosts under the same switch. Both hosts
have 20G mlx NIC, and 8 tx/rx queues.
Sender sends pure SYN flood with random src IPs and ports using trafgen.
Receiver has a simple TCP listener on the target port.
Both hosts have multiple custom rules:
- For incoming packets, only local table is traversed.
- For outgoing packets, 3 tables are traversed to find the route.
The packet processing rate on the receiver is as follows:
- Before the fix: 3.78Mpps
- After the fix:  5.50Mpps

v1->v2:
- Added a helper ip6_rt_put_flags() in patch 3 suggested by David Miller

Wei Wang (5):
  ipv6: introduce RT6_LOOKUP_F_DST_NOREF flag in ip6_pol_route()
  ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
  ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
  ipv6: convert rx data path to not take refcnt on dst
  ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF

 drivers/net/vrf.c       | 11 ++---
 include/net/ip6_route.h | 36 +++++++++++++++-
 include/net/l3mdev.h    | 11 +++--
 net/ipv6/fib6_rules.c   | 12 +++---
 net/ipv6/route.c        | 93 +++++++++++++++++++----------------------
 net/l3mdev/l3mdev.c     | 22 +++++-----
 6 files changed, 108 insertions(+), 77 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

