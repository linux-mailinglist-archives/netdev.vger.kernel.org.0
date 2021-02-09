Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A340E315593
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhBISEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:04:01 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12795 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbhBIRxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 12:53:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6022cbe20001>; Tue, 09 Feb 2021 09:52:34 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 17:52:33 +0000
Received: from localhost.localdomain (172.20.145.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb 2021
 17:52:31 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Jian Yang <jianyang.kernel@gmail.com>, <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next] Revert "net-loopback: set lo dev initial state to UP"
Date:   Tue, 9 Feb 2021 18:52:04 +0100
Message-ID: <565e72d78de80b2db767d172691bb4b682c6f4fd.1612893026.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612893154; bh=ngDwYQ995XcPWFUInvTa4qFDqQNpu/4/NY2wK3Abag0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=l7MCItvYdyTTZPJ/ZpukvSZKJJDwD1KzZFtjLSQliqph6xpANZa608bPXxl/EQ5Xf
         4OZRP+HQWAqcZXmj5guGUCN64T1SKEdtQAUpxuD+FxUmG6Xpc6IdafCR3LAq/0gE/E
         Ld2m6NBvRpDzm3QkDaV5F72XzAGEwtDRcp5Mudear7mV8Ne4dzvuuEWrsjwJsqtUCu
         bbEzlrKHzyJ60VkKGrIBEJroi+YByTZJHvvjV/2X6E98EY5YSqNk323gpcp1+GBwg7
         12U9AChwSb8aGgrnnadaJ3xni/DugDJ5pdGvJGeLEI73KUzK08tUIzo6As82/uNc3F
         f3YvMbqT/TvOA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c9dca822c729 ("net-loopback: set lo dev initial state to UP"),
linux started automatically bringing up the loopback device of a newly
created namespace. However, an existing user script might reasonably have
the following stanza when creating a new namespace -- and in fact at least
tools/testing/selftests/net/fib_nexthops.sh in Linux's very own testsuite
does:

 # set -e
 # ip netns add foo
 # ip -netns foo addr add 127.0.0.1/8 dev lo
 # ip -netns foo link set lo up
 # set +e

This will now fail, because the kernel reasonably rejects "ip addr add" of
a duplicate address. The described change of behavior therefore constitutes
a breakage. Revert it.

Fixes: c9dca822c729 ("net-loopback: set lo dev initial state to UP")
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/loopback.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 24487ec17f8b..a1c77cc00416 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -219,12 +219,6 @@ static __net_init int loopback_net_init(struct net *ne=
t)
=20
 	BUG_ON(dev->ifindex !=3D LOOPBACK_IFINDEX);
 	net->loopback_dev =3D dev;
-
-	/* bring loopback device UP */
-	rtnl_lock();
-	dev_open(dev, NULL);
-	rtnl_unlock();
-
 	return 0;
=20
 out_free_netdev:
--=20
2.26.2

