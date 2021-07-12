Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DA03C40A7
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 02:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhGLA6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 20:58:51 -0400
Received: from novek.ru ([213.148.174.62]:38544 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhGLA6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 20:58:50 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C09FA50048B;
        Mon, 12 Jul 2021 03:53:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C09FA50048B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1626051228; bh=9MwGr9Awd3biwYm0OzND7zycfKh/nBjRi6o4UUif+oM=;
        h=From:To:Cc:Subject:Date:From;
        b=uQD3I/BkkZfFwynknzl8tlJajwq/nUFeMJ8XQzAv1LYigSCTDxgw5PUPtm4+mOfKT
         GRl+jBpbfgpR7rjCnHd3vemSJHeUxDJ2tHOwwHsch7NH1gJTYe1qbunELTMusVEqUt
         a2K9CRJvhbSGrMlVZBWniveGXBlT/mrb4TTTL1a4=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net 0/3] Fix PMTU for ESP-in-UDP encapsulation
Date:   Mon, 12 Jul 2021 03:55:51 +0300
Message-Id: <20210712005554.26948-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bug 213669 uncovered regression in PMTU discovery for UDP-encapsulated
routes and some incorrect usage in udp tunnel fields. This series fixes
problems and also adds such case for selftests

Vadim Fedorenko (3):
  udp: check for encap using encap_enable
  udp: check encap socket in __udp_lib_err
  selftests: net: add ESP-in-UDP PMTU test

 drivers/infiniband/sw/rxe/rxe_net.c   |   1 -
 drivers/net/bareudp.c                 |   1 -
 drivers/net/geneve.c                  |   1 -
 drivers/net/vxlan.c                   |   1 -
 drivers/net/wireguard/socket.c        |   1 -
 net/ipv4/fou.c                        |   1 -
 net/ipv4/udp.c                        |  31 ++++++--
 net/ipv6/udp.c                        |  30 ++++++--
 net/sctp/protocol.c                   |   2 -
 net/tipc/udp_media.c                  |   1 -
 tools/testing/selftests/net/nettest.c |  55 +++++++++++++-
 tools/testing/selftests/net/pmtu.sh   | 104 +++++++++++++++++++++++++-
 12 files changed, 205 insertions(+), 24 deletions(-)

-- 
2.18.4

