Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 033A4A34EC
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfH3KZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42794 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3KZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 06:25:57 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E0D3308AA11;
        Fri, 30 Aug 2019 10:25:56 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF2A819C77;
        Fri, 30 Aug 2019 10:25:54 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     borisp@mellanox.com, jakub.kicinski@netronome.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 0/3] net: tls: add socket diag
Date:   Fri, 30 Aug 2019 12:25:46 +0200
Message-Id: <cover.1567158431.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 30 Aug 2019 10:25:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current kernel does not provide any diagnostic tool, except
getsockopt(TCP_ULP), to know more about TCP sockets that have an upper
layer protocol (ULP) on top of them. This series extends the set of
information exported by INET_DIAG_INFO, to include data that are
specific to the ULP (and that might be meaningful for debug/testing
purposes).

patch 1/3 ensures that the control plane reads/updates ULP specific data
using RCU.

patch 2/3 extends INET_DIAG_INFO and allows knowing the ULP name for
each TCP socket that has done setsockopt(TCP_ULP) successfully.

patch 3/3 extends kTLS to let programs like 'ss' know the protocol
version and the cipher in use.

Changes since v2:
- remove unneeded #ifdef and fix reverse christmas tree in
  tls_get_info(), thanks to Jakub Kicinski 

Changes since v1:
- don't worry about grace period when accessing ulp_ops, thanks to
  Jakub Kicinski and Eric Dumazet
- use rcu_dereference() to access ULP data in tls get_info(), and 
  test against NULL value, thanks to Jakub Kicinski
- move RCU protected section inside tls get_info(), thanks to Jakub
  Kicinski

Changes since RFC:
- some coding style fixes, thanks to Jakub Kicinski
- add X_UNSPEC as lowest value of uAPI enums, thanks to Jakub Kicinski
- fix assignment of struct nlattr *start, thanks to Jakub Kicinski
- let tls dump RXCONF and TXCONF, suggested by Jakub Kicinski
- don't dump anything if TLS version or cipher are 0 (but still return a
  constant size in get_aux_size()), thanks to Boris Pismenny
- constify first argument of get_info() and get_size()
- use RCU to access access ulp_ops, like it's done for ca_ops
- add patch 1/3, from Jakub Kicinski

Davide Caratti (2):
  tcp: ulp: add functions to dump ulp-specific information
  net: tls: export protocol version, cipher, tx_conf/rx_conf to socket
    diag

Jakub Kicinski (1):
  net/tls: use RCU protection on icsk->icsk_ulp_data

 include/net/inet_connection_sock.h |  2 +-
 include/net/tcp.h                  |  3 +
 include/net/tls.h                  | 26 ++++++++-
 include/uapi/linux/inet_diag.h     |  9 +++
 include/uapi/linux/tls.h           | 15 +++++
 net/core/sock_map.c                |  2 +-
 net/ipv4/tcp_diag.c                | 52 ++++++++++++++++-
 net/tls/tls_device.c               |  2 +-
 net/tls/tls_main.c                 | 90 +++++++++++++++++++++++++++---
 9 files changed, 188 insertions(+), 13 deletions(-)

-- 
2.20.1

