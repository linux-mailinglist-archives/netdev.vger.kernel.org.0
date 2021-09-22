Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08066414F04
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhIVR2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:28:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236711AbhIVR2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632331620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fwtV10F6Py72ZM1WtfrnrYAsIb+mcQlspU3tfvAl9EE=;
        b=OpLmRF7WIJg7ZZTdPFkOehRtsxPViMDt8F/SYT3XazDR+HpbIr56zsv61hMTZoPMV7dPcB
        57lw4EYTQLW9LpzDZWpcyPWBCouL6WqY5YfY5twGRJlTr8IbAcR72XLHehe5E5vMmuELt8
        Qe8mfw1uBmQjEKgBaJTlS3uv1SmjTpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-86WGX-j7NPyIE0eR8gqo5g-1; Wed, 22 Sep 2021 13:26:59 -0400
X-MC-Unique: 86WGX-j7NPyIE0eR8gqo5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEC00802CBA;
        Wed, 22 Sep 2021 17:26:57 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 484B919724;
        Wed, 22 Sep 2021 17:26:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/4] net: remove sk skb caches
Date:   Wed, 22 Sep 2021 19:26:39 +0200
Message-Id: <cover.1632318035.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric noted we would be better off reverting the sk
skb caches.

MPTCP relies on such a feature, so we need a
little refactor of the MPTCP tx path before the mentioned
revert.

The first patch exposes additional TCP helpers. The 2nd patch
changes the MPTCP code to do locally the whole skb allocation
and updating, so it does not rely anymore on core TCP helpers
for that nor the sk skb cache.

As a side effect, we can make the tcp_build_frag helper static.

Finally, we can pull Eric's revert.

RFC -> v1:
 - drop driver specific patch - no more needed after helper rename
 - rename skb_entail -> tcp_skb_entail (Eric)
 - preserve the tcp_build_frag helpwe, just make it static (Eric)

---
Note:

that this series touches some LoC also modifed by this -net patch:

https://patchwork.kernel.org/project/netdevbpf/patch/706c577fde04fbb8285c8fc078a2c6d0a4bf9564.1632309038.git.pabeni@redhat.com/

so the whole series is based on top of the above and will apply
with no conflict after such patch will land into net-next

Eric Dumazet (1):
  tcp: remove sk_{tr}x_skb_cache

Paolo Abeni (3):
  tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
  mptcp: stop relying on tcp_tx_skb_cache
  tcp: make tcp_build_frag() static

 Documentation/networking/ip-sysctl.rst |   8 --
 include/net/sock.h                     |  19 ----
 include/net/tcp.h                      |   4 +-
 net/ipv4/af_inet.c                     |   4 -
 net/ipv4/sysctl_net_ipv4.c             |  12 ---
 net/ipv4/tcp.c                         |  38 ++-----
 net/ipv4/tcp_ipv4.c                    |   6 --
 net/ipv6/tcp_ipv6.c                    |   6 --
 net/mptcp/protocol.c                   | 137 ++++++++++++++-----------
 9 files changed, 85 insertions(+), 149 deletions(-)

-- 
2.26.3

