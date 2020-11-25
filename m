Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D460E2C3BD0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 10:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgKYJQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 04:16:55 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:13997 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbgKYJQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 04:16:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbe21080001>; Wed, 25 Nov 2020 01:16:56 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 09:16:53 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net v2 2/2] devlink: Make sure devlink instance and port are in same net namespace
Date:   Wed, 25 Nov 2020 11:16:20 +0200
Message-ID: <20201125091620.6781-3-parav@nvidia.com>
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
        t=1606295816; bh=4w59AAqraJ4GdBe93WaSiu/9yugJKU4v1iUI+AkSXmc=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Egpx+tLUxPmxYOOUCXnCyoiI/s1D3uMGOKHQZ0vlXhcbbtGGn6yNdtBVEDJWV0nYK
         sntHn16iB5H0ZDS/MlXC6PKjNYWMdF1y8Wp2HeLO2sFbnnaHaG+DY3hXlLGTBTNc0F
         KrTb6lL/XFot+36fuZx16fQ1plSO8fV6VVTTzTTJ3NOYto/PwYY0y2okf1I3RWQzyb
         dEb4fBwrIKFw23j7vTQnHOiaXVI2wD1NUrHN3az/6hW7g03A/7S2NY9mKc/KacC12n
         MhFf9TdL1CFNfENI7l2FldB+yJwKnrlVnZVvXmI7RZIP3TY4XdNa7qah69u2nLSkCX
         MOGvGbdu+x3Yw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When devlink reload operation is not used, netdev of an Ethernet port may
be present in different net namespace than the net namespace of the
devlink instance.

Ensure that both the devlink instance and devlink port netdev are located
in same net namespace.

Fixes: 070c63f20f6c ("net: devlink: allow to change namespaces during reloa=
d")
Signed-off-by: Parav Pandit <parav@nvidia.com>
---
Changelog:
v1->v2:
 - avoided refactor code from previous patch

---
 net/core/devlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 04ae67bbe19c..28c45be7f1bf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -802,9 +802,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, s=
truct devlink *devlink,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
 	if (devlink_port->type =3D=3D DEVLINK_PORT_TYPE_ETH) {
+		struct net *net =3D devlink_net(devlink_port->devlink);
 		struct net_device *netdev =3D devlink_port->type_dev;
=20
-		if (netdev &&
+		if (netdev && net_eq(net, dev_net(netdev)) &&
 		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
 				 netdev->ifindex) ||
 		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
--=20
2.26.2

