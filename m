Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82113197F7B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 17:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgC3PWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 11:22:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:28321 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727255AbgC3PWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 11:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585581765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRom6IvNpMgMUyWIXFy7ykYjVqfYVBjHnLgbEROmr7Y=;
        b=JAynNsaBQVqR0mhChg1qM+I8Aj03UmGub3j8vieApbOTgYUW6XLIRuNsGmNTf7w94XLy07
        tF2kEnrXAaAKZ63/hvcs55ZrQDL86Te+osgMOUHRNd08+GJlih1zp1Iq9bt85oCz2ifJtw
        RG7vgWaqw8i3JYxPJaCdt1Iget2ACMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-AL9jF58FPxaF4ryRWIYmBw-1; Mon, 30 Mar 2020 11:22:42 -0400
X-MC-Unique: AL9jF58FPxaF4ryRWIYmBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076B0800D5E;
        Mon, 30 Mar 2020 15:22:41 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A953019925;
        Mon, 30 Mar 2020 15:22:37 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Moshe Levi <moshele@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH net v2] ipv6: don't auto-add link-local address to lag ports
Date:   Mon, 30 Mar 2020 11:22:19 -0400
Message-Id: <20200330152219.58296-1-jarod@redhat.com>
In-Reply-To: <CAKfmpSd_VQTwxy-gr-jNvQu_CMFf9F2enEjyQC3+W9+Y2WO1Dg@mail.gmail.com>
References: <CAKfmpSd_VQTwxy-gr-jNvQu_CMFf9F2enEjyQC3+W9+Y2WO1Dg@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bonding slave and team port devices should not have link-local addresses
automatically added to them, as it can interfere with openvswitch being
able to properly add tc ingress.

Basic reproducer, courtesy of Marcelo:

$ ip link add name bond0 type bond
$ ip link set dev ens2f0np0 master bond0
$ ip link set dev ens2f1np2 master bond0
$ ip link set dev bond0 up
$ ip a s
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
mq master bond0 state UP group default qlen 1000
    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
mq master bond0 state DOWN group default qlen 1000
    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
11: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc
noqueue state UP group default qlen 1000
    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link
       valid_lft forever preferred_lft forever

(above trimmed to relevant entries, obviously)

$ sysctl net.ipv6.conf.ens2f0np0.addr_gen_mode=3D0
net.ipv6.conf.ens2f0np0.addr_gen_mode =3D 0
$ sysctl net.ipv6.conf.ens2f1np2.addr_gen_mode=3D0
net.ipv6.conf.ens2f1np2.addr_gen_mode =3D 0

$ ip a l ens2f0np0
2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
mq master bond0 state UP group default qlen 1000
    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
       valid_lft forever preferred_lft forever
$ ip a l ens2f1np2
5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
mq master bond0 state DOWN group default qlen 1000
    link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
       valid_lft forever preferred_lft forever

Looks like addrconf_sysctl_addr_gen_mode() bypasses the original "is
this a slave interface?" check added by commit c2edacf80e15, and
results in an address getting added, while w/the proposed patch added,
no address gets added. This simply adds the same gating check to another
code path, and thus should prevent the same devices from erroneously
obtaining an ipv6 link-local address.

Fixes: d35a00b8e33d ("net/ipv6: allow sysctl to change link-local address=
 generation mode")
Reported-by: Moshe Levi <moshele@mellanox.com>
CC: Stephen Hemminger <stephen@networkplumber.org>
CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 net/ipv6/addrconf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 46d614b611db..2a8175de8578 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3296,6 +3296,10 @@ static void addrconf_addr_gen(struct inet6_dev *id=
ev, bool prefix_route)
 	if (netif_is_l3_master(idev->dev))
 		return;
=20
+	/* no link local addresses on devices flagged as slaves */
+	if (idev->dev->flags & IFF_SLAVE)
+		return;
+
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
=20
 	switch (idev->cnf.addr_gen_mode) {
--=20
2.20.1

