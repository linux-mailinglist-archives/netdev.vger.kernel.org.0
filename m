Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89513B55A6
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 00:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhF0Wu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 18:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhF0Wuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 18:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624834109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XqPF1XFqEQgW7GgV5Vae7FX9FdN3U+DbXbS6AiE/cAo=;
        b=RHokA8btyGuZqXRAX4g6k5xX+sNlGqHJvN5YyjkhFKwMcgCemzmUBpOjn6zUFICQIaBZbf
        ySOPUbhuCGye/MhtgfXHP+vV61t8RjMj7AllYE61/uYfb3rDz3vW7v4DNM4Eke/SUjPvbi
        u2Kku8GYaU1OR0kDCcuomzvq9Q/HN64=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-7-oVIeAUOOuMOIW7EX0W-Q-1; Sun, 27 Jun 2021 18:48:27 -0400
X-MC-Unique: 7-oVIeAUOOuMOIW7EX0W-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E712A106B7DF;
        Sun, 27 Jun 2021 22:48:26 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-112-243.rdu2.redhat.com [10.10.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D70D5C1CF;
        Sun, 27 Jun 2021 22:48:26 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
Subject: [PATCHv2 net-next 0/2] net: sock: add tracers for inet socket errors
Date:   Sun, 27 Jun 2021 18:48:20 -0400
Message-Id: <20210627224822.4689-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

changes since v2:

- change "sk.sk_error_report(&ipc->sk);" to "sk_error_report(&ipc->sk);"
  in net/qrtr/qrtr.c

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

