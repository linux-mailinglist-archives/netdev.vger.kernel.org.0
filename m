Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EFB112D87
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbfLDOgV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Dec 2019 09:36:21 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40052 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727878AbfLDOgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:36:21 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-QPrEdz0sNb-EpJQKAlyBUA-1; Wed, 04 Dec 2019 09:36:17 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00B8B18B9FC8;
        Wed,  4 Dec 2019 14:36:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54A55D6BB;
        Wed,  4 Dec 2019 14:36:14 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 0/2] net: convert ipv6_stub to ip6_dst_lookup_flow
Date:   Wed,  4 Dec 2019 15:35:51 +0100
Message-Id: <cover.1575458463.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QPrEdz0sNb-EpJQKAlyBUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiumei Mu reported a bug in a VXLAN over IPsec setup:

  IPv6 | ESP | VXLAN

Using this setup, packets go out unencrypted, because VXLAN over IPv6
gets its route from ipv6_stub->ipv6_dst_lookup (in vxlan6_get_route),
which doesn't perform an XFRM lookup.

This patchset first makes ip6_dst_lookup_flow suitable for some
existing users of ipv6_stub->ipv6_dst_lookup by adding a 'net'
argument, then converts all those users.

Sabrina Dubroca (2):
  net: ipv6: add net argument to ip6_dst_lookup_flow
  net: ipv6_stub: use ip6_dst_lookup_flow instead of ip6_dst_lookup

 drivers/infiniband/core/addr.c                      |  7 +++----
 drivers/infiniband/sw/rxe/rxe_net.c                 |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c |  8 ++++----
 drivers/net/geneve.c                                |  4 +++-
 drivers/net/vxlan.c                                 |  8 +++-----
 include/net/ipv6.h                                  |  2 +-
 include/net/ipv6_stubs.h                            |  6 ++++--
 net/core/lwt_bpf.c                                  |  4 +---
 net/dccp/ipv6.c                                     |  6 +++---
 net/ipv6/addrconf_core.c                            | 11 ++++++-----
 net/ipv6/af_inet6.c                                 |  4 ++--
 net/ipv6/datagram.c                                 |  2 +-
 net/ipv6/inet6_connection_sock.c                    |  4 ++--
 net/ipv6/ip6_output.c                               |  8 ++++----
 net/ipv6/raw.c                                      |  2 +-
 net/ipv6/syncookies.c                               |  2 +-
 net/ipv6/tcp_ipv6.c                                 |  4 ++--
 net/l2tp/l2tp_ip6.c                                 |  2 +-
 net/mpls/af_mpls.c                                  |  7 +++----
 net/sctp/ipv6.c                                     |  4 ++--
 net/tipc/udp_media.c                                |  9 ++++++---
 21 files changed, 58 insertions(+), 54 deletions(-)

-- 
2.23.0

