Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49DF4A9C4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730255AbfFRS0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:26:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44898 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfFRS0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:26:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so8125853pgp.11
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koThOUoc5SDFrb2RIfCAXuPG38Z1EOa+hLNv6STvKKc=;
        b=vJvfLIZC9W4BUQQEkj4AqdiEPCM07KG3vVippTruqmmuHEj0JIik+/VsSvyCUuN6HZ
         cBe2KCPnbvGKLydbRNRqRp3NRBYwl2BaKoYjhZHYgQ3h3hHW6zA5uSL74OPw90VSqaW4
         9zV1p6J+4C+UJTLZBjviedW/QUPxcZq8oLHsmeNvZdONi/8+vTT742RPY+vPSgPvU34Q
         Jt+V9TLAOWq/EresV0D1ZSTy+X1pVKN+SZwCiJ7q6Uk8nWfHFuKUYcJlb5QHhg/tRCla
         VowLFBw+ZGY2piYIRNB0g6lftLaWQLgGLFUxN9JrQjV2hcpt1nonR5QX9W6yepbRijqY
         30bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koThOUoc5SDFrb2RIfCAXuPG38Z1EOa+hLNv6STvKKc=;
        b=cHHgxroW2uVES+kA1o2OwLW7w9sbyEYeN1LotGccZ77BBKUK7xdF5XTb+/+Sf0cbed
         ibdIyYzQ6Lx2JTOKSZdwfMXV2W4wqtPxePNDN8MaYe/vhXfrjPfSFiGJWQrv1gQ/awMJ
         DVatDgm82V7H5313ZOnl09A7lXdAF8IU+SLX3+P/BRrveVHtXVcXrvJhW4WF8Vm8QCCX
         Q98sgcsJwKSZsLeFB2P8Jgm+JdkPOgx3+4+YHTCaZmnyViIruqtXgXdlOdKoAxLqehSK
         yfS5jc5Y0yZm2rVZN0UaHHAGVo06C8Y9VTXfDW1U00miBGzRdthPDVkuPWnGpd8AuEzR
         N+Ng==
X-Gm-Message-State: APjAAAW3/M9aCmIb38OlR4PZ0chLW5ilz6NULO9cUH/KQRZVluPd0Q2C
        cQONovEhzmxzO9E2zQRcQ6w=
X-Google-Smtp-Source: APXvYqzrMeT1q8/XQcGkJqdsqZolEnIJWoK8G+Url+XANCkocs/1QyWTGuwLlakn/VlzK16MIVQ4Dw==
X-Received: by 2002:a63:6445:: with SMTP id y66mr3982075pgb.23.1560882368374;
        Tue, 18 Jun 2019 11:26:08 -0700 (PDT)
Received: from weiwan0.svl.corp.google.com ([2620:15c:2c4:201:9310:64cb:677b:dcba])
        by smtp.gmail.com with ESMTPSA id h6sm2845859pjs.2.2019.06.18.11.26.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:26:07 -0700 (PDT)
From:   Wei Wang <tracywwnj@gmail.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>
Subject: [PATCH net-next 0/5] ipv6: avoid taking refcnt on dst during route lookup 
Date:   Tue, 18 Jun 2019 11:25:38 -0700
Message-Id: <20190618182543.65477-1-tracywwnj@gmail.com>
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

Wei Wang (5):
  ipv6: introduce RT6_LOOKUP_F_DST_NOREF flag in ip6_pol_route()
  ipv6: initialize rt6->rt6i_uncached in all pre-allocated dst entries
  ipv6: honor RT6_LOOKUP_F_DST_NOREF in rule lookup logic
  ipv6: convert rx data path to not take refcnt on dst
  ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF

 drivers/net/vrf.c       | 11 ++---
 include/net/ip6_route.h | 26 +++++++++++-
 include/net/l3mdev.h    | 11 +++--
 net/ipv6/fib6_rules.c   | 16 ++++---
 net/ipv6/route.c        | 93 +++++++++++++++++++----------------------
 net/l3mdev/l3mdev.c     | 22 +++++-----
 6 files changed, 102 insertions(+), 77 deletions(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

