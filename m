Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88300103A4C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfKTMsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:48:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27037 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727656AbfKTMsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574254083;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=F7ta0kyYo+Bc9cUbj+adNG4UJ4gZihsZ/D3qwidEAc4=;
        b=R5pEDN/UbDwZNXh1xm3Z8jH/MzjQybxIcRxI0CM4sfbHyidYK8cu4CwJqmQ62yQHo3PM2p
        OAPx3hjyxXQbfbt5HamFj8xnj4MEzYN1MNpZOFRdv6UKYWU6QxUx7UChgoRmglwr5Xuwc9
        r3cb6ogHfOvX5d8JcbOVtBXtVDuQ6w0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-LuIf7jH_NJ6VZqoR4RrLXg-1; Wed, 20 Nov 2019 07:47:59 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E217107B789;
        Wed, 20 Nov 2019 12:47:58 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-23.ams2.redhat.com [10.36.117.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D74F32CA76;
        Wed, 20 Nov 2019 12:47:56 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next v4 0/5] net: introduce and use route hint
Date:   Wed, 20 Nov 2019 13:47:32 +0100
Message-Id: <cover.1574252982.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: LuIf7jH_NJ6VZqoR4RrLXg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series leverages the listification infrastructure to avoid
unnecessary route lookup on ingress packets. In absence of custom rules,
packets with equal daddr will usually land on the same dst.

When processing packet bursts (lists) we can easily reference the previous
dst entry. When we hit the 'same destination' condition we can avoid the
route lookup, coping the already available dst.

Detailed performance numbers are available in the individual commit
messages.

v3 -> v4:
 - move helpers to their own patches (Eric D.)
 - enable hints for SUBTREE builds (David A.)
 - re-enable hints for ipv4 forward (David A.)

v2 -> v3:
 - use fib*_has_custom_rules() helpers (David A.)
 - add ip*_extract_route_hint() helper (Edward C.)
 - use prev skb as hint instead of copying data (Willem )

v1 -> v2:
 - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
 - fix potential race in ip6_list_rcv_finish()

Paolo Abeni (5):
  ipv6: add fib6_has_custom_rules() helper
  ipv6: keep track of routes using src
  ipv6: introduce and uses route look hints for list input.
  ipv4: move fib4_has_custom_rules() helper to public header
  ipv4: use dst hint for ipv4 list receive

 include/net/ip6_fib.h    | 39 +++++++++++++++++++++++++++++++++++++
 include/net/ip_fib.h     | 10 ++++++++++
 include/net/netns/ipv6.h |  3 +++
 include/net/route.h      |  4 ++++
 net/ipv4/fib_frontend.c  | 10 ----------
 net/ipv4/ip_input.c      | 35 +++++++++++++++++++++++++++++----
 net/ipv4/route.c         | 42 ++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_fib.c       |  4 ++++
 net/ipv6/ip6_input.c     | 26 +++++++++++++++++++++++--
 net/ipv6/route.c         |  3 +++
 10 files changed, 160 insertions(+), 16 deletions(-)

--=20
2.21.0

