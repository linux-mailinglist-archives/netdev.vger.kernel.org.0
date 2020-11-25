Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB352C3BCF
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgKYJQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:16:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6703 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgKYJQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 04:16:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe21050000>; Wed, 25 Nov 2020 01:16:53 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 09:16:52 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net v2 1/2] devlink: Hold rtnl lock while reading netdev attributes
Date:   Wed, 25 Nov 2020 11:16:19 +0200
Message-ID: <20201125091620.6781-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201125091620.6781-1-parav@nvidia.com>
References: <20201122061257.60425-3-parav@nvidia.com>
 <20201125091620.6781-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606295813; bh=xdvq/95jdyMMniYGD/4mEKAG8emco+ivwY+KlhCpUw0=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=rbZgomLR5IskFiggbuU+KZquzNohCryHTSTIEu68Ah/n6duQPGYolkrMsB6OtquMt
         l2QX1QGnpP5lS0EEecyGjcE5s/7gcGlnIEPUl3Cm9Xf8IS9FZ7RgNVaYHQqLYzYiil
         yO9g1/3ZkOdnF1bcPj/FlvTtXZc+ZuG//HTCqVSt4PJ5Wnio5qEzpCQWxBNxadI9In
         9xR4mB99PSr5lgJmLfAPfaCiaRDD1EBWX0U1nVGkxgh0Hve0yCO4SxKtTLC2ozgGe/
         WJr9mI6YPoyGXywWegQiMdV00CMq8jeC+y2LaO+97yxHZnMK1LaCpm6PiGnB031sE8
         1lghQRCJLSdaQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A netdevice of a devlink port can be moved to different net namespace
than its parent devlink instance.
This scenario occurs when devlink reload is not used.

When netdevice is undergoing migration to net namespace, its ifindex
and name may change.

In such use case, devlink port query may read stale netdev attributes.

Fix it by reading them under rtnl lock.

Fixes: bfcd3a466172 ("Introduce devlink infrastructure")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
Changelog:
v1->v2:
 - avoided refactoring the code
 - updated commit log

---
 net/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index acc29d5157f4..04ae67bbe19c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -792,6 +792,8 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
ruct devlink *devlink,
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX, devlink_port->index))
 		goto nla_put_failure;
=20
+	/* Hold rtnl lock while accessing port's netdev attributes. */
+	rtnl_lock();
 	spin_lock_bh(&devlink_port->type_lock);
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
 		goto nla_put_failure_type_locked;
@@ -818,6 +820,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
ruct devlink *devlink,
 			goto nla_put_failure_type_locked;
 	}
 	spin_unlock_bh(&devlink_port->type_lock);
+	rtnl_unlock();
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
@@ -828,6 +831,7 @@ static int devlink_nl_port_fill(struct sk_buff *msg, st=
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

