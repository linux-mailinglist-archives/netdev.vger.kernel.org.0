Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF92BC43C
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 07:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgKVGNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 01:13:23 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:12348 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727244AbgKVGNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 01:13:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fba01850000>; Sat, 21 Nov 2020 22:13:25 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Nov
 2020 06:13:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net 2/2] devlink: Make sure devlink instance and port are in same net namespace
Date:   Sun, 22 Nov 2020 08:12:57 +0200
Message-ID: <20201122061257.60425-3-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201122061257.60425-1-parav@nvidia.com>
References: <20201122061257.60425-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606025605; bh=qgj8One1flKFQT3LHMU1kEEYHriQyZLqZ3Zv63F7LWo=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=MaxNNAF2CG/4uSB0ZjYSIFHhMb7MDmPWObNd1xKGgTGS92wcBJ7aHIadrFxQlbO2U
         s48eUgGLx/AWQ+4/b9Kq3aEsBokY+mBbq4cBcAVdRIe73ZIIMl6jmb9EY/pW3aOb35
         1nyXXyqvuNDblWRC5HyqFW9T16odAzY6q9RpRrmr2A3JW0YuCby8AUI03G5v3Xoxh7
         HJqIGjBapxiQ/x7MbXr7zhX2NgSPmia69lSuMOgndGO7eoMuNWykf6VcY8emeO9tKY
         M1jfnxdeWMjgw3o0JVVYWc2AVahWTDD6YBeMireQbZ7ITrihxIEh3cE1CEvctO3k5P
         8OWiT2CuGEXrw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devlink reload operation is not used, netdev of an Ethernet port
may be present in different net namespace than the net namespace of the
devlink instance.

Ensure that both the devlink instance and devlink port netdev are
located in same net namespace.

Fixes: 070c63f20f6c ("net: devlink: allow to change namespaces during reloa=
d")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 net/core/devlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6135ef5972ce..2e1b0e82a102 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -778,12 +778,15 @@ devlink_nl_port_function_attrs_put(struct sk_buff *ms=
g, struct devlink_port *por
 static int devlink_nl_port_netdev_fill(struct sk_buff *msg, struct devlink=
_port *devlink_port)
 {
 	struct net_device *netdev =3D devlink_port->type_dev;
-	int err;
+	int err =3D 0;
=20
 	ASSERT_RTNL();
 	if (!netdev)
 		return 0;
=20
+	if (!net_eq(devlink_net(devlink_port->devlink), dev_net(netdev)))
+		goto done;
+
 	err =3D nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX, netdev->ifinde=
x);
 	if (err)
 		goto done;
--=20
2.26.2

