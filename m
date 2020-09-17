Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB4126D656
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgIQIXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:23:01 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1664 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgIQIW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:22:57 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f631b820000>; Thu, 17 Sep 2020 01:17:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 01:17:49 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 01:17:49 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 08:17:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/8] devlink: Prepare code to fill multiple port function attributes
Date:   Thu, 17 Sep 2020 11:17:26 +0300
Message-ID: <20200917081731.8363-4-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917081731.8363-1-parav@nvidia.com>
References: <20200917081731.8363-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600330626; bh=wdfLzZOZMJtp/ZqF6MO+GBRLjYMAiW+DHTHVJy6JAqI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=H1kXQdtiZIq0MXs+gpyFwb5EK/UgGWSIr/yFx5j2bdYer7eZX336VVfb2j+/uHbyA
         ldmbqF3PDV+muYvm48OUof7siEeHb2kmVvGN044FO7saoSCAO7TT/B3MWJhhTjtdSE
         ItDIw8AoBMxlYf4wGz6gxJ+xL//JR8JLAfJXmx7cSroBmPbXW7eIGBg9Usq+8ek05q
         E/Odi4iqJqmtlsNYn+QxRb9FHdE13mifffArVY3RXRxX4TQz1J4kyOdUb8YO0yeQV1
         41Nz4AYgFG6NnX9rm7qsi4IGQI9wnsciRk5HfSbA9tFIEJkT16heXAytJsP/JJ0f80
         P1T/AzwNpGy0g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare code to fill zero or more port function optional attributes.
Subsequent patch makes use of this to fill more port function
attributes.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 53 +++++++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e93730065c57..d152489e48da 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -570,6 +570,31 @@ static int devlink_nl_port_attrs_put(struct sk_buff *m=
sg,
 	return 0;
 }
=20
+static int
+devlink_port_function_hw_addr_fill(struct devlink *devlink, const struct d=
evlink_ops *ops,
+				   struct devlink_port *port, struct sk_buff *msg,
+				   struct netlink_ext_ack *extack, bool *msg_updated)
+{
+	u8 hw_addr[MAX_ADDR_LEN];
+	int hw_addr_len;
+	int err;
+
+	if (!ops->port_function_hw_addr_get)
+		return 0;
+
+	err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_l=
en, extack);
+	if (err) {
+		if (err =3D=3D -EOPNOTSUPP)
+			return 0;
+		return err;
+	}
+	err =3D nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw_=
addr);
+	if (err)
+		return err;
+	*msg_updated =3D true;
+	return 0;
+}
+
 static int
 devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_por=
t *port,
 				   struct netlink_ext_ack *extack)
@@ -577,36 +602,16 @@ devlink_nl_port_function_attrs_put(struct sk_buff *ms=
g, struct devlink_port *por
 	struct devlink *devlink =3D port->devlink;
 	const struct devlink_ops *ops;
 	struct nlattr *function_attr;
-	bool empty_nest =3D true;
-	int err =3D 0;
+	bool msg_updated =3D false;
+	int err;
=20
 	function_attr =3D nla_nest_start_noflag(msg, DEVLINK_ATTR_PORT_FUNCTION);
 	if (!function_attr)
 		return -EMSGSIZE;
=20
 	ops =3D devlink->ops;
-	if (ops->port_function_hw_addr_get) {
-		int hw_addr_len;
-		u8 hw_addr[MAX_ADDR_LEN];
-
-		err =3D ops->port_function_hw_addr_get(devlink, port, hw_addr, &hw_addr_=
len, extack);
-		if (err =3D=3D -EOPNOTSUPP) {
-			/* Port function attributes are optional for a port. If port doesn't
-			 * support function attribute, returning -EOPNOTSUPP is not an error.
-			 */
-			err =3D 0;
-			goto out;
-		} else if (err) {
-			goto out;
-		}
-		err =3D nla_put(msg, DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR, hw_addr_len, hw=
_addr);
-		if (err)
-			goto out;
-		empty_nest =3D false;
-	}
-
-out:
-	if (err || empty_nest)
+	err =3D devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extac=
k, &msg_updated);
+	if (err || !msg_updated)
 		nla_nest_cancel(msg, function_attr);
 	else
 		nla_nest_end(msg, function_attr);
--=20
2.26.2

