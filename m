Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2BC1026F7
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKSOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:39:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727560AbfKSOjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574174361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JLgou/Q7yZxSLAkA4OThao6eG9mLgBLuu5O/0sV8BvU=;
        b=efa8Jhhtk+hsuMNOjPfRwBr2Ys8rGhzG2OL2JgnN8UD5ua2gnc9QVe4yeXRcCEiqKa599j
        ri7fkgWXcFn/DtHOt40gP+XZmAB3xPCBPW4qPHdAOVePxbeg59AyDJGoQN/hC1ZGxRZTQk
        iZU9aUygOB/mQgAarZiSjlgAjLpXnUU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-uu8Z3swSObO3MM1sZqi0Pw-1; Tue, 19 Nov 2019 09:39:18 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D27B1098107;
        Tue, 19 Nov 2019 14:39:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-12.ams2.redhat.com [10.36.117.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E02F56058D;
        Tue, 19 Nov 2019 14:39:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next v3 0/2] net: introduce and use route hint
Date:   Tue, 19 Nov 2019 15:38:35 +0100
Message-Id: <cover.1574165644.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: uu8Z3swSObO3MM1sZqi0Pw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series leverages the listification infrastructure to avoid
unnecessary route lookup on ingress packets. In absence of policy routing,
packets with equal daddr will usually land on the same dst.

When processing packet bursts (lists) we can easily reference the previous
dst entry. When we hit the 'same destination' condition we can avoid the
route lookup, coping the already available dst.

Detailed performance numbers are available in the individual commit
messages. Figures are slightly better then previous iteration because
thanks to Willem's suggestion we additionally skip early demux when using
the route hint.

v2 -> v3:
 - use fib*_has_custom_rules() helpers (David A.)
 - add ip*_extract_route_hint() helper (Edward C.)
 - use prev skb as hint instead of copying data (Willem )

v1 -> v2:
 - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
 - fix potential race in ip6_list_rcv_finish()

Paolo Abeni (2):
  ipv6: introduce and uses route look hints for list input
  ipv4: use dst hint for ipv4 list receive

 include/net/ip6_fib.h   |  9 +++++++++
 include/net/ip_fib.h    | 10 ++++++++++
 include/net/route.h     |  4 ++++
 net/ipv4/fib_frontend.c | 10 ----------
 net/ipv4/ip_input.c     | 35 +++++++++++++++++++++++++++++++----
 net/ipv4/route.c        | 37 +++++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_input.c    | 26 ++++++++++++++++++++++++--
 7 files changed, 115 insertions(+), 16 deletions(-)

--=20
2.21.0

