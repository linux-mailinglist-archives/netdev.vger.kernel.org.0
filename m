Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524912BC43B
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 07:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgKVGNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 01:13:21 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18638 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbgKVGNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 01:13:20 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fba01810000>; Sat, 21 Nov 2020 22:13:21 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 22 Nov
 2020 06:13:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net 1/2] devlink: Hold rtnl lock while reading netdev attributes
Date:   Sun, 22 Nov 2020 08:12:56 +0200
Message-ID: <20201122061257.60425-2-parav@nvidia.com>
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
        t=1606025601; bh=WK47DA5ZA2xv8ag88EpAjwArasehUfzCUddaNASKX0w=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HwiQ8VO6UwBqL/cOo7OlFEIroNjUcTw+/UcgusnuhfFuEghCIadoSOM1uQFplxLLc
         Uy9H43FRXHN0XyczujOI7TkFaIs0vIlP71MFsDoUrnezogOxta1ZA6X5e3ifOAmDT2
         ICBAy55SC0+QWEntcQw8ff9QD4hEc3SA56tH+qUQeebTSMVUURZPfBF2SOfJkGDwfo
         rRxr0yqscz25ujySsQNIXmfZCG+XLEKBx5lmJIZ9JsdEURVphkbrVveR3P+iBAhmnU
         0VX7hlWMKvP1cyzgqgjhbwqaZeWVP9UsZnLaoFoG2fK5PqppINs42P8FU3v3syvfF4
         f9VkvujVYV3qA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A netdevice of a devlink port can be moved to different
net namespace than its parent devlink instance.
This scenario occurs when devlink reload is not used for
maintaining backward compatibility.

When netdevice is undergoing migration to net namespace,
its ifindex and name may change.

In such use case, devlink port query may read stale netdev
attributes.

Fix it by reading them under rtnl lock.

Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 net/core/devlink.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index acc29d5157f4..6135ef5972ce 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -775,6 +775,23 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg=
, struct devlink_port *por
 	return err;
 }
=20
+static int devlink_nl_port_netdev_fill(struct sk_buff *msg, struct devlink=
_port *devlink_port)
+{
+	struct net_device *netdev =3D devlink_port->type_dev;
+	int err;
+
+	ASSERT_RTNL();
+	if (!netdev)
+		return 0;
+
+	err =3D nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX, netdev->ifinde=
x);
+	if (err)
+		goto done;
+	err =3D nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME, netdev->name);
+done:
+	return err;
+}
+
 static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devli=
nk,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid,
@@ -792,6 +809,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
ruct devlink *devlink,
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
 		goto nla_put_failure;
=20
+	/* Hold rtnl lock while accessing port's netdev attributes. */
+	rtnl_lock();
 	spin_lock_bh(&devlink_port->type_lock);
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
 		goto nla_put_failure_type_locked;
@@ -800,13 +819,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, =
struct devlink *devlink,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type =3D=3D DEVLINK_PORT_TYPE_ETH) {
-		struct net_device *netdev =3D devlink_port->type_dev;
+		int err;
=20
-		if (netdev &&
-		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
-				 netdev->ifindex) ||
-		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
-				    netdev->name)))
+		err =3D devlink_nl_port_netdev_fill(msg, devlink_port);
+		if (err)
 			goto nla_put_failure_type_locked;
 	}
 	if (devlink_port->type =3D=3D DEVLINK_PORT_TYPE_IB) {
@@ -818,6 +834,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
ruct devlink *devlink,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
+	rtnl_unlock();
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
@@ -828,6 +845,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
ruct devlink *devlink,
=20
 nla_put_failure_type_locked:
 	spin_unlock_bh(&devlink_port->type_lock);
+	rtnl_unlock();
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
--=20
2.26.2

