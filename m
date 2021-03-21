Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C574834338F
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhCURCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230094AbhCURBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zXdHoUcjVUJHBfbZEfpNBFQoV8iIM4f14FaBG3Sy6a4=;
        b=BBoYh25FQ7LJdyTHKqyeloxdY1eKni/hmhmwFPpHAHEwu5OXNpEvaPppCeStTN0Ld12orV
        IOkOzcX/XhsxuGoEiqF/UxnxKFV2NLJnKuX62OeUGg/ukWR72nrDNJZ+XMC5JOqVZeW48M
        23K0iapQT4L9bX7HjoJJRsebzUNnXD0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-vtaqVx7ePqy8i8QaVFYGBw-1; Sun, 21 Mar 2021 13:01:43 -0400
X-MC-Unique: vtaqVx7ePqy8i8QaVFYGBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50B7C107ACCD;
        Sun, 21 Mar 2021 17:01:42 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FE766267B;
        Sun, 21 Mar 2021 17:01:40 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 0/8] udp: GRO L4 improvements
Date:   Sun, 21 Mar 2021 18:01:11 +0100
Message-Id: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves the UDP L4 - either 'forward' or 'frag_list' -
co-existence with UDP tunnel GRO, allowing the first to take place
correctly even for encapsulated UDP traffic.

The first for patches are mostly bugfixes, addressing some GRO 
edge-cases when both tunnels and L4 are present, enabled and in use.

The next 3 patches avoid unneeded segmentation when UDP GRO
traffic traverses in the receive path UDP tunnels.

Finally, some self-tests are included, covering the relevant
GRO scenarios.

Even if most patches are actually bugfixes, this series is
targeting net-next, as overall it makes available a new feature.

Paolo Abeni (8):
  udp: fixup csum for GSO receive slow path
  udp: skip fwd/list GRO for tunnel packets
  udp: properly complete L4 GRO over UDP tunnel packet
  udp: never accept GSO_FRAGLIST packets
  vxlan: allow L4 GRO passthrou
  geneve: allow UDP L4 GRO passthrou
  bareudp: allow UDP L4 GRO passthrou
  selftests: net: add UDP GRO forwarding self-tests

 drivers/net/bareudp.c                     |   1 +
 drivers/net/geneve.c                      |   1 +
 drivers/net/vxlan.c                       |   1 +
 include/linux/udp.h                       |  15 +-
 include/net/udp.h                         |  18 ++
 net/ipv4/udp.c                            |  22 +-
 net/ipv4/udp_offload.c                    |  27 ++-
 net/ipv6/udp.c                            |   5 +
 net/ipv6/udp_offload.c                    |   3 +-
 tools/testing/selftests/net/Makefile      |   1 +
 tools/testing/selftests/net/udpgro_fwd.sh | 251 ++++++++++++++++++++++
 11 files changed, 330 insertions(+), 15 deletions(-)
 create mode 100755 tools/testing/selftests/net/udpgro_fwd.sh

-- 
2.26.2

