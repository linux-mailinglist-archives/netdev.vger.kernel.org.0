Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0D761A5144
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 14:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbgDKMRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 08:17:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgDKMRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CFC420644;
        Sat, 11 Apr 2020 12:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607465;
        bh=ZOZLhi1wgZ1KCiSc5ynZD9XDsGPp6+H9laCsQzK4XIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nziEdpRd3Az0a/8oUzpOxL6b04HNB+1kih3KF9XH8Q4dHflEIKcrVSCsU8rPzHkIy
         BF0Vn3HwzOsUk0EgxfKUbIzw+Cys2HiFsVQECUgFGUZB8Ih/lcuUT6I7ANaJ/8CtOS
         KR6qteJzDussyDhkrdXyDvc35aDPwCx8IRDyR/Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Levi <moshele@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        netdev@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 03/41] ipv6: dont auto-add link-local address to lag ports
Date:   Sat, 11 Apr 2020 14:09:12 +0200
Message-Id: <20200411115504.360628454@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>

[ Upstream commit 744fdc8233f6aa9582ce08a51ca06e59796a3196 ]

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

$ sysctl net.ipv6.conf.ens2f0np0.addr_gen_mode=0
net.ipv6.conf.ens2f0np0.addr_gen_mode = 0
$ sysctl net.ipv6.conf.ens2f1np2.addr_gen_mode=0
net.ipv6.conf.ens2f1np2.addr_gen_mode = 0

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

Fixes: d35a00b8e33d ("net/ipv6: allow sysctl to change link-local address generation mode")
Reported-by: Moshe Levi <moshele@mellanox.com>
CC: Stephen Hemminger <stephen@networkplumber.org>
CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3296,6 +3296,10 @@ static void addrconf_addr_gen(struct ine
 	if (netif_is_l3_master(idev->dev))
 		return;
 
+	/* no link local addresses on devices flagged as slaves */
+	if (idev->dev->flags & IFF_SLAVE)
+		return;
+
 	ipv6_addr_set(&addr, htonl(0xFE800000), 0, 0, 0);
 
 	switch (idev->cnf.addr_gen_mode) {


