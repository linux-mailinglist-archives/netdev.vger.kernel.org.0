Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D48100365
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfKRLCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:02:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726890AbfKRLCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574074951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l6rfiROFeW43GyvP/Cafzt3CsjQ/7ws9jG9UXs7NYj4=;
        b=C/Nyq9o6mewPXJyHq1qqg+HNstQ8Pis1yG7gnGKolImaYmQ0N4kakW18ElkeyFAZrmHdm4
        FN6JCUPmxbrUZKZCwnKPx1+EsJfxNPz1eh3tWeoL8LbiitD2V9C6sLYRWBqJxm+k9S6oUI
        qAoYatjSCCRArDKuWl6jedlIXUmVzMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-2HXXyJrFP4SX8d5CG5s45g-1; Mon, 18 Nov 2019 06:02:29 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76B27108BC52;
        Mon, 18 Nov 2019 11:02:28 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-52.ams2.redhat.com [10.36.117.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C8F65DDAA;
        Mon, 18 Nov 2019 11:02:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next v2 0/2] net: introduce and use route hint
Date:   Mon, 18 Nov 2019 12:01:28 +0100
Message-Id: <cover.1574071944.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 2HXXyJrFP4SX8d5CG5s45g-1
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
messages.

v1 -> v2
 - fix build issue with !CONFIG_IP*_MULTIPLE_TABLES
 - fix potential race in ip6_list_rcv_finish()

Paolo Abeni (2):
  ipv6: introduce and uses route look hints for list input
  ipv4: use dst hint for ipv4 list receive

 include/net/route.h  | 11 +++++++++++
 net/ipv4/ip_input.c  | 38 +++++++++++++++++++++++++++++++++-----
 net/ipv4/route.c     | 38 ++++++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_input.c | 40 ++++++++++++++++++++++++++++++++++++----
 4 files changed, 118 insertions(+), 9 deletions(-)

--=20
2.21.0

