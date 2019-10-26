Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D0E5983
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 11:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZJx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 05:53:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34901 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726010AbfJZJxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 05:53:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572083634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oh9Z8CkcDLaJeBNxsDjoQv7FwHNkZK/r3K3tAlMqJcY=;
        b=ArbuxkpZ1kUC6sbsMx37EGyx8lMX5dvpTAcjPAoKuIrHccv6p3Ci3o8HbsmEUMJ2Jl4Ec4
        ukUeJO0FCHhA6ked3UL7AhQfK0SSZK1YNCfM5nJKVcbpAUrYSjvYuDSM4oT2Uznevaa1Dz
        9xyayl8eNtRfEnJBe/LzD2MmRThSD4o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-M1GplxejOF6D-XDlju6Sbg-1; Sat, 26 Oct 2019 05:53:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39C25801E70;
        Sat, 26 Oct 2019 09:53:50 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-60.ams2.redhat.com [10.36.116.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18DD85C1B5;
        Sat, 26 Oct 2019 09:53:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 1/2] ipv4: fix route update on metric change.
Date:   Sat, 26 Oct 2019 11:53:39 +0200
Message-Id: <f49bd3aa34371d8a6296315d0e1ebbd8ec50dec7.1572083332.git.pabeni@redhat.com>
In-Reply-To: <cover.1572083332.git.pabeni@redhat.com>
References: <cover.1572083332.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: M1GplxejOF6D-XDlju6Sbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit af4d768ad28c ("net/ipv4: Add support for specifying metric
of connected routes"), when updating an IP address with a different metric,
the associated connected route is updated, too.

Still, the mentioned commit doesn't handle properly some corner cases:

$ ip addr add dev eth0 192.168.1.0/24
$ ip addr add dev eth0 192.168.2.1/32 peer 192.168.2.2
$ ip addr add dev eth0 192.168.3.1/24
$ ip addr change dev eth0 192.168.1.0/24 metric 10
$ ip addr change dev eth0 192.168.2.1/32 peer 192.168.2.2 metric 10
$ ip addr change dev eth0 192.168.3.1/24 metric 10
$ ip -4 route
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.0
192.168.2.2 dev eth0 proto kernel scope link src 192.168.2.1
192.168.3.0/24 dev eth0 proto kernel scope link src 192.168.2.1 metric 10

Only the last route is correctly updated.

The problem is the current test in fib_modify_prefix_metric():

=09if (!(dev->flags & IFF_UP) ||
=09    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
=09    ipv4_is_zeronet(prefix) ||
=09    prefix =3D=3D ifa->ifa_local || ifa->ifa_prefixlen =3D=3D 32)

Which should be the logical 'not' of the pre-existing test in
fib_add_ifaddr():

=09if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
=09    (prefix !=3D addr || ifa->ifa_prefixlen < 32))

To properly negate the original expression, we need to change the last
logical 'or' to a logical 'and'.

Fixes: af4d768ad28c ("net/ipv4: Add support for specifying metric of connec=
ted routes")
Reported-and-suggested-by: Beniamino Galvani <bgalvani@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index dde77f72e03e..71c78d223dfd 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1148,7 +1148,7 @@ void fib_modify_prefix_metric(struct in_ifaddr *ifa, =
u32 new_metric)
 =09if (!(dev->flags & IFF_UP) ||
 =09    ifa->ifa_flags & (IFA_F_SECONDARY | IFA_F_NOPREFIXROUTE) ||
 =09    ipv4_is_zeronet(prefix) ||
-=09    prefix =3D=3D ifa->ifa_local || ifa->ifa_prefixlen =3D=3D 32)
+=09    (prefix =3D=3D ifa->ifa_local && ifa->ifa_prefixlen =3D=3D 32))
 =09=09return;
=20
 =09/* add the new */
--=20
2.21.0

