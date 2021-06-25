Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87703B4931
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFYTVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:21:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24052 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229697AbhFYTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 15:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624648719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V0+pBItggBD/Vh3eyfyb3/4rgtHfl3PXYGfGXvCV3Hc=;
        b=Z7f5evCvNCQ0pQ9RPCzuqK487I8sDbdGCXLGIqyA+BQmu1bMWO2/iiEkr8SfGV85WJLt2S
        cYFQCtEwrOukodlbiFJpxkSah2xqiJhwS2AQonDE49iLbqnWcgrCavpijFq3bhSwtidUfP
        REvke+u+jBxV7IdASRsJkgzcCapw6tE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-ZchmF0GJOaiDYK4g9yny4g-1; Fri, 25 Jun 2021 15:18:37 -0400
X-MC-Unique: ZchmF0GJOaiDYK4g9yny4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46C36800D62;
        Fri, 25 Jun 2021 19:18:36 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-114-32.rdu2.redhat.com [10.10.114.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2F9A60657;
        Fri, 25 Jun 2021 19:18:35 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 0/2] net: sock: add tracers for inet socket errors
Date:   Fri, 25 Jun 2021 15:18:20 -0400
Message-Id: <20210625191822.77721-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this patch series introduce tracers for sk_error_report socket callback
calls. The use-case is that a user space application can monitor them
and making an own heuristic about bad peer connections even over a
socket lifetime. To make a specific example it could be use in the Linux
cluster world to fence a "bad" behaving node. For now it's okay to only
trace inet sockets. Other socket families can introduce their own tracers
easily.

Example output with trace-cmd:

<idle>-0     [003]   201.799437: inet_sk_error_report: family=AF_INET protocol=IPPROTO_TCP sport=21064 dport=38941 saddr=192.168.122.57 daddr=192.168.122.251 saddrv6=::ffff:192.168.122.57 daddrv6=::ffff:192.168.122.251 error=104

- Alex

Alexander Aring (2):
  net: sock: introduce sk_error_report
  net: sock: add trace for socket errors

 .../chelsio/inline_crypto/chtls/chtls_cm.c    |  2 +-
 drivers/vhost/vsock.c                         |  2 +-
 include/linux/skmsg.h                         |  2 +-
 include/net/sock.h                            |  2 +
 include/net/tls.h                             |  2 +-
 include/trace/events/sock.h                   | 60 +++++++++++++++++++
 net/caif/caif_socket.c                        |  2 +-
 net/can/bcm.c                                 |  4 +-
 net/can/isotp.c                               | 20 +++----
 net/can/j1939/socket.c                        |  4 +-
 net/can/raw.c                                 |  6 +-
 net/core/skbuff.c                             |  6 +-
 net/core/sock.c                               | 16 +++++
 net/dccp/ipv4.c                               |  4 +-
 net/dccp/ipv6.c                               |  4 +-
 net/dccp/proto.c                              |  2 +-
 net/dccp/timer.c                              |  2 +-
 net/ipv4/ping.c                               |  2 +-
 net/ipv4/raw.c                                |  4 +-
 net/ipv4/tcp.c                                |  4 +-
 net/ipv4/tcp_input.c                          |  2 +-
 net/ipv4/tcp_ipv4.c                           |  4 +-
 net/ipv4/tcp_timer.c                          |  2 +-
 net/ipv4/udp.c                                |  4 +-
 net/ipv6/raw.c                                |  2 +-
 net/ipv6/tcp_ipv6.c                           |  4 +-
 net/ipv6/udp.c                                |  2 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/mptcp/subflow.c                           |  2 +-
 net/netlink/af_netlink.c                      |  8 +--
 net/nfc/rawsock.c                             |  2 +-
 net/packet/af_packet.c                        |  4 +-
 net/qrtr/qrtr.c                               |  2 +-
 net/sctp/input.c                              |  2 +-
 net/sctp/ipv6.c                               |  2 +-
 net/smc/af_smc.c                              |  2 +-
 net/strparser/strparser.c                     |  2 +-
 net/unix/af_unix.c                            |  2 +-
 net/vmw_vsock/af_vsock.c                      |  2 +-
 net/vmw_vsock/virtio_transport.c              |  2 +-
 net/vmw_vsock/virtio_transport_common.c       |  2 +-
 net/vmw_vsock/vmci_transport.c                |  4 +-
 net/xdp/xsk.c                                 |  2 +-
 43 files changed, 145 insertions(+), 67 deletions(-)

-- 
2.26.3

