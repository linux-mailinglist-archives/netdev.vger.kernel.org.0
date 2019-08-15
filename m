Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49E838F001
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729998AbfHOQCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 12:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfHOQCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 12:02:55 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DF1630253A9;
        Thu, 15 Aug 2019 16:02:55 +0000 (UTC)
Received: from mob-31-157-107-94.net.vodafone.it.com (ovpn-204-48.brq.redhat.com [10.40.204.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BCF673796;
        Thu, 15 Aug 2019 16:02:52 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] net: tls: add socket diag
Date:   Thu, 15 Aug 2019 18:00:41 +0200
Message-Id: <cover.1565882584.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 15 Aug 2019 16:02:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current kernel does not provide any diagnostic tool, except
getsockopt(TCP_ULP), to know more about TCP sockets that have an upper
layer protocol (ULP) on top of them. This series extends the set of
information exported by INET_DIAG_INFO, to include data that are specific
to the ULP (and that might be meaningful for debug/testing purposes).

patch 1/3 ensures that the control plane reads/updates ULP specific data
using RCU.

patch 2/3 extends INET_DIAG_INFO and allows knowing the ULP name for
each TCP socket that has done setsockopt(TCP_ULP) successfully.

patch 3/3 extends kTLS to let programs like 'ss' know the protocol
version and the cipher in use.

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
 include/net/tcp.h                  |  3 ++
 include/net/tls.h                  | 28 +++++++++-
 include/uapi/linux/inet_diag.h     |  9 ++++
 include/uapi/linux/tls.h           | 15 ++++++
 net/core/sock_map.c                |  2 +-
 net/ipv4/tcp_diag.c                | 56 ++++++++++++++++++-
 net/tls/tls_device.c               |  2 +-
 net/tls/tls_main.c                 | 87 +++++++++++++++++++++++++++---
 9 files changed, 191 insertions(+), 13 deletions(-)

-- 
2.20.1

