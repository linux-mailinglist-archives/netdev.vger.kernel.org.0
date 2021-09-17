Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5AF40FCB8
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241710AbhIQPkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:40:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:36175 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232331AbhIQPkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631893148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YRcVUlsCC8SSag0IHICYu8LmP243zJu8/RXmA/yODbw=;
        b=gL6bM0K/qvbKMmKqE3Kchv5FAlNDySXAO3fV70PNIvZMxYkWlwDElZTsYSCobuvqmLQimH
        k2yU+h6TWYI0ddfwqdrgiNF1PreYPIr15F2foa9IxpHBSSbxLlbqnYg62vyD8aZZPzJSP9
        I45pMd31VEcyUC6vShNuuybxLARzKxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-V2_xS9yIMrOkxKk3R5GAxg-1; Fri, 17 Sep 2021 11:39:05 -0400
X-MC-Unique: V2_xS9yIMrOkxKk3R5GAxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A32B1084683;
        Fri, 17 Sep 2021 15:39:03 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B07E69CAD;
        Fri, 17 Sep 2021 15:39:01 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 0/5] net: remove sk skb caches
Date:   Fri, 17 Sep 2021 17:38:35 +0200
Message-Id: <cover.1631888517.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric noted we would be better off reverting the sk
skb caches.

MPTCP relies on such a feature, so we need a
little refactor of the MPTCP tx path before the mentioned
revert.

The first patch avoids that the next one will cause a name
clash. The second exposes additional TCP helpers. The 3rd patch
changes the MPTCP code to do locally the whole skb allocation
and updating, so it does not rely anymore on core TCP helpers
for that nor the sk skb cache.

As a side effect, we can drop the tcp_build_frag helper.

Finally, we can pull Eric's revert.

Note that patch 3/5 will conflict with the pending -net fix
for a recently reported syzkaller splat.

Eric Dumazet (1):
  tcp: remove sk_{tr}x_skb_cache

Paolo Abeni (4):
  chtls: rename skb_entail() to chtls_skb_entail()
  tcp: expose the tcp_mark_push() and skb_entail() helpers
  mptcp: stop relying on tcp_tx_skb_cache
  Partially revert "tcp: factor out tcp_build_frag()"

 Documentation/networking/ip-sysctl.rst        |   8 -
 .../chelsio/inline_crypto/chtls/chtls.h       |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |   2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  10 +-
 include/net/sock.h                            |  19 ---
 include/net/tcp.h                             |   4 +-
 net/ipv4/af_inet.c                            |   4 -
 net/ipv4/sysctl_net_ipv4.c                    |  12 --
 net/ipv4/tcp.c                                | 147 +++++++-----------
 net/ipv4/tcp_ipv4.c                           |   6 -
 net/ipv6/tcp_ipv6.c                           |   6 -
 net/mptcp/protocol.c                          | 137 +++++++++-------
 12 files changed, 139 insertions(+), 218 deletions(-)

-- 
2.26.3

